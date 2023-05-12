USE CLC
GO

SELECT * FROM [VP-BTSQL02].CLC.dbo.D_Documento ORDER BY Codice DESC 


--INSERT INTO D_Documento	 (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)

SELECT
	20346,
	'CB - Condizioni Generali Conto Digital 4 int',
	'CB - Condizioni Generali Conto Digital 4 int',
	CodOggettoControlli,
	FlagDocumentoBase,
	CodiceRiferimentoKtesios,
	Ordinamento,
	TestoHelp,
	FlagScanCEI,
	NumeroPagine
FROM D_Documento

WHERE Codice = 20322


--INSERT into R_Cliente_TipoIncarico_TipoDocumento	 (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	--VALUES (48, 331, 20346, 1, null, null);


--INSERT into S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)

SELECT
	CodOggettoGenerazione,
	20346,
	'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\CondizioniGeneraliContoDigital4int.pdf',
	FlagDocx,
	FlagCopia,
	NomeMacro,
	FlagGeneratoreLegacy
FROM S_TemplateDocumento
WHERE IdTemplate = 4091


SELECT SCOPE_IDENTITY()

--INSERT into R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
--	VALUES (4100, 48, 331, 3);



--modulo apertura 4 int

SELECT
	*
FROM [VP-BTSQL02].CLC.dbo.D_Documento
ORDER BY Codice DESC



--INSERT INTO D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)

SELECT
	20347,
	'CB - Modulo di Apertura Conto Digital 4 int',
	'CB - Modulo di Apertura Conto Digital 4 int',
	CodOggettoControlli,
	FlagDocumentoBase,
	CodiceRiferimentoKtesios,
	Ordinamento,
	TestoHelp,
	FlagScanCEI,
	NumeroPagine
FROM D_Documento
WHERE Codice = 20323

USE CLC
--INSERT into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
--VALUES (48,331,20347,1,NULL,NULL)


SELECT * FROM R_Cliente_TipoIncarico_TipoDocumento where CodDocumento = 20347


INSERT INTO S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)

SELECT
	CodOggettoGenerazione,
	20347,
	'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\ModuloAperturaContoDigital4int.dot',
	FlagDocx,
	FlagCopia,
	NomeMacro,
	FlagGeneratoreLegacy
FROM S_TemplateDocumento
WHERE CodTipoDocumento = 20323


SELECT SCOPE_IDENTITY()


--INSERT into R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
--	VALUES (4101, 48, 331, 3);



SELECT * FROM [VP-BTSQL02].CLC.dbo.D_Documento ORDER BY Codice DESC


--INSERT into D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
SELECT
	20349,
	'CB - Pack Fuori Sede Conto Digital 4 int',
	'CB - Pack Fuori Sede Conto Digital 4 int',
	CodOggettoControlli,
	FlagDocumentoBase,
	CodiceRiferimentoKtesios,
	Ordinamento,
	TestoHelp,
	FlagScanCEI,
	NumeroPagine
FROM D_Documento
WHERE Codice = 20336


--INSERT into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)

--VALUES (48,331,20348,1,NULL,NULL)
--		,(48,331,20349,1,NULL,null)


SELECT * FROM S_TemplateDocumento ORDER BY IdTemplate DESC

--4090
--4089

--UPDATE S_TemplateDocumento
--SET CodTipoDocumento = 20348
--,PercorsoFile = 'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\PackFuoriSedeContoDigital.dot'

--WHERE IdTemplate = 4089


--UPDATE S_TemplateDocumento
--SET CodTipoDocumento = 20349
--,PercorsoFile = 'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\PackFuoriSedeContoDigital4int.dot'
--WHERE IdTemplate = 4090



SELECT * FROM D_Documento ORDER BY Codice DESC


SELECT * FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDocumento WHERE CodDocumento IN (20321,20319)


SELECT * FROM [VP-BTSQL02].CLC.dbo.S_TemplateDocumento WHERE CodTipoDocumento IN (20321,20319)



--UPDATE [VP-BTSQL02].CLC.dbo.S_TemplateDocumento
--SET CodTipoDocumento = 20348
--,PercorsoFile = 'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\PackFuoriSedeContoDigital.dot'
--WHERE CodTipoDocumento = 20319

--UPDATE [VP-BTSQL02].CLC.dbo.S_TemplateDocumento

--SET CodTipoDocumento = 20349
--,PercorsoFile = 'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\PackFuoriSedeContoDigital4int.dot'
--where CodTipoDocumento = 20321



SELECT * FROM D_Documento ORDER BY Codice desc

/*
20296	CB - FEA Termini e Condizioni
20322	CB - Condizioni Generali Conto Digital
20323	CB - Modulo di Apertura Conto Digital
20348	CB - Pack Fuori Sede Conto Digital

20349	CB - Pack Fuori Sede Conto Digital 4 int
20347	CB - Modulo di Apertura Conto Digital 4 int
20346	CB - Condizioni Generali Conto Digital 4 int

*/

/* SPENTI
20321	CB - Documento di Sintesi Conto Digital
20319	CB - Foglio Informativo Conto Digital
*/


SELECT * FROM R_Cliente_TipoIncarico_TipoDocumento where CodDocumento IN (20296	--CB - FEA Termini e Condizioni
,20322	--CB - Condizioni Generali Conto Digital
,20323	--CB - Modulo di Apertura Conto Digital
,20348	--CB - Pack Fuori Sede Conto Digital

,20349	--CB - Pack Fuori Sede Conto Digital 4 int
,20347	--CB - Modulo di Apertura Conto Digital 4 int
,20346	--CB - Condizioni Generali Conto Digital 4 int
)


--in preprod
USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodDocumento IN (20296	--CB - FEA Termini e Condizioni
, 20322	--CB - Condizioni Generali Conto Digital
, 20323	--CB - Modulo di Apertura Conto Digital
, 20348	--CB - Pack Fuori Sede Conto Digital

, 20349	--CB - Pack Fuori Sede Conto Digital 4 int
, 20347	--CB - Modulo di Apertura Conto Digital 4 int
, 20346	--CB - Condizioni Generali Conto Digital 4 int
)

--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)

SELECT
	CodCliente,
	CodTipoIncarico,
	20346, 
	FlagVisualizza,
	CodiceRiferimento,
	CodOggettoControlli
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE IdRelazione = 60889

--ci sono ma con flag visualizza = 0, tranne per il coddocumento 20296 che c'era già per via del setup del conto deposito


USE clc
SELECT * FROM R_Cliente_TipoIncarico_TipoDocumento where CodDocumento IN (20321	--CB - Documento di Sintesi Conto Digital
																		  ,20319	--CB - Foglio Informativo Conto Digital
																		  )
--sia in test sia in preprod è stato tolto il setup delle etichette spente


--check presenza template
USE clc

SELECT 	IdTemplate,
		S_TemplateDocumento.CodOggettoGenerazione,
		S_TemplateDocumento.CodTipoDocumento,
		S_TemplateDocumento.PercorsoFile,
		S_TemplateDocumento.FlagDocx,
		S_TemplateDocumento.FlagCopia,
		S_TemplateDocumento.NomeMacro,
		S_TemplateDocumento.FlagGeneratoreLegacy, 
		D_Documento.Descrizione 
FROM S_TemplateDocumento 
JOIN D_Documento ON S_TemplateDocumento.CodTipoDocumento = D_Documento.Codice
where CodTipoDocumento IN (20296	--CB - FEA Termini e Condizioni ok				idtemplate test 4071	idtemplate preprod 4538
, 20322	--CB - Condizioni Generali Conto Digital					ok				idtemplate test 4091	idtemplate preprod 4643
, 20323	--CB - Modulo di Apertura Conto Digital						ok				idtemplate test 4092	idtemplate preprod 4644
, 20348	--CB - Pack Fuori Sede Conto Digital						ok				idtemplate test 4089	idtemplate preprod 4641

, 20349	--CB - Pack Fuori Sede Conto Digital 4 int					ok				idtemplate test 4090	idtemplate preprod 4642
, 20347	--CB - Modulo di Apertura Conto Digital 4 int				no preprod		idtemplate test 4101
, 20346	--CB - Condizioni Generali Conto Digital 4 int				no preprod		idtemplate test 4100
)


--TEST interno
USE CLC
SELECT * FROM R_Cliente_TemplateDocumento where IdTemplateDocumento IN (4071	--ok
																		,4091	--ok
																		,4092	--ok
																		,4089	--ok
																		,4090	--ok
																		,4101	--ok
																		,4100	--ok
																		)

--preprod
USE CLC
SELECT * FROM R_Cliente_TemplateDocumento where IdTemplateDocumento IN (4538	--ok
																		,4643	--ok
																		,4644	--ok
																		,4641	--ok
																		,4642	--ok
																		)



--facciamo gli insert dei template mancanti in preproduzione
USE CLC

--INSERT INTO [VP-BTSQL02].CLC.dbo.S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)
SELECT 	
		CodOggettoGenerazione,
		CodTipoDocumento,
		PercorsoFile,
		FlagDocx,
		FlagCopia,
		NomeMacro,
		FlagGeneratoreLegacy 
FROM S_TemplateDocumento
WHERE CodTipoDocumento = 20347



--INSERT INTO [VP-BTSQL02].CLC.dbo.S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)
	SELECT
		CodOggettoGenerazione,
		CodTipoDocumento,
		PercorsoFile,
		FlagDocx,
		FlagCopia,
		NomeMacro,
		FlagGeneratoreLegacy
	FROM S_TemplateDocumento
	WHERE CodTipoDocumento = 20346


USE clc
SELECT * FROM S_TemplateDocumento ORDER BY IdTemplate desc

--4665
--4664

USE clc
--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
SELECT 	
		4664,
		CodCliente,
		CodTipoIncarico,
		Priorita 
FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento = 4101
UNION ALL
SELECT 	
		4665,
		CodCliente,
		CodTipoIncarico,
		Priorita 
FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento = 4100

--fatto.


/*
--fai girare dopo la comunicazione ad Arad (pre-prod)
UPDATE R_Cliente_TipoIncarico_TipoDocumento
SET FlagVisualizza = 1
WHERE CodDocumento IN (20322
,20323
,20348
,20349
,20347
,20346)

*/