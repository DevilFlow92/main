USE CLC
GO

--/*gruppo tabelle setup Archivio Qtask */ --------------------------------R_Cliente_Archivio-------------------------------- 
--INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine,
--NumeroDocumenti, FlagTemporaneo, CodDocumento)
--	SELECT
--		23
--	   ,693
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
--	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_Archivio
--	WHERE CodTipoIncarico = 83
--	AND CodCliente = 23

/* FATTO gruppo tabelle setup Operatori QTask Setup operatori Cefin Isp */ --------------------------------R_Cliente_AssegnatarioIncarico-------------------------------- 
--INSERT INTO R_Cliente_AssegnatarioIncarico (CodCliente, CodTipoIncarico, CodProfiloAccesso, CodRuoloOperatoreIncarico)
	SELECT
		23
	   ,693
	   ,CodProfiloAccesso
	   ,CodRuoloOperatoreIncarico
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_AssegnatarioIncarico
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Workflow incarichi Attributi QT */ --------------------------------R_Cliente_Attributo-------------------------------- 
--INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
	SELECT
		23
	   ,693
	   ,CodAttributo
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_Attributo
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23


/* FATTO gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico,
--FlagAssegnaAutomaticamenteAreaDaOperatore)
	SELECT
		23
	   ,693
	   ,CodTipoWorkflow
	   ,FlagMostraElementiSubincarichi
	   ,CodTabIncaricoDefault
	   ,FlagMostraElementiIncarichiMaster
	   ,CodAssegnaAutomaticamenteRuoloOperatoreIncarico
	   ,FlagAssegnaAutomaticamenteAreaDaOperatore
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste Aree incarichi QTask */ --------------------------------R_Cliente_TipoIncarico_Area-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
	SELECT
		23
	   ,693
	   ,CodArea
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_Area
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23



/*FATTO gruppo tabelle setup Generale incarichi */ --------------------------------R_Cliente_TipoIncarico_ControllaDuplicati-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_ControllaDuplicati (CodCliente, CodTipoIncarico, FlagBloccante, FlagAbilita)
	SELECT
		23
	   ,693
	   ,FlagBloccante
	   ,FlagAbilita
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_ControllaDuplicati
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico_DatoAssociabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
	SELECT
		23
	   ,693
	   ,CodDatoAssociabile
	   ,Cardinalita
	   ,FlagMostraInRicerca
	   ,ElementiSubincarichiVisualizzabili
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_DatoAssociabile
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Generale incarichi */ --------------------------------R_Cliente_TipoIncarico_DatoAssociabileCollegabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabileCollegabile 
--(CodCliente, CodTipoIncaricoMaster, CodTipoSubIncarico, CodDatoAssociabileCollegabile, FlagClonazione, CodRuoloRichiedenteCollegabile)

SELECT 23, D_TipoIncarico.Codice, 693, app.D_DatoAssociabile.Codice, 1, NULL
FROM D_TipoIncarico
JOIN app.D_DatoAssociabile ON  D_TipoIncarico.Codice IN (83,
540, --sottoscrizioni lux zenith
553 --aggiuntivi lux zenith
) 
AND app.D_DatoAssociabile.Codice IN (30,36,68,26,2
)




/*FATTO gruppo tabelle setup Workflow incarichi Extranet 3.0 - Richieste – Workflow/Transizioni */ --------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento, IdFaseLavorazioneIncarico)
	SELECT
		23
	   ,693
	   ,CodStatoWorkflowIncarico
	   ,CodMacroStatoWorkflowIncarico
	   ,Ordinamento
	   ,IdFaseLavorazioneIncarico
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23


/*FATTO gruppo tabelle setup Tabelle Antiriciclaggio Ruolo Richiedente */ --------------------------------R_Cliente_TipoIncarico_RuoloRichiedente-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente, FlagVisualizzaPersonaRimossa, FlagEsecutore)
	SELECT
		23
	   ,693
	   ,CodRuoloRichiedente
	   ,FlagVisualizzaPersonaRimossa
	   ,FlagEsecutore
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_RuoloRichiedente
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23



/*FATTO gruppo tabelle setup Dati Aggiuntivi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT
		23
	   ,693
	   ,CodTipoDatoAggiuntivo
	   ,Ordinamento
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDatoAggiuntivo
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Dati Aggiuntivi */ --------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, ValoreLista)
	SELECT
		23
	   ,693
	   ,CodTipoDatoAggiuntivo
	   ,ValoreLista
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Documenti Generatore documenti Documenti Q-Task Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncarico_TipoDocumento-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
	SELECT
		23
	   ,693
	   ,r.CodDocumento
	   ,r.FlagVisualizza
	   ,r.CodiceRiferimento
	   ,r.CodOggettoControlli
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDocumento r
	JOIN D_Documento ON r.CodDocumento = D_Documento.Codice
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23


/*FATTO gruppo tabelle setup Note incarichi */ --------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi-------------------------------- 
--INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
	SELECT
		23
	   ,693
	   ,CodTipoNotaIncarichi
	FROM [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23

/*FATTO gruppo tabelle setup Generale incarichi Extranet 3.0 - Richieste */ --------------------------------R_Cliente_TipoIncaricoAssociabile-------------------------------- 
--INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
	SELECT 23, D_TipoIncarico.Codice, 693
FROM D_TipoIncarico
WHERE D_TipoIncarico.Codice IN (83,
540, --sottoscrizioni lux zenith
553 --aggiuntivi lux zenith
) 




/*gruppo tabelle setup Abilitazioni operatori Q_Task Profili accesso Extranet 3.0 - profili Setup operatori Cefin Isp */ --------------------------------R_ProfiloAccesso_AbilitazioneIncarico-------------------------------- 
--INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
	SELECT
		CodProfiloAccesso
	   ,23
	   ,693
	   ,r.CodStatoWorkflowIncarico
	   ,r.FlagAbilita
	   ,r.CodProduttore
	FROM [VP-BTSQL02].CLC.dbo.R_ProfiloAccesso_AbilitazioneIncarico r
	JOIN D_ProfiloAccesso ON r.CodProfiloAccesso = D_ProfiloAccesso.Codice
	WHERE CodTipoIncarico = 83
	AND CodCliente = 23




/* ARCHIVIO QTASK */

SELECT DISTINCT CodScaffaleInizio, CodiceSezioneInizio
FROM R_Cliente_Archivio
WHERE CodCliente = 23 AND CodTipoIncarico = 83


SELECT * FROM S_Archivio
WHERE CodScaffale = 32

SELECT DISTINCT CodiceSezioneInizio, CodiceSezioneFine, CodicePianoInizio, CodicePianoFine
FROM R_Cliente_Archivio
WHERE CodScaffaleInizio = 32

--INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
SELECT CodCliente, 693, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, 8, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, 9, CodiceScatolaFine,9000 NumeroDocumenti, FlagTemporaneo, CodDocumento
FROM R_Cliente_Archivio
WHERE CodCliente = 23 AND CodTipoIncarico = 83
AND IdRelazione = 347
