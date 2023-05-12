USE CLC
GO


IF NOT EXISTS (SELECT
		CodTipoIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		,COUNT(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio) PosizioniUtilizzate
		,COUNT(S_PosizioneArchivio.IdPosizioneArchivio) PosizioniDisponibili

	FROM S_PosizioneArchivio
	LEFT JOIN T_PeriodoPosizioneArchivioUtilizzata
		ON S_PosizioneArchivio.IdPosizioneArchivio = T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio
	JOIN D_TipoIncarico
		ON Codice = CodTipoIncarico
	WHERE CodCliente = 23
	--AND CodTipoIncarico = 137
	GROUP BY	CodCliente
				,CodTipoIncarico
				,Descrizione

	HAVING (COUNT(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio) / COUNT(S_PosizioneArchivio.IdPosizioneArchivio)) >= 0.8)
BEGIN
	SELECT
		1 / 0 CodTipoIncarico
		,'' TipoIncarico
		,1 / 0 PosizioniUtilizzate
		,1 / 0 PosizioniDisponibili
END
ELSE
BEGIN
	SELECT
		CodTipoIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		,COUNT(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio) PosizioniUtilizzate
		,COUNT(S_PosizioneArchivio.IdPosizioneArchivio) PosizioniDisponibili

	FROM S_PosizioneArchivio
	LEFT JOIN T_PeriodoPosizioneArchivioUtilizzata
		ON S_PosizioneArchivio.IdPosizioneArchivio = T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio
	JOIN D_TipoIncarico
		ON Codice = CodTipoIncarico
	WHERE CodCliente = 23
	--AND CodTipoIncarico = 137
	GROUP BY	CodCliente
				,CodTipoIncarico
				,Descrizione

	HAVING (COUNT(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio) - COUNT(S_PosizioneArchivio.IdPosizioneArchivio)) >= -2

END
