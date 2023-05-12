use CLC
--analisi workflow
SELECT DISTINCT 
	S_WorkflowIncarico.IdRelazione
	--,CodTipoWorkflow
   ,CodStatoWorkflowIncaricoPartenza
   ,--dmacro1.Descrizione + ' - ' + 
		  wfpartenza.Descrizione StatoWorkflowPartenza
   ,CodStatoWorkflowIncaricoDestinazione
   ,--dmacro2.descrizione + ' - ' + 
		  wfdestinazione.Descrizione StatoWorkflowDestinazione

FROM S_WorkflowIncarico
JOIN D_StatoWorkflowIncarico wfpartenza	ON wfpartenza.Codice = CodStatoWorkflowIncaricoPartenza
--JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rmacro1	ON rmacro1.CodStatoWorkflowIncarico = wfpartenza.Codice
--JOIN D_MacroStatoWorkflowIncarico dmacro1	ON rmacro1.CodMacroStatoWorkflowIncarico = dmacro1.Codice

JOIN D_StatoWorkflowIncarico wfdestinazione	ON wfdestinazione.Codice = CodStatoWorkflowIncaricoDestinazione
--JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rmacro2	ON rmacro2.CodStatoWorkflowIncarico = wfdestinazione.Codice
--JOIN D_MacroStatoWorkflowIncarico dmacro2	ON rmacro2.CodMacroStatoWorkflowIncarico = dmacro2.Codice

WHERE CodTipoWorkflow = 5 AND CodStatoWorkflowIncaricoPartenza = 8570
--and rmacro1.CodMacroStatoWorkflowIncarico IS NULL
--and rmacro2.CodMacroStatoWorkflowIncarico is NULL

--select * FROM S_WorkflowIncarico where CodTipoWorkflow = 5 AND CodStatoWorkflowIncaricoPartenza = 8570

--nuovi stati workflow
use CLC
select * FROM D_StatoWorkflowIncarico order BY Codice DESC
--14438 Quietanza fatturata
--14437	Da Verificare - Documentale
--14436	Controllo Formale

--INSERT INTO D_StatoWorkflowIncarico (Codice, Descrizione)
--VALUES 
		--(14436, 'Controllo Formale'
--		,(14437, 'Da Verificare - Documentale')
--		,(14439, 'CC Aperto - In Attesa di attivazione')		fatto

--insert into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente , CodTipoIncarico , CodStatoWorkflowIncarico , CodMacroStatoWorkflowIncarico , Ordinamento )
--VALUES 
--(48,331,14436,9,null)
--		,(48,331,14437,2,null)
--		(48,331,14439,9,null)	fatto

--update S_WorkflowIncarico 
--set CodStatoWorkflowIncaricoPartenza = 14436
--where CodTipoWorkflow = 5 AND CodStatoWorkflowIncaricoPartenza = 8570		--fatto

--UPDATE S_WorkflowIncarico
--set CodStatoWorkflowIncaricoDestinazione = 14437
--where CodTipoWorkflow = 5 AND CodStatoWorkflowIncaricoDestinazione = 14332	--fatto


--SELECT * FROM S_WorkflowIncarico where CodTipoWorkflow = 5 and  CodStatoWorkflowIncaricoPartenza = 14436 and CodStatoWorkflowIncaricoDestinazione = 14276

--UPDATE S_WorkflowIncarico 
--set CodStatoWorkflowIncaricoDestinazione = 14439 
--where CodTipoWorkflow = 5 
--and CodStatoWorkflowIncaricoPartenza = 14436 and CodStatoWorkflowIncaricoDestinazione = 14276	--fatto

--INSERT INTO [dbo].[S_WorkflowIncarico]
--           ([CodTipoWorkflow]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza])
--VALUES (5,14439, null, 14276, 0, null)		--fatto


--INSERT INTO [dbo].[S_WorkflowIncarico]
--           ([CodTipoWorkflow]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza])
--VALUES (5,14437, null, 14332, 0, null)		--fatto


--INSERT INTO [dbo].[S_WorkflowIncarico]
--           ([CodTipoWorkflow]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza])

--select 
--          [CodTipoWorkflow]
--           ,14437 [CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza]
--from S_WorkflowIncarico
--where CodTipoWorkflow = 5 and CodStatoWorkflowIncaricoPartenza = 14332 and CodStatoWorkflowIncaricoDestinazione <> 6560	--fatto


--INSERT INTO [dbo].[S_WorkflowIncarico]
--           ([CodTipoWorkflow]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza])

--values (5,14437, null , 14436, 0, null)	--fatto

--INSERT INTO [dbo].[S_WorkflowIncarico]
--           ([CodTipoWorkflow]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[FlagCreazione]
--           ,[FlagAttesaPartenza])

--values (5,8570, null , 14436, 0, null)	--fatto


