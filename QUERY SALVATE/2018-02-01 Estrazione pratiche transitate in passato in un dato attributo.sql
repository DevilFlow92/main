USE CLC

SELECT 
				 T_Incarico.IdIncarico
				,max(isnull(WF.DataTransizione,T_Incarico.DataCreazione)) as DataTransizione
				,CASE WHEN WF.CodAttributoIncaricoDestinazione = 1459 THEN 1 ELSE 0 END as TransitataNellAttributo
				,descrizioni.StatoWorkflowIncarico as StatoWorkflowIncaricoAttuale

FROM T_Incarico

left JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON T_Incarico.IdIncarico = descrizioni.IdIncarico

left JOIN (SELECT *
FROM L_WorkflowIncarico
WHERE CodAttributoIncaricoDestinazione = 1459 --documenti riscansionati da Milano
												) WF ON WF.idincarico = T_incarico.IdIncarico

where T_Incarico.CodArea = 8 AND
T_Incarico.CodTipoIncarico = 331
and T_Incarico.DataCreazione > '2017-11-06'

GROUP BY 
T_Incarico.IdIncarico
,CASE WHEN WF.CodAttributoIncaricoDestinazione = 1459 THEN 1 ELSE 0 END
,descrizioni.StatoWorkflowIncarico
