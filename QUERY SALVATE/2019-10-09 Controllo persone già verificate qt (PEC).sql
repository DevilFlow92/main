USE CLC
GO

--CREATE PROCEDURE controlli.CESAM_AZ_Antiriciclaggio_CheckSegnalazioniPEC (@idriga INT) AS 

--DECLARE @idriga INT = 4427061 

DECLARE	@RES_CodGiudizioControllo INT
		,@RED_Note AS NVARCHAR(2000)
		,@RED_CodEsitoControllo VARCHAR(5)


DECLARE @Esito INT
DECLARE @Note VARCHAR(MAX)
SET @RES_CodGiudizioControllo = 1	--N/D
SET @RED_Note = ''

BEGIN TRY

DECLARE @IdIncarico INT

SET @IdIncarico = @idriga

IF OBJECT_ID('tempdb.dbo.#list') IS NOT NULL
	DROP TABLE #list




SELECT ti2.IdIncarico, D_TipoIncarico.Descrizione
INTO #list
 FROM T_Incarico ti
				JOIN T_R_Incarico_Persona trip ON ti.IdIncarico = trip.IdIncarico
				JOIN T_R_Incarico_Persona trip2 ON trip.IdPersona = trip2.IdPersona
				JOIN T_Incarico ti2 ON trip2.IdIncarico = ti2.IdIncarico
				JOIN D_TipoIncarico ON ti2.CodTipoIncarico = D_TipoIncarico.Codice
				WHERE ti.IdIncarico = @IdIncarico

				AND ti.CodCliente = ti2.CodCliente
				AND ti.CodArea = ti2.CodArea
							
				AND ti2.CodTipoIncarico IN (522,549)
				AND ti2.IdIncarico <> @IdIncarico
				AND ti2.CodStatoWorkflowIncarico <> 440

IF NOT EXISTS (SELECT * FROM #list)
BEGIN
	SET @RED_Note = 'Nessun altro incarico di Segnalazione PEC / EDD associato alla persona'
END
ELSE 
BEGIN
	SET @RES_CodGiudizioControllo = 2
	SET @RED_Note = 'Trovati i seguenti incarichi associati alla persona:' + CHAR(13)

	DECLARE @IdIncaricoFound INT
		,@TipoIncarico VARCHAR(200)
    
    DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
    	SELECT * FROM #list

    OPEN cur
    
    FETCH NEXT FROM cur INTO @IdIncaricoFound, @TipoIncarico
    
    WHILE @@FETCH_STATUS = 0 BEGIN
    
    	SET @RED_Note = @RED_Note + CAST(@IdIncaricoFound AS VARCHAR(50)) + ' ' + @TipoIncarico + CHAR(10)
    
    	FETCH NEXT FROM cur INTO @IdIncaricoFound, @TipoIncarico
    
    END
    
    CLOSE cur
    DEALLOCATE cur
END

DROP TABLE #list

SELECT
	@RES_CodGiudizioControllo AS CodGiudizioControllo
	,@RED_CodEsitoControllo AS CodEsitoControllo
	,@RED_Note AS Note

END TRY 

BEGIN CATCH
DROP TABLE #list
SET @RED_Note = 'Errore: inviare ad ORGA una segnalazione'
SELECT
	@RES_CodGiudizioControllo AS CodGiudizioControllo
	,@RED_CodEsitoControllo AS CodEsitoControllo
	,@RED_Note AS Note

END CATCH

GO
