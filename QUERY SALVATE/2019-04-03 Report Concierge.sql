USE clc
GO

--ALTER VIEW rs.v_CESAM_AZ_ServizioConcierge_CodaLavorazione AS

/* Author: Fiori L.

Utilizzata nel report: AZ - Servizio Concierge - Code Lavorazioni

*/

WITH ServizioConcierge AS (
SELECT Concierge.IdIncarico IdIncaricoConcierge
,IIF(tr1.IdIncarico is NOT NULL,1,0) IsIncaricoMaster

,ISNULL(PerimetroConciergeSub.IdIncarico,PerimetroConciergeMaster.IdIncarico) IdIncaricoCollegato
,ISNULL(PerimetroConciergeSub.DataCreazione,PerimetroConciergeMaster.DataCreazione) DataCreazioneIncaricoCollegato
,ISNULL(PerimetroConciergeSub.DataUltimaTransizione,PerimetroConciergeMaster.DataUltimaTransizione) DataUltimaTransizioneIncaricoCollegato
,ISNULL(PerimetroConciergeSub.CodTipoIncarico,PerimetroConciergeMaster.CodTipoIncarico) CodTipoIncaricoCollegato
,ISNULL(PerimetroConciergeSub.CodStatoWorkflowIncarico,PerimetroConciergeMaster.CodStatoWorkflowIncarico) CodStatoWorkFlowIncaricoCollegato
,ISNULL(PerimetroConciergeSub.CodAttributoIncarico,PerimetroConciergeMaster.CodAttributoIncarico) CodAttributoIncaricoCollegato

FROM T_Incarico Concierge

LEFT JOIN T_R_Incarico_SubIncarico tr1 ON Concierge.IdIncarico = tr1.IdIncarico
LEFT JOIN T_Incarico PerimetroConciergeSub ON tr1.IdSubIncarico = PerimetroConciergeSub.IdIncarico

LEFT JOIN T_R_Incarico_SubIncarico tr2 ON Concierge.IdIncarico = tr2.IdSubIncarico
LEFT JOIN T_Incarico PerimetroConciergeMaster ON tr2.IdIncarico = PerimetroConciergeMaster.IdIncarico

WHERE Concierge.CodArea = 8 AND Concierge.CodCliente = 23 AND  Concierge.CodTipoIncarico = 517


)

SELECT IdIncaricoConcierge
,tiConcierge.DataCreazione DataCreazioneIncaricoConcierge
,tiConcierge.DataUltimaTransizione DataUltimaTransizioneIncaricoConcierge
,operatoreultimatransizione.Etichetta OperatoreUltimaTransizione
,gestore.Etichetta GestoreIncarico
,rWfConcierge.CodMacroStatoWorkflowIncarico CodMacroStatoConcierge
,tiConcierge.CodStatoWorkflowIncarico CodStatoWorkFlowIncaricoConcierge
,macrostatoconcierge.Descrizione + ' - ' + StatoWorkFlowConcierge.Descrizione StatoWorkFlowIncaricoConcierge

/* ANAGRAFICA - ASSUMO CHE ANAGRAFICA CONCIERGE = ANAGRAFICA INCARICO COLLEGATO */

,anagrafica.ChiaveClienteIntestatario
	,IIF(anagrafica.CognomeIntestatario IS NULL OR anagrafica.CognomeIntestatario = '', anagrafica.RagioneSocialeIntestatario, anagrafica.CognomeIntestatario)
	+ ' ' + ISNULL(anagrafica.NomeIntestatario, '') Intestatario

	,anagrafica.CodicePromotore CodiceConsulente
	,IIF(anagrafica.CognomePromotore IS NULL OR anagrafica.CognomePromotore = '', anagrafica.RagioneSocialePromotore, anagrafica.CognomePromotore)
	+ ' ' + ISNULL(anagrafica.NomePromotore, '') Consulente


/******************************************************************************/

,IdIncaricoCollegato
,D_TipoIncarico.Descrizione TipoIncaricoCollegato
,DataCreazioneIncaricoCollegato
,DataUltimaTransizioneIncaricoCollegato
,CodStatoWorkFlowIncaricoCollegato
,macrostatocollegato.Descrizione + ' - ' + StatoWorkFlowIncaricoCollegato.Descrizione StatoWorkflowIncaricoCollegato

--,ISNULL(integrazioniConcierge.Documento_id,ISNULL(integrazioniIncaricoCollegato.Documento_id,1)) IsDocumentoMancante

,CASE WHEN rWfConcierge.CodMacroStatoWorkflowIncarico = 3  --chiusa
			AND CodStatoWorkFlowIncaricoCollegato = 15524	--Presa in carico Concierge
	then 1 --Incarico Concierge chiuso ma incarico collegato ancora in presa in carico - Va fatta la transizione
 WHEN rWfConcierge.CodMacroStatoWorkflowIncarico <> 3
		AND CodStatoWorkFlowIncaricoCollegato <> 15524
		AND CodTipoIncaricoCollegato <> 54
	THEN 2 --Incarico Concierge in lavorazione ma incarico collegato non nello stato presa in carico concierge
	Else null

 END as CheckTransizioni
 
 ,T_Comunicazione.IdComunicazione
 ,DataInvio
 ,Destinatario
 ,Oggetto
 ,T_Comunicazione.IdOperatore
 ,soMail.Etichetta OperatoreMailToCF

 
FROM ServizioConcierge

JOIN T_Incarico tiConcierge ON IdIncaricoConcierge = tiConcierge.IdIncarico

JOIN D_TipoIncarico ON CodTipoIncaricoCollegato = D_TipoIncarico.Codice

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON IdIncaricoConcierge = anagrafica.IdIncarico

LEFT JOIN D_StatoWorkflowIncarico StatoWorkFlowConcierge ON tiConcierge.CodStatoWorkflowIncarico = StatoWorkFlowConcierge.Codice
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rWfConcierge ON StatoWorkFlowConcierge.Codice = rWfConcierge.CodStatoWorkflowIncarico
AND rWfConcierge.CodCliente = 23 and rWfConcierge.CodTipoIncarico = tiConcierge.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico macrostatoconcierge ON rWfConcierge.CodMacroStatoWorkflowIncarico = macrostatoconcierge.Codice

LEFT JOIN D_StatoWorkflowIncarico StatoWorkFlowIncaricoCollegato ON CodStatoWorkFlowIncaricoCollegato = StatoWorkFlowIncaricoCollegato.Codice
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rWfIncaricoCollegato ON rWfIncaricoCollegato.CodStatoWorkflowIncarico = StatoWorkFlowIncaricoCollegato.Codice
AND rWfIncaricoCollegato.CodCliente = 23 and rWfIncaricoCollegato.CodTipoIncarico = CodTipoIncaricoCollegato
LEFT JOIN D_MacroStatoWorkflowIncarico macrostatocollegato ON rWfIncaricoCollegato.CodMacroStatoWorkflowIncarico = macrostatocollegato.Codice

JOIN (SELECT
	MAX(IdTransizione) IdTransizione
	,IdIncarico
FROM L_WorkflowIncarico
GROUP BY IdIncarico) inputwf
	ON inputwf.IdIncarico = ServizioConcierge.IdIncaricoConcierge

JOIN L_WorkflowIncarico wf WITH (NOLOCK)
	ON inputwf.IdTransizione = wf.IdTransizione
JOIN S_Operatore operatoreultimatransizione WITH (NOLOCK)
	ON wf.IdOperatore = operatoreultimatransizione.IdOperatore

LEFT JOIN T_R_Incarico_Operatore WITH (NOLOCK)
	ON ServizioConcierge.IdIncaricoConcierge = T_R_Incarico_Operatore.IdIncarico
LEFT JOIN S_Operatore gestore WITH (NOLOCK)
	ON T_R_Incarico_Operatore.IdOperatore = gestore.IdOperatore


LEFT JOIN (SELECT MAX(IdComunicazione) IdComunicazione, IdIncarico
		 FROM  T_Comunicazione
		 JOIN R_TemplateComunicazione_StatoWorkflowIncarico ON IdTemplateComunicazione = IdTemplate
		 AND CodCliente = 23 and CodTipoIncarico = 517
		 --WHERE IdTemplate IS NOT NULL
			 GROUP BY IdIncarico) inputmail on tiConcierge.IdIncarico = inputmail.IdIncarico

LEFT JOIN T_Comunicazione ON inputmail.IdComunicazione = T_Comunicazione.IdComunicazione
--AND DATEDIFF(DAY,DataInvio,GETDATE()) >= 2
AND rs.DateAdd_GiorniLavorativi(23,DataInvio,3)<=CONVERT(DATE,GETDATE())

LEFT JOIN S_Operatore soMail ON T_Comunicazione.IdOperatore = soMail.IdOperatore

WHERE --tiConcierge.CodStatoWorkflowIncarico <> 820 AND 
rWfConcierge.CodMacroStatoWorkflowIncarico NOT IN ( 13) --Archiviata
AND anagrafica.ProgressivoPersona = 1

--AND IdIncaricoCollegato = 12046529

GO



--SELECT T_Incarico.IdIncarico, anagrafica.CodicePromotore, anagrafica.CognomePromotore + ' ' + anagrafica.NomePromotore Promotore
--,Email, Destinatario,T_Comunicazione.IdTemplate, CodTipoComunicazione,D_TipoComunicazione.Descrizione, DataInvio
--FROM T_Incarico
--JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON T_Incarico.IdIncarico = anagrafica.IdIncarico
--AND anagrafica.ProgressivoPersona = 1
--JOIN T_Contatto ON anagrafica.IdPersonaPromotore = T_Contatto.IdPersona
--AND CodRuoloContatto = 7 AND FlagAttivo = 1

--JOIN (SELECT MAX(IdComunicazione) IdComunicazione, IdIncarico
--		 FROM  T_Comunicazione
--		 JOIN R_TemplateComunicazione_StatoWorkflowIncarico ON IdTemplateComunicazione = IdTemplate
--		 AND CodCliente = 23 and CodTipoIncarico = 517
--		 --WHERE IdTemplate IS NOT NULL
--			 GROUP BY IdIncarico) inputmail on T_Incarico.IdIncarico = inputmail.IdIncarico

--JOIN T_Comunicazione ON inputmail.IdComunicazione = T_Comunicazione.IdComunicazione

--LEFT JOIN S_TemplateComunicazione ON T_Comunicazione.IdTemplate = S_TemplateComunicazione.IdTemplate
--LEFT JOIN D_TipoComunicazione on CodTipoComunicazione = Codice
--WHERE T_Incarico.IdIncarico = 11966096 

--AND DATEDIFF(DAY,DataInvio,GETDATE()) >= 2




