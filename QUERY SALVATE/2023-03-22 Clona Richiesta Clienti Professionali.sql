USE CLC_Cesam
GO


--INSERT INTO dbo.R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
--SELECT CodCliente, 1033, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi FROM dbo.R_Cliente_TipoIncarico
--WHERE dbo.R_Cliente_TipoIncarico.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
--SELECT CodCliente, 1033, CodArea FROM dbo.R_Cliente_TipoIncarico_Area
--WHERE dbo.R_Cliente_TipoIncarico_Area.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_Area.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
--SELECT CodCliente, 1033, CodAttributo FROM dbo.R_Cliente_Attributo
--JOIN dbo.D_AttributoIncarico ON dbo.R_Cliente_Attributo.CodAttributo = dbo.D_AttributoIncarico.Codice
--WHERE dbo.R_Cliente_Attributo.CodCliente = 23
--AND dbo.R_Cliente_Attributo.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
--	VALUES (23, 1033, 1022);

--INSERT INTO dbo.R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
--SELECT IdTemplateDocumento, CodCliente, 1033, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico FROM dbo.R_Cliente_TemplateDocumento
--WHERE dbo.R_Cliente_TemplateDocumento.CodCliente = 23
--AND dbo.R_Cliente_TemplateDocumento.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
--SELECT CodCliente, 1033, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico FROM dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow
--WHERE dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
--SELECT CodCliente, 1033, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita FROM dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
--WHERE dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
--SELECT CodCliente, 1033, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili FROM dbo.R_Cliente_TipoIncarico_DatoAssociabile
--WHERE dbo.R_Cliente_TipoIncarico_DatoAssociabile.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_DatoAssociabile.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore, CodTipoPersona, OrdinamentoDefault)
--SELECT CodCliente, 1033, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore, CodTipoPersona, OrdinamentoDefault FROM dbo.R_Cliente_TipoIncarico_RuoloRichiedente
--WHERE dbo.R_Cliente_TipoIncarico_RuoloRichiedente.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_RuoloRichiedente.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
--SELECT CodCliente, 1033, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza FROM dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata
--WHERE dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
--SELECT CodCliente, 1033, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli FROM dbo.R_Cliente_TipoIncarico_TipoDocumento
--WHERE dbo.R_Cliente_TipoIncarico_TipoDocumento.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
--SELECT CodCliente, 1033, CodTipoNotaIncarichi FROM dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
--WHERE dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi.CodTipoIncarico = 595

--INSERT INTO dbo.R_ComunicazioneImbarcata_TransizioneIncarico (CodCliente, CodArea, CodTipoIncarico, CodCategoriaComunicazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgentePartenza, FlagAttesaPartenza, FlagUrgenteDestinazione, FlagAttesaDestinazione)
--SELECT CodCliente, CodArea, 1033, CodCategoriaComunicazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgentePartenza, FlagAttesaPartenza, FlagUrgenteDestinazione, FlagAttesaDestinazione FROM dbo.R_ComunicazioneImbarcata_TransizioneIncarico
--WHERE dbo.R_ComunicazioneImbarcata_TransizioneIncarico.CodCliente = 23
--AND dbo.R_ComunicazioneImbarcata_TransizioneIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, CodTipoIncarico)
--SELECT CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, 1033 FROM dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
--WHERE dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso.CodCliente = 23
--AND dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso.CodTipoIncarico = 595

--INSERT INTO dbo.R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo, FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
--SELECT IdTemplateComunicazione, CodCliente, 1033, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo, FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch FROM dbo.R_TemplateComunicazione_StatoWorkflowIncarico
--WHERE dbo.R_TemplateComunicazione_StatoWorkflowIncarico.CodCliente = 23
--AND dbo.R_TemplateComunicazione_StatoWorkflowIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch)
--SELECT CodCliente, 1033, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch FROM dbo.R_Transizione_AttivitaPianificata
--WHERE dbo.R_Transizione_AttivitaPianificata.CodCliente = 23
--AND dbo.R_Transizione_AttivitaPianificata.CodTipoIncarico = 595

--SELECT * FROM dbo.S_ValutazioneDatiIncarico
--WHERE dbo.S_ValutazioneDatiIncarico.IdValutazione = 1638

--INSERT INTO dbo.R_TemplateComunicazione_ValutazioneDatiIncarico (IdTemplateComunicazione, IdValutazioneDatiIncarico)
--SELECT dbo.R_TemplateComunicazione_ValutazioneDatiIncarico.IdTemplateComunicazione, 1638 FROM dbo.S_ValutazioneDatiIncarico
--JOIN dbo.R_TemplateComunicazione_ValutazioneDatiIncarico ON dbo.S_ValutazioneDatiIncarico.IdValutazione = dbo.R_TemplateComunicazione_ValutazioneDatiIncarico.IdValutazioneDatiIncarico
--WHERE dbo.S_ValutazioneDatiIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
--SELECT CodCliente, 1033, CodEsitoTelefonata FROM dbo.R_Cliente_TipoIncarico_EsitoTelefonata
--WHERE dbo.R_Cliente_TipoIncarico_EsitoTelefonata.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_EsitoTelefonata.CodTipoIncarico = 595

--INSERT INTO dbo.R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
--SELECT DISTINCT dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodProfiloAccesso, CodCliente, 1033, CodStatoWorkflowIncarico, 0, CodProduttore FROM dbo.R_ProfiloAccesso_AbilitazioneIncarico
--JOIN dbo.D_ProfiloAccesso ON dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodProfiloAccesso = dbo.D_ProfiloAccesso.Codice
--JOIN dbo.S_Operatore ON dbo.D_ProfiloAccesso.Codice = dbo.S_Operatore.CodProfiloAccesso AND dbo.S_Operatore.FlagAttivo = 1
--WHERE dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodCliente = 23
--AND dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_TemplateComunicazione_TransizioneIncarico (IdTemplateComunicazione, CodStatoWorkflowPartenza, FlagUrgentePartenza, CodAttributoPartenza, CodStatoWorkflowDestinazione, FlagUrgenteDestinazione, CodAttributoDestinazione, CodCliente, CodTipoIncarico, FlagCreazione)
--SELECT IdTemplateComunicazione, CodStatoWorkflowPartenza, FlagUrgentePartenza, CodAttributoPartenza, CodStatoWorkflowDestinazione, FlagUrgenteDestinazione, CodAttributoDestinazione, CodCliente, 1033, FlagCreazione FROM dbo.R_TemplateComunicazione_TransizioneIncarico
--WHERE dbo.R_TemplateComunicazione_TransizioneIncarico.CodCliente = 23
--AND dbo.R_TemplateComunicazione_TransizioneIncarico.CodTipoIncarico = 595

--INSERT INTO dbo.R_TransizioneIncarico_GenerazioneDocumento (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, IdTemplateDocumento, FlagXml, FlagPdf, Priorita)
--SELECT CodCliente, 1033, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, IdTemplateDocumento, FlagXml, FlagPdf, Priorita FROM dbo.R_TransizioneIncarico_GenerazioneDocumento
--WHERE dbo.R_TransizioneIncarico_GenerazioneDocumento.CodCliente = 23
--AND dbo.R_TransizioneIncarico_GenerazioneDocumento.CodTipoIncarico = 595

--INSERT INTO dbo.S_MittentePosteIncarichi (CodCliente, CodTipoIncarico, Nome, Cognome, Indirizzo, Cap, Localita, Provincia)
--SELECT CodCliente, 1033, Nome, Cognome, Indirizzo, Cap, Localita, Provincia FROM dbo.S_MittentePosteIncarichi
--WHERE dbo.S_MittentePosteIncarichi.CodTipoIncarico = 595
--AND dbo.S_MittentePosteIncarichi.CodCliente = 23

--INSERT INTO dbo.R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
--SELECT dbo.R_Cliente_TipoIncarico_MotivoTelefonata.CodCliente, 1033, dbo.R_Cliente_TipoIncarico_MotivoTelefonata.CodMotivoTelefonata FROM dbo.R_Cliente_TipoIncarico_MotivoTelefonata
--WHERE dbo.R_Cliente_TipoIncarico_MotivoTelefonata.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_MotivoTelefonata.CodTipoIncarico = 595

--INSERT INTO dbo.S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo, CodPrivilegioEsterno)
--SELECT CodCliente, 1033, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo, CodPrivilegioEsterno FROM dbo.S_MacroControllo
--WHERE dbo.S_MacroControllo.CodCliente = 23
--AND dbo.S_MacroControllo.CodTipoIncarico = 595

--INSERT INTO dbo.S_Controllo (CodDatoAssociabile, IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, NomeStoredProcedureInfoRilevanti, FlagDettaglioEspanso)
--SELECT CodDatoAssociabile, 4121, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, NomeStoredProcedureInfoRilevanti, FlagDettaglioEspanso FROM dbo.S_Controllo
--WHERE dbo.S_Controllo.IdTipoMacroControllo = 3068

--INSERT INTO dbo.R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
--SELECT CodCliente, 1033, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, 4121, FlagCreazione FROM dbo.R_Transizione_MacroControllo
--WHERE dbo.R_Transizione_MacroControllo.CodCliente = 23
--AND dbo.R_Transizione_MacroControllo.CodTipoIncarico = 595

--INSERT INTO dbo.R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
--SELECT CodCliente, 1033, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IIF(dbo.R_EsitoControllo_BloccoTransizione.IdControllo = 7607,12540,12541), IdMacroControllo, FlagAbilitaBlocco FROM dbo.R_EsitoControllo_BloccoTransizione
--WHERE dbo.R_EsitoControllo_BloccoTransizione.CodCliente = 23
--AND dbo.R_EsitoControllo_BloccoTransizione.CodTipoIncarico = 595

/*** da inserire poi ***/
USE CLC_Cesam
--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico)
--SELECT 23, 1033, Codice, 9
--FROM D_StatoWorkflowIncarico
--WHERE Codice IN (
--22320	--In Attesa verifiche uffici competenti
--,22321	--Riscontro ricevuto da uffici competenti
--,30144	--Generazione Controlli CF
--)
/***********************/


INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza , CodStatoWorkflowIncaricoDestinazione, FlagCreazione)
--SELECT 23595, 8570, 22320, 0 UNION
--SELECT 23595, 22320, 22321, 0 UNION
--SELECT 23595, 22321, 20854, 0 UNION
--SELECT 23595, 22321, 8500, 0 UNION
--SELECT 23595, 20856, 22320, 0 UNION
-- SELECT 23595, 22321, 20857, 0	--Variazione Profilo eseguita
--INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione,TestoHelp,  FlagGenerazioneDifferita, Ordinamento)
--	VALUES (23, 1033, 'MacroControlloAlwaysValid', 'Controlli CF'
--				,null 
--				,0,1)

--INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza,CodStatoWorkflowIncaricoDestinazione, IdTipoMacroControllo, FlagCreazione)
--VALUES (23, 1033, 6500, 8570,4123 --da inserire
--,0)

--INSERT INTO S_Controllo (IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva
--, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, Ordinamento, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, FlagDettaglioEspanso)
--VALUES (4123 --da inserire
--,'CESAM_AZ_FastTrack_ControlloCF', 1,1,0,1,0,'Controllo Popolamento CF'
--,'Controlla se il CF è presente, se i contatti sono inseriti e se rientra in whitelist per la courtesy mail FastTrack'
--,1,0,0,0,1,0
--)

--INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza
--, CodStatoWorkflowIncaricoDestinazione, CodGiudizioControllo, IdControllo, FlagAbilitaBlocco)
--VALUES (23,1034,8570,20853,4,12543 --da inserire
--,1
--)




--UPDATE R_ProfiloAccesso_AbilitazioneIncarico
--SET FlagAbilita = 1
--WHERE CodCliente = 23
--AND CodTipoIncarico = 1033
--AND FlagAbilita = 0
