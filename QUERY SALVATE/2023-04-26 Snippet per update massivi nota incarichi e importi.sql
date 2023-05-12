

;
WITH target_update AS (
/* inserire testo snippet fatto in excel  */

) 

UPDATE dbo.T_NotaIncarichi
SET Testo = TestoNew
FROM dbo.T_NotaIncarichi
JOIN target_update ON T_NotaIncarichi.IdNotaIncarichi = target_update.IdNotaIncarichi

;
WITH target_update AS (
/* inserire testo snippet fatto in excel  */


) UPDATE dbo.T_MovimentoContoBancario
SET Importo = ImportoNew
FROM dbo.T_MovimentoContoBancario
JOIN target_update ON dbo.T_MovimentoContoBancario.IdMovimentoContoBancario = target_update.IdMovimentoContoBancario