USE CLC
GO

SELECT * FROM D_StatoWorkflowIncarico ORDER BY Codice DESC

SELECT * FROM D_StatoWorkflowIncarico ORDER BY Codice DESC

--INSERT INTO [VP-BTSQL02].CLC.dbo.D_StatoWorkflowIncarico (Codice, Descrizione)
--	VALUES (14550, 'Generazione Controlli');


SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow WHERE CodCliente = 48 AND CodTipoIncarico = 331 AND CodStatoWorkflowIncarico = 6500


--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
	SELECT
		CodCliente,
		378,
		14550,
		CodMacroStatoWorkflowIncarico,
		Ordinamento
	FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow

WHERE IdRelazione = 13049


--INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
SELECT
	CodTipoWorkflow,
	CodStatoWorkflowIncaricoPartenza,
	FlagUrgentePartenza,
	14550,
	FlagCreazione,
	FlagAttesaPartenza
FROM S_WorkflowIncarico
WHERE CodTipoWorkflow = 5
AND CodStatoWorkflowIncaricoDestinazione = 14530


--INSERT into S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
SELECT
	CodTipoWorkflow,
	14550,
	FlagUrgentePartenza,
	CodStatoWorkflowIncaricoDestinazione,
	FlagCreazione,
	FlagAttesaPartenza
FROM S_WorkflowIncarico
WHERE CodTipoWorkflow = 5
AND CodStatoWorkflowIncaricoDestinazione IN (14530,14531)


SELECT IdRelazione 
into #tmp
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
 WHERE CodStatoWorkflowIncarico = 14550

--UPDATE R_Cliente_TipoIncarico_MacroStatoWorkFlow
--SET CodMacroStatoWorkflowIncarico = 9
--FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow JOIN #tmp  ON R_Cliente_TipoIncarico_MacroStatoWorkFlow.IdRelazione = #tmp.IdRelazione




SELECT R_Transizione_MacroControllo.*, smc.Descrizione
 FROM R_Transizione_MacroControllo 

JOIN S_MacroControllo smc ON R_Transizione_MacroControllo.IdTipoMacroControllo = smc.IdMacroControllo
WHERE smc.CodTipoIncarico = 331




--insert in preprod

SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow WHERE CodStatoWorkflowIncarico = 14550

SELECT * FROM S_WorkflowIncarico where CodStatoWorkflowIncaricoPartenza = 14550 OR CodStatoWorkflowIncaricoDestinazione = 14550


--INSERT INTO [VP-BTSQL02].CLC.dbo.S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
SELECT
	CodTipoWorkflow,
	CodStatoWorkflowIncaricoPartenza,
	FlagUrgentePartenza,
	CodStatoWorkflowIncaricoDestinazione,
	FlagCreazione,
	FlagAttesaPartenza
FROM S_WorkflowIncarico
WHERE IdRelazione IN (41535
,41536
,41537
)


SELECT * FROM D_TipoIncarico WHERE Codice in (331,334,335,359)

/* *********************************************** TU SEI QUI ****************************************************************************** */

--connettiti a test interno
USE CLC
GO

--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow	 (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
SELECT 	
		CodCliente,
		CodTipoIncarico,
		CodStatoWorkflowIncarico,
		CodMacroStatoWorkflowIncarico,
		Ordinamento 
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodStatoWorkflowIncarico = 14550

--connettiti a preprod
USE CLC
GO

--modificare i trigger dei controlli
if object_id(N'tempdb.#trigger',N'U') is not null
BEGIN
drop TABLE #trigger
END
IF OBJECT_ID(N'tempdb.#blocchi', N'U') IS NOT NULL
BEGIN
	DROP TABLE #blocchi
END

SELECT
	R_Transizione_MacroControllo.*
	--,D_StatoWorkflowIncarico.Descrizione,
	--S_MacroControllo.Descrizione,
	--S_Controllo.Descrizione,
	--IdMacroControllo,
	--IdControllo
INTO #trigger
FROM R_Transizione_MacroControllo
--JOIN S_MacroControllo
--	ON R_Transizione_MacroControllo.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo
--JOIN S_Controllo
--	ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo

--JOIN D_StatoWorkflowIncarico ON R_Transizione_MacroControllo.CodStatoWorkflowIncaricoDestinazione = D_StatoWorkflowIncarico.Codice
WHERE ( (R_Transizione_MacroControllo.CodTipoIncarico IN (331, 334, 335, 359, 378)
 AND CodStatoWorkflowIncaricoDestinazione = 8570)

 OR IdTipoMacroControllo IN (702
,730))


--blocchi da modificare 
SELECT 
--R_EsitoControllo_BloccoTransizione.IdControllo,
		--S_Controllo.Descrizione
		R_EsitoControllo_BloccoTransizione.* 
INTO #blocchi
FROM R_EsitoControllo_BloccoTransizione 
--JOIN S_Controllo ON R_EsitoControllo_BloccoTransizione.IdControllo = S_Controllo.IdControllo
WHERE R_EsitoControllo_BloccoTransizione.IdControllo IN (1943
,1991
,1992
,1993
,1994
,2209
,1934
,2060
,2061
,2062
,2063
)

AND CodStatoWorkflowIncaricoPartenza = 8570 


--faccio generare i controlli prima che ARAD concluda la sua lavorazione
	--UPDATE R_Transizione_MacroControllo 
	--SET CodStatoWorkflowIncaricoDestinazione = 14550
	--,FlagCreazione = 0
	--FROM R_Transizione_MacroControllo
	--JOIN #trigger ON R_Transizione_MacroControllo.IdRelazione = #trigger.IdRelazione

	
--faccio bloccare il controllo che ho salvato nella temporanea 
	--UPDATE R_EsitoControllo_BloccoTransizione 
	--SET CodStatoWorkflowIncaricoPartenza = 6500
	--FROM R_EsitoControllo_BloccoTransizione
	--JOIN #blocchi ON R_EsitoControllo_BloccoTransizione.IdRelazione = #blocchi.IdRelazione



--SELECT
--	S_MacroControllo.Descrizione,
--	S_Controllo.Descrizione,
--	#trigger.*
--FROM #trigger
--JOIN S_MacroControllo
--	ON IdTipoMacroControllo = IdMacroControllo
--JOIN S_Controllo
--	ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo

--SELECT
--S_MacroControllo.Descrizione,
--S_Controllo.Descrizione,
--	#blocchi.*
--FROM #blocchi
--JOIN S_Controllo
--	ON #blocchi.IdControllo = S_Controllo.IdControllo
--JOIN S_MacroControllo
--	ON S_Controllo.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo

DROP TABLE #trigger
DROP TABLE #blocchi


SELECT * FROM S_WorkflowIncarico where CodTipoWorkflow = 5 AND CodStatoWorkflowIncaricoPartenza = 6500 AND CodStatoWorkflowIncaricoDestinazione IN (14530,14531)


DELETE from S_WorkflowIncarico 
WHERE IdRelazione IN (55010
,55011
)

--eventuale "rollback"
--INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
--values (	5	,6500,	NULL,	14530,	0,	NULL)
--	   ,(	5	,6500,	NULL,	14531,	0,	NULL)


--cambio la transizione che faceva bloccare il controllo documenti obbligatori, parte ARAD 
	--UPDATE R_EsitoControllo_BloccoTransizione
	--SET CodStatoWorkflowIncaricoPartenza = 14550
	--WHERE IdRelazione IN (1744, 1745)


--TESTA E POI TRASFERISCI IN PROD.



SELECT * FROM R_EsitoControllo_BloccoTransizione where CodStatoWorkflowIncaricoDestinazione = 14530
--2309


SELECT S_MacroControllo.Descrizione, IdMacroControllo, R_Transizione_MacroControllo.* FROM R_Transizione_MacroControllo 
JOIN S_MacroControllo ON R_Transizione_MacroControllo.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo
where R_Transizione_MacroControllo.CodTipoIncarico = 335





SELECT * FROM #trigger

SELECT * FROM D_TipoIncarico where Descrizione LIKE '%consulenza%c%'

--INSERT INTO R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
--values	 (48	,331	,NULL	,NULL	,0		,NULL	,8570	,NULL	,NULL	,NULL	,519	,0)
--		,(48	,334	,NULL	,NULL	,0		,0		,8570	,NULL	,0		,0		,538	,0)
--		,(48	,335	,NULL	,NULL	,0		,0		,8570	,NULL	,0		,0		,539	,0)
--		,(48	,331	,NULL	,NULL	,NULL	,NULL	,8570	,NULL	,NULL	,NULL	,508	,0)
--		,(48	,335	,NULL	,NULL	,NULL	,NULL	,8570	,NULL	,NULL	,NULL	,702	,0)
--		,(48	,331	,NULL	,NULL	,NULL	,NULL	,8570	,NULL	,NULL	,NULL	,730	,0)



SELECT * FROM R_EsitoControllo_BloccoTransizione where CodTipoIncarico = 331

SELECT * FROM R_Transizione_MacroControllo where CodTipoIncarico = 331 AND IdTipoMacroControllo = 511


SELECT * FROM S_MacroControllo WHERE IdMacroControllo = 511


INSERT into R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT
	CodCliente,
	CodTipoIncarico,
	null,
	CodAttributoIncaricoPartenza,
	FlagUrgentePartenza,
	FlagAttesaPartenza,
	8570,
	CodAttributoIncaricoDestinazione,
	FlagUrgenteDestinazione,
	FlagAttesaDestinazione,
	IdTipoMacroControllo,
	FlagCreazione
FROM R_Transizione_MacroControllo
WHERE IdRelazione = 800



SELECT * FROM S_MacroControllo JOIN S_Controllo on S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo 
WHERE IdMacroControllo = 511
--1944

SELECT * FROM R_Transizione_MacroControllo where IdTipoMacroControllo = 511


