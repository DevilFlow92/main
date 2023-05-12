SELECT ti.IdIncarico
,d.TipoIncarico
,tdoc.Documento_id
--,tdoc.Tipo_Documento
,D_Documento.Descrizione TipoDocumento
--,tdoc.IdOperatoreInserimento
,S_Operatore.Etichetta OperatoreImbarcoDocumento
,IIF(CodProfiloAccesso IN (839,2062),1,0) ImbarcatoDaUploadMassivo
,tdoc.DataInserimento
,IIF(tdoc.DataInserimento >= '2020-01-22 10:00',1,0) IsPostRilascioUpload
--,tdoc.CodOrigineDocumento
--,tdoc.CodOrigineDocumentoImbarcaton

FROM T_Incarico ti
JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico
AND tdoc.FlagPresenzaInFileSystem = 1
AND tdoc.FlagScaduto = 0
AND tdoc.CodOrigineDocumento <> 2
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
JOIN D_Documento ON tdoc.Tipo_Documento = D_Documento.Codice
JOIN S_Operatore ON tdoc.IdOperatoreInserimento = S_Operatore.IdOperatore
AND S_Operatore.CodProfiloAccesso in (876,839,2062)


WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico in (112,522,524,549)

AND tdoc.DataInserimento >= '2019-09-01'

