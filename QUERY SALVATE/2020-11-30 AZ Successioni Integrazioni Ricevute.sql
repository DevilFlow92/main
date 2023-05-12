USE clc
GO

--SELECT * FROM D_AttributoIncarico dai
--JOIN R_Cliente_Attributo rca ON dai.Codice = rca.CodAttributo
--AND rca.CodCliente = 23 AND rca.CodTipoIncarico = 54
--WHERE dai.Descrizione LIKE '%inte%'

SELECT ti.IdIncarico
,ti.ChiaveCliente
,ti.DataCreazione
,ti.CodStatoWorkflowIncarico
,d.StatoWorkflowIncarico
,ti.CodAttributoIncarico
,d.AttributoIncarico
,RicevuteIntegrazioni.DataTransizione DataAttributo
,IIF(ti.FlagUrgente = 1,'Sì','No') Urgenza
,IIF(ti.FlagUrgente = 1, Urgenza.DataTransizione,NULL) DataUrgenza

FROM T_Incarico ti 
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
JOIN (
			SELECT MAX(lwi1.DataTransizione) DataTransizione, ti1.IdIncarico
			FROM L_WorkflowIncarico lwi1
			JOIN T_Incarico ti1 ON lwi1.IdIncarico = ti1.IdIncarico
			AND ti1.CodArea = 8
			AND ti1.CodCliente = 23 AND ti1.CodTipoIncarico = 54
			WHERE (lwi1.CodAttributoIncaricoPartenza IS NULL OR lwi1.CodAttributoIncaricoPartenza != lwi1.CodAttributoIncaricoDestinazione)
			AND lwi1.CodAttributoIncaricoDestinazione = 239	--INTEGRAZIONI RICEVUTE
			GROUP BY ti1.IdIncarico
          ) RicevuteIntegrazioni ON ti.IdIncarico = RicevuteIntegrazioni.IdIncarico

LEFT JOIN (
			SELECT MAX(lwi2.DataTransizione) DataTransizione, ti2.IdIncarico
			FROM L_WorkflowIncarico lwi2
			JOIN T_Incarico ti2 ON lwi2.idincarico = ti2.IdIncarico
			AND ti2.CodArea = 8 AND ti2.CodCliente = 23 AND ti2.CodTipoIncarico = 54
			WHERE (lwi2.FlagUrgentePartenza IS NULL OR lwi2.FlagUrgentePartenza = 0)
			AND lwi2.FlagUrgenteDestinazione = 1
			GROUP BY ti2.IdIncarico
		) Urgenza ON ti.IdIncarico = Urgenza.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 54
AND ti.CodAttributoIncarico = 239  --INTEGRAZIONI RICEVUTE

