USE CLC_Cesam
GO

BEGIN TRAN

IF OBJECT_ID('tempdb.dbo.#TmpDividendi') IS NOT NULL
	DROP TABLE #TmpDividendi


SELECT IdMovimentoContoBancario
INTO #tmpDividendi
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND anno = YEAR(getdate())
JOIN T_Incarico ti ON T_ContoBancarioPerAnno.IdIncarico = ti.IdIncarico
AND ti.CodCliente = 23 AND ti.CodArea = 8
WHERE DataImport >= '20221101' --CONVERT(DATE,GETDATE())
AND NotaAggiuntiva LIKE '%{AUTO_REIN%DIVIDENDI}%'
AND FlagAttivo = 1

UPDATE T_MovimentoContoBancario
SET FlagAttivo = 0
FROM T_MovimentoContoBancario
JOIN #tmpDividendi ON T_MovimentoContoBancario.IdMovimentoContoBancario = #tmpDividendi.IdMovimentoContoBancario

DROP TABLE #tmpDividendi

COMMIT TRAN


GO


