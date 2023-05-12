USE CLC
GO


ALTER PROCEDURE controlli.CESAM_CB_ControlloAttivazioneAccordi (@IdRiga INT) AS 

--DECLARE @IdRiga INT = 15339548
   --cartaceo solo carta credito
--4429802  fea
--4429803 --cartaceo

DECLARE      @RES_CodGiudizioControllo INT
                    ,@RED_Note AS NVARCHAR(255)
                    ,@RED_CodEsitoControllo VARCHAR(5)


DECLARE @Esito INT
       DECLARE @Note VARCHAR(MAX)
       SET @RES_CodGiudizioControllo = 4
       SET @RED_Note = 'Aggiorna Controlli'

DECLARE @IdIncarico INT
SET @IdIncarico = @IdRiga

DECLARE @FlagContoCorrente BIT = 0
,@FlagDossier BIT = 0
,@FlagKK BIT = 0


IF EXISTS (
SELECT * FROM T_R_Incarico_Controllo
JOIN T_Controllo ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
WHERE CodGiudizioControllo IN (2,4)
AND IdTipoControllo = 8327
AND IdIncarico = @IdIncarico
)
BEGIN
	SET @FlagContoCorrente = 1
END



IF EXISTS (
SELECT * FROM T_R_Incarico_Controllo
JOIN T_Controllo ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
WHERE CodGiudizioControllo IN (2,4)
AND IdTipoControllo IN ( 8328) --dossier
--,8329)
AND IdIncarico = @IdIncarico
)
BEGIN
	SET @FlagDossier = 1
END

IF EXISTS (
SELECT * FROM T_R_Incarico_Controllo
JOIN T_Controllo ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
WHERE CodGiudizioControllo IN (2,4)
AND IdTipoControllo IN ( 8329) --carta di credito
--,8329)
AND IdIncarico = @IdIncarico
)
BEGIN
	SET @FlagKK = 1
END


IF OBJECT_ID('tempdb.dbo.#situazioneincarico') IS NOT NULL
BEGIN
	DROP TABLE #situazioneincarico
END

SELECT
	ti.IdIncarico
   ,ti.CodTipoIncarico
   ,ContoAttivo.IdTransizione WFConto
   ,DossierAttivo.IdTransizione WFDossier
   ,KKAttiva.IdTransizione WFKK
  
   ,CASE WHEN (ti.CodTipoIncarico = 611 AND ContoAttivo.IdTransizione IS NULL)
			OR (ti.CodTipoIncarico = 613 AND ContoAttivo.IdTransizione IS NULL AND @FlagContoCorrente = 1)
		 THEN 'Transizione in Conto Attivo Mancante.' + CHAR(10) + 'Si prega di effettuare la transizione prima di andare in Gestita - Lavorazioni Effettuate'
   
   WHEN ti.CodTipoIncarico = 613 AND DossierAttivo.IdTransizione IS NULL AND @FlagDossier = 1
		 THEN 'Transizione in Conto Titoli Aperto Mancante' + CHAR(10) + 'Si prega di effettuare la transizione prima di andare in Gestita - Lavorazioni Effettuate'
   
   WHEN ti.CodTipoIncarico = 613 AND KKAttiva.IdTransizione IS NULL AND @FlagKK = 1
		 THEN 'Transizione in Carta di Credito Attiva Mancante' + CHAR(10) + 'Si prega di effettuare la transizione prima di andare in Gestita - Lavorazioni Effettuate'
	   
   END Note
   
   INTO #situazioneincarico
FROM T_Incarico ti
LEFT JOIN (SELECT
		MAX(IdTransizione) IdTransizione
	   ,IdIncarico
	FROM L_WorkflowIncarico
	WHERE CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
	AND CodStatoWorkflowIncaricoDestinazione = 14276 --Conto Corrente Attivo
	AND IdIncarico = @IdIncarico
	GROUP BY IdIncarico) ContoAttivo
	ON ti.IdIncarico = ContoAttivo.IdIncarico

LEFT JOIN (SELECT
		MAX(IdTransizione) IdTransizione
	   ,IdIncarico
	FROM L_WorkflowIncarico
	WHERE CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
	AND CodStatoWorkflowIncaricoDestinazione = 14274 --Conto Titoli Aperto
	AND IdIncarico = @IdIncarico
	GROUP BY IdIncarico) DossierAttivo
	ON ti.IdIncarico = ContoAttivo.IdIncarico

LEFT JOIN (
SELECT
		MAX(IdTransizione) IdTransizione
	   ,IdIncarico
	FROM L_WorkflowIncarico
	WHERE CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
	AND CodStatoWorkflowIncaricoDestinazione = 14440 --Carta di Credito Attiva
	AND IdIncarico = @IdIncarico
	GROUP BY IdIncarico

) KKAttiva ON ti.IdIncarico = KKAttiva.IdIncarico

WHERE ti.IdIncarico = @IdIncarico


BEGIn

IF EXISTS (SELECT * FROM #situazioneincarico
			WHERE note IS NOT NULL

			)
BEGIN
	SET @RED_Note = (SELECT note FROM #situazioneincarico)
END 
ELSE
BEGIN
	SET @RES_CodGiudizioControllo = 2
	SET @Red_Note = 'OK'
end

END


SELECT
             @RES_CodGiudizioControllo AS CodGiudizioControllo
             ,@RED_CodEsitoControllo AS CodEsitoControllo
             ,@RED_Note AS Note

GO