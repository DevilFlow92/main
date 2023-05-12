USE CLC
GO

WITH storico_date AS (
SELECT MIN(t.DataUpload) Data, t.ProgressivoZip n
FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI t
WHERE t.idincarico IN (14875223,
14896723
)
GROUP BY t.ProgressivoZip
)

UPDATE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
SET DataUpload = storico_date.data
--SELECT
--CONVERT(VARCHAR,DataUpload,112), RIGHT(NamingCartellaZip,8),
-- documento_id,NamingCartellaZip, DataUpload,ProgressivoZip ,data
-- , codtipoincarico,descrizioneincarico, tipo_documento
 FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI 
 JOIN storico_date ON n = ProgressivoZip
WHERE DataUpload >= '20200101' AND

 RIGHT(NamingCartellaZip,8) <> CONVERT(VARCHAR,DataUpload,112)

