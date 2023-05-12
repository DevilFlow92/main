SELECT 

DISTINCT 
	  --z.CodTipoIncarico CodiceTipoIncaricoQTask
	  --D_TipoIncarico.Descrizione EtichettaTipoIncaricoQTask
	  --,z.CodSistemaEsterno
	  z.CodiceTipoDocumentoCliente DocType
	  ,z.CodTipoDocumento CodiceDocumentoQTask
	  ,D_Documento.Descrizione EtichettaDocumentoQTask
	  ,z.CodiceAggiuntivoCliente Operation_Code
	  --,z.CodStatoWorkflowIncarico
	  --,z.CodAttributoIncarico
	  ,z.Leading_refCode
	  --,z.FlagDocumentoPrincipale 
	  ,CASE WHEN r.IdRelazione IS NOT NULL THEN 1 ELSE 0 END FlagSetup
	  ,FORMAT(uploadDocbank.DataUpload,'dd/MM/yyyy HH:mm') DataUltimoUploadDocbank

FROM export.Z_Cliente_TipoIncarico_TipoDocumento z
JOIN D_Documento ON z.CodTipoDocumento = D_Documento.Codice
JOIN D_TipoIncarico ON z.CodTipoIncarico = D_TipoIncarico.Codice
LEFT JOIN R_Cliente_TipoIncarico_TipoDocumento r ON z.CodCliente = r.CodCliente
AND z.CodTipoIncarico = r.CodTipoIncarico
AND D_Documento.Codice = r.CodDocumento
OUTER APPLY (
				SELECT TOP 1 docbank.DataUpload
				FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank docbank
				WHERE docbank.tipo_documento = z.codtipodocumento
				--AND docbank.codtipoincarico = z.codtipoincarico
				ORDER BY dataupload DESC

) uploadDocbank
WHERE z.CodCliente = 48
AND z.CodTipoIncarico NOT IN (331 --Apertura Conto e Dossier (Se presente) - Cartaceo
,334 --Apertura Dossier Titoli SOLO FEA
,335 --Apertura Conto Corrente FEA
,564 --Trasferimento servizi pagamento FEA
,493 --Gestione Documentale (non caricamento)
,378 --Apertura Carta di Credito FEA
)
AND z.CodStatoWorkflowIncarico = 14275
--ORDER BY z.CodTipoIncarico, CodiceTipoDocumentoCliente, CodTipoDocumento

