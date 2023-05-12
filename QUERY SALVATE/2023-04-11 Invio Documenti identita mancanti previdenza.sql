USE CLC_Cesam
GO


IF OBJECT_ID('tempdb.dbo.#sottoscrizioni_azipr') IS NOT NULL
BEGIN
	DROP TABLE #sottoscrizioni_azipr	
END


IF OBJECT_ID('tempdb.dbo.#sottoscrizioni_azisf') IS NOT NULL
begin
	DROP TABLE #sottoscrizioni_azisf
END

;WITH s_azipr AS (
SELECT DISTINCT t.idincarico, t.chiavecliente
, t.nomedocumentopdf
, t.codtipoincarico
, LEFT(t.StringaCSV,8) IdIncaricoFlusso
, tp.IdPersona
FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI t
JOIN dbo.T_Persona tp ON t.chiavecliente = tp.ChiaveCliente

WHERE t.codtipoincarico IN (167	--Sottoscrizioni Previdenza
,572	--Sottoscrizioni Previdenza - Zenith
)
AND t.DataUpload >= DATEADD(MONTH,-2,getdate())

) SELECT s_azipr.idincarico
		,s_azipr.chiavecliente
		,s_azipr.nomedocumentopdf
		,s_azipr.codtipoincarico
		,s_azipr.IdIncaricoFlusso
		,v.Documento_id
		,s_azipr.IdPersona 
INTO #sottoscrizioni_azipr
FROM s_azipr
JOIN rs.v_CESAM_AZ_Documento_Identita_Recente v ON s_azipr.IdPersona = v.IdPersona

;WITH s_azisf AS (
SELECT DISTINCT t.idincarico, t.chiavecliente, t.nomedocumentopdf, t.codtipoincarico, t.DataUpload, LEFT(t.StringaCSV,8) IdIncaricoFlusso
, T_Persona.IdPersona, t.NumeroMandato

FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t
JOIN dbo.T_Persona ON t.chiavecliente = T_Persona.ChiaveCliente

WHERE t.DataUpload >= DATEADD(MONTH,-2,getdate())
AND t.codtipoincarico IN (
657	--AZISF - Sottoscrizioni Previdenza
,658 --AZISF - Disinvestimenti Previdenza
)
)
SELECT s_azisf.idincarico
	  ,s_azisf.chiavecliente
	  ,s_azisf.nomedocumentopdf
	  ,s_azisf.codtipoincarico
	  ,s_azisf.DataUpload
	  ,s_azisf.IdIncaricoFlusso
	  ,v.Documento_id
	  ,s_azisf.IdPersona
	  ,s_azisf.NumeroMandato
	  INTO #sottoscrizioni_azisf
FROM s_azisf
JOIN rs.v_CESAM_AZ_Documento_Identita_Recente v ON s_azisf.IdPersona = v.IdPersona


;WITH 
inviati_azipr AS (
SELECT idincarico, ProgressivoZip, RowNum = ROW_NUMBER() OVER (PARTITION BY idincarico ORDER BY  ProgressivoZip)

FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI 
WHERE DataUpload >= '2019-12-27 13:00:01'

GROUP BY idincarico,ProgressivoZip	

)
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI (documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento
, nomefile_input, idrepository, percorsocompleto
, NamingCartellaZip
, ProgressivoZip
, nomedocumentopdf
,StringaCSV
, FlagUpload, DataUpload, DescrizioneKO)

SELECT DISTINCT s.Documento_id, ti.IdIncarico, s.chiavecliente, ti.CodTipoIncarico, dti.Descrizione, td.Tipo_Documento
,td.Nome_file, srd.IdRepository, srd.PercorsoBase
, 'AZI' + '_' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8)
, (SELECT MAX(ProgressivoZip) +1 FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI)
, 'AZ_' + dbo.T_Persona.CodiceFiscale + '_' + CAST(IdIncaricoFlusso AS VARCHAR(20)) + '_' + CAST(inviati.RowNum AS VARCHAR(2))
,CAST(IdIncaricoFlusso AS VARCHAR(20)) + '_' + CAST(inviati.RowNum AS VARCHAR(2)) + ';' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8)
	+ ';AZ;AZI;' + 'AZ_' + dbo.T_Persona.CodiceFiscale + '_' + CAST(IdIncaricoFlusso AS VARCHAR(20)) + '_' + CAST(inviati.RowNum AS VARCHAR(2)) + '.pdf'
	+';'+Nome+';'+COGNOME+';'+CodiceFiscale StringaCSV
,0, NULL, NULL
FROM #sottoscrizioni_azipr s
JOIN dbo.T_Persona ON s.IdPersona = T_Persona.IdPersona
JOIN dbo.T_Documento td ON s.Documento_id = td.Documento_id
JOIN dbo.T_Incarico ti ON td.IdIncarico = ti.IdIncarico
JOIN dbo.D_TipoIncarico dti ON ti.CodTipoIncarico = dti.Codice
JOIN dbo.S_RepositoryDocumenti srd ON td.IdRepository = srd.IdRepository
 JOIN (SELECT MAX(RowNum) RowNum, idincarico FROM  inviati_azipr
					GROUP BY idincarico
					 ) inviati ON s.IdIncarico = inviati.idincarico
OUTER APPLY (
	SELECT TOP 1 * 
    FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI icbpi
	WHERE s.chiavecliente = icbpi.chiavecliente
	AND LEFT(stringacsv,8) = IdIncaricoFlusso
	--AND cafgdi.codtipoincarico != sottoscrizioni.codtipoincarico
	AND(
		icbpi.tipo_documento IN (102
,5589
,1
,9
,7348
)
OR (icbpi.tipo_documento = 155 AND icbpi.codtipoincarico = 44)
)
) t
WHERE T.documento_id IS NULL

;WITH inviati_azisf AS (
SELECT idincarico, ProgressivoZip, RowNum = ROW_NUMBER() OVER (PARTITION BY idincarico ORDER BY  ProgressivoZip)

FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture 

GROUP BY idincarico,ProgressivoZip	

)

INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture (documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico
, tipo_documento, nomefile_input, idrepository, percorsocompleto, NamingCartellaZip, ProgressivoZip
, nomedocumentopdf, StringaCSV, FlagUpload, DataUpload, DescrizioneKO, NumeroMandato)


SELECT DISTINCT s.Documento_id, ti.IdIncarico, s.chiavecliente, ti.CodTipoIncarico, dti.Descrizione, td.Tipo_Documento
,td.Nome_file, srd.IdRepository, srd.PercorsoBase, 'AZISF' + '_' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8)
, (SELECT MAX(ProgressivoZip) +1 FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture)
, 'AZ_' + dbo.T_Persona.CodiceFiscale + '_' + CAST(IdIncaricoFlusso AS VARCHAR(20)) + '_' + CAST(inviati.RowNum AS VARCHAR(2))
,CAST(IdIncaricoFlusso AS VARCHAR(20)) + '_' + CAST(inviati.RowNum AS VARCHAR(2)) + ';' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8)
	+ ';AZ;AZISF;' + 'AZ_' + dbo.T_Persona.CodiceFiscale + '_' + CAST(IdIncaricoFlusso AS VARCHAR(20)) + '_' + CAST(inviati.RowNum AS VARCHAR(2)) + '.pdf'
	+';'+Nome+';'+COGNOME+';'+CodiceFiscale StringaCSV
,0, NULL, NULL, s.NumeroMandato
FROM #sottoscrizioni_azisf s
JOIN dbo.T_Persona ON s.IdPersona = T_Persona.IdPersona
JOIN dbo.T_Documento td ON s.Documento_id = td.Documento_id
JOIN dbo.T_Incarico ti ON td.IdIncarico = ti.IdIncarico
JOIN dbo.D_TipoIncarico dti ON ti.CodTipoIncarico = dti.Codice
JOIN dbo.S_RepositoryDocumenti srd ON td.IdRepository = srd.IdRepository
 JOIN (SELECT MAX(RowNum) RowNum, idincarico FROM  inviati_azisf
					GROUP BY idincarico
) inviati ON s.IdIncarico = inviati.idincarico
OUTER APPLY (
	SELECT TOP 1 * 
    FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture azisf 
	WHERE s.chiavecliente = azisf.chiavecliente
	AND LEFT(stringacsv,8) = IdIncaricoFlusso
	--AND cafgdi.codtipoincarico != sottoscrizioni.codtipoincarico
	AND ( 
	azisf.tipo_documento IN (
								102
								,5589
								,1
								,9
								,7348
							)
OR (azisf.codtipoincarico = 44 AND azisf.tipo_documento = 155)
)
) t2
WHERE t2.documento_id IS NULL


DROP TABLE #sottoscrizioni_azipr, #sottoscrizioni_azisf



