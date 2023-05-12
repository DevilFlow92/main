USE clc
GO

ALTER VIEW rs.v_CESAM_AZ_Antiriciclaggio_StatisticheLavorazioneOperatore AS 

SELECT ti.IdIncarico
,ti.DataCreazione
,ti.CodTipoIncarico
,descrizioni.TipoIncarico
,descrizioni.CodMacroStatoWFIncarico CodMacroStatoWorkflowIncaricoAttuale
,ti.CodStatoWorkflowIncarico CodStatoWorkflowIncaricoAttuale
,descrizioni.StatoWorkflowIncarico StatoWorkFlowIncaricoAttuale
,ti.CodAttributoIncarico CodAttributoIncaricoAttuale
,descrizioni.AttributoIncarico AttributoIncaricoAttuale
,ti.DataUltimaTransizione
,IIF(natourgente.IdTransizione is NOT NULL,'Sì','No') NatoUrgente

,lwi.DataTransizione DataLavorazione

,lwi.CodStatoWorkflowIncaricoPartenza
,macropartenza.Descrizione + ' - ' + partenza.Descrizione StatoWorkflowIncaricoPartenza
,lwi.CodAttributoIncaricoPartenza 
,attrpartenza.Descrizione AttributoIncaricoPartenza

,lwi.CodStatoWorkflowIncaricodestinazione
,macrodestinazione.Descrizione + ' - ' + destinazione.Descrizione StatoWorkflowIncaricodestinazione
,lwi.CodAttributoIncaricodestinazione 
,attrdestinazione.Descrizione AttributoIncaricodestinazione


,so.IdOperatore IdOperatoreTransizione
,so.Etichetta OperatoreTransizione

,CASE 

		WHEN ti.CodTipoIncarico IN (66,522) 
			AND  lwi.CodStatoWorkflowIncaricoPartenza IS NULL 
			and lwi.CodStatoWorkflowIncaricoDestinazione = 6500 
		THEN '1 - Incarichi Creati'

		WHEN ti.CodTipoIncarico = 524 
			AND lwi.CodStatoWorkflowIncaricoPartenza = 7130 --In Gestione - In Valutazione
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 15548	--Esito Negativo
			THEN '0 - Negativi'
			
--     	ELSE NULL END AS Step1
--,CASE 
		WHEN ti.CodTipoIncarico = 66
			AND lwi.CodStatoWorkflowIncaricoPartenza = 7130
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 7130
			AND lwi.CodAttributoIncaricoDestinazione = 312	--PROPOSTA SCHEDA PF
			THEN '2 - Analisi Preliminare'
		WHEN ti.CodTipoIncarico = 522
			AND lwi.CodStatoWorkflowIncaricoPartenza = 7130
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 15539	--Invio proposta
			THEN '2 - Analisi Preliminare'
		WHEN ti.CodTipoIncarico = 524 
			AND lwi.CodStatoWorkflowIncaricoPartenza = 7130 --In Gestione - In Valutazione
			AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15543	--Invio Scheda Omonimia al CF
														     ,15549	--Invio Proposta Azione di Mitigazione
															)
			THEN '1 - Verifica Omonimia'
--		ELSE NULL END AS Step2
--,case
		WHEN ti.CodTipoIncarico = 66
		AND CodStatoWorkflowIncaricoPartenza = 7130
		AND CodStatoWorkflowIncaricoDestinazione = 7130
		AND lwi.CodAttributoIncaricoDestinazione = 285	--PRIMA RICHIESTA SCHEDA PF
			THEN '3 - Invio Scheda al Consulente'

		WHEN ti.CodTipoIncarico = 522
			AND lwi.CodStatoWorkflowIncaricoPartenza = 15541	--Riscontro Ricevuto
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 15540	--Invio richiesta approfondimenti al CF
			THEN '3 - Invio Scheda al Consulente'
		WHEN ti.CodTipoIncarico = 524
			AND lwi.CodStatoWorkflowIncaricoPartenza IN (15542, 20211) --Riscontro ricevuto dal CF
			AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15548	--Esito Negativo
															 ,15549 --Invio Proposta Azione di Mitigazione
															)
			THEN '2 - Verifica Completata'
--		ELSE NULL END AS Step3

--,case
		WHEN ti.CodTipoIncarico in (66,522) 
		AND lwi.CodStatoWorkflowIncaricoDestinazione IN ( 6566 --Da Firmare 
															,6596	--Firma Interna
															)
			THEN '4 - Analisi Completata'
		
		WHEN ti.CodTipoIncarico = 524
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 15549 --Invio Proposta Azione di Mitigazione
			AND inputazionemitigazione.IdComunicazione IS NOT NULL 
			THEN '3 - Invio Proposta Azione Mitigazione'
--	ELSE null END as Step4

--,CASE
		WHEN ti.CodTipoIncarico IN (66,522) 
		AND lwi.CodStatoWorkflowIncaricoDestinazione = 6570 --Definita - Inviata
			THEN '5 - Invio Analisi'
		
		WHEN ti.CodTipoIncarico = 524
			AND lwi.CodStatoWorkflowIncaricoPartenza IN (15542, 15541)	--Riscontro Ricevuto
			AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15547 --Esito Positivo
															,15548 --Esito Negativo
															)
			THEN '4 - Gestione Riscontro Ricevuto su Proposta'

			--ELSE NULL	end AS Step5
ELSE null END AS LavorazioneOperatore

	,inputazionemitigazione.IdComunicazione
	,inviopropostamitigazione.DataInvio

,CASE  ti.CodStatoWorkflowIncarico 
	WHEN 15547 --Esito Positivo
	THEN 'Positivo'

	WHEN 15548 --Esito Negativo
	THEN 'Negativo'

	ELSE NULL end AS EsitoVerifica
	
FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico
AND van.ProgressivoPersona = 1

JOIN L_WorkflowIncarico lwi ON ti.IdIncarico = lwi.IdIncarico

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rpartenza ON ti.CodCliente = rpartenza.CodCliente
AND ti.CodTipoIncarico = rpartenza.CodTipoIncarico
AND lwi.CodStatoWorkflowIncaricoPartenza = rpartenza.CodStatoWorkflowIncarico

LEFT JOIN D_StatoWorkflowIncarico partenza ON partenza.Codice = rpartenza.CodStatoWorkflowIncarico
LEFT JOIN D_AttributoIncarico attrpartenza ON attrpartenza.Codice = lwi.CodAttributoIncaricoPartenza
LEFT JOIN D_MacroStatoWorkflowIncarico macropartenza ON rpartenza.CodMacroStatoWorkflowIncarico = macropartenza.Codice

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rdestinazione ON ti.CodCliente = rdestinazione.CodCliente
AND ti.CodTipoIncarico = rdestinazione.CodTipoIncarico
AND lwi.CodStatoWorkflowIncaricoDestinazione = rdestinazione.CodStatoWorkflowIncarico

LEFT JOIN D_StatoWorkflowIncarico destinazione ON destinazione.Codice = rdestinazione.CodStatoWorkflowIncarico
LEFT JOIN D_AttributoIncarico attrdestinazione ON attrdestinazione.Codice = lwi.CodAttributoIncaricodestinazione
LEFT JOIN D_MacroStatoWorkflowIncarico macrodestinazione ON rdestinazione.CodMacroStatoWorkflowIncarico = macrodestinazione.Codice

LEFT JOIN (SELECT IdTransizione,IdIncarico FROM L_WorkflowIncarico
			WHERE CodStatoWorkflowIncaricoPartenza IS null AND CodStatoWorkflowIncaricoDestinazione = 6500
			AND FlagUrgenteDestinazione = 1

			) natourgente ON ti.IdIncarico = natourgente.IdIncarico

LEFT JOIN (
			SELECT MIN(IdComunicazione) IdComunicazione, IdIncarico
			FROM T_Comunicazione
			WHERE IdTemplate in (13803	--Proposte Az. di Mitigazione sulla clientela - CF
								,13804 --Proposte Az. di Mitigazione sulla clientela - BC)
								)
				OR (Mittente = 'approfondimenti.antiriciclaggio@azimut.cesamoffice.it' AND Destinatario = 'massimiliano.mazzocchi@azimut.it')
			GROUP BY IdIncarico
	
			) inputazionemitigazione ON inputazionemitigazione.IdIncarico = ti.IdIncarico

LEFT JOIN T_Comunicazione inviopropostamitigazione ON inputazionemitigazione.IdComunicazione = inviopropostamitigazione.IdComunicazione

LEFT JOIN S_Operatore so ON lwi.IdOperatore = so.IdOperatore

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico IN (66,522,524)

/*
AND ti.IdIncarico NOT IN (12294416
,12294418
,12294424
,12294490
,12294508
,12294532
,12294563
,12294567
,12294609
) --Escludo primi incarichi per i quali sono state effettuate delle transizioni doppie
*/


--AND ti.IdIncarico = 12294560


SELECT 	IdIncarico
		,DataCreazione
		,CodTipoIncarico
		,TipoIncarico
		,CodMacroStatoWorkflowIncaricoAttuale
		,CodStatoWorkflowIncaricoAttuale
		,StatoWorkFlowIncaricoAttuale
		,CodAttributoIncaricoAttuale
		,AttributoIncaricoAttuale
		,DataUltimaTransizione
		,NatoUrgente
		,DataLavorazione
		,CodStatoWorkflowIncaricoPartenza
		,StatoWorkflowIncaricoPartenza
		,CodAttributoIncaricoPartenza
		,AttributoIncaricoPartenza
		,CodStatoWorkflowIncaricodestinazione
		,StatoWorkflowIncaricodestinazione
		,CodAttributoIncaricodestinazione
		,AttributoIncaricodestinazione
		,IdOperatoreTransizione
		,OperatoreTransizione
		,LavorazioneOperatore
		,IdComunicazione
		,DataInvio
		,EsitoVerifica 
FROM rs.v_CESAM_AZ_Antiriciclaggio_StatisticheLavorazioneOperatore	

GO