USE clc
GO


--ALTER PROCEDURE rs.CESAM_AZ_EliminaDoppioniDossier 
--(@DataFiltro DATETIME
--,@DataOrigine DATETIME
--)

--AS

/*
Author: L. Fiori
Elimina persone censite 2 o più volte

Eventuali residui sono gestibili manualmente consultando il primo foglio del report AZ - Incarichi con dossier NON popolati correttamente
Decommentare sotto in caso di test della SP
*/

/* ================================================== */
--DECLARE @DataOrigine DATETIME
--		,@IdRiga INT 

--SET @DataOrigine = '2017-01-01'

--SET @IdRiga = 9799187 --prod

--			--4424683 
--			--4424682 --preprod
/* ================================================== */

BEGIN


	--Dichiarazione Parametri di controllo per eliminazione doppioni
	DECLARE	@IdIncarico INT
			,@CodTipoIncarico INT
			,@IdDossier INT
			,@IdPersona INT
			,@CodRuoloRichiedente1 INT
			,@CodRuoloRichiedenteRipetuto INT
			

	--IF OBJECT_ID(N'tempdb.#listaincarichi', N'U') IS NOT NULL
	--BEGIN
	--	DROP TABLE #listaincarichi
	--END

	--CREATE TABLE #listaincarichi (
	--	IdIncarico INT,
	--	caso VARCHAR(200)
	--)

	DECLARE cur CURSOR FOR
	SELECT
		IdIncarico,
		CodTipoIncarico,
		IdDossier,
		IdPersonaRipetuta,
		CodRuoloRichiedente1,
		CodRuoloRichiedenteRipetuto
	FROM [rs].[v_CESAM_AZ_PersonaRipetutaNelDossier]
	WHERE DataCreazione >= @DataOrigine
	--idincarico = @IdRiga



	OPEN cur
	FETCH NEXT FROM cur INTO @IdIncarico, @CodTipoIncarico, @IdDossier, @IdPersona, @CodRuoloRichiedente1, @CodRuoloRichiedenteRipetuto
	WHILE @@fetch_status = 0

	BEGIN
		--stesso dossier, stess persona, stesso codice ruolo richiedente (doppioni)
		IF @CodRuoloRichiedente1 = @CodRuoloRichiedenteRipetuto
		BEGIN
			DELETE FROM T_R_Dossier_Persona
			where IdDossier = @IdDossier AND IdPersona = @IdPersona 
			AND Progressivo <> 1

			--INSERT INTO #listaincarichi (IdIncarico, caso)
			--	SELECT
			--		@IdIncarico,
			--		'Dossier con doppioni ' + 'IdDossier ' + CAST(@IdDossier AS VARCHAR(15))
		END


		--stesso dossier, stessa persona ruoli richiedente diversi (solo un ruolo è giusto)

		--Il tipo incarico presuppone che il ruolo giusto è Intestatario
		IF @CodTipoIncarico IN (83		--Sottoscrizioni/Versamenti FONDI Investimento
			, 100	--Sottoscrizioni/Versamenti SICAV
			, 352	--Versamenti FONDI Investimento
			, 85		--Rimborso FONDI Investimento
			, 321	--Sottoscrizioni AFB
			, 322	--Versamenti Aggiuntivi AFB
			, 323	--Rimborsi AFB
			, 324	--Switch AFB
			, 343	--Incremento/Decremento
			, 84	--Switch FONDI Investimento
	
			)
		BEGIN
			IF @CodRuoloRichiedente1 = 33 --Persona censita per prima come Intestatario
			BEGIN
				DELETE FROM T_R_Dossier_Persona
				WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona 
				AND Progressivo <> 1

				--INSERT INTO #listaincarichi (IdIncarico, caso)
				--	SELECT
				--		@IdIncarico,
				--		'Dossier caso 1 (rimasto primo intestatario) ' + 'IdDossier ' + CAST(@IdDossier AS VARCHAR(15))

			END

			ELSE
			IF @CodRuoloRichiedenteRipetuto = 33 --Persona censita (non per prima) come Intestatario
			BEGIN
				DELETE FROM T_R_Dossier_Persona
				WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona
				and Progressivo < (SELECT max(Progressivo) FROM T_R_Dossier_Persona 
									WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona)	

				IF (SELECT	Progressivo FROM T_R_Dossier_Persona WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona) > 1 
					begin
					UPDATE T_R_Dossier_Persona
					SET Progressivo = 1
					where IdDossier = @IdDossier AND IdPersona = @IdPersona 
					END 

				--INSERT INTO #listaincarichi (IdIncarico, caso)
				--	SELECT
				--		@IdIncarico,
				--		'Dossier caso 2 (rimasto l''ultimo intestatario) ' + 'IdDossier ' + CAST(@IdDossier AS VARCHAR(15))
			END
		END

		FETCH NEXT FROM cur INTO @IdIncarico, @CodTipoIncarico, @IdDossier, @IdPersona, @CodRuoloRichiedente1, @CodRuoloRichiedenteRipetuto
	END

	CLOSE cur
	DEALLOCATE cur

	--SELECT
	--	*
	--FROM #listaincarichi
	--DROP TABLE #listaincarichi




SELECT  IdIncarico
		,IdDossier
		,NumeroDossier
		,IdPersonaRipetuta
		,ChiaveClientePersona
		,Persona
		,CodRuoloRichiedente1
		,DescrizioneRuolo1
		,CodRuoloRichiedenteRipetuto
		,DescrizioneRuoloRipetuto
		,DataCreazione
FROM [rs].[v_CESAM_AZ_PersonaRipetutaNelDossier]

where DataCreazione >= @DataFiltro

END

GO