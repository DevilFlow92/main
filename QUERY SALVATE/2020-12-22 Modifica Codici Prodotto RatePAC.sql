USE CLC
GO

IF OBJECT_ID('tempdb.dbo.#tmpDatiAggiuntivi') IS NOT NULL
	DROP TABLE #tmpDatiAggiuntivi


	SELECT IdIncarico			
		  ,NumeroMandato
		  ,CodiceSocietaProdotto
		   ,IdDatoAggiuntivoCodiceProdotto
		  ,CodiceProdotto		 
		  ,CASE CodiceProdotto
			WHEN '21e' THEN 's1e'
			WHEN '21g' THEN 's1g'
			WHEN '05e' THEN 'r9e'
			WHEN '05g' THEN 'r9g'
			WHEN '35e' THEN 's2e'
			WHEN '35g' THEN 's2g'
			WHEN 'b2e' THEN 's0e'
			WHEN 'b2g' THEN 's0g'
			WHEN 'b8e' THEN 's3e'
			WHEN 'b8g' THEN 's3g'
			END CodiceProdottoNuovo
	INTO #tmpDatiAggiuntivi
	FROM rs.v_CESAM_AZ_Incarichi_PAC
	WHERE CodiceProdotto IN ('21E,','21G','05E','05G','35E','35G','b2e','b2g','b8e','b8g'
	--'21f,','21s','05f','05s','35f','35s'
	)

	UPDATE T_DatoAggiuntivo
	SET Testo = CodiceProdottoNuovo
	FROM T_DatoAggiuntivo
	JOIN #tmpDatiAggiuntivi ON T_DatoAggiuntivo.IdDatoAggiuntivo = #tmpDatiAggiuntivi.IdDatoAggiuntivoCodiceProdotto

	DROP TABLE #tmpDatiAggiuntivi