USE CLC_Cesam
GO

BEGIN tran
	

DECLARE @data DATE = '2023-04-25'

IF OBJECT_ID('tempdb.dbo.#target_update_afb') IS NOT NULL
begin
	DROP TABLE #target_update_afb
END

IF OBJECT_ID('tempdb.dbo.#target_update_azf') IS NOT NULL
begin
	DROP TABLE #target_update_azf
END


SELECT T_ContoBancarioPerAnno.IdIncarico, IdMovimentoContoBancario, DataValuta, DataOperazione
INTO #target_update_afb
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND Anno = year(getdate())
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND Abi IN ('05034'
,'01005')
AND Cab IN ('11701'
,'01600')
AND NumeroConto in (
'000000070040' --AZIMUT CAPITAL MANAGEMENT SGR P.A. - Conto afflussi Case Terze AFB
,'000000070041' --AZIMUT CAPITAL MANAGEMENT SGR P.A. - Conto rimborsi? Case Terze AFB
,'000000070042' --AZIMUT CAPITAL MANAGEMENT SGR P.A. - Conto Ritenute Case Terze AFB
,'000000070043' --AZIMUT CAPITAL MANAGEMENT SGR P.A. - Conto Dividendi Case Terze AFB
,'000000002103' --fiscalità case terze
)
AND ( DataValuta = @data
OR DataOperazione = @data
)


SELECT T_ContoBancarioPerAnno.IdIncarico, IdMovimentoContoBancario, DataValuta, DataOperazione 
INTO #target_update_azf
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND Anno = year(getdate())
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND Abi = '03479'
AND cab = '01600'
AND NumeroConto = '802260103'
AND ( DataValuta = @data
OR DataOperazione = @data
)

UPDATE dbo.T_MovimentoContoBancario
SET DataValuta = rs.DateAdd_GiorniLavorativi(23,@Data,1)
FROM dbo.T_MovimentoContoBancario
JOIN #target_update_afb ON T_MovimentoContoBancario.IdMovimentoContoBancario = #target_update_afb.IdMovimentoContoBancario
WHERE dbo.T_MovimentoContoBancario.DataValuta = @Data

UPDATE dbo.T_MovimentoContoBancario
SET DataOperazione = rs.DateAdd_GiorniLavorativi(23,@Data,1)
FROM dbo.T_MovimentoContoBancario
JOIN #target_update_afb ON T_MovimentoContoBancario.IdMovimentoContoBancario = #target_update_afb.IdMovimentoContoBancario
WHERE dbo.T_MovimentoContoBancario.DataOperazione = @Data

UPDATE dbo.T_MovimentoContoBancario
SET DataOperazione = rs.DateAdd_GiorniLavorativi(23,@Data,1)
FROM dbo.T_MovimentoContoBancario
JOIN #target_update_azf ON T_MovimentoContoBancario.IdMovimentoContoBancario = #target_update_azf.IdMovimentoContoBancario
WHERE dbo.T_MovimentoContoBancario.DataOperazione = @Data

UPDATE dbo.T_MovimentoContoBancario
SET DataValuta = rs.DateAdd_GiorniLavorativi(23,@Data,1)
FROM dbo.T_MovimentoContoBancario
JOIN #target_update_azf ON T_MovimentoContoBancario.IdMovimentoContoBancario = #target_update_azf.IdMovimentoContoBancario
WHERE dbo.T_MovimentoContoBancario.DataValuta = @Data

DROP TABLE #target_update_azf, #target_update_afb

COMMIT TRAN