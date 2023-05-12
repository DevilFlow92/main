USE clc
GO

BEGIN TRAN

IF OBJECT_ID('tempdb.dbo.#tmpMovimenti') IS NOT NULL
begin	
	DROP TABLE #tmpMovimenti
END


SELECT 
T_MovimentoContoBancario.IdMovimentoContoBancario, T_MovimentoContoBancario.DataImport, T_MovimentoContoBancario.DataOperazione, T_MovimentoContoBancario.DataValuta
INTO #tmpMovimenti
FROM T_ContoBancario
JOIN T_ContoBancarioPerAnno ON T_ContoBancario.IdContoBancario = T_ContoBancarioPerAnno.IdContoBancario
AND anno = 2021
AND Abi = '03479'
--AND numeroconto = '70040'
JOIN T_Incarico ON T_ContoBancarioPerAnno.IdIncarico = T_Incarico.IdIncarico
AND CodArea = 8
AND CodCliente = 23

JOIN T_MovimentoContoBancario ON T_ContoBancarioPerAnno.IdContoBancarioPerAnno = T_MovimentoContoBancario.IdContoBancarioPerAnno
--JOIN T_R_Incarico_MovimentoContoBancario ON T_MovimentoContoBancario.IdMovimentoContoBancario = T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario
--JOIN T_PagamentoInvestimento ON T_MovimentoContoBancario.IdMovimentoContoBancario = T_PagamentoInvestimento.IdMovimentoContoBancario
--AND T_PagamentoInvestimento.FlagAttivo = 1
CROSS APPLY (
				SELECT TOP 1 s.IdMovimentoContoBancario, s.DataModifica
				FROM storico.V_Log_T_MovimentoContoBancario s
				WHERE s.DataModifica >= '20210603 08:40'
				AND s.Utente = 'GRUPPOMOL\Lorenzo.Fiori'
				AND s.DataOperazione = '20210603'
				AND s.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
				ORDER BY s.DataModifica ASC
) modifica
WHERE DataOperazione = '20210603'

UPDATE T_MovimentoContoBancario
SET DataOperazione = '20210602'
,DataValuta = '20210603'
FROM T_MovimentoContoBancario
JOIN #tmpMovimenti ON T_MovimentoContoBancario.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

DROP TABLE #tmpMovimenti

--COMMIT TRAN
ROLLBACK TRAN
