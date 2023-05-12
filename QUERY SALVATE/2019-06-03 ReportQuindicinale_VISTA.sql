USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_Antiriciclaggio_ReportAtteseSchede AS 

/*
Author: Lorenzo Fiori
Utilizzata nel report: AZ - Antiriciclaggio - Attesa Schede Conoscitive
*/

SELECT 
	ti.IdIncarico
	,ti.ChiaveCliente
	,ti.FlagUrgente

	,descrizioni.StatoWorkflowIncarico
	,descrizioni.AttributoIncarico
	,IIF(van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = '', van.RagioneSocialeIntestatario, van.CognomeIntestatario) + ' ' + ISNULL(van.NomeIntestatario, '')
	+ IIF(van.ChiaveClienteIntestatario IS NULL, '', ' ' + van.ChiaveClienteIntestatario) Anagrafica

	,IdAntiriciclaggio
	,CodMotivoVerifica
	,D_MotivoVerifica.Descrizione MotivoVerifica
	,CodSanatoriaFiscale
	,D_SanatoriaFiscale.Descrizione SanatoriaFiscale

	,ISNULL(van.CodicePromotore, '') + ' - ' + IIF(van.CognomePromotore IS NULL OR van.CognomePromotore = '', van.RagioneSocialePromotore, van.CognomePromotore)
	+ ' ' + ISNULL(van.NomePromotore, '') Promotore

	,ti.DataCreazione
	,ti.DataUltimaTransizione

	,so.Etichetta GestoreIncarico

	,CASE
		WHEN lwi.CodAttributoIncaricoPartenza IN (284	--1a RICHIESTA INTEGRAZ. SCHEDA PF
			, 285	--PRIMA RICHIESTA SCHEDA PF
			, 286	--SECONDA RICHIESTA SCHEDA PF
			, 371	--2a RICHIESTA INTEGRAZ. SCHEDA PF
			) OR
			lwi.CodAttributoIncaricoDestinazione IN (284	--1a RICHIESTA INTEGRAZ. SCHEDA PF
			, 285	--PRIMA RICHIESTA SCHEDA PF
			, 286	--SECONDA RICHIESTA SCHEDA PF
			, 371	--2a RICHIESTA INTEGRAZ. SCHEDA PF
			) THEN 1 --Transizioni Incarico 66

		WHEN lwi.CodStatoWorkflowIncaricoPartenza IN (12360	--Primo Sollecito
			, 12370	--Secondo Sollecito
			, 12380	--Terzo Sollecito
			, 15495	--Prima richiesta Integrazione
			, 15540	--Invio richiesta approfondimenti al CF
			, 15553	--Seconda richiesta integrazione
			, 15555	--Terza richiesta integrazione
			) OR
			lwi.CodStatoWorkflowIncaricoDestinazione IN (12360	--Primo Sollecito
			, 12370	--Secondo Sollecito
			, 12380	--Terzo Sollecito
			, 15495	--Prima richiesta Integrazione
			, 15540	--Invio richiesta approfondimenti al CF
			, 15553	--Seconda richiesta integrazione
			, 15555	--Terza richiesta integrazione
			) THEN 2 --Transizioni nuovo incarico verifiche rafforzate
		ELSE 0
	END AS TipoTransizione

	,MAX(lwi.IdTransizione) OVER (PARTITION BY lwi.IdIncarico) AS [ultimaTransizione]
	,LAG(lwi.DataTransizione, 1) OVER (PARTITION BY lwi.IdIncarico ORDER BY lwi.IdTransizione ASC) AS DataTransizionePrecedente
	,lwi.IdTransizione
	,lwi.DataTransizione
	,ISNULL(comunicazione.IdComunicazione,1) IdComunicazione

FROM T_Incarico ti
JOIN L_WorkflowIncarico lwi	ON ti.IdIncarico = lwi.IdIncarico

--etichette stati e tipi incarico
LEFT JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON ti.IdIncarico = descrizioni.IdIncarico

--anagrafiche
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van
	ON ti.IdIncarico = van.IdIncarico

--tab antiriciclaggio
LEFT JOIN T_Antiriciclaggio
	ON ti.IdIncarico = T_Antiriciclaggio.IdIncarico
LEFT JOIN D_MotivoVerifica
	ON T_Antiriciclaggio.CodMotivoVerifica = D_MotivoVerifica.Codice
LEFT JOIN D_SanatoriaFiscale
	ON T_Antiriciclaggio.CodSanatoriaFiscale = D_SanatoriaFiscale.Codice

--gestore incarico
LEFT JOIN T_R_Incarico_Operatore triop
	ON ti.IdIncarico = triop.IdIncarico
LEFT JOIN S_Operatore so
	ON triop.IdOperatore = so.IdOperatore

--check comunicazione prima scheda
LEFT JOIN (SELECT MIN(IdComunicazione) IdComunicazione , IdIncarico
			FROM T_Comunicazione
			WHERE IdTemplate in (3112 )
			GROUP BY IdIncarico
			) comunicazione ON comunicazione.IdIncarico = ti.IdIncarico



WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND (
		(
			ti.CodTipoIncarico = 66
			AND ti.CodStatoWorkflowIncarico = 7130	--In valutazione
			AND ti.CodAttributoIncarico IN (284	--1a RICHIESTA INTEGRAZ. SCHEDA PF
											, 285	--PRIMA RICHIESTA SCHEDA PF
											, 286	--SECONDA RICHIESTA SCHEDA PF
											, 371	--2a RICHIESTA INTEGRAZ. SCHEDA PF
											)
		)

		OR (
			 ti.CodTipoIncarico = 522
			 AND ti.CodStatoWorkflowIncarico IN (12360	--Primo Sollecito
												, 12370	--Secondo Sollecito
												, 12380	--Terzo Sollecito
												, 15495	--Prima richiesta Integrazione
												, 15540	--Invio richiesta approfondimenti al CF
												, 15553	--Seconda richiesta integrazione
												, 15555	--Terza richiesta integrazione												
												)
			)
	)

GO
