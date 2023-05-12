--PREPRODUZIONE

use clc
--1) creare i nuovi stati wf incarico:

select * FROM D_StatoWorkflowIncarico 
order BY Codice DESC 
--ultimo codice: 14372

INSERT INTO D_StatoWorkflowIncarico (Codice, Descrizione)
	VALUES (14373, 'Restituzione Pratica Errata')

--2) associare gli stati e macrostati wf al tipo incarico

SELECT * FROM D_TipoIncarico where Codice = 320
--conti ubs

INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodMacroStatoWorkflowIncarico, CodStatoWorkflowIncarico)
	VALUES (23, 320, 13, 14373)


--3) setup transizione di stato
--verifica come sono fatti i workflow che stanno nel medesimo Stato WF

SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow 
	where CodCliente = 23 AND CodTipoIncarico = 320 and CodMacroStatoWorkflowIncarico = 13
--14272
--8620

SELECT * FROM D_StatoWorkflowIncarico where Codice IN (14272, 8620)

SELECT
	*
FROM R_Cliente_TipoIncarico
WHERE CodTipoIncarico = 320
--23161

SELECT
	*
FROM D_TipoWorkflow
WHERE Codice = 23161
--workflow conti UBS

SELECT
	*
FROM S_WorkflowIncarico
WHERE CodStatoWorkflowIncaricoDestinazione IN (14272, 8620) AND CodTipoWorkflow = 23161 
--cod partenza 6004

SELECT * FROM D_StatoWorkflowIncarico where Codice = 6004
--In lavorazione CESAM

INSERT INTO [dbo].[S_WorkflowIncarico] ([CodTipoWorkflow]
, [CodStatoWorkflowIncaricoPartenza]
, [FlagUrgentePartenza]
, [CodStatoWorkflowIncaricoDestinazione]
, [FlagCreazione]
, [FlagAttesaPartenza])

	SELECT
		CodTipoWorkflow
	   ,CodStatoWorkflowIncaricoPartenza
	   ,FlagUrgentePartenza
	   ,14373 --Restituzione Pratica Errata
	   ,FlagCreazione
	   ,FlagAttesaPartenza
	FROM S_WorkflowIncarico
	WHERE CodStatoWorkflowIncaricoDestinazione = 14272 --workflow benchmarck: conto non aperto
	AND CodTipoWorkflow = 23161 --transizioni per i CONTI UBS


--verifica
SELECT
	*
FROM S_WorkflowIncarico
WHERE CodStatoWorkflowIncaricoDestinazione = 14373


-- 4) FAI UNA PROVA IN AMBIENTE PRE PRODUZIONE


-- 5) TRASFERISCI IL GRUPPO DI TABELLE WORKFLOW INCARICHI