
$Error.Clear()

$test = 0
$mandamail = 0

$jsonPath = $($MyInvocation.MyCommand.path) -replace "ps1", "json"
#$jsonPath = "C:\ScriptAdminRoot\Modify\PS_Script\CESAM_AZ_Import_Rendicontazione.json"

$conf = Get-Content $jsonPath | Out-String | ConvertFrom-Json -Verbose


$date = get-date -format yyyyMMdd
$date2 = get-date -format yyyyMMdd
$date_lag = '{0:yyyyMMdd}' -f [datetime](get-date).AddDays(-1)


if((get-date).DayOfWeek -eq "Monday"){
    $date = '{0:yyyyMMdd}' -f [datetime](Get-Date).AddDays(-2)
    $date2 = '{0:yyyyMMdd}' -f [datetime](get-date).AddDays(-1)
    $date_lag = '{0:yyMMdd}' -f [datetime](Get-Date).AddDays(-3)
}


$getAnno = [int] $(Get-Date -Format "yyyy")

$csvlogfile = "$(Split-Path $($MyInvocation.MyCommand.path))\LISTE\$($Date)_ImportResults.csv"

Get-Module -Name PSSQLQuery | ForEach-Object { Remove-Module -Name $_.Name }
Import-Module PSSQLQuery

#load winscp .NET assembly
Add-type -Path $($conf.WinScp.dllpath)

#session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol              = [WinSCP.Protocol]::Sftp
    HostName              = $($conf.sftp.hostname)
    UserName              = $($conf.sftp.username)
    Password              = $($conf.sftp.password)
    SshHostKeyFingerprint = $($conf.sftp.fingerprint)
}


# web-api config
if ($test -eq 0) {
    $user = $($conf.WebAPI.user)
    $Password = $($conf.WebAPI.pwd)
    $urlBase = $($conf.WebAPI.url)
    $URI = $($conf.webservice.uri)
    $url = $($conf.webservice.url)
}
else {
    $user = $($conf.WebAPI.userTest)
    $Password = $($conf.WebAPI.pwdTest)
    $urlBase = $($conf.WebAPI.urlTest)
    $URI = $($conf.webservice.uriTest)
    $url = $($conf.webservice.urlTest)
}

$CodCliente = $($conf.WebAPI.codCliente)
$CodTipoIncarico = $($conf.WebAPI.codTipoIncarico)
$CodArea = $($conf.WebAPI.codArea)
$chiavecliente = $($conf.WebAPI.chiaveCliente)


# sql query
$VerbosePreference = "continue"
$qSelect = @"
SELECT IdImport_RendicontazioneBP,
		DataContabile_61,
		ABI,
		CAB,
        CodBanca,
		Conto,
		IdContoBancario,
		IdContoBancarioPerAnno,
		DescrizioneConto,
		SaldoInizialeSegno,
		SaldoContabileSegno,
		SaldoLiquidoSegno,
        CodDivisa,
		Divisa,
		ProgressivoOperazione,
		DataOperazione,
		DataValuta,
		Entrate,
		Uscite,
        IdOperazioneContoBancario,
		Causale,
		RiferimentoCliente_62,
		DescrizioneOperazione,
		SegnoSaldoIniziale,
		SaldoIniziale,
		SegnoSaldoContabile,
		SaldoContabile,
		SegnoSaldoLiquido,
		SaldoLiquido,
		SegnoMovimento,
		ImportoMovimento,
        /* LF 2020-12-21 AGGIUNTO CAMPO IBANORDINANTE */
        IbanOrdinante

FROM rs.v_CESAM_AZ_Rendicontazione_BancoPopolare_Raggruppa --where IdImport_RendicontazioneBP = @IdImport_RendicontazioneBP

"@

$qInserisciConto = @"
EXEC orga.Inserisci_ContoRendicontazione	@NomeConto = @Nome,
											@NumeroConto = @Numero,
											@CodBancaVD = @Banca,
										    @CodValuta = @Valuta,
                                            @FlagFittizio = @Fittizio,
								            @CodTipoContoBancario = @CodTipoConto,
                                            @Abi = @CodAbi,
                                            @Cab = @CodCab,
                                            @IdIncarico = @Incarico,
                                            @IdContoBancario = @ContoBancario,
											@Anno = @NumeroAnno							
"@

$qInserisciOperazione = @"
EXEC orga.Inserisci_OperazioneRendicontazione	@RiferimentoCliente_62 = @DescrizioneCausale,
												@SegnoImporto = @SegnoCausale,
												@CodiceCausale = @CodiceCausale

"@

$qInserisciOperazioneSetup = @"
EXEC orga.Inserisci_OperazioneRendicontazione	@RiferimentoCliente_62 = @DescrizioneCausaleSetup,
												@SegnoImporto = @SegnoCausaleSetup,
												@CodiceCausale = @CodiceCausaleSetup

"@

#LF 2020-12-21 INSERITO PARAMETRO IBAN ORDINANTE SU SP
$qInserisciMovimento = @"
EXEC orga.Inserisci_MovimentoContoBancario	@DescrizioneMovimento = @Descrizione,
											@IdContoBancarioPerAnno = @IdContoPerAnno,
											@DataValuta = @DataVal,
											@DataOperazione = @DataOp,
											@IdOperazioneContoBancario = @IdOperazione,
											@Importo = @Importo,
                                            @IdImport_Rendicontazione = @IdImport,
                                            @IbanOrdinante = @Iban

"@

# scratch directory
$scratchname = $($conf.ScratchName)
$scratchDir = "$env:TEMP\$scratchname"
if (-not (Test-Path $scratchDir)) {
    mkdir $scratchDir | Out-Null
}

try {
    $MessaggioErrore = ""
    $FileElaboration = ""
    
    #connect winscp
    $session = New-Object WinSCP.Session
    $session.open($sessionOptions)


    # autenticate web-api
    $headerToken = Invoke-RestMethod –Uri "$urlBase/Autenticazione/NomeHeaderTokenSessione" -Verbose
    $credenziali = @{ Username = $User; Password = $Password } | ConvertTo-Json
    $token = Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "$urlBase/Autenticazione/Autentica" -Body $credenziali
    $headers = @{"$headerToken" = $token }
    $sessione = Invoke-RestMethod -ContentType "application/json" -Method Get -Uri "$urlBase/Autenticazione/Sessione" -Headers $headers
    if ($test -eq 0) { 
        # connect sql   
        $connSetup = Connect-SQLServer -Istance $($conf.SQLConnection.istanzaSetup) -Database $($conf.SQLConnection.database)  -TimeOut 20000
        $conn = Connect-SQLServer -Istance $($conf.SQLConnection.istanza) -Database $($conf.SQLConnection.database) -TimeOut 20000
    }
    else {
        $connSetup = Connect-SQLServer -Istance $($conf.SQLConnection.istanzaSetup) -Database $($conf.SQLConnection.database)  -TimeOut 20000
        $conn = Connect-SQLServer -Istance $($conf.SQLConnection.istanzaTest) -Database $($conf.SQLConnection.database) -TimeOut 20000
    }
           
    # connessione a sql

    if ($test -eq 0) {
        $StringaConnessione = "Server=$($conf.SQLConnection.istanza);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
        $ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
        $Comando = New-Object System.Data.SqlClient.SqlCommand 
    }
    else {
        $StringaConnessione = "Server=$($conf.SQLConnection.istanzaTest);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
        $ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
        $Comando = New-Object System.Data.SqlClient.SqlCommand 
    }

    $tempImport = @()
    $tempImport = New-Object System.Data.DataTable
    $column1 = New-Object System.Data.DataColumn "NomeFile", ([STRING])
    $tempImport.Columns.Add($column1)    
    $column2 = New-Object System.Data.DataColumn "EsitoElaborazione", ([STRING])
    $tempImport.Columns.Add($column2)
    $column3 = New-Object System.Data.DataColumn "Errore", ([STRING])
    $tempImport.Columns.Add($column3)
            
    # Get list of files in the directory
    $directoryInfo = $session.ListDirectory($($conf.sftp.remotePath))

    # Select the most recent file from sftp
    $latest = $directoryInfo.Files | Where-Object { -Not $_.IsDirectory -and ($_.Name -match $date -or $_.Name -match $date2 -or ($_.Name -match $date_lag -and $_.Name -match "holazi")) } | Sort-Object LastWriteTime -Descending | Select-Object #-First 2
      
    # Any file at all?
    if ($latest -eq $Null) {
        # get list of files in the elab directory
        $ElabDir = $session.ListDirectory($($conf.sftp.elabPath))
        $latestElab = $ElabDir.Files | Where-Object { -Not $_.IsDirectory -and ($_.Name -match $date -or $_.Name -match $date2 -or ($_.Name -match $date_lag -and $_.Name -match "holazi")) } | Sort-Object LastWriteTime -Descending | Select-Object -First 1

        if ($latestElab -ne $Null) {
            $FileElaboration = "All files already Elab!"
        }
        else {
            $FileElaboration = "No file found"
        }        
        
    }
    else {    
        # webservice conn
        $Proxy = New-WebserviceProxy $URI –Namespace X 
        #$Proxy | get-member -MemberType MEthod
        $Proxy.timeout = 2000000
        $proxy.url = $url     

        foreach ($l in $latest) {
            $latestCsv = $Null
            $latestCsvName = $Null            

            $latestCsv = $l.FullName 
            $latestCsvName = $l.Name 
    
            #Download the selected file
            Write-Host ("downloading {0} ..." -f $($latestCsv))
            $session.GetFiles($session.EscapeFileMask($latestCsv), $scratchDir).Check() 
            $importedfilepath = $Null
            $importedfilepath = $scratchDir + $latestCsvName

            write-host "call ws for the file $importedfilepath" -ForegroundColor Green
            # call webservice to import in scratch sql table
            $fileimported = $null
            if (test-path $importedfilepath) {
                $array = $Null
                $array = get-content $importedfilepath 
                
                try {
                    $proxy.ImportRendicontazioniCESAM($array)  
                    $fileimported = $true
                }
                catch {
                    $fileimported = $false
                    $MessaggioErrore = $Error
                }
                finally {
                    if ($fileimported -eq $false) {
                        $FileElaboration = "Error on file $latestCsvName"
                    }


                }
                
            }#if test-path        
        
            if ($fileimported -eq $true) {
                #tabella che viene popolata all'esecuzione della vista
                $Datatable = New-Object System.Data.DataTable
                $DatatableNew = New-Object System.Data.DataTable
                Write-Host "select" -ForegroundColor Cyan

                $ConnectionObject.Open()
                $Comando = $ConnectionObject.CreateCommand()
                $Comando.CommandTimeout = 10000
                $Comando.CommandText = $qSelect
                $DataSetDiRitorno = $null
                $DataSetDiRitorno = $Comando.ExecuteReader()
                $DataTable.Load($DataSetDiRitorno)
                write-host "query select caricata!" -ForegroundColor Green
                $ConnectionObject.close()

                $records = $Datatable

                $qparam = @()
            
                $Conti = $records | Select-Object Conto, DescrizioneConto, ABI, CAB, CodBanca, CodDivisa, IdContoBancarioPerAnno, idcontobancario -Unique | Where-Object IdContoBancarioPerAnno -match ""
        
                $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
                foreach ($Conto in $Conti) {
                    $idcontobancario = ""
                    $idIncarico = ""
                    $IdContoBancarioPerAnno = ""
                              
                    if ([string]::IsNullOrEmpty($Conto.IdContoBancarioPerAnno)) {
                    
                        # chiamo la webapi per creare un incarico
                        $chiavecliente = $($conto.Conto + $getAnno)
                        $ParametriIncaricoDaCreare = @{CodArea = $CodArea ; CodCliente = $CodCliente ; CodTipoIncarico = $CodTipoIncarico ; ChiaveCliente = $chiavecliente } | ConvertTo-Json
                        $servicePoint.CloseConnectionGroup("")
                        $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
                        $idIncarico = Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "$urlBase/Incarico" -Headers $headers -Body $ParametriIncaricoDaCreare
                               
                        # chiamo una sp che fa la insert sulla tcontobancarioperanno utilizzando l'idincarico segnalato e l'idcontobancario estratto
                        $paramNome = @()
                        $paramNumero = @()
                        $paramBanca = @()
                        $paramValuta = @()
                        $paramFittizio = @()
                        $paramTipoConto = @()
                        $paramAbi = @()
                        $paramCab = @()
                        $paramIncarico = @()
                        $paramIdContoBancario = @()
                        $paramAnno = @()
                        $paramNome = (New-SQLParameter -name Nome -value $($Conto.DescrizioneConto) -dbtype varchar)
                        $paramNumero = (New-SQLParameter -name Numero -value $($Conto.Conto) -dbtype varchar)
                        $paramBanca = (New-SQLParameter -name Banca -value 101 -dbtype int)
                        $paramValuta = (New-SQLParameter -name Valuta -value $($Conto.CodDivisa) -dbtype int)
                        $paramFittizio = (New-SQLParameter -name Fittizio -value 0 -dbtype bit)
                        $paramTipoConto = (New-SQLParameter -name CodTipoConto -value 2 -dbtype int)
                        $paramAbi = (New-SQLParameter -name CodAbi -value $($Conto.ABI) -dbtype varchar)
                        $paramCab = (New-SQLParameter -name CodCab -value $($Conto.CAB) -dbtype varchar)
                    
                        if ([string]::IsNullOrEmpty($Conto.IdContoBancario)) {
                            $paramIdContoBancario = (New-SQLParameter -name ContoBancario -value 1 -dbtype int)
                        }
                        else {
                            $paramIdContoBancario = (New-SQLParameter -name ContoBancario -value $($Conto.IdContoBancario) -dbtype int)
                        }

                        $paramIncarico = (New-SQLParameter -name Incarico -value $idIncarico -dbtype int)
                        $paramAnno = (New-SQLParameter -name NumeroAnno -value $getAnno -dbtype int)
                    
                        $IdContoBancarioPerAnno = Invoke-SQLQuery -query $qInserisciConto -Connection $conn -parameters $paramNome, $paramNumero, $paramBanca, $paramValuta, $paramFittizio, $paramTipoConto, $paramAbi, $paramCab, $paramIncarico, $paramIdContoBancario, $paramAnno             

                    }                
                }

                $operazioni = $records | Select-Object Causale, RiferimentoCliente_62, SegnoMovimento, IdOperazioneContoBancario -Unique | Where-Object IdOperazioneContoBancario -match ""

                foreach ($operazione in $operazioni) {                

                    if ([string]::IsNullOrEmpty($operazione.IdOperazioneContoBancario)) {
                        $operazione.Causale
                        $operazione.RiferimentoCliente_62
                        $operazione.SegnoMovimento
                        # chiamo una sp che fa la insert sulla S_operazionecontobancario indicando il segno dell'operazione con i codici causale e descrizione
                        $paramDescrizioneCausale = @()
                        $paramCodiceCausale = @()
                        $paramSegnoCausale = @()
                        $paramDescrizioneCausale = (New-SQLParameter -name DescrizioneCausale -value $($operazione.RiferimentoCliente_62).trim() -dbtype varchar)
                        $paramCodiceCausale = (New-SQLParameter -name CodiceCausale -value $($operazione.Causale).trim() -dbtype varchar)
                        $paramSegnoCausale = (New-SQLParameter -name SegnoCausale -value $($operazione.SegnoMovimento) -dbtype int)
                        $IdOperazioneContoBancario = Invoke-SQLQuery -query $qInserisciOperazione -Connection $conn -parameters $paramDescrizioneCausale, $paramSegnoCausale, $paramCodiceCausale

                        $paramDescrizioneCausaleSetup = @()
                        $paramCodiceCausaleSetup = @()
                        $paramSegnoCausaleSetup = @()
                        $paramDescrizioneCausaleSetup = (New-SQLParameter -name DescrizioneCausaleSetup -value $($operazione.RiferimentoCliente_62).trim() -dbtype varchar)
                        $paramCodiceCausaleSetup = (New-SQLParameter -name CodiceCausaleSetup -value $($operazione.Causale).trim() -dbtype varchar)
                        $paramSegnoCausaleSetup = (New-SQLParameter -name SegnoCausaleSetup -value $($operazione.SegnoMovimento) -dbtype int)
                        if ($test -eq 0) {
                            $IdOperazioneContoBancarioSetup = Invoke-SQLQuery -query $qInserisciOperazioneSetup -Connection $connSetup -parameters $paramDescrizioneCausaleSetup, $paramSegnoCausaleSetup, $paramCodiceCausaleSetup
                        }
                    }                
                } #foreach operazione in operazioni  

                # rieseguo la vista dopo che ho censito i conti mancanti
                $conticensiti = $Null
                $conticensiti = $conti | Where-Object { [string]::IsNullOrEmpty($_.IdContoBancarioPerAnno) }

                $operazionicensite = $Null
                $operazionicensite = $operazioni | Where-Object { [string]::IsNullOrEmpty($_.IdOperazioneContoBancario) }

                
                if ($conticensiti -or $operazionicensite) {
            
                    Write-Host "select new" -ForegroundColor Cyan
                    $ConnectionObject.Open()
                    $Comando = $ConnectionObject.CreateCommand()
                    $Comando.CommandTimeout = 5000
                    $Comando.CommandText = $qSelect
                    $DataSetDiRitorno = $null
                    $DataSetDiRitorno = $Comando.ExecuteReader()
                    $DatatableNew.Load($DataSetDiRitorno)
                    $ConnectionObject.close()
                    $recordsNew = $DatatableNew               

                }
                else {
                    $recordsNew = $Datatable
                }
           
                foreach ($recordNew in $recordsNew) {
                
                    # inserisco tutti i movimenti      
                    #Write-Host "recordnew"
                    $paramDescrizioneMovimento = @()
                    $paramIdContoPerAnno = @()
                    $paramDataVal = @()
                    $paramDataOP = @()
                    $paramIdOperazione = @()
                    $paramImporto = @()
                    $paramIdImport = @()
                    $paramDescrizioneMovimento = (New-SQLParameter -name Descrizione -value $($recordNew.DescrizioneOperazione).Trim() -dbtype varchar)
                    $paramIdContoPerAnno = (New-SQLParameter -name IdContoPerAnno -value $($recordNew.IdContoBancarioPerAnno) -dbtype int)
                    $paramDataVal = (New-SQLParameter -name DataVal -value $($recordNew.DataValuta) -dbtype datetime)
                    $paramDataOp = (New-SQLParameter -name DataOp -value $($recordNew.DataOperazione) -dbtype datetime)
                    $paramIdOperazione = (New-SQLParameter -name IdOperazione -value $($recordNew.IdOperazioneContoBancario) -dbtype int)
                    $paramImporto = (New-SQLParameter -name Importo -value $($recordNew.ImportoMovimento) -dbtype decimal)
                    $paramIdImport = (New-SQLParameter -name IdImport -value $($recordNew.IdImport_RendicontazioneBP) -dbtype int)

                    #LF 2020-12-21 IBAN ORDINANTE
                    $paramIban = (New-SQLParameter -name Iban -value $($recordNew.IbanOrdinante) -dbtype VarChar)

                    #LF 2020-12-21 AGGIUNTO PARAMETRO IBAN ORDINANTE SU INVOKE QUERY
                    $IdMovimentoContoBancario = Invoke-SQLQuery -query $qInserisciMovimento -Connection $conn -parameters $paramDescrizioneMovimento, $paramIdContoPerAnno, $paramDataVal, $paramDataOp, $paramIdOperazione, $paramImporto, $paramIdImport, $paramIban
                    
                    Write-Host "$($recordnew.ABI) $($recordnew.CAB) $($recordnew.Conto) $($recordnew.DescrizioneOperazione)"
                    
                } #foreach recordnew in recordsNew
        
  
                #move file imported to elab dir
                $landFile = "$($conf.sftp.elabPath)$latestCsvName" 
                $session.MoveFile($latestCsv, $landFile) 
                $MessaggioErrore = ""


            } #if file is imported
            
            $row = $Null
            $row = $tempImport.NewRow()

            if ($FileElaboration -eq "") { $FileElaboration = "Importato" }
      
            $row."NomeFile" = [string]$latestCsvName
            $row."EsitoElaborazione" = $FileElaboration
            $row."Errore" = $MessaggioErrore
            $tempImport.Rows.Add($row)
            
            #$tempImport

            $MessaggioErrore = ""
            $FileElaboration = ""
        } #foreach l in latest
    } #if latest (any file at all?)     
    #>  
} #try
catch {
    
    $MessaggioErrore = $Error
    $FileElaboration = "Errore nel file $latestcsvname"
}
finally {
    # close sql connection
    Close-SQLConnection -Connection $conn #| Out-Null
    Close-SQLConnection -Connection $connSetup #| Out-Null

    # close winscp session
    $session.Dispose()

    #remove scratchdir
    Remove-Item $scratchDir -Recurse

    $TempImportRows = $tempImport | Measure-Object |select -ExpandProperty count
    if($tempimportrows -gt 0){
    $tempImport | Export-Csv -Delimiter ";" -NoTypeInformation -path $csvlogfile
    }

    $mailParams = @{ }
    $mailBody = @"
"@;

    $tempImportError = $tempImport | Select-Object EsitoElaborazione | Where-Object {$_.EsitoElaborazione -ne "Importato"}
    $tempImportErrorRows = $tempImportError |Measure-Object | select -ExpandProperty count

    if ($tempImportErrorRows -eq 0 ) {
        $mailSubject = "[success] BPM - Import Rendicontazione"
        
    } 
    else {
        $mailSubject = "[error] BPM - Import Rendicontazione"
    }
    $EsitoFinale = ""
    if ($mailSubject -match "success") {
        if ($FileElaboration -eq "All files already Elab!") {
            $EsitoFinale = "Tutti i file sono stati gia' elaborati."
        }
        else {
            $EsitoFinale = "Import avvenuto con successo"
        }
    }
    else {
        $EsitoFinale = "Almeno un file e' andato in errore."
    }

    $mailBody = @"
$EsitoFinale
    
$messaggioerrore
Server: $env:COMPUTERNAME
ScriptPath: $($MyInvocation.MyCommand.Path)
"@
    
    $conf.mailing | Get-Member -MemberType NoteProperty | ForEach-Object {
        $mailParams.Add($_.name, $conf.mailing."$($_.name)")
    }

    $mailParams.Add("Body", $mailbody)
    $mailParams.Add("Subject", $mailSubject)
    
    if ($mandamail -eq 1) {
        if($TempImportRows -gt 0){
            Send-MailMessage @mailParams -Attachments $csvlogfile
        }else{
            Send-MailMessage @mailParams
        }
    }

    # print dei parametri subject, body

    $mailBody
    $mailSubject

    $tempImport.Clear()
}