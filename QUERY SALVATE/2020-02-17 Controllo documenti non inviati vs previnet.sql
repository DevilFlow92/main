USE clc
GO


SELECT T_Incarico.IdIncarico
,T_Documento.Documento_id
,T_Documento.Tipo_Documento

FROM T_Incarico
JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
AND FlagPresenzaInFileSystem = 1
AND FlagScaduto = 0
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON T_Incarico.CodCliente = export.Z_Cliente_TipoIncarico_TipoDocumento.CodCliente
AND T_Incarico.CodTipoIncarico = export.Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico
AND CodTipoDocumento = Tipo_Documento

LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI previnet ON T_Documento.Documento_id = previnet.documento_id

WHERE CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico IN (173	--Disinvestimenti Previdenza
,572 --Sottoscrizioni Previdenza - Zenith
,175 --Successioni - Previdenza
,178 --Varie Previdenza
,57	--Gestione SEPA
,167 --Sottoscrizioni Previdenza
,102 --Switch Previdenza
)
AND previnet.documento_id IS NULL
AND T_Incarico.DataUltimaTransizione >= '2020-02-05'
AND T_Documento.DataInserimento < T_Incarico.DataUltimaTransizione

