IF OBJECT_ID('tempdb.dbo.#aggiorna') IS NOT NULL
	DROP TABLE #aggiorna

SELECT
	ti.IdIncarico
	,ti.CodStatoWorkflowIncarico
	,ti.CodAttributoIncarico
	,ti.DataUltimaTransizione
	,IIF(ti.CodStatoWorkflowIncarico = 6596, 15550, ti.CodStatoWorkflowIncarico) CodStatoWorkflowNEW
	,522 CodTipoIncaricoNEW
	,33 CodTipoWorkflowNEW
	,wf.IdTransizione
INTO #aggiorna
FROM T_Incarico ti
JOIN (SELECT MAX(IdTransizione) IdTransizione, IdIncarico
		FROM L_WorkflowIncarico 
		GROUP BY IdIncarico
		) wf ON ti.IdIncarico = wf.IdIncarico
WHERE ti.CodCliente = 23
AND ti.CodArea = 8
AND ti.CodTipoIncarico = 66

AND ti.IdIncarico = 1811008


SELECT * FROM #aggiorna
--UPDATE T_Incarico
--SET CodTipoIncarico = CodTipoIncaricoNEW
--,CodTipoWorkflow = CodTipoWorkflowNEW
--,CodStatoWorkflowIncarico = CodStatoWorkflowNEW
--FROM T_Incarico
--JOIN #aggiorna ON T_Incarico.IdIncarico = #aggiorna.IdIncarico


SELECT *
--UPDATE L_WorkflowIncarico
--SET CodStatoWorkflowIncaricoDestinazione = CodStatoWorkflowNEW
FROM L_WorkflowIncarico
JOIN #aggiorna ON L_WorkflowIncarico.IdTransizione = #aggiorna.IdTransizione
AND L_WorkflowIncarico.IdIncarico = #aggiorna.IdIncarico

DROP TABLE #aggiorna