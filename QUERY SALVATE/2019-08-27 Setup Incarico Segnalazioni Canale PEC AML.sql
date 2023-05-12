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

--INSERT INTO D_PrivilegioEsterno (Codice, Descrizione)
SELECT MAX(codice) + 1 , 'Visualizzazione mailbox AZ Segnalazioni PEC Antiriciclaggio'
FROM D_PrivilegioEsterno

--INSERT into R_ProfiloAccesso_PrivilegioEsterno 
SELECT CodProfiloAccesso, 11855, FlagDisabilita
FROM R_ProfiloAccesso_PrivilegioEsterno where CodPrivilegioEsterno = 11778


INSERT INTO S_MailboxImbarcoIncarichi (Username, CodPrivilegio, IdOperatore, Descrizione, CodOrigineDocumento, FlagFax, FlagAbilita, FlagAbilitaMatchIdIncarico, IdSistemaML, FlagAbilitaAutomatismoOperazioneImbarcoMail)
	SELECT
		Username, CodPrivilegio, IdOperatore, Descrizione, CodOrigineDocumento, FlagFax, FlagAbilita, FlagAbilitaMatchIdIncarico, IdSistemaML, FlagAbilitaAutomatismoOperazioneImbarcoMail
	FROM [VP-BTSQL02].CLC.dbo.s_MailboxImbarcoIncarichi
	WHERE IdMailbox = 799
	
INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
	VALUES (23, 549, SCOPE_IDENTITY());

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
--,(23,549,20749,9,2,null)
--,(23,549,20750,9,3,null)
--,(23,549,440,13,4,null)
--,(23,549,820,14,5,null)
--,(23,549,20727,14,6,null)
--,(23,549,20728,14,7,null)
--,(23,549,20730,9,8,null)



--INSERT into R_Cliente_TipoIncarico_MacroStatoWorkFlow 
SELECT 23, 549, D_StatoWorkflowIncarico.Codice, 12, NULL, NULL
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
JOIN D_StatoWorkflowIncarico on IdRelazione = 1
AND D_StatoWorkflowIncarico.Codice in (6500	--Creata
,20749	--In Valutazione (Master Segnalazioni PEC)
,20750	--In Valutazione Segnalazione PEC
,440		--Caricamento Errato
,20730	--Creazione Subincarichi PEC
,20765	--No Indice di Rischio + ADV scaduta
,20764	--Clienti già verificati QT
,20763	--Clienti Esclusi da Azimut
,20762	--Clienti con versato storico - 100k
,20761	--Clienti Chiusi Vincolati
,20760	--Clienti Chiusi + 12 mesi
,20728	--Apertura Verifica Rafforzata
)


--UPDATE R_Cliente_TipoIncarico_MacroStatoWorkFlow
--SET CodMacroStatoWorkflowIncarico = 13
--WHERE CodCliente = 23
--AND CodTipoIncarico = 549
--AND CodStatoWorkflowIncarico in  (440		--Caricamento Errato
--,20730	--Creazione Subincarichi PEC
--,20765	--No Indice di Rischio + ADV scaduta
--,20764	--Clienti già verificati QT
--,20763	--Clienti Esclusi da Azimut
--,20762	--Clienti con versato storico - 100k
--,20761	--Clienti Chiusi Vincolati
--,20760	--Clienti Chiusi + 12 mesi
--)

--UPDATE R_Cliente_TipoIncarico_MacroStatoWorkFlow
--SET CodMacroStatoWorkflowIncarico = 9
--WHERE CodCliente = 23 AND CodTipoIncarico = 549
--AND CodStatoWorkflowIncarico in (20749	--In Valutazione (Master Segnalazioni PEC)
--,20750	--In Valutazione Segnalazione PEC

--)


--INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)

SELECT 33, 6500, NULL, 440, 0, NULL UNION ALL
SELECT 33, 6500, NULL, 20749, 0, NULL UNION ALL
SELECT 33, 6500, NULL, 20750, 0, NULL UNION ALL
SELECT 33, 20749, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20750, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20749, NULL, 20730, 0, NULL UNION ALL
SELECT 33, 20750, NULL, 20727, 0, NULL UNION ALL
SELECT 33, 20750, NULL, 20728, 0, NULL UNION ALL
SELECT 33, 20727, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20728, NULL, 440, 0, NULL UNION ALL
SELECT 33, 20730, NULL, 440, 0, NULL --UNION ALL
--SELECT 33, 20730, NULL, 820, 0, NULL 



SELECT IdRelazione, dsw.Codice, dsw.Descrizione, dsw2.Codice, dsw2.Descrizione FROM S_WorkflowIncarico JOIN D_StatoWorkflowIncarico dsw ON S_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza = dsw.Codice
JOIN D_StatoWorkflowIncarico dsw2 ON S_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione = dsw2.Codice
WHERE CodTipoWorkflow = 30162

SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodStatoWorkflowIncarico = 20728

--INSERT into S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)

SELECT CodTipoWorkflow, Codice, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza 
FROM S_WorkflowIncarico
JOIN D_StatoWorkflowIncarico ON  CodStatoWorkflowIncaricoPartenza = 20728 AND CodTipoWorkflow = 30162
AND Codice IN (20765	--No Indice di Rischio + ADV scaduta
,20764	--Clienti già verificati QT
,20763	--Clienti Esclusi da Azimut
,20762	--Clienti con versato storico - 100k
,20761	--Clienti Chiusi Vincolati
,20760	--Clienti Chiusi + 12 mesi
)

UNION ALL

SELECT CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, Codice, FlagCreazione, FlagAttesaPartenza 
FROM S_WorkflowIncarico
JOIN D_StatoWorkflowIncarico ON  CodStatoWorkflowIncaricoDestinazione = 20728 and CodTipoWorkflow = 30162
AND Codice IN (20765	--No Indice di Rischio + ADV scaduta
,20764	--Clienti già verificati QT
,20763	--Clienti Esclusi da Azimut
,20762	--Clienti con versato storico - 100k
,20761	--Clienti Chiusi Vincolati
,20760	--Clienti Chiusi + 12 mesi
)

SELECT * FROM S_WorkflowIncarico
WHERE CodTipoWorkflow = 30162
AND (
CodStatoWorkflowIncaricoPartenza IN (20765	--No Indice di Rischio + ADV scaduta
,20764	--Clienti già verificati QT
,20763	--Clienti Esclusi da Azimut
,20762	--Clienti con versato storico - 100k
,20761	--Clienti Chiusi Vincolati
,20760	--Clienti Chiusi + 12 mesi
) 
OR CodStatoWorkflowIncaricoDestinazione IN (20765	--No Indice di Rischio + ADV scaduta
,20764	--Clienti già verificati QT
,20763	--Clienti Esclusi da Azimut
,20762	--Clienti con versato storico - 100k
,20761	--Clienti Chiusi Vincolati
,20760	--Clienti Chiusi + 12 mesi
)
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


/*
SETUP CLONA INCARICHI
*/

SELECT * FROM R_Cliente_TipoIncarico_DatoAssociabile
JOIN D_DatoAssociabile ON Codice = CodDatoAssociabile
WHERE CodCliente = 23
AND CodTipoIncarico = 549

--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile (CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile, FlagDataInizioRapportoObbligatoria)

SELECT 23 CodCliente
,549 CodTipoIncaricoMaster
,522 CodTipoSubIncarico
,D_DatoAssociabile.Codice CodDatoAssociabileCollegabile
,1 FlagClonazione
,NULL CodRuoloRichiedenteCollegabile
,0 FlagDataInizioRapportoObbligatoria
FROM D_DatoAssociabile
WHERE Codice IN (2	--Documento
,3	--Comunicazione
,21	--Dato aggiuntivo generico
,26	--Persona
,34	--Antiriciclaggio
,36	--Promotore
,32	--Controllo
)

/*
Controlli
*/

SELECT * FROM S_MacroControllo
WHERE CodCliente = 23
AND CodTipoIncarico = 112

--INSERT into S_MacroControllo 
SELECT
	CodCliente
	,549
	,NomeStoredProcedure
	,'Verifiche Antiriciclaggio'
	,'Verifiche Antiriciclaggio'
	,FlagGenerazioneDifferita
	,Ordinamento
	,CodCategoriaMacroControllo
	,CodiceGruppo
FROM S_MacroControllo
WHERE IdMacroControllo = 2635

--2701

--INSERT into S_MacroControllo
 SELECT CodCliente, CodTipoIncarico, NomeStoredProcedure, 'Motivi Esclusione', NULL, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo
 FROM S_MacroControllo
 WHERE IdMacroControllo = 2701

 SELECT SCOPE_IDENTITY() --2705



--INSERT into S_Controllo 
SELECT
	CodDatoAssociabile
	,2701 IdTipoMacroControllo
	,NomeStoredProcedure
	,1 FlagEsitoNonDefinito
	,1 FlagEsitoPositivo
	,0 FlagEsitoPositivoConRiserva
	,0 FlagEsitoNegativo
	,FlagNotaObbligatoria
	,'Verifiche Pregresse Antiriciclaggio'
	,'Verifiche Pregresse Antiriciclaggio'
	,CodEsitoControlloDefault
	,NomeStoredProcedurePreparatoria
	,Ordinamento
	,CodTipoRilievoControlloDefault
	,FlagSolaLettura
	,FlagCommenti
	,FlagCommentiObbligatori
	,CodCategoriaControllo
	,NomeStoredProcedureInfoRilevanti
	,FlagDettaglioEspanso
FROM S_Controllo
WHERE IdControllo = 6989


--INSERT into S_MacroControllo 
SELECT
	CodCliente
	,549
	,NomeStoredProcedure
	,'Automatismi Antiriciclaggio'
	,'Automatismi Antiriciclaggio'
	,FlagGenerazioneDifferita
	,Ordinamento
	,CodCategoriaMacroControllo
	,CodiceGruppo
FROM S_MacroControllo
WHERE IdMacroControllo = 2635

SELECT SCOPE_IDENTITY()

--2702

--INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo)
SELECT
	CodCliente
	,549
	,NomeStoredProcedure
	,'Automatismi Antiriciclaggio'
	,'Automatismi Antiriciclaggio'
	,FlagGenerazioneDifferita
	,Ordinamento
	,CodCategoriaMacroControllo
	,CodiceGruppo
FROM S_MacroControllo
WHERE IdMacroControllo = 2635

SELECT
	SCOPE_IDENTITY()

--INSERT into S_Controllo 
SELECT
	CodDatoAssociabile
	,2702 IdTipoMacroControllo
	,NomeStoredProcedure
	,1 FlagEsitoNonDefinito
	,1 FlagEsitoPositivo
	,0 FlagEsitoPositivoConRiserva
	,0 FlagEsitoNegativo
	,FlagNotaObbligatoria
	,'Creazione Subincarichi'
	,'Creazione Subincarichi'
	,CodEsitoControlloDefault
	,NomeStoredProcedurePreparatoria
	,Ordinamento
	,CodTipoRilievoControlloDefault
	,FlagSolaLettura
	,FlagCommenti
	,FlagCommentiObbligatori
	,CodCategoriaControllo
	,NomeStoredProcedureInfoRilevanti
	,FlagDettaglioEspanso
FROM S_Controllo
WHERE IdControllo = 6989

--form de
--INSERT into S_Controllo (CodDatoAssociabile, IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, NomeStoredProcedureInfoRilevanti, FlagDettaglioEspanso)
SELECT
	CodDatoAssociabile
	,2703 IdTipoMacroControllo
	,NomeStoredProcedure
	,FlagEsitoNonDefinito
	,FlagEsitoPositivo
	,FlagEsitoPositivoConRiserva
	,FlagEsitoNegativo
	,FlagNotaObbligatoria
	,Descrizione
	,TestoHelp
	,CodEsitoControlloDefault
	,NomeStoredProcedurePreparatoria
	,Ordinamento
	,CodTipoRilievoControlloDefault
	,FlagSolaLettura
	,FlagCommenti
	,FlagCommentiObbligatori
	,CodCategoriaControllo
	,NomeStoredProcedureInfoRilevanti
	,FlagDettaglioEspanso
FROM S_Controllo
WHERE IdControllo = 6989



--INSERT into S_Controllo 
SELECT
	CodDatoAssociabile
	,2705 IdTipoMacroControllo
	,NULL NomeStoredProcedure
	,FlagEsitoNonDefinito
	,FlagEsitoPositivo
	,FlagEsitoPositivoConRiserva
	,FlagEsitoNegativo
	,FlagNotaObbligatoria
	,D_StatoWorkflowIncarico.Descrizione
	,TestoHelp
	,CodEsitoControlloDefault
	,NomeStoredProcedurePreparatoria
	,ROW_NUMBER() OVER (ORDER BY IdControllo) Ordinamento
	,CodTipoRilievoControlloDefault
	,FlagSolaLettura
	,FlagCommenti
	,FlagCommentiObbligatori
	,CodCategoriaControllo
	,NomeStoredProcedureInfoRilevanti
	,FlagDettaglioEspanso
FROM S_Controllo
JOIN D_StatoWorkflowIncarico
	ON IdControllo = 7209
	AND Codice IN (20760	--Clienti Chiusi + 12 mesi
	, 20761	--Clienti Chiusi Vincolati
	, 20762	--Clienti con versato storico - 100k
	, 20763	--Clienti Esclusi da Azimut
	, 20764	--Clienti già verificati QT
	, 20765	--No Indice di Rischio + ADV scaduta)
	)

--INSERT into R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT
	23 CodCliente
	,549 CodTipoIncarico
	,20749 CodStatoWorkflowIncaricoPartenza
	,null CodAttributoIncaricoPartenza
	,null FlagUrgentePartenza
	,null FlagAttesaPartenza
	,20730 CodStatoWorkflowIncaricoDestinazione
	,null CodAttributoIncaricoDestinazione
	,null FlagUrgenteDestinazione
	,null FlagAttesaDestinazione
	,2702 IdTipoMacroControllo
	,0 FlagCreazione



--INSERT into R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT
	23 CodCliente
	,549 CodTipoIncarico
	,6500 CodStatoWorkflowIncaricoPartenza
	,null CodAttributoIncaricoPartenza
	,null FlagUrgentePartenza
	,null FlagAttesaPartenza
	,20750 CodStatoWorkflowIncaricoDestinazione
	,null CodAttributoIncaricoDestinazione
	,null FlagUrgenteDestinazione
	,null FlagAttesaDestinazione
	,2701 IdTipoMacroControllo
	,0 FlagCreazione

--INSERT into R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT
	23 CodCliente
	,549 CodTipoIncarico
	,6500 CodStatoWorkflowIncaricoPartenza
	,null CodAttributoIncaricoPartenza
	,null FlagUrgentePartenza
	,null FlagAttesaPartenza
	,20749 CodStatoWorkflowIncaricoDestinazione
	,null CodAttributoIncaricoDestinazione
	,null FlagUrgenteDestinazione
	,null FlagAttesaDestinazione
	,2703 IdTipoMacroControllo
	,0 FlagCreazione



/*
DATI AGGIUNTIVI
*/

SELECT * FROM D_TipoDatoAggiuntivo
WHERE Descrizione LIKE '%ESCLUS%'

--INSERT INTO D_TipoDatoAggiuntivo (Codice, Descrizione, CodFormatoDatoAggiuntivo)

SELECT (SELECT MAX(Codice) + 1 FROM D_TipoDatoAggiuntivo),'Motivi di Esclusione Verifiche Rafforzate',9


--1629

--INSERT into R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo)
--	VALUES (23, 549, 1629);

--INSERT into R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, ValoreLista)
--	VALUES (23, 549, 1629, 'Clienti Chiusi + 12 mesi')
--	,(23, 549, 1629, 'Clienti con versato storico - 100k')
--	,(23, 549, 1629, 'Clienti già verificati QT')
--	,(23, 549, 1629, 'Clienti Chiusi Vincolati')
--	,(23, 549, 1629, 'Clienti Esclusi da Azimut')
--	,(23, 549, 1629, 'No Indice di Rischio + ADV scaduta')
--	;

/*
Form DE
*/


--DELETE FROM orga.S_FormDE
--WHERE CodFormDE = 117

--INSERT INTO orga.S_FormDE (CodFormDE, Name, Value, Type, FieldOrderNumber, Category, FieldValueOptionList)
SELECT 117, 'Codice Cliente','','INTEGER',1,'DataEntry','' UNION ALL
SELECT 117,	'Nome Cliente','','STRING',	2,'DataEntry','' UNION ALL
select 117,	'Cognome Cliente','','STRING',	3,'DataEntry',''  UNION all
select 117,	'Codice Fiscale','','STRING',	4,'DataEntry',''			


SELECT * FROM R_Cliente_TipoIncarico_TipoDocumento
JOIN D_Documento on Codice = CodDocumento
WHERE CodCliente = 23
AND CodTipoIncarico = 549
AND Descrizione like '%allegato%'

--INSERT INTO orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE (CodCliente, CodTipoIncarico, CodTipoDocumento, CodFormDE, CodOrigineDE)
--	VALUES (23, 549, 155, 117, DEFAULT);


--INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
	SELECT
		CodCliente
		,CodTipoIncarico
		,CodStatoWorkflowIncaricoPartenza
		,CodAttributoIncaricoPartenza
		,FlagUrgentePartenza
		,FlagAttesaPartenza
		,CodStatoWorkflowIncaricoDestinazione
		,CodAttributoIncaricoDestinazione
		,FlagUrgenteDestinazione
		,FlagAttesaDestinazione
		,2705 IdTipoMacroControllo
		,FlagCreazione
	FROM R_Transizione_MacroControllo
	WHERE IdTipoMacroControllo = 2701