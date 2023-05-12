USE CLC_Cesam
GO

IF OBJECT_ID('tempdb.dbo.#T_Incarico') IS NOT NULL
BEGIN
	DROP TABLE #T_Incarico
END

SELECT
	ti.IdIncarico
   ,ti.CodTipoIncarico
   ,dbo.D_TipoIncarico.Descrizione TipoIncarico
   ,EtichettaMese MeseCreazione
   ,Anno AnnoCreazione
   ,FORMAT(ti.DataCreazione, 'dd/MM/yyyy HH:mm') DataCreazione INTO #T_Incarico
FROM dbo.T_Incarico ti
JOIN dbo.D_TipoIncarico
	ON ti.CodTipoIncarico = D_TipoIncarico.Codice
JOIN rs.S_Data
	ON CAST(ti.DataCreazione AS DATE) = CAST(ChiaveData AS DATE)
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.FlagArchiviato = 0
AND ti.DataCreazione >= '20230101'
AND ti.DataCreazione < '20230301'

CREATE INDEX IX_T_incarico_idIncarico ON #T_Incarico (IdIncarico ASC)
CREATE INDEX IX_T_Incarico_CodTipoIncarico ON #T_Incarico (CodTipoIncarico ASC)


IF OBJECT_ID('tempdb.dbo.#VariatiAP') IS NOT NULL
BEGIN
	DROP TABLE #VariatiAP
END


SELECT
	ti.*
   ,variazioneincaricoAP.IdOperatore
   ,variazioneincaricoAP.Etichetta
   ,FORMAT(variazioneincaricoAP.DataVariazione,'dd/MM/yyyy HH:mm') DataVariazione
   INTO #VariatiAP
FROM #T_Incarico ti
CROSS APPLY (SELECT
		tapx.IdAttivita
	   ,S_Operatore.IdOperatore
	   ,Etichetta
	   ,stapx.DataModifica DataVariazione
	FROM dbo.T_AttivitaPianificataIncarico tapx
	JOIN storico.Log_T_AttivitaPianificataIncarico stapx
		ON tapx.IdAttivita = stapx.IdAttivita
		AND tapx.CodTipoAttivitaPianificata = 552 --Variazione Tipo Incarico
		AND stapx.CodTipoModifica = 1
	JOIN dbo.S_Operatore
		ON stapx.IdOperatore = dbo.S_Operatore.IdOperatore
		AND CodProfiloAccesso IN (845, 867)
	WHERE tapx.IdIncarico = ti.IdIncarico) variazioneincaricoAP

CREATE INDEX IX_VariatiAP_CodTipoIncarico ON #VariatiAP (CodTipoIncarico ASC)
CREATE INDEX IX_VariatiAP_IdIncarico ON #VariatiAP (IdIncarico ASC)


IF OBJECT_ID('tempdb.dbo.#VariatiGestDati') IS NOT NULL
BEGIN
	DROP TABLE #VariatiGestDati
END


SELECT
	sti.IdIncarico
   ,sti.CodTipoIncarico
   ,sti.TipoIncarico
   ,sti.MeseCreazione
   ,sti.AnnoCreazione
   ,sti.DataCreazione
   ,sti.IdOperatore
   ,sti.Etichetta
   ,FORMAT(sti.DataVariazione,'dd/MM/yyyy HH:mm') DataVariazione
   ,sti.CodTipoIncaricoPrecedente INTO #VariatiGestDati
FROM (SELECT
		#T_Incarico.*
	   ,DataModifica DataVariazione
	   ,Log_T_Incarico.IdOperatore
	   ,FlagAttivo
	   ,CodProfiloAccesso
	   ,Etichetta
	   ,Log_T_Incarico.CodTipoIncarico CodTipoIncaricoLog
	   ,LAG(storico.Log_T_Incarico.CodTipoIncarico) OVER (PARTITION BY Log_T_Incarico.IdIncarico ORDER BY Log_T_Incarico.IdIncarico, DataModifica ASC) CodTipoIncaricoPrecedente
	FROM #T_Incarico
	JOIN storico.Log_T_Incarico
		ON #T_Incarico.IdIncarico = Log_T_Incarico.IdIncarico
	LEFT JOIN dbo.S_Operatore
		ON storico.Log_T_Incarico.IdOperatore = S_Operatore.IdOperatore) sti
WHERE sti.CodTipoIncaricoLog != sti.CodTipoIncaricoPrecedente
AND sti.CodProfiloAccesso IN (845, 867)

CREATE INDEX IX_VariatiGestDati_CodTipoIncarico ON #VariatiGestDati (CodTipoIncarico ASC)
CREATE INDEX IX_VariatiGestDati_IdIncarico ON #VariatiGestDati (IdIncarico ASC)


;
WITH merged_tipi_incarico
AS
(SELECT DISTINCT
		CodTipoIncarico
	FROM #VariatiAP
	UNION
	SELECT DISTINCT
		CodTipoIncarico
	FROM #VariatiGestDati)


SELECT
	#T_Incarico.IdIncarico
   ,#T_Incarico.CodTipoIncarico
   ,#T_Incarico.TipoIncarico
   ,#T_Incarico.MeseCreazione
   ,#T_Incarico.AnnoCreazione
   ,#T_Incarico.DataCreazione
   ,CASE WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico ORDER BY #T_Incarico.IdIncarico) > 1 THEN 0 ELSE 1 END ContatoreIncarico
   ,CASE
		WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico, #VariatiAP.DataVariazione ORDER BY #T_Incarico.IdIncarico, #VariatiAP.DataVariazione) > 1 OR
			#VariatiAP.IdIncarico IS NULL THEN 0
		ELSE 1
	END VariatoAP
   ,CASE
		WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico, #VariatiAP.DataVariazione ORDER BY #T_Incarico.IdIncarico, #VariatiAP.DataVariazione) > 1 OR
			#VariatiAP.IdIncarico IS NULL THEN NULL
		ELSE #VariatiAP.Etichetta
	END OperatoreVariazioneAP
   ,CASE
		WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico, #VariatiAP.DataVariazione ORDER BY #T_Incarico.IdIncarico, #VariatiAP.DataVariazione) > 1 OR
			#VariatiAP.IdIncarico IS NULL THEN NULL
		ELSE #VariatiAP.DataVariazione
	END DataVariazioneAP

   ,CASE
		WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico, #VariatiGestDati.DataVariazione ORDER BY #T_Incarico.IdIncarico, #VariatiGestDati.DataVariazione) > 1 OR
			#VariatiGestDati.IdIncarico IS NULL THEN 0
		ELSE 1
	END VariatoGestDati
   ,CASE
		WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico, #VariatiGestDati.DataVariazione ORDER BY #T_Incarico.IdIncarico, #VariatiGestDati.DataVariazione) > 1 OR
			#VariatiGestDati.IdIncarico IS NULL THEN NULL
		ELSE #VariatiGestDati.Etichetta
	END OperatoreVariazioneGestDati
   ,CASE
		WHEN ROW_NUMBER() OVER (PARTITION BY #T_Incarico.IdIncarico, #VariatiGestDati.DataVariazione ORDER BY #T_Incarico.IdIncarico, #VariatiGestDati.DataVariazione) > 1 OR
			#VariatiGestDati.IdIncarico IS NULL THEN NULL
		ELSE #VariatiGestDati.DataVariazione
	END DataVariazioneGestDati

FROM #T_Incarico
JOIN merged_tipi_incarico
	ON #T_Incarico.CodTipoIncarico = merged_tipi_incarico.CodTipoIncarico
LEFT JOIN #VariatiAP
	ON #T_Incarico.IdIncarico = #VariatiAP.IdIncarico
LEFT JOIN #VariatiGestDati
	ON #T_Incarico.IdIncarico = #VariatiGestDati.IdIncarico

--WHERE #VariatiAP.IdIncarico IS NOT NULL AND #VariatiGestDati.IdIncarico IS NOT NULL

DROP TABLE #T_Incarico, #VariatiAP, #VariatiGestDati



