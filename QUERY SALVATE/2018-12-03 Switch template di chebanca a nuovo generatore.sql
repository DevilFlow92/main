USE CLC
GO

IF OBJECT_ID('tempdb.dbo.#tmpUpdate') IS NOT NULL
	DROP TABLE #tmpUpdate



SELECT IdTemplate
INTO #tmpUpdate
 FROM S_TemplateDocumento where PercorsoFile like 'CESAM\chebanca%'

AND FlagGeneratoreLegacy = 1

SELECT * FROM S_TemplateDocumento
JOIN #tmpUpdate on S_TemplateDocumento.IdTemplate = #tmpUpdate.IdTemplate


/*
UPDATE S_TemplateDocumento

SET FlagGeneratoreLegacy = 0

FROM S_TemplateDocumento
JOIN #tmpUpdate on S_TemplateDocumento.IdTemplate = #tmpUpdate.IdTemplate
*/

DROP TABLE #tmpUpdate