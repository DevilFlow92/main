USE CLC
GO




--input parameters
DECLARE @ora SMALLINT
,@min SMALLINT


/***** Insert here INPUT parameters **********/

SET @ora = 12
SET @min = 49

/*********************************************/

--intermediate parameters
DECLARE @AngoloMin DECIMAL
,@AngoloOra DECIMAL

--output parameters
, @angolo DECIMAL
,@angolo2 as DECIMAL


--CHECK
IF @ora < 0 OR @ora > 23
BEGIN  
	PRINT 'ERRORE: L''ora inserita deve essere compresa tra 0 e 23'
END
ELSE IF @min < 0 OR @min > 59 
BEGIN
	PRINT 'ERRORE: I minuti inseriti devono essere compresi tra 0 e 59'
END
ELSE
BEGIN
	--Is it Post Meridian time?
	IF @ora BETWEEN 12 AND 23
	BEGIN
	SET @ora = @ora - 12
	END

--ELAB
	--@min:60 = @AngoloMin:360
	SET @AngoloMin = @min*6
	
	--[@ora + (@min/60)]:12 = @AngoloOra:360
	SET @AngoloOra = 30*@ora + (@min/2)
	
	SET @angolo = ABS(@AngoloOra-@AngoloMin)
	SET @angolo2 = 360 - @angolo

--OUTPUT	
SELECT @angolo AS Angolo1, @angolo2 AS Angolo2 

END



