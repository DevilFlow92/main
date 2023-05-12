USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_FatturazioneIncarichi
--AS

/*
Author: Lorenzo Fiori
Utilizzata nel report: AZ - Fatturazione Mensile
*/

WITH ServiziInvTo AS (SELECT
	T_Incarico.IdIncarico
	,anagrafica.CodicePromotore + ' '
	+ IIF(anagrafica.CognomePromotore IS NULL OR anagrafica.CognomePromotore = '', anagrafica.RagioneSocialePromotore, anagrafica.CognomePromotore) + ' '
	+ IIF(anagrafica.NomePromotore IS NULL OR anagrafica.NomePromotore = '', '', anagrafica.NomePromotore) Promotore
	,anagrafica.ChiaveClienteIntestatario ChiaveCliente
	,IIF(anagrafica.CognomeIntestatario IS NULL OR anagrafica.CognomeIntestatario = '', anagrafica.RagioneSocialeIntestatario, anagrafica.CognomeIntestatario) + ' '
	+ IIF(anagrafica.NomeIntestatario IS NULL OR anagrafica.NomeIntestatario = '', '', anagrafica.NomeIntestatario) Cliente

	,T_DatoAggiuntivo.IdDatoAggiuntivo
	,CodTipoServizioInvestimento
	,ISNULL(D_TipoDatoAggiuntivo.Descrizione, D_TipoServizioInvestimento.Descrizione) Descrizione


FROM T_Incarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
	ON T_Incarico.IdIncarico = anagrafica.IdIncarico
LEFT JOIN T_DatoAggiuntivo
	ON T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico
	AND FlagAttivo = 1

LEFT JOIN D_TipoDatoAggiuntivo
	ON T_DatoAggiuntivo.CodTipoDatoAggiuntivo = D_TipoDatoAggiuntivo.Codice
LEFT JOIN T_R_Incarico_Mandato
	ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
LEFT JOIN T_Mandato
	ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
LEFT JOIN D_TipoServizioInvestimento
	ON T_Mandato.CodTipoServizioInvestimento = D_TipoServizioInvestimento.Codice
WHERE CodArea = 8
AND CodCliente = 23
AND CodTipoIncarico IN (473		--Attivazione Servizi di Investimento
, 397	--Servizi Investimento Digitale
)
AND (IdDatoAggiuntivo IS NOT NULL
OR (CodTipoServizioInvestimento IS NOT NULL)))


SELECT
	/* DETTAGLIO INCARICHI*/
	ti.IdIncarico
	,ti.DataCreazione
	,ti.CodTipoIncarico
	,descrizioni.TipoIncarico
	,ti.CodStatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico
	,ti.CodAttributoIncarico
	,descrizioni.AttributoIncarico

	/* DETTAGLIO SERVIZI DI INVESTIMENTO */

	,ServiziInvTo.Promotore
	,ServiziInvTo.ChiaveCliente
	,ServiziInvTo.Cliente
	,ServiziInvTo.IdDatoAggiuntivo
	,ServiziInvTo.CodTipoServizioInvestimento
	,ServiziInvTo.Descrizione



FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON ti.IdIncarico = descrizioni.IdIncarico


LEFT JOIN ServiziInvTo
	ON ti.IdIncarico = ServiziInvTo.IdIncarico

LEFT JOIN (SELECT
	IdIncarico
FROM T_Incarico
WHERE CodArea = 8
AND CodCliente = 23
AND CodTipoIncarico IN (321	--Sottoscrizioni AFB
, 322	--Versamenti Aggiuntivi AFB
, 323	--Rimborsi AFB
, 324	--Switch AFB
, 351	--Successioni AFB
, 396	--OnBoarding Digitale
)
AND CodStatoWorkflowIncarico = 6500 --Nuova - Creata
AND CodAttributoIncarico = 1507	--Attesa contratto Cartaceo 

) afb
	ON afb.IdIncarico = ti.IdIncarico --escludo gli afb creati senza carta perché si tratta di creazioni da MYDESK e fin quando non arriva la carta
--non è corretto fatturarli in quanto non ancora lavorati

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodStatoWorkflowIncarico <> 440

--escludo tali tipi incarico per i quali è prevista una fatturazione diversa, cioè per documenti
AND ti.CodTipoIncarico NOT IN (
253	--Bonifica Anagrafica - ADV in scadenza
, 91	 --MIFID - Contratti consulenza/collocamento
, 288 --Censimento Cliente
, 350 --Pregresso Augustum
)



AND afb.IdIncarico IS NULL

--AND ti.DataCreazione >= '2018-10-01'
--AND ti.DataCreazione < '2018-11-01'

GO