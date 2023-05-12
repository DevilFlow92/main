<#


4. storicizzare tutte le riconciliazioni, in modo da non riproporle - anche se l'operatore le disassocia


IMPORTANTE: 

-- aggiungere un ciclo che cicla su tutti gli incarichi associati ad una contabile e flag riconciliato = 0 and statusworkflow = 1 
        su questi deve essere fatto update soltanto nella contabile associata - quindi modificare anche la sp di salvataggio per NON inserire nella TRincaricomovimentocontobancario

cercare per #modificato per trovare le modifiche
            #LS 22062020 != Mandato

#>

Clear-Host
$start = Get-Date

$MessaggioErrore = $null

$jsonPath = $($MyInvocation.MyCommand.path) -replace "ps1", "json"
$conf=gc $jsonPath | Out-String | ConvertFrom-Json

$Error.Clear()
$ErrorActionPreference = "stop"


############# PANNELLO DI CONTROLLO #############

$TEST = 0 # 0 punta al server di produzione, 1 punta al server di test interno

$flaginserisciadb = 1 #
$flageseguimodificacontabili = 1 #
$flagmodificariconciliato = 1 #
$flaginseriscitemplatenotaaggiuntiva = 1 #
$flagriconciliapac = 1 #
$flagestraisospesi = 1 #

$flagvisualizzaparametririconciliazione = 0

$mandamail = 0 #

#################################################



$flag_connettisql = 1
$flag_estraimovimenti = 1
$flag_estraiincarichi = 1
$flag_eseguiriconciliazione = 1
$livelliRiconciliazione = 5
$logicariconciliazionesingoloconto = 1
$flageliminaprecedentiriconciliazioniserictipo1 = 1
$flagabilitacontrolloordinantebeneficiario = 1



$nomescript = [System.IO.Path]::GetFileNameWithoutExtension($jsonPath) 

if($TEST -eq 1){
$connection = $conf.SQLConnection.istanzaTest
$user = $conf.WebAPI.userTest
$Password = $conf.WebAPI.pwdTest
$urlBase = $conf.WebAPI.urlTest

}else{
$connection = $conf.SQLConnection.istanza
$user = $conf.WebAPI.user
$Password = $conf.WebAPI.pwd
$urlBase = $conf.WebAPI.url
}

$log = @()

$scratchname = $nomescript
$scratchDir="$env:TEMP\$scratchname"
if(-not (Test-Path $scratchDir)){
    mkdir $scratchDir | Out-Null
}


$file_risultatiriconciliazione = "$scratchDir\r_$($nomescript)_$($dateformat).csv"
$file_log = "$scratchDir\l_$($nomescript)_$($dateformat).txt"

#Funzione sostituisci accenti e altri caratteri speciali

function get-sanitizedUTF8Input{
    Param(
        [String]$inputString
    )
    #Tabella dei campi sostituibili
    $replaceTable = @{"ß"="ss";"à"="a";"á"="a";"â"="a";"ã"="a";"ä"="a";"å"="a";"æ"="ae";"ç"="c";"è"="e";"é"="e";"ê"="e";"ë"="e";"ì"="i";"í"="i";"î"="i";"ï"="i";"ð"="d";"ñ"="n";"ò"="o";"ó"="o";"ô"="o";"õ"="o";"ö"="o";"ø"="o";"ù"="u";"ú"="u";"û"="u";"ü"="u";"ý"="y";"þ"="p";"ÿ"="y"
                       ;"o'"="o";"a'"="a";"e'"="e";"i'"="i";"u'"="u"
                     }

    foreach($key in $replaceTable.Keys){
        $inputString = $inputString -Replace($key,$replaceTable.$key)
    }
    return $inputString
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

function logica-riconciliazione (
$statusworkflow
,$idmovimentocontabile
,$tiporiconciliazione
,$idincarico
,$inseriscitr
,$notacontabile
,$eliminadatr
,$testocontabile
){


if($inseriscitr -eq 1){
    if($tiporiconciliazione-eq 1){
    
        if($statusworkflow -eq 0){ 

        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                         
        
        
        }else{

        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                 
        }
        
    
    }
    
    if($tiporiconciliazione -eq 2){
      if($statusworkflow -eq 0){
       
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                   
        
        
        }else{
       
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                    
        
        }
    
    
    }

    if($tiporiconciliazione -eq 3){
      if($statusworkflow -eq 0){
       
        exec-salvariconcilia -inseriscitr 0 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                    
        
        
        }else{
       
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                  
        
        }
    
    
    }

    if($tiporiconciliazione -eq 8){
      if($statusworkflow -eq 0){
       
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva "altrocc-$idincarico"  -sp_tiporiconciliazione $tiporiconciliazione                             
        
        
        }else{
       
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva "altrocc-$idincarico"  -sp_tiporiconciliazione $tiporiconciliazione                              
        
        }
    
    
    }
    
    if($tiporiconciliazione -eq 5){
      if($statusworkflow -eq 0){
        
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                 
        
        
        }else{
        
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                 
        }
        
       
    }
    
    if($tiporiconciliazione -eq 6){
    
        #LS 22062020 != Mandato
        if($notacontabile -match "!= Mandato") {
            exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                 
        } else {

    if($statusworkflow -eq 0){
        
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                 
        
        
        }else{
        
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva $notacontabile -sp_tiporiconciliazione $tiporiconciliazione                                 
        }
    
    
    }
    }
    

    if($tiporiconciliazione -eq 7){ #ordinante diverso da esecutore
    
    if($statusworkflow -eq 0){
        
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva "Ord!=Esec" -sp_tiporiconciliazione $tiporiconciliazione                               
        
        
        }else{
        
        exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva "Ord!=Esec"   -sp_tiporiconciliazione $tiporiconciliazione                             
        }
    
    
    
    
    }

    if($tiporiconciliazione -eq 9){
             
            exec-salvariconcilia -inseriscitr 1 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva "$notacontabile" -sp_tiporiconciliazione $tiporiconciliazione

     }
    

}else{
    
    if($notacontabile -and $notacontabile -notmatch "PAC"){
        if($notacontabile -notmatch "GIROCONTO"){
            exec-salvariconcilia -inseriscitr 0 -idincarico 0 -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 1 -notaaggiuntiva "$notacontabile"
        }else{
            exec-salvariconcilia -inseriscitr 0 -idincarico 0 -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva "$notacontabile"
        }
    }
    
    if($eliminadatr -eq 0){
  exec-salvariconcilia -inseriscitr 0 -idincarico 0 -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 1 -flagconfermato 0 -notaaggiuntiva "r"                               
        }

    if($eliminadatr -eq 1){
    
    exec-salvariconcilia -eliminadatr 1 -inseriscitr 0 -idincarico $idincarico -idmovimentocontobancario $idmovimentocontabile -flagriconciliato 0 -flagconfermato 0 -notaaggiuntiva ""                               
 

    }

}

}

function estrai-residui(
$connection,
$database,
$pac
){
$StringaConnessione = "Server=$($connection);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
$ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)

$Datatable_Residui = @()
$Datatable_Residui = New-Object System.Data.DataTable

$Comando = New-Object System.Data.SqlClient.SqlCommand

if($pac -eq 1){
$Query = @"
SELECT T_MovimentoContoBancario.IdMovimentoContoBancario
	  ,T_MovimentoContoBancario.IdContoBancarioPerAnno
	  ,T_MovimentoContoBancario.CodTipoMovimentoContoBancario
	  ,T_MovimentoContoBancario.DataValuta
	  ,T_MovimentoContoBancario.IdOperazioneContoBancario
	  ,T_MovimentoContoBancario.Importo
	  ,T_MovimentoContoBancario.IdNotaIncarichi
      ,T_NotaIncarichi.Testo
	  ,T_MovimentoContoBancario.DataOperazione
	  ,T_MovimentoContoBancario.DataImport
	  ,T_MovimentoContoBancario.NotaAggiuntiva
	  ,T_MovimentoContoBancario.FlagRiconciliato
	  ,T_MovimentoContoBancario.FlagConfermato
	  ,T_MovimentoContoBancario.FlagAttivo
	  ,T_MovimentoContoBancario.DataRiconciliazione
	  ,T_MovimentoContoBancario.DataConferma
	  ,T_MovimentoContoBancario.CodiceTipoRiconciliazione
      ,NULL CodiceCausale
      ,NULL TemplateNotaAggiuntiva
	  
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND Anno = YEAR(GETDATE())
and flagattivo = 1
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
JOIN T_NotaIncarichi ON T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi
WHERE T_ContoBancario.NumeroConto = '802260103'

AND FlagRiconciliato = 0
AND FlagConfermato = 0
AND CodiceTipoRiconciliazione IS NULL
AND ( NotaAggiuntiva = '* *' or NotaAggiuntiva = '')
AND DataRiconciliazione IS NULL

"@
}else{

$Query = @"
SELECT 
    T_MovimentoContoBancario.IdMovimentoContoBancario
	  ,T_MovimentoContoBancario.IdContoBancarioPerAnno
	  ,T_MovimentoContoBancario.CodTipoMovimentoContoBancario
	  ,T_MovimentoContoBancario.DataValuta
	  ,T_MovimentoContoBancario.IdOperazioneContoBancario
	  ,T_MovimentoContoBancario.Importo
	  ,T_MovimentoContoBancario.IdNotaIncarichi
      ,T_NotaIncarichi.Testo
	  ,T_MovimentoContoBancario.DataOperazione
	  ,T_MovimentoContoBancario.DataImport
	  ,T_MovimentoContoBancario.NotaAggiuntiva
	  ,T_MovimentoContoBancario.FlagRiconciliato
	  ,T_MovimentoContoBancario.FlagConfermato
	  ,T_MovimentoContoBancario.FlagAttivo
	  ,T_MovimentoContoBancario.DataRiconciliazione
	  ,T_MovimentoContoBancario.DataConferma
	  ,T_MovimentoContoBancario.CodiceTipoRiconciliazione
	  ,CodiceCausale
	  ,CASE WHEN CodiceCausale = 'Zibe' THEN '[* * Bonifico Estero]'
		ELSE '* *'
		END TemplateNotaAggiuntiva

FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND Anno = YEAR(GETDATE())
and flagattivo = 1
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
JOIN S_OperazioneContoBancario ON T_MovimentoContoBancario.IdOperazioneContoBancario = S_OperazioneContoBancario.IdOperazioneContoBancario
JOIN T_NotaIncarichi on T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi
WHERE T_ContoBancario.NumeroConto = '802260103'
AND FlagRiconciliato = 0
AND FlagConfermato = 0
AND NotaAggiuntiva = ''
AND CodiceTipoRiconciliazione IS NULL
AND DataRiconciliazione IS NULL

"@
}

$ConnectionObject.open()
$Comando = $ConnectionObject.CreateCommand()
$Comando.CommandText = $Query
$Comando.CommandTimeout = 200
$Dataset_Residui = $null
$Dataset_Residui = $Comando.ExecuteReader()

$Datatable_Residui.load($Dataset_Residui)

$ConnectionObject.close()

return $Datatable_Residui

}

function estraisospesi(
$connection,
$database
){
$StringaConnessione = "Server=$($connection);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
$ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
$Datatable_sospesi = @()
$Datatable_sospesi = New-Object System.Data.DataTable

$Comando = New-Object System.Data.SqlClient.SqlCommand
$query = @"
SELECT NotaAggiuntiva, IdMovimentoContoBancario
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND Anno = YEAR(GETDATE())
and FlagAttivo = 1
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND NumeroConto = '802260103'

WHERE FlagConfermato = 0
AND DataImport < CONVERT(DATE,GETDATE())
AND NotaAggiuntiva NOT LIKE '%{Intranet}%'

"@

$ConnectionObject.open()
$Comando = $ConnectionObject.CreateCommand()
$Comando.CommandText = $Query
$Comando.CommandTimeout = 200
$Dataset_sospesi = $null
$Dataset_sospesi = $Comando.ExecuteReader()

$Datatable_sospesi.load($Dataset_sospesi)

$ConnectionObject.close()

return $Datatable_sospesi

}


try{

if($flag_connettisql -eq 1){

 # connessione a sql 

 $StringaConnessione = "Server=$($connection);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
 $ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
 $Comando = New-Object System.Data.SqlClient.SqlCommand

 If($flagestraisospesi -eq 1){
    ################################################### ESTRAI SOSPESI ############################################################
    $Datatable_movimenti_sospesi = estraisospesi -connection $connection -database $($conf.SQLConnection.database) #| Select-Object IdMovimentoContoBancario -First 5
    foreach($r in $Datatable_movimenti_sospesi){
    $ConnectionObject.Open()
    $r.IdMovimentoContoBancario
    exec-salvariconcilia -idmovimentocontobancario $r.IdMovimentoContoBancario -notaaggiuntiva "Intranet" -inseriscitr 0 -eliminadatr 0 -idincarico 0 -flagriconciliato 0 -flagconfermato 0 
    $ConnectionObject.Close()
    }

    ################################################### FINE ESTRAI SOSPESI #######################################################
 }

if($flag_estraimovimenti -eq 1){
write-host "Estrai movimenti" -ForegroundColor Green
$log += "Estrai movimenti"
 #tabella che viene popolata all'esecuzione della vista
 $Datatable_movimenti = @()
 $Datatable_movimenti = New-Object System.Data.DataTable 
 
$Query_movimenti =   @"


SELECT 	ElencoMovimenti.ImportoIncarichiAssociati,
		ElencoMovimenti.NonRiconciliatoMaAssociatoCorrettamente,
		ElencoMovimenti.IdContoBancario,
		ElencoMovimenti.DataImport,
		ElencoMovimenti.DataValuta,
		ElencoMovimenti.IdContoBancarioPerAnno,
		ElencoMovimenti.NomeConto,
		ElencoMovimenti.ProdottoConto,
		ElencoMovimenti.NumeroConto,
		ElencoMovimenti.IdMovimentoContoBancario,
		ElencoMovimenti.SegnoImporto,
		ElencoMovimenti.Importo,
		ElencoMovimenti.NomeOperazione,
		ElencoMovimenti.IdOperazioneContoBancario,
		ElencoMovimenti.Testo,
		ElencoMovimenti.Gruppo,
		ElencoMovimenti.Gruppo_Automatismo,
		ElencoMovimenti.FlagEseguiControlloOrdinanteBeneficiario,
        ElencoMovimenti.FlagRiconciliato,
        ElencoMovimenti.CodiceTipoRiconciliazione,
        ElencoMovimenti.NotaAggiuntiva,
        ElencoMovimenti.CodiceCausale,
        ElencoMovimenti.FlagModificaCognomeNome
        FROM rs.v_CESAM_Rendicontazione_BNP_ElencoMovimenti  ElencoMovimenti
where ( ElencoMovimenti.Gruppo_Automatismo is null or ElencoMovimenti.Gruppo_Automatismo != 'REINV.DIVIDENDI' )
ORDER BY IdMovimentoContoBancario ASC
		


"@
    
    #apro la connessione a sql
 $ConnectionObject.Open()
 
 $Comando = $ConnectionObject.CreateCommand()
 $Comando.CommandTimeout = 500
 $Comando.CommandText = $Query_movimenti
 
 $DataSetDiRitorno = $null
 $DataSetDiRitorno = $Comando.ExecuteReader()
 

 $DataTable_movimenti.Load($DataSetDiRitorno)
    #chiudo la connessione a sql

 $ConnectionObject.close()

    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "IsRiconciliato" -Value 0
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "TipoRiconciliazione" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "IdIncarico" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "Prodotto" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "Cognome" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "Nome" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "RagioneSociale" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "ImportoIncarico" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "NumeroMandato" -Value $null
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "SommaPerCognomeNome" -Value $null
    #LS 22062020 != Mandato
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "CheckFalseMandato" -Value 0  
    $Datatable_movimenti | Add-Member -MemberType NoteProperty -Name "TestoCognomeNome" -Value $null

    
    $Datatable_movimenti  = $Datatable_movimenti | 
        Select-Object IsRiconciliato,
        TipoRiconciliazione,
        IdIncarico,Prodotto,ProdottoConto,
        Cognome,
        Nome,
        RagioneSociale,
        ImportoIncarico,
        NumeroMandato,
        SommaPerCognomeNome,
        IdContoBancario,
        IdContoBancarioPerAnno,
        IdMovimentoContoBancario,NomeConto,NumeroConto,
        SegnoImporto,
        Importo,
        NomeOperazione,
        IdOperazioneContoBancario,
        Gruppo,
        Gruppo_Automatismo,
        FlagEseguiControlloOrdinanteBeneficiario,
        #LS 22062020 != Mandato
        CheckFalseMandato,
        #LF 08102020 FlagRiconciliato, NotaAggiuntiva
        FlagRiconciliato,
        CodiceTipoRiconciliazione,
        NotaAggiuntiva,
        #LF 15122020
        CodiceCausale,
        FlagModificaCognomeNome,

        @{Name="Testo";Expression ={$_.Testo -replace "IT\d\d\w\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d",""}}, 
        @{Name="Iban";Expression ={$([regex]::Match($_.Testo,"IT\d\d\w\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d\d")).Value}},
        TestoCognomeNome              


$Datatable_movimenti | foreach{
$t = $null
$j = $null
$c = $null

$t = $([string]($_.Testo))
$c = $_.FlagModificaCognomeNome

if($t.Length -lt 70){
    $j = $t
}else{
    $j = $t.Substring(0,70)
}
if($c -eq 0){
    $_.TestoCognomeNome = get-sanitizedUTF8Input -inputString $t

}else{
    $_.TestoCognomeNome = get-sanitizedUTF8Input -inputString $j
}

$_.Testo = get-sanitizedUTF8Input -inputString $t


}

}

if($flag_estraiincarichi -eq 1){

write-host "Estrai incarichi" -ForegroundColor Green
 $log += "Estrai incarichi"
 #tabella che viene popolata all'esecuzione della vista
 $datatable_incarichi = @()
 $Datatable_incarichi = New-Object System.Data.DataTable 
 
$Query_incarichi =   @"		

		SELECT --top 1
     	elencoincarichi.IdIncarico,
		elencoincarichi.Prodotto,
		elencoincarichi.IdMovimentoContoBancario,
		elencoincarichi.importomovimentocontobancario,
		elencoincarichi.NonRiconciliatoMaAssociatoCorrettamente,
		elencoincarichi.CodTipoIncarico,
		elencoincarichi.DataUltimaTransizione,
		elencoincarichi.ProgressivoPersona,
		elencoincarichi.CodTipoPersona,
		elencoincarichi.cognome,
		elencoincarichi.ragionesociale,
		elencoincarichi.nome,
		elencoincarichi.Importo,
		elencoincarichi.NumeroMandato,
		elencoincarichi.StatusWF,
		elencoincarichi.CodStatoWorkflowIncarico,
		elencoincarichi.NmandatoNoZero,
		elencoincarichi.SommaPerCognomeNome 
FROM rs.v_CESAM_AZ_Incarichi_AnagraficheClienti_RIC_BNP elencoincarichi
ORDER BY elencoincarichi.IdIncarico, ProgressivoPersona ASC

"@

$Query_incarichi_pac = @"

SELECT IdIncarico
	  ,NumeroMandato
	  ,CodiceSocietaProdotto
	  ,CodiceProdotto 
FROM rs.v_CESAM_AZ_Incarichi_PAC

"@
    
    #apro la connessione a sql
 $ConnectionObject.Open()
 
 $Comando = $ConnectionObject.CreateCommand()
 $Comando.CommandTimeout = 500
 $Comando.CommandText = $Query_incarichi
 
 $DataSetDiRitorno = $null
 $DataSetDiRitorno = $Comando.ExecuteReader() 

 $Datatable_incarichi.Load($DataSetDiRitorno) 
 
 if($flagriconciliapac -eq 1){
 write-host "Estrai incarichi Rata PAC" -ForegroundColor Green
 $log += "Estrai incarichi Rata PAC"
 
 $datatable_incarichi_pac = @()
 $datatable_incarichi_pac = New-Object System.Data.DataTable

 $Comando2 = $ConnectionObject.CreateCommand()
 $Comando2.CommandTimeout = 200
 $Comando2.CommandText = $Query_incarichi_pac

 $DataSetPAC = $null
 $DataSetPAC = $Comando2.ExecuteReader()

 $datatable_incarichi_pac.Load($DataSetPAC) 
 }

 $ConnectionObject.close()

 $Datatable_incarichi | Add-Member -MemberType NoteProperty -Name "IsRiconciliato" -Value 0
 $Datatable_incarichi | Add-Member -MemberType NoteProperty -Name "IdMovimentoContoBancaricoInRun" -Value $null
 $Datatable_incarichi | Add-Member -MemberType NoteProperty -Name "TipoRiconciliazioneInRun" -Value $null


 $datatable_incarichi | foreach{
    $_.cognome = get-sanitizedUTF8Input -inputString $($_.Cognome)
    $_.nome = get-sanitizedUTF8Input -inputString $($_.Nome)
    $_.ragionesociale = get-sanitizedUTF8Input -inputString $($_.ragionesociale)

 }

}

}

if($flag_eseguiriconciliazione -eq 1 ){
write-host "start riconciliazione standard $(Get-Date)" -ForegroundColor Green
$log += "start riconciliazione standard $(Get-Date)"


 # connessione a sql
 $StringaConnessione = "Server=$($connection);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
 $ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
 $Comando = New-Object System.Data.SqlClient.SqlCommand
 $ConnectionObject.Open()
  
 $Tempriconciliazione = @()
 $Tempriconciliazione = New-Object System.Data.DataTable 
 $column1 = New-Object System.Data.DataColumn "idincarico",([STRING])
 $Tempriconciliazione.Columns.Add($column1)
 $column2 = New-Object System.Data.DataColumn "idmovimentocontabile",([INT])
 $Tempriconciliazione.Columns.Add($column2)
 $column3 = New-Object System.Data.DataColumn "idmovimentoincarico",([INT])
 $Tempriconciliazione.Columns.Add($column3)
 $column4 = New-Object System.Data.DataColumn "tiporiconciliazione",([INT])
 $Tempriconciliazione.Columns.Add($column4)
 $column5 = New-Object System.Data.DataColumn "statuswf",([INT])
 $Tempriconciliazione.Columns.Add($column5)
  $column6 = New-Object System.Data.DataColumn "ImportoIncarico",([decimal])
 $Tempriconciliazione.Columns.Add($column6)
  $column7 = New-Object System.Data.DataColumn "ImportoIncaricoSomma",([decimal])
 $Tempriconciliazione.Columns.Add($column7)
  $column8 = New-Object System.Data.DataColumn "ImportoContabile",([decimal])
 $Tempriconciliazione.Columns.Add($column8)
  $column9 = New-Object System.Data.DataColumn "Prodotto",([STRING])
 $Tempriconciliazione.Columns.Add($column9)
  $column10 = New-Object System.Data.DataColumn "ProdottoConto",([STRING])
 $Tempriconciliazione.Columns.Add($column10)
   $column11 = New-Object System.Data.DataColumn "FlagRiconcilia",([INT])
 $Tempriconciliazione.Columns.Add($column11)
    $column12 = New-Object System.Data.DataColumn "OrdinanteBonifico",([STRING])
 $Tempriconciliazione.Columns.Add($column12)
     $column13 = New-Object System.Data.DataColumn "Cognome",([STRING])
 $Tempriconciliazione.Columns.Add($column13)
      $column14 = New-Object System.Data.DataColumn "Nome",([STRING])
 $Tempriconciliazione.Columns.Add($column14)
       $column15 = New-Object System.Data.DataColumn "RagioneSociale",([STRING])
 $Tempriconciliazione.Columns.Add($column15)
        $column16 = New-Object System.Data.DataColumn "FlagEseguiControlloOrdinanteBeneficiario",([INT])
 $Tempriconciliazione.Columns.Add($column16)
         #LS 22062020 != Mandato
         $column17 = New-Object System.Data.DataColumn "CheckFalseMandato",([INT])
 $Tempriconciliazione.Columns.Add($column17)
        $column18 = New-Object System.Data.DataColumn "Testo",([STRING])
 $Tempriconciliazione.Columns.Add($column18)

$uniqueincarichi = $null
$uniqueincarichi = $datatable_incarichi | Select-Object idincarico,IsRiconciliato -Unique #| Where-Object {$_.idincarico -eq 12397931}




foreach($uniqueincarico in $uniqueincarichi){


$listaincarico = $null
$listaincarico = $datatable_incarichi | Where-Object {$_.idincarico -eq $uniqueincarico.idincarico}
$uniquemovimentiincarico = $null
$uniquemovimentiincarico =$listaincarico | Select-Object IdMovimentoContoBancario -Unique


$incarico = $null
foreach($incarico in $listaincarico){

if ($flagvisualizzaparametririconciliazione -eq 1){Write-Host $incarico.IdIncarico -ForegroundColor DarkCyan}
    $ImportoIncaricoRangeSuperiore = $null
    $ImportoIncaricoRangeInferiore = $null

    if($incarico.Importo -le 500000){ #se supera cento mila non faccio nulla
            $ImportoIncaricoRangeSuperiore = $incarico.Importo * 1.02
            $ImportoIncaricoRangeInferiore = $incarico.Importo / 1.02
        }else{
            $ImportoIncaricoRangeSuperiore = $incarico.Importo 
            $ImportoIncaricoRangeInferiore = $incarico.Importo 
        }

    $ImportoIncarico_GruppoRangeSuperiore = $null
    $ImportoIncarico_GruppoRangeInferiore = $null

    if($incarico.Importo -le 1000000){   #se supera un milione non faccio nulla
            $ImportoIncarico_GruppoRangeSuperiore = $incarico.Importo * 1.02
            $ImportoIncarico_GruppoRangeInferiore = $incarico.Importo / 1.02
        }else{
            $ImportoIncarico_GruppoRangeSuperiore = $incarico.Importo 
            $ImportoIncarico_GruppoRangeInferiore = $incarico.Importo 
        }

#write-host "$($incarico.IdIncarico)         $($incarico.cognome) " -ForegroundColor Cyan

   
 $m1 = $null #match per cognome,nome,importo preciso,somma cognomenome
 $m2 = $null #match per mandato,importo preciso,somma cognomenome   
 $m3 = $null #match per cognome,nome,importo maggiorato del 2%,somma cognomenome maggiorata del 2%
 $m4 = $null #match per mandato,importo maggiorato del 2%,somma cognomenome maggiorata del 2%
 $m5 = $null #match per cognome nome / o mandato e cognome

 
 $m1 = $Datatable_movimenti  |
            
            Where-Object {
           $_.IsRiconciliato -eq 0 -and
           $_.SegnoImporto -eq 1 -and
           (@($uniquemovimentiincarico.IdMovimentoContoBancario) -notcontains $_.IdMovimentoContoBancario) -and 

            (
            ( #match per cognome e nome o ragione sociale
            (
            ( $_.TestoCognomeNome -match " $($incarico.cognome)\W") -and 
            ($_.TestoCognomeNome -match " $($incarico.Nome)\W")
            ) -or
            ( -not ([string]::IsNullOrEmpty($incarico.ragionesociale)) -and
                ($_.TestoCognomeNome -replace "\.","") -match (" $($incarico.ragionesociale)\W" -replace "\.","")
            )
            ) -or
            ( #match per mandato
             (-not ([string]::IsNullOrEmpty($incarico.NumeroMandato))) -and
             ($_.Testo -match "$($incarico.NumeroMandato)\W" -or $_.Testo -match "$($incarico.NmandatoNoZero)\W")
            )
            )-and
            ( #match per importo
            (($_.Importo) -ge $ImportoIncaricoRangeInferiore -and ($_.Importo) -le $ImportoIncaricoRangeSuperiore) -or 
            (($_.Importo) -ge $ImportoIncarico_GruppoRangeInferiore -and ($_.Importo) -le $ImportoIncarico_GruppoRangeSuperiore) -or
             (($_.Importo) -eq $incarico.SommaPerCognomeNome -and ($_.Importo -eq $incarico.Importo) )
            )
                        

            }

 <#logica tipo 1 blocca il resto#>
 $m1 | Where-Object { ( $_.TestoCognomeNome -match " $($incarico.cognome)\W" -or 
                            (-not ([String]::IsNullOrEmpty($incarico.ragionesociale)) -and (($_.TestoCognomeNome -replace "\.","") -match ("$($incarico.ragionesociale)\W") -replace "\.",""))
                        )-and
                            (
                                (-not ([string]::IsNullOrEmpty($incarico.NumeroMandato))) -and 
                                (($_.Testo -match "$($incarico.NumeroMandato)\W") -or ($_.Testo -match "$($incarico.NmandatoNoZero)\W"))

                            )} | foreach {

                          $_.IsRiconciliato = 1

                          $_.TipoRiconciliazione = 1
                            
                          Write-Host "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" -ForegroundColor Green
                          $log += "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" 
                       

                          $row = $null
                          $row = $Tempriconciliazione.NewRow()
                          $row."idincarico" = $($incarico.IdIncarico)
                          $row."idmovimentocontabile" =  $($_.IdMovimentoContoBancario)
                          $row."idmovimentoincarico" = $($incarico.IdMovimentoContoBancario)
                          $row."tiporiconciliazione" = $($_.TipoRiconciliazione)
                          $row."statuswf" = $($incarico.StatusWF)
                          $row."ImportoIncarico" = $($incarico.Importo)
                          $row."ImportoIncaricoSomma" = $($incarico.SommaPerCognomeNome)
                          $row."ImportoContabile" = $($_.Importo)
                          $row."Prodotto" = $($incarico.Prodotto)
                          $row."ProdottoConto" = $($_.ProdottoConto)
                         $row."FlagRiconcilia" = 1
                         $row."OrdinanteBonifico" = $($_.Testo).Substring(0,50)
                         $row."Cognome" = $incarico.cognome
                         $row."Nome" = $incarico.nome
                         $row."RagioneSociale" = $incarico.ragionesociale
                         $row."FlagEseguiControlloOrdinanteBeneficiario" = $($_.FlagEseguiControlloOrdinanteBeneficiario)
                         $row."Testo" = $($_.Testo)
                          $Tempriconciliazione.Rows.add($row)


                          $_.Idincarico = $incarico.IdIncarico
                          $_.Prodotto = $incarico.Prodotto
                          $_.Cognome = $incarico.cognome
                          $_.Nome = $incarico.Nome
                          $_.RagioneSociale = $incarico.RagioneSociale
                          $_.ImportoIncarico = $incarico.Importo
                          $_.NumeroMandato = $incarico.NumeroMandato
                          $_.SommaPerCognomeNome = $incarico.SommaPerCognomeNome

                            }

# se esiste almeno una riconciliazione di tipo uno allora non faccio nulla, altrimenti trovo le riconciliazioni di tipo 2
if($m1 | Where-Object {$_.Tiporiconciliazione -eq 1 }){



}else{

$m1 | foreach {          $_.IsRiconciliato = 0  #modificato da 1 a 0 20191125

                                 $_.TipoRiconciliazione = 2
                                 
                                 Write-Host "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" -ForegroundColor Green
                                 $log += "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF"  

                                 $row = $null
                                 $row = $Tempriconciliazione.NewRow()
                                 $row."idincarico" = $($incarico.IdIncarico)
                                 $row."idmovimentocontabile" =  $($_.IdMovimentoContoBancario)
                                 $row."idmovimentoincarico" = $($incarico.IdMovimentoContoBancario)
                                 $row."tiporiconciliazione" = $($_.TipoRiconciliazione)
                                 $row."statuswf" = $($incarico.StatusWF)
                                 $row."ImportoIncarico" = $($incarico.Importo)
                                 $row."ImportoIncaricoSomma" = $($incarico.SommaPerCognomeNome)
                                 $row."ImportoContabile" = $($_.Importo)
                                 $row."Prodotto" = $($incarico.Prodotto)
                                 $row."ProdottoConto" = $($_.ProdottoConto)
                                 $row."FlagRiconcilia" = 1
                                  $row."OrdinanteBonifico" = if($($_.Testo).length -lt 41){$($_.Testo)}else{ $($_.Testo).Substring(0,40)}
                         $row."Cognome" = $incarico.cognome
                         $row."Nome" = $incarico.nome
                         $row."RagioneSociale" = $incarico.ragionesociale
                         $row."FlagEseguiControlloOrdinanteBeneficiario" = $($_.FlagEseguiControlloOrdinanteBeneficiario)
                         $row."Testo" = $($_.Testo)
                                 $Tempriconciliazione.Rows.add($row)

                                 $_.Idincarico = $incarico.IdIncarico
                                 $_.Prodotto = $incarico.Prodotto
                                 $_.Cognome = $incarico.cognome
                                 $_.Nome = $incarico.Nome
                                 $_.RagioneSociale = $incarico.RagioneSociale
                                 $_.ImportoIncarico = $incarico.Importo
                                 $_.NumeroMandato = $incarico.NumeroMandato
                                 $_.SommaPerCognomeNome = $incarico.SommaPerCognomeNome

}

}



if(!$m1 -and $livelliRiconciliazione -ge 5){

$m5 = $Datatable_movimenti   |
            
            Where-Object {
            $_.IsRiconciliato -eq 0 -and
            $_.SegnoImporto -eq 1 -and
            (@($uniquemovimentiincarico.IdMovimentoContoBancario) -notcontains $_.IdMovimentoContoBancario) -and 
            (
            (
            (-not ([string]::IsNullOrEmpty($incarico.NumeroMandato))) -and
            (($_.Testo -match "$($incarico.NumeroMandato)\W") -or ($_.Testo -match "$($incarico.NmandatoNoZero)\W")) -and
            
            (
                ($_.Testo -match " $($incarico.cognome)\W") -or (-not ([string]::IsNullOrEmpty($incarico.ragionesociale)) -and ($_.Testo -replace "\.","") -match (" $($incarico.ragionesociale)\W" -replace "\.",""))
            )

            ) -or 

            (
            (
               (-not ([string]::IsNullOrEmpty($incarico.cognome))) -and
            ($_.Testo -match " $($incarico.cognome)\W") -and 
            ($_.Testo -match " $($incarico.Nome)\W")
            ) -or
            (
                 -not([string]::IsNullOrEmpty($incarico.ragionesociale)) -and ($_.TestoCognomeNome -replace "\.","") -match (" $($incarico.ragionesociale)\W" -replace "\.","")
            )
            )
            )

            } 

 $m5 | foreach {     # Write-Host "$($incarico.NumeroMandato) - $($_.Testo)" -ForegroundColor Cyan 
                        $_.IsRiconciliato = 0
                        if(
                             (-not ([string]::IsNullOrEmpty($incarico.NumeroMandato))) -and
                             ($_.Testo -match "$($incarico.NumeroMandato)\W" -or $_.Testo -match "$($incarico.NmandatoNoZero)\W")
                             )
                             {
                                $_.TipoRiconciliazione = 5
                        
                               Write-Host "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" -ForegroundColor Yellow
                              $log += "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" 

                                $row = $null
                                 $row = $Tempriconciliazione.NewRow()
                                 $row."idincarico" = $($incarico.IdIncarico)
                                 $row."idmovimentocontabile" =  $($_.IdMovimentoContoBancario)
                                 $row."idmovimentoincarico" = $($incarico.IdMovimentoContoBancario)
                                 $row."tiporiconciliazione" = $($_.TipoRiconciliazione)
                                 $row."statuswf" = $($incarico.StatusWF)
                                 $row."ImportoIncarico" = $($incarico.Importo)
                                 $row."ImportoIncaricoSomma" = $($incarico.SommaPerCognomeNome)
                                 $row."ImportoContabile" = $($_.Importo)
                                 $row."Prodotto" = $($incarico.Prodotto)
                                 $row."ProdottoConto" = $($_.ProdottoConto)
                                 $row."FlagRiconcilia" = 1
                                  $row."OrdinanteBonifico" = if($($_.Testo).Length -gt 50){$($_.Testo).Substring(0,50)}else{$($_.Testo)}
                         $row."Cognome" = $incarico.cognome
                         $row."Nome" = $incarico.nome
                         $row."RagioneSociale" = $incarico.ragionesociale
                         $row."FlagEseguiControlloOrdinanteBeneficiario" = $($_.FlagEseguiControlloOrdinanteBeneficiario)
                         $row."Testo" = $($_.Testo)
                                 $Tempriconciliazione.Rows.add($row)
                        
                        }else{ 
                        
                                $_.TipoRiconciliazione = 6 
                        
                                #LS 22062020 != Mandato
                                if((-not ([string]::IsNullOrEmpty($incarico.NumeroMandato))) -and
                                ($_.Testo -notmatch "$($incarico.NumeroMandato)\W" -or $_.Testo -notmatch "$($incarico.NmandatoNoZero)\W"))
                                
                                {
                                    $_.CheckFalseMandato = 1    
                                } 

                                Write-Host "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" -ForegroundColor Yellow
                                $log += "$($_.NomeConto) $($_.NumeroConto) $($_.IdMovimentoContoBancario) IDMOVIMENTO $($incarico.IdIncarico) IDINCARICO $($_.TipoRiconciliazione) TIPORICONCILIAZIONE $($incarico.StatusWF) SWF" 
                                

                               $row = $null
                                 $row = $Tempriconciliazione.NewRow()
                                 $row."idincarico" = $($incarico.IdIncarico)
                                 $row."idmovimentocontabile" =  $($_.IdMovimentoContoBancario)
                                 $row."idmovimentoincarico" = $($incarico.IdMovimentoContoBancario)
                                 $row."tiporiconciliazione" = $($_.TipoRiconciliazione)
                                 $row."statuswf" = $($incarico.StatusWF)
                                 $row."ImportoIncarico" = $($incarico.Importo)
                                 $row."ImportoIncaricoSomma" = $($incarico.SommaPerCognomeNome)
                                 $row."ImportoContabile" = $($_.Importo)
                                 $row."Prodotto" = $($incarico.Prodotto)
                                 $row."ProdottoConto" = $($_.ProdottoConto)
                                 $row."FlagRiconcilia" = 1
                                  $row."OrdinanteBonifico" = $($_.Testo).Substring(0,50)
                         $row."Cognome" = $incarico.cognome
                         $row."Nome" = $incarico.nome
                         $row."RagioneSociale" = $incarico.ragionesociale
                         $row."FlagEseguiControlloOrdinanteBeneficiario" = $($_.FlagEseguiControlloOrdinanteBeneficiario)
                         #LS 22062020 != Mandato
                         $row."CheckFalseMandato" = $($_.CheckFalseMandato)
                         $row."Testo" = $($_.Testo)
                                 $Tempriconciliazione.Rows.add($row)
                        
                        
                        }
                        $_.Idincarico = $incarico.IdIncarico
                        $_.Prodotto = $incarico.Prodotto
                        $_.Cognome = $incarico.cognome
                        $_.Nome = $incarico.Nome
                        $_.RagioneSociale = $incarico.RagioneSociale
                        $_.ImportoIncarico = $incarico.Importo
                        $_.NumeroMandato = $incarico.NumeroMandato
                        $_.SommaPerCognomeNome = $incarico.SommaPerCognomeNome

                          }
    

#Write-Host "5" -ForegroundColor Yellow    



}    

if($flagvisualizzaparametririconciliazione -eq 1  ){
if($m1){
Write-Host "---> m1" -ForegroundColor Yellow
$m1
}
if($m5){
Write-Host "---> m5" -ForegroundColor red
$m5
}
}





if($m1){ 
#Write-Host "esco dal ciclo" -ForegroundColor Cyan
break 
}




}


if($flagvisualizzaparametririconciliazione -eq 1){
    $Tempriconciliazione | Select-Object idincarico,idmovimentocontabile,tiporiconciliazione,statuswf,Prodotto,ProdottoConto,FlagRiconcilia
    }
if(@($Tempriconciliazione).count -ge 1){
    $Tempriconciliazionegrouped = $null
    $Tempriconciliazionegrouped = $Tempriconciliazione | Select-Object idincarico,idmovimentocontabile,tiporiconciliazione,statuswf,ImportoIncarico,ImportoIncaricoSomma,ImportoContabile -Unique
    

    $importoincarico = $null
    $importoincarico = $Tempriconciliazione.ImportoIncarico[0]
    $importoincaricoSomma = $null
    $importoincaricoSomma = $Tempriconciliazione.ImportoIncaricoSomma[0]
    $sommacontabli = $null
    $sommacontabli = $($Tempriconciliazionegrouped | Group-Object -Property Idincarico | Select-Object @{Name="Somma";Expression={($_.Group | Measure-Object ImportoContabile -Sum).Sum}}).Somma
    
    $IdMovimentoContoBancaricoInRun = $null
    $IdMovimentoContoBancaricoInRun = $Tempriconciliazione.idmovimentocontabile[0]
    
    #controllo se l'incarico è stato associato a più contabili uguali, se si lo disassocio
    [string]$rapportosommacontabileimportoincarico = $null
    if($importoincarico -eq 0){
        [string]$rapportosommacontabileimportoincarico = 0
        }else{
        [string]$rapportosommacontabileimportoincarico = $sommacontabli/$importoincarico
        }
    
  
    $movimentodatentere = $null
    if( $rapportosommacontabileimportoincarico -notmatch "\." -and  
    $rapportosommacontabileimportoincarico -gt 1 #-and     $Tempriconciliazione.TipoRiconciliazione[0] -ne 1

    ){
   
    $movimentodatenere = $Tempriconciliazione.idmovimentocontabile[0]
 
    $log += "movimento da tenere $movimentodatenere"
    $Tempriconciliazione | Where-Object {$_.idmovimentocontabile -ne $movimentodatenere} | ForEach-Object {$_.FlagRiconcilia = 0}


    $Datatable_movimenti | Where-Object {$_.IdIncarico -eq $incarico.IdIncarico -and $_.IdMovimentoContoBancario -ne $movimentodatenere} | ForEach-Object{

    if($flagvisualizzaparametririconciliazione -eq 1){
    Write-Host "disassocio movimento $($_.IdMovimentoContoBancario)" -ForegroundColor Red
    }
    
    $_.IsRiconciliato = 0
    $_.TipoRiconciliazione = 0
    $_.IdIncarico = 0


    }

    }


    $listaanagraficaincarico = $null
    $listaanagraficaincarico = $datatable_incarichi | Where-Object {$_.IdIncarico -eq $incarico.idincarico} | Select-Object Nome, Cognome, RagioneSociale
    
    $Tempriconciliazione | Where-Object {$_.FlagRiconcilia -eq 1} | 
    Select-Object idincarico,idmovimentocontabile,tiporiconciliazione,statuswf,Prodotto,ProdottoConto,OrdinanteBonifico,FlagEseguiControlloOrdinanteBeneficiario,CheckFalseMandato,Testo -Unique | #LS 22062020 != Mandato
    ForEach-Object {
    
    $Tempriconciliazione_idmovimentocontabile = $null
    $Tempriconciliazione_idmovimentocontabile = $_.idmovimentocontabile   


    #logica che associa se la somma delle contabili trovate è uguale all'importo incarico/o alla somma per cognome
    if(($importoincarico -eq $sommacontabli -or $importoincaricoSomma -eq $sommacontabli) -and 
        -not($_.tiporiconciliazione -eq 1 -or $_.tiporiconciliazione -eq 2))
        {
    
    $_.tiporiconciliazione = 3
           $log += "tiporiconciliazione 3"

    }
    #>
    #logica che verifica se il nome del prodotto è presente, 
    #se è presente verifico di aver raggiunto l'importo totale dell'incarico
    #se non è presente - traccio nelle note di riconciliazione idincarico e prodotto

    
if($flagabilitacontrolloordinantebeneficiario -eq 1 -and $_.FlagEseguiControlloOrdinanteBeneficiario -eq 1){

$modificatiporiconciliazionecontrolloordinantebeneficiario = 1

foreach ($intestatario in $listaanagraficaincarico){

if(
    ((-not ([string]::IsNullOrEmpty($intestatario.RagioneSociale))) -and $($_.OrdinanteBonifico -replace " ","" -replace "\.","") -match $($intestatario.RagioneSociale -replace " ","" -replace "\.","")) -or
    (
        ((-not ([string]::IsNullOrEmpty($intestatario.Cognome))) -and $($_.OrdinanteBonifico -replace " ","" -replace "\.","") -match $($intestatario.cognome -replace " ","" -replace "\.","")) -and
        ($($_.OrdinanteBonifico -replace " ","" -replace"\.","") -match $($intestatario.nome -replace " ","" -replace "\.",""))
    )

 ){


$modificatiporiconciliazionecontrolloordinantebeneficiario = 0

}

if($modificatiporiconciliazionecontrolloordinantebeneficiario -eq 1){
    $log += "Controllo Ordinante Bonifico - Ordinante $($_.OrdinanteBonifico)- ragione sociale $($intestatario.RagioneSociale) - cognome $($intestatario.Cognome) - Nome $($intestatario.Nome)"
   

    }


} #foreach intestatario in anagrafica

if($modificatiporiconciliazionecontrolloordinantebeneficiario -eq 1){
     $_.tiporiconciliazione = 7
     $log += "Tiporiconciliazione 7 Ordinante diverso da tutti gli esecutori"
}


}


    <#IL CONTROLLO SUL CONTO/PRODOTTO DEVE ESSERE SEMPRE L'ULTIMO CONTROLLO EFFETTUATO#>
    if($logicariconciliazionesingoloconto -eq 1){

        IF(
        (-not ([string]::IsNullOrEmpty($_.Prodotto))) -and
        ($_.Prodotto -ne $_.ProdottoConto)
        ){

        $_.tiporiconciliazione = 8
        Write-Host "AZCM/AZF1 SOTTOS 802260103 IDMOVIMENTO $($_.IdMovimentoContoBancario) IDINCARICO $($_.IdIncarico) TIPORICONCILIAZIONE 8 SWF 0"
        $log +=    "AZCM/AZF1 SOTTOS 802260103 IDMOVIMENTO $($_.IdMovimentoContoBancario) IDINCARICO $($_.IdIncarico) TIPORICONCILIAZIONE 8 SWF 0"
        
    $Datatable_movimenti | Where-Object {$_.IdMovimentoContoBancario -eq $Tempriconciliazione_idmovimentocontabile} | ForEach-Object{

    if($flagvisualizzaparametririconciliazione -eq 1){
    Write-Host "disassocio movimento $($_.IdMovimentoContoBancario)" -ForegroundColor Red
    }
    
    $_.IsRiconciliato = 0
    $_.TipoRiconciliazione = 0
    $_.IdIncarico = 0


    }



        }


    }


   

if($flagvisualizzaparametririconciliazione -eq 1){
    Write-Host "tiporiconciliazione: $($_.tiporiconciliazione) idmovimento $($_.idmovimentocontabile) idincarico $($_.idincarico)" -ForegroundColor Yellow
    }

    
    #eseguo update sulla tabella datatable incarichi in modo da storicizzare anche il movimento associato in running all'incarico

    $TipoRiconciliazioneInRun = $null
    $TipoRiconciliazioneInRun = $($_.tiporiconciliazione) 
    $idincaricoinrun = $null
    $idincaricoinrun = $($_.idincarico)
    
    $datatable_incarichi | Where-Object {$_.idincarico -eq $idincaricoinrun  } | ForEach-Object {
        $_.IdMovimentoContoBancaricoInRun = $IdMovimentoContoBancaricoInRun
        $_.TipoRiconciliazioneInRun = $TipoRiconciliazioneInRun 
        $_.IsRiconciliato = 1
    }
    
    #gestione eliminazione incarichi riconciliati con tipo meno preciso (il tipo meno preciso ha un valore superiore)
    $listatipiriconciliazioni  = $null
    $listatipiriconciliazioni = $datatable_incarichi | Where-Object {$_.IdMovimentoContoBancaricoInRun -eq $IdMovimentoContoBancaricoInRun} | select TipoRiconciliazioneInRun
    $listatipiriconciliazioni = $listatipiriconciliazioni.TipoRiconciliazioneInRun
    $maxtiporiconciliazione = $null
    [int]$maxtiporiconciliazione = $($listatipiriconciliazioni | measure -Maximum  | select Maximum).Maximum
    $mintiporiconciliazione = $null
    [int]$mintiporiconciliazione = $($listatipiriconciliazioni | measure -Minimum | select Minimum).Minimum
    

    #lista degli incarichi associati al movimento che hanno tiporiconciliazione diversa da 1
    $listaincarichidaeliminare = @()
    if($maxtiporiconciliazione -ne $mintiporiconciliazione -and $flageliminaprecedentiriconciliazioniserictipo1 -eq 1){
        
        $listaincarichidaeliminare =  $datatable_incarichi |
            Where-Object {

            $_.IdMovimentoContoBancaricoInRun -eq $IdMovimentoContoBancaricoInRun -and
            $_.TipoRiconciliazioneInRun -gt $mintiporiconciliazione

            } |
            select IdIncarico -Unique


    }
    if($flagvisualizzaparametririconciliazione -eq 1){
    Write-Host "lista incarichi da eliminare" -ForegroundColor Red
    $listaincarichidaeliminare
    }

    #Write-Host $_.Testo
    
    if($flaginserisciadb -eq 1){

        #LS 22062020 != Mandato
        if($_.CheckFalseMandato -eq 1) {
            logica-riconciliazione -inseriscitr 1 -statusworkflow $($_.statuswf) -idmovimentocontabile $($_.idmovimentocontabile) -tiporiconciliazione $($_.tiporiconciliazione) -idincarico $($_.idincarico) -notacontabile "!= Mandato" -testocontabile $($_.Testo)
        } else {  
            logica-riconciliazione -inseriscitr 1 -statusworkflow $($_.statuswf) -idmovimentocontabile $($_.idmovimentocontabile) -tiporiconciliazione $($_.tiporiconciliazione) -idincarico $($_.idincarico) -testocontabile $($_.Testo)
        }

     #Write-Host "inserisco a db" -ForegroundColor Cyan
        
            ##############elimina relazione movimento incarico per riconciliazione inferiore a tipo 1##################
         if($listaincarichidaeliminare -and $flageliminaprecedentiriconciliazioniserictipo1 -eq 1){

         $listaincarichidaeliminare | ForEach-Object {

         Write-Host "elimino incarico $($_.IdIncarico) per riconciliazione inferiore con movimento $IdMovimentoContoBancaricoInRun" -ForegroundColor Red
         $log += "elimino incarico $($_.IdIncarico) per riconciliazione inferiore con movimento $IdMovimentoContoBancaricoInRun" 
       
         logica-riconciliazione -eliminadatr 1 -inseriscitr 0 -statusworkflow 0 -idincarico $($_.IdIncarico) -idmovimentocontabile $IdMovimentoContoBancaricoInRun -tiporiconciliazione 0


         }

         }
         
            ########################################################################################################### 

                                      

    } #flaginserisciadb
} #foreachobject 

if(@($Tempriconciliazione).count -ge 1){$uniqueincarico.IsRiconciliato = 1}

$Tempriconciliazione.Clear()

}

}

 $ConnectionObject.close()
} #flag esegui riconciliazione

$dateformat = Get-Date -Format "yyyyMMdd_HHmm"
$end = Get-Date
$duration = $end - $start
write-host "minuti esecuzione $($duration.totalminutes)" -ForegroundColor Cyan
$log += "minuti esecuzione $($duration.totalminutes)"

$Datatable_movimenti | export-csv $file_risultatiriconciliazione -Delimiter ";" -NoTypeInformation
#$datatable_incarichi | export-csv "H:\incarichi_$($dateformat).csv" -Delimiter ";" -NoTypeInformation
$riconciliati = $null
$riconciliati = $Datatable_movimenti | Where-Object {-not ([string]::IsNullOrEmpty($_.IdIncarico))}
$numeroriconciliati = @($riconciliati).count
$numeroincarichi = $null
$numeroincarichi = @($uniqueincarichi).Count
$numeroincarichiriconciliati = $null
$numeroincarichiriconciliati = @($uniqueincarichi |Where-Object{$_.IsRiconciliato -eq 1}).Count
$numerocontabili = $null
$numerocontabili = @($Datatable_movimenti).Count

Write-Host "%ric su incarichi [$($numeroriconciliati/$numeroincarichi)] %ric su contabili [$($numeroriconciliati/$numerocontabili)]" -ForegroundColor Yellow
$log += "%ric su incarichi [$($numeroriconciliati/$numeroincarichi)] %ric su contabili [$($numeroriconciliati/$numerocontabili)]"

if($flageseguimodificacontabili -eq 1){

if($flag_connettisql -eq 1){

 # connessione a sql
 $StringaConnessione = "Server=$($conf.SQLConnection.istanza);Database=$($conf.SQLConnection.database);Trusted_Connection=Yes"
 $ConnectionObject = New-Object System.Data.SqlClient.SqlConnection($StringaConnessione)
 $Comando = New-Object System.Data.SqlClient.SqlCommand

 $ConnectionObject.Open()

    $Datatable_movimenti | 
        #Where-Object {-not [string]::IsNullOrEmpty($_.Gruppo) } | 
        #Select-Object -First 1 | 
        ForEach-Object {

    #Write-Host "ciao $($_.IdMovimentoContoBancario) - $($_.Gruppo) "
    
        if(-not [string]::IsNullOrEmpty($_.Gruppo)){
                if($flaginserisciadb -eq 1){  
                 logica-riconciliazione -inseriscitr 0 -statusworkflow 0 -idmovimentocontabile $($_.IdMovimentoContoBancario) -tiporiconciliazione 0 -idincarico 0 -notacontabile "AUTO_$($_.Gruppo)"
        
                } #flaginserisciadb
        
        }

         if(-not [string]::IsNullOrEmpty($_.Gruppo_Automatismo)){
                if($flaginserisciadb -eq 1){  
                 logica-riconciliazione -inseriscitr 0 -statusworkflow 0 -idmovimentocontabile $($_.IdMovimentoContoBancario) -tiporiconciliazione 0 -idincarico 0 -notacontabile "AUTO_$($_.Gruppo_Automatismo)"
        
                } #flaginserisciadb
        
        
        }
    
    
    } #foreach datatablemovimenti (gruppi-gruppo auto)

    
 $ConnectionObject.Close()


 if($flagriconciliapac -eq 1){
   ############# RICONCILIAZIONE PAC PREGRESSI ###########################################################
   $ConnectionObject.Open()

   $Datatable_movimenti_residui = @()
   $Datatable_movimenti_residui = New-Object System.Data.DataTable
   $Datatable_movimenti_residui = estrai-residui -connection $connection -database $($conf.SQLConnection.database) -pac 1
 

   foreach($r in $datatable_incarichi_pac){
        $Datatable_movimenti_residui | Where-Object {$_.Testo -match "$($r.NumeroMandato)\W" -and
                                    $_.Importo -le 1000
                                   } | ForEach-Object {

            Write-Host "AZCM/AZF1 SOTTOS 802260103 IDMOVIMENTO $($_.IdMovimentoContoBancario) IDINCARICO $($r.idincarico) TIPORICONCILIAZIONE 9 SWF 1" -ForegroundColor Green
            $LOG +=    "AZCM/AZF1 SOTTOS 802260103 IDMOVIMENTO $($_.IdMovimentoContoBancario) IDINCARICO $($r.idincarico) TIPORICONCILIAZIONE 9 SWF 1"
            logica-riconciliazione -inseriscitr 1 -eliminadatr 0 -statusworkflow 0 -idmovimentocontabile $($_.IdMovimentoContoBancario) -tiporiconciliazione 9 -idincarico $($r.idincarico) -notacontabile "R.P.R.: $($r.idincarico) *$($r.NumeroMandato) - $($r.CodiceProdotto)*"
        
        } #foreach movimenti pac                                     


    } #foreach incarichi ratapac

   $ConnectionObject.close()
   ############# FINE RICONCILIAZIONE PAC PREGRESSI ######################################################
} #if flagriconciliapac


 } #flagconnetti sql
} #flageseguimodificacontabili

<# IMPLEMENTARE LOGICA FLAG STATO WORKFLOW, SE TROVO UNA CONTABILE ASSOCIATA A PIU' INCARICHI
   E ALMENO UNO DI QUESTI HA STATUS WORKFLOW = 1
     ALLORA RIMUOVO DALL'ASSOCIAZIONE TRINCARICOMOVIMENTO TUTTI GLI INCARICHI CON STATUS 0
     ED INSERISCO IL FLAGRICONCILIATO = 1
   

#>
if($flagmodificariconciliato -eq 1){
 $ConnectionObject.Open()

$movimentidavariareinriconciliato = $null
$movimentidavariareinriconciliato = $datatable_incarichi | 
Where-Object {-not ([string]::IsNullOrEmpty($_.IdMovimentocontobancario)) -and $_.IsRiconciliato -eq 0 -and $_.StatusWF -eq 1} | 
Select IdMovimentocontobancario -Unique 

if($movimentidavariareinriconciliato){Write-Host "Modifica flagriconciliato" -ForegroundColor green
$log += "Modifica flagriconciliato"

}

$movimentidavariareinriconciliato |
ForEach-Object {
    Write-Host $($_.IdMovimentocontobancario)  -ForegroundColor Green
    $log +=  $($_.IdMovimentocontobancario)
    logica-riconciliazione -inseriscitr 0 -statusworkflow 1 -idmovimentocontabile $($_.IdMovimentocontobancario) -tiporiconciliazione 7 -idincarico 0 -eliminadatr 0
    
}


$datatable_incarichi | 

Where-Object {(@($movimentidavariareinriconciliato.IdMovimentoContoBancario) -contains $_.IdMovimentocontobancario)  -and $_.StatusWF -eq 0} |
ForEach-Object {
  Write-Host "elimino $($_.IdIncarico) incarico - $($_.IdMovimentocontobancario) movimento da TR" -ForegroundColor red
  $log += "elimino $($_.IdIncarico) incarico - $($_.IdMovimentocontobancario) movimento da TR"
  logica-riconciliazione -eliminadatr 1 -inseriscitr 0 -statusworkflow 0 -idincarico $($_.IdIncarico) -idmovimentocontabile $($_.IdMovimentocontobancario) -tiporiconciliazione 0

}



}


$Datatable_movimenti | ForEach-Object {

    if($_.CodiceCausale -eq "Zibe" -and (-not ($_.NotaAggiuntiva -match "Bonifico Estero\W")) ){

        Write-Host "Bonifico estero: $($_.IdMovimentoContoBancario)" -ForegroundColor Magenta
        $log+= "Bonifico estero: $($_.IdMovimentoContoBancario)"
       
        exec-salvariconcilia -idmovimentocontobancario $_.IdMovimentoContoBancario -notaaggiuntiva "Bonifico Estero" -inseriscitr 0 -eliminadatr 0 -idincarico 0 -flagriconciliato 0 -flagconfermato 0

    }
}
 $ConnectionObject.Close()

   if($flaginseriscitemplatenotaaggiuntiva -eq 1){
   ################ TEMPLATE NOTA AGGIUNTIVA ####################################################
   $Datatable_movimenti_residui = @()
   $Datatable_movimenti_residui = New-Object System.Data.DataTable
   $Datatable_movimenti_residui = estrai-residui -connection $connection -database $conf.SQLConnection.database -pac 0
   Write-Host "$($Datatable_movimenti_residui.count) movimenti residui!" -ForegroundColor Green

   
   $ConnectionObject.open()

   $Datatable_movimenti_residui |  ForEach-Object {

    Write-Host "Nota aggiuntiva su residuo $($_.IdMovimentoContoBancario)" -ForegroundColor DarkYellow
    $log+= "Nota aggiuntiva su residuo $($_.IdMovimentoContoBancario)"

    exec-salvariconcilia -inseriscitr 0 -eliminadatr 0 -idincarico 0 -flagriconciliato 0 -flagconfermato 0 -idmovimentocontobancario $($_.IdMovimentoContoBancario) -notaaggiuntiva "$($_.TemplateNotaAggiuntiva)"

    }

    $ConnectionObject.close()
    
   ################ FINE TEMPLATE NOTA AGGIUNTIVA ############################################### 

   }


$log | Out-File $file_log

}catch{

$MessaggioErrore = $null
$error
$MessaggioErrore = $error




}finally{



 
    $mailParams=@{}
    $mailBody=@"
"@;

$mailBody=@"
$nomescript

minuti esecuzione $($duration.totalminutes)

$MessaggioErrore

Server: $env:COMPUTERNAME
ScriptPath: $($MyInvocation.MyCommand.Path)



"@

    if($MessaggioErrore -eq $null){
        $mailSubject="[success] $($nomescript)"
    } 
    else{
        $mailSubject="[error] $($nomescript)"
    }
    
    $conf.mailing  | Get-Member -MemberType NoteProperty | %{
        $mailParams.Add($_.name,$conf.mailing."$($_.name)")
    }

    $mailParams.Add("Body",$mailbody)
    $mailParams.Add("Subject",$mailSubject)

    $dayoftheweek = $null
    $dayoftheweek = (Get-Date).DayOfWeek

    if($dayoftheweek -eq "Saturday" -or $dayoftheweek -eq "Sunday"){
    $mandamail = 0
    }

    if($mandamail -eq 1){
    Send-MailMessage @mailParams -Attachments $file_risultatiriconciliazione, $file_log
    }
    # print dei parametri subject, body
    $mailSubject
    $mailBody 
   

   # $MessaggioErrore

Remove-Item $scratchDir -Force -Recurse
}
