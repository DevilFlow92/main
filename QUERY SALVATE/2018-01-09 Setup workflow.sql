--PREPRODUZIONE

use clc
--1) creare i nuovi stati wf incarico:
-----'Archiviata - Gestita CB! - Restituzione Documenti'
-----'Archiviata - Gestita CB! - Cartaceo Inviato'
--cod macrostato wf: 13	Archiviata

select * FROM D_StatoWorkflowIncarico 
order BY Codice DESC 
--ultimo codice: 14370

insert into D_StatoWorkflowIncarico (Codice,Descrizione)
VALUES (14371, 'Gestita CB! - Restituzione Documenti')
		,(14372, 'Gestita CB! - Cartaceo Inviato')

--2) associare gli stati e macrostati wf al tipo incarico (331)
INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente,CodTipoIncarico,CodMacroStatoWorkflowIncarico,CodStatoWorkflowIncarico)
VALUES (48,331,13,14371)
		,(48,331,13,14372)


--3) setup transizione di stato
--verifica il tipoworkflow

SELECT * FROM D_StatoWorkflowIncarico where Descrizione LIKE '%gestita cb%'
--14305

SELECT
	*
FROM R_Cliente_TipoIncarico
WHERE CodTipoIncarico = 331

SELECT * FROM D_TipoWorkflow where Codice = 5
 
 SELECT * FROM S_WorkflowIncarico where CodStatoWorkflowIncaricoDestinazione = 14305 and CodTipoWorkflow = 5

INSERT INTO [dbo].[S_WorkflowIncarico]
           ([CodTipoWorkflow]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[FlagCreazione]
           ,[FlagAttesaPartenza])

	 SELECT CodTipoWorkflow
			,CodStatoWorkflowIncaricoPartenza
			,FlagUrgentePartenza
			,14371 --Gestita CB! Restituzione documenti
			,FlagCreazione
			,FlagAttesaPartenza		 
	 FROM S_WorkflowIncarico
	 WHERE CodStatoWorkflowIncaricoDestinazione = 14305
	 AND CodTipoWorkflow = 5


--verifica
SELECT * from S_WorkflowIncarico where CodStatoWorkflowIncaricoDestinazione = 14371

INSERT into S_WorkflowIncarico (CodTipoWorkflow,CodStatoWorkflowIncaricoPartenza,CodStatoWorkflowIncaricoDestinazione,FlagCreazione)
VALUES (5,14371,14372,0)

-- 4) FAI UNA PROVA IN AMBIENTE PRE PRODUZIONE


-- 5) TRASFERISCI IL GRUPPO DI TABELLE WORKFLOW INCARICHI




