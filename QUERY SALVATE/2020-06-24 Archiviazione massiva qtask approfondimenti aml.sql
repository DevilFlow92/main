--15202374 

ALTER PROCEDURE orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA
AS

--EXEC orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA

BEGIN TRANSACTION


IF OBJECT_ID('tempdb.dbo.#tmpIncarichi') IS NOT NULL
	DROP TABLE #tmpIncarichi

SELECT
	T_Incarico.IdIncarico
	,CodStatoWorkflowIncarico
	,T_Controllo.IdMacroControllo
	,IdControllo
	,DataUltimaTransizione
	,T_Controllo.DataModifica DataModificaControllo INTO #tmpIncarichi
FROM T_Incarico
JOIN T_MacroControllo
	ON T_Incarico.IdIncarico = T_MacroControllo.IdIncarico
	AND IdTipoMacroControllo = 2251
JOIN T_Controllo
	ON T_MacroControllo.IdMacroControllo = T_Controllo.IdMacroControllo
	AND IdTipoControllo = 7242
WHERE CodStatoWorkflowIncarico <> 820
AND  T_Incarico.IdIncarico IN (12464157
,12463924
,12463883
,12294701
,12463883
,12464214
,12464199
,12464159
,12464157
,12464058
,12463652
,12464217
,12463870
,12294768
,12464150
,12464141
,12464154
,12463640
,12463704
,12463875
,12464058
,12463870
,12463609
,12464188
,12464189
,12464192
,12463683
,12463657
,12464133
,12463875
,12464147
,12463691
,12463941
,12464154
,12464159
,12463924
,12294699
,12463898
,12464021
,12464141
,12464032
,12464038
,12294695
,12464186
,12464133
,12464147
,12463898
,12464172
,12463884
,12463962
,12463884

)


INSERT INTO L_WorkflowIncarico
	SELECT
		L_WorkflowIncarico.IdIncarico
		,15307 IdOperatore
		,GETDATE() DataTransizione
		,CodTipoWorkflow
		,CodStatoWorkflowIncaricoDestinazione CodStatoWorkflowIncaricoPartenza
		,FlagUrgentePartenza
		,820 CodStatoWorkflowIncaricoDestinazione
		,FlagUrgenteDestinazione
		,FlagManuale
		,CodAttributoIncaricoPartenza
		,CodAttributoIncaricoDestinazione
		,FlagAttesaPartenza
		,FlagAttesaDestinazione
		,CodAreaPartenza
		,CodAreaDestinazione
		,IdNota
	FROM L_WorkflowIncarico
	JOIN #tmpIncarichi
		ON L_WorkflowIncarico.IdIncarico = #tmpIncarichi.IdIncarico
		AND DataUltimaTransizione = DataTransizione

UPDATE T_Incarico
SET	CodStatoWorkflowIncarico = 820
	,DataUltimaModifica = wf.DataTransizione
	,DataUltimaTransizione = wf.DataTransizione
FROM T_Incarico
JOIN (SELECT
	MAX(DataTransizione) DataTransizione
	,L_WorkflowIncarico.IdIncarico
FROM L_WorkflowIncarico
JOIN #tmpIncarichi
	ON L_WorkflowIncarico.IdIncarico = #tmpIncarichi.IdIncarico
GROUP BY L_WorkflowIncarico.IdIncarico) wf
	ON wf.IdIncarico = T_Incarico.IdIncarico
JOIN #tmpIncarichi
	ON T_Incarico.IdIncarico = #tmpIncarichi.IdIncarico


UPDATE T_Controllo
SET	CodGiudizioControllo = 2
	,DataModifica = GETDATE()
FROM T_Controllo

JOIN #tmpIncarichi	ON T_Controllo.IdControllo = #tmpIncarichi.IdControllo


DROP TABLE #tmpIncarichi

--ROLLBACK TRANSACTION
COMMIT TRANSACTION

GO