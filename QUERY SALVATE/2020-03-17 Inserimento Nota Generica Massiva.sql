USE CLC
GO


--ALTER PROCEDURE orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA
--AS

DECLARE @IncaricoEsempio INT = 14512476 

--SELECT * FROM T_NotaIncarichi
--JOIN T_R_Incarico_Nota ON T_NotaIncarichi.IdNotaIncarichi = T_R_Incarico_Nota.IdNota
--WHERE IdIncarico = 14512476 

	--EXEC orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA

	BEGIN TRANSACTION

	DECLARE	@IdIncarico INT
				,@IdNota INT

		DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR SELECT
			IdIncarico
		FROM T_Incarico
		WHERE IdIncarico IN (
		/*INSERIRE QUI GLI INCARICHI DOVE INSERIRE LA NOTA GENERICA*/
		)

		OPEN cur

		FETCH NEXT FROM cur INTO @IdIncarico

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @IdNota = NULL

			INSERT INTO T_NotaIncarichi (CodTipoNotaIncarichi, DataInserimento, IdOperatore, Testo)
				SELECT
					CodTipoNotaIncarichi
					,GETDATE()
					,IdOperatore
					,Testo 
				FROM T_NotaIncarichi
				JOIN T_R_Incarico_Nota
					ON T_NotaIncarichi.IdNotaIncarichi = T_R_Incarico_Nota.IdNota
				WHERE IdIncarico = @IncaricoEsempio

			SET @IdNota = (SELECT
				SCOPE_IDENTITY())

			INSERT INTO T_R_Incarico_Nota (IdIncarico, IdNota, FlagAttiva)
				VALUES (@IdIncarico, @IdNota, 1);

			FETCH NEXT FROM cur INTO @IdIncarico

		END

		CLOSE cur
		DEALLOCATE cur


		--COMMIT TRANSACTION
		ROLLBACK TRANSACTION