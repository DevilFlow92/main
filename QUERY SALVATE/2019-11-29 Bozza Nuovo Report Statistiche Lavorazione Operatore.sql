USE CLC
GO


--ALTER VIEW rs.v_CESAM_AZ_Antiriciclaggio_StatisticheLavorazioneOperatore
--AS
--;

WITH D_FaseProcessoAML
AS (SELECT
	1 CodFaseProcessoAML
	,'Istruttoria' FaseProcessoAML
UNION
SELECT
	2 CodFaseProcessoAML
	,'Solleciti / Integrazioni' FaseProcessoAML
UNION
SELECT
	3 CodFaseProcessoAML
	,'Analisi / Finalizzazione' FaseProcessoAML),
dati
AS (SELECT
	ti.IdIncarico
	,ti.DataCreazione
	,d.TipoIncarico
	,CASE
		WHEN ti.CodTipoIncarico = 524 AND
			ApprAML.Codice IS NOT NULL THEN ApprAML.Descrizione

		WHEN ti.CodTipoIncarico = 524 AND
			ApprAML.Codice IS NULL THEN 'Esiti Banche Dati'
		ELSE d.TipoIncarico

	END TipoProcesso
	,ti.DataUltimaTransizione
	,ti.CodStatoWorkflowIncarico
	,d.CodMacroStatoWFIncarico CodMacroStatoAttuale
	,d.StatoWorkflowIncarico StatoAttuale

	,van.ChiaveClienteIntestatario + ' - ' +
	CASE
		WHEN van.CognomeIntestatario IS NULL OR
			van.CognomeIntestatario = '' THEN van.RagioneSocialeIntestatario
		ELSE van.CognomeIntestatario + ' ' + ISNULL(van.NomeIntestatario, '')
	END Intestatario

	,van.CodicePromotore + ' - ' +
	CASE
		WHEN van.CognomePromotore IS NULL OR
			van.CognomePromotore = '' THEN van.RagioneSocialePromotore
		ELSE van.CognomePromotore + ' ' + ISNULL(van.NomePromotore, '')
	END Consulente

	,lwi.IdTransizione

	,lwi.DataTransizione DataLavorazione

	,OperatoreTransizione.IdOperatore
	,OperatoreTransizione.Etichetta OperatoreTransizione
	,lwi.CodStatoWorkflowIncaricoPartenza
	,IIF(macropartenza.Descrizione IS NULL, '', macropartenza.Descrizione + ' - ') + partenza.Descrizione StatoPartenza
	,AttributoPartenza.Descrizione AttibutoPartenza
	,lwi.CodStatoWorkflowIncaricoDestinazione
	,IIF(macrodestinazione.Descrizione IS NULL, '', macrodestinazione.Descrizione + ' - ') + destinazione.Descrizione StatoDestinazione
	,AttributoDestinazione.Descrizione AttributoDestinazione


	/*********************************** MAPPATURA FASI ***************************************************/

	/****************************** APPROFONDIMENTI AML *********************************************/
	,CASE
		WHEN ti.CodTipoIncarico = 524
			--AND lwi.CodStatoWorkflowIncaricoPartenza IN (7130	--In valutazione		
			--													,20751  --Esiti Banche Dati
			--													,20752 --Profilo Alto
			--													,20753 --Origine dei Fondi
			--													,20754 --Bonifici Esteri
			--													,20755 --Movimenti superiori a 5 MLN
			--													,20766 --Monitoraggio clientela
			--													)
			--AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15540	--Invio richiesta approfondimenti al CF
			--												 ,15549	--Invio Proposta Azione di Mitigazione
			--												 ,15543	--Invio Scheda Omonimia al CF
			--												)

			AND lwi.CodStatoWorkflowIncaricoPartenza = 6500 --Nuova - Creata
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 7130	--In valutazione
		THEN 1 --Istruttoria Approfondimenti AML

		WHEN ti.CodTipoIncarico = 524 AND
			lwi.CodStatoWorkflowIncaricoDestinazione IN (12360	--Primo Sollecito
			, 12370	--Secondo Sollecito
			, 12380	--Terzo Sollecito	
			, 15495	--Prima richiesta Integrazione
			, 15553	--Seconda richiesta integrazione
			, 15555	--Terza richiesta integrazione	
			) THEN 2 --Solleciti/Integrazioni Approfondimenti AML

		WHEN ti.CodTipoIncarico = 524 AND
			lwi.CodStatoWorkflowIncaricoDestinazione IN (820 --Lavorazione Conclusa

			) THEN 3 --Analisi/Finalizzazione Approfondimenti AML

		/****************************** VERIFICHE RAFFORZATE *********************************************/

		WHEN ti.CodTipoIncarico = 522 AND
			(
			(lwi.CodStatoWorkflowIncaricoPartenza = 6500 --Nuova - Creata
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 7130 --In Valutazione
			--IN (15539	--Invio proposta
			--										 ,15556	--Richiesta integrazioni a soggetti Terzi
			--)
			) --Nuovo Processo

			OR (lwi.CodStatoWorkflowIncaricoPartenza IN (6515	--Verifica documentazione 
			, 2000	--Analisi Documenti
			) AND
			lwi.CodStatoWorkflowIncaricoDestinazione = 7130	--In valutazione


			)--Vecchio Processo		 
			) THEN 1 --Istruttoria Verifiche Rafforzate


		WHEN ti.CodTipoIncarico = 522 AND
			(
			(
			lwi.CodStatoWorkflowIncaricoDestinazione IN (12360	--Primo Sollecito
			, 12370	--Secondo Sollecito
			, 12380	--Terzo Sollecito	
			, 15495	--Prima richiesta Integrazione
			, 15553	--Seconda richiesta integrazione
			, 15555	--Terza richiesta integrazione	
			, 15556	--Richiesta integrazioni a soggetti Terzi
			)
			) --Nuovo Processo
			OR (
			lwi.CodAttributoIncaricoDestinazione IN (238	--IN ATTESA DI INTEGRAZIONI
			, 284	--1a RICHIESTA INTEGRAZ. SCHEDA PF
			, 285	--PRIMA RICHIESTA SCHEDA PF
			, 286	--SECONDA RICHIESTA SCHEDA PF
			, 371	--2a RICHIESTA INTEGRAZ. SCHEDA PF

			)

			)
			) --Vecchio Processo
		THEN 2 --Solleciti / Integrazioni Verifiche Rafforzate



		WHEN ti.CodTipoIncarico = 522 AND
			(
			(
			lwi.CodStatoWorkflowIncaricoDestinazione IN (6566	--Da Firmare												  
			, 6596 --Firma Interna
			) AND
			rdestinazione.CodMacroStatoWorkflowIncarico = 14 --Gestita
			) OR
			(
			lwi.CodStatoWorkflowIncaricoDestinazione = 6585	--Gest Firma Interna
			AND rdestinazione.CodMacroStatoWorkflowIncarico IS NULL
			) OR
			(lwi.CodStatoWorkflowIncaricoPartenza = 7130 --In Valutazione
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 6570	--Definita Inviata

			)
			) THEN 3 --Analisi / Finalizzazione Verifiche Rafforzate


		/****************************** ONBOARDING ANTIRICICLAGGIO ********************************************/

		WHEN ti.CodTipoIncarico = 112
			--AND lwi.CodStatoWorkflowIncaricoPartenza = 7130	--In valutazione
			--AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15539	--Invio proposta
			--												 ,15429	--Richiesta chiarimenti/integrazioni
			--												)
			AND lwi.CodStatoWorkflowIncaricoPartenza = 6500 AND
			lwi.CodStatoWorkflowIncaricoDestinazione = 7130	--In valutazione
		THEN 1 --Istruttoria Onboarding Antiriciclaggio

		WHEN ti.CodTipoIncarico = 112
			--AND lwi.CodStatoWorkflowIncaricoPartenza = 15541 --Riscontro Ricevuto
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 15429	--Richiesta chiarimenti/integrazioni
		THEN 2 --Solleciti / Integrazioni Onboarding Antiriciclaggio

		WHEN ti.CodTipoIncarico = 112 AND
			(
			(lwi.CodStatoWorkflowIncaricoPartenza = 6500 --Nuova - Creata
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 11950 --Lavorazione non necessaria
			) OR
			(lwi.CodStatoWorkflowIncaricoPartenza = 15541 --Riscontro Ricevuto
			AND lwi.CodStatoWorkflowIncaricoDestinazione IN (11950 --Lavorazione non necessaria
			, 20738	--Parere favorevole
			, 20739	--Parere non favorevole
			)

			)
			) THEN 3 --Analisi / Finalizzazione OnBoarding AML	

	END CodFaseProcessoAML

/***************************************************************************************************/

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d
	ON ti.IdIncarico = d.IdIncarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van
	ON ti.IdIncarico = van.IdIncarico
	AND van.ProgressivoPersona = 1

LEFT JOIN (SELECT
	MAX(lwi.IdTransizione) IdTransizione
	,lwi.IdIncarico
	,lwi.CodStatoWorkflowIncaricoDestinazione
FROM T_Incarico
JOIN L_WorkflowIncarico lwi
	ON T_Incarico.IdIncarico = lwi.IdIncarico
	AND CodArea = 8
	AND CodCliente = 23
	AND CodTipoIncarico = 524
WHERE lwi.CodStatoWorkflowIncaricoDestinazione IN (20751  --Esiti Banche Dati
, 20752 --Profilo Alto
, 20753 --Origine dei Fondi
, 20754 --Bonifici Esteri
, 20755 --Movimenti superiori a 5 MLN
, 20766 --Monitoraggio clientela
)
GROUP BY	lwi.IdIncarico
			,lwi.CodStatoWorkflowIncaricoDestinazione) inputApprAML
	ON ti.IdIncarico = inputApprAML.IdIncarico

LEFT JOIN D_StatoWorkflowIncarico ApprAML
	ON ApprAML.Codice = inputApprAML.CodStatoWorkflowIncaricoDestinazione

LEFT JOIN L_WorkflowIncarico lwi
	ON ti.IdIncarico = lwi.IdIncarico

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rpartenza
	ON lwi.CodStatoWorkflowIncaricoPartenza = rpartenza.CodStatoWorkflowIncarico
	AND ti.CodCliente = rpartenza.CodCliente
	AND ti.CodTipoIncarico = rpartenza.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico macropartenza
	ON rpartenza.CodMacroStatoWorkflowIncarico = macropartenza.Codice
LEFT JOIN D_StatoWorkflowIncarico partenza
	ON partenza.Codice = lwi.CodStatoWorkflowIncaricoPartenza
LEFT JOIN D_AttributoIncarico AttributoPartenza
	ON lwi.CodAttributoIncaricoPartenza = AttributoPartenza.Codice

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rdestinazione
	ON lwi.CodStatoWorkflowIncaricoDestinazione = rdestinazione.CodStatoWorkflowIncarico
	AND ti.CodCliente = rdestinazione.CodCliente
	AND ti.CodTipoIncarico = rdestinazione.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico macrodestinazione
	ON rdestinazione.CodMacroStatoWorkflowIncarico = macrodestinazione.Codice
LEFT JOIN D_StatoWorkflowIncarico destinazione
	ON destinazione.Codice = lwi.CodStatoWorkflowIncaricoDestinazione
LEFT JOIN D_AttributoIncarico AttributoDestinazione
	ON lwi.CodAttributoIncaricoDestinazione = AttributoDestinazione.Codice

LEFT JOIN S_Operatore OperatoreTransizione
	ON lwi.IdOperatore = OperatoreTransizione.IdOperatore

LEFT JOIN (SELECT
	T_DatoAggiuntivo.*
FROM T_DatoAggiuntivo
JOIN T_Incarico
	ON T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico
	AND CodArea = 8
	AND CodCliente = 23
	AND CodTipoIncarico = 522
WHERE CodTipoDatoAggiuntivo = 1625	--Tipo Incarico Origine
AND Testo = 'Ex Antiriciclaggio Storico') AMLStorico
	ON ti.IdIncarico = AMLStorico.IdIncarico


WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico IN (112, 522, 524, 549)
AND AMLStorico.IdDatoAggiuntivo IS NULL

--sono i 16 primi incarichi di onboarding antiriciclaggio gestiti secondo il vecchio processo dismesso
AND ti.IdIncarico NOT IN (13552980
, 13561107
, 13561406
, 13561622
, 13562894
, 13562932
, 13563036
, 13563268
, 13563512
, 13563666
, 13563728
, 13564459
, 13564528
, 13564578
, 13564635
, 13564661
))
--, v AS (
SELECT --TOP 20

	dati.IdIncarico
	,dati.DataCreazione
	,dati.TipoIncarico
	,dati.TipoProcesso
	,dati.DataUltimaTransizione
	,dati.CodMacroStatoAttuale
	,dati.CodStatoWorkflowIncarico
	,dati.StatoAttuale
	,dati.Intestatario
	,dati.Consulente
	,dati.IdTransizione
	,dati.DataLavorazione
	,dati.IdOperatore
	,dati.OperatoreTransizione
	,dati.CodStatoWorkflowIncaricoPartenza
	,dati.StatoPartenza
	,dati.AttibutoPartenza
	,dati.CodStatoWorkflowIncaricoDestinazione
	,dati.StatoDestinazione
	,dati.AttributoDestinazione
	,dati.CodFaseProcessoAML
	,D_FaseProcessoAML.FaseProcessoAML

FROM dati
JOIN D_FaseProcessoAML
	ON D_FaseProcessoAML.CodFaseProcessoAML = dati.CodFaseProcessoAML

--WHERE DataCreazione >= '2017-03-01'
--AND dati.IdIncarico = 11538062 -- 11538032 --11527158 --11527147 --2268052 --13226302 --13212520
--AND IdIncarico = 11658910 
--ORDER BY IdIncarico

--) 
--SELECT IdIncarico, TipoIncarico, DataCreazione
--,*
--FROM v 
--WHERE codMacroStatoAttuale = 13
----AND IdIncarico = 12660957
--AND IdIncarico in (8126323
--,8566187
--,10128628
--,10128730
--,11321028
--)
--GROUP BY IdIncarico, TipoIncarico, DataCreazione
--HAVING COUNT(CodFaseProcessoAML) = 1

GO