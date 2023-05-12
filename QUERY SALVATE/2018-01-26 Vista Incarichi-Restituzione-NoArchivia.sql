use CLC
GO
--attributo documenti da restituire a CheBanca! 1556

--ALTER view [rs].[v_CESAM_CB_Monitor_Cartaceo_da_Restituire_NO_Archivia] as


SELECT
	ti.IdIncarico
   ,ti.CodTipoIncarico
   ,D_TipoIncarico.Descrizione [Tipo Incarico]
   ,macroWF.Codice [CodMacroStatoWF]
   ,ti.CodStatoWorkflowIncarico [CodStatoWF]
   ,macroWF.Descrizione + ' - ' + statoWF.Descrizione AS [Stato WorkFlow]
   ,ti.CodAttributoIncarico
   ,D_AttributoIncarico.Descrizione [Attributo Incarico]
   ,ti.DataCreazione
   ,ti.DataUltimaTransizione

FROM T_Incarico ti
LEFT JOIN D_TipoIncarico ON ti.CodTipoIncarico = D_TipoIncarico.Codice

LEFT JOIN D_AttributoIncarico ON ti.CodAttributoIncarico = D_AttributoIncarico.Codice

LEFT JOIN D_StatoWorkflowIncarico statoWF ON ti.CodStatoWorkflowIncarico = statoWF.Codice --statoWF

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r_cli_inc_macroWF ON statoWF.Codice = r_cli_inc_macroWF.CodStatoWorkflowIncarico
		AND ti.CodCliente = r_cli_inc_macroWF.CodCliente
		AND ti.CodTipoIncarico = r_cli_inc_macroWF.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico macroWF ON r_cli_inc_macroWF.CodMacroStatoWorkflowIncarico = macroWF.Codice  --risalire alla descrizione del macrostatoWF

WHERE ti.CodArea = 8 AND
ti.CodCliente = 48 --CheBanca
AND ti.CodAttributoIncarico = 1556 --Documenti da Restituire a CB!


GO

