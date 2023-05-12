SELECT DISTINCT T_Incarico.IdIncarico
,DataCreazione
,DataUltimaTransizione
,descrizioni.TipoIncarico
,IIF(anagrafica.CodTipoPersona = 2 ,'OnBoarding Persone Giuridiche','OnBoarding Persone Fisiche') TipoCensimento
,descrizioni.StatoWorkflowIncarico


 FROM T_Incarico

JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON T_Incarico.IdIncarico = anagrafica.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni on T_Incarico.IdIncarico = descrizioni.IdIncarico
AND anagrafica.ProgressivoPersona = 1

WHERE CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico = 288

AND DataCreazione >= '2018-01-01'
