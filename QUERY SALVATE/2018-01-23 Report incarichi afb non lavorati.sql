USE [CLC]
GO

/****** Object:  View [rs].[v_CESAM_AZ_AFB_Report_SwitchRimborsi_NON_lavorati]    Script Date: 25/01/2018 10:26:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--ALTER view [rs].[v_CESAM_AZ_AFB_Report_SwitchRimborsi_NON_lavorati] AS

select distinct T_Incarico.idincarico
		,T_Incarico.DataCreazione
		,T_Incarico.CodTipoIncarico
		,descrizioni.TipoIncarico
		,anagrafica.CodicePromotore
		,anagrafica.CognomePromotore + ' ' + anagrafica.NomePromotore [NominativoPromotore]
		,anagrafica.ChiaveClienteIntestatario
		,anagrafica.CognomeIntestatario + ' ' + anagrafica.NomeIntestatario [NominativoIntestatario]
		,descrizioni.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico
		,descrizioni.CodAttributoIncarico
		,descrizioni.AttributoIncarico
		,min(T_Documento.DataInserimento) DataInserimento
		,isnull(CodTipoFea,3) CodTipoFea
		,MAX(L_WorkflowIncarico.DataTransizione) DataRegolamentoSospeso
	
FROM T_Incarico

join rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica on T_Incarico.IdIncarico = anagrafica.IdIncarico AND anagrafica.ProgressivoPersona = 1
join rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni on T_Incarico.IdIncarico = descrizioni.IdIncarico
JOIN T_Documento on T_Documento.IdIncarico = T_Incarico.IdIncarico
LEFT join T_DatiAggiuntiviIncaricoAzimut on T_Incarico.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico

LEFT JOIN L_WorkflowIncarico ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico 
											AND CodStatoWorkflowIncaricoPartenza = 8570 AND CodStatoWorkflowIncaricoDestinazione = 6603
											-- regolarizzata -> acquisita --> pronta caricamento fend

where T_Incarico.CodArea = 8
and T_Incarico.CodTipoIncarico IN (323,324) --switch/rimborsi AFB
and T_Incarico.CodStatoWorkflowIncarico <> 820 --lavorazione conclusa

--nuova creata
--sospesa 
--regolarizzata
--acquisita
--pronta caricamento fend


GROUP by T_Incarico.idincarico
		,T_Incarico.DataCreazione
		,T_Incarico.CodTipoIncarico
		,descrizioni.TipoIncarico
		,anagrafica.CodicePromotore
		,anagrafica.CognomePromotore + ' ' + anagrafica.NomePromotore 
		,anagrafica.ChiaveClienteIntestatario
		,anagrafica.CognomeIntestatario + ' ' + anagrafica.NomeIntestatario
		,descrizioni.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico
		,descrizioni.CodAttributoIncarico
		,descrizioni.AttributoIncarico
		,isnull(CodTipoFea,3)


GO


