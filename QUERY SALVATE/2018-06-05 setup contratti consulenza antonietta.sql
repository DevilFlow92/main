USE clc
GO
/*
SELECT * FROM D_TipoIncarico where Codice = 359
--359	Contratti Consulenza CheBanca


SELECT D_StatoWorkflowIncarico.*,

	r.CodCliente,

	r.CodStatoWorkflowIncarico,
	r.CodMacroStatoWorkflowIncarico
	
FROM D_StatoWorkflowIncarico
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r ON D_StatoWorkflowIncarico.Codice = r.CodStatoWorkflowIncarico
													AND CodCliente = 48 
													AND CodMacroStatoWorkflowIncarico = 2
													AND CodTipoIncarico = 331

EXCEPT
SELECT
	D_StatoWorkflowIncarico.*,
		r.CodCliente,
	
	r.CodStatoWorkflowIncarico,
	r.CodMacroStatoWorkflowIncarico

FROM D_StatoWorkflowIncarico
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r
	ON D_StatoWorkflowIncarico.Codice = r.CodStatoWorkflowIncarico
	AND CodCliente = 48
	AND CodMacroStatoWorkflowIncarico = 2
	AND CodTipoIncarico = 359

--6560	Regolarizzata
--8611	In attesa di riscontro banca
--14332	Documentale
--14333	Attesa attivazione accordo
--14334	Errore tecnico

*/

--INSERT into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)

SELECT
	CodCliente,
	359,
	CodStatoWorkflowIncarico,
	CodMacroStatoWorkflowIncarico,
	Ordinamento
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodCliente = 48
AND CodTipoIncarico = 331
AND CodStatoWorkflowIncarico IN (6560
, 8611
, 14332
, 14333
, 14334
)

/*

SELECT 	s.IdTemplate,
		s.CodTipoComunicazione,
		D_TipoComunicazione.Descrizione TipoComunicazione,
		s.CodCategoriaMittente,
		D_CategoriaMittenteComunicazione.Descrizione CategoriaMittente,
		s.MittenteSpecifico
FROM S_TemplateComunicazione s
JOIN R_TemplateComunicazione_StatoWorkflowIncarico r ON r.IdTemplateComunicazione = s.IdTemplate
JOIN D_TipoComunicazione on D_TipoComunicazione.Codice = s.CodTipoComunicazione
JOIN D_CategoriaMittenteComunicazione ON D_CategoriaMittenteComunicazione.Codice = s.CodCategoriaMittente

WHERE r.CodTipoIncarico = 331 
AND s.FlagAttivo = 1

*/

--INSERT into R_TemplateComunicazione_StatoWorkflowIncarico (IdTemplateComunicazione, CodCliente, CodTipoIncarico, CodStatoWorkflow, FlagUrgente, CodAttributo, IdAtc, IdSedeAtc, CodProdottoPratica, CodAmministrazioneEsterna, CodSedeAmministrazioneEsterna, CodTipoSinistro, CodAssicurazioneSinistro, IdFondoPensioneSinistro, IdSedeAssicurazioneSinistro, CodiceConvenzioneSinistro, CodAttributoAtcInternalizzazione, CodModalitaRintraccioAtcInternalizzazione, CodEsitoRintraccioAtcInternalizzazione, FlagRichiestaVariazioneAnagraficaAtcInternalizzazione, CodCausaleRichiestaFondo, CodEsitoValutazioneFondo, FlagDocumentazioneCompletaFondo, FlagRateInsoluteDataRichiestaFondo, FlagInvioConsapFondo, FlagEsitoConsapFondo, CodCausaleRichiestaMoratoria, CodEsitoValutazioneMoratoria, FlagDocumentazioneCompletaMoratoria, FlagRateInsoluteDataRichiestaMoratoria, CodiceFilialePraticaMutuo, CodTipoTassoPraticaMutuo, CodValutaPraticaMutuo, CodProdottoPraticaMutuo, CodFinalitaPraticaMutuo, CodiceAssicurazioneVitaPraticaMutuo, CodiceAssicurazioneImpiegoPraticaMutuo, CodiceAssicurazioneImmobilePraticaMutuo, CodiceAssicurazioneCPIPraticaMutuo, CodProduttorePratica, CodCategoriaTicket, CodMacroCategoriaTicket, CodTipoProduttorePratica, CodAssicurazioneIncarico)
SELECT
	IdTemplateComunicazione,
	CodCliente,
	359,
	CodStatoWorkflow,
	FlagUrgente,
	CodAttributo,
	IdAtc,
	IdSedeAtc,
	CodProdottoPratica,
	CodAmministrazioneEsterna,
	CodSedeAmministrazioneEsterna,
	CodTipoSinistro,
	CodAssicurazioneSinistro,
	IdFondoPensioneSinistro,
	IdSedeAssicurazioneSinistro,
	CodiceConvenzioneSinistro,
	CodAttributoAtcInternalizzazione,
	CodModalitaRintraccioAtcInternalizzazione,
	CodEsitoRintraccioAtcInternalizzazione,
	FlagRichiestaVariazioneAnagraficaAtcInternalizzazione,
	CodCausaleRichiestaFondo,
	CodEsitoValutazioneFondo,
	FlagDocumentazioneCompletaFondo,
	FlagRateInsoluteDataRichiestaFondo,
	FlagInvioConsapFondo,
	FlagEsitoConsapFondo,
	CodCausaleRichiestaMoratoria,
	CodEsitoValutazioneMoratoria,
	FlagDocumentazioneCompletaMoratoria,
	FlagRateInsoluteDataRichiestaMoratoria,
	CodiceFilialePraticaMutuo,
	CodTipoTassoPraticaMutuo,
	CodValutaPraticaMutuo,
	CodProdottoPraticaMutuo,
	CodFinalitaPraticaMutuo,
	CodiceAssicurazioneVitaPraticaMutuo,
	CodiceAssicurazioneImpiegoPraticaMutuo,
	CodiceAssicurazioneImmobilePraticaMutuo,
	CodiceAssicurazioneCPIPraticaMutuo,
	CodProduttorePratica,
	CodCategoriaTicket,
	CodMacroCategoriaTicket,
	CodTipoProduttorePratica,
	CodAssicurazioneIncarico
FROM R_TemplateComunicazione_StatoWorkflowIncarico
WHERE CodTipoIncarico = 331
AND IdTemplateComunicazione IN (8425
, 8469
, 8529
, 12003
)


