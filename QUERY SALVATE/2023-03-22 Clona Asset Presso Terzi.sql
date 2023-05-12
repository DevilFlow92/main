USE CLC_Cesam
GO



--INSERT INTO dbo.D_TipoIncarico (Codice, Descrizione)
--	VALUES (1033, 'Fast Track - Richiesta Clienti Professionali'),
--	(1034, 'Fast Track - Asset Presso Terzi');

--INSERT INTO dbo.R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
--SELECT CodCliente, 1034, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi FROM dbo.R_Cliente_TipoIncarico
--WHERE dbo.R_Cliente_TipoIncarico.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
--SELECT CodCliente, 1034, CodArea FROM dbo.R_Cliente_TipoIncarico_Area
--WHERE dbo.R_Cliente_TipoIncarico_Area.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_Area.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
--SELECT CodCliente, 1034, CodAttributo FROM dbo.R_Cliente_Attributo
--JOIN dbo.D_AttributoIncarico ON dbo.R_Cliente_Attributo.CodAttributo = dbo.D_AttributoIncarico.Codice
--WHERE dbo.R_Cliente_Attributo.CodCliente = 23
--AND dbo.R_Cliente_Attributo.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
--	VALUES (23, 1034, 1022);

--INSERT INTO dbo.R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
--SELECT IdTemplateDocumento, CodCliente, 1034, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico FROM dbo.R_Cliente_TemplateDocumento
--WHERE dbo.R_Cliente_TemplateDocumento.CodCliente = 23
--AND dbo.R_Cliente_TemplateDocumento.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
--SELECT CodCliente, 1034, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico FROM dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow
--WHERE dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
--SELECT CodCliente, 1034, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita FROM dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
--WHERE dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_AzioneSalvataggioIncarico.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_ControllaDuplicati (CodCliente, CodTipoIncarico, FlagBloccante, FlagAbilita)
--SELECT 23, 1034, 0, 1 FROM dbo.R_Cliente_TipoIncarico_ControllaDuplicati
--WHERE dbo.R_Cliente_TipoIncarico_Co\			ntrollaDuplicati.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_ControllaDuplicati.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
--SELECT CodCliente, 1034, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili FROM dbo.R_Cliente_TipoIncarico_DatoAssociabile
--WHERE dbo.R_Cliente_TipoIncarico_DatoAssociabile.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_DatoAssociabile.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore, CodTipoPersona, OrdinamentoDefault)
--SELECT CodCliente, 1034, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore, CodTipoPersona, OrdinamentoDefault FROM dbo.R_Cliente_TipoIncarico_RuoloRichiedente
--WHERE dbo.R_Cliente_TipoIncarico_RuoloRichiedente.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_RuoloRichiedente.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
--SELECT CodCliente, 1034, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza FROM dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata
--WHERE dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
--SELECT CodCliente, 1034, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli FROM dbo.R_Cliente_TipoIncarico_TipoDocumento
--WHERE dbo.R_Cliente_TipoIncarico_TipoDocumento.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
--SELECT CodCliente, 1034, CodTipoNotaIncarichi FROM dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
--WHERE dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi.CodTipoIncarico = 571

--INSERT INTO dbo.R_ComunicazioneImbarcata_TransizioneIncarico (CodCliente, CodArea, CodTipoIncarico, CodCategoriaComunicazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgentePartenza, FlagAttesaPartenza, FlagUrgenteDestinazione, FlagAttesaDestinazione)
--SELECT CodCliente, CodArea, 1034, CodCategoriaComunicazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgentePartenza, FlagAttesaPartenza, FlagUrgenteDestinazione, FlagAttesaDestinazione FROM dbo.R_ComunicazioneImbarcata_TransizioneIncarico
--WHERE dbo.R_ComunicazioneImbarcata_TransizioneIncarico.CodCliente = 23
--AND dbo.R_ComunicazioneImbarcata_TransizioneIncarico.CodTipoIncarico = 571

--INSERT INTO dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, CodTipoIncarico)
--SELECT CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, 1034 FROM dbo.D_SottoMotivazioneSospeso
--JOIN dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso ON dbo.D_SottoMotivazioneSospeso.Codice = dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso.CodSottoMotivazioneSospeso
--AND dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso.CodCliente = 23
--AND dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso.CodTipoIncarico = 571
--WHERE dbo.D_SottoMotivazioneSospeso.Descrizione like '%asset presso terzi%'

--INSERT INTO dbo.R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo, FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
--SELECT IdTemplateComunicazione, CodCliente, 1034, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo, FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch FROM dbo.R_TemplateComunicazione_StatoWorkflowIncarico
--WHERE dbo.R_TemplateComunicazione_StatoWorkflowIncarico.CodCliente = 23
--AND dbo.R_TemplateComunicazione_StatoWorkflowIncarico.CodTipoIncarico = 571

--INSERT INTO dbo.R_TipoAttivitaPianificata_UfficioAttivitaPianificata (CodTipoAttivitaPianificata, CodUfficioAttivitaPianificata, FlagDefault, CodCliente, CodTipoIncarico)
--SELECT CodTipoAttivitaPianificata, CodUfficioAttivitaPianificata, FlagDefault, CodCliente, 1034 FROM dbo.R_TipoAttivitaPianificata_UfficioAttivitaPianificata
--WHERE dbo.R_TipoAttivitaPianificata_UfficioAttivitaPianificata.CodTipoIncarico = 571
--AND dbo.R_TipoAttivitaPianificata_UfficioAttivitaPianificata.CodCliente = 23

--INSERT INTO dbo.R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch)
--SELECT CodCliente, 1034, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch FROM dbo.R_Transizione_AttivitaPianificata
--WHERE dbo.R_Transizione_AttivitaPianificata.CodCliente = 23
--AND dbo.R_Transizione_AttivitaPianificata.CodTipoIncarico = 571

--INSERT INTO dbo.S_ValutazioneDatiIncarico (Descrizione, CodCliente, CodTipoIncarico, FlagAbilitaInvio, Priorita, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
--SELECT Descrizione, CodCliente, 1034, FlagAbilitaInvio, Priorita, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch FROM dbo.S_ValutazioneDatiIncarico
--WHERE dbo.S_ValutazioneDatiIncarico.CodCliente = 23
--AND dbo.S_ValutazioneDatiIncarico.CodTipoIncarico = 571

--INSERT INTO dbo.R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
--SELECT CodCliente, 1034, CodEsitoTelefonata FROM dbo.R_Cliente_TipoIncarico_EsitoTelefonata
--WHERE dbo.R_Cliente_TipoIncarico_EsitoTelefonata.CodCliente = 23
--AND dbo.R_Cliente_TipoIncarico_EsitoTelefonata.CodTipoIncarico = 571

--INSERT INTO dbo.R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
--SELECT DISTINCT dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodProfiloAccesso, CodCliente, 1034, CodStatoWorkflowIncarico, 0, CodProduttore FROM dbo.R_ProfiloAccesso_AbilitazioneIncarico
--JOIN dbo.D_ProfiloAccesso ON dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodProfiloAccesso = dbo.D_ProfiloAccesso.Codice
--JOIN dbo.S_Operatore ON dbo.D_ProfiloAccesso.Codice = dbo.S_Operatore.CodProfiloAccesso AND dbo.S_Operatore.FlagAttivo = 1
--WHERE dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodCliente = 23
--AND dbo.R_ProfiloAccesso_AbilitazioneIncarico.CodTipoIncarico = 571

--INSERT INTO dbo.S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo, CodPrivilegioEsterno)
--SELECT CodCliente, 1034, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo, CodPrivilegioEsterno FROM dbo.S_MacroControllo
--WHERE dbo.S_MacroControllo.CodCliente = 23
--AND dbo.S_MacroControllo.CodTipoIncarico = 571

--INSERT INTO dbo.S_Controllo (CodDatoAssociabile, IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, NomeStoredProcedureInfoRilevanti, FlagDettaglioEspanso)
--SELECT CodDatoAssociabile, 4120, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, CodEsitoControlloDefault, NomeStoredProcedurePreparatoria, Ordinamento, CodTipoRilievoControlloDefault, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, NomeStoredProcedureInfoRilevanti, FlagDettaglioEspanso FROM dbo.S_Controllo
--WHERE dbo.S_Controllo.IdTipoMacroControllo = 2719

--INSERT INTO dbo.R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
--SELECT CodCliente, 1034, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, 4120, FlagCreazione FROM dbo.R_Transizione_MacroControllo
--WHERE dbo.R_Transizione_MacroControllo.CodCliente = 23
--AND dbo.R_Transizione_MacroControllo.CodTipoIncarico = 571

--INSERT INTO dbo.R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
--SELECT CodCliente, 1034, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, 12539, IdMacroControllo, FlagAbilitaBlocco FROM dbo.R_EsitoControllo_BloccoTransizione
--WHERE dbo.R_EsitoControllo_BloccoTransizione.CodCliente = 23
--AND dbo.R_EsitoControllo_BloccoTransizione.CodTipoIncarico = 571

--DELETE FROM dbo.R_TemplateComunicazione_StatoWorkflowIncarico
--WHERE IdTemplateComunicazione = 18480

--INSERT INTO dbo.R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico)
--SELECT 18480, CodCliente, CodTipoIncarico
--fROM dbo.R_Cliente_TipoIncarico
--WHERE CodCliente = 23 AND CodTipoIncarico IN (1033,1034)


/*
22320	In Attesa verifiche uffici competenti
22321	Riscontro ricevuto da uffici competenti
30144	Generazione Controlli CF
*/


/***** inserire poi ****/
USE CLC_Cesam
--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico)
--SELECT 23, 1034, Codice, 9
--FROM D_StatoWorkflowIncarico
--WHERE codice IN (22320	--In Attesa verifiche uffici competenti
--,22321	--Riscontro ricevuto da uffici competenti
--,30144	--Generazione Controlli CF
--)
/***********************/

SELECT * FROM D_StatoWorkflowIncarico
WHERE Descrizione LIKE '%variaz%'

--INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza,CodStatoWorkflowIncaricoDestinazione, FlagCreazione)
--SELECT 2323, 6500, 30144, 0 UNION
--SELECT 2323, 30144, 8570, 0 UNION
--SELECT 2323, 30144, 22320, 0 UNION
--SELECT 2323, 22320, 22321, 0 UNION
--SELECT 2323, 22321, 8570, 0 UNION
--SELECT 2323, 22321, 8500, 0 

SELECT 20857

--INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione,TestoHelp,  FlagGenerazioneDifferita, Ordinamento)
--	VALUES (23, 1034, 'MacroControlloAlwaysValid', 'Controlli CF'
--				,null 
--				,0,1)


--INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza,CodStatoWorkflowIncaricoDestinazione, IdTipoMacroControllo, FlagCreazione)
--VALUES (23, 1034, 6500, 30144,4122 --da inserire
--,0)

--INSERT INTO S_Controllo (IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo, FlagEsitoPositivoConRiserva
--, FlagEsitoNegativo, FlagNotaObbligatoria, Descrizione, TestoHelp, Ordinamento, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo, FlagDettaglioEspanso)
--VALUES (4122 --da inserire
--,'CESAM_AZ_FastTrack_ControlloCF', 1,1,0,1,0,'Controllo Popolamento CF'
--,'Controlla se il CF è presente, se i contatti sono inseriti e se rientra in whitelist per la courtesy mail FastTrack'
--,1,0,0,0,1,0
--)


--INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza
--, CodStatoWorkflowIncaricoDestinazione, CodGiudizioControllo, IdControllo, FlagAbilitaBlocco)
--VALUES (23,1034,30144,8570,4,12542 --da inserire
--,1
--)


--UPDATE R_ProfiloAccesso_AbilitazioneIncarico
--SET FlagAbilita = 1
--WHERE CodCliente = 23
--AND CodTipoIncarico = 1034
--AND FlagAbilita = 0

