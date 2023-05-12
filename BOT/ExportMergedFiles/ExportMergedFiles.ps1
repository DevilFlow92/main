############################ PANNELLO DI CONTROLLO ########################################

$Test = 0 # = 1 se devo farlo girare in ambiente di test, = 0 se deve girare in produzione

$locale = 1 # = 1 se lo script gira sulla mia macchina, = 0 se deve girare su server

###########################################################################################


Clear-Host
$Error.Clear()
$ErrorActionPreference="Continue"
$MessaggioErrore = $null

$jsonPath = $($MyInvocation.MyCommand.path) -replace "ps1", "json"

$conf=gc $jsonPath | Out-String | ConvertFrom-Json -Verbose


if($test -eq 1){

$urlbase = $conf.WebAPI.urlTest
$user = $conf.WebAPI.userTest
$Password = $conf.WebAPI.pwdTest

}else{

$urlbase = $conf.WebAPI.url
$User = $conf.WebAPI.user
$Password = $conf.WebAPI.pwd

}

if($locale -eq 1){
$dll = $conf.itextsharp.dllpathLocale
}else{
$dll = $conf.itextsharp.dllpath
}

function Merge-pdf(){
    [CmdletBinding()]
    param(
        [string]$workingDirectory,
        [string]$fileOutPut
    )
    <#
    [void] [System.Reflection.Assembly]::LoadFrom(
        [System.IO.Path]::Combine($workingDirectory, 'itextsharp.dll')

    );#>
    [void] [System.Reflection.Assembly]::LoadFrom($dll)
    $pdfs = ls $workingDirectory -recurse | where {-not $_.PSIsContainer -and $_.Extension -imatch "^\.pdf$"};
    $output = $fileOutPut
    $fileStream = New-Object System.IO.FileStream($output, [System.IO.FileMode]::OpenOrCreate);
    $document = New-Object iTextSharp.text.Document;
    $pdfCopy = New-Object iTextSharp.text.pdf.PdfCopy($document, $fileStream);
    $document.Open();
    [iTextSharp.text.pdf.PdfReader]::unethicalreading=$true
    foreach ($pdf in $pdfs) {
        Write-Verbose "Adding pdf $($pdf.name) into $fileOutPut"
        $reader = New-Object iTextSharp.text.pdf.PdfReader($pdf.FullName);
        
        $pdfCopy.AddDocument($reader);
        $reader.Dispose();  
    }

    $pdfCopy.Dispose();
    $document.Dispose();
    $fileStream.Dispose();
}



Import-Module PSSqlQuery

#load winscp .NET assembly

if($locale -eq 1){
Add-type -Path $($conf.WinScp.dllpathLocale)
}else{
Add-type -Path $($conf.WinScp.dllpath)

}

#session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = $($conf.sftp.hostname)
        UserName = $($conf.sftp.username)
        Password = $($conf.sftp.password)
        SshHostKeyFingerprint = $($conf.sftp.fingerprint)
    }

$VerbosePreference="continue"
$query=@"

SELECT documento_id,
		idincarico,
		chiavecliente,
		codtipoincarico,
		descrizioneincarico,
		tipo_documento,
		nomefile_input,
		idrepository,
		percorsocompleto,
		NamingCartellaZip,
        progressivoZip,
		nomedocumentopdf,
		StringaCSV,
		FlagUpload,
		DataUpload,
		DescrizioneKO,
        NumeroMandato
  FROM [export].[CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture] t
  WHERE t.FlagUpload = 0 
  AND t.NamingCartellaZip like 'AZISF_%'
  
"@

$mailBody=""
$mailSubject=""

$mailFrom=$($conf.mailing.from)
$mailTo=$($conf.mailing.to)
$mailCC=$($conf.mailing.cc)
$mailSmtp=$($conf.mailing.smtp)

$s=([guid]::NewGuid()).Guid

$scratchDir="$env:temp\export_ICBPI_AZISF\$s"
if (Test-Path "$env:temp\export_ICBPI_AZISF"){
    Remove-Item "$env:temp\export_ICBPI_AZISF" -Recurse -Force
}
if (-not (Test-Path $scratchDir)){
    mkdir $scratchDir | Out-Null
}


try{


    $preSP="EXEC export.CESAM_AZ_Documenti_PREVINET_AZISF"
    $updateQuery="Update [export].[CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture] set FlagUpload=@FlagUpload, DataUpload=getdate() where documento_id =@ID and NamingCartellaZip = @NomeZip AND ProgressivoZip = @ProgressivoZip"
    
    # sql connection dotNet
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection

    if($test -eq 1){    
    $sqlConn= Connect-SQLServer -Istance $conf.SQLConnection.istanzaTest -Database $conf.SQLConnection.database
    $SqlConnection.ConnectionString = "Server=$($conf.SQLConnection.istanzaTest);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes;"

    }else{
    $sqlConn=Connect-SQLServer -Istance $conf.SQLConnection.istanza -Database $conf.SQLConnection.database
    $SqlConnection.ConnectionString = "Server=$($conf.SQLConnection.istanzaProdDotNet);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes;"
    }
    Write-Host "executing $preSP"
    
    

    $MioDataSet = New-Object System.Data.DataSet
    $SqlConnection.Open()
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $SqlCmd.CommandTimeout = 300
    #eseguo la query
    $SqlCmd.CommandText = $preSP
    $SqlCmd.Connection = $SqlConnection
    $SqlCmd.ExecuteNonQuery() 
    $SqlConnection.Close()


    $records=Invoke-SQLQuery -query $query -Connection $sqlConn

         # autenticazione api
    $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
    $headerToken =Invoke-RestMethod –Uri "$urlBase/Autenticazione/NomeHeaderTokenSessione"
    $credenziali = @{ Username = $User; Password = $Password} | ConvertTo-Json
    $token = Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "$urlBase/Autenticazione/Autentica" -Body $credenziali
    $headers = @{"$headerToken" = $token }
    $sessione = Invoke-RestMethod -ContentType "application/json" -Method Get -Uri "$urlBase/Autenticazione/Sessione" -Headers $headers
       

    foreach ($r in $records){
        $workdir = $null
        $workdir="$scratchDir\$($r.NamingCartellaZip)_$($r.progressivoZip)\$($r.nomedocumentopdf)"
        if (-not (Test-Path $workdir)){
            mkdir $workdir |Out-Null
        }

            $filePath = "$workdir/$($r.nomefile_input).pdf"
           
            # download file from qtask
            $servicePoint.CloseConnectionGroup("")
            $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)

            Invoke-RestMethod -ContentType "application/json" -Method GET -Uri "$urlBase/Incarico/$($r.idincarico)/Documento/$($r.documento_id)/contenuto" -Headers $headers -OutFile $filePath
            
        Write-Verbose $workdir
    }
    dir $scratchDir -Directory | % {
        pushd $($_.FullName)
        $pdfs=dir -Directory
        foreach ($d in $pdfs){
           $outputPdf="$($d.FullName).pdf"
           Write-Verbose $outputPdf
           Merge-pdf -workingDirectory $d.FullName -fileOutPut $outputPdf
           Remove-Item $d.FullName -Recurse
        }
        popd 
    }

    $txtname="indice.txt"
    $records | select NamingCartellaZip, progressivoZip,StringaCSV -Unique | % { Out-File -InputObject $($_.StringaCSV) -FilePath "$scratchDir\$($_.NamingCartellaZip)_$($_.progressivoZip)\$txtname" -Append -Encoding ascii }

    Add-Type -assembly "system.io.compression.filesystem"
    dir $scratchDir -Directory | %{
        [io.compression.zipfile]::CreateFromDirectory($($_.FullName), "$($_.FullName).zip") 
        Remove-Item $($_.FullName) -Recurse
    }
    

    
    #connect winscp
    $session = New-Object WinSCP.Session
    $session.open($sessionOptions)   


    dir $scratchDir -File -Filter "*.zip" | %{
        Write-Verbose "Sending $($_.FullName) to $($conf.sftp.remotePath)/$($_.Name)"
            $sftpRemoteBase=  $null
            $sftpRemoteBase = "$($conf.sftp.remotePath)/$($_.Name)"
         $session.PutFiles($($_.FullName), $sftpRemoteBase).Check()
    }
  

    $trn=$null
    
    $trn=Start-SQLTransaction -Connection $sqlConn
    $records | % {
        Invoke-SQLNonQuery -query $updateQuery -parameters @(New-SQLParameter -name FlagUpload -value 1 -dbtype Bit
        ; New-SQLParameter -name Id -value $($_.documento_id) -dbtype Int
        ; New-SQLParameter -name NomeZip -value $($_.NamingCartellaZip) -dbtype VarChar
        ; New-SQLParameter -name ProgressivoZip -value $($_.progressivoZip) -dbtype Int
        ) -Connection $sqlConn -Transaction $trn
    }
    Stop-SQLTransaction -transaction $trn -action Commit
   
    $mailSubject="[Success] - Export Azimut Previnet Fondo AZISF"
    $mailBody=@"
I file relatvi all'export verso Previnet Fondo AZISF sono stati traferiti con successo sull'sftp $sftpServer`:$sftpPort$sftpRemoteBase.

Server: $env:COMPUTERNAME
ScriptPath: $($MyInvocation.MyCommand.Definition)
"@

}catch{
popd
    $d = if([string]::IsNullOrEmpty($d)){"errore"}else{$d}
    Write-Warning $d
    $messaggio=$Error[0]
    if ($trn -ne $null){
        Stop-SQLTransaction -transaction $trn -action Rollback
    }
    $mailSubject="[Error] - Export Azimut Previnet Fondo AZISF"
    $mailBody=@"
Si è verificato un errore nel trasferimento dei file Azimut verso Previnet Fondo AZISF verso il server $sftpServer`:$sftpPort$sftpRemoteBase.
L'errore riportato è:
$messaggio
$Error

Server: $env:COMPUTERNAME
ScriptPath: $($MyInvocation.MyCommand.Definition)
"@
}finally{
    $session.Close()
    Send-MailMessage -Body $mailBody -Subject $mailSubject -To $mailTo -cc $mailCC -From $mailFrom -Encoding utf8 -SmtpServer $mailSmtp
    if (Test-Path $scratchDir){
       Remove-Item $scratchDir -Recurse -Force
    }

    Write-Host $mailSubject -ForegroundColor DarkGreen
    Write-Host $mailBody -ForegroundColor Green
}



$scratchDir