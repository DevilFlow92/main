USE CLC
GO

--SELECT * FROM D_TipoIncarico
--WHERE Descrizione like '%sepa%'


SELECT DISTINCT
ti.IdIncarico
,CAST(YEAR(ti.DataCreazione) AS VARCHAR(4)) + ' - ' + format(MONTH(ti.DataCreazione),'0#') PeriodoCreazione
--,ti.CodTipoIncarico
,descrizioni.TipoIncarico
--,ti.CodStatoWorkflowIncarico
,descrizioni.StatoWorkflowIncarico
,CONVERT(varchar,ti.DataCreazione,105) DataCreazioneMaster

,sub.IdIncarico IdSubincaricoGestioneSEPA
,CONVERT(varchar,sub.DataCreazione,105) DataCreazioneSubincarico
,tdoc.Documento_id
--,tdoc.Documento_id
--,tdoc.Tipo_Documento
--,D_Documento.Descrizione
FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico
JOIN T_R_Incarico_SubIncarico tris ON ti.IdIncarico = tris.IdIncarico
JOIN T_Incarico sub ON tris.IdSubIncarico = sub.IdIncarico
AND ti.CodCliente = sub.CodCliente
AND ti.CodArea = sub.CodArea
AND sub.CodTipoIncarico = 57
LEFT JOIN T_Documento tdoc ON sub.IdIncarico = tdoc.IdIncarico
AND tdoc.FlagPresenzaInFileSystem = 1
AND tdoc.FlagScaduto = 0
AND tdoc.Tipo_Documento = 7049 --Gestione SEPA - Azimut Previdenza

LEFT JOIN D_Documento ON tdoc.Tipo_Documento = D_Documento.Codice
WHERE ti.CodCliente = 23
AND ti.CodArea = 8
AND ti.CodTipoIncarico IN (
572
,167
--,573
--,574
--,575
)

--AND ti.CodStatoWorkflowIncarico <> 820
--AND tdoc.Documento_id IS NULL
--AND sub.IdIncarico = 14666128
--AND ti.DataCreazione >= '20200301'

