USE CLC_Cesam

GO

DECLARE @IdIncarico INT = 22599949


IF OBJECT_ID('tempdb.dbo.#TControllo') IS NOT NULL
	DROP TABLE #TControllo

SELECT
	dbo.T_Controllo.IdControllo
 
INTO #TControllo
FROM dbo.T_Controllo
JOIN dbo.T_R_Incarico_Controllo ON dbo.T_Controllo.IdControllo = dbo.T_R_Incarico_Controllo.IdControllo
JOIN dbo.S_Controllo
	ON dbo.T_Controllo.IdTipoControllo = dbo.S_Controllo.IdControllo
WHERE T_R_Incarico_Controllo.idincarico = @IdIncarico

IF EXISTS (SELECT * FROM T_R_Incarico_Controllo where IdIncarico = @idincarico)
BEGIN
DELETE FROM T_R_Incarico_Controllo where IdIncarico = @idincarico


DELETE FROM dbo.T_Controllo
FROM dbo.T_Controllo
JOIN #TControllo
	ON dbo.T_Controllo.IdControllo = #TControllo.IdControllo

DELETE FROM T_MacroControllo WHERE IdIncarico = @IdIncarico

PRINT 'Ho rimosso i controlli pregressi'

END

