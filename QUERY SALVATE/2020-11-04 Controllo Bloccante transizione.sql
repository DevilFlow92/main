USE clc
GO


/*
Authors: Fiori L.
Description: restituisce un esito ko se non sono trascorsi due giorni dalla data di creazione incarico.
Esigenza: bloccare la transizione verso lo stato In Gestione - Da Censire Movimento se non siamo a t+2

*/
create PROCEDURE controlli.CESAM_AZ_CheckMovimentoDaCensire (@IdRiga INT)
AS


--DECLARE @idriga INT
--SET @idriga = 16246315   

BEGIN TRY


	DECLARE	@RES_CodGiudizioControllo INT
			,@RED_Note AS NVARCHAR(255)
			,@RED_CodEsitoControllo VARCHAR(5)


	SET @RES_CodGiudizioControllo = 4 --KO di default
	SET @RED_Note = ''

	DECLARE @IdIncarico INT
	SET @IdIncarico = @IdRiga


	--TRA I DUE SEPARATORI INSERIRE I COMANDI DELLA SP
	--===========================================================================================================

	--dichiaro le variabili utilizzate all'interno della sp
	DECLARE @t AS DATE 
	,@giorni AS TINYINT
	

	SELECT @t = CONVERT(DATE,DataCreazione)
	,@giorni = CASE WHEN DATEPART(HOUR,DataCreazione) < 10 THEN 1 ELSE 2 END 
	
	FROM T_Incarico
	WHERE IdIncarico = @IdIncarico

	--SELECT format(@t,'dd/MM'), @giorni

	IF DATEADD(DAY,@giorni,@t) > CONVERT(DATE,GETDATE() )
	BEGIN  
	SET @RED_Note = 'Non sono ancora passati due giorni dalla data di creazione incarico. Il giorno risulta essere il '+ FORMAT(DATEADD(DAY,@giorni,@t),'dd/MM')
    	
    END
	ELSE
	BEGIN
    	SET @RES_CodGiudizioControllo = 2 --OK
		SET @RED_Note = 'OK, si può transitare nello stato In Gestione - Da Censire Movimento'
    END
    


	SELECT
		@RES_CodGiudizioControllo AS CodGiudizioControllo
		,@RED_CodEsitoControllo AS CodEsitoControllo
		,@RED_Note AS Note


END TRY

BEGIN CATCH
	PRINT 'Errore: inviare ad ORGA una segnalazione'
END CATCH


GO