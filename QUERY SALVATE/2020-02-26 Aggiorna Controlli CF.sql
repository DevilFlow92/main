--ALTER PROCEDURE orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA
--AS

	--EXEC orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA

BEGIN TRANSACTION

IF OBJECT_ID('tempdb.dbo.#POBA') IS NOT NULL
	DROP TABLE #POBA

;
CREATE TABLE #POBA (
	--idincarico INT,
	CodGiudizioControllo INT
	,CodEsitoControllo INT
	,Note VARCHAR(MAX)
)
;
DECLARE @var1 INT
,@IdControllo INT


DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR

SELECT DISTINCT
	v_CESAM_AZ_Previdenza_ListaIncarichi.IdIncarico
	--,v_CESAM_AZ_Previdenza_ListaIncarichi.CodTipoIncarico
	--,TipoIncarico
	--,CodStatoWorkflowIncarico
	--,StatoWorkflowIncarico
	--,ChiaveClienteIntestatario
	--,RagioneSocialeIntestatario
	--,CognomeIntestatario
	--,NomeIntestatario
	--,CodiceFiscaleIntestatario
	--,T_Controllo.Note
	,T_Controllo.IdControllo
FROM rs.v_CESAM_AZ_Previdenza_ListaIncarichi

JOIN T_R_Incarico_Controllo	ON rs.v_CESAM_AZ_Previdenza_ListaIncarichi.IdIncarico = T_R_Incarico_Controllo.IdIncarico
JOIN T_Controllo ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
JOIN S_Controllo ON T_Controllo.IdTipoControllo = S_Controllo.IdControllo
JOIN S_MacroControllo ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo

WHERE CodStatoWorkflowIncarico NOT IN (820)
AND FlagStopDocumento = 0
AND DataUltimaTransizione >= '2020-02-23'

AND IdDocumentoTrasferito IS NULL

AND S_Controllo.NomeStoredProcedure = 'CESAM_AZ_CheckCodiceFiscaleClienti'
AND T_Controllo.CodGiudizioControllo = 4

OPEN cur

FETCH NEXT FROM cur INTO @var1, @IdControllo

WHILE @@FETCH_STATUS = 0 BEGIN

INSERT INTO #POBA
EXEC controlli.CESAM_AZ_CheckCodiceFiscaleClienti @IdRiga = @var1

IF EXISTS (SELECT * FROM #POBA where CodGiudizioControllo = 2)
BEGIN
	UPDATE T_Controllo
	SET CodGiudizioControllo = 2
	WHERE IdControllo = @IdControllo
END

TRUNCATE TABLE #POBA

FETCH NEXT FROM cur INTO @var1, @IdControllo

END

CLOSE cur
DEALLOCATE cur


DROP TABLE #POBA

;
SELECT DISTINCT
	v_CESAM_AZ_Previdenza_ListaIncarichi.IdIncarico
	--,v_CESAM_AZ_Previdenza_ListaIncarichi.CodTipoIncarico
	--,TipoIncarico
	--,CodStatoWorkflowIncarico
	--,StatoWorkflowIncarico
	--,ChiaveClienteIntestatario
	--,RagioneSocialeIntestatario
	--,CognomeIntestatario
	--,NomeIntestatario
	--,CodiceFiscaleIntestatario
	--,T_Controllo.Note
	,T_Controllo.IdControllo
FROM rs.v_CESAM_AZ_Previdenza_ListaIncarichi

JOIN T_R_Incarico_Controllo
	ON rs.v_CESAM_AZ_Previdenza_ListaIncarichi.IdIncarico = T_R_Incarico_Controllo.IdIncarico
JOIN T_Controllo
	ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
JOIN S_Controllo
	ON T_Controllo.IdTipoControllo = S_Controllo.IdControllo
JOIN S_MacroControllo
	ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo

WHERE CodStatoWorkflowIncarico NOT IN (820)
AND FlagStopDocumento = 0
AND DataUltimaTransizione >= '2020-02-23'

AND IdDocumentoTrasferito IS NULL

AND S_Controllo.NomeStoredProcedure = 'CESAM_AZ_CheckCodiceFiscaleClienti'
AND T_Controllo.CodGiudizioControllo = 4


--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

GO

