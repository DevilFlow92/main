use CLC
GO

IF OBJECT_ID('tempdb.dbo.#clean') IS NOT NULL
	DROP TABLE #clean


;WITH cte AS (
SELECT count(IdSubIncarico) n_sub, tr.IdIncarico, tr.IdSubIncarico
 FROM T_R_Incarico_SubIncarico tr
 JOIN T_Incarico ti ON tr.IdIncarico = ti.IdIncarico
 WHERE  ti.CodArea = 8 
	AND ti.CodCliente IN(23, 48,73)
	and ti.datacreazione >= '2019-03-04'
 GROUP BY tr.IdIncarico, tr.IdSubIncarico
 HAVING count(tr.IdSubIncarico) > 1 )

 SELECT 	MIN(tr.IdRelazione) IdRelazioneDELETE
			,tr.IdIncarico
			,tr.IdSubIncarico
			,tr.FlagArchiviato

INTO #clean
 FROM T_R_Incarico_SubIncarico tr
 JOIN cte on cte.IdIncarico = tr.IdIncarico AND cte.IdSubincarico = tr.IdSubincarico

 GROUP BY

 tr.IdIncarico
			,tr.IdSubIncarico
			,tr.FlagArchiviato

SELECT * FROM #clean

/*
DELETE tr
FROM T_R_Incarico_SubIncarico tr
INNER JOIN #clean on IdRelazioneDELETE = tr.IdRelazione
*/

--DELETE FROM T_R_Incarico_SubIncarico WHERE IdRelazione = 5152314