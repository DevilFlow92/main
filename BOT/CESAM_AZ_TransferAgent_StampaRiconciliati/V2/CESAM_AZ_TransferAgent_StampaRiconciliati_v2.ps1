Clear-Host
$Error.Clear()

#$jobRatePac = Start-Job { C:\ScriptAdminRoot\Execute\AZIMUT\RICONCILIATORE\CESAM_AZ_Riconciliatore_PAC\CESAM_AZ_Riconciliatore_PAC.ps1 }
#Wait-Job $jobRatePac


$error.Clear()

$ErrorActionPreference = "stop"
$MessaggioErrore = $null
$segnalaerrore = 0

################## PANNELLO DI CONTROLLO #######################################

$test = 0 
$locale = 0

################################################################################


################# CONFIGURAZIONI [INIZIO] ######################################

$jsonPath = $($MyInvocation.MyCommand.path) -replace "ps1", "json"
$conf=gc $jsonPath | Out-String | ConvertFrom-Json -Verbose

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
$destinazione = $conf.Destinazione.pathLocale

}else{
$destinazione = $conf.Destinazione.pathServer
}

################## CONFIGURAZIONI [FINE] #######################################


############# FUNZIONI [INIZIO] ##########################################################################################

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

############# FUNZIONI [FINE] ##########################################################################################


############################ AUTENTICAZIONE BES (PER LE WEBAPI) #######################################################################

$servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
$headerToken =Invoke-RestMethod –Uri "$urlBase/Autenticazione/NomeHeaderTokenSessione"
$credenziali = @{ Username = $User; Password = $Password} | ConvertTo-Json
$token = Invoke-RestMethod -ContentType "application/json" -Method Post -Uri "$urlBase/Autenticazione/Autentica" -Body $credenziali
$headers = @{"$headerToken" = $token }
$sessione = Invoke-RestMethod -ContentType "application/json" -Method Get -Uri "$urlBase/Autenticazione/Sessione" -Headers $headers

############################ FINE AUTENTICAZIONE BES (PER LE WEBAPI)  #################################################################


############################ CONNESSIONE DB ###########################################################################################

$StringaConnessione = "Server=$($conn);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
$ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
$Comando = New-Object System.Data.SqlClient.SqlCommand 

#######################################################################################################################################



############################ CARICAMENTO DATI [INIZIO] ################################################################################

#tabella che viene popolata all'esecuzione della vista
$Datatable = New-Object System.Data.DataTable 

$Query =   @"
SELECT StampaRiconciliati.IdIncarico
	  ,StampaRiconciliati.CodTipoIncarico
	  ,StampaRiconciliati.IdMovimentoContoBancario
	  ,StampaRiconciliati.Importo
	  ,StampaRiconciliati.ImportoIncarichi
	  ,StampaRiconciliati.DataValuta
	  ,StampaRiconciliati.DataContabile
	  ,StampaRiconciliati.IbanOrdinante
	  ,StampaRiconciliati.Abi
	  ,StampaRiconciliati.Cab
	  ,StampaRiconciliati.NumeroConto
	  ,StampaRiconciliati.RiferimentoOrdinante
	  ,StampaRiconciliati.Causale
	  ,StampaRiconciliati.NotaAggiuntiva
	  ,StampaRiconciliati.Gruppo
	  ,StampaRiconciliati.FlagErroreRiconciliazione
	  ,StampaRiconciliati.DettaglioProdotti
	  ,StampaRiconciliati.FlagPaperless
	  ,StampaRiconciliati.n
	  ,StampaRiconciliati.IsFEQ
	  ,StampaRiconciliati.FlagParziale
	  ,StampaRiconciliati.dataconferma
	  ,StampaRiconciliati.TipoDispositiva
	  ,StampaRiconciliati.CodStatoWorkflowIncaricoDestinazione
	  ,StampaRiconciliati.CodAttributoIncaricoDestinazione 
FROM rs.v_CESAM_AZ_TransferAgent_StampaRiconciliati_V2 StampaRiconciliati
ORDER BY StampaRiconciliati.IdIncarico, StampaRiconciliati.IdMovimentoContoBancario

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

$Datatable | Add-Member -MemberType NoteProperty -Name "Transizioni" -Value $null
$Datatable | Add-Member -MemberType NoteProperty -Name "ModificaDB" -Value $null

############################ CARICAMENTO DATI [FINE] ##################################################################################


############################ OGGETTO TEMPORANEO PER RENDICONTO FILE [INIZIO] ##########################################################

$TempStampa = @()
$TempStampa = New-Object System.Data.DataTable 
 $column1 = New-Object System.Data.DataColumn "IdIncarico",([INT])
 $TempStampa.Columns.Add($column1)

 $column2 = New-Object System.Data.DataColumn "Transizioni",([INT])
 $TempStampa.Columns.Add($column2)

 $column3 = New-Object System.Data.DataColumn "ModificaDB", ([INT])
 $TempStampa.Columns.Add($column3)

 $column4 = New-Object System.Data.DataColumn "Importo",([DECIMAL])
 $TempStampa.Columns.add($column4)

 $column5 = New-Object System.Data.DataColumn "DataValuta",([STRING])
 $TempStampa.Columns.Add($column5)

 $column6 = New-Object System.Data.DataColumn "DataContabile",([STRING])
 $TempStampa.Columns.Add($column6)

 $column7 = New-Object System.Data.DataColumn "ABI",([STRING])
 $TempStampa.Columns.Add($column7)

 $column8 = New-Object System.Data.DataColumn "CAB",([STRING])
 $TempStampa.Columns.Add($column8)

 $Column9 = New-Object System.Data.DataColumn "NumeroConto",([STRING])
 $TempStampa.Columns.Add($COLUMN9)

 $column10 = New-Object System.Data.DataColumn "RiferimentoOrdinante",([STRING])
 $TempStampa.Columns.Add($column10)

 $column11 = New-Object System.Data.DataColumn "Causale",([STRING])
 $TempStampa.Columns.Add($column11) 

 $column12 = New-Object System.Data.DataColumn "NotaUfficioBonifici",([STRING])
 $TempStampa.Columns.Add($column12)

 $column13 = New-Object System.Data.DataColumn "IdMovimentoContoBancario",([INT])
 $TempStampa.Columns.Add($column13)

 $column14 = New-Object System.Data.DataColumn "Gruppo",([STRING])
 $TempStampa.Columns.ADD($column14)

 $column15 = New-Object System.Data.DataColumn "DettaglioProdotti",([STRING])
 $TempStampa.Columns.ADD($column15)

 $column16 = New-Object System.Data.DataColumn "TipologiaProdotti", ([string])
 $TempStampa.Columns.ADD($column16)


############################ OGGETTO TEMPORANEO PER RENDICONTO FILE [FINE] ##########################################################


############################ PROCESSO [INIZIO] ####################################################################################

$Incarichi = $Datatable | Select-Object IdIncarico, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione -Unique

foreach ($i in $Incarichi){

$attributodestinazione = $null
$attributodestinazione = $i.CodAttributoIncaricoDestinazione

$statoworkflow = $null
$statoworkflow = $i.CodStatoWorkflowIncaricoDestinazione
$idincarico = $null
$idincarico = $i.IdIncarico

$transizioni = 0

    try{
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
        } #if stato attuale != $statoworkflow
    
        
        #attributo
        $attributo = $null
        $attributo = $attributodestinazione

        $servicePoint.CloseConnectionGroup("")
        $servicePoint = [System.Net.ServicePointManager]::FindServicePoint($urlBase)
        Invoke-RestMethod -ContentType "application/json" -Method PUT -Uri "$urlBase/Incarico/$idincarico/attributo/$attributo" -Headers $headers -Verbose        
        $servicePoint.CloseConnectionGroup("")    
    
        $transizioni = 1
    }catch{
        $MessaggioErrore = $Error

    }finally{
        if($transizioni -eq 1){
            $Datatable | Where-Object{$_.IdIncarico -eq $idincarico} | ForEach-Object{
                $modificadb = 0
                $codtipoincarico = $null
                $codtipoincarico = $_.CodTipoIncarico

                if($codtipoincarico -eq 693){
                    $Paperless = "Paperless_PAC"
                }else{
                    $Paperless = "Paperless"
                }

                try{
                    $ConnectionObject.Open()
                    exec-salvariconcilia -inseriscitr 0 -eliminadatr 0 -idincarico 0 -idmovimentocontobancario $_.IdMovimentoContoBancario -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $Paperless
                    $modificadb = 1
                    $ConnectionObject.Close()
                }catch{
                    $MessaggioErrore = $Error
                    $segnalaerrore = 1

                }finally{
                    if($modificadb -eq 1){
                       $row = $null
                        $row = $TempStampa.NewRow()
                        $row."IdIncarico"                = $idincarico
                        $row."Transizioni"               = 1
                        $row."ModificaDB"                = 1       
                        $row."Importo"                   = $_.Importo             
                        $row."DataValuta"                = $_.DataValuta           
                        $row."DataContabile"             = $_.DataContabile         
                        $row."ABI"                       = $_.ABI                  
                        $row."CAB"                       = $_.CAB     
                        $ROW."NumeroConto"               = $_.NumeroConto                
                        $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
                        $row."Causale"                   = $_.Causale              
                        $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
                        $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
                        $row."Gruppo"                    = $_.Gruppo
                        $row."DettaglioProdotti"         = $_.DettaglioProdotti
                        $row."TipologiaProdotti"         = $_.TipoDispositiva
                        $TempStampa.rows.add($row)  

                    }else{
                        
                        $row = $null
                        $row = $TempStampa.NewRow()
                        $row."IdIncarico"                = $idincarico
                        $row."Transizioni"               = 1
                        $row."ModificaDB"                = 0      
                        $row."Importo"                   = $_.Importo             
                        $row."DataValuta"                = $_.DataValuta           
                        $row."DataContabile"             = $_.DataContabile         
                        $row."ABI"                       = $_.ABI                  
                        $row."CAB"                       = $_.CAB     
                        $ROW."NumeroConto"               = $_.NumeroConto                
                        $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
                        $row."Causale"                   = $_.Causale              
                        $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
                        $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
                        $row."Gruppo"                    = $_.Gruppo
                        $row."DettaglioProdotti"         = $_.DettaglioProdotti
                        $row."TipologiaProdotti"         = $_.TipoDispositiva
                        $TempStampa.rows.add($row) 
                    } #if modificadb

                } #finally (secondo)

            } #ForEach-Object $Datatable 1

        }else{
            $Datatable | Where-Object{$_.IdIncarico -eq $idincarico} | ForEach-Object{
                $row = $null
                $row = $TempStampa.NewRow()
                $row."IdIncarico"                = $idincarico
                $row."Transizioni"               = 0
                $row."ModificaDB"                = 0      
                $row."Importo"                   = $_.Importo             
                $row."DataValuta"                = $_.DataValuta           
                $row."DataContabile"             = $_.DataContabile         
                $row."ABI"                       = $_.ABI                  
                $row."CAB"                       = $_.CAB     
                $ROW."NumeroConto"               = $_.NumeroConto                
                $row."RiferimentoOrdinante"      = $_.RiferimentoOrdinante   
                $row."Causale"                   = $_.Causale              
                $row."NotaUfficioBonifici"       = $_.NotaUfficioBonifici    
                $row."IdMovimentoContoBancario"  = $_.IdMovimentoContoBancario
                $row."Gruppo"                    = $_.Gruppo
                $row."DettaglioProdotti"         = $_.DettaglioProdotti
                $row."TipologiaProdotti"         = $_.TipoDispositiva
                $TempStampa.rows.add($row)
            } #foreach
            $segnalaerrore = 1
        } #if transizioni

    } #finally (primo)

} #foreach incarichi


############################ PROCESSO [FINE] ######################################################################################


############################ CREAZIONE ED INVIO RESOCONTO [INIZIO] ################################################################
$data = $null
$data = Get-Date -Format "dd-MM-yyyy"
$ora = $null
$ora = Get-Date -Format "HH-mm"

$TempStampa | export-csv -Delimiter ";" -NoTypeInformation -Path "$destinazione\$data-$ora-report riconciliato movimento.csv"
$TempStampa.Clear()

$mailBody = @"
In allegato report delle notifiche riconciliato movimento (ex stampa TA) per i bonifici
di AZFund1.

Interpretazione dei record:
- Transizioni = 1, ModificaDB = 1 --> tutto OK, nessun intervento da effettuare.
- Transizioni = 0, ModificaDB = 0 --> tutto KO, effettuare transizioni mancanti (workflow 20606 e/o attributo 17473) ed eseguire "Query Riciclo Movimenti non modificati.sql" su idmovimentocontobancario
- Transizioni = 1, ModificaDB = 0 --> andata in errore la modifica nota aggiuntiva. Eseguire "Query Riciclo Movimenti non modificati.sql" su idmovimentocontobancario

Server: $env:COMPUTERNAME
ScriptPath: $($MyInvocation.MyCommand.Path)
"@

if($segnalaerrore -eq 1){
    $mailSubject="[Error] - Stampa riconciliatore"
    Write-Host "$mailSubject $MessaggioErrore" -ForegroundColor Red
}else{
    $mailSubject= "[Success] - Stampa riconciliatore"
    Write-Host $mailSubject -ForegroundColor Green
} #if segnalaerrore

$mailParams =@{}

$conf.mailing  | Get-Member -MemberType NoteProperty | %{
    $mailParams.Add($_.name,$conf.mailing."$($_.name)")
}

$mailParams.Add("Body",$mailbody)
$mailParams.Add("Subject",$mailSubject)

$csvfile = "$destinazione\$data-$ora-report riconciliato movimento.csv"

Send-MailMessage @mailParams -Encoding utf8 -Attachments $csvfile

############################ CREAZIONE ED INVIO RESOCONTO [FINE] ################################################################
