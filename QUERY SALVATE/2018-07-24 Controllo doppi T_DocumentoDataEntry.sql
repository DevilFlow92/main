USE CLC
GO 

;WITH cte as (
SELECT 	
		T_Incarico.CodCliente
		,T_Incarico.CodTipoIncarico
		,T_Incarico.IdIncarico
		,T_DocumentoDataEntry.IdDocumento
		,T_DocumentoDataEntry.CodOrigineDataEntry
		,T_DocumentoDataEntry.IdPersona
		,T_DocumentoDataEntry.NomeFile
		--,COUNT(IdDocumento)

 FROM T_DocumentoDataEntry
JOIN T_Documento ON Documento_id = IdDocumento
JOIN T_Incarico ON T_Documento.IdIncarico = T_Incarico.IdIncarico

WHERE CodArea = 8
AND CodCliente IN (23,48)
AND DataCreazione >= '20200301'

--AND T_Incarico.IdIncarico = 22555283    

GROUP BY T_Incarico.CodCliente
		,T_Incarico.CodTipoIncarico
		,T_Incarico.IdIncarico
		,T_DocumentoDataEntry.IdDocumento
		,T_DocumentoDataEntry.CodOrigineDataEntry
		,T_DocumentoDataEntry.IdPersona
		,T_DocumentoDataEntry.NomeFile

HAVING COUNT(IdDocumento) > 1

) 

SELECT MIN(T_DocumentoDataEntry.IdDocumentoDataEntry) IdDocumentoDataEntryDELETE, 	
IdIncarico
,IIF(cte.CodTipoIncarico IN (334,335,611,682),1,0) IsFEA
,T_DocumentoDataEntry.IdDocumento
,T_DocumentoDataEntry.CodOrigineDataEntry
,T_DocumentoDataEntry.IdPersona
,T_DocumentoDataEntry.NomeFile 
FROM T_DocumentoDataEntry
JOIN cte ON T_DocumentoDataEntry.IdDocumento = cte.IdDocumento
LEFT JOIN L_DocumentoDataEntry ON T_DocumentoDataEntry.IdDocumentoDataEntry = L_DocumentoDataEntry.IdDocumentoDataEntry

WHERE L_DocumentoDataEntry.IdLog is NULL
--AND IdIncarico = 14259813
GROUP BY
cte.IdIncarico
,IIF(cte.CodTipoIncarico IN (334,335,611,682),1,0)
,T_DocumentoDataEntry.IdDocumento
,T_DocumentoDataEntry.CodOrigineDataEntry
,T_DocumentoDataEntry.IdPersona
,T_DocumentoDataEntry.NomeFile 



--EXEC orga.CESAM_EliminaDoppioniFormDataEntry @IdIncarico = 22555283 