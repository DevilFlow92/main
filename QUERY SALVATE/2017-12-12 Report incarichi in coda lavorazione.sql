use CLC

SELECT       IdIncarico,
             CodiceIncarico,
             TipoIncarico,
             AnagraficaCliente,
             AnagraficaPromotore,
             DataCreazione,
             DataUltimaTransizione,
             CodStatoWorkflowIncarico,
             StatoWorkflow FROM rs.v_CESAM_AZ_OpCagliari_VerificheFormali_Generico


/*
view rs.v_CESAM_AZ_OpCagliari_VerificheFormali_Generico

SELECT
       T_Incarico.IdIncarico
   ,T_incarico.CodTipoIncarico CodiceIncarico
   ,D_TipoIncarico.Descrizione TipoIncarico
   ,ChiaveClienteIntestatario + ' ' + CognomeIntestatario + ' ' + NomeIntestatario + ' ' + RagioneSocialeIntestatario AnagraficaCliente
   ,CodicePromotore + ' ' + NomePromotore + ' ' + CognomePromotore + ' ' + RagioneSocialePromotore AnagraficaPromotore
   ,DataCreazione
   ,DataUltimaTransizione
   ,CodStatoWorkflowIncarico
   ,D_StatoWorkflowIncarico.Descrizione StatoWorkflow
FROM T_Incarico

       LEFT JOIN rs.v_CESAM_AZ_OpCagliari_SwitchFondiInvestimento cagliari_switchfondi ON T_Incarico.IdIncarico = cagliari_switchfondi.IdIncarico

       left JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON T_Incarico.IdIncarico = anagrafica.IdIncarico

       JOIN D_TipoIncarico ON T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
       join D_StatoWorkflowIncarico on D_StatoWorkflowIncarico.Codice = CodStatoWorkflowIncarico
WHERE CodArea = 8 and CodStatoWorkflowIncarico = 6500

AND 

(CodTipoIncarico = 343
       or cagliari_switchfondi.IdIncarico IS not NULL)

*/