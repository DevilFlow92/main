USE [CLC]
GO

/****** Object:  View [rs].[v_CESAM_Anagrafica_Cliente_Promotore]    Script Date: 23/01/2018 11:33:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--ALTER view [rs].[v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico] AS

SELECT IdIncarico
		,T_Incarico.CodTipoIncarico
		,D_TipoIncarico.Descrizione [TipoIncarico]
		,D_MacroStatoWorkflowIncarico.Codice [CodMacroStatoWFIncarico]
		,T_Incarico.CodStatoWorkflowIncarico
		,D_MacroStatoWorkflowIncarico.Descrizione + ' - ' + D_StatoWorkflowIncarico.Descrizione [StatoWorkflowIncarico]
		,CodAttributoIncarico
		,D_AttributoIncarico.Descrizione [AttributoIncarico]
		
FROM T_Incarico

join D_TipoIncarico on T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice

join D_AttributoIncarico on T_Incarico.CodAttributoIncarico = D_AttributoIncarico.Codice

join	D_StatoWorkflowIncarico on T_Incarico.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice--statoWF

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r_cli_inc_macroWF on D_StatoWorkflowIncarico.Codice = r_cli_inc_macroWF.CodStatoWorkflowIncarico
                    and T_Incarico.CodCliente = r_cli_inc_macroWF.CodCliente AND T_Incarico.CodTipoIncarico = r_cli_inc_macroWF.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico on CodMacroStatoWorkflowIncarico = D_MacroStatoWorkflowIncarico.Codice  --risalire alla descrizione del macrostatoWF


--WHERE CodArea = 8 and T_Incarico.CodTipoIncarico = 331

GO

