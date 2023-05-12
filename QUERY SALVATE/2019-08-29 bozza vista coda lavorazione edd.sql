USE CLC
GO

--SELECT * FROM rs.v_CESAM_AZ_Antiriciclaggio_EDD_Lavorazione


SELECT l.IdIncarico
		,ti.DataCreazione
		,ti.DataUltimaTransizione
		,ti.FlagUrgente
		,CodMotivoVerifica
		,D_MotivoVerifica.Descrizione MotivoVerifica
		,ti.CodTipoIncarico
		,descrizioni.TipoIncarico
		,l.NatoUrgente
		,ti.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico
		,descrizioni.AttributoIncarico

		,IIF(l.IncaricoConcluso = 1 OR descrizioni.CodMacroStatoWFIncarico = 26
				,1 --'Incarico Chiuso/Archiviato'
				,IIF(l.CodStepLavorazioneAttuale IN (-2,0), 2 --'Stato di Attesa - Esterno'
					,3
					)
			) CodStepLavorazioneAttuale
		,IIF(l.IncaricoConcluso = 1 OR descrizioni.CodMacroStatoWFIncarico IN (13,26),1,0) IncaricoChiusoArchiviato
		
		,gestore.Etichetta GestoreIncarico
		,ISNULL(van.ChiaveClienteIntestatario, '') + ' - '  
		+ IIF(van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = '', van.RagioneSocialeIntestatario, van.CognomeIntestatario)
       + ' ' + ISNULL(van.NomeIntestatario, '') Cliente

	   ,l.SogliaMinuti
	   ,l.SogliaMinuti/60/8 GiorniLavorazioneConsentiti

	   ,SUM(l.[Minuti Lavorazione Pre-Istruttoria]) + SUM(l.[Minuti Lavorazione Istruttoria]) MinutiLavorazioneCESAM
	   ,SUM(l.[Minuti Lavorazione ESTERNA]) MinutiLavorazioneEsterna

FROM scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato l
JOIN T_Incarico ti ON l.IdIncarico = ti.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico

LEFT JOIN T_Antiriciclaggio ON ti.IdIncarico = T_Antiriciclaggio.IdIncarico
LEFT JOIN D_MotivoVerifica ON T_Antiriciclaggio.CodMotivoVerifica = D_MotivoVerifica.Codice

LEFT JOIN T_R_Incarico_Operatore triop ON ti.IdIncarico = triop.IdIncarico
LEFT JOIN S_Operatore gestore ON triop.IdOperatore = gestore.IdOperatore
WHERE 
van.ProgressivoPersona = 1
AND triop.CodRuoloOperatoreIncarico = 1

GROUP BY
l.IdIncarico
,ti.DataCreazione
,ti.DataUltimaTransizione
,ti.FlagUrgente
,CodMotivoVerifica
,D_MotivoVerifica.Descrizione 
,ti.CodTipoIncarico
,descrizioni.TipoIncarico
,l.NatoUrgente
,descrizioni.CodMacroStatoWFIncarico
,ti.CodStatoWorkflowIncarico
,descrizioni.StatoWorkflowIncarico
,descrizioni.AttributoIncarico
,l.IncaricoConcluso
,CodStepLavorazioneAttuale
,gestore.Etichetta 
,van.ChiaveClienteIntestatario
,van.RagioneSocialeIntestatario
,van.CognomeIntestatario
,van.NomeIntestatario
,l.SogliaMinuti

