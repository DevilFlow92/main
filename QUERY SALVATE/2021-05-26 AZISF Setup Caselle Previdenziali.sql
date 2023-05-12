USE CLC
GO

SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_TipoIncarico
ORDER BY Codice DESC

INSERT INTO [DB-CLC-SETUPBT].clc.dbo.D_TipoIncarico 
SELECT 765, 'AZISF - Gestione Caselle Previdenza'

INSERT INTO  D_TipoIncarico		
SELECT 765, 'AZISF - Gestione Caselle Previdenza'

--/*gruppo tabelle setup Archivio Qtask SETUP ARCHIVIO DA FARE A PARTE! */
----------------------------------R_Cliente_Archivio-------------------------------- 
--INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine,
--NumeroDocumenti, FlagTemporaneo, CodDocumento)
--	SELECT
--		23
--	   ,753
--	   ,CodTipoArchiviazione
--	   ,CodScaffaleInizio
--	   ,CodiceSezioneInizio
--	   ,CodicePianoInizio
--	   ,CodiceScatolaInizio
--	   ,CodScaffaleFine
--	   ,CodiceSezioneFine
--	   ,CodicePianoFine
--	   ,CodiceScatolaFine
--	   ,NumeroDocumenti
--	   ,FlagTemporaneo
--	   ,CodDocumento
--	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_Archivio
--	WHERE CodTipoIncarico = 657
--	AND CodCliente = 23 

	
/*gruppo tabelle setup Operatori QTask Setup operatori Cefin Isp */
--------------------------------R_Cliente_AssegnatarioIncarico-------------------------------- 
INSERT INTO R_Cliente_AssegnatarioIncarico (CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico)
SELECT CodCliente, 765 CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico FROM R_Cliente_AssegnatarioIncarico
WHERE CodCliente = 23
AND CodTipoIncarico = 753
	

/*gruppo tabelle setup Workflow incarichi Attributi QT */
--------------------------------R_Cliente_Attributo-------------------------------- 
INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
SELECT CodCliente, 765 , CodAttributo FROM R_Cliente_Attributo
WHERE CodCliente = 23 
AND CodTipoIncarico = 753

/*gruppo tabelle setup Operazione
Imbarco Mail */
--------------------------------R_Cliente_MailboxImbarcoIncarichi-------------------------------- 
--INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)


/*gruppo tabelle setup Generatore documenti */
--------------------------------R_Cliente_TemplateDocumento-------------------------------- 
INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
SELECT IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico
FROM R_Cliente_TemplateDocumento
WHERE CodCliente = 23 AND CodTipoIncarico = 753

/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico,
--FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
SELECT CodCliente, 765, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi
FROM R_Cliente_TipoIncarico
WHERE CodCliente = 23 AND CodTipoIncarico = 753

	
	/*gruppo tabelle
setup Generale incarichi Extranet 3.0 - Richieste Aree incarichi QTask */
--------------------------------R_Cliente_TipoIncarico_Area-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
SELECT CodCliente, 765, CodArea FROM R_Cliente_TipoIncarico_Area
WHERE CodCliente = 23 AND CodTipoIncarico = 753
	
	/*gruppo tabelle setup Generale
incarichi */
--------------------------------R_Cliente_TipoIncarico_AzioneSalvataggioIncarico-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza,
CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)

SELECT CodCliente, 765 CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza,
CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita
FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
WHERE CodCliente = 23
AND CodTipoIncarico = 753



/*gruppo tabelle
setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
	   ,765
	   ,CodDatoAssociabile
	   ,Cardinalita
	   ,FlagMostraInRicerca
	   ,ElementiSubincarichiVisualizzabili
	FROM R_Cliente_TipoIncarico_DatoAssociabile
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 
	
	/*gruppo tabelle setup Generale incarichi */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabileCollegabile-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile (CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile)
	SELECT
		23
	   ,765 CodTipoIncaricoMaster
	   ,CodTipoSubIncarico
	   ,CodDatoAssociabileCollegabile
	   ,FlagClonazione
	   ,CodRuoloRichiedenteCollegabile
	FROM R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE CodTipoIncaricoMaster = 753
	AND CodCliente = 23 
	
	/*gruppo
tabelle setup */
--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT
		23
	   ,765
	   ,CodEsitoTelefonata
	FROM R_Cliente_TipoIncarico_EsitoTelefonata
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 
	
/*gruppo tabelle setup Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
	   ,765
	   ,CodStatoWorkflowIncarico
	   ,CodMacroStatoWorkflowIncarico
	   ,Ordinamento
	   ,IdFaseLavorazioneIncarico
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 

/*gruppo tabelle setup Piano di rientro Qtask */

--------------------------------R_Cliente_TipoIncarico_ModalitaPagamento-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_ModalitaPagamento (CodCliente, CodTipoIncarico, CodModalitaPagamento)
	SELECT
		23
	   ,765
	   ,CodModalitaPagamento
	FROM dbo.R_Cliente_TipoIncarico_ModalitaPagamento
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 

/*gruppo tabelle setup Telefonata */
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
	SELECT
		23
	   ,765
	   ,CodMotivoTelefonata
	FROM R_Cliente_TipoIncarico_MotivoTelefonata
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 

/*gruppo tabelle setup Codice Stampa */
--------------------------------R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa (CodCliente, CodTipoIncarico, CodTipoIncaricoRicerca, CodStatoWorkflowIncaricoRicerca)
	SELECT
		23
	   ,765
	   ,CodTipoIncaricoRicerca
	   ,CodStatoWorkflowIncaricoRicerca
	FROM R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 

/*gruppo tabelle setup Tabelle Antiriciclaggio Ruolo Richiedente */
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore)
	SELECT
		23
	   ,765
	   ,CodRuoloRichiedente
	   ,FlagVisualizzaPersonaRimossa
	   ,FlagEsecutore
	FROM R_Cliente_TipoIncarico_RuoloRichiedente
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 
	
/*gruppo tabelle setup Attività pianificate incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoAttivitaPianificata-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente,
FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	SELECT
		23
	   ,765
	   ,CodStatoWorkflowIncarico
	   ,CodTipoAttivitaPianificata
	   ,CodStatoWorkflowDeadline
	   ,MinutiDeadline
	   ,NomeStoredProcedureMatch
	   ,FlagUrgente
	   ,FlagNotaObbligatoria
	   ,CodAttributo
	   ,FlagIntervalloLavorativo
	   ,NomeStoredProcedureAggiornamentoDataScadenza
	FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23
	
/*gruppo tabelle setup Dati Aggiuntivi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT
		23
	   ,765
	   ,CodTipoDatoAggiuntivo
	   ,Ordinamento
	FROM R_Cliente_TipoIncarico_TipoDatoAggiuntivo
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 

INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, ValoreLista)
SELECT CodCliente, 765, CodTipoDatoAggiuntivo, ValoreLista
FROM R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista
WHERE CodCliente = 23
AND CodTipoIncarico = 753



/*gruppo tabelle setup Documenti Generatore documenti Documenti Q-Task Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_TipoDocumento-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
	   ,765
	   ,r.CodDocumento
	   ,r.FlagVisualizza
	   ,r.CodiceRiferimento
	   ,r.CodOggettoControlli
	FROM R_Cliente_TipoIncarico_TipoDocumento r
	--JOIN D_Documento ON r.CodDocumento = D_Documento.Codice
	WHERE r.CodTipoIncarico = 753
	AND r.CodCliente = 23 
	


/*gruppo tabelle setup Note incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
	   ,765
	   ,CodTipoNotaIncarichi
	FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 



/*gruppo tabelle setup Sospesi */
--------------------------------R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso-------------------------------- 
INSERT INTO R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, CodTipoIncarico)
	SELECT
		CodMotivazioneSospeso
	   ,CodSottoMotivazioneSospeso
	   ,CodModalitaSospeso
	   ,FlagAttivo
	   ,23
	   ,765 CodTipoIncarico
	FROM R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 



	/*gruppo tabelle
setup Abilitazioni operatori Q_Task Profili accesso Extranet 3.0 - profili Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico-------------------------------- 
INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,765
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	   ,CodProduttore
	FROM R_ProfiloAccesso_AbilitazioneIncarico
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 
	
	/*gruppo tabelle setup Extranet 3.0 - profili Attributi QT Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_AttributoIncarico-------------------------------- 
INSERT INTO R_ProfiloAccesso_AttributoIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodAttributoIncarico, FlagAbilita)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,765
	   ,CodAttributoIncarico
	   ,FlagAbilita
	FROM R_ProfiloAccesso_AttributoIncarico
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 
	
/*gruppo tabelle setup Operatori CEI Qtask Operatori QTask Extranet 3.0 - profili Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_TipoIncarico_Privilegio-------------------------------- 
INSERT INTO R_ProfiloAccesso_TipoIncarico_Privilegio (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodPrivilegio, FlagAbilita, CodStatoWorkflowIncarico)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,765
	   ,CodPrivilegio
	   ,FlagAbilita
	   ,CodStatoWorkflowIncarico
	FROM R_ProfiloAccesso_TipoIncarico_Privilegio
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 
	
/*gruppo tabelle setup Operatori - Privilegi Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_TipoIncarico_PrivilegioEsterno-------------------------------- 
INSERT INTO R_ProfiloAccesso_TipoIncarico_PrivilegioEsterno (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodPrivilegioEsterno, CodStatoWorkflowIncarico, FlagAbilita)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,765
	   ,CodPrivilegioEsterno
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	FROM R_ProfiloAccesso_TipoIncarico_PrivilegioEsterno
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 


 /*gruppo tabelle setup Mailer Prodotti CLC */

--------------------------------S_MittenteMailIncarichi-------------------------------- 
INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, CodRuoloOperatoreIncarico, Email, Firma, CodClientePratica, CodProdottoPratica, CodProduttorePratica, CodMacroCategoriaTicket, NomeVisualizzato, CodBancaInterna)
	SELECT
		23
	   ,765
	   ,CodRuoloOperatoreIncarico
	   ,Email
	   ,Firma
	   ,CodClientePratica
	   ,CodProdottoPratica
	   ,CodProduttorePratica
	   ,CodMacroCategoriaTicket
	   ,NomeVisualizzato
	   ,CodBancaInterna
	FROM dbo.S_MittenteMailIncarichi
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23
	AND Email = 'info.sustainablefuture@azimut.cesamoffice.it'

/*gruppo tabelle setup Mailer */
--------------------------------S_MittentePosteIncarichi-------------------------------- 
INSERT INTO S_MittentePosteIncarichi (CodCliente, CodTipoIncarico, Nome, Cognome, Indirizzo, Cap, Localita, Provincia)
	SELECT
		23
	   ,753
	   ,Nome
	   ,Cognome
	   ,Indirizzo
	   ,Cap
	   ,Localita
	   ,Provincia
	FROM S_MittentePosteIncarichi
	WHERE CodTipoIncarico = 753
	AND CodCliente = 23 


/* CONTROLLO BLOCCANTE MAIL MANCANTE */
DECLARE @IdMacroControllo INT
,@IdControllo INT

INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo)
SELECT CodCliente, 765, NomeStoredProcedure, 'Controlli Dataentry' Descrizione, NULL, 0, 1, NULL, NULL
FROM [DB-CLC-SETUPBT].CLC.dbo.S_MacroControllo
WHERE IdMacroControllo = 3104

SET @IdMacroControllo = (SELECT SCOPE_IDENTITY())

INSERT INTO S_Controllo ( IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione,    Ordinamento,  FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo,  FlagDettaglioEspanso)
SELECT @IdMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria
,'Controllo DataEntry Cliente/Propsect' Descrizione
,    Ordinamento,  FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo,  FlagDettaglioEspanso
FROM [DB-CLC-SETUPBT].CLC.dbo.S_Controllo
WHERE IdTipoMacroControllo = 3104

SET @IdControllo = (SELECT SCOPE_IDENTITY())

INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza,    CodStatoWorkflowIncaricoDestinazione,    IdTipoMacroControllo, FlagCreazione)
SELECT CodCliente, 765 CodTipoIncarico, CodStatoWorkflowIncaricoPartenza,    CodStatoWorkflowIncaricoDestinazione, @IdMacroControllo    IdTipoMacroControllo, FlagCreazione 
FROM R_Transizione_MacroControllo
WHERE CodCliente = 23
AND CodTipoIncarico = 753

INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico,   CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione,     CodGiudizioControllo,  IdControllo,  FlagAbilitaBlocco)
SELECT CodCliente, 765 CodTipoIncarico,   CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione,     CodGiudizioControllo, @IdControllo  IdControllo,  FlagAbilitaBlocco FROM R_EsitoControllo_BloccoTransizione
WHERE CodCliente = 23
AND CodTipoIncarico = 753


INSERT INTO R_TipoAttivitaPianificata_UfficioAttivitaPianificata (CodTipoAttivitaPianificata, CodUfficioAttivitaPianificata, FlagDefault, CodCliente, CodTipoIncarico)
SELECT CodTipoAttivitaPianificata, CodUfficioAttivitaPianificata, FlagDefault, CodCliente,765 CodTipoIncarico
FROM R_TipoAttivitaPianificata_UfficioAttivitaPianificata
WHERE CodCliente = 23 AND CodTipoAttivitaPianificata = 389
AND CodTipoIncarico = 753

--INSERT INTO R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch)
SELECT CodCliente, 765 CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione
, CASE WHEN IdTipoAttivitaInserimento IS NOT NULL THEN 5366 END IdTipoAttivitaInserimento
, CodTipoAttivitaChiusura
, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch
FROM R_Transizione_AttivitaPianificata
WHERE CodCliente = 23 AND CodTipoIncarico = 753


INSERT INTO R_Cliente_TipoIncarico_RuoloContatto (CodCliente, CodTipoIncarico, CodRuoloContatto)
SELECT CodCliente, 765, CodRuoloContatto
FROM R_Cliente_TipoIncarico_RuoloContatto
WHERE CodCliente = 23 AND CodTipoIncarico = 753

