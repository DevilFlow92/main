USE clc
GO

--ALTER FUNCTION rs.f_CESAM_AZ_Successioni_RilevaSLA_Incarico
--(
--	@IdIncarico INT
--,@DataTransizioneDAL DATETIME
--,@DataTransizioneALEscluso DATETIME
--,@IdIncaricoFase INT null

--)

--RETURNS @SLA_Incarico  TABLE (
--     IdIncaricoMaster INT
--	   ,IdIncaricoFase INT
--     ,CodClienteFase int
--	   ,CodTipoIncaricoFase SMALLINT
--	   ,DataCreazioneIncaricoFase DATETIME
--	   ,DataUltimaTransizioneIncaricoFase DATETIME
--	   ,CodStatoWorkflowIncaricoFase SMALLINT
--	   ,TipoIncaricoFase VARCHAR(200)
--	   ,StatoWorkflowIncaricoFase VARCHAR(200)
--		,Fase VARCHAR(100)
--	   ,DataInizioLavorazione DATETIME
--	   ,DataFineLavorazione DATETIME
--		,GiorniLavorativiTrascorsi smallint
--      ,GiorniLavorativiSoglia tinyint
--		,EsitoSLA VARCHAR(20)
--		,EsitoSLAIncaricoMaster VARCHAR(20)
--		,ISFaseTerminata bit

--) AS


BEGIN

/********* decommentare per test ***********************/

DECLARE @idincarico INT = 19296194  
,@DataTransizioneDAL DATETIME = '20210920'
,@DataTransizioneALEscluso DATETIME = GETDATE()
,@IdIncaricoFase int = 
--NULL
--19118961 
19119124


DECLARE @SLA_Incarico TABLE(
     IdIncaricoMaster INT
	   ,IdIncaricoFase INT
       ,CodClienteFase INT
	   ,CodTipoIncaricoFase SMALLINT
	   ,DataCreazioneIncaricoFase DATETIME
	   ,DataUltimaTransizioneIncaricoFase DATETIME
	   ,CodStatoWorkflowIncaricoFase SMALLINT
	   ,TipoIncaricoFase VARCHAR(200)
	   ,StatoWorkflowIncaricoFase VARCHAR(200)
       ,Fase VARCHAR(100)
	   ,DataInizioLavorazione DATETIME
	   ,DataFineLavorazione DATETIME
	   ,GiorniLavorativiTrascorsi SMALLINT
	   ,GiorniLavorativiSoglia TINYINT
	   ,EsitoSLA VARCHAR(20)
       ,EsitoSLAIncaricoMaster VARCHAR(20)
	   ,ISFaseTerminata BIT
)

/******************************/

	DECLARE @Base_SLA TABLE (
		IdIncaricoMaster INT
	   ,IdIncaricoFase INT
	   ,CodTipoIncarico SMALLINT
	   ,CodStatoAttuale INT
       ,Fase VARCHAR(100)
       ,DataTransizione DATETIME
	   ,DataTransizionePrecedente DATETIME
	   --,CodStatoWorkflowIncaricoPartenza INT
	   ,CodStatoWorkflowIncaricoDestinazione INT
	   ,GiorniIntervallo INT
	   ,GiorniPermanenza INT

	)

	DECLARE @SetupWorkflowSLA TABLE (
	CodCliente SMALLINT
	,CodTipoIncarico SMALLINT
	,CodStatoWorkflowIncaricoPartenza INT
	,CodStatoWorkflowIncaricoDestinazione INT
	,Fase VARCHAR(250)
	)

	DECLARE @StatiTerminaliSLA TABLE (
	CodCliente SMALLINT
	,CodTipoIncarico SMALLINT
	,Fase VARCHAR(250)
	,CodStatoWorkflowInizio int
	,CodStatoWorkflowFine INT
	)

	
	/********************** SETUP WORKFLOW PER GLI SLA ***********************/

	INSERT INTO @SetupWorkflowSLA (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, Fase)
	SELECT CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FaseLavorazione
	FROM rs.v_CESAM_AZ_Successioni_SetupWorkflowSLA

	INSERT INTO @StatiTerminaliSLA (CodCliente, CodTipoIncarico, Fase, CodStatoWorkflowInizio, CodStatoWorkflowFine)
	SELECT CodCliente, CodTipoIncarico, Fase, CodStatoWorkflowInizio, CodStatoWorkflowFine
	FROM rs.v_CESAM_AZ_Successioni_StatiTerminaliSLA

	/********************** FINE SETUP WORKFLOW PER GLI SLA ******************/

	IF @IdIncaricoFase IS NOT NULL
	BEGIN
    	;WITH M1 AS (
			SELECT DISTINCT

		ti1.IdIncarico
		,ISNULL(tris.IdIncaricoMaster,0) IdIncaricoMaster
		,ti1.DataCreazione
		,ti1.CodCliente
		,ti1.CodTipoIncarico
		,ti1.CodStatoWorkflowIncarico CodStatoAttuale
		,lwi1.IdTransizione
		,lwi1.DataTransizione
		,lwi1.CodStatoWorkflowIncaricoPartenza
		,lwi1.CodStatoWorkflowIncaricoDestinazione
		,MAX(lwi1.IdTransizione) OVER (PARTITION BY lwi1.IdIncarico) MaxIdTransizione
		,MAX(lwi1.DataTransizione) OVER (PARTITION BY lwi1.IdIncarico) MaxDataTransizione
		,LAG(lwi1.DataTransizione,1) OVER (PARTITION BY lwi1.IdIncarico ORDER BY lwi1.IdTransizione ASC ) DataTransizionePrecedente
		
		FROM T_Incarico ti1
		JOIN L_WorkflowIncarico lwi1 ON ti1.IdIncarico = lwi1.IdIncarico
		outer APPLY (
						SELECT TOP 1 trisx.IdIncarico IdIncaricoMaster, trisx.IdSubIncarico
                        FROM T_R_Incarico_SubIncarico trisx
						WHERE trisx.IdSubIncarico = ti1.IdIncarico
						ORDER BY trisx.IdRelazione ASC
		) tris
		--AND lwi1.DataTransizione >= '20210920'
		WHERE ti1.IdIncarico = @IdIncaricoFase
		AND ti1.DataCreazione >= '20210920'
		AND ti1.CodTipoIncarico IN (54 --Successioni
									,151	--Successioni - Sicav
									,164	--Successioni - Polizze Azimut Life
									,165	--Successioni - Fondi di Investimento
									,166	--Successioni - Polizze Compagnie Terze
									,175	--Successioni - Previdenza
									,184	--Successioni - Gestioni Individuali
									,185	--Successioni - Raccolta Ordini
									,193	--Successioni - Banco Popolare
									,351	--Successioni AFB
									,659	--AZISF - Successioni - Previdenza
									,783	--Successioni - Fondi Chiusi
									)
		AND ti1.codstatoworkflowincarico NOT IN (440	 --Caricamento Errato
												 ,6505	 --De Cuius non cliente
												 ,22582	 --Segnalazione Errata
												)

	), WfDocConclusa AS (
					SELECT lwi_DocConclusa.IdTransizione IdTransizioneDocConclusa, lwi_DocConclusa.IdIncarico, lwi_DocConclusa.DataTransizione DataTransizioneDocConclusa
					,ROW_NUMBER() OVER (PARTITION BY lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_DocConclusa.DataTransizione ASC ) ProgressivoFase
					,ISNULL(LAG(lwi_DocConclusa.DataTransizione,1) OVER (PARTITION BY lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_DocConclusa.IdTransizione ASC ), M1.DataCreazione) AS DataTransizioneConclusaPrecedente 
		
					FROM L_WorkflowIncarico lwi_DocConclusa
					JOIN m1 ON lwi_DocConclusa.IdIncarico = M1.IdIncarico
					AND lwi_DocConclusa.IdTransizione = M1.IdTransizione
			
					WHERE lwi_DocConclusa.CodStatoWorkflowIncaricoPartenza != lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione
					AND lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione = 21330
					--ORDER BY lwi_DocConclusa.DataTransizione ASC

	), WfFaseIntegrazioni AS (
					SELECT IdIncarico
					,IdTransizioneDocConclusa
							,DataTransizioneDocConclusa
						  ,ProgressivoFase
						  ,DataTransizioneConclusaPrecedente
						  ,wfIntegrazioniRicevute.DataTransizione DataTransizioneIntegrazioniRicevute
					FROM WfDocConclusa
					CROSS APPLY (
								SELECT TOP 1 lwi_IntegrazioniRicevute.IdTransizione, lwi_IntegrazioniRicevute.DataTransizione
								FROM L_WorkflowIncarico lwi_IntegrazioniRicevute
								WHERE WfDocConclusa.IdIncarico = lwi_IntegrazioniRicevute.IdIncarico
								AND lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoPartenza != lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoDestinazione
								AND lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoDestinazione = 15546
								AND lwi_IntegrazioniRicevute.DataTransizione < WfDocConclusa.DataTransizioneDocConclusa
								AND lwi_IntegrazioniRicevute.DataTransizione >= WfDocConclusa.DataTransizioneConclusaPrecedente
						
							) wfIntegrazioniRicevute
			

		), wfLiquidata AS (
					SELECT lwi_Liquidata.IdTransizione IdTransizioneLiquidata, lwi_Liquidata.IdIncarico, lwi_Liquidata.DataTransizione DataTransizioneLiquidata
					,ROW_NUMBER() OVER (PARTITION BY lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_Liquidata.DataTransizione ASC ) ProgressivoFase
					,ISNULL(LAG(lwi_Liquidata.DataTransizione,1) OVER (PARTITION BY lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_Liquidata.IdTransizione ASC ), M1.DataCreazione) AS DataTransizioneLiquidataPrecedente 
		
					FROM L_WorkflowIncarico lwi_Liquidata
					JOIN m1 ON lwi_Liquidata.IdIncarico = M1.IdIncarico
					AND lwi_Liquidata.IdTransizione = M1.IdTransizione
					JOIN @StatiTerminaliSLA ON m1.codcliente = [@StatiTerminaliSLA].CodCliente
					AND m1.codtipoincarico = [@StatiTerminaliSLA].CodTipoIncarico
					AND [@StatiTerminaliSLA].Fase = 'Fase 6 (Liquidazione)'
					WHERE lwi_Liquidata.CodStatoWorkflowIncaricoPartenza != lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione
					AND (lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione = [@StatiTerminaliSLA].CodStatoWorkflowFine
							--OR lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione = 820
							)
							

		),wfLiquidazione AS (
					SELECT IdIncarico
					,IdTransizioneLiquidata
							,DataTransizioneLiquidata
						  ,ProgressivoFase
						  ,DataTransizioneLiquidataPrecedente
						  ,wfInizioLiquidazione.DataTransizione DataTransizioneInizioLiquidazione
					FROM wfLiquidata
					CROSS APPLY (
								SELECT TOP 1 lwi_InizioLiquidazione.IdTransizione, lwi_InizioLiquidazione.DataTransizione
								FROM L_WorkflowIncarico lwi_InizioLiquidazione
								JOIN T_Incarico tix1 ON lwi_InizioLiquidazione.IdIncarico = tix1.IdIncarico
								JOIN @StatiTerminaliSLA ON tix1.CodCliente = [@StatiTerminaliSLA].CodCliente
								AND tix1.CodTipoIncarico = [@StatiTerminaliSLA].CodTipoIncarico
								AND Fase =  'Fase 6 (Liquidazione)'
								WHERE wfLiquidata.IdIncarico = lwi_InizioLiquidazione.IdIncarico
								AND lwi_InizioLiquidazione.CodStatoWorkflowIncaricoPartenza != lwi_InizioLiquidazione.CodStatoWorkflowIncaricoDestinazione
								AND lwi_InizioLiquidazione.CodStatoWorkflowIncaricoDestinazione = CodStatoWorkflowInizio
								AND lwi_InizioLiquidazione.DataTransizione < wfLiquidata.DataTransizioneLiquidata
								AND lwi_InizioLiquidazione.DataTransizione >= wfLiquidata.DataTransizioneLiquidataPrecedente
						
							) wfInizioLiquidazione

		)
		INSERT INTO @Base_SLA (IdIncaricoMaster, IdIncaricoFase, CodTipoIncarico, CodStatoAttuale, Fase, DataTransizione, DataTransizionePrecedente, CodStatoWorkflowIncaricoDestinazione, GiorniIntervallo, GiorniPermanenza)
		SELECT DISTINCT M1.IdIncaricoMaster, M1.IdIncarico, m1.CodTipoIncarico, m1.CodStatoAttuale
	, CASE WHEN Fase = 'Fase 3 (Verifica Integrazioni)'  THEN Fase + ' [' + CAST(ISNULL(WfFaseIntegrazioni.ProgressivoFase,'0') AS VARCHAR(4)) + ']'
		WHEN fase = 'Fase 6 (Liquidazione)' THEN fase + ' [' + CAST(ISNULL(wfLiquidazione.ProgressivoFase,'0') AS VARCHAR(4)) + ']'
		WHEN FaseTerminata.IdTransizione IS NOT NULL AND m1.DataTransizione > FaseTerminata.DataTransizione THEN 'CHECK'
		WHEN (fase LIKE 'Fase 4%' OR fase LIKE 'Fase 5%') AND (tda.testo IS NULL OR tda.testo != 'SI') AND M1.CodTipoIncarico IN (164,175,166,659) THEN 'CHECK'
		ELSE Fase
		END AS Fase

	, m1.DataTransizione, DataTransizionePrecedente
	,M1.CodStatoWorkflowIncaricoDestinazione
	,rs.IntervalloLavorativoGiorni(DataTransizionePrecedente,M1.DataTransizione) as GiorniIntervallo
	, CASE WHEN M1.IdTransizione = MaxIdTransizione 
		THEN  rs.IntervalloLavorativoGiorni(MaxDataTransizione,GETDATE()) 
		ELSE 0 END AS GiorniPermanenza


	FROM M1
	JOIN @SetupWorkflowSLA ON M1.CodCliente = [@SetupWorkflowSLA].CodCliente
	AND M1.CodTipoIncarico = [@SetupWorkflowSLA].CodTipoIncarico
	AND ( 
		  (	
			M1.CodStatoWorkflowIncaricoPartenza = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoPartenza
		   AND M1.CodStatoWorkflowIncaricoDestinazione = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoDestinazione
		  )
		  OR ( m1.CodStatoWorkflowIncaricoPartenza IS NULL AND m1.CodStatoWorkflowIncaricoDestinazione = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoDestinazione)
		)
	
	LEFT JOIN WfFaseIntegrazioni ON M1.IdIncarico = WfFaseIntegrazioni.IdIncarico
	AND m1.DataTransizione >= WfFaseIntegrazioni.DataTransizioneIntegrazioniRicevute
	AND m1.DataTransizione <= WfFaseIntegrazioni.DataTransizioneDocConclusa
	
	LEFT JOIN wfLiquidazione ON m1.idincarico = wfLiquidazione.IdIncarico
	AND m1.datatransizione >= wfLiquidazione.DataTransizioneInizioLiquidazione
	AND m1.DataTransizione <= wfLiquidazione.DataTransizioneLiquidata

	LEFT JOIN T_DatoAggiuntivo tda ON M1.IdIncarico = tda.idincarico
	AND tda.flagattivo = 1
	AND tda.codtipodatoaggiuntivo = 2424 --Lettera Valorizzazione prevista
		OUTER APPLY (
					SELECT TOP 1 lwiTerminata.IdTransizione, lwiTerminata.DataTransizione
                    FROM L_WorkflowIncarico lwiTerminata
					JOIN @StatiTerminaliSLA ON lwiTerminata.CodStatoWorkflowIncaricoPartenza != lwiTerminata.CodStatoWorkflowIncaricoDestinazione
											AND lwiTerminata.CodStatoWorkflowIncaricoDestinazione = [@StatiTerminaliSLA].CodStatoWorkflowFine
					WHERE [@StatiTerminaliSLA].Fase = [@SetupWorkflowSLA].Fase
					AND Fase NOT LIKE 'fase 3%' AND Fase NOT LIKE 'fase 6%'
					AND lwiTerminata.IdIncarico = M1.IdIncarico
					
	) FaseTerminata
	WHERE m1.DataTransizione >= @DataTransizioneDAL AND m1.DataTransizione < @DataTransizioneALEscluso
	AND (
			([@SetupWorkflowSLA].fase LIKE 'Fase 3%' AND [@SetupWorkflowSLA].CodTipoIncarico = 54)
		  OR([@SetupWorkflowSLA].Fase NOT LIKE 'Fase 3%' )
	)	


    END
	ELSE
	BEGIN
         
	/* FASI DEL MASTER */
	;WITH M1 AS (
		SELECT DISTINCT
		ti1.IdIncarico
		,ti1.DataCreazione
		,ti1.CodCliente
		,ti1.CodTipoIncarico
		,ti1.CodStatoWorkflowIncarico CodStatoAttuale
		,lwi1.IdTransizione
		,lwi1.DataTransizione
		,lwi1.CodStatoWorkflowIncaricoPartenza
		,lwi1.CodStatoWorkflowIncaricoDestinazione
		,MAX(lwi1.IdTransizione) OVER (PARTITION BY lwi1.IdIncarico) MaxIdTransizione
		,MAX(lwi1.DataTransizione) OVER (PARTITION BY lwi1.IdIncarico) MaxDataTransizione
		,LAG(lwi1.DataTransizione,1) OVER (PARTITION BY lwi1.IdIncarico ORDER BY lwi1.IdTransizione ASC ) DataTransizionePrecedente
		
		FROM T_Incarico ti1
		JOIN L_WorkflowIncarico lwi1 ON ti1.IdIncarico = lwi1.IdIncarico
		--AND lwi1.DataTransizione >= '20210920'
		WHERE ti1.IdIncarico = @idincarico
		AND ti1.DataCreazione >= '20210920'

	), WfDocConclusa AS (
					SELECT lwi_DocConclusa.IdTransizione IdTransizioneDocConclusa, lwi_DocConclusa.IdIncarico, lwi_DocConclusa.DataTransizione DataTransizioneDocConclusa
					,ROW_NUMBER() OVER (PARTITION BY lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_DocConclusa.DataTransizione ASC ) ProgressivoFase
					,ISNULL(LAG(lwi_DocConclusa.DataTransizione,1) OVER (PARTITION BY lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_DocConclusa.IdTransizione ASC ), M1.DataCreazione) AS DataTransizioneConclusaPrecedente 
		
					
					FROM L_WorkflowIncarico lwi_DocConclusa
					JOIN m1 ON lwi_DocConclusa.IdIncarico = M1.IdIncarico
					AND lwi_DocConclusa.IdTransizione = M1.IdTransizione
			
					WHERE lwi_DocConclusa.CodStatoWorkflowIncaricoPartenza != lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione
					AND lwi_DocConclusa.CodStatoWorkflowIncaricoDestinazione = 21330
					--ORDER BY lwi_DocConclusa.DataTransizione ASC

	), WfFaseIntegrazioni AS (
					SELECT IdIncarico
					,IdTransizioneDocConclusa
							,DataTransizioneDocConclusa
						  ,ProgressivoFase
						  ,DataTransizioneConclusaPrecedente
						  ,wfIntegrazioniRicevute.DataTransizione DataTransizioneIntegrazioniRicevute
					FROM WfDocConclusa
					CROSS APPLY (
								SELECT TOP 1 lwi_IntegrazioniRicevute.IdTransizione, lwi_IntegrazioniRicevute.DataTransizione
								FROM L_WorkflowIncarico lwi_IntegrazioniRicevute
								WHERE WfDocConclusa.IdIncarico = lwi_IntegrazioniRicevute.IdIncarico
								AND lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoPartenza != lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoDestinazione
								AND lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoDestinazione = 15546
								AND lwi_IntegrazioniRicevute.DataTransizione < WfDocConclusa.DataTransizioneDocConclusa
								AND lwi_IntegrazioniRicevute.DataTransizione >= WfDocConclusa.DataTransizioneConclusaPrecedente
						 
							) wfIntegrazioniRicevute
	)
	INSERT INTO @Base_SLA (IdIncaricoMaster, IdIncaricoFase, CodTipoIncarico, CodStatoAttuale, Fase, DataTransizione, M1.DataTransizionePrecedente, codstatoworkflowincaricodestinazione, GiorniIntervallo, GiorniPermanenza)
	SELECT DISTINCT M1.IdIncarico, M1.IdIncarico, m1.CodTipoIncarico, m1.CodStatoAttuale
	, CASE WHEN Fase = 'Fase 3 (Verifica Integrazioni)'  THEN Fase + ' [' + ISNULL(CAST(WfFaseIntegrazioni.ProgressivoFase AS VARCHAR(4)),'0') + ']'
		WHEN FaseTerminata.IdTransizione IS NOT NULL AND M1.DataTransizione > FaseTerminata.DataTransizione THEN 'CHECK'
		ELSE Fase
		END AS Fase

	, m1.DataTransizione, DataTransizionePrecedente
	,M1.CodStatoWorkflowIncaricoDestinazione
	,rs.IntervalloLavorativoGiorni(m1.DataTransizionePrecedente,M1.DataTransizione) as GiorniIntervallo
	, CASE WHEN M1.IdTransizione = m1.MaxIdTransizione 
		THEN  rs.IntervalloLavorativoGiorni(m1.MaxDataTransizione,GETDATE()) 
		ELSE 0 END AS GiorniPermanenza
	FROM M1
	JOIN @SetupWorkflowSLA ON M1.CodCliente = [@SetupWorkflowSLA].CodCliente
	AND M1.CodTipoIncarico = [@SetupWorkflowSLA].CodTipoIncarico
	AND ( 
		  (	
			M1.CodStatoWorkflowIncaricoPartenza = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoPartenza
		   AND M1.CodStatoWorkflowIncaricoDestinazione = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoDestinazione
		  )
		  OR ( m1.CodStatoWorkflowIncaricoPartenza IS NULL AND m1.CodStatoWorkflowIncaricoDestinazione = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoDestinazione)
		)
	
	LEFT JOIN WfFaseIntegrazioni ON M1.IdIncarico = WfFaseIntegrazioni.IdIncarico
	AND m1.DataTransizione <= WfFaseIntegrazioni.DataTransizioneDocConclusa
	AND m1.DataTransizione >= WfFaseIntegrazioni.DataTransizioneIntegrazioniRicevute

	OUTER APPLY (
					SELECT TOP 1 lwiTerminata.IdTransizione, lwiTerminata.DataTransizione
                    FROM L_WorkflowIncarico lwiTerminata
					JOIN @StatiTerminaliSLA ON lwiTerminata.CodStatoWorkflowIncaricoPartenza != lwiTerminata.CodStatoWorkflowIncaricoDestinazione
											AND lwiTerminata.CodStatoWorkflowIncaricoDestinazione = [@StatiTerminaliSLA].CodStatoWorkflowFine
					WHERE [@StatiTerminaliSLA].Fase = [@SetupWorkflowSLA].Fase
					AND Fase NOT LIKE 'fase 3%' AND Fase NOT LIKE 'fase 6%'
					AND lwiTerminata.IdIncarico = M1.IdIncarico
					
	) FaseTerminata

	WHERE m1.DataTransizione >= @DataTransizioneDAL AND m1.DataTransizione < @DataTransizioneALEscluso
	
	/* FASI DEL SUB */

	;WITH M2 AS (
		SELECT DISTINCT
		tris.IdIncarico IdIncaricoMaster
		,sub.IdIncarico IdIncaricoFase
		,sub.CodCliente
		,sub.CodTipoIncarico 
		,sub.CodStatoWorkflowIncarico CodStatoAttuale
		,sub.DataCreazione
		,lwi2.IdTransizione
		,lwi2.DataTransizione
		,lwi2.CodStatoWorkflowIncaricoPartenza
		,lwi2.CodStatoWorkflowIncaricoDestinazione
		,MAX(lwi2.IdTransizione) OVER (PARTITION BY lwi2.IdIncarico) MaxIdTransizione
		,MAX(lwi2.DataTransizione) OVER (PARTITION BY lwi2.IdIncarico) MaxDataTransizione
		,LAG(lwi2.DataTransizione,1) OVER (PARTITION BY lwi2.IdIncarico ORDER BY lwi2.IdTransizione ASC ) DataTransizionePrecedente
		
		FROM T_R_Incarico_Subincarico tris
		JOIN T_Incarico sub ON sub.IdIncarico = tris.IdSubIncarico
		JOIN L_WorkflowIncarico lwi2 ON sub.IdIncarico = lwi2.IdIncarico
		--AND lwi2.DataTransizione >= '20210920'
		WHERE tris.IdIncarico = @idincarico
		AND sub.datacreazione >= '20210920'
		AND sub.CodTipoIncarico IN (151	--Successioni - Sicav
									,164	--Successioni - Polizze Azimut Life
									,165	--Successioni - Fondi di Investimento
									,166	--Successioni - Polizze Compagnie Terze
									,175	--Successioni - Previdenza
									,184	--Successioni - Gestioni Individuali
									,185	--Successioni - Raccolta Ordini
									,193	--Successioni - Banco Popolare
									,351	--Successioni AFB
									,659	--AZISF - Successioni - Previdenza
									,783	--Successioni - Fondi Chiusi
									)
		AND sub.codstatoworkflowincarico NOT IN (440	 --Caricamento Errato
												 ,6505	 --De Cuius non cliente
												 ,22582	 --Segnalazione Errata
												)

	), WfDocConclusa2 AS (
					SELECT lwi_DocConclusa2.IdTransizione IdTransizioneDocConclusa, lwi_DocConclusa2.IdIncarico, lwi_DocConclusa2.DataTransizione DataTransizioneDocConclusa
					,ROW_NUMBER() OVER (PARTITION BY lwi_DocConclusa2.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_DocConclusa2.DataTransizione ASC ) ProgressivoFase
					,ISNULL(LAG(lwi_DocConclusa2.DataTransizione,1) OVER (PARTITION BY lwi_DocConclusa2.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_DocConclusa2.IdTransizione ASC ), M2.DataCreazione) AS DataTransizioneConclusaPrecedente 
		
					
					FROM L_WorkflowIncarico lwi_DocConclusa2
					JOIN m2 ON lwi_DocConclusa2.IdIncarico = M2.IdIncaricoFase
					AND lwi_DocConclusa2.IdTransizione = M2.IdTransizione
			
					WHERE lwi_DocConclusa2.CodStatoWorkflowIncaricoPartenza != lwi_DocConclusa2.CodStatoWorkflowIncaricoDestinazione
					AND lwi_DocConclusa2.CodStatoWorkflowIncaricoDestinazione = 21330
	

	), WfFaseIntegrazioni2 AS (
					SELECT IdIncarico
					,IdTransizioneDocConclusa
							,DataTransizioneDocConclusa
						  ,ProgressivoFase
						  ,DataTransizioneConclusaPrecedente
						  ,wfIntegrazioniRicevute.DataTransizione DataTransizioneIntegrazioniRicevute
					FROM WfDocConclusa2
					CROSS APPLY (
								SELECT TOP 1 lwi_IntegrazioniRicevute.IdTransizione, lwi_IntegrazioniRicevute.DataTransizione
								FROM L_WorkflowIncarico lwi_IntegrazioniRicevute
								WHERE WfDocConclusa2.IdIncarico = lwi_IntegrazioniRicevute.IdIncarico
								AND lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoPartenza != lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoDestinazione
								AND lwi_IntegrazioniRicevute.CodStatoWorkflowIncaricoDestinazione = 15546
								AND lwi_IntegrazioniRicevute.DataTransizione < WfDocConclusa2.DataTransizioneDocConclusa
								AND lwi_IntegrazioniRicevute.DataTransizione >= WfDocConclusa2.DataTransizioneConclusaPrecedente
						
							) wfIntegrazioniRicevute
	), wfLiquidata AS (
					SELECT lwi_Liquidata.IdTransizione IdTransizioneLiquidata, lwi_Liquidata.IdIncarico, lwi_Liquidata.DataTransizione DataTransizioneLiquidata
					,ROW_NUMBER() OVER (PARTITION BY lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_Liquidata.DataTransizione ASC ) ProgressivoFase
					,ISNULL(LAG(lwi_Liquidata.DataTransizione,1) OVER (PARTITION BY lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione ORDER BY lwi_Liquidata.IdTransizione ASC ), M2.DataCreazione) AS DataTransizioneLiquidataPrecedente 
		
					FROM L_WorkflowIncarico lwi_Liquidata
					JOIN m2 ON lwi_Liquidata.IdIncarico = M2.IdIncaricoFase
					AND lwi_Liquidata.IdTransizione = M2.IdTransizione
					JOIN @StatiTerminaliSLA ON m2.codcliente = [@StatiTerminaliSLA].CodCliente
					AND m2.codtipoincarico = [@StatiTerminaliSLA].CodTipoIncarico
					AND [@StatiTerminaliSLA].Fase = 'Fase 6 (Liquidazione)'
					WHERE lwi_Liquidata.CodStatoWorkflowIncaricoPartenza != lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione
					AND (lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione = [@StatiTerminaliSLA].CodStatoWorkflowFine
							--OR lwi_Liquidata.CodStatoWorkflowIncaricoDestinazione = 820
						)

		),wfLiquidazione AS (
					SELECT IdIncarico
					,IdTransizioneLiquidata
							,DataTransizioneLiquidata
						  ,ProgressivoFase
						  ,DataTransizioneLiquidataPrecedente
						  ,wfInizioLiquidazione.DataTransizione DataTransizioneInizioLiquidazione
					FROM wfLiquidata
					CROSS APPLY (
								SELECT TOP 1 lwi_InizioLiquidazione.IdTransizione, lwi_InizioLiquidazione.DataTransizione
								FROM L_WorkflowIncarico lwi_InizioLiquidazione
								JOIN T_Incarico tix2 ON lwi_InizioLiquidazione.IdIncarico = tix2.IdIncarico
								JOIN @StatiTerminaliSLA ON tix2.CodCliente = [@StatiTerminaliSLA].CodCliente
								AND tix2.CodTipoIncarico = [@StatiTerminaliSLA].CodTipoIncarico
								AND Fase =  'Fase 6 (Liquidazione)'
								WHERE wfLiquidata.IdIncarico = lwi_InizioLiquidazione.IdIncarico
								AND lwi_InizioLiquidazione.CodStatoWorkflowIncaricoPartenza != lwi_InizioLiquidazione.CodStatoWorkflowIncaricoDestinazione
								AND lwi_InizioLiquidazione.CodStatoWorkflowIncaricoDestinazione = CodStatoWorkflowInizio
								AND lwi_InizioLiquidazione.DataTransizione < wfLiquidata.DataTransizioneLiquidata
								AND lwi_InizioLiquidazione.DataTransizione >= wfLiquidata.DataTransizioneLiquidataPrecedente
						
							) wfInizioLiquidazione
	)
	INSERT INTO @Base_SLA (IdIncaricoMaster, IdIncaricoFase, CodTipoIncarico, CodStatoAttuale, Fase, DataTransizione, datatransizioneprecedente, CodStatoWorkflowIncaricoDestinazione, GiorniIntervallo, GiorniPermanenza)
	SELECT IdIncaricoMaster, IdIncaricoFase, M2.CodTipoIncarico, CodStatoAttuale
	, CASE WHEN Fase = 'Fase 3 (Verifica Integrazioni)'  THEN Fase + ' [' + CAST(ISNULL(WfFaseIntegrazioni2.ProgressivoFase,'0') AS VARCHAR(4)) + ']'
		WHEN FASE = 'Fase 6 (Liquidazione)' THEN FASE + ' [' + CAST(ISNULL(wfLiquidazione.ProgressivoFase,'0') AS VARCHAR(4)) + ']'
		WHEN FaseTerminata.IdTransizione IS NOT NULL AND m2.DataTransizione > FaseTerminata.DataTransizione THEN 'CHECK'
		WHEN (fase LIKE 'Fase 4%' OR fase like 'fase 5%') AND (tda.Testo IS NULL OR tda.Testo != 'SI') AND M2.CodTipoIncarico IN (164,175,166,659) THEN 'CHECK'
		ELSE Fase
		END AS Fase

	,m2.DataTransizione, DataTransizionePrecedente
	,M2.CodStatoWorkflowIncaricoDestinazione
	,rs.IntervalloLavorativoGiorni(m2.DataTransizionePrecedente,M2.DataTransizione) GiorniIntervallo
	,CASE WHEN m2.IdTransizione = m2.MaxIdTransizione 
		THEN rs.IntervalloLavorativoGiorni(m2.MaxDataTransizione,GETDATE()) 
		ELSE 0
		END AS GiorniPermanenza
	FROM m2
	JOIN @SetupWorkflowSLA ON M2.CodCliente = [@SetupWorkflowSLA].CodCliente
	AND M2.CodTipoIncarico = [@SetupWorkflowSLA].CodTipoIncarico
	AND ( 
		  (	
			M2.CodStatoWorkflowIncaricoPartenza = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoPartenza
		   AND M2.CodStatoWorkflowIncaricoDestinazione = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoDestinazione
		  )
		  OR ( m2.CodStatoWorkflowIncaricoPartenza IS NULL AND m2.CodStatoWorkflowIncaricoDestinazione = [@SetupWorkflowSLA].CodStatoWorkflowIncaricoDestinazione)
		)

	LEFT JOIN WfFaseIntegrazioni2 ON M2.IdIncaricoFase = WfFaseIntegrazioni2.IdIncarico
	AND m2.DataTransizione >= WfFaseIntegrazioni2.DataTransizioneIntegrazioniRicevute
	AND m2.DataTransizione <= WfFaseIntegrazioni2.DataTransizioneDocConclusa

	LEFT JOIN wfLiquidazione ON M2.IdIncaricoFase = wfLiquidazione.IdIncarico
	AND M2.DataTransizione >= wfLiquidazione.DataTransizioneInizioLiquidazione
	AND M2.DataTransizione <= wfLiquidazione.DataTransizioneLiquidata
	
	LEFT JOIN T_DatoAggiuntivo tda ON m2.IdIncaricoFase = tda.IdIncarico
	AND tda.FlagAttivo = 1
	AND tda.CodTipoDatoAggiuntivo = 2424 --Lettera Valorizzazione prevista
	
	OUTER APPLY (
					SELECT TOP 1 lwiTerminata.IdTransizione, lwiTerminata.DataTransizione
                    FROM L_WorkflowIncarico lwiTerminata
					JOIN @StatiTerminaliSLA ON lwiTerminata.CodStatoWorkflowIncaricoPartenza != lwiTerminata.CodStatoWorkflowIncaricoDestinazione
											AND lwiTerminata.CodStatoWorkflowIncaricoDestinazione = [@StatiTerminaliSLA].CodStatoWorkflowFine
					WHERE [@StatiTerminaliSLA].Fase = [@SetupWorkflowSLA].Fase
					AND Fase NOT LIKE 'fase 3%' AND Fase NOT LIKE 'fase 6%'
					AND lwiTerminata.IdIncarico = M2.IdIncaricoFase
					
	) FaseTerminata
	WHERE m2.DataTransizione >= @DataTransizioneDAL AND m2.DataTransizione < @DataTransizioneALEscluso
	AND (
				([@SetupWorkflowSLA].CodTipoIncarico = 54 AND [@SetupWorkflowSLA].FASE IN ('Fase 1 (Blocco Posizione)','Fase 2 (Verifica Primo Pack)') AND DataCreazione >= '20210920')
				OR ([@SetupWorkflowSLA].CodTipoIncarico = 54 AND [@SetupWorkflowSLA].FASE LIKE 'FASE 3%')
				OR ([@SetupWorkflowSLA].CodTipoIncarico !=54 
					 AND ([@SetupWorkflowSLA].FASE NOT IN ('Fase 1 (Blocco Posizione)','Fase 2 (Verifica Primo Pack)') 
					 and [@SetupWorkflowSLA].FASE NOT LIKE 'FASE 3%')
				   )
	)

	
	END

	/************ INSERT FINALE *********************/

	;WITH finale AS (
	SELECT IdIncaricoMaster, IdIncaricoFase,ti.codcliente, ti.CodTipoIncarico,ti.DataCreazione,ti.DataUltimaTransizione
	,ti.CodStatoWorkflowIncarico,d.TipoIncarico,d.StatoWorkflowIncarico, Fase
	,MIN(DataTransizionePrecedente) DataInizioLavorazione
	--,CASE WHEN FaseTerminata.FlagTerminato = 1 then MAX(DataTransizione) END DataFineLavorazione
	,MAX(datatransizione) DataFineLavorazione
	
	,SUM(GiorniIntervallo) + SUM(CASE WHEN wfSLA.Codice IS NOT NULL and CodStatoAttuale != 820 THEN GiorniPermanenza ELSE 0 END )
	
	AS GiorniTrascorsi
	,CASE  
		when Fase = 'Fase 1 (Blocco Posizione)' THEN 1
		when Fase = 'Fase 2 (Verifica Primo Pack)' THEN 2
		when Fase LIKE 'Fase 3 (Verifica Integrazioni)%' THEN 3
		WHEN fase = 'Fase 4 (Invio Lettera Valorizzazione Fondi Casa)' THEN 5
		WHEN fase = 'Fase 5 (Invio Richiesta Info Prodotti Terze Parti)' THEN 3
		WHEN fase = 'Fase 5.1 (Invio Lettera Valorizzazione Terze Parti)' THEN 4
		WHEN fase like 'Fase 6%' THEN 4

	 END AS GiorniSoglia

	
	FROM @Base_SLA
	JOIN T_Incarico ti ON [@Base_SLA].IdIncaricoFase = ti.IdIncarico
	JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
	OUTER APPLY (SELECT TOP 1 w.CodStatoWorkflowIncaricoPartenza Codice
					FROM @SetupWorkflowSLA w
				WHERE w.CodCliente = ti.codcliente 
				AND w.CodTipoIncarico = ti.codtipoincarico 
				AND w.Fase = [@Base_SLA].Fase 
				AND w.CodStatoWorkflowIncaricoPartenza = CodStatoAttuale
				) wfSLA


	WHERE Fase != 'CHECK'
	GROUP BY  IdIncaricoMaster, IdIncaricoFase,ti.codcliente, ti.CodTipoIncarico,ti.DataCreazione,ti.DataUltimaTransizione
	,ti.CodStatoWorkflowIncarico,d.TipoIncarico,d.StatoWorkflowIncarico, Fase
	)

		INSERT INTO @SLA_Incarico (IdIncaricoMaster, IdIncaricoFase,CodClienteFase, CodTipoIncaricoFase, DataCreazioneIncaricoFase, DataUltimaTransizioneIncaricoFase
	, CodStatoWorkflowIncaricoFase, TipoIncaricoFase, StatoWorkflowIncaricoFase, Fase
	, DataInizioLavorazione, DataFineLavorazione
	,  GiorniLavorativiTrascorsi,GiorniLavorativiSoglia, EsitoSLA, ISFaseTerminata)
	SELECT IdIncaricoMaster
		  ,IdIncaricoFase
		  ,CodCliente
		  ,CodTipoIncarico
		  ,DataCreazione
		  ,DataUltimaTransizione
		  ,CodStatoWorkflowIncarico
		  ,TipoIncarico
		  ,StatoWorkflowIncarico
		  ,Fase
		  ,DataInizioLavorazione
		  ,CASE WHEN TermineSLA.CodStatoWorkflowFine IS NOT NULL then DataFineLavorazione END AS DataFineLavorazione
		  ,CASE WHEN GiorniTrascorsi = 0 AND TermineSLA.CodStatoWorkflowFine IS NOT NULL THEN 1 ELSE GiorniTrascorsi END GiorniTrascorsi
		  ,GiorniSoglia
		  ,CASE WHEN  GiorniTrascorsi <= GiorniSoglia THEN 'SLA OK'	
			when fase = 'Lavorazione Esterna' THEN 'NO SLA'
			ELSE 'SLA KO'
			END Esito
		  ,CASE WHEN TermineSLA.CodStatoWorkflowFine IS NOT NULL THEN 1 ELSE 0 END AS IsFaseTerminata
	FROM finale
	outer APPLY (
					SELECT TOP 1 ISNULL(CodStatoWorkflowFine,820) CodStatoWorkflowFine
                    FROM @Base_SLA
					JOIN @StatiTerminaliSLA ON CodCliente = 23
					AND [@Base_SLA].CodTipoIncarico = [@StatiTerminaliSLA].CodTipoIncarico
					AND ([@Base_SLA].Fase = [@StatiTerminaliSLA].Fase OR ([@Base_SLA].Fase LIKE 'fase 3%' AND [@StatiTerminaliSLA].Fase LIKE 'fase 3%') 
																	  or ([@Base_SLA].Fase LIKE 'fase 6%' AND [@StatiTerminaliSLA].Fase LIKE 'fase 6%') 
																		)
					AND [@Base_SLA].Fase NOT LIKE '%[0]%'
					WHERE IdIncaricoMaster = finale.idincaricomaster
					AND IdIncaricoFase = finale.idincaricofase
					AND (finale.Fase= [@Base_SLA].Fase OR ([@Base_SLA].fase LIKE 'fase 3%' AND finale.Fase LIKE 'fase 3%')
													   OR ([@Base_SLA].Fase LIKE 'fase 6%' AND finale.Fase LIKE 'fase 6%') 
														  )
					AND finale.Fase NOT LIKE '%[0]%'
					AND (CodStatoWorkflowIncaricoDestinazione = CodStatoWorkflowFine OR CodStatoWorkflowIncaricoDestinazione = 820)
	) TermineSLA

	/***********************************************************************/

	IF EXISTS (SELECT * FROM  @SLA_Incarico WHERE EsitoSLA = 'SLA KO' AND ISFaseTerminata = 1)
	BEGIN
    	UPDATE @SLA_Incarico
		SET EsitoSLAIncaricoMaster = 'SLA KO'
    END
	ELSE 
	BEGIN
    	UPDATE @SLA_Incarico
		SET EsitoSLAIncaricoMaster = 'SLA OK'
    END


	/**** decommentare per fare test *****/

	SELECT * FROM @Base_SLA
	SELECT * FROM @SLA_Incarico

	/*************************************/

	--RETURN --commentare per fare test

END


--SELECT * FROM R_TransizioneIncarico_GenerazioneDocumento

GO 


