USE CLC
GO

--SELECT * FROM D_TipoIncarico
--JOIN R_Cliente_TipoIncarico ON CodTipoIncarico = D_TipoIncarico.Codice
--AND CodCliente = 23
--WHERE Descrizione LIKE '%censimento%'

--396	--OnBoarding Digitale
--288	Censimento Cliente


SELECT DISTINCT ti.IdIncarico
,ti.DataCreazione
,ti.CodTipoIncarico
,d.TipoIncarico
,ti.CodStatoWorkflowIncarico
,d.StatoWorkflowIncarico
,ti.CodAttributoIncarico
,d.AttributoIncarico

,anagrafica.ChiaveClienteIntestatario
,CASE WHEN anagrafica.CognomeIntestatario is NULL OR anagrafica.CognomeIntestatario = ''
	THEN anagrafica.RagioneSocialeIntestatario
	ELSE anagrafica.CognomeIntestatario + ' ' + ISNULL(anagrafica.NomeIntestatario,'')
 END AS Intestatario

 ,anagrafica.CodicePromotore
 ,CASE WHEN anagrafica.CognomePromotore IS NULL or anagrafica.CognomePromotore = ''
	THEN anagrafica.RagioneSocialePromotore
	ELSE anagrafica.CognomePromotore + ' ' + ISNULL(anagrafica.NomePromotore,'')
 END AS Promotore

,lwi.DataTransizione DataCaricamento

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON ti.IdIncarico = anagrafica.IdIncarico
AND anagrafica.ProgressivoPersona = 1

JOIN (SELECT MAX(IdTransizione) IdTransizione
			,IdIncarico
			 FROM L_WorkflowIncarico
			WHERE CodAttributoIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione IN (--8520,	--Da Acquisire
														 8570,	--Acquisita
														 12180 --Caricata (Onboarding Digitale)
														)
			GROUP BY IdIncarico
			) wf ON ti.IdIncarico = wf.IdIncarico
JOIN L_WorkflowIncarico lwi ON wf.IdTransizione = lwi.IdTransizione
LEFT JOIN rs.v_CESAM_Acquisizione_CodaLavorazione_DispositiveSmartWorking smartworking ON ti.IdIncarico = smartworking.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND (
	 (smartworking.IdIncarico is not NULL AND ti.CodTipoIncarico = 288)
   OR (ti.CodTipoIncarico = 396)

   )
AND ti.DataCreazione >= '20200101'

