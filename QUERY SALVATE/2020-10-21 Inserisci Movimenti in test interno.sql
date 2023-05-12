USE CLC
GO

/*
author: Andrea Padricelli
*/


--WHERE IdContoBancarioPerAnno = 26401

DECLARE @InputIdContoBancarioPerAnno INT  = (SELECT IdContoBancarioPerAnno FROM T_ContoBancarioPerAnno WHERE IdIncarico = 8920793)

--SELECT COUNT(*) FROM T_MovimentoContoBancario
--WHERE IdContoBancarioPerAnno = @InputIdContoBancarioPerAnno

--fino a 5000 movimenti ok
--16619 --> inizia a rallentare (13 secondi)
--26619	--> 31 secondi, 29 secondi, 25 secondi
--36619	--> +50 secondi
--ti ho cancellato 10000 movimenti, visti i tempi
--46619	--> 

IF OBJECT_ID('tempdb.dbo.#tmpMovimenti') IS NOT NULL
begin
	DROP TABLE #tmpMovimenti
END

SELECT TOP 10000   --tmc.IdMovimentoContoBancario,
@InputIdContoBancarioPerAnno IdContoBancarioPerAnno, tmc.DataValuta, tmc.DataOperazione, tmc.IdOperazioneContoBancario, tmc.Importo, tni.Testo
INTO #tmpMovimenti
FROM [DB-CLC-PRODBT].clc.dbo.T_MovimentoContoBancario tmc
JOIN  [DB-CLC-PRODBT].clc.dbo.T_ContoBancarioPerAnno tcbpa ON tmc.IdContoBancarioPerAnno = tcbpa.IdContoBancarioPerAnno
JOIN  [DB-CLC-PRODBT].clc.dbo.T_NotaIncarichi tni ON tmc.IdNotaIncarichi = tni.IdNotaIncarichi
OUTER APPLY (
				SELECT TOP 1 tmcTEST.IdMovimentoContoBancario FROM T_MovimentoContoBancario tmcTEST
				JOIN T_NotaIncarichi tniTEST ON tmcTEST.IdNotaIncarichi = tniTEST.IdNotaIncarichi
				WHERE tmcTEST.IdContoBancarioPerAnno = @InputIdContoBancarioPerAnno
				AND tniTEST.Testo = tni.testo
				AND tmcTEST.Importo = tmc.importo

) MovimentiTestImportati
WHERE tcbpa.IdIncarico = 13943236
AND tmc.DataImport >= '20200315'
AND tmc.NotaAggiuntiva NOT LIKE '%auto%'
AND tNI.Testo NOT LIKE '%ALLFUNDS BANK%'
AND TNI.Testo NOT LIKE '%ASSEGN%'
AND tni.Testo NOT LIKE '%STORN%'
AND tmc.IdMovimentoContoBancarioMaster IS NULL

DECLARE
@DescrizioneMovimento VARCHAR(max)
, @IdContoBancarioPerAnno INT
, @DataValuta DATETIME
, @DataOperazione DATETIME
, @IdOperazioneContoBancario INT
, @Importo DECIMAL(18,4)
, @IdImport_Rendicontazione INT


DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR

SELECT * FROM #tmpMovimenti

--AND tmc.IdMovimentoContoBancario = 1141977

OPEN cur

FETCH NEXT FROM cur INTO @IdContoBancarioPerAnno, @DataValuta, @DataOperazione, @IdOperazioneContoBancario, @Importo, @DescrizioneMovimento

WHILE @@FETCH_STATUS = 0 BEGIN

	BEGIN tran
BEGIN try
	BEGIN
	DECLARE @idnotaincarichi INT
	,@IdMovimentoContoBancario INT

	INSERT into T_NotaIncarichi (CodTipoNotaIncarichi, DataInserimento, IdOperatore, Testo)
		VALUES (92, GETDATE(), 21, @DescrizioneMovimento);

	SET @idnotaincarichi = SCOPE_IDENTITY()

	INSERT INTO T_MovimentoContoBancario (IdContoBancarioPerAnno,   CodTipoMovimentoContoBancario, DataValuta, DataOperazione, 
	 IdOperazioneContoBancario, Importo,         FlagIncompleto, FlagPresenzaContabile, FlagImportIncompleto,  IdNotaIncarichi
	, FlagImportato, DataImport, NotaAggiuntiva, FlagRiconciliato, FlagConfermato, FlagAttivo)
		VALUES (@idcontobancarioperanno,   5, @datavaluta, @dataoperazione,  @idoperazionecontobancario, @importo,  0, 0, 0, @idnotaincarichi, 1, GETDATE(), N'', 0, 0, 1);

	SET @IdMovimentoContoBancario = SCOPE_IDENTITY()


	END	
COMMIT
--SELECT 12345 AS IdMovimentoContoBancario
--SELECT @IdMovimentoContoBancario as IdMovimentoContoBancario

END try

BEGIN CATCH
	SELECT ERROR_MESSAGE()
END CATCH


FETCH NEXT FROM cur INTO @IdContoBancarioPerAnno, @DataValuta, @DataOperazione, @IdOperazioneContoBancario, @Importo, @DescrizioneMovimento

END

CLOSE cur
DEALLOCATE cur

DROP TABLE #tmpMovimenti

GO