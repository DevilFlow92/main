use CLC

SELECT 
--R_TemplateComunicazione_StatoWorkflowIncarico.IdRelazione,
		CodCliente
		,CodTipoIncarico
		,D_TipoComunicazione.Codice
		,D_TipoComunicazione.Descrizione
from R_TemplateComunicazione_StatoWorkflowIncarico
join S_TemplateComunicazione on IdTemplateComunicazione = IdTemplate
JOIN D_TipoComunicazione on CodTipoComunicazione = D_TipoComunicazione.Codice
 where CodTipoIncarico = 54 and Codice in (2160
,2161
,2162
,2212
,2213
,2280
,2307
,2348
,2350
,2352
,2353
,2354
,2355
,2356
,2357
,3698
,6149)


 EXCEPT

 SELECT
	 --R_TemplateComunicazione_StatoWorkflowIncarico.IdRelazione,
	 CodCliente
	,CodTipoIncarico
	,D_TipoComunicazione.Codice
	,D_TipoComunicazione.Descrizione
 FROM R_TemplateComunicazione_StatoWorkflowIncarico
 JOIN S_TemplateComunicazione
	 ON IdTemplateComunicazione = IdTemplate
 JOIN D_TipoComunicazione
	 ON CodTipoComunicazione = D_TipoComunicazione.Codice
 WHERE CodTipoIncarico = 166

--select * from D_categoriaComunicazione where Descrizione LIKE '%promotore%'

--INSERT INTO [dbo].[R_TemplateComunicazione_StatoWorkflowIncarico]
--           ([IdTemplateComunicazione]
--           ,[CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodStatoWorkflow]
--           ,[FlagUrgente]
--           ,[CodAttributo]
--           ,[IdAtc]
--           ,[IdSedeAtc]
--           ,[CodProdottoPratica]
--           ,[CodAmministrazioneEsterna]
--           ,[CodSedeAmministrazioneEsterna]
--           ,[CodTipoSinistro]
--           ,[CodAssicurazioneSinistro]
--           ,[IdFondoPensioneSinistro]
--           ,[IdSedeAssicurazioneSinistro]
--           ,[CodiceConvenzioneSinistro]
--           ,[CodAttributoAtcInternalizzazione]
--           ,[CodModalitaRintraccioAtcInternalizzazione]
--           ,[CodEsitoRintraccioAtcInternalizzazione]
--           ,[FlagRichiestaVariazioneAnagraficaAtcInternalizzazione]
--           ,[CodCausaleRichiestaFondo]
--           ,[CodEsitoValutazioneFondo]
--           ,[FlagDocumentazioneCompletaFondo]
--           ,[FlagRateInsoluteDataRichiestaFondo]
--           ,[FlagInvioConsapFondo]
--           ,[FlagEsitoConsapFondo]
--           ,[CodCausaleRichiestaMoratoria]
--           ,[CodEsitoValutazioneMoratoria]
--           ,[FlagDocumentazioneCompletaMoratoria]
--           ,[FlagRateInsoluteDataRichiestaMoratoria]
--           ,[CodiceFilialePraticaMutuo]
--           ,[CodTipoTassoPraticaMutuo]
--           ,[CodValutaPraticaMutuo]
--           ,[CodProdottoPraticaMutuo]
--           ,[CodFinalitaPraticaMutuo]
--           ,[CodiceAssicurazioneVitaPraticaMutuo]
--           ,[CodiceAssicurazioneImpiegoPraticaMutuo]
--           ,[CodiceAssicurazioneImmobilePraticaMutuo]
--           ,[CodiceAssicurazioneCPIPraticaMutuo]
--           ,[CodProduttorePratica]
--           ,[CodCategoriaTicket]
--           ,[CodMacroCategoriaTicket]
--           ,[CodTipoProduttorePratica]
--           ,[CodAssicurazioneIncarico])

--SELECT
--[IdTemplateComunicazione]
--           ,[CodCliente]
--           ,166
--           ,[CodStatoWorkflow]
--           ,[FlagUrgente]
--           ,[CodAttributo]
--           ,[IdAtc]
--           ,[IdSedeAtc]
--           ,[CodProdottoPratica]
--           ,[CodAmministrazioneEsterna]
--           ,[CodSedeAmministrazioneEsterna]
--           ,[CodTipoSinistro]
--           ,[CodAssicurazioneSinistro]
--           ,[IdFondoPensioneSinistro]
--           ,[IdSedeAssicurazioneSinistro]
--           ,[CodiceConvenzioneSinistro]
--           ,[CodAttributoAtcInternalizzazione]
--           ,[CodModalitaRintraccioAtcInternalizzazione]
--           ,[CodEsitoRintraccioAtcInternalizzazione]
--           ,[FlagRichiestaVariazioneAnagraficaAtcInternalizzazione]
--           ,[CodCausaleRichiestaFondo]
--           ,[CodEsitoValutazioneFondo]
--           ,[FlagDocumentazioneCompletaFondo]
--           ,[FlagRateInsoluteDataRichiestaFondo]
--           ,[FlagInvioConsapFondo]
--           ,[FlagEsitoConsapFondo]
--           ,[CodCausaleRichiestaMoratoria]
--           ,[CodEsitoValutazioneMoratoria]
--           ,[FlagDocumentazioneCompletaMoratoria]
--           ,[FlagRateInsoluteDataRichiestaMoratoria]
--           ,[CodiceFilialePraticaMutuo]
--           ,[CodTipoTassoPraticaMutuo]
--           ,[CodValutaPraticaMutuo]
--           ,[CodProdottoPraticaMutuo]
--           ,[CodFinalitaPraticaMutuo]
--           ,[CodiceAssicurazioneVitaPraticaMutuo]
--           ,[CodiceAssicurazioneImpiegoPraticaMutuo]
--           ,[CodiceAssicurazioneImmobilePraticaMutuo]
--           ,[CodiceAssicurazioneCPIPraticaMutuo]
--           ,[CodProduttorePratica]
--           ,[CodCategoriaTicket]
--           ,[CodMacroCategoriaTicket]
--           ,[CodTipoProduttorePratica]
--           ,[CodAssicurazioneIncarico]
  
--FROM R_TemplateComunicazione_StatoWorkflowIncarico

--where IdTemplateComunicazione IN ( 3381
--,4452
--,4453
--,5500
--,5501
--,5577
--,5608
--,5655
--,5656
--,5659
--,5660
--,5661
--,5662
--,5663
--,5664
--,6648
--,8909)
--and CodTipoIncarico = 54
