USE CLC
GO

IF OBJECT_ID('tempdb.dbo.#tmpBloccate') IS NOT NULL
	DROP TABLE #tmpBloccate


CREATE TABLE #tmpBloccate (
	IdIncarico INT PRIMARY KEY
)

INSERT INTO #tmpBloccate (IdIncarico)
	SELECT DISTINCT
		v.IdIncarico
	FROM rs.v_CESAM_AZ_Successioni_RiepiologoBlocchiLavorazioni_v2 v
	UNION
	SELECT DISTINCT
		T_R_Incarico_SubIncarico.IdIncarico
	FROM dbo.T_R_Incarico_SubIncarico
	JOIN rs.v_CESAM_AZ_Successioni_RiepiologoBlocchiLavorazioni_v2 v
		ON v.IdIncarico = IdSubIncarico

SELECT 'Successioni Bloccate: ' + CAST(@@rowcount AS VARCHAR(20))

--BEGIN TRY
--	BEGIN TRANSACTION
	DELETE t
	--SELECT *
	FROM [DB-CLC-SETUPBT].CLC.rs.CESAM_AZ_Successioni_RiepilogoBlocchiLavorazioni_NonBloccate t
	SELECT 'Righe ripulite: ' + CAST(@@rowcount AS VARCHAR(20))

	INSERT INTO [DB-CLC-SETUPBT].CLC.rs.CESAM_AZ_Successioni_RiepilogoBlocchiLavorazioni_NonBloccate (tipo, IdIncarico, TipoIncarico, MacroStatoWorkflowIncarico, StatoWorkflowIncarico, Attesa, DescrizioneAttributo, CentroRaccolta, Area, Promotore, DeCuius, DataCreazione, DataUltimaTransizione, Sim, CodAttributoIncarico)
		SELECT
			v.tipo
		   ,v.IdIncarico
		   ,v.TipoIncarico
		   ,v.MacroStatoWorkflowIncarico
		   ,v.StatoWorkflowIncarico
		   ,v.Attesa
		   ,v.Descrizione
		   ,v.CentroRaccolta
		   ,v.Area
		   ,v.Promotore
		   ,v.DeCuius
		   ,v.DataCreazione
		   ,v.DataUltimaTransizione
		   ,v.Sim
		   ,v.CodAttributoIncarico
		FROM rs.v_CESAM_AZ_Successioni_RiepiologoBlocchiLavorazioni_NonBloccate_ETL v
		LEFT JOIN #tmpBloccate
			ON v.IdIncarico = #tmpBloccate.IdIncarico
		WHERE #tmpBloccate.IdIncarico IS NULL
		
		SELECT 'Righe Reinserite: ' + CAST(@@rowcount AS varchar(20))

--	COMMIT TRANSACTION
--END TRY
--BEGIN CATCH
--	PRINT
--	'Error ' + CONVERT(VARCHAR(50), ERROR_NUMBER()) +
--	', Severity ' + CONVERT(VARCHAR(5), ERROR_SEVERITY()) +
--	', State ' + CONVERT(VARCHAR(5), ERROR_STATE()) +
--	', Line ' + CONVERT(VARCHAR(5), ERROR_LINE())

--	PRINT ERROR_MESSAGE();

--	IF XACT_STATE() <> 0
--	BEGIN
--		ROLLBACK TRANSACTION
--	END
--END CATCH;

DROP TABLE #tmpBloccate


--SELECT * FROM rs.v_CESAM_AZ_Successioni_RiepiologoBlocchiLavorazioni_NonBloccate_ETL
--WHERE IdIncarico = 9979849

