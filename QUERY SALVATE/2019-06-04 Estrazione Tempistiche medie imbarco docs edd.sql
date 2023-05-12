USE CLC
GO

WITH cte AS (
SELECT ti.IdIncarico
		,Min(tdoc.DataInserimento) DataPrimoUpload 
		,MAX(tdoc.DataInserimento) DataUltimoUpload

FROM T_Incarico ti
JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico
JOIN D_Documento ddoc ON ddoc.Codice = tdoc.Tipo_Documento
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 66
AND ti.DataCreazione >= DATEADD(MONTH,-3,CONVERT(DATE,GETDATE()))
AND ddoc.CodOggettoControlli = 1
AND tdoc.IdOperatoreInserimento <> 5001 --Mazzocchi M.
AND tdoc.CodOrigineDocumento = 1


GROUP BY ti.IdIncarico
) 

SELECT ti.IdIncarico
			,ti.DataCreazione
			,ti.FlagArchiviato
			,descrizioni.StatoWorkflowIncarico
			,DataPrimoUpload
			,DataUltimoUpload
			,IIF(DATEDIFF(HOUR,DataPrimoUpload,DataUltimoUpload) > 8,1,0) Outlier
FROM cte
JOIN T_Incarico ti ON cte.IdIncarico = ti.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico

 