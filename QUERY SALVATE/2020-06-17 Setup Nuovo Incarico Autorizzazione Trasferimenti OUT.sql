USE CLC
GO

/*gruppo tabelle setup
	Archivio Qtask
*/
--------------------------------R_Cliente_Archivio--------------------------------
INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
	SELECT
		23
		,649
		,CodTipoArchiviazione
		,CodScaffaleInizio
		,CodiceSezioneInizio
		,CodicePianoInizio
		,CodiceScatolaInizio
		,CodScaffaleFine
		,CodiceSezioneFine
		,CodicePianoFine
		,CodiceScatolaFine
		,NumeroDocumenti
		,FlagTemporaneo
		,CodDocumento
	FROM [btsqlcl05].clc.dbo.R_Cliente_Archivio
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Operatori QTask
	Setup operatori Cefin Isp
*/
--------------------------------R_Cliente_AssegnatarioIncarico--------------------------------
INSERT INTO R_Cliente_AssegnatarioIncarico (CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico)
	SELECT
		23
		,649
		,CodProfiloAccesso
		,CodRuoloOperatoreIncarico
	FROM [btsqlcl05].clc.dbo.R_Cliente_AssegnatarioIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Workflow incarichi
	Attributi QT
*/
--------------------------------R_Cliente_Attributo--------------------------------
INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
	SELECT
		23
		,649
		,CodAttributo
	FROM [btsqlcl05].clc.dbo.R_Cliente_Attributo
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Operazione Imbarco Mail
*/
--------------------------------R_Cliente_MailboxImbarcoIncarichi--------------------------------
INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
	SELECT
		23
		,649
		,IdMailboxImbarcoIncarichi
	FROM [btsqlcl05].clc.dbo.R_Cliente_MailboxImbarcoIncarichi
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Extranet 3.0 - profili
	Setup operatori Cefin Isp
*/
--------------------------------R_Cliente_ProfiloAccesso_InserimentoIncarico--------------------------------
INSERT INTO R_Cliente_ProfiloAccesso_InserimentoIncarico (CodCliente, CodProfiloAccesso, CodTipoIncarico, FlagAbilitaInserimento)
	SELECT
		23
		,CodProfiloAccesso
		,649
		,FlagAbilitaInserimento
	FROM [btsqlcl05].clc.dbo.R_Cliente_ProfiloAccesso_InserimentoIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generatore documenti
*/
--------------------------------R_Cliente_TemplateDocumento--------------------------------
INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
	SELECT
		IdTemplateDocumento
		,23
		,649
		,Priorita
		,CodProduttore
		,CodTipoProcessoSelfId
		,IdFaseLavorazioneIncarico
	FROM [btsqlcl05].clc.dbo.R_Cliente_TemplateDocumento
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico--------------------------------
INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore)
	SELECT
		23
		,649
		,CodTipoWorkflow
		,FlagMostraElementiSubincarichi
		,CodTabIncaricoDefault
		,FlagMostraElementiIncarichiMaster
		,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
		,FlagAssegnaAutomaticamenteAreaDaOperatore
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
	Aree incarichi QTask
*/
--------------------------------R_Cliente_TipoIncarico_Area--------------------------------
INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		23
		,649
		,CodArea
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_Area
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
*/
--------------------------------R_Cliente_TipoIncarico_AzioneSalvataggioIncarico--------------------------------
INSERT INTO R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
	SELECT
		23
		,649
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
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile--------------------------------
INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
		,649
		,CodDatoAssociabile
		,Cardinalita
		,FlagMostraInRicerca
		,ElementiSubincarichiVisualizzabili
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_DatoAssociabile
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
*/
--------------------------------R_Cliente_TipoIncarico_DatoAssociabileCollegabile--------------------------------
INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile (CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile)
	SELECT
		23
		,CodTipoIncaricoMaster
		,CodTipoSubIncarico
		,CodDatoAssociabileCollegabile
		,FlagClonazione
		,CodRuoloRichiedenteCollegabile
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata--------------------------------
INSERT INTO R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT
		23
		,649
		,CodEsitoTelefonata
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_EsitoTelefonata
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Workflow incarichi
	Extranet 3.0 - Richieste – Workflow/Transizioni
*/
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow--------------------------------
INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
		,649
		,CodStatoWorkflowIncarico
		,CodMacroStatoWorkflowIncarico
		,Ordinamento
		,IdFaseLavorazioneIncarico
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Telefonata
*/
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata--------------------------------
INSERT INTO R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
	SELECT
		23
		,649
		,CodMotivoTelefonata
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_MotivoTelefonata
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Codice Stampa
*/
--------------------------------R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa--------------------------------
INSERT INTO R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa (CodCliente, CodTipoIncarico, CodTipoIncaricoRicerca, CodStatoWorkflowIncaricoRicerca)
	SELECT
		23
		,649
		,CodTipoIncaricoRicerca
		,CodStatoWorkflowIncaricoRicerca
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Tabelle Antiriciclaggio
	Ruolo Richiedente
*/
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente--------------------------------
INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente)
	SELECT
		23
		,649
		,CodRuoloRichiedente
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_RuoloRichiedente
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Attività pianificate incarichi
*/
--------------------------------R_Cliente_TipoIncarico_TipoAttivitaPianificata--------------------------------
INSERT INTO R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	SELECT
		23
		,649
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
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Dati Aggiuntivi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo--------------------------------
INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT
		23
		,649
		,CodTipoDatoAggiuntivo
		,Ordinamento
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_TipoDatoAggiuntivo
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Dati Aggiuntivi
*/
--------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista--------------------------------
INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, ValoreLista)
	SELECT
		23
		,649
		,CodTipoDatoAggiuntivo
		,ValoreLista
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Documenti
	Documenti Q-Task
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_TipoDocumento--------------------------------
INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
		,649
		,CodDocumento
		,FlagVisualizza
		,CodiceRiferimento
		,CodOggettoControlli
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_TipoDocumento
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Note incarichi
*/
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi--------------------------------
INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
		,649
		,CodTipoNotaIncarichi
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncaricoAssociabile--------------------------------
INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT
		23
		,649
		,CodTipoIncaricoAssociabile
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncaricoAssociabile
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncaricoAssociabile--------------------------------
INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT
		23
		,649
		,CodTipoIncaricoAssociabile
	FROM [btsqlcl05].clc.dbo.R_Cliente_TipoIncaricoAssociabile
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Controlli
*/
--------------------------------R_EsitoControllo_BloccoTransizione--------------------------------
INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
	SELECT
		23
		,649
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
	FROM [btsqlcl05].clc.dbo.R_EsitoControllo_BloccoTransizione
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Abilitazioni operatori Q_Task
	Profili accesso
	Extranet 3.0 - profili
	Setup operatori Cefin Isp
*/
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico--------------------------------
INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
		,23
		,649
		,CodStatoWorkflowIncarico
		,FlagAbilita
		,CodProduttore
	FROM [btsqlcl05].clc.dbo.R_ProfiloAccesso_AbilitazioneIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Mailer
	Prodotti CLC
*/
--------------------------------R_TemplateComunicazione_StatoWorkflowIncarico--------------------------------
INSERT INTO R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo, FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale)
	SELECT
		IdTemplateComunicazione
		,23
		,649
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
	FROM [btsqlcl05].clc.dbo.R_TemplateComunicazione_StatoWorkflowIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Mailer
*/
--------------------------------R_TemplateComunicazione_TransizioneIncarico--------------------------------
INSERT INTO R_TemplateComunicazione_TransizioneIncarico (IdTemplateComunicazione, CodStatoWorkflowPartenza, FlagUrgentePartenza, CodAttributoPartenza, CodStatoWorkflowDestinazione, FlagUrgenteDestinazione, CodAttributoDestinazione, CodCliente, CodTipoIncarico, FlagCreazione)
	SELECT
		IdTemplateComunicazione
		,CodStatoWorkflowPartenza
		,FlagUrgentePartenza
		,CodAttributoPartenza
		,CodStatoWorkflowDestinazione
		,FlagUrgenteDestinazione
		,CodAttributoDestinazione
		,23
		,649
		,FlagCreazione
	FROM [btsqlcl05].clc.dbo.R_TemplateComunicazione_TransizioneIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Attività pianificate incarichi
	Attività pianificate incarichi - Transizioni
*/
--------------------------------R_Transizione_AttivitaPianificata--------------------------------
INSERT INTO R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch)
	SELECT
		23
		,649
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
	FROM [btsqlcl05].clc.dbo.R_Transizione_AttivitaPianificata
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Controlli
*/
--------------------------------R_Transizione_MacroControllo--------------------------------
INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
	SELECT
		23
		,649
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
	FROM [btsqlcl05].clc.dbo.R_Transizione_MacroControllo
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Generatore documenti
*/
--------------------------------R_TransizioneIncarico_GenerazioneDocumento--------------------------------
INSERT INTO R_TransizioneIncarico_GenerazioneDocumento (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, IdTemplateDocumento, FlagXml, FlagPdf, Priorita)
	SELECT
		23
		,649
		,FlagCreazione
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
		,IdTemplateDocumento
		,FlagXml
		,FlagPdf
		,Priorita
	FROM [btsqlcl05].clc.dbo.R_TransizioneIncarico_GenerazioneDocumento
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Controlli
*/
--------------------------------S_MacroControllo--------------------------------
INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo)
	SELECT
		23
		,649
		,NomeStoredProcedure
		,Descrizione
		,TestoHelp
		,FlagGenerazioneDifferita
		,Ordinamento
		,CodCategoriaMacroControllo
		,CodiceGruppo
	FROM [btsqlcl05].clc.dbo.S_MacroControllo
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Mailer
	Prodotti CLC
*/
--------------------------------S_MittenteMailIncarichi--------------------------------
INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, CodRuoloOperatoreIncarico, Email, Firma, CodClientePratica, CodProdottoPratica, CodProduttorePratica, CodMacroCategoriaTicket, NomeVisualizzato, CodBancaInterna)
	SELECT
		23
		,649
		,CodRuoloOperatoreIncarico
		,Email
		,Firma
		,CodClientePratica
		,CodProdottoPratica
		,CodProduttorePratica
		,CodMacroCategoriaTicket
		,NomeVisualizzato
		,CodBancaInterna
	FROM [btsqlcl05].clc.dbo.S_MittenteMailIncarichi
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Mailer
*/
--------------------------------S_MittentePosteIncarichi--------------------------------
INSERT INTO S_MittentePosteIncarichi (CodCliente, CodTipoIncarico, Nome, Cognome, Indirizzo, Cap, Localita, Provincia)
	SELECT
		23
		,649
		,Nome
		,Cognome
		,Indirizzo
		,Cap
		,Localita
		,Provincia
	FROM [btsqlcl05].clc.dbo.S_MittentePosteIncarichi
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Archivio Qtask
*/
--------------------------------S_PosizioneArchivio--------------------------------
INSERT INTO S_PosizioneArchivio (IdPosizioneArchivio, CodScaffale, CodiceSezione, CodicePiano, CodiceScatola, CodColore, CodCliente, CodTipoIncarico, CodTipoArchiviazione, NumeroDocumenti, FlagTemporaneo, CodDocumento)
	SELECT
		IdPosizioneArchivio
		,CodScaffale
		,CodiceSezione
		,CodicePiano
		,CodiceScatola
		,CodColore
		,23
		,649
		,CodTipoArchiviazione
		,NumeroDocumenti
		,FlagTemporaneo
		,CodDocumento
	FROM [btsqlcl05].clc.dbo.S_PosizioneArchivio
	WHERE codtipoincarico = 173
	AND codcliente = 23



/*gruppo tabelle setup
	Mailer
	Prodotti CLC
*/
--------------------------------S_ValutazioneDatiIncarico--------------------------------
INSERT INTO S_ValutazioneDatiIncarico (Descrizione, CodCliente, CodTipoIncarico, FlagAbilitaInvio, Priorita, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale)
	SELECT
		Descrizione
		,23
		,649
		,FlagAbilitaInvio
		,Priorita
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
		,CodCausaleRichiestaFondo
		,CodEsitoValutazioneFondo
		,CodCausaleRichiestaMoratoria
		,CodEsitoValutazioneMoratoria
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
	FROM [btsqlcl05].clc.dbo.S_ValutazioneDatiIncarico
	WHERE codtipoincarico = 173
	AND codcliente = 23