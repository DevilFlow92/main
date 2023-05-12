Clear-Host
$error.Clear()


$ErrorActionPreference = "stop"

$jsonPath = $($MyInvocation.MyCommand.path) -replace "ps1", "json"
$conf=gc $jsonPath | Out-String | ConvertFrom-Json


$itextsharpdllpath = "$(Split-Path $($MyInvocation.MyCommand.path))\DLL\itextsharp.dll"
$winscpdllpath = "$(Split-Path $($MyInvocation.MyCommand.path))\DLL\WinSCPnet.dll"
$blankpagepath = "$(Split-Path $($MyInvocation.MyCommand.path))\BlankPage.pdf"

$stampaPython ="$(Split-Path $($MyInvocation.MyCommand.path))\PythonScripts\StampaTestaPacco_v2.py"
$printIdIncaricoPython = "$(Split-Path $($MyInvocation.MyCommand.path))\PythonScripts\PrintIdIncarico.py"
$convertImgToPdf = "$(split-path $($MyInvocation.MyCommand.path))\PythonScripts\ConvertIMGtoPDF.py"
$MergePDFPython = "$(Split-Path $($myinvocation.MyCommand.path))\PythonScripts\MergePDFs.py"

Clear-Host
$error.Clear()

################## PANNELLO DI CONTROLLO #######################################
$test = 0 
$locale = 0
$mandamail = 1
$flageseguilavorativo = 0

$flagconverti_python = 1 #
$flagmergepython = 0 #

$flag_sql_download = 1 #
$flag_sql_select1 = 0
$flag_documents_download = 1 #
$flag_convertto_pdfa = 1 #
$flag_estraiSEPA = 1 #
$flag_estrai2switch = 1 #
$flag_documents_merge = 1 #
$flag_documents_stamp = 1 #
$flag_raggruppa_15 = 1 #
$flag_mergefoldersinpdf = 1 #
$flag_producicsv = 1 #
$flag_create_zip = 0 #
$flag_trasferisci_transferagent = 1 #
$flag_imbarcaTestaPacco = 1 #

$flag_esegui_transizioni = 1 #
$flag_remove_work_folder = 1

#################################################################################

if($test -eq 0){
$urlBase = $conf.WebAPI.url
$user = $conf.WebAPI.user
$Password = $conf.WebAPI.pwd
$conn = $conf.SQLConnection.istanzaProdDotNet
}else{
$urlBase = $conf.WebAPI.urlTest
$user = $conf.WebAPI.userTest
$Password = $conf.WebAPI.pwdTest
$conn = $conf.SQLConnection.istanzaTest
}

if($locale -eq 1){
$ghostscript = $conf.GhostScript.pathLocale
$destinazione = $conf.Destinazione.pathLocale

}else{
$ghostscript = $conf.GhostScript.pathServer
$destinazione = $conf.Destinazione.pathServer
}

#pulizia file vecchi su disco
$limit = (Get-Date).AddDays(10)
$pathliste = "$(Split-Path $($MyInvocation.MyCommand.path))\LISTE"
$pathlog = "$(Split-Path $($MyInvocation.MyCommand.path))\LOG"
Get-ChildItem -Path $pathliste -Recurse -Force | Where-Object {!$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
Get-ChildItem -Path $pathlog -Recurse -Force | Where-Object {!$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force



function Pdf-toPdfa($OutputFile,$InputFile){
$errore = $null
$table = @()
$tablevalue = New-Object System.Object


try{
 & "$GhostScript"  -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$OutputFile" "$InputFile"
 }catch{$errore = $error
 
 
 
 }finally{if($errore -eq $null){
        $tablevalue | Add-Member -MemberType NoteProperty -Name "IsOk" -Value 1
        $table += $tablevalue 
 }else{
        $tablevalue | Add-Member -MemberType NoteProperty -Name "IsOk" -Value 0
        $table += $tablevalue 
 }}
        $table      
 }
 


function Test-FileLock {
  param (
    [parameter(Mandatory=$true)][string]$Path
  )

  $oFile = New-Object System.IO.FileInfo $Path

  if ((Test-Path -Path $Path) -eq $false) {
    return $false
  }

  try {
    $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::OpenWrite, [System.IO.FileShare]::None)

    if ($oStream) {
      $oStream.Close()
    }
    $false
  } catch {
    # file is locked by a process.
    return $true
  }
}


function Merge-pdf(){
    [CmdletBinding()]
    param(
        [string]$workingDirectory,
        [string]$fileOutPut
    )
    [void] [System.Reflection.Assembly]::LoadFrom($itextsharpdllpath);
    $pdfs = ls $workingDirectory -recurse | where {-not $_.PSIsContainer -and $_.Extension -imatch "^\.pdf$"} | sort{$_.Name};
    $output = $fileOutPut
    $op = [System.IO.FileMode]::OpenOrCreate
    $fileStream = New-Object System.IO.FileStream($output, $op);
    $document = New-Object iTextSharp.text.Document;
    $pdfCopy = New-Object iTextSharp.text.pdf.PdfCopy($document, $fileStream);
    $document.Open();

    foreach ($pdf in $pdfs) {
        $reader = New-Object -typeName iTextSharp.text.pdf.PdfReader -ArgumentList $($pdf.FullName);
        Write-Host "$($pdf.Fullname)"
        $pdfCopy.AddDocument($reader);
        $reader.Dispose(); 
    }
    

    $pdfCopy.Dispose();
    $document.Dispose();
    $fileStream.Dispose();
    
}


function exec-salvariconcilia(
$inseriscitr,
$idincarico,
$idmovimentocontobancario,
$flagriconciliato,
$flagconfermato,
$notaaggiuntiva,
$eliminadatr,
$sp_tiporiconciliazione
){

if(!$sp_tiporiconciliazione){$sp_tiporiconciliazione = "NULL"}

$notaaggiuntiva = $notaaggiuntiva -replace "'","''"
if(!$eliminadatr){
    $eliminadatr = 0
}

if($Comando){
 

$Comando = $ConnectionObject.CreateCommand()

$Exec =   @"

EXEC orga.Salva_Riconciliazione_MovimentoContoBancario	@InserisciTR = $inseriscitr,
                                                        @IdIncarico = $idincarico,
														@IdMovimentoContoBancario = $idmovimentocontobancario,
														@FlagRiconciliato = $flagriconciliato,
														@FlagConfermato = $flagconfermato,
														@NotaAggiuntiva = '$notaaggiuntiva',
                                                        @EliminaDaTR = $eliminadatr,
                                                        @TipoRiconciliazione = $sp_tiporiconciliazione

"@

#$Exec

$Comando.CommandTimeout = 20
$Comando.CommandText = $Exec
$Comando.ExecuteNonQuery()

}

}

Function Create-PDF([iTextSharp.text.Document]$Document
, [string]$File
, [int32]$TopMargin
, [int32]$BottomMargin
, [int32]$LeftMargin
, [int32]$RightMargin
, [string]$Author
)
{

    $Document.SetPageSize([iTextSharp.text.PageSize]::A4)
    $Document.SetMargins($LeftMargin, $RightMargin, $TopMargin, $BottomMargin)
    [void][iTextSharp.text.pdf.PdfWriter]::GetInstance($Document, [System.IO.File]::Create($File))
    $Document.AddAuthor($Author)
}

function Add-Image([iTextSharp.text.Document]$Document
, [string]$File,
 [int32]$Scale = 100
 , [int32]$ScalePercent
 )
{


    [iTextSharp.text.Image]$img = [iTextSharp.text.Image]::GetInstance($File) 
   
   if($img.Height > $img.Width){
    [float]$percentage = 700 / $img.Height
    $img.ScalePercent($percentage*100)

   } else {
   [float]$percentage = 450 / $img.Width
    $img.ScalePercent($percentage*100)
    $img.scaleab
   }
   $Document.Add($img)
}

function clonaflussicbicontabiliscorporate($idmovimento){

$Comando = $ConnectionObject.CreateCommand()

$exec = @"

INSERT INTO scratch.T_R_ImportRendicontazione_Movimento (IdImport_Rendicontazione, IdMovimentoContoBancario, IdContoBancarioPerAnno)

SELECT tr.IdImport_Rendicontazione
,tm.IdMovimentoContoBancario
,tm.IdContoBancarioPerAnno

FROM T_MovimentoContoBancario tm
JOIN T_ContoBancarioPerAnno ON tm.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND anno = YEAR(getdate())
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND NumeroConto IN (
'802240901'	--AZIMUT CAP. MANAG. SGR	Conto SIA/SISTEMA FORMULA 1	AZCM SIA/SIST FORM1
,'802260103'	--AZ FUND 1	Conto Sottoscrizioni	AZCM/AZ FUND1 SOTT
,'802260302'	--AZ Multi Asset	Conto Sottoscrizioni	AZCM/AZ MULTI AS SOT
,'801241000'	--AZIMUT DINAMICO	Conto Afflusso	AZIMUT DINAMICO AF
,'801241100'	--AZIMUT TREND   	Conto Afflusso	AZIMUT TREND AF
,'801241200'	--AZIMUT SOLIDITY 	Conto Afflusso	AZIMUT SOLIDITY AF
,'801241300'	--AZIMUT TREND ITALIA              	Conto Afflusso	AZIMUT TREND ITA AF
,'801241400'	--AZIMUT TREND TASSI               	Conto Afflusso	AZIMUT TREND TASSI
,'801241500'	--AZIMUT SCUDO         	Conto Afflusso	AZIMUT SCUDO AF
,'801241600'	--AZIMUT TREND EUROPA              	Conto Afflusso	AZIMUT TREND EUR AF
,'801241700'	--AZIMUT TREND AMERICA             	Conto Afflusso	AZIMUT TREND AMER AF
,'801241800'	--AZIMUT  ITALIA ALTO POTENZIALE	Conto Afflusso	AZIMUT ITA. ALTO POTENZ.AF
,'801241900'	--AZIMUT TARGET 2017 		AZIMUT TAR21 E.OP AF
,'801242000'	--FORMULA 1 ABSOLUTE 	Conto Afflusso	AZIMUT FOR1 ABSOL AF
,'801242100'	--AZIMUT REDDITO USA 	Conto Afflusso	AZIMUT RED USA AF
,'801242200'	--AZIMUT STRATEGIC TREND           	Conto Afflusso	AZIMUT STRA TREND AF
,'802258100'	--Azimut   Azimut Previdenza	conto afflusso	AZIMUT PREV/ AFFLUS 
  
)

JOIN T_NotaIncarichi tni1 ON tm.IdNotaIncarichi = tni1.IdNotaIncarichi

LEFT JOIN scratch.T_R_ImportRendicontazione_Movimento trnull ON tm.IdMovimentoContoBancario = trnull.IdMovimentoContoBancario

JOIN T_MovimentoContoBancario scorporo ON tm.IdMovimentoContoBancarioMaster = scorporo.IdMovimentoContoBancario
JOIN T_NotaIncarichi tni2 ON scorporo.IdNotaIncarichi = tni2.IdNotaIncarichi
JOIN scratch.T_R_ImportRendicontazione_Movimento tr ON scorporo.IdMovimentoContoBancario = tr.IdMovimentoContoBancario
AND scorporo.IdMovimentoContoBancario = tr.IdMovimentoContoBancario

WHERE trnull.idrelazione IS NULL
AND tni1.Testo = tni2.Testo
and tm.IdMovimentoContoBancario = $idmovimento


"@

$Comando.CommandText = $exec
$Comando.CommandTimeout = 1000
$Comando.ExecuteNonQuery()

#Write-Host "Clonato Movimento Scorporato $idmovimento"

}

############################ AUTENTICAZIONE #######################################

$servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
    $headerToken =Invoke-RestMethod –Uri "$urlBase/Autenticazione/NomeHeaderTokenSessione"
    $credenziali = @{ Username = $User; Password = $Password} | ConvertTo-Json
    $token = Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "$urlBase/Autenticazione/Autentica" -Body $credenziali
    $headers = @{"$headerToken" = $token }
    $sessione = Invoke-RestMethod -ContentType "application/json" -Method Get -Uri "$urlBase/Autenticazione/Sessione" -Headers $headers

############################ FINE AUTENTICAZIONE ##################################
 # connessione a sql
 $StringaConnessione = "Server=$($conn);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
 $ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
 $Comando = New-Object System.Data.SqlClient.SqlCommand 

$Datatable_calendario = New-Object System.Data.DataTable

 Write-Host "Accesso al Database - Ricerca calendario lavorativo Azimut"

$querycalendario =@"
SELECT TOP 1 *
FROM S_Calendario
JOIN rs.S_Data ON rs.S_Data.Data = CAST(FLOOR(CAST(InizioMezzaGiornata AS FLOAT)) AS DATETIME)
WHERE CodCliente = 23
AND FlagLavorativo = 1
AND Data = CONVERT(DATE,getdate())
"@



 #apro la connessione a sql
 $ConnectionObject.Open()

 $Comando = $ConnectionObject.CreateCommand()
 $Comando.CommandTimeout = 10
 $Comando.CommandText = $querycalendario

 $DatasetCalendario = $null
 $DatasetCalendario = $Comando.ExecuteReader()

 $Datatable_calendario.load($DatasetCalendario)
 
 $ConnectionObject.close()

 if($Datatable_calendario.Rows.Count -eq 0 -and $flageseguilavorativo -eq 1){
    Write-Host "Giorno Festivo. Nessuna azione necessaria"
 
 }else{


try{

if($flag_sql_download -eq 1){

 
 #tabella che viene popolata all'esecuzione della vista
 $Datatable = New-Object System.Data.DataTable 
 
$Query =   @"

SELECT --top 91
StampaRiconciliati.IdIncarico
      ,StampaRiconciliati.CodTipoIncarico
	  ,StampaRiconciliati.Documento_id
      ,StampaRiconciliati.CodTipoDocumento
      ,StampaRiconciliati.TipoDocumento
	  ,StampaRiconciliati.Nome_file
      ,StampaRiconciliati.FlagPDF
	  ,StampaRiconciliati.NomeFileOutput
	  ,StampaRiconciliati.EstensioneFileOutput
	  ,StampaRiconciliati.IdMovimentoContoBancario
	  ,StampaRiconciliati.Importo
      ,StampaRiconciliati.ImportoIncarichi
	  ,StampaRiconciliati.DataValuta
	  ,StampaRiconciliati.DataContabile
	  ,StampaRiconciliati.IbanOrdinante
	  ,StampaRiconciliati.Abi
	  ,StampaRiconciliati.Cab
        
        /* LF 2020-12-30 AGGIUNTA CAMPO NUMERO CONTO */
        ,StampaRiconciliati.NumeroConto

	  ,StampaRiconciliati.RiferimentoOrdinante
	  ,StampaRiconciliati.Causale
      ,StampaRiconciliati.NotaAggiuntiva
      ,StampaRiconciliati.Gruppo
      ,StampaRiconciliati.DettaglioProdotti
      ,StampaRiconciliati.FlagPaperLess
      ,StampaRIconciliati.TipoDispositiva
     
FROM rs.v_CESAM_AZ_TransferAgent_StampaRiconciliati StampaRiconciliati
where EstensioneFileOutput IN ('.pdf','.jpg','.jpeg','.png')
--and flagpaperless = 1
ORDER BY StampaRiconciliati.IdMovimentoContoBancario, StampaRiconciliati.IdIncarico

"@
 
    
 #apro la connessione a sql
 $ConnectionObject.Open()
 
 $Comando = $ConnectionObject.CreateCommand()
 $Comando.CommandTimeout = 10000
 $Comando.CommandText = $Query

 write-host "Pre-Caricamento stampe..." -ForegroundColor Green
 
 $DataSetDiRitorno = $null
 $DataSetDiRitorno = $Comando.ExecuteReader()
 

 $DataTable.Load($DataSetDiRitorno)
  #chiudo la connessione a sql

 $ConnectionObject.close()

  #### CLONA T_R_IMPORTRENDICONTAZIONE_MOVIMENTO DELLE CONTABILI SCORPORATE ###
 $ConnectionObject.Open()
 Write-Host "Clona Dati Flusso cbi della contabile scorporata"
    $Datatable | Where-Object { $_.IbanOrdinante -eq "N/D"} | Select-Object IdMovimentoContoBancario -Unique | ForEach-Object{
    
        clonaflussicbicontabiliscorporate -idmovimento $_.IdMovimentoContoBancario

    }

  #riesegui query 
  Write-Host "Ricaricamento Stampe" -ForegroundColor Green
  $Comando = $ConnectionObject.CreateCommand()
  $Comando.CommandTimeout = 10000
  $Comando.CommandText = $Query

  $DataSetDiRitorno = $null
  $DataSetDiRitorno = $Comando.ExecuteReader()
  
  $Datatable.Clear()
  $Datatable.load($DataSetDiRitorno)

 $ConnectionObject.CLOSE()
 #############################################################################




if($flag_sql_select1 -eq 1){
 $Datatable = $Datatable | Select-Object #-First 30

 }

 $Datatable | Add-Member -MemberType NoteProperty -Name "IsOK" -Value $null
 
}

$TempStampa = @()
 $TempStampa = New-Object System.Data.DataTable 
 $column1 = New-Object System.Data.DataColumn "IdIncarico",([INT])
 $TempStampa.Columns.Add($column1)
 $column2 = New-Object System.Data.DataColumn "Importo",([DECIMAL])
 $TempStampa.Columns.add($column2)
 $column3 = New-Object System.Data.DataColumn "SommaOperazioniIncarichi", ([DECIMAL])
 $TempStampa.Columns.Add($column3)
 $column4 = New-Object System.Data.DataColumn "DataValuta",([STRING])
 $TempStampa.Columns.Add($column4)
 $column5 = New-Object System.Data.DataColumn "DataContabile",([STRING])
 $TempStampa.Columns.Add($column5)
 $column6 = New-Object System.Data.DataColumn "ABI",([STRING])
 $TempStampa.Columns.Add($column6)
 $column7 = New-Object System.Data.DataColumn "CAB",([STRING])
 $TempStampa.Columns.Add($column7)

  #LF 2020-12-30 NumeroConto
 $Column8 = New-Object System.Data.DataColumn "NumeroConto",([STRING])
 $TempStampa.Columns.Add($COLUMN8)

 $column9 = New-Object System.Data.DataColumn "RiferimentoOrdinante",([STRING])
 $TempStampa.Columns.Add($column9)
 $column10 = New-Object System.Data.DataColumn "Causale",([STRING])
 $TempStampa.Columns.Add($column10) 
 $column11 = New-Object System.Data.DataColumn "NotaUfficioBonifici",([STRING])
 $TempStampa.Columns.Add($column11)
 $column12 = New-Object System.Data.DataColumn "IdMovimentoContoBancario",([INT])
 $TempStampa.Columns.Add($column12)
 $column13 = New-Object System.Data.DataColumn "Documento_id",([INT])
 $TempStampa.Columns.ADD($column13)
 $COLUMN14 = New-Object System.Data.DataColumn "TipoDocumento",([STRING])
 $TempStampa.Columns.ADD($column14)
 $column15 = New-Object System.Data.DataColumn "Gruppo",([STRING])
 $TempStampa.Columns.ADD($column15)
 $COLUMN16 = New-Object System.Data.DataColumn "IsOK",([STRING])
 $TempStampa.Columns.ADD($column16)
 $column17 = New-Object System.Data.DataColumn "Paperless",([INT])
 $TempStampa.Columns.ADD($column17)
 $column18 = New-Object System.Data.DataColumn "DettaglioProdotti",([STRING])
 $TempStampa.Columns.ADD($column18)
  # LF 2021-03-36 Tipologia Prodotti 
 $column19 = New-Object System.Data.DataColumn "TipologiaProdotti", ([string])
 $TempStampa.Columns.ADD($column19)
 ##########################################


  

if($flag_documents_download -eq 1){


# scratch directory
$data = $null
$data = Get-Date -Format "dd-MM-yyyy"
$ora = $null
$ora = Get-Date -Format "HH-mm"
$scratchname=$($conf.ScratchName)
$scratchDir="$env:TEMP\$scratchname"
$scratchSubDir = "$scratchDir\work"

$log = @()
$logfile = "$(Split-Path $($MyInvocation.MyCommand.path))\LOG\$data-$ora.txt"

 
if(Test-Path $scratchDir){

Remove-Item $scratchDir -Recurse -Force
  
}
 mkdir $scratchDir | Out-Null
 mkdir $scratchSubDir | Out-Null


$DataTableIncarichi = $Datatable | select IdIncarico, CodTipoIncarico, Documento_id, Nome_file, FlagPDF, NomeFileOutput, EstensioneFileOutput, IsOK, Gruppo, FlagPaperLess -Unique 


$fileblankprecedente = $null

$DataTableIncarichi | Where-Object {$_.FlagPaperLess -eq 0} | ForEach-Object {

$idincarico = $null
$codtipoincarico = $null
$iddocumento = $null
$filePath = $null
$filepathblankpage = $null

$foldername = $null
$foldername = $_.Gruppo


$idincarico = $_.IdIncarico
$iddocumento = $_.Documento_id
$codtipoincarico = $_.CodTipoIncarico
#$idmovimento = $_.IdMovimentoContoBancario

if(!(Test-Path "$scratchSubDir\$data-$ora-$foldername")){

                mkdir "$scratchSubDir\$data-$ora-$foldername" | Out-Null
              }

if(Test-Path "$scratchSubDir\$data-$ora-$foldername\$($_.IdIncarico).pdf" -PathType Leaf){

}else{
Copy-Item $blankpagepath -Destination "$scratchSubDir\$data-$ora-$foldername\$($_.IdIncarico).pdf"
}
$filepathblankpage = "$scratchSubDir\$data-$ora-$foldername\$($_.IdIncarico).pdf"
$filePath = "$scratchSubDir\$data-$ora-$foldername\$($_.NomeFileOutput)$($_.EstensioneFileOutput)"

Write-Host $iddocumento -ForegroundColor Yellow
                    $servicePoint.CloseConnectionGroup("")
                   $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
                   Invoke-RestMethod -ContentType "application/json" -Method GET -Uri "$urlBase/Incarico/$idincarico/Documento/$iddocumento/contenuto" -Headers $headers -OutFile $filePath
                           
                   $servicePoint.CloseConnectionGroup("")

if($_.FlagPDF -ne 1){

    Write-Host "Conversione immagine in pdf"
    

    $nomePDF = $null
    $nomePDF = "$($_.NomeFileOutput).pdf"

    $filepdf = $null
    $filepdf = "$(Split-Path $filePath)\$nomePDF"

    
    if($flagconverti_python -eq 1){
            $conversione = python $convertImgToPdf "$filepath"
            Write-Host "Conversione: $conversione" -ForegroundColor Magenta
    }else{
            [void] [System.Reflection.Assembly]::LoadFrom($itextsharpdllpath)

            
            $pdf =$null
            $pdf = New-Object iTextSharp.text.Document

            Create-PDF -Document $pdf -file $filepdf -TopMargin 20 -BottomMargin 20 -LeftMargin 20 -RightMargin 20 -Author "Fiori"
            $pdf.open()
            Add-Image -Document $pdf -file $filePath
            $pdf.close()
    }



    $filePath = $filepdf

}




if($flag_convertto_pdfa -eq 1){


$filePathblankpage_c = $null
$filePathblankpage_c = $filepathblankpage -replace "\.pdf","_c.pdf"

$filePath_c = $null
$filePath_c = $filePath -replace "\.pdf","_c.pdf"


$PDFTOPDFA = $null

$PDFTOPDFA = Pdf-toPdfa -OutputFile $filePathblankpage_c -InputFile $filepathblankpage 


$PDFTOPDFA = Pdf-toPdfa -OutputFile $filePath_c -InputFile $filePath 


#write-host $PDFTOPDFA -ForegroundColor red
IF($($PDFTOPDFA.IsOk) -eq 1){
$_.IsOk = 1

$log += "convertito $filepathblankpage in $filePathblankpage_c"
$log += "convertito $filepath in $filePath_c"


Remove-Item $filepathblankpage -Recurse -Force | Out-Null
Rename-Item -Path $filePathblankpage_c -NewName $filepathblankpage

$fileblankprecedente = $filepathblankpage

Remove-Item $filePath -Recurse -Force | Out-Null
Rename-Item -Path $filePath_c -NewName $filePath

if($flagmergepython -eq 1){

#$newfilepath = $null
#$newfilepath = python $printIdIncaricoPython "$idincarico" "$filepath"

##$newfilepath

#Remove-Item $filePath
#Rename-Item -Path $newfilepath -NewName "$($_.NomeFileOutput)$($_.EstensioneFileOutput)"

##Test-Path $filePath
}

if($flag_documents_stamp -eq 1){
    #LF 2020-12-30 NumeroConto
    $DatatableMovimenti = $Datatable | Where-Object{ $_.IdIncarico -Match $idincarico}  | Select IdMovimentoContoBancario, Importo, ImportoIncarichi, DataValuta, DataContabile, Abi, Cab, NumeroConto, RiferimentoOrdinante, Causale, NotaAggiuntiva, Gruppo, DettaglioProdotti, TipoDispositiva -Unique 

    $idmovimentocontobancario = $null
    $importo = $null
    $datavaluta = $null
    $datacontabile = $null
    $abi = $null
    $cab = $null
    $riferimentoordinante = $null
    $causale = $null
    $notaaggiuntiva = $null
    $gruppo = $null
    $importoincarichi = $null
    $dettaglioprodotti = $null
    #LF 2020-12-30 NumeroConto
    $numeroconto = $null
    $TipoDispositiva = $null
    
 
    $idmovimentocontobancario = $DatatableMovimenti.IdMovimentoContoBancario -join "§"
    $importo = $DatatableMovimenti.Importo -join "§"
    $datavaluta = $DatatableMovimenti.DataValuta -join "§"
    $datacontabile = $DatatableMovimenti.DataContabile -join "§"
    $abi = $DatatableMovimenti.Abi -join "§"
    $cab = $DatatableMovimenti.Cab -join "§"
    $riferimentoordinante = $DatatableMovimenti.RiferimentoOrdinante -join "§"
    $causale = $DatatableMovimenti.Causale -join "§"
    $notaaggiuntiva = $DatatableMovimenti.NotaAggiuntiva -join "§"
    $gruppo = $DatatableMovimenti.Gruppo -join "§"
    $importoincarichi = $DatatableMovimenti.ImportoIncarichi -join "§"
    $dettaglioprodotti = $DatatableMovimenti.DettaglioProdotti -join "§"
    #LF 2020-12-30 NumeroConto
    $numeroconto = $DatatableMovimenti.NumeroConto -join "§"
    $TipoDispositiva = $DatatableMovimenti.TipoDispositiva -join "§"
    
    Write-Host  "$filepathblankpage  Incarico $idincarico" -ForegroundColor Cyan
   
    $stampa = $null
    #lf 2020-12-30 NumeroConto
    $stampa = python $stampaPython "$idincarico" "$idmovimentocontobancario" "$importo" "$datavaluta" "$datacontabile" "$abi" "$cab" "$riferimentoordinante" "$causale" "$notaaggiuntiva" "$filepathblankpage" "$importoincarichi" "$dettaglioprodotti" "$numeroconto" "$TipoDispositiva"
    
    write-host "stampa: $stampa" -ForegroundColor Magenta
    
   
    if($stampa -eq "OK"){

    $ConnectionObject.Open()

    $log+="Stampato $idincarico IdMovimenti $idmovimentocontobancario"
    foreach($movimento in $DatatableMovimenti){
    if($flag_esegui_transizioni -eq 1){
    exec-salvariconcilia -inseriscitr 0 -eliminadatr 0 -idincarico 0 -idmovimentocontobancario $movimento.IdMovimentoContoBancario -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva "Stampato"
    }
    }
    $ConnectionObject.close()
    
    $Datatable | Where-Object{$_.Documento_id -Match $iddocumento} | ForEach-Object{
        $row = $null
        $row = $TempStampa.NewRow()
        $row."IdIncarico"                = $_.IdIncarico           
        $row."Importo"                   = $_.Importo             
        $row."DataValuta"                = $_.DataValuta           
        $row."DataContabile"             = $_.DataContabile         
        $row."ABI"                       = $_.ABI                  
        $row."CAB"                       = $_.CAB   
        #LF 2020-12-30 NumeroConto  
        $ROW."NumeroConto"               = $_.NumeroConto                
        $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
        $row."Causale"                   = $_.Causale              
        $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
        $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
        $row."Documento_id"              = $_.Documento_id           
        $row."TipoDocumento"             = $_.TipoDocumento
        $row."Gruppo"                    = $_.Gruppo
        $row."IsOK"                      = 1
        $row."Paperless"                 = 0
        $row."DettaglioProdotti"         = $_.DettaglioProdotti
        $row."TipologiaProdotti" = $_.TipoDispositiva
        $TempStampa.rows.add($row) 

 
        }
    }else{ 
        Write-Host "$idincarico IdMovimenti $idmovimentocontobancario $error" -ForegroundColor Red
        $log += "$idincarico IdMovimenti $idmovimentocontobancario $error"
        $Datatable | Where-Object{ $_.Documento_id -Match $iddocumento} | ForEach-Object{
            $row = $null
            $row = $TempStampa.NewRow()
            $row."IdIncarico"                = $_.IdIncarico           
            $row."Importo"                   = $_.Importo             
            $row."DataValuta"                = $_.DataValuta           
            $row."DataContabile"             = $_.DataContabile         
            $row."ABI"                       = $_.ABI                  
            $row."CAB"                       = $_.CAB  
            #LF 2020-12-30 NumeroConto  
            $row."NumeroConto"               = $_.NumeroConto                 
            $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
            $row."Causale"                   = $_.Causale              
            $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
            $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
            $row."Documento_id"              = $_.Documento_id           
            $row."TipoDocumento"             = $_.TipoDocumento
            $row."Gruppo"                    = $_.Gruppo
            $row."IsOK"                      = 0
            $row."Paperless"                 = 0
            $row."DettaglioProdotti"         = $_.DettaglioProdotti
            $row."TipologiaProdotti" = $_.TipoDispositiva
            $TempStampa.rows.add($row)           
          }

    }

} #end $flag_documents_stamp


}ELSE{

$_.IsOk = 0
Write-Host "errore pdfa IdIncarico $idincarico IdDocumento $iddocumento IdMovimenti $idmovimentocontobancario" -ForegroundColor Red
$log += "errore pdfa IdIncarico $idincarico IdDocumento $iddocumento IdMovimenti $idmovimentocontobancario"
$error
$Datatable | Where-Object{ $_.Documento_id -Match $iddocumento} | ForEach-Object{
$row = $null
$row = $TempStampa.NewRow()
$row."IdIncarico"                = $_.IdIncarico           
$row."Importo"                   = $_.Importo             
$row."DataValuta"                = $_.DataValuta           
$row."DataContabile"             = $_.DataContabile         
$row."ABI"                       = $_.ABI                  
$row."CAB"                       = $_.CAB  
#LF 2020-12-30 NumeroConto   
$row."NumeroConto"               = $_.NumeroConto              
$row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
$row."Causale"                   = $_.Causale              
$row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
$row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
$row."Documento_id"              = $_.Documento_id           
$row."TipoDocumento"             = $_.TipoDocumento
$row."Gruppo"                    = $_.Gruppo
$row."IsOK"                      = 0
$row."Paperless"                 = 0
$row."DettaglioProdotti"         = $_.DettaglioProdotti
$row."TipologiaProdotti" = $_.TipoDispositiva
$TempStampa.rows.add($row)           
}

if($fileblankprecedente -ne $filepathblankpage){
Remove-Item $filepathblankpage -Recurse -Force | Out-Null
}

Remove-Item $filePathblankpage_c -Recurse -Force | Out-Null

Remove-Item $filePath -Recurse -Force | Out-Null
Remove-Item $filePath_c -Recurse -Force | Out-Null

}

}


} #close foreach datatable  STAMPA

Write-Host "Caricamento paperless" -ForegroundColor Green

$Paperless = $DataTableIncarichi  | Where-Object {$_.FlagPaperLess -eq 1} | Select IdIncarico, CodTipoIncarico, Gruppo -Unique 
$Paperless | ForEach-Object{
$idincarico = $null
$idincarico = $_.IdIncarico
$codtipoincarico = $null
$codtipoincarico = $_.CodTipoIncarico
$foldername = $null
$foldername = $_.Gruppo

######### INIZIO IMBARCO TESTAPACCO #######################
if($flag_imbarcaTestaPacco -eq 1){

if(!(Test-Path "$scratchSubDir\$data-$ora-$foldername")){

                mkdir "$scratchSubDir\$data-$ora-$foldername" | Out-Null
              }

if(Test-Path "$scratchSubDir\$data-$ora-$foldername\$idincarico.pdf" -PathType Leaf){

}else{


Copy-Item $blankpagepath -Destination "$scratchSubDir\$data-$ora-$foldername\$idincarico.pdf"
}
$filepathblankpage = "$scratchSubDir\$data-$ora-$foldername\$idincarico.pdf"

$filename = $null
$filename = "$idincarico.pdf"

    #LF 2020-12-30 NumeroConto
    $DatatableMovimenti = $Datatable | Where-Object{ $_.IdIncarico -Match $idincarico}  | Select IdMovimentoContoBancario, Importo, ImportoIncarichi, DataValuta, DataContabile, Abi, Cab, NumeroConto, RiferimentoOrdinante, Causale, NotaAggiuntiva, Gruppo, DettaglioProdotti, TipoDispositiva -Unique 

    $idmovimentocontobancario = $null
    $importo = $null
    $datavaluta = $null
    $datacontabile = $null
    $abi = $null
    $cab = $null
    $riferimentoordinante = $null
    $causale = $null
    $notaaggiuntiva = $null
    $gruppo = $null
    $importoincarichi = $null
    $dettaglioprodotti = $null
    #LF 2020-12-30 NumeroConto
    $numeroconto = $null
    $TipoDispositiva = $null
    
 
    $idmovimentocontobancario = $DatatableMovimenti.IdMovimentoContoBancario -join "§"
    $importo = $DatatableMovimenti.Importo -join "§"
    $datavaluta = $DatatableMovimenti.DataValuta -join "§"
    $datacontabile = $DatatableMovimenti.DataContabile -join "§"
    $abi = $DatatableMovimenti.Abi -join "§"
    $cab = $DatatableMovimenti.Cab -join "§"
    $riferimentoordinante = $DatatableMovimenti.RiferimentoOrdinante -join "§"
    $causale = $DatatableMovimenti.Causale -join "§"
    $notaaggiuntiva = $DatatableMovimenti.NotaAggiuntiva -join "§"
    $gruppo = $DatatableMovimenti.Gruppo -join "§"
    $importoincarichi = $DatatableMovimenti.ImportoIncarichi -join "§"
    $dettaglioprodotti = $DatatableMovimenti.DettaglioProdotti -join "§"
    #LF 2020-12-30 NumeroConto
    $numeroconto = $DatatableMovimenti.NumeroConto -join "§"
    $TipoDispositiva = $DatatableMovimenti.TipoDispositiva -join "§"
    
    Write-Host  "$filepathblankpage  Incarico $idincarico" -ForegroundColor Cyan
   
    $stampa = $null
    #lf 2020-12-30 NumeroConto
    $stampa = python $stampaPython "$idincarico" "$idmovimentocontobancario" "$importo" "$datavaluta" "$datacontabile" "$abi" "$cab" "$riferimentoordinante" "$causale" "$notaaggiuntiva {Paperless}" "$filepathblankpage" "$importoincarichi" "$dettaglioprodotti" "$numeroconto" "$TipoDispositiva"
    
    write-host "stampa: $stampa" -ForegroundColor Magenta

if($stampa -eq "OK"){
    



##############################################################################################

# IMBARCO DOCUMENTO STAMPA DATI CONTABILE DISMESSO.
# PER RIATTIVARLO, DECOMMENTARE LO SNIPPET DI CODICE INDICATO SOTTO

####$parametriInserimentoDocumento = $null
####$parametriInserimentoDocumento = @{IdIncarico = $_.IdIncarico
####;CodTipoDocumento = 259391 
####;CodOrigineDocumento = 1
####;NomeFile = $Filename
####;Contenuto = [Convert]::ToBase64String([IO.File]::ReadAllBytes($filepathblankpage))
####} | ConvertTo-Json

####$servicePoint.CloseConnectionGroup("")
####$servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)

####try{
####Write-Host "trasferimento Documento $Filename" -ForegroundColor Cyan
####$documentoid = $null
####if($codtipoincarico -ne 693 -and){
####$documentoid = Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "$urlBase/Documento" -Headers $headers -Body $parametriInserimentoDocumento
####}
####}catch{
####$Error
####$log += "$error"
####
####} #try-catch web-api inserimento documento

###############################################################################################

    $ConnectionObject.Open()

    $log+="Paperless $idincarico IdMovimenti $idmovimentocontobancario"
    foreach($movimento in $DatatableMovimenti){
    if($flag_esegui_transizioni -eq 1){
        if($codtipoincarico -eq 693){
            $Paperless = "Paperless_PAC"
        }else{
            $Paperless = "Paperless"
        }

        exec-salvariconcilia -inseriscitr 0 -eliminadatr 0 -idincarico 0 -idmovimentocontobancario $movimento.IdMovimentoContoBancario -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $Paperless
    }
    }
    $ConnectionObject.close()
    
    $DatatableMovimenti | ForEach-Object{
        $row = $null
        $row = $TempStampa.NewRow()
        $row."IdIncarico"                = $idincarico          
        $row."Importo"                   = $_.Importo             
        $row."DataValuta"                = $_.DataValuta           
        $row."DataContabile"             = $_.DataContabile         
        $row."ABI"                       = $_.ABI                  
        $row."CAB"                       = $_.CAB   
        #LF 2020-12-30 NumeroConto  
        $ROW."NumeroConto"               = $_.NumeroConto                
        $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
        $row."Causale"                   = $_.Causale              
        $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
        $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
        $row."Documento_id"              = 0         
        $row."TipoDocumento"             = "N/D"
        $row."Gruppo"                    = $_.Gruppo
        $row."IsOK"                      = 1
        $row."Paperless"                 = 1
        $row."DettaglioProdotti"         = $_.DettaglioProdotti
        $row."TipologiaProdotti" = $_.TipoDispositiva
        $TempStampa.rows.add($row) 

 
        }
    }else{ 
        Write-Host "$idincarico IdMovimenti $idmovimentocontobancario $error" -ForegroundColor Red
        $log += "$idincarico IdMovimenti $idmovimentocontobancario $error"
        $DatatableMovimenti | Select-Object  | ForEach-Object{
            $row = $null
            $row = $TempStampa.NewRow()
            $row."IdIncarico"                = $idincarico           
            $row."Importo"                   = $_.Importo             
            $row."DataValuta"                = $_.DataValuta           
            $row."DataContabile"             = $_.DataContabile         
            $row."ABI"                       = $_.ABI                  
            $row."CAB"                       = $_.CAB  
            #LF 2020-12-30 NumeroConto  
            $row."NumeroConto"               = $_.NumeroConto                 
            $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
            $row."Causale"                   = $_.Causale              
            $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
            $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
            $row."Documento_id"              = 0          
            $row."TipoDocumento"             = "N/D"
            $row."Gruppo"                    = $_.Gruppo
            $row."IsOK"                      = 0
            $row."Paperless"                 = 1
            $row."DettaglioProdotti"         = $_.DettaglioProdotti
            $row."TipologiaProdotti" = $_.TipoDispositiva
            $TempStampa.rows.add($row)           
          }

    }

#if($foldername -ne "MAXFUNDS"){
#Remove-Item $filepathblankpage
##Remove-Item  "$scratchSubDir\$data-$ora-$foldername" -Recurse -Force
#}

Remove-Item $filepathblankpage
#Remove-Item "$scratchSubDir\$data-$ora-$foldername"

} #if flagimbarcatestapacco

########## FINE IMBARCO TESTAPACCO ########################


} #foreach PAPERLESS

if($flag_documents_merge -eq 1){ 

    $mergingdirs = $Datatable | Where-Object {$_.IsOk -eq 1} | where EstensioneFileOutput -Match ".pdf" | select NomeFileOutput, EstensioneFileOutput, Gruppo -Unique
    
    #$mergingdirs

    foreach($mergingdir in $mergingdirs){

    $foldername = $null 
    $foldername = $_.Gruppo

    $workdir = $null
    $workdir = "$scratchSubDir\$data-$ora-$foldername\$($mergingdir.NomeFileOutput)"

    mkdir $workdir

    #$workdir

    $attachments = $Datatable | Where-Object {$_.IsOk -eq 1} | where NomeFileOutput -Match $($mergingdir.NomeFileOutput)
    $incarico = $Datatable | Where-Object {$_.IsOk -eq 1} | where NomeFileOutput -Match $($mergingdir.NomeFileOutput) | select  IdIncarico, EstensioneFileOutput, Gruppo  -Unique

    "$scratchSubDir\$data-$ora-$foldername\$($incarico.IdIncarico)$($incarico.EstensioneFileOutput)"

    Copy-Item "$scratchSubDir\$data-$ora-$foldername\$($incarico.IdIncarico)$($incarico.EstensioneFileOutput)" $workdir
    Remove-Item  "$scratchSubDir\$data-$ora-$foldername\$($incarico.IdIncarico)$($incarico.EstensioneFileOutput)" -Recurse

    foreach($attachment in $attachments){

    Copy-Item "$scratchSubDir\$data-$ora-$foldername\$($attachment.Nome_file)" "$workdir\$($attachment.Nome_file)"
    Remove-Item  "$scratchSubDir\$data-$ora-$foldername\$($attachment.Nome_file)" -Recurse

    }

    $Files = $null
    $files = Get-ChildItem $workdir
    #$files
    $NFiles = $null
    $NFiles = ($Files | Measure-Object).count
    $OutputFile = $null
    $OutputFile = "$scratchSubDir\$data-$ora-$foldername\$($mergingdir.NomeFileOutput)$($mergingdir.EstensioneFileOutput)"

    if($NFiles -eq 1){
    
    Move-Item "$workdir\$($attachment.Nome_file)" $OutputFile
    Remove-Item $workdir               

    }
    
    if($NFiles -gt 1){

   pushd $workdir
   try{
        Write-Host $workdir -ForegroundColor Green
        if($flagmergepython -eq 0){
            Merge-pdf -workingDirectory $workdir -fileOutPut $OutputFile
        }else{
            $mergingPython = python $MergePDFPython $workdir $OutputFile
            if($mergingPython -ne "OK"){
                throw $_
                $error = $mergingPython
            }
        }
        }catch{ throw $_}finally{
   popd }

    Remove-Item $workdir -Recurse

    }

     }

} #close if documents merge


if($flag_raggruppa_15 -eq 1){


#MoveTo-folder -filesperfolder 50 -sourcePath $scratchSubDir -destPath $scratchSubDir

}

if($flag_mergefoldersinpdf -eq 1){

$listfolders = $null
$listfolders = Get-ChildItem $scratchSubDir -Recurse | ?{$_.PSIsContainer} 
$folder = $null
foreach($folder in $listfolders){

    $Files = $null
    $files = Get-ChildItem $folder.FullName
    $NFiles = $null
    $NFiles = ($Files | Measure-Object).count

    $outputfolderfile = $null
    $outputfolderfile = "$scratchSubDir\$($folder.Name).pdf"
    
    if($NFiles -eq 1){

    $file = $null
    $file = Get-ChildItem $($folder.FullName) | ForEach-Object {Move-Item $_.FullName $outputfolderfile}

    Remove-Item $($folder.FullName)

    }
    
    if($NFiles -gt 1){

       pushd $($folder.FullName)
   try{
        Write-Host $($folder.FullName) -ForegroundColor DarkYellow
        #Get-ChildItem $folder.FullName
        if($flagmergepython -eq 0){
            Merge-pdf -workingDirectory $($folder.FullName) -fileOutPut $outputfolderfile
        }else{
            $mergingPython =  python $MergePDFPython $($folder.FullName) $outputfolderfile
            if($mergingPython -ne "OK"){
                throw $_
                $error = $mergingPython
            }
        }
        }catch{ throw $_}finally{
   popd }

    Remove-Item $($folder.FullName) -Recurse


    }


    }


}

if($flag_producicsv -eq 1){

$TempStampa | export-csv -Delimiter ";" -NoTypeInformation -Path "$scratchSubDir\$data-$ora-lista.csv"

}




if($flag_create_zip -eq 1){

$zipfolder = $null
$zipfolder = "$scratchDir\$data-$ora.zip"
# zip folder
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($scratchSubDir, $zipfolder)

}


} #close flag_documents_download

if($flag_remove_work_folder -eq 1){

Remove-Item $scratchSubDir -Recurse -force

}


if($flag_trasferisci_transferagent -eq 1){

if($flag_create_zip -eq 1){
$zipfolder_name = $null
$zipfolder_name = $zipfolder | Split-Path -Leaf

if(Test-Path "$($destinazione)\$zipfolder_name"){
    Remove-Item "$($destinazione)\$zipfolder_name" -Recurse -Force
}

Move-Item $zipfolder "$($destinazione)\$zipfolder_name"
}else{

    $TempStampa | export-csv -Delimiter ";" -NoTypeInformation -Path "$($destinazione)\$data-$ora-lista.csv"

}



} #close if trasferisci TA
 



if($flag_esegui_transizioni -eq 1){

$listatransizioni = $null
$attributodestinazione = $null
$attributodestinazione = 17473

$statoworkflow = $null
$statoworkflow = 20606 

$listatransizioni = $TempStampa | Where-Object{$_.IsOK -eq 1}  | Select-Object IdIncarico -Unique
$listatransizioni | ForEach-Object {

$idincarico = $null
$idincarico = $_.IdIncarico


if(-not ([string]::IsNullOrEmpty($statoworkflow))){
 
#transizione
 $servicePoint.CloseConnectionGroup("")
 $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)

 $datiincarico = $null
 $datiincarico = Invoke-RestMethod -ContentType "application/json" -Method Get -uri "$urlBase/Incarico/$idincarico" -Headers $headers

 write-host "Stato Workflow Corrente IdIncarico $idincarico --> $( $datiincarico.CodStatoWorkflowIncarico)" -ForegroundColor Cyan

 if($datiincarico.CodStatoWorkflowIncarico -ne $statoworkflow){
    
    $servicePoint.CloseConnectionGroup("")
    $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
    
    Invoke-RestMethod -ContentType "application/json" -Method PUT -Uri "$urlBase/Incarico/$idincarico/statoWorkflow/$statoworkflow" -Headers $headers -Verbose
    
    $servicePoint.CloseConnectionGroup("")
  }

#Write-Host $_.WorkflowDestinazione -ForegroundColor Yellow



}

if(-not ([string]::IsNullOrEmpty($attributodestinazione))){

#attributo
$attributo = $null
$attributo = $attributodestinazione

 $servicePoint.CloseConnectionGroup("")
                   $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
                   Invoke-RestMethod -ContentType "application/json" -Method PUT -Uri "$urlBase/Incarico/$idincarico/attributo/$attributo" -Headers $headers -Verbose
                   
                    $servicePoint.CloseConnectionGroup("")


}


} #close foreach



} #close if esegui transizione
$MessaggioErrore = ""
} catch{

$error

$MessaggioErrore = $error
$log += $error

if($flag_esegui_transizioni -eq 1){
$ConnectionObject.Open()

    $TempStampa | Select-Object IdMovimentoContoBancario -Unique | ForEach-Object{
    
        Write-Host "Esegui Rollback IdMovimento $($_.IdMovimentoContoBancario)" -ForegroundColor Yellow        
        exec-salvariconcilia -idmovimentocontobancario $_.IdMovimentoContoBancario -notaaggiuntiva "Rollback Stampa" -inseriscitr 0 -flagriconciliato 0 -eliminadatr 0 -idincarico 0 -flagconfermato 0 
        $log += "Eseguito Rollback IdMovimento $($_.IdMovimentoContoBancario)"
    }

$ConnectionObject.close()
}
}finally{
$log | Out-File $logfile

$csvfile = "$(Split-Path $($MyInvocation.MyCommand.path))\LISTE\$data-$ora-lista.csv"
$TempStampa | Export-Csv -Delimiter ";" -NoTypeInformation -Path $csvfile
$TempStampa.clear()

$mailBody=@"
$MessaggioErrore
Log in allegato.

Server: $env:COMPUTERNAME
ScriptPath: $($MyInvocation.MyCommand.Path)

"@

if(-not [string]::IsNullOrEmpty($MessaggioErrore)){

$mailSubject="[Error] - Stampa riconciliatore"
Write-Host "$mailSubject $MessaggioErrore" -ForegroundColor Red

}else{
$mailSubject= "[Success] - Stampa riconciliatore"
Write-Host $mailSubject -ForegroundColor Green
}

$mailParams =@{}

$conf.mailing  | Get-Member -MemberType NoteProperty | %{
    $mailParams.Add($_.name,$conf.mailing."$($_.name)")
}

$mailParams.Add("Body",$mailbody)
$mailParams.Add("Subject",$mailSubject)

#$mailFrom=$($conf.mailing.from)
#$mailTo=$($conf.mailing.to)
#$mailCC=$($conf.mailing.cc)
#$mailSmtp=$($conf.mailing.smtp)

Send-MailMessage @mailParams -Encoding utf8 -Attachments $logfile, $csvfile

}
}
#>