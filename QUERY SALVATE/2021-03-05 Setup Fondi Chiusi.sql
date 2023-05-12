


/*gruppo tabelle setup Generale incarichi */ --------------------------------R_Cliente_TipoIncarico_AzioneSalvataggioIncarico-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_AzioneSalvataggioIncarico (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza,
--CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, CodAzioneSalvataggioIncarico, FlagAbilita)
	SELECT
		23
	   ,746
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
	   --,Descrizione
	FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
	--JOIN app.D_AzioneSalvataggioIncarico ON R_Cliente_TipoIncarico_AzioneSalvataggioIncarico.CodAzioneSalvataggioIncarico = D_AzioneSalvataggioIncarico.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Generatore documenti */ --------------------------------R_Cliente_TemplateDocumento-------------------------------- 
INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita, CodProduttore, CodTipoProcessoSelfId, IdFaseLavorazioneIncarico)
	SELECT
		IdTemplateDocumento
	   ,23
	   ,746
	   ,Priorita
	   ,CodProduttore
	   ,CodTipoProcessoSelfId
	   ,IdFaseLavorazioneIncarico
	FROM R_Cliente_TemplateDocumento
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi */ --------------------------------R_Cliente_TipoIncarico_TipoIndirizzo-------------------------------- 
INSERT INTO R_Cliente_TipoIncarico_TipoIndirizzo (CodCliente, CodTipoIncarico, CodTipoIndirizzo)
	SELECT
		23
	   ,746
	   ,CodTipoIndirizzo
	FROM R_Cliente_TipoIncarico_TipoIndirizzo
	WHERE CodTipoIncarico = 463
	AND CodCliente
	= 23

/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico,
--FlagAssegnaAutomaticamenteAreaDaOperatore, FlagMostraWorkflowSubincarichi)
	SELECT
		23
	   ,746
	   ,CodTipoWorkflow
	   ,FlagMostraElementiSubincarichi
	   ,CodTabIncaricoDefault
	   ,FlagMostraElementiIncarichiMaster
	   ,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
	   ,FlagAssegnaAutomaticamenteAreaDaOperatore
	   ,FlagMostraWorkflowSubincarichi
	FROM R_Cliente_TipoIncarico
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Tabelle Antiriciclaggio Ruolo Richiedente */ --------------------------------R_Cliente_TipoIncarico_RuoloRichiedente-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore)
	SELECT DISTINCT
		23
	   ,746
	   ,CodRuoloRichiedente
	   ,FlagVisualizzaPersonaRimossa
	   ,FlagEsecutore
	   --,Descrizione
	FROM R_Cliente_TipoIncarico_RuoloRichiedente
	--JOIN D_RuoloRichiedente ON R_Cliente_TipoIncarico_RuoloRichiedente.CodRuoloRichiedente = D_RuoloRichiedente.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Codice Stampa */ --------------------------------R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa-------------------------------- 
--NON FATTA, NON NECESSARIA
--INSERT INTO R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa (CodCliente, CodTipoIncarico, CodTipoIncaricoRicerca, CodStatoWorkflowIncaricoRicerca)
	SELECT
		23
	   ,746
	   ,CodTipoIncaricoRicerca
	   ,CodStatoWorkflowIncaricoRicerca
	FROM R_Cliente_TipoIncarico_ParametriRicercaCodiceStampa
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Mailer */ --------------------------------S_MittentePosteIncarichi-------------------------------- 
--INSERT INTO S_MittentePosteIncarichi (CodCliente, CodTipoIncarico, Nome, Cognome, Indirizzo, Cap, Localita, Provincia)
	SELECT
		23
	   ,746
	   ,Nome
	   ,Cognome
	   ,Indirizzo
	   ,Cap
	   ,Localita
	   ,Provincia
	FROM S_MittentePosteIncarichi
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Abilitazioni operatori Q_Task Profili accesso Extranet 3.0 - profili Setup operatori Cefin Isp */ --------------------------------R_ProfiloAccesso_AbilitazioneIncarico-------------------------------- 
--INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,746
	   ,CodStatoWorkflowIncarico
	   ,FlagAbilita
	   ,CodProduttore
	   --,D_ProfiloAccesso.Descrizione
	FROM R_ProfiloAccesso_AbilitazioneIncarico
	--JOIN D_ProfiloAccesso ON R_ProfiloAccesso_AbilitazioneIncarico.CodProfiloAccesso = D_ProfiloAccesso.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23
	--AND CodProfiloAccesso IN (2022,2166)

	--verificare chi ha un determinato profilo accesso
	SELECT * FROM S_Operatore
	WHERE CodProfiloAccesso = 935
	AND FlagAttivo = 1

	--team formazione, procedure e controllo qualità cesam azimut
	SELECT * FROM S_Operatore
	WHERE Cognome IN ('petito','cabianca')


/*gruppo tabelle setup Mailer Prodotti CLC */ --------------------------------S_MittenteMailIncarichi-------------------------------- 
--INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, CodRuoloOperatoreIncarico, Email, Firma, CodClientePratica, CodProdottoPratica, CodProduttorePratica, CodMacroCategoriaTicket, NomeVisualizzato, CodBancaInterna)
	SELECT
		23
	   ,746
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
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Workflow incarichi Attributi QT */ --------------------------------R_Cliente_Attributo-------------------------------- 
--INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
	SELECT
		23
	   ,746
	   ,CodAttributo
	   --,D_AttributoIncarico.Descrizione
	FROM R_Cliente_Attributo
	--JOIN D_AttributoIncarico ON R_Cliente_Attributo.CodAttributo = D_AttributoIncarico.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Operatori QTask Setup operatori Cefin Isp */ --------------------------------R_Cliente_AssegnatarioIncarico-------------------------------- 
--Chi può assegnare e a chi può essere assegnato l'incarico
--INSERT INTO R_Cliente_AssegnatarioIncarico (CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico)
	SELECT
		23
	   ,746
	   ,CodProfiloAccesso
	   ,CodRuoloOperatoreIncarico
	   --,D_ProfiloAccesso.Descrizione Profilo
	   --,D_RuoloOperatoreIncarico.Descrizione RuoloOperatore
	FROM R_Cliente_AssegnatarioIncarico
	--JOIN D_ProfiloAccesso ON R_Cliente_AssegnatarioIncarico.CodProfiloAccesso = D_ProfiloAccesso.Codice
	--JOIN D_RuoloOperatoreIncarico ON R_Cliente_AssegnatarioIncarico.CodRuoloOperatoreIncarico = D_RuoloOperatoreIncarico.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Generale incarichi */ --------------------------------R_Cliente_TipoIncarico_DatoAssociabileCollegabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile (CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile)
	--ALICrowd Master
	SELECT
		23
	   ,746 CodTipoIncaricoMaster
	   ,CodTipoSubIncarico
	   ,CodDatoAssociabileCollegabile
	   ,FlagClonazione
	   ,CodRuoloRichiedenteCollegabile
	FROM R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE CodTipoIncaricoMaster = 463
	AND CodCliente = 23
	UNION
	--ALICrowd Subincarico
	SELECT
		23
	   ,CodTipoIncaricoMaster
	   ,746
	   ,CodDatoAssociabileCollegabile
	   ,FlagClonazione
	   ,CodRuoloRichiedenteCollegabile
	FROM R_Cliente_TipoIncarico_DatoAssociabileCollegabile
	WHERE CodTipoSubIncarico = 463
	AND CodCliente = 23



/*gruppo tabelle setup Operazione Imbarco Mail */ --------------------------------R_Cliente_MailboxImbarcoIncarichi-------------------------------- 
--Stabilisco per quali tipi incarico posso imbarcare le mail provenienti da determinate caselle

--INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
	SELECT
		23
	   ,746
	   ,IdMailboxImbarcoIncarichi
	   --,Descrizione,Username
	FROM R_Cliente_MailboxImbarcoIncarichi
	--JOIN S_MailboxImbarcoIncarichi ON R_Cliente_MailboxImbarcoIncarichi.IdMailboxImbarcoIncarichi = S_MailboxImbarcoIncarichi.IdMailbox
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Incassi e Pagamenti */ --------------------------------R_Cliente_TipoIncarico_TipoPagamento-------------------------------- 
--Tipi Pagamento (menu a tendina) pagamenti e investimenti
--INSERT INTO R_Cliente_TipoIncarico_TipoPagamento (CodCliente, CodTipoIncarico, CodTipoPagamento)
	SELECT
		23
	   ,746
	   ,CodTipoPagamento
	   --,Descrizione
	FROM R_Cliente_TipoIncarico_TipoPagamento
	--JOIN D_TipoPagamento ON R_Cliente_TipoIncarico_TipoPagamento.CodTipoPagamento = D_TipoPagamento.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente
	= 23


	/* 
	clona template documenti: esempio 
	
	INSERT INTO S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy, FlagForzaCultureIt, FlagGenerazioneAsincrona)
	SELECT CodOggettoGenerazione, CodTipoDocumento, 
	REPLACE(PercorsoFile,'CESAM\Azimut\Private Debt','CESAM\Azimut\ALICrowd') PercorsoNuovo
	,FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy, FlagForzaCultureIt, FlagGenerazioneAsincrona
	FROM S_TemplateDocumento
	JOIN R_Cliente_TemplateDocumento ON S_TemplateDocumento.IdTemplate = R_Cliente_TemplateDocumento.IdTemplateDocumento
	WHERE CodCliente = 23
	AND CodTipoIncarico = 463


	INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
	SELECT IdTemplate, 23, 746, 5, percorsofile
	FROM S_TemplateDocumento
	WHERE PercorsoFile LIKE '%CESAM\Azimut\ALICrowd%'

	*/


/*gruppo tabelle setup Generatore documenti */ --------------------------------R_TransizioneIncarico_GenerazioneDocumento-------------------------------- 
--NON FATTA, NON NECESSARIA
--NON FATTA, CAPIRE SE NECESSARIA
--INSERT INTO R_TransizioneIncarico_GenerazioneDocumento (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, 
--CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, IdTemplateDocumento, FlagXml, FlagPdf, Priorita)
SELECT
	23 CodCliente
   ,746 CodTipoIncarico
   ,1 FlagCreazione
   ,null CodStatoWorkflowIncaricoPartenza
   ,null CodAttributoIncaricoPartenza
   ,null FlagUrgentePartenza
   ,null FlagAttesaPartenza
   ,NULL CodStatoWorkflowIncaricoDestinazione
   ,D_AttributoIncarico.Codice CodAttributoIncaricoDestinazione
   ,null FlagUrgenteDestinazione
   ,null FlagAttesaDestinazione
   ,null FlagArchiviatoDestinazione
   ,CASE Codice
	WHEN 1718 THEN 6135 
	WHEN 17246 THEN 6137
	WHEN 17245 THEN 6136
	END AS IdTemplateDocumento
   ,0 FlagXml
   ,1 FlagPdf
   ,10 Priorita

FROM D_AttributoIncarico
WHERE Codice IN (
1718	--CLOSING
,17246	--ANNULLAMENTO
,17245	--CONFERMA PAGAMENTO
)

	/*
	Questo clona non va bene, ma leggete la query per cultura :)
	SELECT 
		23
	   ,746
	   ,FlagCreazione
	   ,CodStatoWorkflowIncaricoPartenza	   
	   ,dmacropartenza.Descrizione + ' - ' + dstatopartenza.Descrizione StatoPartenza	   
	   ,CodAttributoIncaricoPartenza	   
	   ,attributopartenza.Descrizione AttributoPartenza	   
	   ,FlagUrgentePartenza
	   ,FlagAttesaPartenza
	   ,FlagArchiviatoPartenza
	   ,CodStatoWorkflowIncaricoDestinazione	   
	   ,dmacrodestinazione.Descrizione + ' - ' + dstatodestinazione.Descrizione Statodestinazione	   
	   ,CodAttributoIncaricoDestinazione
	   ,attributodestinazione.Descrizione Attributodestinazione
	   ,FlagUrgenteDestinazione
	   ,FlagAttesaDestinazione
	   ,FlagArchiviatoDestinazione
	   ,IdTemplateDocumento
	   ,D_Documento.Descrizione	   
	   ,S_TemplateDocumento.PercorsoFile
	   ,FlagXml
	   ,FlagPdf
	   ,Priorita
	FROM R_TransizioneIncarico_GenerazioneDocumento r
	JOIN S_TemplateDocumento ON r.IdTemplateDocumento = S_TemplateDocumento.IdTemplate
	JOIN D_Documento ON S_TemplateDocumento.CodTipoDocumento = D_Documento.Codice
	
	LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rpartenza ON r.CodCliente = rpartenza.CodCliente
	AND r.CodTipoIncarico = rpartenza.CodTipoIncarico
	AND r.CodStatoWorkflowIncaricoPartenza = rpartenza.CodStatoWorkflowIncarico
	LEFT JOIN D_MacroStatoWorkflowIncarico dmacropartenza ON rpartenza.CodMacroStatoWorkflowIncarico = dmacropartenza.Codice
	LEFT JOIN D_StatoWorkflowIncarico dstatopartenza ON r.CodStatoWorkflowIncaricoPartenza = dstatopartenza.Codice

	LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rdestinazione ON r.CodCliente = rdestinazione.CodCliente
	AND r.CodTipoIncarico = rdestinazione.CodTipoIncarico
	AND r.CodStatoWorkflowIncaricodestinazione = rdestinazione.CodStatoWorkflowIncarico
	LEFT JOIN D_MacroStatoWorkflowIncarico dmacrodestinazione ON rdestinazione.CodMacroStatoWorkflowIncarico = dmacrodestinazione.Codice
	LEFT JOIN D_StatoWorkflowIncarico dstatodestinazione ON r.CodStatoWorkflowIncaricodestinazione = dstatodestinazione.Codice

	LEFT JOIN D_AttributoIncarico attributopartenza ON r.CodAttributoIncaricoPartenza = attributopartenza.Codice
	LEFT JOIN D_AttributoIncarico attributodestinazione ON r.CodAttributoIncaricodestinazione = attributodestinazione.Codice
		
	WHERE r.CodTipoIncarico = 463
	AND r.CodCliente = 23

	*/
/*gruppo tabelle setup Dati Aggiuntivi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT
		23
	   ,746
	   ,CodTipoDatoAggiuntivo
	   ,Ordinamento
	   --,Descrizione
	FROM R_Cliente_TipoIncarico_TipoDatoAggiuntivo
	--JOIN D_TipoDatoAggiuntivo ON CodTipoDatoAggiuntivo = D_TipoDatoAggiuntivo.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Mailer Prodotti CLC */ --------------------------------S_ValutazioneDatiIncarico-------------------------------- 
--tabella che configura l'invio automatico / apertura popup template comunicazione
--INSERT INTO S_ValutazioneDatiIncarico (Descrizione, CodCliente, CodTipoIncarico, FlagAbilitaInvio, Priorita, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro,
--CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione,
--CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo,
--CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket,
--CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
	SELECT TOP 1
		'AZ - ALICrowd' Descrizione
	   ,23
	   ,746
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
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


	--INSERT INTO R_TemplateComunicazione_ValutazioneDatiIncarico (IdTemplateComunicazione, IdValutazioneDatiIncarico)
	SELECT R_TemplateComunicazione_StatoWorkflowIncarico.IdTemplateComunicazione, 1338 IdValutazioneDatiIncarico
	FROM R_TemplateComunicazione_ValutazioneDatiIncarico
	JOIN R_TemplateComunicazione_StatoWorkflowIncarico ON R_TemplateComunicazione_ValutazioneDatiIncarico.IdTemplateComunicazione = R_TemplateComunicazione_StatoWorkflowIncarico.IdTemplateComunicazione
	WHERE R_TemplateComunicazione_StatoWorkflowIncarico.CodCliente =23 
	AND CodTipoIncarico = 463

	SELECT * FROM S_ValutazioneDatiIncarico
	WHERE CodCliente = 23 AND CodTipoIncarico = 746


/*gruppo tabelle setup Mailer */ --------------------------------R_TemplateComunicazione_TransizioneIncarico-------------------------------- 
--Setup che, fatto un invio comunicazione, viene scatenata una transizione di stato
--INSERT INTO R_TemplateComunicazione_TransizioneIncarico (IdTemplateComunicazione, CodStatoWorkflowPartenza, FlagUrgentePartenza, CodAttributoPartenza, CodStatoWorkflowDestinazione, FlagUrgenteDestinazione, CodAttributoDestinazione,
--CodCliente, CodTipoIncarico, FlagCreazione)
	SELECT
		IdTemplateComunicazione
	   ,CodStatoWorkflowPartenza
	   ,FlagUrgentePartenza
	   ,CodAttributoPartenza
	   ,CodStatoWorkflowDestinazione
	   ,FlagUrgenteDestinazione
	   ,CodAttributoDestinazione
	   ,23
	   ,746
	   ,FlagCreazione
	FROM R_TemplateComunicazione_TransizioneIncarico
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico_DatoAssociabile-------------------------------- 
--TABELLA CHE CONSENTE DI VEDERE I TAB E I DATI ASSOCIABILI DELL'INCARICO
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
	   ,746
	   ,CodDatoAssociabile
	   ,Cardinalita
	   ,FlagMostraInRicerca
	   ,ElementiSubincarichiVisualizzabili
	   --,Descrizione
	FROM R_Cliente_TipoIncarico_DatoAssociabile
	--JOIN app.D_DatoAssociabile ON R_Cliente_TipoIncarico_DatoAssociabile.CodDatoAssociabile = D_DatoAssociabile.Codice
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Mailer Prodotti CLC */ --------------------------------R_TemplateComunicazione_StatoWorkflowIncarico-------------------------------- 
--TABELLA CHE RELAZIONA I TEMPLATE AGLI INCARICHI
--INSERT INTO R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna,
--CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione,
--CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo,
--FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo,
--CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica,
--CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico, FlagFirmaCessioneQuintoInFiliale, NomeFunzioneMatch)
	SELECT
		IdTemplateComunicazione
	   ,23
	   ,746
	   ,CodStatoWorkflow
	   --,FlagUrgente
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
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */ --------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow--------------------------------
--TABELLA TRA LE PIU' IMPORTANTI! Relaziona gli stati workflow agli incarichi (senza questa, praticamente non funziona nulla)
--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
	   ,746
	   ,CodStatoWorkflowIncarico
	   ,CodMacroStatoWorkflowIncarico
	   ,Ordinamento
	   ,IdFaseLavorazioneIncarico
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncaricoAssociabile--------------------------------
--TABELLA CHE GIA' CONOSCETE, CONFIGURA LA POSSIBILITA' DI SUBINCARICARE DETERMINATI TIPI INCARICO AD UN ALTRO (MASTER)
--INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
--746 MASTER
	SELECT
		23
	   ,746
	   ,CodTipoIncaricoAssociabile
	FROM R_Cliente_TipoIncaricoAssociabile
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23
UNION
--746 SUBINCARICO
SELECT 23, CodTipoIncarico, 746
FROM R_Cliente_TipoIncaricoAssociabile
WHERE CodTipoIncaricoAssociabile = 463
AND CodCliente = 23


/*gruppo tabelle setup Piano di rientro Qtask */ --------------------------------R_Cliente_TipoIncarico_ModalitaPagamento-------------------------------- 
--MENU A TENDINA MODALITA PAGAMENTO (TAB INCARICO, SEZIONE PAGAMENTI E INVESTIMENTI)
--INSERT INTO R_Cliente_TipoIncarico_ModalitaPagamento (CodCliente, CodTipoIncarico, CodModalitaPagamento)
	SELECT
		23
	   ,746
	   ,CodModalitaPagamento
	FROM R_Cliente_TipoIncarico_ModalitaPagamento
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


/*gruppo tabelle setup Note incarichi */ --------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi-------------------------------- 
--TABELLA CHE RELAZIONA DELLE TIPOLOGIE DI NOTE AGLI INCARICHI
--INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
	   ,746
	   ,CodTipoNotaIncarichi
	FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Sospesi */ --------------------------------R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso-------------------------------- 
--TABELLA CHE CONFIGURA LE COMBINAZIONI DI MOTIVAZIONE - SOTTOMOTIVAZIONE - MODALITA' DI RISOLUZIONE dei sospesi agli incarichi
--INSERT INTO R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso, CodSottoMotivazioneSospeso, CodModalitaSospeso, FlagAttivo, CodCliente, CodTipoIncarico)
	SELECT
		CodMotivazioneSospeso
	   ,CodSottoMotivazioneSospeso
	   ,CodModalitaSospeso
	   ,FlagAttivo
	   ,23
	   ,746
	FROM R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Attività pianificate incarichi */ --------------------------------R_Cliente_TipoIncarico_TipoAttivitaPianificata-------------------------------- 
--TABELLA CHE RELAZIONA LE ATTIVITA' PIANIFICATE AGLI INCARICHI
--INSERT INTO R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente,
--FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
	SELECT
		23
	   ,746
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
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23


--	/*gruppo tabelle setup Attività pianificate incarichi Attività pianificate incarichi - Transizioni */ 
----------------------------------R_Transizione_AttivitaPianificata-------------------------------- 
--INSERT INTO R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione,
--CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato,
--FlagAbilita, NomeStoredProcedureMatch)
--	SELECT
--		23
--	   ,746
--	   ,FlagCreazione
--	   ,CodStatoWorkflowIncaricoPartenza
--	   ,CodAttributoIncaricoPartenza
--	   ,FlagUrgentePartenza
--	   ,FlagAttesaPartenza
--	   ,CodStatoWorkflowIncaricoDestinazione
--	   ,CodAttributoIncaricoDestinazione
--	   ,FlagUrgenteDestinazione
--	   ,FlagAttesaDestinazione
--	   ,IdTipoAttivitaInserimento
--	   ,CodTipoAttivitaChiusura
--	   ,FlagStatoWorkflowModificato
--	   ,FlagAttributoModificato
--	   ,FlagUrgenteModificato
--	   ,FlagAttesaModificato
--	   ,FlagAbilita
--	   ,NomeStoredProcedureMatch
--	FROM R_Transizione_AttivitaPianificata
--	WHERE CodTipoIncarico = 463
--	AND CodCliente = 23




/*gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste Aree incarichi QTask */ --------------------------------R_Cliente_TipoIncarico_Area-------------------------------- 
--RELAZIONA CLIENTE, TIPOINCARICO E AREA
--INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		23
	   ,746
	   ,CodArea
	FROM R_Cliente_TipoIncarico_Area
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23

/*gruppo tabelle setup Documenti Generatore documenti Documenti Q-Task Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico_TipoDocumento-------------------------------- 
--CONFIGURA QUALI TIPI DOCUMENTO DEVONO ESSERE PRESENTI DENTRO L'INCARICO
--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
	   ,746
	   ,CodDocumento
	   ,FlagVisualizza
	   ,CodiceRiferimento
	   ,CodOggettoControlli
	FROM R_Cliente_TipoIncarico_TipoDocumento
	WHERE CodTipoIncarico = 463
	AND CodCliente = 23



	/* SETUP ARCHIVIO QTASK */

	--Che posizione ha l'incarico clone?
	SELECT * FROM R_Cliente_Archivio
	WHERE CodCliente = 23 AND CodTipoIncarico = 463

	--Capire la capienza dello scaffale
	SELECT * FROM S_Archivio
	WHERE CodScaffale = 33

	--32 sezioni, 43 piani

	SELECT * FROM R_Cliente_Archivio
	WHERE CodScaffaleInizio = 33
	AND CodiceSezioneInizio = 2 --la sezione 1 è tutta occupata
	ORDER BY CodicePianoInizio, CodicePianoFine
	   

	--"Prenotiamo" sezione 2 piani 25,26
	/******* IMPORTANTE!! AVVISARE I DPE (DL QTASK SETUP) CHE STIAMO PROCEDENDO CON IL SETUP ARCHIVIO QTASK **************/
	/******* FIN QUANDO NON CONCLUDIAMO TUTTO IL GIRO, NESSUNO DEVE FARE SETUP, TRASFERIRE GRUPPO ARCHIVIO QTASK ********/
	--INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
	SELECT
		23 CodCliente
	   ,746 CodTipoIncarico
	   ,2 CodTipoArchiviazione
	   ,33 CodScaffaleInizio
	   ,2 CodiceSezioneInizio
	   ,25 CodicePianoInizio
	   ,1 CodiceScatolaInizio
	   ,33 CodScaffaleFine
	   ,2 CodiceSezioneFine
	   ,26 CodicePianoFine
	   ,4 CodiceScatolaFine
	   ,9000 NumeroDocumenti
	   ,0 FlagTemporaneo
	   ,NULL CodDocumento
	   		 
			 SELECT * FROM D_TipoIncarico
			 WHERE Codice = 463

			 SELECT * FROM R_Cliente_TipoIncarico_DatoAssociabileCollegabile
			 WHERE CodCliente = 23 AND CodTipoIncaricoMaster = 746 


	   --EXEC Popola_S_PosizioneArchivio --tempo esecuzione circa 3 min, IN BASE AL SETUP PRESENTE NELLA R_Cliente_Archivio, popola la S_PosizioneArchivio di tutto il DB
										--Per questo motivo è importante che NESSUN ALTRO IN TUTTA L'AZIENDA deve fare setup o trasferire tabelle mentre questa sp gira

		--Traferisci subito gruppo tabelle Archivio QTask quando finisce la procedura ...e rispondi alla mail di prima che hai concluso :)

	



