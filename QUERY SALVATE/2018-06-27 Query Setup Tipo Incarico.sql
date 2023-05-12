/*
SETUP TIPO INCARICO
*/


--INSERT into R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodTipoWorkflow,
	FlagMostraElementiSubincarichi,
	CodTabIncaricoDefault,
	FlagMostraElementiIncarichiMaster
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico
WHERE CodTipoIncarico = 323
--INSERT into D_TipoWorkflow (Codice, Descrizione)
--SELECT 	Codice,
--		Descrizione FROM [VP-BTSQL02].CLC.dbo.D_TipoWorkflow where Codice = 23306

--INSERT into R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodArea
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_Area
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodAttributo
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_Attributo
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodStatoWorkflowIncaricoPartenza,
	CodAttributoIncaricoPartenza,
	FlagUrgentePartenza,
	FlagAttesaPartenza,
	FlagArchiviatoPartenza,
	CodStatoWorkflowIncaricoDestinazione,
	CodAttributoIncaricoDestinazione,
	FlagUrgenteDestinazione,
	FlagAttesaDestinazione,
	FlagArchiviatoDestinazione,
	CodAzioneSalvataggioIncarico,
	FlagAbilita
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
WHERE CodTipoIncarico = 323

--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodDatoAssociabile,
	Cardinalita,
	FlagMostraInRicerca,
	ElementiSubincarichiVisualizzabili
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_DatoAssociabile
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_TipoIncarico_AreaCreazioneImport (CodCliente, CodTipoIncarico, CodTipoImportIncarico, CodArea)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodTipoImportIncarico,
	2
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_AreaCreazioneImport
WHERE CodTipoIncarico = 323

--INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodTipoIncaricoAssociabile
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncaricoAssociabile
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodTipoNotaIncarichi
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_TipoIncarico_IncaricoCollegabile (CodCliente, CodTipoIncarico, CodTipoIncaricoCollegabile, CodDatoAssociabileCollegabile, FlagAbilita)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodTipoIncaricoCollegabile,
	CodDatoAssociabileCollegabile,
	FlagAbilita
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_IncaricoCollegabile
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodStatoWorkflowIncarico,
	CodMacroStatoWorkflowIncarico,
	Ordinamento
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodTipoIncarico = 323

--INSERT into S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
SELECT
	CodTipoWorkflow,
	CodStatoWorkflowIncaricoPartenza,
	FlagUrgentePartenza,
	CodStatoWorkflowIncaricoDestinazione,
	FlagCreazione,
	FlagAttesaPartenza
FROM [VP-BTSQL02].CLC.dbo.S_WorkflowIncarico
WHERE CodTipoWorkflow = 23306

--INSERT into R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodRuoloRichiedente
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_RuoloRichiedente
WHERE CodTipoIncarico = 323

--INSERT into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodDocumento,
	FlagVisualizza,
	CodiceRiferimento,
	CodOggettoControlli
FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDocumento
WHERE CodTipoIncarico = 323