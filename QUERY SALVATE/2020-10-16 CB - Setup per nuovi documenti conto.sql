USE CLC
GO

--SELECT * FROM D_Documento WHERE Descrizione LIKE '%modulo%apertura %premier%'
--ORDER BY Codice DESC

/*
257383	--Modulo Apertura Conto_NG
257215  --Modulo premier --> diventa generico

inserire dato aggiuntivo tipologia rapporto su pregresso

*/


--DELETE 
SELECT *
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodCliente = 48
AND CodTipoIncarico IN (611,613,682)
AND CodDocumento IN (8275      --Modulo di apertura Conto Yellow
,8397     -- Modulo di apertura Conto Digital
,8398     -- Modulo di apertura Conto Deposito
,10025    --Modulo di apertura Conto Tascabile
)

--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza)
SELECT 48, D_TipoIncarico.Codice, D_Documento.Codice, 1
FROM D_TipoIncarico
JOIN D_Documento ON D_TipoIncarico.Codice IN (613,611)
AND D_Documento.Codice IN (257383	--Modulo Apertura Conto_NG
,257215  --Modulo premier --> diventa generico
)
LEFT JOIN R_Cliente_TipoIncarico_TipoDocumento r ON r.CodCliente = 48
AND r.CodTipoIncarico = D_TipoIncarico.Codice
AND r.CodDocumento = D_Documento.Codice
WHERE r.IdRelazione IS NULL


--DELETE 
SELECT *
FROM orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE
WHERE CodCliente = 48
AND CodTipoIncarico IN (611,613,682)
AND CodTipoDocumento IN (8275      --Modulo di apertura Conto Yellow
,8397     -- Modulo di apertura Conto Digital
,8398     -- Modulo di apertura Conto Deposito
,10025    --Modulo di apertura Conto Tascabile
)


--INSERT INTO orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE (CodCliente, CodTipoIncarico, CodTipoDocumento, CodFormDE, CodOrigineDE)
SELECT 48, D_TipoIncarico.Codice, D_Documento.Codice, 119,2
FROM D_TipoIncarico
JOIN D_Documento ON D_TipoIncarico.Codice IN ( 613,611)
AND D_Documento.Codice IN (257383	--Modulo Apertura Conto_NG
,257215  --Modulo premier --> diventa generico
)
LEFT JOIN orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE r ON r.CodCliente = 48
AND r.CodTipoIncarico = D_TipoIncarico.Codice
AND r.CodTipoDocumento = D_Documento.Codice

WHERE r.idRelazione IS NULL



SELECT * FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDocumento
WHERE CodDocumento IN (257383	--Modulo Apertura Conto_NG
,257215  --Modulo premier --> diventa generico
)

--DELETE 
SELECT *
FROM export.Z_Cliente_TipoIncarico_TipoDocumento
WHERE CodCliente = 48
AND CodTipoIncarico IN (613)
AND CodTipoDocumento IN (8275      --Modulo di apertura Conto Yellow
,8397     -- Modulo di apertura Conto Digital
,8398     -- Modulo di apertura Conto Deposito
,10025    --Modulo di apertura Conto Tascabile
)


--DELETE FROM export.Z_Cliente_TipoIncarico_TipoDocumento
--WHERE CodCliente = 48 AND CodTipoIncarico = 613 AND CodTipoDocumento = 257215

--INSERT INTO export.Z_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodSistemaEsterno, CodiceTipoDocumentoCliente, CodTipoDocumento, CodiceAggiuntivoCliente, CodStatoWorkflowIncarico, CodAttributoIncarico, Leading_refCode, FlagDocumentoPrincipale)
SELECT
	48 CodCliente
   ,613 CodTipoIncarico
   ,6 CodSistemaEsterno
   ,CASE D_Documento.Codice
	WHEN 257215 THEN 'PRDCNT'
	ELSE 'PRDCNT_NG' END CodiceTipoDocumentoCliente
   ,D_Documento.Codice CodTipoDocumento
   ,'OP001' CodiceAggiuntivoCliente
   ,D_StatoWorkflowIncarico.Codice CodStatoWorkflowIncarico
   ,NULL CodAttributoIncarico
   ,NULL Leading_refCode
   ,1 FlagDocumentoPrincipale
FROM D_Documento
JOIN D_StatoWorkflowIncarico
	ON D_Documento.Codice IN (257383	--Modulo Apertura Conto_NG
		, 257215  --Modulo premier --> diventa generico
		)
		AND D_StatoWorkflowIncarico.Codice IN (14275, 20977)
LEFT JOIN export.Z_Cliente_TipoIncarico_TipoDocumento Z ON Z.CodCliente = 48
AND Z.CodTipoIncarico = 613 AND D_StatoWorkflowIncarico.Codice = Z.CodStatoWorkflowIncarico
AND D_Documento.Codice = Z.CodTipoDocumento

WHERE z.IdRelazione IS NULL


