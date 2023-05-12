USE clc

GO


ALTER PROCEDURE orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA
AS

EXEC orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA


BEGIN TRAN
IF OBJECT_ID('tempdb.dbo.#tmpMovimenti') IS NOT NULL
	DROP TABLE #tmpMovimenti


SELECT IdMovimentoContoBancario, IdContoBancarioPerAnno, 206612 IdContoBancarioNew
INTO #tmpMovimenti
FROM T_MovimentoContoBancario
WHERE (( DataImport < '20201101'
AND IdContoBancarioPerAnno = 203267)
OR (FlagConfermato = 1 AND FlagRiconciliato = 1 AND CodiceTipoRiconciliazione IS NULL AND IdContoBancarioPerAnno = 203267) --Vado ad inserire anche gli auto a prescindere
) --AND IdMovimentoContoBancario = 1227162

SELECT FlagConfermato, FlagRiconciliato, CodiceTipoRiconciliazione, IdMovimentoContoBancario FROM T_MovimentoContoBancario
WHERE IdMovimentoContoBancario = 1227162

UPDATE  T_MovimentoContoBancario
SET IdContoBancarioPerAnno = IdContoBancarioNew

--SELECT DISTINCT  IdContoBancarioPerAnno
FROM T_MovimentoContoBancario
JOIN #tmpMovimenti ON T_MovimentoContoBancario.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

UPDATE scratch.T_R_ImportRendicontazione_Movimento
SET IdContoBancarioPerAnno = IdContoBancarioNew
FROM scratch.T_R_ImportRendicontazione_Movimento
JOIN #tmpMovimenti ON T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario
AND T_R_ImportRendicontazione_Movimento.IdContoBancarioPerAnno = #tmpMovimenti.IdContoBancarioPerAnno


COMMIT TRAN


/*
WITH sistema AS (
SELECT 1200078 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200079 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200081 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200082 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200083 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200084 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200085 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200087 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200093 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200094 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200095 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200099 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200105 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200106 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200107 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200112 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200116 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200117 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200118 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200122 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200123 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200125 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200126 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200127 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200128 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200135 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200140 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200143 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200146 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200147 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200149 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200156 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1200186 IdMovimento, 7 CodRic, '{Ord!=Ben}' Nota UNION ALL
SELECT 1210056 IdMovimento, 6 CodRic, '{!= Mandato}' Nota

)
UPDATE T_MovimentoContoBancario
SET NotaAggiuntiva = Nota
,CodiceTipoRiconciliazione = sistema.CodRic
,FlagRiconciliato = 0
FROM T_MovimentoContoBancario
JOIN sistema ON IdMovimento = IdMovimentoContoBancario
*/

--UPDATE T_MovimentoContoBancario
--SET FlagRiconciliato = 0
--FROM T_MovimentoContoBancario
--JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
--AND IdIncarico = 13943236
--WHERE CodiceTipoRiconciliazione IN (6,7)
--AND FlagRiconciliato = 1
--AND FlagConfermato = 0

GO
