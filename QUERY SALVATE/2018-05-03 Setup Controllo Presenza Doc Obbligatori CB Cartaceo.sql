USE CLC

SELECT contr.IdControllo
		,IdMacroControllo
		,CodTipoIncarico
 FROM S_Controllo contr
JOIN S_MacroControllo on contr.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo
where contr.NomeStoredProcedure LIKE '%presenza%docum%'

--id controllo 1775	id macrocontrollo 453

--INSERT into S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento)

SELECT  CodCliente,
		331,
		NomeStoredProcedure,
		Descrizione,
		TestoHelp,
		FlagGenerazioneDifferita,
		Ordinamento FROM S_MacroControllo

WHERE IdMacroControllo = 453

SELECT * FROM S_MacroControllo ORDER BY IdMacroControllo DESC

--idmacrocontrollo test interno 457

--INSERT INTO S_Controllo (CodDatoAssociabile, IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, NomeStoredProcedureInfoRilevanti, FlagDettaglioEspanso)
SELECT
	CodDatoAssociabile,
	457,
	NomeStoredProcedure,
	FlagEsitoNonDefinito,
	FlagEsitoPositivo,
	FlagEsitoPositivoConRiserva,
	FlagEsitoNegativo,
	FlagNotaObbligatoria,
	Descrizione,
	TestoHelp,
	CodEsitoControlloDefault,
	NomeStoredProcedurePreparatoria,
	Ordinamento,
	CodTipoRilievoControlloDefault,
	FlagSolaLettura,
	FlagCommenti,
	FlagCommentiObbligatori,
	CodCategoriaControllo,
	NomeStoredProcedureInfoRilevanti,
	FlagDettaglioEspanso
FROM S_Controllo
WHERE IdControllo = 1775

SELECT * FROM S_Controllo ORDER BY IdControllo DESC

--id controllo cartaceo test interno 1810

--TRIGGER CONTROLLO
/*
Lo faccio partire alla transizione In Gestione - Acquisita
*/
	
SELECT * FROM D_StatoWorkflowIncarico where Codice = 8570
--8570	Acquisita

INSERT into R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT 	
		CodCliente,
		331,
		6500,
		CodAttributoIncaricoPartenza,
		FlagUrgentePartenza,
		FlagAttesaPartenza,
		8570,
		CodAttributoIncaricoDestinazione,
		FlagUrgenteDestinazione,
		FlagAttesaDestinazione,
		IdTipoMacroControllo,
		0
FROM R_Transizione_MacroControllo

WHERE IdTipoMacroControllo = 453

--INSERT into R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
SELECT 	CodCliente,
		331,
		CodAttributoIncaricoPartenza,
		CodAttributoIncaricoDestinazione,
		CodStatoWorkflowIncaricoPartenza,
		CodStatoWorkflowIncaricoDestinazione,
		FlagUrgentePartenza,
		FlagUrgenteDestinazione,
		FlagAttesaPartenza,
		FlagAttesaDestinazione,
		CodGiudizioControllo,
		CodEsitoControllo,
		1810,
		IdMacroControllo,
		FlagAbilitaBlocco FROM R_EsitoControllo_BloccoTransizione where IdControllo = 1775


--INSERT INTO [VP-BTSQL02].CLC.dbo.S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento)
	SELECT
		CodCliente,
		CodTipoIncarico,
		NomeStoredProcedure,
		Descrizione,
		TestoHelp,
		FlagGenerazioneDifferita,
		Ordinamento
	FROM S_MacroControllo
	WHERE IdMacroControllo = 457

SELECT TOP 10
	*
FROM [VP-BTSQL02].CLC.dbo.S_MacroControllo
ORDER BY IdMacroControllo DESC
--730

--INSERT INTO [VP-BTSQL02].CLC.dbo.S_Controllo (CodDatoAssociabile, IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura)
	SELECT
		CodDatoAssociabile,
		730,
		NomeStoredProcedure,
		FlagEsitoNonDefinito,
		FlagEsitoPositivo,
		FlagEsitoPositivoConRiserva,
		FlagEsitoNegativo,
		FlagNotaObbligatoria,
		Descrizione,
		TestoHelp,
		CodEsitoControlloDefault,
		NomeStoredProcedurePreparatoria,
		Ordinamento,
		CodTipoRilievoControlloDefault,
		FlagSolaLettura
	FROM S_Controllo
	WHERE IdControllo = 1810

SELECT TOP 10 * FROM [VP-BTSQL02].CLC.dbo.S_Controllo ORDER BY IdControllo DESC 
--2397

--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodStatoWorkflowIncaricoPartenza,
	CodAttributoIncaricoPartenza,
	FlagUrgentePartenza,
	FlagAttesaPartenza,
	CodStatoWorkflowIncaricoDestinazione,
	CodAttributoIncaricoDestinazione,
	FlagUrgenteDestinazione,
	FlagAttesaDestinazione,
	730,
	FlagCreazione
FROM R_Transizione_MacroControllo
WHERE IdTipoMacroControllo = 457

--INSERT into [VP-BTSQL02].CLC.dbo.R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
	
SELECT
	CodCliente,
	CodTipoIncarico,
	CodAttributoIncaricoPartenza,
	CodAttributoIncaricoDestinazione,
	CodStatoWorkflowIncaricoPartenza,
	CodStatoWorkflowIncaricoDestinazione,
	FlagUrgentePartenza,
	FlagUrgenteDestinazione,
	FlagAttesaPartenza,
	FlagAttesaDestinazione,
	CodGiudizioControllo,
	CodEsitoControllo,
	2397,
	IdMacroControllo,
	FlagAbilitaBlocco
FROM R_EsitoControllo_BloccoTransizione
WHERE IdControllo = 1810

