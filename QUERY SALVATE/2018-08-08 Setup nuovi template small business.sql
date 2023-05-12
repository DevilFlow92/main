USE CLC
GO

/* ************************************* SETUP NUOVI TEMPLATE SMALL BUSINESS ************************************** */

/* ***** DEPOSITO TITOLI ***** */

/* 
	- CONDIZIONI GENERALI
	- DOC INFORMATIVO PER LA CLIENTELA 
*/

--SELECT * FROM D_Documento where Descrizione LIKE '%condizioni generali%'

--SELECT LEN('CB - Condizioni Generali Dep Titoli Small Business')

SELECT TOP 10 * FROM D_Documento ORDER BY Codice DESC 

--INSERT into D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
SELECT
	--@doc1,
	'CB - Condizioni Generali Deposito Titoli Small Business'
	,'CB - Condizioni Generali Dep Titoli Small Business'
	,CodOggettoControlli
	,FlagDocumentoBase
	,CodiceRiferimentoKtesios
	,Ordinamento
	,TestoHelp
	,FlagScanCEI
	,NumeroPagine
FROM D_Documento
WHERE Codice = 20597

--SELECT LEN('CB - Documento Informativo Clientela Dep Titoli SB')


--INSERT into D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
SELECT
	--@doc2,
	'CB - Documento Informativo Clientela Dep Titoli SB'
	,'CB - Documento Informativo Clientela Dep Titoli SB'
	,CodOggettoControlli
	,FlagDocumentoBase
	,CodiceRiferimentoKtesios
	,Ordinamento
	,TestoHelp
	,FlagScanCEI
	,NumeroPagine
FROM D_Documento
WHERE Codice = 20338


--INSERT into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)

SELECT
	CodCliente
	,474
	--,@doc1
	,FlagVisualizza
	,CodiceRiferimento
	,CodOggettoControlli
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodTipoIncarico = 331
AND CodDocumento = 20597

UNION ALL

SELECT
	CodCliente
	,474
	--,@doc2
	,FlagVisualizza
	,CodiceRiferimento
	,CodOggettoControlli
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodTipoIncarico = 331
AND CodDocumento = 20338



--INSERT into S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)

SELECT
	CodOggettoGenerazione
	--,@doc1
	,'CESAM\CheBanca\PredisposizioneContratto\SmallBusiness\CondizioniGeneraliDepositoTitoliSmallBusiness.pdf'
	,FlagDocx
	,FlagCopia
	,NomeMacro
	,FlagGeneratoreLegacy
FROM S_TemplateDocumento

WHERE IdTemplate = 4739



--INSERT into S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)

SELECT
	CodOggettoGenerazione
	--,@doc2
	,PercorsoFile
	,FlagDocx
	,FlagCopia
	,NomeMacro
	,FlagGeneratoreLegacy
FROM S_TemplateDocumento

WHERE IdTemplate = 4703


--INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)

SELECT
	--@template1,
	CodCliente
	,474
	,Priorita
FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento = 4739

UNION ALL

SELECT
	--@template2,
	CodCliente
	,474
	,Priorita
FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento = 4703


/* TEMPLATE PACK DEPOSITO TITOLI SMALL BUSINESS */

SELECT TOP 10 * 
FROM D_Documento
ORDER BY Codice DESC

--INSERT INTO D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
SELECT
	Codice
	,'CB - Pack Fuori Sede Deposito Titoli Small Business'
	,'CB - Pack Fuori Sede Deposito Titoli Small Business'
	,CodOggettoControlli
	,FlagDocumentoBase
	,CodiceRiferimentoKtesios
	,Ordinamento
	,TestoHelp
	,FlagScanCEI
	,NumeroPagine
FROM D_Documento
WHERE Codice = 20360


--INSERT into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
