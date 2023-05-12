USE CLC
GO

/*
152
178
153
147
325
57
*/

IF OBJECT_ID('tempdb.dbo.#setup') IS NOT NULL
	DROP TABLE #setup

CREATE TABLE #setup (
	CodCliente INT
	,CodTipoIncarico INT
	,CodTipoArchiviazione SMALLINT
	,CodScaffaleInizio INT
	,CodiceSezioneInizio INT
	,CodicePianoInizio INT
	,CodiceScatolaInizio INT
	,CodScaffaleFine INT
	,CodiceSezioneFine INT
	,CodicePianoFine INT
	,CodiceScatolaFine INT
	,NumeroDocumenti INT
	,FlagTemporaneo BIT
	,CodDocumento INT
)

DECLARE @CodTipoIncaricoCur INT

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
SELECT CodTipoIncarico
	--,D_TipoIncarico.Descrizione TipoIncarico
	--,COUNT(t.IdPosizioneArchivio) PosizioniUtilizzate
	--,COUNT(s.IdPosizioneArchivio) PosizioniDisponibili

FROM [BTSQLCL05\BTSQLCL05].clc.dbo.S_PosizioneArchivio s
LEFT JOIN [BTSQLCL05\BTSQLCL05].clc.dbo.T_PeriodoPosizioneArchivioUtilizzata t
	ON s.IdPosizioneArchivio = t.IdPosizioneArchivio
JOIN [BTSQLCL05\BTSQLCL05].clc.dbo.D_TipoIncarico
	ON Codice = CodTipoIncarico
WHERE CodCliente = 23
--AND CodTipoIncarico = 137
GROUP BY	CodCliente
			,CodTipoIncarico
			,Descrizione
HAVING (COUNT(t.IdPosizioneArchivio) / COUNT(s.IdPosizioneArchivio)) >= 1

OPEN cur

FETCH NEXT FROM cur INTO @CodTipoIncaricoCur
	


WHILE @@FETCH_STATUS = 0
BEGIN
DELETE FROM #setup

INSERT INTO #setup (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
EXEC orga.CESAM_SetupArchivio	@CodCliente = 23
								,@CodTipoIncarico = @CodTipoIncaricoCur
								,@FlagSimulazione = 1
								,@NumeroPiani = 1
IF EXISTS (SELECT
		*
	FROM #setup
	JOIN orga.v_PosizioniArchivioOccupateNonSettate v
		ON v.CodScaffale = CodScaffaleInizio
		AND v.CodiceSezione = CodiceSezioneInizio
		AND v.CodicePiano >= CodicePianoInizio
		AND v.CodicePiano <= CodicePianoFine)
BEGIN
	SELECT @CodTipoIncaricoCur CodTipoIncarico,
		'Setup Archivio calcolato non disponibile' Esito
		,	v.IdPeriodoPosizioneArchivioUtilizzata
	,v.Versione
	,v.IdPosizioneArchivio
	,v.Periodo
	,v.Progressivo
	,v.IdIncarico
	,v.FlagEtichettaStampata
	,v.CodScaffale
	,v.CodiceSezione
	,v.CodicePiano
	,v.CodiceScatola
	,v.CodiceColore
	
FROM #setup
JOIN orga.v_PosizioniArchivioOccupateNonSettate v
	ON v.CodScaffale = CodScaffaleInizio
	AND v.CodiceSezione = CodiceSezioneInizio
	AND v.CodicePiano >= CodicePianoInizio
	AND v.CodicePiano <= CodicePianoFine

END

ELSE
BEGIN
	SELECT @CodTipoIncaricoCur CodTipoIncarico,
		'Posizione Archivio calcolato Inseribile' Esito

END

FETCH NEXT FROM cur INTO @CodTipoIncaricoCur
	
END

CLOSE cur
DEALLOCATE cur


DROP TABLE #setup
GO


