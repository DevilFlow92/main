USE CLC_Cesam
GO

alter PROCEDURE rs.p_report_CESAM_AZ_PerimetroSottoscrizioniFIA_CheckQtaskNadir
(
	@Fondo VARCHAR(255)
	,@IbanClasse VARCHAR(MAX)
)
AS 

BEGIN
/*
DECLARE @Fondo VARCHAR(255) = 'Private Equity Escalator'
,@IbanClasse VARCHAR(MAX) = 'A - IT50A0347901600000801557800,B; C - IT50A0347901600000801557800'
--grouping è per iban e data closing, quindi se ho più classi con stesso iban e stessa data closing, raggruppo in un'unica voce le classi (separate in riga dal ; )

----query per avere la stringa pronta di ibanclasse e data closing pronta per provare i filtri su questa sp
--SELECT STRING_AGG(so.IbanClasseClosing, ',')
--FROM ( SELECT top 1000 s.IbanClasseClosing --metto un top per fare in modo che accetti l'order by su funzione
--FROM (
--SELECT STRING_AGG(ClasseQuote, '; ') + ' - ' + IbanContoAfflussi IbanClasse
--FROM orga.S_ConfigurazioneFiaAzimut 
--WHERE NomeFia = 'Private Equity Escalator'
--AND FlagAttivo = 1
--and ibancontoafflussi is not null
--GROUP BY IbanContoAfflussi, DataClosing
--) s
--ORDER BY s.IbanClasseClosing
--) so

*/

--metto in tabella temporanea il set di filtri della combo iban-classe-closing
IF OBJECT_ID('tempdb.dbo.#ibanclasseclosing') IS NOT NULL
BEGIN
	DROP TABLE #ibanclasseclosing
END

CREATE TABLE #ibanclasseclosing (IbanClasseClosing NVARCHAR(255));
INSERT INTO #ibanclasseclosing (IbanClasseClosing)
	SELECT value FROM STRING_SPLIT(@IbanClasse,',') --con questa funzione di sistema io posso partire da un'elenco di valori separati da un carattere e buttarli in tabella!


--tabella temporanea di appoggio configurazioni fia, questa guida i filtri di tutti i dati (oltre che essere la base per il report!)
IF OBJECT_ID('tempdb.dbo.#ConfigFIA') IS NOT NULL
begin
    DROP TABLE #ConfigFIA
end
    
SELECT s.IdConfigurazioneFiaAzimut
	  ,s.NomeFia
	  ,s.Isin
	  ,s.ClasseQuote
	  ,s.MinimoSottoscrizioneRetail
	  ,s.MinimoSottoscrizioneProfessionale
	  ,s.DataInizioCollocamento
	  ,s.DataClosing
	  ,s.DataCutOffPagamenti
	  ,s.DataAssegnazioneQuote
	  ,s.IbanContoAfflussi
	  ,s.NumeroRichiamo
	  ,s.CodiceFia
	  ,s.NomeFileNadir
	  ,s.FlagAttivo
	  ,s.FlagPir
	  ,s.Prodotto 
	  ,s1.IbanClasseClosing
	  ,s.DataFineCaricamento
INTO #configFIA	 
FROM (
	SELECT NomeFia
		  ,STRING_AGG(ClasseQuote, '; ') + ' - ' + IbanContoAfflussi IbanClasseClosing
		  ,STRING_AGG(ClasseQuote,'; ') ListaClasse
		  ,orga.S_ConfigurazioneFiaAzimut.DataClosing
	FROM orga.S_ConfigurazioneFiaAzimut
	WHERE FlagAttivo = 1
and ibancontoafflussi is not null
GROUP BY  IbanContoAfflussi, NomeFia,orga.S_ConfigurazioneFiaAzimut.DataClosing) s1
JOIN orga.S_ConfigurazioneFiaAzimut  s ON s1.NomeFia = s.NomeFia
AND s1.DataClosing	= s.DataClosing
WHERE s.NomeFia = @Fondo
AND s1.IbanClasseClosing IN ( SELECT IbanClasseClosing FROM #ibanclasseclosing)
  
--SELECT * FROM #configFIA


--creo contenitore flussi nadir già filtrati per fondo e iban-classe-closing di interesse
IF OBJECT_ID('tempdb.dbo.#ImportFiaNadir') IS NOT NULL
begin
	DROP TABLE #ImportFiaNadir
END

SELECT NomeFia NomeFiaNadir
	  ,t.ID
	  ,t.nomefile
	  ,t.Cliente ClienteNadir
	  ,t.desc_cliente AnagraficaIntestatarioNadir
	  ,t.[c/o_spedizione] [c/o_spedizione Nadir]
	  ,t.indirizzo_spedizione indirizzo_spedizioneNadir
	  ,t.loc_spedizione loc_spedizioneNadir
	  ,t.prov_spedizione prov_spedizioneNadir
	  ,t.cap_spedizione cap_spedizioneNadir
	  ,t.nazione_spedizione nazione_spedizioneNadir
	  ,t.cclie_coint_21_1 cclie_coint_21_1Nadir
	  ,t.desc_cointest_1 desc_cointest_1Nadir
	  ,t.cclie_coint_21_2 cclie_coint_21_2Nadir
	  ,t.desc_cointest_2 desc_cointest_2Nadir
	  ,t.cclie_coint_21_3 cclie_coint_21_3Nadir
	  ,t.desc_cointest_3 desc_cointest_3Nadir
	  ,t.cclie_coint_21_4 cclie_coint_21_4Nadir
	  ,t.desc_cointest_4 desc_cointest_4Nadir
	  ,t.agente agenteNadir
	  ,t.desc_agente desc_agenteNadir
	  ,t.desc_societa
	  ,t.cod_prodotto
	  ,t.prodotto
	  ,t.desc_prodotto
	  ,t.dossier dossierNadir
	  ,RIGHT(t.mandato,9) MandatoNadir
	  ,t.commitment commitmentNadir
	  ,t.commitment_lordo commitment_lordoNadir
	  ,t.tot_versato
	  ,t.dt_sottoscrizione DataSottoscrizioneNadir
	  ,CONVERT(VARCHAR(10),t.dt_caricamento,103) dt_caricamentoNadir
	  ,IIF(t.status_mandato = '5',t.dt_stato_man,NULL) DataRevocaNadir
	  ,t.status_mandato status_mandatoNadir
	  ,ClasseQuote
	  ,IbanContoAfflussi
	  ,DataClosing
	  ,IbanClasseClosing
	  ,DataFineCaricamento
INTO #ImportFiaNadir
FROM scratch.ImportFiaNadir t
JOIN #configFIA  --non mi serve più inserire i parametri, basta mettere in join stretta la #configFIA
ON t.prodotto = #configFIA.Prodotto --joinando per prodotto a livello di configurazioneFIA, so quale classe dare al singolo mandato dei flussi nadir
									--QUINDI MI ASPETTO CHE LA RELAZIONE SIA SEMPRE UNIVOCA (ad ogni singolo mandato, voglio una sola riga di configFIA)
									--in caso contrario si sdoppiano le righe

AND NomeFileNadir = t.nomefile --rafforzativo giusto per velocizzargli la ricerca, gli contestualizzo quale fondo mi interessa

--SELECT * FROM #ImportFiaNadir

--creo contenitore incarichi sottoscrizione qtask già filtrati per combo fondo e iban-classe-closing
IF OBJECT_ID('tempdb.dbo.#IncarichiFIA') IS NOT NULL
BEGIN
	DROP TABLE #IncarichiFIA
END

SELECT v.Idincarico
,v.Isin
,v.NomeFondo NomeFiaQTask
,v.ClasseQuote 
,v.[Ndg Intestatario] NdgQtask
,v.[Anagrafica Intestatario] AnagraficaIntestatarioQtask
,v.NdgCointestatario1 NdgCointestatarioQtask
,v.AnagraficaCointestatario1 AnagraficaCointestatario1Qtask
,v.NdgCointestatario2 NdgCointestatario2Qtask
,v.AnagraficaCointestatario2 AnagraficaCointestatario2Qtask
,v.NdgCointestatario3 NdgCointestatario3Qtask
,v.AnagraficaCointestatario3 AnagraficaCointestatario3Qtask
,v.NdgCointestatario4 NdgCointestatario4Qtask
,v.AnagraficaCointestatario4 AnagraficaCointestatario4Qtask
,v.[Codice CF] CodCfQtask
,v.AnagraficaCF AnagraficaCFQtask
,v.MacroArea
,v.Area
,v.CDR
,v.am
,v.RagioneSocialeAM
,v.TM
,v.RagioneSocialeTM
,v.[C/O] [C/O Qtask]
,v.Indirizzo IndirizzoQtask
,v.Localita LocalitaQtask
,v.Cap CapQtask
,v.Provincia ProvinciaQtask
,v.Stato NazioneQtask
,v.StatoNadir NazioneQtaskNadir
,RIGHT(v.Mandato,9) MandatoQtask
,v.[Mandato Pir]
,v.Dossier DossierQtask
,v.DataSottoscrizione DataSottoscrizioneQtask
,v.DataCaricamento DataCaricamentoQtask
,v.[Importo Lordo] ImportoLordoQtask
,v.[Importo netto] ImportoNettoQtask
,v.Commissioni
,v.[Importo lordo Originale]
,v.[Importo Netto Iniziale]
,v.DataRevocaQtask 
,v.[Revoca/Variazione] RevocaQtask
,v.[Mandato Valido]
,v.FileImportNadir
,v.IbanContoAfflussi
,conf.DataInizioCollocamento
,conf.DataClosing
,conf.DataCutOffPagamenti
,conf.DataAssegnazioneQuote
,conf.MinimoSottoscrizioneRetail
,conf.MinimoSottoscrizioneProfessionale
,v.CodMacroStatoWorkflowIncarico --?
,v.CodStatoWorkflowIncarico
,v.StatoWorkflowIncarico
,v.DataVariazioneCommitment
,CheckCF.IdDatoAggiuntivo IdCheckCF
,CheckLocalita.IdDatoAggiuntivo IdCheckLocalita

INTO #IncarichiFIA
FROM rs.v_CESAM_AZ_PerimetroSottoscrizioniFIA v
JOIN #configFIA conf ON v.Isin = conf.Isin --qui join stretta con #configFIA per applicare i filtri in ingresso
	AND v.ClasseQuote = conf.ClasseQuote				--tutti questi campi mi aspetto abbiano legame univoco (per ogni singolo incarico, mi aspetto un solo valore di configFIA)
	AND v.DataClosing = conf.DataClosing				--altrimenti si sdoppiano le righe
	AND v.IbanContoAfflussi = conf.IbanContoAfflussi
LEFT JOIN T_DatoAggiuntivo CheckCF ON v.Idincarico = CheckCF.IdIncarico --inserisco già qui il dato aggiuntivo che gestisce l'eccezione di diverso CF
	AND CheckCF.FlagAttivo = 1
	AND CheckCF.Testo = 'OK'
LEFT JOIN T_DatoAggiuntivo CheckLocalita ON v.Idincarico = CheckLocalita.IdIncarico --inserisco già qui il dato aggiuntivo che gestisce l'eccezione della località
	AND CheckLocalita.FlagAttivo = 1
	AND CheckLocalita.Testo = 'OK'
/*** 
	 in questo spazio di left join, in futuro aggiungere (spero di no!)
	 altre eventuali eccezioni che bypassano i check più avanti
***/
WHERE FileImportNadir IS NOT NULL


--Indicizziamo i campi oggetto della full join tra flussi nadir e incarichi fia
--questo aiuta a velocizzare la parte di merge dei dati
--gli indici, come le tabelle, sono temporanei, quindi spariranno ad esecuzione conclusa!

CREATE INDEX IX_FIA_NADIR_NomeFile ON #ImportFiaNadir(nomefile)
CREATE INDEX IX_FIA_NADIR_Mandato ON #ImportFiaNadir(MandatoNadir)
CREATE INDEX IX_FIA_NADIR_Classe ON #ImportFiaNadir(ClasseQuote)
CREATE INDEX IX_FIA_QTASK_FileImportNadir ON #IncarichiFIA(FileImportNadir)
CREATE INDEX IX_FIA_QTASK_Mandato ON #IncarichiFIA(MandatoQtask)
CREATE INDEX IX_FIA_QTASK_Classe ON #IncarichiFIA(ClasseQuote)

--SELECT * FROM #ImportFiaNadir
--SELECT * FROM #IncarichiFIA

;WITH CHECKincarichi AS (
SELECT ISNULL(NomeFiaQTask,NomeFiaNadir) Fondo
,ISNULL(#IncarichiFIA.ClasseQuote, #ImportFiaNadir.ClasseQuote) classequoteqtask
,IIF(ClienteNadir IS NULL, 'NO','SI') PresenzaNadir
,IIF(Idincarico IS NULL,'NO','SI') PresenzaQtask
,Idincarico
,CodMacroStatoWorkflowIncarico
,NdgQtask
,ClienteNadir
,IIF(NdgQtask = ClienteNadir,'OK','KO') ChkNdg
,AnagraficaIntestatarioQtask
,AnagraficaIntestatarioNadir
,IIF(AnagraficaIntestatarioQtask = AnagraficaIntestatarioNadir,'OK','KO') ChkAnagrafica
,CodCfQtask
,agenteNadir
,CASE WHEN CodCfQtask = agenteNadir
	THEN 'OK'
	WHEN codcfqtask != agentenadir AND IdCheckCF IS NOT NULL THEN 'OK' --metto già qui la forzatura del check
	ELSE 'KO'
	END AS ChkCF
,AnagraficaCFQtask
,desc_agenteNadir
,CASE WHEN AnagraficaIntestatarioQtask = AnagraficaIntestatarioNadir then'OK'
	WHEN AnagraficaIntestatarioQtask != AnagraficaIntestatarioNadir AND IdCheckCF IS NOT NULL THEN 'OK' --metto già qui la forzatura del check
	else 'KO'
 END AS ChkAnagraficaCF
,[C/O Qtask]
,[c/o_spedizione Nadir]
,IIF(RTRIM(LTRIM([C/O Qtask])) = RTRIM(LTRIM([c/o_spedizione Nadir])), 'OK', 'KO') ChkCO
,IndirizzoQtask
,indirizzo_spedizioneNadir
,IIF(IndirizzoQtask = indirizzo_spedizioneNadir, 'OK', 'KO') ChkIndirizzo
,LocalitaQtask
,loc_spedizioneNadir
,case 
	when LocalitaQtask = loc_spedizioneNadir then 'OK'
	when REPLACE(LocalitaQtask,'-',' ') = loc_spedizioneNadir then 'OK' --ECCEZIONE località con trattino che non risultano nei sistemi legacy
	WHEN LocalitaQtask != loc_spedizioneNadir AND IdCheckLocalita IS NOT NULL THEN 'OK' --forzatura generica del check se inseriscono dato aggiuntivo
	else 'KO'
END	ChkLocalita
,CapQtask
,cap_spedizioneNadir
,IIF((ISNULL(CapQtask, '00000') = cap_spedizioneNadir) OR (ISNULL(CapQtask, '')  = cap_spedizioneNadir), 'OK', 'KO') ChkCap
,ProvinciaQtask
,prov_spedizioneNadir
,IIF((ProvinciaQtask = prov_spedizioneNadir) OR (ISNULL(ProvinciaQtask,'' ) = prov_spedizioneNadir), 'OK', 'KO') ChkPro
,NazioneQtask
,nazione_spedizioneNadir
,IIF(NazioneQtaskNadir = nazione_spedizioneNadir, 'OK', 'KO') ChkNaz
,MandatoQtask
,mandatoNadir
,IIF(MandatoQtask = mandatoNadir, 'OK', 'KO') ChKMandato
,DossierQtask
,dossierNadir
,IIF(right(DossierQtask,9) = right(dossierNadir,9), 'OK','KO') ChKDossier
,DataSottoscrizioneQtask
,DataSottoscrizioneNadir
,IIF(DataSottoscrizioneQtask =DataSottoscrizioneNadir, 'OK', 'KO') ChkDataSottoscrizione
,DataCaricamentoQtask
,dt_caricamentoNadir
,IIF(DataCaricamentoQtask = dt_caricamentoNadir, 'OK', 'KO') ChkDataCaricamento
,[Mandato Valido]
,status_mandatoNadir
,IIF(((status_mandatoNadir in (1,2,3) )AND ([Mandato Valido] = 'Sottoscrizioni Valide')) OR 
(status_mandatoNadir = 5 AND  [Mandato Valido]  = 'Mandato Revocato')
, 'OK','KO') CheckRevoca  
,DataRevocaNadir
,DataRevocaQtask
,iif((status_mandatoNadir = 5) and ([Mandato Valido]  = 'Mandato Revocato') and (DataRevocaNadir != DataRevocaQtask), 'KO','OK') ChkDataRevoca
,ImportoLordoQtask
,commitment_lordoNadir
,IIF((commitment_lordoNadir = 0) OR (   ImportoLordoQtask = commitment_lordoNadir) , 'OK', 'KO') ChkImpLor
,ImportoNettoQtask
,commitmentNadir
,IIF(ImportoNettoQtask = commitmentNadir, 'OK', 'KO') ChkImpNet

,NdgCointestatarioQtask
,cclie_coint_21_1Nadir
,IIF(ISNULL(NdgCointestatarioQtask ,'')=  ISNULL(cclie_coint_21_1Nadir,''), 'OK','KO') ChkndgCoint1
,AnagraficaCointestatario1Qtask
,desc_cointest_1Nadir
,IIF(ISNULL(AnagraficaCointestatario1Qtask,'') =  ISNULL(desc_cointest_1Nadir,''), 'OK','KO')ChkDescCoint1
,NdgCointestatario2Qtask
,cclie_coint_21_2Nadir
,IIF(ISNULL(NdgCointestatario2Qtask,'') =  ISNULL(cclie_coint_21_2Nadir,''), 'OK','KO') ChkndgCoint2
,AnagraficaCointestatario2Qtask
,desc_cointest_2Nadir
,IIF(ISNULL(AnagraficaCointestatario2Qtask,'') =  ISNULL(desc_cointest_2Nadir,''), 'OK','KO') ChkDescCoint2
,NdgCointestatario3Qtask
,cclie_coint_21_3Nadir
,IIF(ISNULL(NdgCointestatario3Qtask,'') =  ISNULL(cclie_coint_21_3Nadir,''), 'OK','KO') ChkndgCoint3
,AnagraficaCointestatario3Qtask
,desc_cointest_3Nadir
,IIF(ISNULL(AnagraficaCointestatario3Qtask,'') =  ISNULL(desc_cointest_3Nadir,''), 'OK','KO') ChkDescCoint3
,NdgCointestatario4Qtask
,cclie_coint_21_4Nadir
,IIF(ISNULL(NdgCointestatario4Qtask,'') =  ISNULL(cclie_coint_21_4Nadir,''), 'OK','KO') ChkndgCoint4
,AnagraficaCointestatario4Qtask
,desc_cointest_4Nadir
,IIF(ISNULL(AnagraficaCointestatario4Qtask,'') =  ISNULL(desc_cointest_4Nadir,''), 'OK','KO') ChkDescCoint4
---- altri dati perimetro Qtask
   ,MacroArea
,Area
,CDR
,am
,RagioneSocialeAM
,TM
,RagioneSocialeTM
,[Mandato Pir]
,Commissioni
,[Importo lordo Originale]
,[Importo Netto Iniziale]
,RevocaQtask [Revoca/Variazione]
,DataInizioCollocamento
,#IncarichiFIA.DataClosing
,DataCutOffPagamenti
,DataAssegnazioneQuote
,MinimoSottoscrizioneRetail
,MinimoSottoscrizioneProfessionale
,StatoWorkflowIncarico
,DataVariazioneCommitment
,#IncarichiFIA.IbanContoAfflussi
,#IncarichiFIA.IdCheckCF
,#IncarichiFIA.IdCheckLocalita
FROM #ImportFiaNadir
FULL JOIN #IncarichiFIA ON nomefile = FileImportNadir
AND MandatoNadir = MandatoQtask
AND #ImportFiaNadir.ClasseQuote = #IncarichiFIA.ClasseQuote


), v AS (
SELECT  IIF(
	   ( CHECKincarichi.ChkNdg						       ='KO')
	   or(CHECKincarichi.ChkAnagrafica					   ='KO')
	   or(CHECKincarichi.ChkCF							   ='KO')
	   or(CHECKincarichi.ChkAnagraficaCF                   ='KO')
	   or(CHECKincarichi.ChkCO							   ='KO')
	   or(CHECKincarichi.ChkIndirizzo					   ='KO')
	   or(CHECKincarichi.ChkLocalita					   ='KO')
	   or(CHECKincarichi.ChkCap						       ='KO')
	   or(CHECKincarichi.ChkPro						       ='KO')
	   or(CHECKincarichi.ChkNaz						       ='KO')
	   or(CHECKincarichi.ChKMandato				    	   ='KO')
	   or(CHECKincarichi.ChKDossier					       ='KO')
	   or(CHECKincarichi.ChkDataSottoscrizione			   ='KO')
	   or(CHECKincarichi.ChkDataCaricamento			       ='KO')
	   or(CHECKincarichi.CheckRevoca					   ='KO')
	   or(CHECKincarichi.ChkImpLor						   ='KO')
	   or(CHECKincarichi.ChkImpNet						   ='KO')
	   or(CHECKincarichi.ChkndgCoint1					   ='KO')
	   or(CHECKincarichi.ChkDescCoint1					   ='KO')
	   or(CHECKincarichi.ChkndgCoint2					   ='KO')
	   or(CHECKincarichi.ChkDescCoint2					   ='KO')
	   or(CHECKincarichi.ChkndgCoint3					   ='KO')
	   OR(CHECKincarichi.ChkDescCoint3                     ='KO')
	   OR(CHECKincarichi.ChkDescCoint3                     ='KO')
	 
	   ,'KO', 'OK') ChkGlobale
	   ,CASE WHEN DataSottoscrizioneQtask > dateadd(day,11,DataClosing) then 1 else 0 end FlagSottoscrizionePostClosing
	   ,*
FROM CHECKincarichi
) SELECT s.IbanContoAfflussi iban
,ISNULL(v.Fondo,s.NomeFia) Fondo
,ISNULL(v.classequoteqtask,s.ClasseQuote) classequoteqtask
,s.IbanClasseClosing IbanClasse
,   v.ChkGlobale
   ,v.FlagSottoscrizionePostClosing
   ,v.PresenzaNadir
   ,v.PresenzaQtask
   ,v.Idincarico
   ,v.CodMacroStatoWorkflowIncarico
   ,v.NdgQtask
   ,v.ClienteNadir
   ,v.ChkNdg
   ,v.AnagraficaIntestatarioQtask
   ,v.AnagraficaIntestatarioNadir
   ,v.ChkAnagrafica
   ,v.CodCfQtask
   ,v.agenteNadir
   ,v.ChkCF
   ,v.AnagraficaCFQtask
   ,v.desc_agenteNadir
   ,v.ChkAnagraficaCF
   ,v.[C/O Qtask]
   ,v.[c/o_spedizione Nadir]
   ,v.ChkCO
   ,v.IndirizzoQtask
   ,v.indirizzo_spedizioneNadir
   ,v.ChkIndirizzo
   ,v.LocalitaQtask
   ,v.loc_spedizioneNadir
   ,v.ChkLocalita
   ,v.CapQtask
   ,v.cap_spedizioneNadir
   ,v.ChkCap
   ,v.ProvinciaQtask
   ,v.prov_spedizioneNadir
   ,v.ChkPro
   ,v.NazioneQtask
   ,v.nazione_spedizioneNadir
   ,v.ChkNaz
   ,v.MandatoQtask
   ,v.MandatoNadir
   ,v.ChKMandato
   ,v.DossierQtask
   ,v.dossierNadir
   ,v.ChKDossier
   ,v.DataSottoscrizioneQtask
   ,v.DataSottoscrizioneNadir
   ,v.ChkDataSottoscrizione
   ,CONVERT(DATE,v.DataCaricamentoQtask,105) DataCaricamentoQtask
   ,CONVERT(DATE,v.dt_caricamentoNadir,105) dt_caricamentoNadir
   ,v.ChkDataCaricamento
   ,v.[Mandato Valido]
   ,v.status_mandatoNadir
   ,v.CheckRevoca
   ,v.DataRevocaNadir
   ,v.DataRevocaQtask
   ,v.ChkDataRevoca
   ,v.ImportoLordoQtask
   ,v.commitment_lordoNadir
   ,v.ChkImpLor
   ,v.ImportoNettoQtask
   ,v.commitmentNadir
   ,v.ChkImpNet
   ,v.NdgCointestatarioQtask
   ,v.cclie_coint_21_1Nadir
   ,v.ChkndgCoint1
   ,v.AnagraficaCointestatario1Qtask
   ,v.desc_cointest_1Nadir
   ,v.ChkDescCoint1
   ,v.NdgCointestatario2Qtask
   ,v.cclie_coint_21_2Nadir
   ,v.ChkndgCoint2
   ,v.AnagraficaCointestatario2Qtask
   ,v.desc_cointest_2Nadir
   ,v.ChkDescCoint2
   ,v.NdgCointestatario3Qtask
   ,v.cclie_coint_21_3Nadir
   ,v.ChkndgCoint3
   ,v.AnagraficaCointestatario3Qtask
   ,v.desc_cointest_3Nadir
   ,v.ChkDescCoint3
   ,v.NdgCointestatario4Qtask
   ,v.cclie_coint_21_4Nadir
   ,v.ChkndgCoint4
   ,v.AnagraficaCointestatario4Qtask
   ,v.desc_cointest_4Nadir
   ,v.ChkDescCoint4
   ,v.MacroArea
   ,v.Area
   ,v.CDR
   ,v.am
   ,v.RagioneSocialeAM
   ,v.TM
   ,v.RagioneSocialeTM
   ,v.[Mandato Pir]
   ,v.Commissioni
   ,v.[Importo lordo Originale]
   ,v.[Importo Netto Iniziale]
   ,v.[Revoca/Variazione]
   ,v.IbanContoAfflussi
   ,StatoWorkflowIncarico
   ,DataVariazioneCommitment
   ,v.IdCheckCF
   ,v.IdCheckLocalita
,isnull(v.DataInizioCollocamento, s.DataInizioCollocamento) DataInizioCollocamento
,isnull(v.DataClosing,s.DataClosing) DataClosing
,isnull(v.DataCutOffPagamenti,s.DataCutOffPagamenti) DataCutOffPagamenti
,isnull(v.DataAssegnazioneQuote,s.DataAssegnazioneQuote) DataAssegnazioneQuote
,isnull(v.MinimoSottoscrizioneRetail,s.MinimoSottoscrizioneRetail) MinimoSottoscrizioneRetail
,isnull(v.MinimoSottoscrizioneProfessionale, s.MinimoSottoscrizioneProfessionale) MinimoSottoscrizioneProfessionale
,CASE 
	WHEN [Mandato Valido] = 'Sottoscrizioni Valide' THEN ImportoLordoQtask
	ELSE 0 
END AS ImportoLordoSomma
,CASE 
	WHEN [Mandato Valido] = 'Sottoscrizioni Valide' THEN ImportoNettoQtask
    ELSE 0
END AS ImportoNettoSomma
,CASE
	WHEN [Mandato Valido] = 'Mandato Revocato' THEN ImportoLordoQtask
	ELSE 0
END AS ImportoLordoSommaRevoche
,CASE
	WHEN [Mandato Valido] = 'Mandato Revocato' THEN ImportoNettoQtask
	ELSE 0
END AS ImportoNettoSommaRevoche
,case 
	when v.PresenzaNadir = 'NO' and v.DataCaricamentoQtask  = CONVERT(varchar(10),GETDATE(),103) 
		THEN 1
	else 0
end EscludiCaricamentiGiornata 
,CASE
	WHEN v.PresenzaNadir = 'SI' AND v.presenzaqtask = 'NO' AND v.status_mandatoNadir = '5'
		THEN 1
	ELSE 0
END EscludiStatus5Nadir
,IIF(ChkGlobale = 'KO' AND v.PresenzaQtask = 'SI' 
	AND (PresenzaNadir != 'NO' OR DataCaricamentoQtask < CONVERT(VARCHAR(10),GETDATE(),103))
	,1
	,0
	) CheckDE
,IIF(ChkGlobale = 'KO' AND PresenzaNadir = 'SI'
		AND PresenzaQtask = 'NO'
	,1
	,0
	) CheckNOQtask
,IIF(ChkGlobale = 'KO' AND PresenzaNadir = 'NO'
	AND PresenzaQtask = 'SI'
	,1
	,0
	)CheckNONadir
,IIF(PresenzaQtask = 'SI' AND [Mandato Valido] = 'Mandato Revocato'
	,1
	,0
	) RevocheQTask
,IIF(PresenzaQtask = 'SI' AND [Mandato Valido] = 'Sottoscrizioni Valide'
	,1
	,0
	) SottoscrizioniQTask
,s.DataFineCaricamento
,CASE WHEN DataVariazioneCommitment IS NOT NULL AND DataVariazioneCommitment > s.DataFineCaricamento
	THEN 'SI'
	WHEN DataVariazioneCommitment IS NOT NULL THEN 'NO'
	END VariazioneDopoFineCaricamento

FROM #configFIA s --come accennato sopra, parto come base dalla config, questo consentirà al report (qualora fossero già censite classi non ancora iniziate)
				  --di farle comunque vedere nello sheet di riepilogo, ma con i contatori delle sottoscrizioni valide/revoche a zero.

LEFT JOIN v --metto in left join l'estratto con i check, se non esistono ne incarichi ne flussi per certe classi, sarà estratto ma tutto a NULL
ON v.Fondo = s.NomeFia								   
AND s.ClasseQuote = v.classequoteqtask


DROP TABLE #ibanclasseclosing, #configFIA, #ImportFIANadir, #IncarichiFIA --d'obbligo! per evitare di avere in memoria (tempdb) tabelle che non ci servono più

END

GO