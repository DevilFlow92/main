
/*gruppo tabelle setup Generale incarichi */
--------------------------------R_Cliente_TipoIncarico_AzioneSalvataggioIncarico-------------------------------- 

--INSERT INTO R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza,
--CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
	SELECT
		23
	   ,747
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
	   ,Descrizione
	FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
	JOIN app.D_AzioneSalvataggioIncarico ON R_Cliente_TipoIncarico_AzioneSalvataggioIncarico.CodAzioneSalvataggioIncarico = D_AzioneSalvataggioIncarico.Codice
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23



/*gruppo tabelle setup Generatore documenti */
--------------------------------R_Cliente_TemplateDocumento-------------------------------- 
--INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
	SELECT
		IdTemplateDocumento
	   ,23
	   ,747
	   ,Priorita
	   ,CodProduttore
	   ,CodTipoProcessoSelfId
	   ,IdFaseLavorazioneIncarico
	   --,PercorsoFile
	   --,Descrizione
	FROM R_Cliente_TemplateDocumento
	--JOIN S_TemplateDocumento ON R_Cliente_TemplateDocumento.IdTemplateDocumento = S_TemplateDocumento.IdTemplate
	--JOIN D_Documento ON S_TemplateDocumento.CodTipoDocumento = D_Documento.Codice
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico,
--FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
	SELECT
		23
	   ,747
	   ,CodTipoWorkflow
	   ,FlagMostraElementiSubincarichi
	   ,CodTabIncaricoDefault
	   ,FlagMostraElementiIncarichiMaster
	   ,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
	   ,FlagAssegnaAutomaticamenteAreaDaOperatore
	   ,FlagMostraWorkflowSubincarichi
	FROM R_Cliente_TipoIncarico
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup */

--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT
		23
	   ,747
	   ,CodEsitoTelefonata
	FROM R_Cliente_TipoIncarico_EsitoTelefonata

	WHERE CodTipoIncarico = 674
	AND CodCliente = 23



/*gruppo tabelle setup Archivio Qtask */
--------------------------------R_Cliente_Archivio-------------------------------- 
SELECT * 
FROM R_Cliente_Archivio
WHERE CodCliente = 23
AND CodTipoIncarico = 674


SELECT * FROM D_Scaffale
JOIN S_Archivio ON D_Scaffale.Codice = S_Archivio.CodScaffale
WHERE Codice = 173


SELECT * FROM R_Cliente_Archivio
WHERE CodScaffaleInizio = 173
ORDER BY CodiceSezioneInizio, CodicePianoInizio, CodicePianoFine

--INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
SELECT
	23 CodCliente
   ,747 CodTipoIncarico
   ,2 CodTipoArchiviazione
   ,173 CodScaffaleInizio
   ,1 CodiceSezioneInizio
   ,11 CodicePianoInizio
   ,1 CodiceScatolaInizio
   ,173 CodScaffaleFine
   ,1 CodiceSezioneFine
   ,11 CodicePianoFine
   ,4 CodiceScatolaFine
   ,9000 NumeroDocumenti
   ,0 FlagTemporaneo
   ,NULL CodDocumento



/*gruppo tabelle setup Tabelle Antiriciclaggio Ruolo Richiedente */
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore)
	SELECT
		23
	   ,747
	   ,CodRuoloRichiedente
	   ,FlagVisualizzaPersonaRimossa
	   ,FlagEsecutore
	   --,descrizione
	FROM R_Cliente_TipoIncarico_RuoloRichiedente
	--JOIN D_RuoloRichiedente ON CodRuoloRichiedente = d_ruoloRichiedente.codice
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Codice Stampa */
--------------------------------R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa (CodCliente, CodTipoIncarico, CodTipoIncaricoRicerca, CodStatoWorkflowIncaricoRicerca)
--	SELECT
--		23
--	   ,747
--	   ,CodTipoIncaricoRicerca
--	   ,CodStatoWorkflowIncaricoRicerca
--	FROM R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa
--	WHERE CodTipoIncarico = 674
--	AND CodCliente = 23


/*gruppo tabelle setup Abilitazioni operatori Q_Task Profili accesso Extranet 3.0 - profili Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico-------------------------------- 
--INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,747
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	   ,CodProduttore
	FROM R_ProfiloAccesso_AbilitazioneIncarico
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi */
--------------------------------R_Cliente_TipoIncarico_ControllaDuplicati-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_ControllaDuplicati (CodCliente, CodTipoIncarico, FlagBloccante, FlagAbilita)
	SELECT
		23
	   ,747
	   ,FlagBloccante
	   ,FlagAbilita
	FROM R_Cliente_TipoIncarico_ControllaDuplicati
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


	

/*gruppo tabelle setup Documenti Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */
--------------------------------R_DocumentoImbarcato_TransizioneIncarico-------------------------------- 
--INSERT INTO R_DocumentoImbarcato_TransizioneIncarico (CodCliente, CodTipoIncarico, CodTipoDocumento, CodOrigineDocumento, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza,
--CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagAbilita)
	SELECT
		23
	   ,747
	   ,CodTipoDocumento
	
	   ,CodOrigineDocumento
	   ,CodStatoWorkflowIncaricoPartenza
	   ,CodAttributoIncaricoPartenza
	   ,FlagUrgentePartenza
	   ,FlagAttesaPartenza
	   ,CodStatoWorkflowIncaricoDestinazione
	   ,CodAttributoIncaricoDestinazione
	   ,FlagUrgenteDestinazione
	   ,FlagAttesaDestinazione
	   ,FlagAbilita
	   --,partenza.Descrizione
	   --,destinazione.Descrizione
	FROM R_DocumentoImbarcato_TransizioneIncarico
	--JOIN D_Documento ON R_DocumentoImbarcato_TransizioneIncarico.CodTipoDocumento = D_Documento.Codice
	--JOIN D_StatoWorkflowIncarico partenza ON CodStatoWorkflowIncaricoPartenza = partenza.Codice
	--JOIN D_StatoWorkflowIncarico destinazione ON CodStatoWorkflowIncaricoDestinazione = destinazione.Codice
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabileCollegabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile (CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile)
	SELECT
		23
	   ,CodTipoIncaricoMaster
	   ,CodTipoSubIncarico
	   ,CodDatoAssociabileCollegabile
	   ,FlagClonazione
	   ,CodRuoloRichiedenteCollegabile
	FROM R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE CodTipoIncaricoMaster = 674
	AND CodCliente = 23
	UNION
	SELECT
		23
	   ,CodTipoIncaricoMaster
	   ,747
	   ,CodDatoAssociabileCollegabile
	   ,FlagClonazione
	   ,CodRuoloRichiedenteCollegabile
	FROM R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE CodTipoSubIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Operazione Imbarco Mail */
--------------------------------R_Cliente_MailboxImbarcoIncarichi-------------------------------- 
--INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
	SELECT
		23
	   ,747
	   ,IdMailboxImbarcoIncarichi
	   --,Descrizione
	FROM R_Cliente_MailboxImbarcoIncarichi
	--JOIN S_MailboxImbarcoIncarichi ON R_Cliente_MailboxImbarcoIncarichi.IdMailboxImbarcoIncarichi = S_MailboxImbarcoIncarichi.IdMailbox
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
	   ,747
	   ,CodDatoAssociabile
	   ,Cardinalita
	   ,FlagMostraInRicerca
	   ,ElementiSubincarichiVisualizzabili
	   --,Descrizione
	FROM R_Cliente_TipoIncarico_DatoAssociabile
	--JOIN app.D_DatoAssociabile ON R_Cliente_TipoIncarico_DatoAssociabile.CodDatoAssociabile = D_DatoAssociabile.Codice
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Mailer Prodotti CLC */
--------------------------------R_TemplateComunicazione_StatoWorkflowIncarico-------------------------------- 
--INSERT INTO R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna,
--CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione,
--CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo,
--FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo,
--CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica,
--CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
	SELECT
		IdTemplateComunicazione
	   ,23
	   ,747
	   ,CodStatoWorkflow
	   ,R_TemplateComunicazione_StatoWorkflowIncarico.FlagUrgente
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
	   --,Descrizione
	FROM R_TemplateComunicazione_StatoWorkflowIncarico
	--JOIN S_TemplateComunicazione ON R_TemplateComunicazione_StatoWorkflowIncarico.IdTemplateComunicazione = S_TemplateComunicazione.IdTemplate
	--JOIN D_TipoComunicazione ON S_TemplateComunicazione.CodTipoComunicazione = D_TipoComunicazione.Codice
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
	   ,747
	   ,CodStatoWorkflowIncarico
	   ,CodMacroStatoWorkflowIncarico
	   ,Ordinamento
	   ,IdFaseLavorazioneIncarico
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncaricoAssociabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT
		23
	   ,747
	   ,CodTipoIncaricoAssociabile
	FROM R_Cliente_TipoIncaricoAssociabile
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23
	UNION 
	SELECT 23, CodTipoIncarico, 747
	FROM R_Cliente_TipoIncaricoAssociabile
	WHERE CodTipoIncaricoAssociabile = 674



/*gruppo tabelle setup Piano di rientro Qtask */


--------------------------------R_Cliente_TipoIncarico_ModalitaPagamento-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_ModalitaPagamento (CodCliente, CodTipoIncarico, CodModalitaPagamento)
	SELECT
		23
	   ,747
	   ,CodModalitaPagamento
	FROM R_Cliente_TipoIncarico_ModalitaPagamento
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23


/*gruppo tabelle setup Telefonata */
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
	SELECT
		23
	   ,747
	   ,CodMotivoTelefonata
	FROM R_Cliente_TipoIncarico_MotivoTelefonata
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23

/*gruppo tabelle setup Note incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
	   ,747
	   ,CodTipoNotaIncarichi
	FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23

/*gruppo tabelle setup Sospesi */
--------------------------------R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso-------------------------------- 
--INSERT INTO R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, CodTipoIncarico)
	SELECT
		CodMotivazioneSospeso
	   ,CodSottoMotivazioneSospeso
	   ,CodModalitaSospeso
	   ,FlagAttivo
	   ,23
	   ,747 CodTipoIncarico
	FROM R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23
	

/*gruppo tabelle setup Attività pianificate incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoAttivitaPianificata-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente,
--FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	SELECT
		23
	   ,747
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
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23

/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste Aree incarichi QTask */
--------------------------------R_Cliente_TipoIncarico_Area-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		23
	   ,747
	   ,CodArea
	FROM R_Cliente_TipoIncarico_Area
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23

/*gruppo tabelle setup Documenti Generatore documenti Documenti Q-Task Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_TipoDocumento-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
	   ,747
	   ,CodDocumento
	   ,FlagVisualizza
	   ,CodiceRiferimento
	   ,CodOggettoControlli
	FROM R_Cliente_TipoIncarico_TipoDocumento
	WHERE CodTipoIncarico = 674
	AND CodCliente = 23




--	INSERT INTO dbo.Z_Cliente_TipoIncarico (CodCliente, CodSistemaEsterno, CodiceTipoIncaricoCliente, CodTipoIncarico, CodiceClasseProdottoDispositiveCliente)
--    VALUES (23, 10, '21', 747, 'AZ_ALICROWD'),
--    (23, 10, '41', 747, 'AZ_ALICROWD');

 

--INSERT INTO dbo.D_ClasseProdottoDispositive (Codice, Descrizione)
--    VALUES (18, 'ALICrowd');

 

--INSERT INTO dbo.Z_Cliente_ClasseProdottoDispositive (CodCliente, CodSistemaEsterno, CodiceClasseProdottoDispositive, CodClasseProdottoDispositive)
--    VALUES (23, 10, 'AZ_ALICROWD', 18);



SELECT * FROM S_Operatore
WHERE UserName = 'sara.dulgheru_qtask'

SELECT * FROM app.D_ModalitaAutenticazione
