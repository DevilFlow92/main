USE CLC
GO


/*gruppo tabelle setup
	Operatori QTask
*/
 

--------------------------------R_Cliente_AssegnatarioIncarico--------------------------------
--INSERT INTO [VP-BTSQL02].clc.dbo.R_Cliente_AssegnatarioIncarico (CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico)
--	--SELECT
--	--	23
--	--	,549
--	--	,CodProfiloAccesso
--	--	,CodRuoloOperatoreIncarico
--	--FROM R_Cliente_AssegnatarioIncarico
--	--WHERE codtipoincarico = 522
--	--AND codcliente = 23
	SELECT CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico FROM R_Cliente_AssegnatarioIncarico
	WHERE CodCliente = 23 and CodTipoIncarico = 549

	

/*gruppo tabelle setup
	Workflow incarichi
	Attributi QT
*/
--------------------------------R_Cliente_Attributo--------------------------------
--INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
--	VALUES (23,549,17312) --ARCHIVIATA

--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)

SELECT CodCliente, CodTipoIncarico, CodAttributo FROM R_Cliente_Attributo
WHERE CodCliente = 23 and CodTipoIncarico = 549

/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_MailboxImbarcoIncarichi--------------------------------
--INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
--	SELECT
--		23
--		,549
--		,IdMailboxImbarcoIncarichi
--	FROM [VP-BTSQL02].clc.dbo.R_Cliente_MailboxImbarcoIncarichi
--	WHERE codtipoincarico = 522
--	AND codcliente = 23



/*gruppo tabelle setup
	Generatore documenti
*/
--------------------------------R_Cliente_TemplateDocumento--------------------------------
--INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
--	SELECT
--		IdTemplateDocumento
--		,23
--		,549
--		,Priorita
--	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TemplateDocumento
--	WHERE codtipoincarico = 522
--	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico--------------------------------
--INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore)
	SELECT
		23
		,549
		,CodTipoWorkflow
		,FlagMostraElementiSubincarichi
		,CodTabIncaricoDefault
		,FlagMostraElementiIncarichiMaster
		,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
		,FlagAssegnaAutomaticamenteAreaDaOperatore
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico
	WHERE codtipoincarico = 522
	AND codcliente = 23

--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore)
SELECT CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore FROM R_Cliente_TipoIncarico
WHERE codcliente = 23
AND CodTipoIncarico = 549

/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_AltroEnteSegnalante--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_AltroEnteSegnalante (CodCliente, CodTipoIncarico, CodAltroEnteSegnalante)
	SELECT
		23
		,549
		,D_AltroEnteSegnalante.Codice
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_AltroEnteSegnalante
	JOIN D_AltroEnteSegnalante ON IdRelazione = 1 
	AND D_AltroEnteSegnalante.Codice > 3

--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_AltroEnteSegnalante (CodCliente, CodTipoIncarico, CodAltroEnteSegnalante)
SELECT CodCliente, CodTipoIncarico, ROW_NUMBER() OVER (ORDER BY CodAltroEnteSegnalante) FROM R_Cliente_TipoIncarico_AltroEnteSegnalante
WHERE CodCliente = 23 and CodTipoIncarico = 549


/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
	Aree incarichi QTask
*/
--------------------------------R_Cliente_TipoIncarico_Area--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		23
		,549
		,CodArea
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_Area
	WHERE codtipoincarico = 522
	AND codcliente = 23

	--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT CodCliente, CodTipoIncarico, CodArea FROM R_Cliente_TipoIncarico_Area
	WHERE CodCliente = 23 and CodTipoIncarico = 549

/*gruppo tabelle setup
	Generale incarichi
*/
--------------------------------R_Cliente_TipoIncarico_ControllaDuplicati--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_ControllaDuplicati (CodCliente, CodTipoIncarico, FlagBloccante, FlagAbilita)
	SELECT
		23
		,549
		,FlagBloccante
		,FlagAbilita
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_ControllaDuplicati
	WHERE codtipoincarico = 522
	AND codcliente = 23


/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
		,549
		,CodDatoAssociabile
		,Cardinalita
		,FlagMostraInRicerca
		,ElementiSubincarichiVisualizzabili
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_DatoAssociabile
	WHERE codtipoincarico = 522
	AND codcliente = 23

	--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili FROM R_Cliente_TipoIncarico_DatoAssociabile
	--JOIN D_DatoAssociabile ON R_Cliente_TipoIncarico_DatoAssociabile.CodDatoAssociabile = D_DatoAssociabile.Codice
	WHERE CodCliente = 23 AND CodTipoIncarico = 549

/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT
		23
		,549
		,CodEsitoTelefonata
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_EsitoTelefonata
	WHERE codtipoincarico = 522
	AND codcliente = 23

	--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT CodCliente, CodTipoIncarico, CodEsitoTelefonata FROM R_Cliente_TipoIncarico_EsitoTelefonata
	WHERE CodCliente = 23 AND CodTipoIncarico = 549

/*gruppo tabelle setup
	Generale incarichi
*/
--------------------------------R_Cliente_TipoIncarico_IncaricoCollegabile--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_IncaricoCollegabile (CodCliente, CodTipoIncarico, CodTipoIncaricoCollegabile, CodDatoAssociabileCollegabile, FlagAbilita)
	SELECT
		23
		,549
		,CodTipoIncaricoCollegabile
		,CodDatoAssociabileCollegabile
		,FlagAbilita
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_IncaricoCollegabile
	WHERE codtipoincarico = 522
	AND codcliente = 23

	
/*gruppo tabelle setup
	Workflow incarichi
	Extranet 3.0 - Richieste – Workflow/Transizioni
*/
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
--values (23,549,6500,12,1,null)
--,(23,549,7130,9,2,null)
--,(23,549,440,13,3,null)
--,(23,549,820,14,4,null)
--,(23,549,20727,14,5,null)
--,(23,549,20728,14,6,null)
--,(23,549,20730,9,7,null)

--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
SELECT CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodCliente = 23 and CodTipoIncarico = 549


--INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)

SELECT 33, 6500, NULL, 440, 0, NULL UNION ALL
SELECT 33, 7130, NULL, 440, 0, NULL UNION ALL
SELECT 33, 7130, NULL, 20730, 0, NULL UNION ALL
SELECT 33, 7130, NULL, 20727, 0, NULL UNION ALL
SELECT 33, 7130, NULL, 20728, 0, NULL UNION ALL
SELECT 33, 20727, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20728, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20730, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20730, NULL, 820, 0, NULL 

--INSERT INTO [VP-BTSQL02].CLC.dbo.S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
SELECT CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza FROM S_WorkflowIncarico
WHERE CodTipoWorkflow = 33 AND IdRelazione IN (48902
,48903
,48904
,48905
,48906
,48907
,48908
,48909
,48910
)


/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_MandatoDossier--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_MandatoDossier (CodCliente, CodTipoIncarico, FlagMandatoDossierPresenti, FlagMandatoDossierObbligatori)
	SELECT
		23
		,549
		,FlagMandatoDossierPresenti
		,FlagMandatoDossierObbligatori
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_MandatoDossier
	WHERE codtipoincarico = 522
	AND codcliente = 23
	


/*gruppo tabelle setup
	Telefonata
*/
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
	SELECT
		23
		,549
		,CodMotivoTelefonata
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_MotivoTelefonata
	WHERE codtipoincarico = 522
	AND codcliente = 23

--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
SELECT CodCliente, CodTipoIncarico, CodMotivoTelefonata FROM R_Cliente_TipoIncarico_MotivoTelefonata
WHERE CodCliente = 23 AND CodTipoIncarico = 549

/*gruppo tabelle setup
	Tabelle Antiriciclaggio
*/
--------------------------------R_Cliente_TipoIncarico_MotivoVerifica--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_MotivoVerifica (CodCliente, CodTipoIncarico, CodMotivoVerifica)
	SELECT
		23
		,549
		,CodMotivoVerifica
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_MotivoVerifica
	WHERE codtipoincarico = 522
	AND codcliente = 23

	--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_MotivoVerifica (CodCliente, CodTipoIncarico, CodMotivoVerifica)
	SELECT CodCliente, CodTipoIncarico, CodMotivoVerifica FROM R_Cliente_TipoIncarico_MotivoVerifica
	WHERE CodCliente = 23 AND CodTipoIncarico = 549

/*gruppo tabelle setup
	Tabelle Antiriciclaggio
*/
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente)
	SELECT
		23
		,549
		,CodRuoloRichiedente
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_RuoloRichiedente
	WHERE codtipoincarico = 522
	AND codcliente = 23

	--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente)
	SELECT  23, 549, Codice
	FROM D_RuoloRichiedente
	WHERE Codice IN 	
	(
		11	--Cliente
		,36	--Rappresentante Legale
		,58	--Titolare Effettivo
		,31	--Curatore
		,22	--Procuratore
		,135	--Ruolo da verificare
	)
	
	
/*gruppo tabelle setup
	Documenti
	Documenti Q-Task
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_TipoDocumento--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
		,549
		,CodDocumento
		,FlagVisualizza
		,CodiceRiferimento
		,CodOggettoControlli
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_TipoDocumento
	WHERE codtipoincarico = 522
	AND codcliente = 23
		

/*gruppo tabelle setup
	Note incarichi
*/
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi--------------------------------
--INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
		,549
		,CodTipoNotaIncarichi
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE codtipoincarico = 522
	AND codcliente = 23


--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
SELECT
	23
	,549
	,codice
FROM D_TipoNotaIncarichi
WHERE Codice IN (22	--Generica
, 206	--Nota Milano
, 207	--Nota Arad
)

/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncaricoAssociabile--------------------------------
--INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT
		23
		,549
		,CodTipoIncaricoAssociabile
	FROM [VP-BTSQL02].clc.dbo.R_Cliente_TipoIncaricoAssociabile
	WHERE codtipoincarico = 522
	AND codcliente = 23

--INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
SELECT 23,549, D_TipoIncarico.Codice
FROM [VP-BTSQL02].CLC.dbo.D_TipoIncarico
WHERE Codice in (549,522)

/*gruppo tabelle setup
	Documenti Q-Task
	Extranet 3.0 - Richieste
	Documenti ScanMOL QT
*/
--------------------------------R_Documento_Cliente_TipoIncarico--------------------------------
--INSERT INTO R_Documento_Cliente_TipoIncarico (CodDocumento, CodCliente, CodTipoIncarico, CodiceSede)
	SELECT
		CodDocumento
		,23
		,549
		,CodiceSede
	FROM [VP-BTSQL02].clc.dbo.R_Documento_Cliente_TipoIncarico
	WHERE codtipoincarico = 522
	AND codcliente = 23



/*gruppo tabelle setup
	Abilitazioni operatori Q_Task
	Profili accesso
	Extranet 3.0 - profili
*/
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico--------------------------------
--INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
		,23
		,549
		,CodStatoWorkflowIncarico
		,FlagAbilita
		,CodProduttore
	FROM [VP-BTSQL02].clc.dbo.R_ProfiloAccesso_AbilitazioneIncarico
	WHERE codtipoincarico = 522


	--INSERT into [VP-BTSQL02].CLC.dbo.R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore FROM [VP-BTSQL02].CLC.dbo.R_ProfiloAccesso_AbilitazioneIncarico
	--JOIN [VP-BTSQL02].CLC.dbo.D_ProfiloAccesso ON CodProfiloAccesso = Codice
	WHERE CodCliente = 23 and CodTipoIncarico = 522


/*gruppo tabelle setup
	Extranet 3.0 - profili
	Attributi QT
*/
--------------------------------R_ProfiloAccesso_AttributoIncarico--------------------------------
--INSERT INTO R_ProfiloAccesso_AttributoIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodAttributoIncarico, FlagAbilita)
	SELECT
		CodProfiloAccesso
		,23
		,549
		,CodAttributoIncarico
		,FlagAbilita
	FROM [VP-BTSQL02].clc.dbo.R_ProfiloAccesso_AttributoIncarico
	WHERE codtipoincarico = 522
	AND codcliente = 23

--INSERT INTO [VP-BTSQL02].CLC.dbo.R_ProfiloAccesso_AttributoIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodAttributoIncarico, FlagAbilita)
SELECT 1267,CodCliente,CodTipoIncarico,CodAttributo,1 FROM R_Cliente_Attributo
WHERE CodCliente = 23 and CodTipoIncarico = 549


/*gruppo tabelle setup
	Operatori CEI Qtask
	Operatori QTask
	Extranet 3.0 - profili
*/
--------------------------------R_ProfiloAccesso_TipoIncarico_Privilegio--------------------------------
--INSERT INTO  [VP-BTSQL02].clc.dbo.R_ProfiloAccesso_TipoIncarico_Privilegio (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodPrivilegio, FlagAbilita, CodStatoWorkflowIncarico)
	SELECT
		CodProfiloAccesso
		,23
		,549
		,CodPrivilegio
		,FlagAbilita
		,CodStatoWorkflowIncarico
	FROM [VP-BTSQL02].clc.dbo.R_ProfiloAccesso_TipoIncarico_Privilegio
	WHERE codtipoincarico = 522
	AND codcliente = 23


	
/*gruppo tabelle setup
	Mailer
	Prodotti CLC
*/
--------------------------------S_MittenteMailIncarichi--------------------------------
--INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, CodRuoloOperatoreIncarico, Email, Firma, CodClientePratica, CodProdottoPratica, CodProduttorePratica, CodMacroCategoriaTicket, NomeVisualizzato)
	SELECT
		23
		,549
		,CodRuoloOperatoreIncarico
		,Email
		,Firma
		,CodClientePratica
		,CodProdottoPratica
		,CodProduttorePratica
		,CodMacroCategoriaTicket
		,NomeVisualizzato
	FROM [VP-BTSQL02].clc.dbo.S_MittenteMailIncarichi
	WHERE codtipoincarico = 522
	AND codcliente = 23


SELECT * FROM D_DatoAssociabile
WHERE Descrizione LIKE '%MAND%'


SELECT * FROM R_Cliente_TipoIncarico_DatoAssociabile
WHERE CodTipoIncarico = 549 AND CodDatoAssociabile = 30

SELECT * FROM D_StatoWorkflowIncarico
WHERE Descrizione LIKE '%SEGN%PEC%'

SELECT * FROM D_TipoWorkflow
WHERE Codice = 33

USE CLC
SELECT * FROM D_TipoWorkflow WHERE Codice = 33 ORDER BY Codice DESC

--INSERT INTO D_TipoWorkflow (Codice, Descrizione)
--	VALUES (30162, 'WF AML Generico');

USE CLC
--INSERT into orga.S_FormDE 
SELECT CodFormDE, Name, Value, Type, FieldOrderNumber, Category, FieldValueOptionList
FROM [VP-BTSQL02].CLC.orga.S_FormDE
WHERE CodFormDE = 117



SELECT IdIncarico, L_DocumentoDataEntry.* FROM T_DocumentoDataEntry
JOIN L_DocumentoDataEntry ON T_DocumentoDataEntry.IdDocumentoDataEntry = L_DocumentoDataEntry.IdDocumentoDataEntry
JOIN T_Documento ON Documento_id = IdDocumento

WHERE T_Documento.IdIncarico = 4427063
ORDER BY IdLog
