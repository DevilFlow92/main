USE CLC
GO

--CREATE FUNCTION orga.GetIdPosizioneArchivio
--(@PosizioneReale VARCHAR(50)
	
--)

--RETURNS @IdPosizioneArchivio BIGINT
--AS 

BEGIN

/** INPUT **/
DECLARE @PosizioneReale VARCHAR(50)

SET @PosizioneReale = 'CESAM-CB!*1*1*56'

/***********/



/* INTERMEDIATE PARAMETERS */
DECLARE @IdPosizioneArchivio BIGINT
		,@scaffale VARCHAR(4)
		,@sezione VARCHAR(3)
		,@piano VARCHAR(3)
		,@scatola VARCHAR(3)
		,@colore VARCHAR(3)

/***************************/

IF OBJECT_ID('tempdb.dbo.#split') IS NOT NULL
	DROP TABLE #split

SELECT 	Id
		,Value 
INTO #split
FROM rs.Split(@PosizioneReale,'*')


SET @scaffale = CAST((SELECT TOP 1 Codice FROM D_Scaffale where Descrizione = (select value FROM #split where id = 1) ORDER BY Codice asc) AS VARCHAR(4))

SET @sezione = format((CAST((SELECT value  FROM #split  WHERE Id = 2) AS INT)), '000')

SET @piano = format((CAST((SELECT value FROM #split WHERE Id = 3) AS INT)), '000')

SET @scatola  = format((CAST((SELECT value FROM #split WHERE Id = 4) AS INT)), '000')

SET @colore = ISNULL(format((CAST((SELECT	value FROM #split WHERE Id = 5) AS INT)), '000'),'005')

SELECT @scaffale, @sezione, @piano, @scatola, @colore

SET @IdPosizioneArchivio = CAST((@scaffale + @sezione + @piano + @scatola + @colore) AS BIGINT)

/** OUTPUT **/

SELECT @IdPosizioneArchivio

--RETURN

/************/


SELECT
	*
FROM T_PeriodoPosizioneArchivioUtilizzata
WHERE IdPosizioneArchivio = @IdPosizioneArchivio


SELECT IdIncarico, * FROM T_Documento
WHERE IdPosizioneArchivio = @IdPosizioneArchivio

DROP TABLE #split

END

GO


SELECT * FROM S_Archivio
WHERE codscaffale IN (113,166)



