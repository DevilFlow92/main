USE clc
GO

--ALTER PROCEDURE orga.CESAM_SetupArchivio
--(@CodCliente INT
--, @CodTipoIncarico int
--, @FlagSimulazione bit
--, @NumeroPiani smallint
--)

--AS

--EXEC orga.CESAM_SetupArchivio	@CodCliente = 23,
--								@CodTipoIncarico = 351,
--								@FlagSimulazione = 1,
--								@NumeroPiani = 1

--==========================================================================================================================
/* Decommentare per testare la SP */

DECLARE	@CodCliente INT,
		@CodTipoIncarico INT,	
		@FlagSimulazione BIT	--se 1, mostra una tabella che riporta il setup; se 0 fa la insert nella R_Cliente_Archivio

		,@NumeroPiani SMALLINT  --numero di piani che si vogliono inserire. 
								--NB: non è ammessa la possibiltà di inserire piani a salti ma solo consecutivi!!
								--In tal caso è sufficiente dare più comandi per poter inserire
								--un piano per volta nel primo "buco" disponibile.

SET @CodCliente = 23
SET @CodTipoIncarico = 351 --343 --200 --320 --54
SET @FlagSimulazione = 1 
SET @NumeroPiani = 2

--==========================================================================================================================


DECLARE @Archivio AS TABLE
 (IdRelazione INT
  ,CodCliente INT 
  ,CodTipoArchiviazione INT 
  ,CodScaffaleInizio INT
  ,CodScaffaleFine INT
  ,CodSezioneInizio INT
  ,CodSezioneFine INT
  ,CodPianoInizio INT
  ,CodPianoFine INT 
  ,PianiMax INT 
  )

DECLARE	@codpianocheck INT,
		@esito BIT

if object_id(N'tempdb.#setup',N'U') is not null
BEGIN
drop TABLE #setup
END

CREATE TABLE #setup (
	CodCliente INT,
	CodTipoIncarico INT,
	CodTipoArchiviazione SMALLINT,
	CodScaffaleInizio INT,
	CodiceSezioneInizio INT,
	CodicePianoInizio INT,
	CodiceScatolaInizio INT,
	CodScaffaleFine INT,
	CodiceSezioneFine INT,
	CodicePianoFine INT,
	CodiceScatolaFine INT,
	NumeroDocumenti INT,
	FlagTemporaneo SMALLINT,
	CodDocumento INT
)

BEGIN
PRINT '----------------INIZIO---------------'
PRINT CHAR(13) + '--Salvataggio informazioni archivio--'

INSERT into @Archivio (IdRelazione, Codcliente, codtipoarchiviazione, CodScaffaleInizio, CodScaffaleFine, CodSezioneInizio, CodSezioneFine, CodPianoInizio, CodPianoFine, PianiMax)
SELECT
	r.IdRelazione,
	@CodCliente,
	r.CodTipoArchiviazione,
	r.CodScaffaleInizio,
	r.CodScaffaleFine,
	r.CodiceSezioneInizio,
	r.CodiceSezioneFine,
	r.CodicePianoInizio,
	r.CodicePianoFine,
	S_Archivio.NumeroPiani
FROM R_Cliente_Archivio r
JOIN (SELECT
	MAX(IdRelazione) IdRelazione,
	CodCliente,
	CodTipoIncarico
FROM R_Cliente_Archivio
WHERE CodCliente = @CodCliente
AND CodTipoIncarico = @CodTipoIncarico
GROUP BY	CodCliente,
			CodTipoIncarico) inputriga	ON inputriga.IdRelazione = r.IdRelazione
JOIN S_Archivio on CodScaffale = r.CodScaffaleInizio

IF EXISTS (SELECT * FROM @Archivio)
BEGIN
PRINT CHAR(13) +  'Parametri Salvati'

--== select di prova di com'è fatto lo scaffale =====

--SELECT
--	*
--FROM R_Cliente_Archivio
--JOIN @Archivio
--	ON R_Cliente_Archivio.CodScaffaleInizio = [@Archivio].CodScaffaleInizio --and CodSezioneInizio = CodiceSezioneInizio
--ORDER BY R_Cliente_Archivio.CodScaffaleInizio, R_Cliente_Archivio.CodScaffaleFine, CodiceSezioneInizio, CodiceSezioneFine, CodicePianoInizio, CodicePianoFine

--===================================================

PRINT CHAR(13) + '--Controllo Posizione Archivio Libera--'

SET @codpianocheck = 1
SET @esito = 1

WHILE  EXISTS (
SELECT * FROM R_Cliente_Archivio r
JOIN @Archivio on  r.CodScaffaleInizio = [@Archivio].CodScaffaleInizio
					AND r.CodScaffaleFine = [@Archivio].CodScaffaleFine
					AND r.CodiceSezioneInizio = CodSezioneInizio
					AND r.CodiceSezioneFine = CodSezioneFine
WHERE (		   
			   (r.CodicePianoInizio >= @codpianocheck AND r.CodicePianoInizio <= (@codpianocheck + @NumeroPiani - 1)) 
			OR (r.CodicePianoFine >= @codpianocheck AND r.CodicePianoFine <= (@codpianocheck + @NumeroPiani - 1))	
			OR (r.CodicePianoInizio <= @codpianocheck and r.CodicePianoFine >= (@codpianocheck + @NumeroPiani - 1))
			OR (r.CodicePianoInizio =  @codpianocheck AND r.CodicePianoFine = @codpianocheck )
			OR (r.CodicePianoInizio =  @codpianocheck AND r.CodicePianoFine <= (@codpianocheck + @NumeroPiani - 1))
			
			)
			 )
				 

BEGIN


--PRINT @codpianocheck

IF (@codpianocheck + @NumeroPiani) > (SELECT PianiMax FROM @Archivio)  --Controllo se si è raggiunto il numero max di piani consentito
	BEGIN
	--interrompo il ciclo
	SET @esito = 0 --esito KO
	BREAK
	END
ELSE
BEGIN
--continuo
	SET @codpianocheck = @codpianocheck + 1
	CONTINUE
END


END

IF @esito = 1
BEGIN
PRINT '  Esito: OK, Salvataggio Setup della R_Cliente_Archivio'

INSERT into #setup (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
SELECT
	r.CodCliente,
	r.CodTipoIncarico,
	r.CodTipoArchiviazione,
	r.CodScaffaleInizio,
	r.CodiceSezioneInizio,
	@codpianocheck [CodicePianoInizio],
	r.CodiceScatolaInizio,
	r.CodScaffaleFine,
	r.CodiceSezioneFine,
	@codpianocheck + (@NumeroPiani - 1) [CodicePianoFine], 
	r.CodiceScatolaFine,
	r.NumeroDocumenti,
	r.FlagTemporaneo,
	r.CodDocumento
FROM R_Cliente_Archivio r
JOIN @Archivio
	ON r.IdRelazione = [@Archivio].IdRelazione


END
ELSE
BEGIN
	PRINT '  Esito: Nessun Piano Libero nella sezione corrente.'
	PRINT CHAR(13) + '--Ricerca piano libero in altre sezioni--'

	DECLARE	@codicesezioneinizio INT
		,@codicesezionefine INT
		
	SET @codpianocheck = 1 --reimposto la start condition: piano 1, esito OK (=1)
	SET @esito = 1 
	SET @codicesezioneinizio = 1 --Non prendo più la sezione corrente, inizio dalla prima
	SET @codicesezionefine = @codicesezioneinizio

		 

    WHILE EXISTS (SELECT *
	FROM R_Cliente_Archivio r
	JOIN @Archivio on r.CodScaffaleInizio = [@Archivio].CodScaffaleInizio AND r.CodScaffaleFine = [@Archivio].CodScaffaleFine
	WHERE  (
			 (r.CodiceSezioneInizio = @codicesezioneinizio AND r.CodiceSezioneFine <= ( SELECT NumeroSezioni FROM S_Archivio JOIN @Archivio ON CodScaffale = [@Archivio].CodScaffaleInizio))
			OR (r.CodiceSezioneInizio <= @codicesezioneinizio and r.CodiceSezioneFine >= @codicesezioneinizio)
			)
	AND  (
			   (r.CodicePianoInizio >= @codpianocheck AND r.CodicePianoInizio <= (@codpianocheck + @NumeroPiani - 1)) 
			OR (r.CodicePianoFine >= @codpianocheck AND r.CodicePianoFine <= (@codpianocheck + @NumeroPiani - 1))	
			OR (r.CodicePianoInizio <= @codpianocheck and r.CodicePianoFine >= (@codpianocheck + @NumeroPiani - 1))
			OR (r.CodicePianoInizio =  @codpianocheck AND r.CodicePianoFine = @codpianocheck )
			OR (r.CodicePianoInizio =  @codpianocheck AND r.CodicePianoFine <= (@codpianocheck + @NumeroPiani - 1))
			 )
		 ) 

	BEGIN
	
	--Decommentare per analizzare il giro di ricerche, consapevoli che ad ogni giro esegue la coppia di print ;)
	--=================================================================
	--PRINT 'sezione ' + CAST(@codicesezioneinizio as VARCHAR(5))
	--PRINT 'piano ' + CAST(@codpianocheck as VARCHAR(5))
	--=================================================================

	IF (@codpianocheck + @NumeroPiani) > (SELECT PianiMax FROM @Archivio) --controllo se si è raggiunto il numero di piani max consentito dal setup nella S_Archivio
		BEGIN
		IF @codicesezionefine < (SELECT NumeroSezioni FROM S_Archivio JOIN @Archivio on CodScaffale = CodScaffaleInizio) --controllo che non siano finite le sezioni da controllare
			BEGIN
				--Si passa alla sezione sucessiva
				SET @codpianocheck = 1
				SET @codicesezioneinizio = @codicesezioneinizio + 1
				SET @codicesezionefine = @codicesezioneinizio

				--PRINT @codpianocheck --idem come sopra
			END        
		ELSE
		--Finite tutte le sezioni dello scaffale corrente, interrompo il ciclo
			BEGIN
				SET @esito = 0
				BREAK
			END	
		END
	ELSE
	--continuo a cercare
		BEGIN
		SET @codpianocheck = @codpianocheck + 1
		CONTINUE
		END
	    	    
	END
    
	
	IF @esito = 1 
	BEGIN
    	PRINT '  Esito: OK, ' + 'Sezione libera: ' + CAST(@codicesezioneinizio as VARCHAR(4)) + SPACE(1) + 'Piano: ' + CAST(@codpianocheck as VARCHAR(4)) 
		PRINT CHAR(13) + '--Salvataggio setup della R_Cliente_Archivio--'
		INSERT into #setup (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
			SELECT
				@CodCliente,
				@CodTipoIncarico,
				[@Archivio].CodTipoArchiviazione,
				[@Archivio].CodScaffaleInizio,
				@codicesezioneinizio,
				@codpianocheck [CodicePianoInizio],
				1 [CodiceScatolaInizio],
				[@Archivio].CodScaffaleFine,
				@codicesezionefine,
				@codpianocheck + (@NumeroPiani - 1) [CodicePianoFine],
				S_Archivio.NumeroScatole [CodiceScatolaFine],
				NumeroDocumenti,
				FlagTemporaneo,
				CodDocumento
			FROM R_Cliente_Archivio
			JOIN @Archivio	ON R_Cliente_Archivio.IdRelazione = [@Archivio].IdRelazione
			JOIN S_Archivio on [@Archivio].CodScaffaleInizio = S_Archivio.CodScaffale


    END
	ELSE
		BEGIN
			PRINT '  Esito: KO: Nessun piano libero presente nelle altre sezioni del CodScaffale corrente'
			PRINT CHAR(13) + 'Riprovare con numero piani inferiore da allocare'
			PRINT '  Se l''errore persiste, ricercare uno scaffale utilizzabile in produzione ed eseguire il primo setup manualmente'
			PRINT CHAR(13) + '----------------FINE---------------'

		--Punto aperto da condividere con ORGA
		END

	END

IF @esito = 1
BEGIN
IF @FlagSimulazione = 1

BEGIN
PRINT CHAR(13) + '--SELECT del Setup simulato--'
SELECT	* FROM #setup
PRINT CHAR(13) + '----------------FINE---------------'
END

ELSE
BEGIN
	INSERT into R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
	SELECT 	CodCliente,
			CodTipoIncarico,
			CodTipoArchiviazione,
			CodScaffaleInizio,
			CodiceSezioneInizio,
			CodicePianoInizio,
			CodiceScatolaInizio,
			CodScaffaleFine,
			CodiceSezioneFine,
			CodicePianoFine,
			CodiceScatolaFine,
			NumeroDocumenti,
			FlagTemporaneo,
			CodDocumento 
	FROM #setup

PRINT CHAR(13) + '----------------FINE---------------'
PRINT CHAR(13) + 'Eseguire il comando EXEC Popola_S_PosizioneArchivio'

END
END

END
ELSE
BEGIN
	PRINT CHAR(13) + 'Archivio non esistente per il tipo incarico selezionato. Verificare il processo ed eseguire il primo setup manualmente'
	PRINT CHAR(13) + '----------------FINE----------------'
END

DROP TABLE #setup

END


GO



