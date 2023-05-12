IF OBJECT_ID('tempdb.dbo.#puliscisimule') IS NOT NULL
	DROP TABLE #puliscisimule

--226901 rows
SELECT DISTINCT
L_ImportSimula.IdImportSimula
	--,FlagAggiornamentoCompletato
	,CodiceSimula
	--,DataSimula
	--,CodiceDisposizione 
INTO #puliscisimule
FROM L_ImportSimula
JOIN L_ImportSimulaOperazione
	ON L_ImportSimula.IdImportSimula = L_ImportSimulaOperazione.IdImportSimula

WHERE DataSimula >= '2018-01-01'
AND DataSimula < '2019-01-01'
AND FlagAssociato = 0
AND FlagAggiornamentoCompletato = 1


--226901 rows
UPDATE L_ImportSimula
SET FlagAggiornamentoCompletato = 0
--SELECT
--	#puliscisimule.IdImportSimula
--	,#puliscisimule.CodiceSimula
	
FROM L_ImportSimula
JOIN #puliscisimule
	ON L_ImportSimula.IdImportSimula = #puliscisimule.IdImportSimula

DROP TABLE #puliscisimule


/*
--1 row
UPDATE L_ImportSimula
SET FlagAggiornamentoCompletato = 0
WHERE IdImportSimula = 1

*/



