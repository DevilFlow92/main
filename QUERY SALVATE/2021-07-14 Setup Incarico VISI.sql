USE clc

GO

SELECT * FROM D_TipoIncarico
ORDER BY Codice DESC


--INSERT INTO D_TipoIncarico (Codice, Descrizione)
--	VALUES (776, 'Visi Antiriciclaggio POC');


 /*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico,
--FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
	SELECT
		23
	   ,776
	   ,31613 CodTipoWorkflow
	   ,FlagMostraElementiSubincarichi
	   ,CodTabIncaricoDefault
	   ,FlagMostraElementiIncarichiMaster
	   ,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
	   ,FlagAssegnaAutomaticamenteAreaDaOperatore
	   ,FlagMostraWorkflowSubincarichi
	FROM R_Cliente_TipoIncarico
	WHERE codtipoincarico = 776
	AND codcliente = 23 
	
	/*gruppo tabelle
setup */
--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
	SELECT
		23
	   ,776
	   ,CodEsitoTelefonata
	FROM R_Cliente_TipoIncarico_EsitoTelefonata
	WHERE codtipoincarico = 776
	AND codcliente = 23 

 /*gruppo tabelle setup  Ruolo Richiedente */
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore)
	SELECT
		23
	   ,CodTipoIncarico
	   ,CodRuoloRichiedente
	   ,FlagVisualizzaPersonaRimossa
	   ,FlagEsecutore
	FROM R_Cliente_TipoIncarico_RuoloRichiedente
	WHERE codtipoincarico = 776
	AND codcliente = 23 
	
/*gruppo tabelle setup Abilitazioni operatori Q_Task Profili accesso Extranet 3.0 - profili Setup operatori Cefin Isp */
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
	   ,codcliente
	   ,CodTipoIncarico
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	   ,CodProduttore
	FROM R_ProfiloAccesso_AbilitazioneIncarico
	WHERE codtipoincarico = 776
	AND codcliente = 23 

/*gruppo tabelle setup Mailer Prodotti CLC */
--------------------------------S_MittenteMailIncarichi--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, CodRuoloOperatoreIncarico, Email, Firma, CodClientePratica, CodProdottoPratica, CodProduttorePratica, CodMacroCategoriaTicket, NomeVisualizzato, CodBancaInterna)
	SELECT
		23
	   ,776
	   ,CodRuoloOperatoreIncarico
	   ,Email
	   ,Firma
	   ,CodClientePratica
	   ,CodProdottoPratica
	   ,CodProduttorePratica
	   ,CodMacroCategoriaTicket
	   ,NomeVisualizzato
	   ,CodBancaInterna
	FROM S_MittenteMailIncarichi
	WHERE codtipoincarico = 776
	AND codcliente = 23 

/*gruppo tabelle setup Workflow incarichi Attributi QT */
--------------------------------R_Cliente_Attributo--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
	SELECT CodCliente, CodTipoIncarico, CodAttributo
	FROM R_Cliente_Attributo
	WHERE CodCliente = 23 AND CodTipoIncarico = 776


/*gruppo tabelle setup Operatori
QTask Setup operatori Cefin Isp */
--------------------------------R_Cliente_AssegnatarioIncarico--------------------------------
--INSERT INTO [db-clc-setupbt].clc.R_Cliente_AssegnatarioIncarico (CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico)
	SELECT
		23
	   ,776
	   ,CodProfiloAccesso
	   ,CodRuoloOperatoreIncarico
	FROM dbo.R_Cliente_AssegnatarioIncarico
	WHERE codtipoincarico = 776
	AND codcliente = 23 
	

 /*gruppo tabelle setup Mailer Prodotti CLC */
--------------------------------S_ValutazioneDatiIncarico--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.S_ValutazioneDatiIncarico (Descrizione, CodCliente, CodTipoIncarico, FlagAbilitaInvio, Priorita, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro,
--CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione,
--CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo,
--CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket,
--CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
	SELECT
		'AZ - AML - VISI' Descrizione
	   ,23
	   ,776
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
	   ,NomeFunzioneMatch
	FROM S_ValutazioneDatiIncarico
	WHERE codtipoincarico = 776
	AND codcliente = 23 
	

	--INSERT INTO [db-clc-setupbt].clc.dbo.R_TemplateComunicazione_TransizioneIncarico (IdTemplateComunicazione, CodStatoWorkflowPartenza
	--, CodStatoWorkflowDestinazione,  CodCliente, CodTipoIncarico, FlagCreazione)
	SELECT IdTemplateComunicazione, CodStatoWorkflowPartenza, CodStatoWorkflowDestinazione,  CodCliente, CodTipoIncarico, FlagCreazione
	FROM R_TemplateComunicazione_TransizioneIncarico
	WHERE CodCliente = 23 AND CodTipoIncarico = 776
	
/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste Tabelle Azimut */
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili
	FROM R_Cliente_TipoIncarico_DatoAssociabile
	WHERE codtipoincarico = 776
	AND codcliente = 23 
	

/*gruppo tabelle setup Workflow incarichi Extranet 3.0 -
Richieste – Workflow/Transizioni Tabelle Azimut */
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
	   ,CodTipoIncarico
	   ,CodStatoWorkflowIncarico
	   ,CodMacroStatoWorkflowIncarico
	   ,Ordinamento
	   ,IdFaseLavorazioneIncarico
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE codtipoincarico = 776
	AND codcliente = 23 	

/*gruppo tabelle setup Generale incarichi Extranet
3.0 - Richieste */
--------------------------------R_Cliente_TipoIncaricoAssociabile--------------------------------
--NON FATTA
--INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT
		23
	   ,776
	   ,CodTipoIncaricoAssociabile
	FROM [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncaricoAssociabile
	WHERE codtipoincarico = 288
	AND codcliente = 23 
	

 /*gruppo tabelle setup Telefonata */
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
	SELECT CodCliente
		  ,CodTipoIncarico
		  ,CodMotivoTelefonata FROM R_Cliente_TipoIncarico_MotivoTelefonata
	WHERE codcliente = 23
	AND codtipoincarico = 776

/*gruppo tabelle setup Note incarichi */
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT CodCliente, CodTipoIncarico, CodTipoNotaIncarichi FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE codcliente = 23
	AND CodTipoIncarico = 776

	
/*gruppo tabelle setup Sospesi */
--------------------------------R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso--------------------------------
--INSERT INTO [DB-CLC-SETUPBT].clc.dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, CodTipoIncarico)
	SELECT
		CodMotivazioneSospeso
	   ,CodSottoMotivazioneSospeso
	   ,CodModalitaSospeso
	   ,FlagAttivo
	   ,23
	   ,776 CodTipoIncarico
	FROM [db-clc-setupbt].clc.dbo.R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
	WHERE codtipoincarico = 288
	AND codcliente = 23 

	--SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_SottoMotivazioneSospeso
	--EXCEPT
	--SELECT * FROM D_SottoMotivazioneSospeso

	
 /*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste Aree incarichi QTask */
--------------------------------R_Cliente_TipoIncarico_Area--------------------------------

--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		CodCliente
	   ,CodTipoIncarico
	   ,CodArea
	FROM dbo.R_Cliente_TipoIncarico_Area
	WHERE codtipoincarico = 776
	AND codcliente = 23 
	
/*gruppo tabelle setup
Documenti Generatore documenti Documenti Q-Task Extranet 3.0 - Richieste */
--------------------------------R_Cliente_TipoIncarico_TipoDocumento--------------------------------
--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
SELECT 23, 776, Codice, 1,NULL,NULL
FROM D_Documento
WHERE Codice in (
1		--Documento d'identita'- Carta d'identita', Passaporto, Patente(fotocopia)
,9		--Codice fiscale (fotocopia)
,102		--Altro documento generico
,1452	--Modello 730
,1539	--Stampa Mail
,1572	--Cover
,1646	--Questionario MIFID firmato dal Cliente SGR
,1664	--Ricerca INFO Internet
,1667	--Contratto di Consulenza / Collocamento firmato
,1670	--Visura Camerale
,1859	--Cover Rispedito
,1923	--Modulo FATCA
,3311	--Dichiarazione_PF grado di parentela PF/cliente
,3335	--Modulo adeguata verifica persona fisica
,3336	--Modulo adeguata verifica persona NON fisica
,3338	--Scheda raccolta dati Persona Fisica
,3339	--Scheda raccolta dati Persona non fisica
,3348	--Atto notorio
,3350	--Scheda racc.dati privacy
,3367	--Corrispondenza
,3381	--Specimen firmato
,3383	--Contratto di Consulenza e Collocamento firmato
,3385	--Scheda finanziaria MIFID firmata
,5277	--Fatca CRS persone giuridiche
,5278	--Fatca CRS persone fisiche
,5589	--Documento d'identità - Codice Fiscale
,5893	--Questionario MIFID firmato dal Cliente AFI
,5953	--Contratto persona fisica SGR
,5954	--Contratto persona fisica AFI
)


SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_Documento
WHERE codice IN (259773,259818)

/* GIA FATTA 
	--INSERT INTO --[DB-CLC-SETUPBT].CLC.dbo.
	--D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
	SELECT 259773 Codice,'Estratto VISI AML' Descrizione,'Estratto VISI AML' Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine
	FROM [DB-CLC-SETUPBT].CLC.dbo.D_Documento ddoc
	WHERE ddoc.Codice = 256876

	--UPDATE d_documento
	--SET descrizione = 'Documento VISI FEQ',
	--etichetta = 'Documento VISI FEQ',
	--CodOggettoControlli = 1
	--WHERE codice = 259773

	--INSERT INTO --[DB-CLC-SETUPBT].clc.dbo.
	--D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
	--SELECT 259818, 'Estratto VISI','Estratto VISI',1,1,NULL,1,NULL,0,NULL
	*/

	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT 23, 776, Codice, 1, NULL, NULL
	FROM D_Documento
	WHERE Codice IN (259773,259818)

	/* da non fare in preprod. c'è già la insert sopra pronta  (copia da test interno as-is) 
	--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT CodCliente, CodTipoIncarico, Codice, 12, 1, NULL
	FROM R_Cliente_TipoIncarico
	JOIN D_StatoWorkflowIncarico ON CodCliente = 23 AND CodTipoIncarico = 776 AND Codice = 6500
	UNION
	SELECT CodCliente, CodTipoIncarico, Codice, 9, NULL, 15 
	FROM R_Cliente_TipoIncarico
	JOIN D_StatoWorkflowIncarico ON CodCliente = 23 AND CodTipoIncarico = 776
	AND codice IN (8570,230,22531,1061,245,11475,22532,270)
	UNION 
	SELECT CodCliente, CodTipoIncarico, Codice, 14, NULL, NULL
	FROM R_Cliente_TipoIncarico
	JOIN D_StatoWorkflowIncarico ON CodCliente = 23 AND CodTipoIncarico = 776
	AND codice = 820
	*****************************************************************
	*/
	


	--INSERT INTO [db-clc-setupbt].clc.dbo.S_WorkflowIncarico(CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione)
	--select 31613, NULL	,6500	,1 union all
	--select 31613, 230	,245	,0 union all
	--select 31613, 230	,22531	,0 union all
	--select 31613, 245	,11475	,0 union all
	--select 31613, 270	,820	,0 union all
	--select 31613, 1061	,820	,0 union all
	--select 31613, 6500	,8570	,0 union all
	--select 31613, 8570	,230	,0 union all
	--select 31613, 11475 ,270	,0 union all
	--select 31613, 11475 ,22532	,0 union all
	--select 31613, 22531 ,245	,0 union all
	--select 31613, 22531 ,1061	,0 union all
	--select 31613, 22532 ,270	,0 union all
	--select 31613, 22532 ,820	,0

	--AP check controllo videointervista su LiveID

	--SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_TipoAttivitaPianificataIncarico
	--WHERE Descrizione LIKE '%identifica%'

	--SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_TipoAttivitaPianificataIncarico
	--ORDER BY Codice DESC

	--già fatta in setup
	--INSERT INTO D_TipoAttivitaPianificataIncarico (Codice, Descrizione, Nota)
	--VALUES (1438, 'Controllo Videointervista su LiveID', null);


	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch
	--, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	--VALUES (23, 776, null, 1438, null, 2880, null, 0, 0, null, 1, null);

	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione,  CodStatoWorkflowIncaricoDestinazione,    IdTipoAttivitaInserimento, FlagStatoWorkflowModificato
	--, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita)
	--Apertura
	SELECT CodCliente, CodTipoIncarico, 0, 230, IdRelazione, 0, 0,0,0,1
	FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
	WHERE CodCliente = 23 AND CodTipoIncarico = 776 AND CodTipoAttivitaPianificata = 1438
	
	--Chiusura
	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza,  CodTipoAttivitaChiusura
	--, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita)
	SELECT CodCliente, CodTipoIncarico, 0, 230, CodTipoAttivitaPianificata,0,0,0,0,1
	FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
	WHERE CodCliente = 23 AND CodTipoIncarico = 776
	AND CodTipoAttivitaPianificata = 1438


	--AP per controllo acquisizione firma digitale

	--già fatta in setup
	--INSERT INTO D_TipoAttivitaPianificataIncarico (Codice, Descrizione, Nota)
	--VALUES (1439, 'Richiesta Firma Digitale', NULL);
	
	--INSERT INTO [db-clc-setupbt].clc.dbo.R_ProfiloAccesso_AssegnamentoAttivitaPianificata (CodProfiloAccesso, CodUfficioAttivitaPianificata)
	--VALUES (839, 44)
	--,(5,44);


--INSERT INTO [db-clc-setupbt].clc.dbo.R_TipoAttivitaPianificata_UfficioAttivitaPianificata (CodTipoAttivitaPianificata, CodUfficioAttivitaPianificata, FlagDefault, CodCliente, CodTipoIncarico)
	SELECT Codice, 44, 1, 23,NULL 
	FROM D_TipoAttivitaPianificataIncarico
	WHERE Codice IN (1438,1439)

	--	INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch
	--, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	--VALUES (23, 776, null, 1439, null, 2880, null, 0, 0, null, 1, null);
	
	--Apertura
	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione,  CodStatoWorkflowIncaricoDestinazione,    IdTipoAttivitaInserimento, FlagStatoWorkflowModificato
	--, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita)
	
	--SELECT CodCliente, CodTipoIncarico, 0, 11475, IdRelazione, 0, 0,0,0,1
	--FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
	--WHERE CodCliente = 23 AND CodTipoIncarico = 776 AND CodTipoAttivitaPianificata = 1439


	----Chiusura
	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza,  CodTipoAttivitaChiusura
	--, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita)
	--SELECT CodCliente, CodTipoIncarico, 0, 11475, CodTipoAttivitaPianificata,0,0,0,0,1
	--FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
	--WHERE CodCliente = 23 AND CodTipoIncarico = 776
	--AND CodTipoAttivitaPianificata = 1439

	/* non fare. abbiamo già il setup pronto per tipo incarico in test interno as is 
	--Automatismo transizione in seguito a Imbarco documento visi FEQ
	--INSERT INTO [db-clc-setupbt].clc.dbo.R_DocumentoImbarcato_TransizioneIncarico (CodCliente, CodTipoIncarico, CodTipoDocumento, CodOrigineDocumento, CodStatoWorkflowIncaricoPartenza,    CodStatoWorkflowIncaricoDestinazione,    FlagAbilita)
	SELECT CodCliente, CodTipoIncarico, 259773 CodDocumento, 14, CodStatoWorkflowIncarico, 270, 1
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodCliente = 23 AND CodTipoIncarico = 776
	AND CodStatoWorkflowIncarico IN (11475,22532)


	--Automatismo transizione in seguito a imbarco estratto visi
	--INSERT INTO [db-clc-setupbt].clc.dbo.R_DocumentoImbarcato_TransizioneIncarico (CodCliente, CodTipoIncarico, CodTipoDocumento
	--, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagAbilita)
	SELECT CodCliente, CodTipoIncarico, 259818, CodStatoWorkflowIncarico, 245,1
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE codcliente = 23 AND CodTipoIncarico = 776
	AND CodStatoWorkflowIncarico IN (230,22531)

	***************************************************************************************
	*/
	
	--INSERT INTO [DB-CLC-SETUPBT].clc.dbo.R_DocumentoImbarcato_TransizioneIncarico (CodCliente, CodTipoIncarico, CodTipoDocumento, CodOrigineDocumento, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagAbilita)
	SELECT CodCliente, CodTipoIncarico, CodTipoDocumento, CodOrigineDocumento, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagAbilita
	FROM R_DocumentoImbarcato_TransizioneIncarico
	WHERE CodCliente = 23 AND CodTipoIncarico = 776


	--Motivi transizione lavorazione conclusa
	--SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_MotivoTransizione
	--WHERE Descrizione LIKE '%sblocco oper%'

	--SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_MotivoTransizione
	--ORDER BY Codice DESC

	--già fatta in setup
	--INSERT INTO D_MotivoTransizione (Codice, Descrizione)
	--VALUES (180, 'Sblocco Operatività su Appian')
	--,(181,'Blocco Operatività su Appian')

	--;

	SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_GruppoMotiviTransizione
	WHERE Descrizione LIKE '%esit%'

	SELECT * FROM [DB-CLC-SETUPBT].clc.dbo.D_GruppoMotiviTransizione
	ORDER BY Codice DESC

	--già fatta in setup
	--INSERT INTO D_GruppoMotiviTransizione (Codice, Descrizione)
	--VALUES (54, 'Review Esito VISI');
	


	--INSERT INTO [db-clc-setupbt].clc.dbo.R_GruppoMotiviTransizione_MotivoTransizione (CodGruppoMotiviTransizione, CodMotivoTransizione)
	SELECT D_GruppoMotiviTransizione.Codice, D_MotivoTransizione.Codice
	FROM D_GruppoMotiviTransizione
	JOIN D_MotivoTransizione ON D_GruppoMotiviTransizione.Codice = 54 
	AND D_MotivoTransizione.Codice IN (180,181)

	--INSERT INTO [db-clc-setupbt].clc.dbo.R_Cliente_TipoIncarico_GruppoMotiviTransizione (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza,    CodStatoWorkflowIncaricoDestinazione,    CodGruppoMotiviTransizione
	--, FlagBloccante, FlagNota, FlagNotaObbligatoria, LunghezzaMassimaNota)
		SELECT CodCliente
			  ,CodTipoIncarico
			  ,CodStatoWorkflowIncaricoPartenza
			  ,FlagAttesaPartenza
			  ,FlagUrgentePartenza
			  ,CodAttributoIncaricoPartenza
			  ,CodStatoWorkflowIncaricoDestinazione
			  ,FlagAttesaDestinazione
			  ,FlagUrgenteDestinazione
			  ,CodAttributoIncaricoDestinazione
			  ,CodGruppoMotiviTransizione
			  ,FlagBloccante
			  ,FlagNota
			  ,FlagNotaObbligatoria
			  ,LunghezzaMassimaNota 
		FROM R_Cliente_TipoIncarico_GruppoMotiviTransizione
		WHERE codcliente = 23 AND CodTipoIncarico = 776


	/***** CONTROLLO DATAENTRY ******/

	--CONNETTERSI A SETUP [DB-CLC-SETUPBT]

	USE CLC
	DECLARE @IdMacroControllo INT
	,@IdControllo INT

	INSERT INTO S_MacroControllo (CodCliente, CodTipoIncarico,NomeStoredProcedure,  Descrizione,  FlagGenerazioneDifferita, Ordinamento)
	SELECT 23, 776,'MacroControlloAlwaysValid', 'Controlli Bloccanti DataEntry', 0, 1

	SET @IdMacroControllo = (SELECT SCOPE_IDENTITY())

	INSERT INTO S_Controllo ( IdTipoMacroControllo, NomeStoredProcedure, FlagEsitoNonDefinito, FlagEsitoPositivo
	, FlagEsitoPositivoConRiserva, FlagEsitoNegativo
	, FlagNotaObbligatoria, Descrizione,   Ordinamento
	, FlagSolaLettura, FlagCommenti, FlagCommentiObbligatori, CodCategoriaControllo
	, FlagDettaglioEspanso)
	SELECT @IdMacroControllo, 'CESAM_AZ_BeeWise_ControlloDEPersonaCensita', 0,1,0,1,0, 'Controllo DataEntry Persona Censita',1,0,0,0,1,0
	
	SET @IdControllo = (SELECT SCOPE_IDENTITY())

	INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoDestinazione
	, IdTipoMacroControllo, FlagCreazione)
	SELECT 23, 776, 6500, @IdMacroControllo, 1

	INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodAttributoIncaricoDestinazione
	,IdTipoMacroControllo, FlagCreazione)
	SELECT 23,776,1194,@IdMacroControllo,0

	INSERT INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza
	, CodStatoWorkflowIncaricoDestinazione, CodGiudizioControllo, IdControllo, FlagAbilitaBlocco)
	SELECT CodCliente, CodTipoIncarico, NULL, CodStatoWorkflowIncarico, 4, @IdControllo,1
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodCliente = 23 AND CodTipoIncarico = 776
	AND CodStatoWorkflowIncarico IN (230,11475)

	
	/* setup template documento da firmare */
	USE CLC
	--RIMANERE SU DB-CLC-SETUPBT

	--DECLARE @idtemplate INT
	--INSERT INTO S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, FlagForzaCultureIt, FlagGenerazioneAsincrona)
	--VALUES (1, 259773, 'CESAM\Azimut\Antiriciclaggio\VISI\DocumentoDaFirmare.dot', 1, 0, 1, 0);
	
	--SET @idtemplate = (SELECT SCOPE_IDENTITY())

	--INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
	--VALUES (@idtemplate, 23, 776, DEFAULT, NULL, NULL, 15);
	   
	--INSERT INTO R_TransizioneIncarico_GenerazioneDocumento (CodCliente, CodTipoIncarico, FlagCreazione,      CodStatoWorkflowIncaricoDestinazione,     IdTemplateDocumento, FlagXml, FlagPdf, Priorita)
	--SELECT 23, 776, 0, 245,@idtemplate,0,1,10



	/************* PARTE PER LA FIRMA ************/

	--Abilita tab
	SELECT * FROM app.D_DatoAssociabile
	WHERE Descrizione LIKE '%richiesto%'

	SELECT * FROM R_Cliente_TipoIncarico_DatoAssociabile
	WHERE CodCliente = 23 AND CodTipoIncarico = 776 AND CodDatoAssociabile = 85

	--GIA' FATTA
	--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	--VALUES (23, 776, 85, null, 1, 1);

	--creiamo fase lavorazione (contenitore per far funzionare tutto lato qtask)
	SELECT * FROM S_FaseLavorazioneIncarico
	WHERE Descrizione LIKE '%FIRMA%'


	--INSERT INTO S_FaseLavorazioneIncarico (Descrizione, Etichetta, Ordinamento)
	--VALUES ('Firma Documento con Namirial', 'Firma Documento con Namirial', 1);

	--SELECT SCOPE_IDENTITY()

	---CAMBIARE ID FASE LAVORAZIONE INCARICO. IN TEST E' 15, IN PREPROD SARA' DIVERSO
	--INSERT INTO R_Cliente_TipoIncarico_GenerazioneDocumentoRichiestoIncarico (CodCliente, CodTipoIncarico, CodArea, NomeSPMatch, CodTipoDocumento, CodGruppoDocumentiEquivalenti, IdFaseLavorazioneIncarico, CodTipoFirmaDigitale, FlagRichiestoOriginale, FlagObbligatorio, FlagRimuovi)
	SELECT
		CodCliente
	   ,776 CodTipoIncarico
	   ,CodArea
	   ,NULL NomeSPMatch
	   ,259773 CodTipoDocumento
	   ,NULL CodGruppoDocumentiEquivalenti
	   --,15 IdFaseLavorazioneIncarico
	   ,2 CodTipoFirmaDigitale
	   ,FlagRichiestoOriginale
	   ,FlagObbligatorio
	   ,FlagRimuovi
	FROM R_Cliente_TipoIncarico_GenerazioneDocumentoRichiestoIncarico
	WHERE CodCliente = 23
	AND CodTipoIncarico = 753

	--INSERT INTO R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico (CodCliente, CodTipoIncarico, CodTipoDocumento, CodTipoWorkflowDocumentoRichiestoIncarico, CodTipoProcessoSelfId, CodGruppoDocumentiEquivalenti, FlagVerificaDatiObbligatori)
	SELECT CodCliente,776 CodTipoIncarico,259773 CodTipoDocumento,5 CodTipoWorkflowDocumentoRichiestoIncarico, CodTipoProcessoSelfId,NULL CodGruppoDocumentiEquivalenti,1 FlagVerificaDatiObbligatori
	FROM R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico
	WHERE CodCliente = 23 AND CodTipoIncarico = 753

	--INSERT INTO R_TransizioneIncarico_InvioRichiestaSelfId (CodCliente, CodTipoIncarico, FlagCreazione
	--, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagInviaRichiestaDocumenti, FlagInviaRichiestaControfirma, FlagInviaRichiestaFirma)
	SELECT CodCliente, CodTipoIncarico, 0, NULL,11475 ,0,0,1
	FROM R_Cliente_TipoIncarico
	WHERE CodCliente = 23 AND CodTipoIncarico = 776

	

	--SELFID
	--VT-BTSLCL10N01
	USE SELFID
	
	SELECT * FROM S_Processo
	JOIN S_ParametriAutenticazioneNamirial ON S_Processo.IdParametriAutenticazioneNamirial = S_ParametriAutenticazioneNamirial.IdParametriAutenticazioneNamirial
	WHERE CodCliente = 23 AND CodTipoIncarico = 776


SELECT * FROM S_Modulo
JOIN D_PaginaDiRiferimento ON S_Modulo.CodPaginaDiRiferimento = D_PaginaDiRiferimento.Codice
WHERE IdProcesso = 34

SELECT * FROM S_AbilitazioneUrlAccesso
JOIN S_UrlAccesso ON S_AbilitazioneUrlAccesso.IdUrlAccesso = S_UrlAccesso.IdUrlAccesso
WHERE IdProcesso = 34

SELECT * FROM S_ParametriFirmaDigitale
WHERE IdProcesso = 34

--INSERT INTO S_ParametriFirmaDigitale (IdTemplateDocumento, NumeroPagina, PosizioneX, PosizioneY, Width, Height, CodiceDocumentoAtteso, FlagControfirma, CodiceRuoloFirmatario, ProgressivoFirmatario, IdProcesso, FlagFirmaVisibile)
SELECT NULL IdTemplateDocumento, 1 NumeroPagina, PosizioneX, PosizioneY, Width, Height,259773 CodiceDocumentoAtteso, FlagControfirma, CodiceRuoloFirmatario, ProgressivoFirmatario,34 IdProcesso, FlagFirmaVisibile
FROM S_ParametriFirmaDigitale
WHERE IdParametriFirmaDigitale = 1


--UPDATE S_ParametriFirmaDigitale
--SET PosizioneX = 24
--,PosizioneY = 500
--WHERE CodiceDocumentoAtteso = 259773

DECLARE @YTot DECIMAL,
             @YFirma DECIMAL,
             @XFirma DECIMAL,
             @AreaX DECIMAL,
             @AreaY DECIMAL

SET  @YTot = 2339
SET @YFirma = 900
SET @XFirma = 67

SELECT ( @XFirma *0.3610 ) AreaX --@AreaX

SELECT ( @YTot- @YFirma )*0.3610 AreaY



/*
Cosa serve per far funzionare la firma.
Dati minimi:
1.	NOME
2.	COGNOME
3.	CODICE FISCALE
4.	CHIAVEPERSONA
5.	CODICERUOLO
6.	PROGRESSIVO

/*** T_DocumentoIdentita ***/
7.	TIPO DOCUMENTO D’IDENTITÀ 
8.	DATA DI RILASCIOData di rilascio
9.	DATA DI SCADENZA 
10.	ENTE DI RILASCIO
11.	NUMERO DOCUMENTO D’IDENTITÀ

12.	STATO DI RESIDENZA

13.	EMAIL
14.	CELLULARE

*/

