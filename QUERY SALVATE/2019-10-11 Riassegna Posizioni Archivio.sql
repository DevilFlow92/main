USE CLC
GO

--alter PROCEDURE orga.CESAM_AZ_Successioni_RiassegnaPosizioniArchivio (@IdIncaricoNew INT, @IdIncaricoOld INT ) AS 

--input parameters
--DECLARE @IdIncaricoNew INT = 13338068
--,@IdIncaricoOld INT = 10714216 

DECLARE
@CodCliente SMALLINT = 23
,@CodTipoIncarico SMALLINT = 54


--working parameters
DECLARE @IdPosizioneArchivioNew BIGINT
,@IdPosizioneArchivio BIGINT

SET @IdPosizioneArchivio = ( SELECT IdPosizioneArchivio FROM T_PeriodoPosizioneArchivioUtilizzata
WHERE IdIncarico = @IdIncaricoNew )


SET @IdPosizioneArchivioNew = (  SELECT TOP 1 s.IdPosizioneArchivio FROM S_PosizioneArchivio s
LEFT JOIN T_PeriodoPosizioneArchivioUtilizzata tp ON s.IdPosizioneArchivio = tp.IdPosizioneArchivio
LEFT JOIN T_Documento tdoc ON s.IdPosizioneArchivio = tdoc.IdPosizioneArchivio
WHERE s.CodCliente = @CodCliente
AND s.CodTipoIncarico = @CodTipoIncarico
AND tp.IdPeriodoPosizioneArchivioUtilizzata is NULL
AND tdoc.Documento_id is NULL
)

UPDATE T_PeriodoPosizioneArchivioUtilizzata
SET IdIncarico = @IdIncaricoOld
WHERE IdPosizioneArchivio = @IdPosizioneArchivio

UPDATE T_Documento
SET IdPosizioneArchivio = @IdPosizioneArchivioNew
WHERE IdIncarico = @IdIncaricoNew
AND IdPosizioneArchivio is NOT NULL

INSERT into T_PeriodoPosizioneArchivioUtilizzata (IdPosizioneArchivio, Periodo, Progressivo, IdIncarico, FlagEtichettaStampata)
	VALUES (@IdPosizioneArchivioNew, null, null, @IdIncaricoNew, 1);

	GO


	SELECT * FROM T_PeriodoPosizioneArchivioUtilizzata
	WHERE IdIncarico = 13338068

	UPDATE T_Documento
	SET IdPosizioneArchivio = 30002002007003
	WHERE IdIncarico = 13338068
	AND IdPosizioneArchivio is NOT NULL


