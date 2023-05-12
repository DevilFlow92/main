USE clc
GO

SELECT * FROM S_TemplateDocumento
WHERE PercorsoFile like '%onbo%'

/*
5336
5337
5338
5339
5340
5341
5342
5343
*/

SELECT * FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento IN (5336
,5337
,5338
,5339
,5340
,5341
,5342
,5343
)

SELECT * FROM R_Cliente_TemplateDocumento
JOIN S_TemplateDocumento ON R_Cliente_TemplateDocumento.IdTemplateDocumento = S_TemplateDocumento.IdTemplate
WHERE IdTemplateDocumento IN (5226
,5227
,5264
,5266
,5300
,5301
,5302
,5303
,5304
,5309
)

USE CLC

SELECT * FROM R_Cliente_TemplateDocumento 
JOIN S_TemplateDocumento ON R_Cliente_TemplateDocumento.IdTemplateDocumento = S_TemplateDocumento.IdTemplate
WHERE CodCliente = 23 AND CodTipoIncarico = 288

--INSERT into R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)

SELECT IdTemplate, CodCliente, CodTipoIncarico, 5 FROM R_Cliente_TemplateDocumento
JOIN S_TemplateDocumento ON IdRelazione = 5921
AND IdTemplate IN (5336
,5337
,5338
,5339
,5340
,5341
,5342
,5343
)
