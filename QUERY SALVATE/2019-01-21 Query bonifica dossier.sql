

USE CLC
--SELECT
--	*
--FROM T_Dossier
--WHERE NumeroDossier = 'D000805798'

SELECT * FROM T_Dossier WHERE IdDossier IN (245562,
277966
)

SELECT * FROM V_ImportSimulaOperazione_DatiProduzione
WHERE IdImportSimulaOperazione = 1807710


DECLARE @IdDossierSurvive INT = 277966


IF OBJECT_ID('tempdb.dbo.#dossier') IS NOT NULL
	DROP TABLE #dossier


CREATE TABLE #dossier
(
IdDossierDelete INT PRIMARY KEY
)

INSERT INTO #dossier (IdDossierDelete)
SELECT IdDossier FROM T_Dossier
WHERE IdDossier IN ( 245562
)

DELETE tr
from T_R_Dossier_Indirizzo tr
JOIN #dossier ON tr.IdDossier = IdDossierDelete

--4 row(s)
DELETE tr
--SELECT * 
FROM T_R_Dossier_Persona tr
JOIN #dossier ON IdDossierDelete = IdDossier

--2 row(s)
UPDATE T_Mandato
SET IdDossier = @IdDossierSurvive
--SELECT * 
FROM T_Mandato
JOIN #dossier ON IdDossier = IdDossierDelete

--3 rows
DELETE t
--SELECT * 
FROM T_Dossier t
JOIN #dossier ON t.IdDossier = IdDossierDelete 

DROP TABLE #dossier