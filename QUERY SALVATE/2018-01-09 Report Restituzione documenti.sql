USE [CLC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--ALTER VIEW [rs].[v_CESAM_CB_Monitor_Cartaceo_da_Restituire] as 

/*
Author: Lorenzo Fiori
Description: Il report estrae tutti gli incarichi per i quali si deve restituire 
la documentazione cartacea a CB!

*/

SELECT ti.IdIncarico
		,ti.CodTipoIncarico
		,D_TipoIncarico.Descrizione [Tipo Incarico]
		,macroWF.Codice [CodMacroStatoWF]
		,ti.CodStatoWorkflowIncarico [CodStatoWF]
		,macroWF.Descrizione + ' - ' + statoWF.Descrizione as [Stato WorkFlow]
		,ti.CodAttributoIncarico
		,isnull(D_AttributoIncarico.Descrizione,'') [Attributo Incarico]
		,ti.DataCreazione
		,ti.DataUltimaTransizione

FROM  T_Incarico ti
left join D_TipoIncarico on ti.CodTipoIncarico = D_TipoIncarico.Codice

left JOIN D_AttributoIncarico on ti.CodAttributoIncarico = D_AttributoIncarico.Codice

LEFT JOIN D_StatoWorkflowIncarico statoWF on ti.CodStatoWorkflowIncarico = statoWF.Codice --statoWF

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r_cli_inc_macroWF on statoWF.Codice = r_cli_inc_macroWF.CodStatoWorkflowIncarico
              and ti.CodCliente = r_cli_inc_macroWF.CodCliente AND ti.CodTipoIncarico = r_cli_inc_macroWF.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico macroWF on r_cli_inc_macroWF.CodMacroStatoWorkflowIncarico = macroWF.Codice  --risalire alla descrizione del macrostatoWF

WHERE 
ti.CodArea = 8 and 
ti.CodCliente = 48 --CheBanca
AND ti.CodStatoWorkflowIncarico = 14371 --WF (Archiviata -) Gestita CB! - Restituzione Documenti


GO


SELECT * FROM D_StatoWorkflowIncarico where Codice = 14372