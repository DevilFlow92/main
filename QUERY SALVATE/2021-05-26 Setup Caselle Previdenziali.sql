USE CLC
GO

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
	SELECT
		23
	   ,753
	   ,CodProfiloAccesso
	   ,CodRuoloOperatoreIncarico
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_AssegnatarioIncarico
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	
/*gruppo tabelle setup Workflow incarichi Attributi QT */
--------------------------------R_Cliente_Attributo-------------------------------- 
INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
	SELECT
		23
	   ,753
	   ,CodAttributo
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_Attributo
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 

/*gruppo tabelle setup Operazione
Imbarco Mail */
--------------------------------R_Cliente_MailboxImbarcoIncarichi-------------------------------- 
INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
	SELECT
		23
	   ,753
	   ,IdMailboxImbarcoIncarichi
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_MailboxImbarcoIncarichi
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23
	
/*gruppo tabelle setup Generatore documenti */
--------------------------------R_Cliente_TemplateDocumento-------------------------------- 
INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
	SELECT
		IdTemplateDocumento
	   ,23
	   ,753
	   ,Priorita
	   ,CodProduttore
	   ,CodTipoProcessoSelfId
	   ,IdFaseLavorazioneIncarico
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TemplateDocumento
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 

/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico,
FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
	SELECT
		23
	   ,753
	   ,31612 CodTipoWorkflow
	   ,FlagMostraElementiSubincarichi
	   ,CodTabIncaricoDefault
	   ,FlagMostraElementiIncarichiMaster
	   ,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
	   ,FlagAssegnaAutomaticamenteAreaDaOperatore
	   ,FlagMostraWorkflowSubincarichi
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	
	
	/*gruppo tabelle
setup Generale incarichi Extranet 3.0 - Richieste Aree incarichi QTask */
--------------------------------R_Cliente_TipoIncarico_Area-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		23
	   ,753
	   ,CodArea
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_Area
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Generale
incarichi */
--------------------------------R_Cliente_TipoIncarico_AzioneSalvataggioIncarico-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza,
CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
	SELECT
		23
	   ,753
	   ,CodStatoWorkflowIncaricoPartenza
	   ,CodAttributoIncaricoPartenza
	   ,FlagUrgentePartenza
	   ,FlagAttesaPartenza
	   ,FlagArchiviatoPartenza
	   ,CodStatoWorkflowIncaricoDestinazione
	   ,CodAttributoIncaricoDestinazione
	   ,FlagUrgenteDestinazione
	   ,FlagAttesaDestinazione
	   ,FlagArchiviatoDestinazione
	   ,CodAzioneSalvataggioIncarico
	   ,FlagAbilita
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	



/*gruppo tabelle
setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
	   ,753
	   ,CodDatoAssociabile
	   ,Cardinalita
	   ,FlagMostraInRicerca
	   ,ElementiSubincarichiVisualizzabili
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_DatoAssociabile
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	
	/*gruppo tabelle setup Generale incarichi */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabileCollegabile-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile (CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile)
	SELECT
		23
	   ,753 CodTipoIncaricoMaster
	   ,CodTipoSubIncarico
	   ,CodDatoAssociabileCollegabile
	   ,FlagClonazione
	   ,CodRuoloRichiedenteCollegabile
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE CodTipoIncaricoMaster = 657
	AND CodCliente = 23 
	
	/*gruppo
tabelle setup */
--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT
		23
	   ,753
	   ,CodEsitoTelefonata
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_EsitoTelefonata
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	
/*gruppo tabelle setup Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
	   ,753
	   ,CodStatoWorkflowIncarico
	   ,CodMacroStatoWorkflowIncarico
	   ,Ordinamento
	   ,IdFaseLavorazioneIncarico
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 

/*gruppo tabelle setup Piano di rientro Qtask */

--------------------------------R_Cliente_TipoIncarico_ModalitaPagamento-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_ModalitaPagamento (CodCliente, CodTipoIncarico, CodModalitaPagamento)
	SELECT
		23
	   ,753
	   ,CodModalitaPagamento
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_ModalitaPagamento
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 

/*gruppo tabelle setup Telefonata */
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
	SELECT
		23
	   ,753
	   ,CodMotivoTelefonata
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_MotivoTelefonata
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 

/*gruppo tabelle setup Codice Stampa */
--------------------------------R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa (CodCliente, CodTipoIncarico, CodTipoIncaricoRicerca, CodStatoWorkflowIncaricoRicerca)
	SELECT
		23
	   ,753
	   ,CodTipoIncaricoRicerca
	   ,CodStatoWorkflowIncaricoRicerca
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 

/*gruppo tabelle setup Tabelle Antiriciclaggio Ruolo Richiedente */
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore)
	SELECT
		23
	   ,753
	   ,CodRuoloRichiedente
	   ,FlagVisualizzaPersonaRimossa
	   ,FlagEsecutore
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_RuoloRichiedente
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Attività pianificate incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoAttivitaPianificata-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente,
FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	SELECT
		23
	   ,753
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
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23
	
/*gruppo tabelle setup Dati Aggiuntivi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT
		23
	   ,753
	   ,CodTipoDatoAggiuntivo
	   ,Ordinamento
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_TipoDatoAggiuntivo
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	AND CodTipoDatoAggiuntivo IN (223,224,230,1210)


	INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT 23, 753, 2302, 1

	INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, ValoreLista)
	select 23, 753, 2302, 'CHIARIMENTI LIQUIDAZIONI / SIMULAZIONI' union
select 23, 753, 2302, 'DICHIARAZIONE CONTRIBUTI NON DEDOTTI' union
select 23, 753, 2302, 'RICHIESTA CERTIFICAZIONE FISCALE' union
select 23, 753, 2302, 'RICHIESTA INVIO DOCUMENTAZIONE VIA MAIL (NON PIU'' PER POSTA ORDINARIA)' union
select 23, 753, 2302, 'RICHIESTA SALDO POSIZIONE' union
select 23, 753, 2302, 'SOLLECITO TRASFERIMENTO OUT' union
select 23, 753, 2302, 'VARIAZIONE DATORE DI LAVORO/TIPO ADESIONE' union
select 23, 753, 2302, 'VARIAZIONI/SEGNALAZIONI ANAGRAFICHE/BENEFICIARI E INDIRIZZO MAIL' union
select 23, 753, 2302, 'RICHIESTE PER SUCCESSIONE' union
select 23, 753, 2302, 'AUTORIZZAZIONE PER TRASFERIMENTO OUT' union
select 23, 753, 2302, 'DETTAGLIO FISCALE' union
select 23, 753, 2302, 'RICHIESTA/SOLLECITO AUTORIZZAZIONE PER TRASFERIMENTO IN' union
select 23, 753, 2302, 'RICHIESTA DOCUMENTI MANCANTI PER TRASFERIMENTO IN/ NON TRASFERIBILITA''' union
select 23, 753, 2302, 'SOLLECITO DETTAGLIO FISCALE' union
select 23, 753, 2302, 'COMUNICAZIONE FUSIONE/CESSIONE AZIENDA' union
select 23, 753, 2302, 'COMUNICAZIONE NUOVI DIPENDENTI / CESSAZIONI DIPENDENTI' union
select 23, 753, 2302, 'COMUNICAZIONI BONIFICI DOPPI E/O ERRATI' union
select 23, 753, 2302, 'INVIO DISTINTE CONTRIBUZIONE E COPIA BONIFICO' union
select 23, 753, 2302, 'RICHESTA INFORMAZIONI PER PAGAMENTO TFR E CONTRIBUTI VARI - CARICAMENTO DISTINTA' union
select 23, 753, 2302, 'RICHIESTA AZIENDA DELLA COPIA MANDATO DEL DIPENDENTE' union
select 23, 753, 2302, 'RICHIESTA RICONCILIAZIONE BONIFICI' union
select 23, 753, 2302, 'RICHIESTE SISTEMAZIONI DISTINTE/BONIFICI' union
select 23, 753, 2302, 'RICHIESTA CODICE AZIENDA/PASSWORD' union
select 23, 753, 2302, 'MODULO SR98/INPS' union
select 23, 753, 2302, 'RICHIESTA CONTATTO DA CONSULENTE O AZIMUT' union
select 23, 753, 2302, 'COMUNICAZIONI FALLIMENTI (POSTA CERTIFICATA)' union
select 23, 753, 2302, 'VARIE ( ES.: AZIENDE CHIEDONO BILANCI, COMPILARE DOCUMENTI, RECLAMI, …. )'



/*gruppo tabelle setup Documenti Generatore documenti Documenti Q-Task Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_TipoDocumento-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
	   ,753
	   ,r.CodDocumento
	   ,r.FlagVisualizza
	   ,r.CodiceRiferimento
	   ,r.CodOggettoControlli
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_TipoDocumento r
	--JOIN D_Documento ON r.CodDocumento = D_Documento.Codice
	WHERE r.CodTipoIncarico = 657
	AND r.CodCliente = 23 
	


/*gruppo tabelle setup Note incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
	   ,753
	   ,CodTipoNotaIncarichi
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 


/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncaricoAssociabile-------------------------------- 
INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT
		23
	   ,753
	   ,CodTipoIncaricoAssociabile
	FROM [db-clc-setupbt].CLC.dbo.R_Cliente_TipoIncaricoAssociabile
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	
	
 /*gruppo tabelle setup Controlli */
--------------------------------R_EsitoControllo_BloccoTransizione-------------------------------- 
INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza,
FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
	SELECT
		23
	   ,753
	   ,CodAttributoIncaricoPartenza
	   ,CodAttributoIncaricoDestinazione
	   ,CodStatoWorkflowIncaricoPartenza
	   ,CodStatoWorkflowIncaricoDestinazione
	   ,FlagUrgentePartenza
	   ,FlagUrgenteDestinazione
	   ,FlagAttesaPartenza
	   ,FlagAttesaDestinazione
	   ,CodGiudizioControllo
	   ,CodEsitoControllo
	   ,IdControllo
	   ,IdMacroControllo
	   ,FlagAbilitaBlocco
	FROM [db-clc-setupbt].CLC.dbo.R_EsitoControllo_BloccoTransizione
	WHERE CodTipoIncarico = 657
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
	   ,CodTipoIncarico
	FROM [db-clc-setupbt].CLC.dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle
setup Abilitazioni operatori Q_Task Profili accesso Extranet 3.0 - profili Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico-------------------------------- 
INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,753
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	   ,CodProduttore
	FROM [db-clc-setupbt].CLC.dbo.R_ProfiloAccesso_AbilitazioneIncarico
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Extranet 3.0 - profili Attributi QT Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_AttributoIncarico-------------------------------- 
INSERT INTO R_ProfiloAccesso_AttributoIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodAttributoIncarico, FlagAbilita)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,753
	   ,CodAttributoIncarico
	   ,FlagAbilita
	FROM [db-clc-setupbt].CLC.dbo.R_ProfiloAccesso_AttributoIncarico
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Operatori CEI Qtask Operatori QTask Extranet 3.0 - profili Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_TipoIncarico_Privilegio-------------------------------- 
INSERT INTO R_ProfiloAccesso_TipoIncarico_Privilegio (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodPrivilegio, FlagAbilita, CodStatoWorkflowIncarico)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,753
	   ,CodPrivilegio
	   ,FlagAbilita
	   ,CodStatoWorkflowIncarico
	FROM [db-clc-setupbt].CLC.dbo.R_ProfiloAccesso_TipoIncarico_Privilegio
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Operatori - Privilegi Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_TipoIncarico_PrivilegioEsterno-------------------------------- 
INSERT INTO R_ProfiloAccesso_TipoIncarico_PrivilegioEsterno (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodPrivilegioEsterno, CodStatoWorkflowIncarico, FlagAbilita)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,753
	   ,CodPrivilegioEsterno
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	FROM [db-clc-setupbt].CLC.dbo.R_ProfiloAccesso_TipoIncarico_PrivilegioEsterno
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 


/*gruppo tabelle setup Mailer Prodotti CLC */
--------------------------------R_TemplateComunicazione_StatoWorkflowIncarico-------------------------------- 
INSERT INTO R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna,
CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione,
CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo,
FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo,
CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica,
CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
	SELECT
		IdTemplateComunicazione
	   ,23
	   ,753
	   ,CodStatoWorkflow
	   ,FlagUrgente
	   ,CodAttributo
	   ,IdAtc
	   ,IdSedeAtc
	   ,CodProdottoPratica
	   ,CodAmministrazioneEsterna
	   ,CodSedeAmministrazioneEsterna
	   ,CodTipoSinistro
	   ,CodAssicurazioneSinistro
	   ,IdFondoPensioneSinistro
	   ,IdSedeAssicurazioneSinistro
	   ,CodiceConvenzioneSinistro
	   ,CodAttributoAtcInternalizzazione
	   ,CodModalitaRintraccioAtcInternalizzazione
	   ,CodEsitoRintraccioAtcInternalizzazione
	   ,FlagRichiestaVariazioneAnagraficaAtcInternalizzazione
	   ,CodCausaleRichiestaFondo
	   ,CodEsitoValutazioneFondo
	   ,FlagDocumentazioneCompletaFondo
	   ,FlagRateInsoluteDataRichiestaFondo
	   ,FlagInvioConsapFondo
	   ,FlagEsitoConsapFondo
	   ,CodCausaleRichiestaMoratoria
	   ,CodEsitoValutazioneMoratoria
	   ,FlagDocumentazioneCompletaMoratoria
	   ,FlagRateInsoluteDataRichiestaMoratoria
	   ,CodiceFilialePraticaMutuo
	   ,CodTipoTassoPraticaMutuo
	   ,CodValutaPraticaMutuo
	   ,CodProdottoPraticaMutuo
	   ,CodFinalitaPraticaMutuo
	   ,CodiceAssicurazioneVitaPraticaMutuo
	   ,CodiceAssicurazioneImpiegoPraticaMutuo
	   ,CodiceAssicurazioneImmobilePraticaMutuo
	   ,CodiceAssicurazioneCPIPraticaMutuo
	   ,CodProduttorePratica
	   ,CodCategoriaTicket
	   ,CodMacroCategoriaTicket
	   ,CodTipoProduttorePratica
	   ,CodAssicurazioneIncarico
	   ,FlagFirmaCessioneQuintoInFiliale
	   ,NomeFunzioneMatch
	FROM [db-clc-setupbt].CLC.dbo.R_TemplateComunicazione_StatoWorkflowIncarico
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 
	
/*gruppo tabelle setup Attività pianificate incarichi Attività
pianificate incarichi - Transizioni */

--------------------------------R_Transizione_AttivitaPianificata-------------------------------- 
INSERT INTO R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione,
CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato,
FlagAbilita, NomeStoredProcedureMatch)
	SELECT
		23
	   ,753
	   ,FlagCreazione
	   ,CodStatoWorkflowIncaricoPartenza
	   ,CodAttributoIncaricoPartenza
	   ,FlagUrgentePartenza
	   ,FlagAttesaPartenza
	   ,CodStatoWorkflowIncaricoDestinazione
	   ,CodAttributoIncaricoDestinazione
	   ,FlagUrgenteDestinazione
	   ,FlagAttesaDestinazione
	   ,IdTipoAttivitaInserimento
	   ,CodTipoAttivitaChiusura
	   ,FlagStatoWorkflowModificato
	   ,FlagAttributoModificato
	   ,FlagUrgenteModificato
	   ,FlagAttesaModificato
	   ,FlagAbilita
	   ,NomeStoredProcedureMatch
	FROM [db-clc-setupbt].CLC.dbo.R_Transizione_AttivitaPianificata
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Controlli */
--------------------------------R_Transizione_MacroControllo-------------------------------- 
INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione,
CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
	SELECT
		23
	   ,753
	   ,CodStatoWorkflowIncaricoPartenza
	   ,CodAttributoIncaricoPartenza
	   ,FlagUrgentePartenza
	   ,FlagAttesaPartenza
	   ,CodStatoWorkflowIncaricoDestinazione
	   ,CodAttributoIncaricoDestinazione
	   ,FlagUrgenteDestinazione
	   ,FlagAttesaDestinazione
	   ,IdTipoMacroControllo
	   ,FlagCreazione
	FROM [db-clc-setupbt].CLC.dbo.R_Transizione_MacroControllo
	WHERE CodTipoIncarico =
	657
	AND CodCliente = 23 /*gruppo tabelle setup Controlli */
--------------------------------S_MacroControllo-------------------------------- 
INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo)
	SELECT
		23
	   ,753
	   ,NomeStoredProcedure
	   ,Descrizione
	   ,TestoHelp
	   ,FlagGenerazioneDifferita
	   ,Ordinamento
	   ,CodCategoriaMacroControllo
	   ,CodiceGruppo
	FROM [db-clc-setupbt].CLC.dbo.S_MacroControllo
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Mailer Prodotti CLC */

--------------------------------S_MittenteMailIncarichi-------------------------------- 
INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, CodRuoloOperatoreIncarico, Email, Firma, CodClientePratica, CodProdottoPratica, CodProduttorePratica, CodMacroCategoriaTicket, NomeVisualizzato, CodBancaInterna)
	SELECT
		23
	   ,753
	   ,CodRuoloOperatoreIncarico
	   ,Email
	   ,Firma
	   ,CodClientePratica
	   ,CodProdottoPratica
	   ,CodProduttorePratica
	   ,CodMacroCategoriaTicket
	   ,NomeVisualizzato
	   ,CodBancaInterna
	FROM [db-clc-setupbt].CLC.dbo.S_MittenteMailIncarichi
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 /*gruppo tabelle setup Mailer */
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
	FROM [db-clc-setupbt].CLC.dbo.S_MittentePosteIncarichi
	WHERE CodTipoIncarico = 657
	AND CodCliente = 23 


	
	INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico,  Email,NomeVisualizzato)
	SELECT r.CodCliente, r.CodTipoIncarico, s.Username, '[NoReply] '+s.Descrizione
	FROM [DB-CLC-SETUPBT].CLC.dbo.S_MailboxImbarcoIncarichi s
	JOIN [DB-CLC-SETUPBT].CLC.dbo.R_Cliente_MailboxImbarcoIncarichi r ON s.IdMailbox = r.IdMailboxImbarcoIncarichi
	WHERE r.CodCliente = 23 AND r.CodTipoIncarico = 753

	UPDATE S_MittenteMailIncarichi
	SET NomeVisualizzato = NULL
	WHERE CodCliente = 23 AND CodTipoIncarico = 753


/* S_WorkflowIncarico */

INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
	VALUES (31612, NULL, NULL, 6500, 1, NULL);
INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza,  CodStatoWorkflowIncaricoDestinazione, FlagCreazione)
VALUES
/* Nuova - Creata */
(31612, 6500,440,0 )
,(31612,6500,22499,0)
,(31612,6500,8500,0)

/* Invio Presa In carico */
,(31612,22499,8570,0)
,(31612,22499,22500,0)

/* Inoltro a terzi */
,(31612,22500,8570,0) --Transizione da fare se outsourcer risponde o ci fa sapere se tutto ok A tendere (quando sarà in piedi lo sviluppo dell'aknowledgement) ci saranno delle transizioni massive
,(31612,22500,15415,0) --Invio sollecito se non ci risponde

/* In Gestione - Acquisita */
,(31612,8570,8500,0) --Apertura Sospeso
,(31612,8570,820,0) --Lavorazione conclusa, si apre template di risposta al cliente
,(31612,8570,22497,0) --Comunicazione Inviata al cliente

/* Sospesi */
,(31612,8500,6550,0)
,(31612,6550,6594,0)
,(31612,6550,6565,0)
,(31612,6550,6560,0)
,(31612,6594,6560,0)
,(31612,6594,6565,0)
,(31612,6560,6550,0)
,(31612,6560,8570,0)
,(31612,6565,8570,0)
,(31612,6565,820,0)

/* Lavorazione conclusa - Invio risposta al cliente */
,(31612,820,22497,0)


/*gruppo tabelle setup Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)

select 23 CodCliente, 753 CodTipoIncarico, 440    CodStatoWorkflowIncarico, 13 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico union
select 23 CodCliente, 753 CodTipoIncarico, 820	  CodStatoWorkflowIncarico, 14 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico union
select 23 CodCliente, 753 CodTipoIncarico, 6500	  CodStatoWorkflowIncarico, 12 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico union
select 23 CodCliente, 753 CodTipoIncarico, 6550	  CodStatoWorkflowIncarico, 2 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 6560	  CodStatoWorkflowIncarico, 2 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 6565	  CodStatoWorkflowIncarico, 2 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 6594	  CodStatoWorkflowIncarico, 2 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 8500	  CodStatoWorkflowIncarico, 2 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 8570	  CodStatoWorkflowIncarico, 9 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 15415  CodStatoWorkflowIncarico, 9 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 22497  CodStatoWorkflowIncarico, 14 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico union
select 23 CodCliente, 753 CodTipoIncarico, 22499  CodStatoWorkflowIncarico, 9 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico  union
select 23 CodCliente, 753 CodTipoIncarico, 22500  CodStatoWorkflowIncarico, 9 CodMacroStatoWorkflowIncarico, null Ordinamento, null IdFaseLavorazioneIncarico

/* CONTROLLO BLOCCANTE MAIL MANCANTE */
DECLARE @IdMacroControllo INT
,@IdControllo INT

INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo)
SELECT CodCliente, 753, NomeStoredProcedure, 'Controlli Dataentry' Descrizione, NULL, 0, 1, NULL, NULL
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
SELECT 23 CodCliente, 753 CodTipoIncarico, NULL CodStatoWorkflowIncaricoPartenza, 6500 CodStatoWorkflowIncaricoDestinazione, @IdMacroControllo IdTipoMacroControllo, 1 FlagCreazione

INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico,   CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione,     CodGiudizioControllo,  IdControllo,  FlagAbilitaBlocco)
SELECT 23 CodCliente, 753 CodTipoIncarico, 6500 CodStatoWorkflowIncaricoPartenza, 22499 CodStatoWorkflowIncaricoDestinazione, 4 CodGiudizioControllo, @IdControllo IdControllo, 1 FlagAbilitaBlocco

