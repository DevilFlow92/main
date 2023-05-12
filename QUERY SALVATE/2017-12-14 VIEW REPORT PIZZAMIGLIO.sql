USE [CLC]

SELECT T_Incarico.IdIncarico
             ,T_Incarico.CodTipoIncarico CodiceTipoIncarico
             ,D_TipoIncarico.Descrizione TipoIncarico
             ,CodMacroStatoWorkflowIncarico CodMacroStatoWF
             ,T_Incarico.CodStatoWorkflowIncarico CodStatoWorkFlow
             ,D_MacroStatoWorkflowIncarico.Descrizione + ' ' + D_StatoWorkflowIncarico.Descrizione StatoWorkflow
             ,ChiaveClienteIntestatario + ' ' + CognomeIntestatario + ' ' + NomeIntestatario AnagraficaCliente
             ,CodicePromotore + ' ' + CognomePromotore + ' ' + NomePromotore AnagraficaPromotore
             ,cast(Importo as decimal(9,2)) Importo
			 ,IdOperazioneAzimut
			 ,NumeroMandato
			 ,NumeroDossier
			 ,DataCreazione
			 ,DataUltimaModifica
             ,DataUltimaTransizione
                    
FROM T_Incarico 
       left join rs.v_CESAM_Anagrafica_Cliente_Promotore on T_Incarico.IdIncarico = v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico --anagrafica già pronta

	   /*atterrare sulla T_operazione azimut anche con l'idmandato*/

       LEFT JOIN T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico --*AP
       left JOIN T_OperazioneAzimut on T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico 
			 AND T_R_Incarico_Mandato.IdMandato = T_OperazioneAzimut.IdMandato					 --risalire agli importi


	   left JOIN T_Mandato on T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato --| --*AP
       LEFT JOIN T_Dossier on T_Mandato.IdDossier = T_Dossier.IdDossier            --| risalire al mandato e al dossier

       left JOIN D_TipoIncarico on CodTipoIncarico = Codice --risalire alla descrizione tipo incarico

       LEFT JOIN D_StatoWorkflowIncarico on CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice --statpWF

      
	   LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r_cli_inc_macroWF on D_StatoWorkflowIncarico.Codice = r_cli_inc_macroWF.CodStatoWorkflowIncarico
                    and T_Incarico.CodCliente = r_cli_inc_macroWF.CodCliente AND T_Incarico.CodTipoIncarico = r_cli_inc_macroWF.CodTipoIncarico
       LEFT JOIN D_MacroStatoWorkflowIncarico on CodMacroStatoWorkflowIncarico = D_MacroStatoWorkflowIncarico.Codice  --risalire alla descrizione del macrostatoWF

where T_Incarico.CodTipoIncarico IN (321, 322) 
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodArea = 8 
AND T_Incarico.FlagArchiviato = 0

