USE [CLC]
GO

/****** Object:  View [rs].[v_CESAM_AZ_ListaDiControlloAcquisizione]    Script Date: 07/12/2017 11:21:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [rs].[v_CESAM_AZ_ListaDiControlloAcquisizione] AS


----/*
----	Author: G.L. Rusu
----	Date: 11/11/2015
----	Description: utilizzata nei Report: 
							--AZ – Acquisizione – Lavorazione Switch Via Fax 
							--AZ - Riepilogo Incarichi Switch FAX				
----*/


	SELECT distinct T_Incarico.IdIncarico,
		D_TipoIncarico.Codice as TipoIncarico,
		L_WorkflowIncarico.IdOperatore, 
		L_WorkflowIncarico.DataTransizione,
		T_Incarico.DataCreazione,
		T_Incarico.CodTipoIncarico,
		T_Incarico.FlagAttesa as Attesa,
		D_AttributoIncarico.Descrizione AS 'Attributo',
		Disposizione1.Testo AS 'Disposizione1', 
		Disposizione2.Testo AS 'Disposizione2', 
		Disposizione3.Testo AS 'Disposizione3', 
		Disposizione4.Testo AS 'Disposizione4',
		Disposizione5.Testo AS 'Disposizione5', 
		Disposizione6.Testo AS 'Disposizione6', 
		Disposizione7.Testo AS 'Disposizione7', 
		S_Operatore.Cognome + ' ' + S_Operatore.Nome AS Operatore,
		S_Operatore.Etichetta,
		ISNULL(UPPER(ISNULL(dCLI.Cognome + ' ' + dCLI.Nome, dCLI.RagioneSociale)), '') + + ISNULL(UPPER(ISNULL(CLI.Cognome + ' ' + CLI.Nome, CLI.RagioneSociale)), '') AS CognomeNome
		,case when T_Documento.Tipo_Documento = 5833 then 1 else 0 end as FlagPEC
	FROM T_Incarico 
		left  JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente 
			AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico 
			AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico 
		left JOIN D_MacroStatoWorkflowIncarico ON  R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodMacroStatoWorkflowIncarico = D_MacroStatoWorkflowIncarico.Codice 

		LEFT join L_WorkflowIncarico as L_WorkflowIncarico on T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico--PRENDO L'ULTIMA TRANSIZIONE
			 and L_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione = 6554
		 and L_WorkflowIncarico.[DataTransizione] = (select max (LW.[DataTransizione])
                                          from L_WorkflowIncarico as LW
                                          where LW.IdIncarico = T_Incarico.IdIncarico 
                                          and LW.CodStatoWorkflowIncaricoDestinazione = 6554) -- Nuova - Da lavorare
		
	LEFT OUTER JOIN S_Operatore ON S_Operatore.IdOperatore = L_WorkflowIncarico.IdOperatore 
	LEFT OUTER JOIN D_AttributoIncarico ON D_AttributoIncarico.Codice = L_WorkflowIncarico.CodAttributoIncaricoDestinazione 
		LEFT OUTER JOIN T_DatoAggiuntivo AS Disposizione1 ON Disposizione1.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione1.CodTipoDatoAggiuntivo = 342 
		LEFT OUTER JOIN  T_DatoAggiuntivo AS Disposizione2 ON Disposizione2.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione2.CodTipoDatoAggiuntivo = 343 
		LEFT OUTER JOIN T_DatoAggiuntivo AS Disposizione3 ON Disposizione3.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione3.CodTipoDatoAggiuntivo = 345 
		LEFT OUTER JOIN T_DatoAggiuntivo AS Disposizione4 ON Disposizione4.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione4.CodTipoDatoAggiuntivo = 346 
		LEFT OUTER JOIN T_DatoAggiuntivo AS Disposizione5 ON Disposizione5.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione5.CodTipoDatoAggiuntivo = 347 
		LEFT OUTER JOIN T_DatoAggiuntivo AS Disposizione6 ON Disposizione6.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione6.CodTipoDatoAggiuntivo = 348 
		LEFT OUTER JOIN T_DatoAggiuntivo AS Disposizione7 ON Disposizione7.IdIncarico = L_WorkflowIncarico.IdIncarico 
			AND Disposizione7.CodTipoDatoAggiuntivo = 349 
		LEFT OUTER JOIN T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico 
			AND T_R_Incarico_Persona.Progressivo = 1 
		LEFT OUTER JOIN T_Persona AS CLI WITH (nolock) ON T_R_Incarico_Persona.IdPersona = CLI.IdPersona 
			AND CLI.CodCliente = 23 
		LEFT OUTER JOIN T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico 
		LEFT OUTER JOIN T_Mandato WITH (nolock) ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato 
		LEFT OUTER JOIN T_Dossier WITH (nolock) ON T_Mandato.IdDossier = T_Dossier.IdDossier 
		LEFT OUTER JOIN T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier 
			AND T_R_Dossier_Persona.Progressivo = 1 
		LEFT OUTER JOIN T_Persona AS dCLI WITH (nolock) ON T_R_Dossier_Persona.IdPersona = dCLI.IdPersona 
			AND dCLI.CodCliente = 23
		inner join D_TipoIncarico on T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
		left join T_Documento on T_Incarico.IdIncarico = T_Documento.IdIncarico

WHERE  (T_Incarico.CodCliente = 23) 
	AND (T_Incarico.CodArea = 8) 
	AND (T_Incarico.CodTipoIncarico IN (159, 160)) 
	AND (T_Incarico.CodStatoWorkflowIncarico = 6554) -- Nuova - Da lavorare
	--and T_Incarico.IdIncarico = 9374063


GO


