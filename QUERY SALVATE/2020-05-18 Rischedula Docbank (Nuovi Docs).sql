;WITH progressivozip AS (SELECT
	CONVERT(VARCHAR(10), GETDATE(), 112) +
	CAST(format(COALESCE(RIGHT(MAX(DocBank.ProgressivoZip), 3), 0) + 1, 'd3') AS VARCHAR(3))
	progressivo
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank docbank
WHERE LEFT(DocBank.ProgressivoZip, 8) = CAST(GETDATE() AS DATE))

--INSERT into export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank (documento_id, idincarico, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, ProgressivoZip, NamingCartellaZip, ProgressivoDocumento, ContentPath, DocType, NDG, NumeroDocumento, DataDocumento, CodiceFiscale, NumeroRapporto, Operation, idPraticaDocBank, PosizioneArchivio, FlagUpload)
SELECT DISTINCT
--export.Z_Cliente_TipoIncarico_TipoDocumento.*,
	T_Documento.Documento_id
	,T_Documento.IdIncarico
	,T_Incarico.CodTipoIncarico
	,D_TipoIncarico.Descrizione DescrizioneIncarico
	,T_Documento.Tipo_Documento
	,dbo.T_Incarico.CodTipoIncarico
	,Nome_file AS NomeFile_Input
	,T_Documento.IdRepository
	,S_RepositoryDocumenti.PercorsoBase AS PercorsoCompleto
	,(SELECT
		progressivo
	FROM progressivozip)
	ProgressivoZip
	,(SELECT
		progressivo
	FROM progressivozip)
	+ '_AssetMol' NamingCartellaZip

	,CAST(format(ROW_NUMBER() OVER (PARTITION BY DATEPART(HOUR, GETDATE())
	ORDER BY export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceTipoDocumentoCliente + ISNULL(export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceAggiuntivoCliente, 1) + CAST(T_Incarico.IdIncarico + T_Persona.IdPersona  AS VARCHAR(50))), 'd6') AS VARCHAR(6)) AS ProgressivoDocumento
	
	,'AM' + '_'
		+ CAST(T_Documento.IdIncarico AS VARCHAR(10)) + '_'
		+ CAST(format(ROW_NUMBER() OVER (PARTITION BY DATEPART(HOUR, GETDATE())
		ORDER BY export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceTipoDocumentoCliente + ISNULL(export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceAggiuntivoCliente, 1) + CAST(T_Incarico.IdIncarico + T_Persona.IdPersona AS VARCHAR(50))), 'd6') AS VARCHAR(6)) AS nomefileoutput
	
	,CodiceTipoDocumentoCliente DocType
	,LTRIM(RTRIM(REPLACE(T_Persona.ChiaveCliente, CHAR(9), ''))) AS NDG
	,ISNULL(T_DocumentoIdentita.Numero, T_Persona.ChiaveCliente) AS NumeroDocumento
	,T_Persona.CodiceFiscale AS CodiceFiscale
	,ISNULL(nrapporto.Leading_refCode, Z_Cliente_TipoIncarico_TipoDocumento.Leading_refCode) + RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 12) AS NumeroRapporto
	,export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceAggiuntivoCliente AS operation
	,CASE
		WHEN CodOggettoControlli = 48 THEN REPLACE(REPLACE(REPLACE(idpraticaDossier.Testo, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
		WHEN CodOggettoControlli = 46 THEN REPLACE(REPLACE(REPLACE(idpraticaPortabilita.Testo, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
		WHEN CodOggettoControlli = 58 THEN REPLACE(REPLACE(REPLACE(idpraticaKK.Testo, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
		WHEN T_Documento.Tipo_Documento = 8302 THEN REPLACE(REPLACE(REPLACE(idpraticaTDT.Testo, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
		WHEN T_Documento.Tipo_Documento = 10053 THEN REPLACE(REPLACE(REPLACE(T_Documento.Documento_id, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
		WHEN T_Documento.Tipo_Documento = 20002 THEN REPLACE(REPLACE(REPLACE(idpraticaWEBCOLL.Testo, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
	END
	AS idPraticaDocBank


	,ISNULL(D_Scaffale.Descrizione + '-' + CAST(S_PosizioneArchivio.CodiceSezione AS VARCHAR(3))
	+ '-' + CAST(S_PosizioneArchivio.CodicePiano AS VARCHAR(3))
	+ '-' + CAST(S_PosizioneArchivio.CodiceScatola AS VARCHAR(3))
	+ '[' + CAST(T_Incarico.IdIncarico AS VARCHAR(20)) + ']', 'ArchivioMOL') AS PosizioneArchivio

FROM T_Incarico
JOIN (SELECT
	MAX(Documento_id) Documento_id
	,T_Documento.IdIncarico
	,Tipo_Documento
FROM T_Documento
JOIN T_Incarico
	ON T_Documento.IdIncarico = T_Incarico.IdIncarico
LEFT JOIN T_DocumentoDataEntry
	ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
WHERE CodTipoIncarico IN (331, 334, 335, 359, 378, 493, 613) --611 nuovo fea arrivano separati, quindi li facciamo estrarre nella vista principale rs.v_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
AND Tipo_Documento IN (8258  --Dichiarazione primo contatto
, 8257 --Informativa regole di comportamento del consulente
)
AND CodCliente = 48
AND CodArea = 8
AND FlagScaduto = 0
AND FlagPresenzaInFileSystem = 1
--AND Nome_file LIKE '%.pdf'    
--AND T_Documento.IdIncarico = 9185620 
GROUP BY	Tipo_Documento
			,T_Documento.IdIncarico
			,IdPersona) DocRecente
	ON DocRecente.IdIncarico = T_Incarico.IdIncarico
JOIN dbo.T_Documento
	ON T_Documento.Documento_id = DocRecente.Documento_id
LEFT JOIN S_PosizioneArchivio
	ON T_Documento.IdPosizioneArchivio = S_PosizioneArchivio.IdPosizioneArchivio
LEFT JOIN D_Scaffale
	ON D_Scaffale.Codice = S_PosizioneArchivio.CodScaffale

JOIN D_Documento
	ON D_Documento.Codice = T_Documento.Tipo_Documento
JOIN dbo.D_TipoIncarico
	ON dbo.D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico
JOIN S_RepositoryDocumenti
	ON S_RepositoryDocumenti.IdRepository = dbo.T_Documento.IdRepository

LEFT JOIN T_R_Incarico_Persona
	ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico
LEFT JOIN T_Persona
	ON T_Persona.IdPersona = T_R_Incarico_Persona.IdPersona
LEFT JOIN T_DocumentoIdentita
	ON T_DocumentoIdentita.IdPersona = T_Persona.IdPersona

LEFT JOIN T_DatoAggiuntivo
	ON T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico
	AND CodTipoDatoAggiuntivo = 643
	AND FlagAttivo = 1

LEFT JOIN T_DatoAggiuntivo idpraticaDossier
	ON idpraticaDossier.IdIncarico = T_Incarico.IdIncarico
	AND idpraticaDossier.CodTipoDatoAggiuntivo = 936
	AND idpraticaDossier.FlagAttivo = 1
LEFT JOIN T_DatoAggiuntivo idpraticaPortabilita
	ON idpraticaPortabilita.IdIncarico = T_Incarico.IdIncarico
	AND idpraticaPortabilita.CodTipoDatoAggiuntivo = 937
	AND idpraticaPortabilita.FlagAttivo = 1
LEFT JOIN T_DatoAggiuntivo idpraticaTDT
	ON idpraticaTDT.IdIncarico = T_Incarico.IdIncarico
	AND idpraticaTDT.CodTipoDatoAggiuntivo = 1020
	AND idpraticaTDT.FlagAttivo = 1
LEFT JOIN T_DatoAggiuntivo idpraticaKK
	ON idpraticaKK.IdIncarico = T_Incarico.IdIncarico
	AND idpraticaKK.CodTipoDatoAggiuntivo = 1159
	AND idpraticaKK.FlagAttivo = 1
LEFT JOIN T_DatoAggiuntivo idpraticaWEBCOLL
	ON idpraticaWEBCOLL.IdIncarico = T_Incarico.IdIncarico
	AND idpraticaWEBCOLL.CodTipoDatoAggiuntivo = 1252
	AND idpraticaWEBCOLL.FlagAttivo = 1

JOIN export.Z_Cliente_TipoIncarico_TipoDocumento
	ON CodSistemaEsterno = 6
	AND DocRecente.Tipo_Documento = export.Z_Cliente_TipoIncarico_TipoDocumento.CodTipoDocumento
	AND T_Incarico.CodTipoIncarico = export.Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico
	AND T_Incarico.CodCliente = export.Z_Cliente_TipoIncarico_TipoDocumento.CodCliente

LEFT JOIN (SELECT
	T_Incarico.IdIncarico
	,MAX(znrapporto.Leading_refCode) Leading_refCode
FROM T_Documento DocNRapporto
JOIN T_Incarico
	ON DocNRapporto.IdIncarico = T_Incarico.IdIncarico
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento znrapporto
	ON znrapporto.CodSistemaEsterno = 6
	AND DocNRapporto.Tipo_Documento = znrapporto.CodTipoDocumento
	AND T_Incarico.CodTipoIncarico = znrapporto.CodTipoIncarico
	AND T_Incarico.CodCliente = znrapporto.CodCliente
	AND (T_Incarico.CodStatoWorkflowIncarico = znrapporto.CodStatoWorkflowIncarico
	OR T_Incarico.CodAttributoIncarico = znrapporto.CodAttributoIncarico
	)
	AND znrapporto.FlagDocumentoPrincipale = 1
--WHERE T_Incarico.IdIncarico =10018290 
GROUP BY T_Incarico.IdIncarico) nrapporto
	ON nrapporto.IdIncarico = T_Incarico.IdIncarico


LEFT JOIN export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
	ON T_Incarico.IdIncarico = Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.idincarico
	AND T_Documento.Tipo_Documento = Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.tipo_documento
	AND DocRecente.Documento_id = export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.documento_id
	

WHERE T_Incarico.CodTipoIncarico IN (331, 334, 335, 359, 378, 493
, 613
) --611 nuovo fea arrivano separati, quindi li facciamo estrarre nella vista principale rs.v_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
AND T_Incarico.CodCliente = 48
AND CodArea = 8
--AND ( T_Documento.Nome_file like '%.pdf')
AND FlagArchiviato = 0
AND FlagScaduto = 0
AND FlagPresenzaInFileSystem = 1
AND export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.documento_id IS NULL

AND T_Incarico.DataUltimaTransizione >= DATEADD(MONTH, -1, GETDATE())

AND T_Incarico.IdIncarico = 14927324