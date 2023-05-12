USE CLC_Cesam


DECLARE @IdIncarico INT
,@IdPosizioneArchivio BIGINT
,@IdPosizioneNuova BIGINT
,@CodCliente INT
,@CodTipoIncaricoAttuale INT
,@CodTipoIncaricoArchivio INT


DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
SELECT
	DISTINCT T_Incarico.IdIncarico,T_Documento.IdPosizioneArchivio, T_Incarico.CodCliente, T_Incarico.CodTipoIncarico CodTipoIncaricoAttuale
	,S_PosizioneArchivio.CodTipoIncarico CodTipoIncaricoArchivio
FROM T_Incarico
JOIN T_Documento
	ON T_Incarico.IdIncarico = T_Documento.IdIncarico
JOIN S_PosizioneArchivio
	ON T_Documento.IdPosizioneArchivio = S_PosizioneArchivio.IdPosizioneArchivio
JOIN D_Scaffale
	ON CodScaffale = D_Scaffale.Codice

WHERE T_Incarico.idincarico IN (
/* inserire gli incarichi dove aggiornare la posizione archivio */
22599949
)

--SELECT * FROM sta

OPEN cur

FETCH NEXT FROM cur INTO @IdIncarico, @IdPosizioneArchivio, @CodCliente, @CodTipoIncaricoAttuale, @CodTipoIncaricoArchivio

WHILE @@FETCH_STATUS = 0 
BEGIN
	IF @CodTipoIncaricoAttuale <> @CodTipoIncaricoArchivio
	BEGIN
		SET @IdPosizioneNuova = (SELECT MIN(S_PosizioneArchivio.IdPosizioneArchivio)			
									FROM S_PosizioneArchivio
									LEFT JOIN T_PeriodoPosizioneArchivioUtilizzata ON S_PosizioneArchivio.IdPosizioneArchivio = T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio
									LEFT JOIN T_Documento ON S_PosizioneArchivio.IdPosizioneArchivio = T_Documento.IdPosizioneArchivio
									WHERE CodCliente = @CodCliente
									AND CodTipoIncarico = @CodTipoIncaricoAttuale
									AND T_Documento.IdPosizioneArchivio IS NULL
									AND T_PeriodoPosizioneArchivioUtilizzata.IdPeriodoPosizioneArchivioUtilizzata IS NULL
								)	

		SELECT @IdIncarico, @IdPosizioneArchivio, @IdPosizioneNuova 
		
		UPDATE T_PeriodoPosizioneArchivioUtilizzata 
		SET IdPosizioneArchivio = @IdPosizioneNuova
		WHERE IdIncarico = @IdIncarico
		
		UPDATE T_Documento
		SET IdPosizioneArchivio = @IdPosizioneNuova
		WHERE IdIncarico = @IdIncarico
		AND IdPosizioneArchivio = @IdPosizioneArchivio

	END
	ELSE 
	BEGIN
		PRINT 'Nessuna azione necessaria.'
	END

FETCH NEXT FROM cur INTO @IdIncarico,@IdPosizioneArchivio, @CodCliente, @CodTipoIncaricoAttuale, @CodTipoIncaricoArchivio

END

CLOSE cur
DEALLOCATE cur

