use CLC
GO

select * FROM D_StatoWorkflowIncarico order BY Codice desc

--14529

--INSERT into D_StatoWorkflowIncarico (Codice, Descrizione) --FATTA

--VALUES (14530, 'Popolamento e Verifiche Effettuate') --Macro stato: In Gestione
--		,(14531, 'Verifiche Formali')				   --Macrostato: Sospesa



--DELETE FROM S_WorkflowIncarico WHERE IdRelazione = 47751 --FATTA



--insert into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente , CodTipoIncarico , CodStatoWorkflowIncarico , CodMacroStatoWorkflowIncarico , Ordinamento )
--VALUES (48,331,14530,9,null)
--		,(48,331,14531,2,null)

SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow where CodTipoIncarico = 331 AND CodStatoWorkflowIncarico = 14530 
--11734

SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow where CodTipoIncarico = 331 AND CodStatoWorkflowIncarico = 14531 
--11735

--INSERT into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
SELECT
	CodCliente,
	378, --378
	CodStatoWorkflowIncarico,
	CodMacroStatoWorkflowIncarico,
	Ordinamento
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE IdRelazione IN (11734,11735)


--INSERT INTO [dbo].[S_WorkflowIncarico] --FATTA
--           ([CodTipoWorkflow]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza])

--VALUES (5, 6500, NULL, 14530,0,NULL)
--		,(5, 6500, NULL, 14531,0,NULL)
--		,(5,14530,NULL,8570,0,NULL)
--		,(5,14531,NULL,8570,0,NULL)


SELECT * FROM S_WorkflowIncarico where CodStatoWorkflowIncaricoPartenza = 6500 and CodStatoWorkflowIncaricoDestinazione IN (14530,14531)


--DELETE FROM S_WorkflowIncarico where CodTipoWorkflow = 5 and CodStatoWorkflowIncaricoPartenza = 6500 and CodStatoWorkflowIncaricoDestinazione = 8570


