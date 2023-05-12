USE CLC
GO

BEGIN TRANSACTION

;WITH progressivozip AS (SELECT
	CONVERT(VARCHAR(10), GETDATE(), 112) +
	CAST(format(COALESCE(RIGHT(MAX(DocBank.ProgressivoZip), 3), 0) + 1, 'd3') AS VARCHAR(3))
	progressivo
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank docbank
WHERE LEFT(DocBank.ProgressivoZip, 8) = CAST(GETDATE() AS DATE))

--INSERT INTO export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank (documento_id, idincarico, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, ProgressivoZip, NamingCartellaZip, ProgressivoDocumento, ContentPath, DocType, NDG, NumeroDocumento, DataDocumento, CodiceFiscale,NumeroRapporto, Operation, idPraticaDocBank, PosizioneArchivio, FlagUpload)

SELECT DISTINCT
	docbank.documento_id
	,docbank.idincarico
	,docbank.codtipoincarico
	,docbank.descrizioneincarico
	,docbank.tipo_documento
	,docbank.nomefile_input
	,docbank.idrepository
	,docbank.percorsocompleto
	,(SELECT
		progressivo
	FROM progressivozip)
	ProgressivoZip
	,(SELECT
		progressivo
	FROM progressivozip)
	+ '_AssetMol' NamingCartellaZip
	,CAST(format(RANK() OVER (PARTITION BY (SELECT progressivo FROM progressivozip)	ORDER BY DocBank.idincarico, DocBank.DocType, DocBank.CodiceFiscale, DocBank.Operation, DocBank.idPraticaDocBank), 'd6') AS VARCHAR(6))
	ProgressivoDocumento
	,'AM_' + CAST(docbank.idincarico AS VARCHAR(10)) 
		+ 'S_' + CAST(format(RANK() OVER (PARTITION BY (SELECT	progressivo	FROM progressivozip) ORDER BY docbank.idincarico, docbank.DocType, docbank.CodiceFiscale, DocBank.Operation, DocBank.idPraticaDocBank), 'd6') AS VARCHAR(6))
	 ContentPath
	,'Dichiarazione' DocType
	,docbank.NDG
	,docbank.NumeroDocumento
	,docbank.DataDocumento
	,docbank.CodiceFiscale
	,docbank.NumeroRapporto
	,'OP024' Operation
	,docbank.idPraticaDocBank idPraticaDocBank
	,docbank.PosizioneArchivio
	,0 flagupload
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank docbank


WHERE docbank.documento_id IN (SELECT documento_id
FROM 
export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank 
WHERE DataUpload >= '20200601'
AND tipo_documento = 20014
AND DocType <> 'Dichiarazione'

EXCEPT

SELECT documento_id FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
WHERE DataUpload >= '20200601'
AND tipo_documento = 20014
AND DocType = 'dichiarazione'
)


COMMIT TRANSACTION
--ROLLBACK TRANSACTION

