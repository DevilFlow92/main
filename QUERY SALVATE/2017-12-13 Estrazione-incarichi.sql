use CLC

SELECT
	IdIncarico
   ,CodiceTipoIncarico
   ,TipoIncarico
   ,CodStatoWorkFlow
   ,StatoWorkflow
   ,DataCreazione
   ,DataUltimaTransizione
   ,AnagraficaCliente
   ,AnagraficaPromotore
   ,Importo

FROM rs.v_CESAM_AZ_AFB_Elenco_Incarichi


/*

LA VIEW rs.v_CESAM_AZ_AFB_Elenco_Incarichi

SELECT T_Incarico.IdIncarico
		,CodTipoIncarico CodiceTipoIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		,CodStatoWorkflowIncarico CodStatoWorkFlow
		,D_StatoWorkflowIncarico.Descrizione StatoWorkflow
		,DataCreazione
		,DataUltimaTransizione
		,ChiaveClienteIntestatario + ' ' + CognomeIntestatario + ' ' + NomeIntestatario AnagraficaCliente
		,CodicePromotore + ' ' + CognomePromotore + ' ' + NomePromotore AnagraficaPromotore
		,cast(Importo as decimal(9,2)) Importo

FROM T_Incarico
	left join rs.v_CESAM_Anagrafica_Cliente_Promotore on T_Incarico.IdIncarico = v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico
	left JOIN D_TipoIncarico on CodTipoIncarico = Codice
	LEFT JOIN D_StatoWorkflowIncarico on CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice
	left JOIN T_OperazioneAzimut on T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico

where CodArea = 8 
AND CodCliente = 23 
and CodTipoIncarico IN (321, 322) --sottoscrizioni AFB e Versamenti Aggiuntivi AFB
		and DataUltimaTransizione >= '20171029'

*/
