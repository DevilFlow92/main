USE CLC
GO

--ALTER  PROCEDURE orga.CESAM_AZ_Antiriciclaggio_ConsolidaDatiSLA

--AS

/*
Author: Fiori L.

Utilizzata per popolare la tabella scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
*/

IF OBJECT_ID('tempdb.dbo.#bkpSLA') IS NOT NULL
	DROP TABLE #bkpSLA



SELECT MAX(IdTransizione) IdTransizione, IdIncarico INTO #bkpSLA
FROM scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
WHERE IncaricoConcluso = 0
GROUP BY IdIncarico

delete l
FROM scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato l
JOIN #bkpSLA ON l.IdTransizione = #bkpSLA.IdTransizione

INSERT INTO scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato (IdTransizione, CodStatoWorkflowIncaricoPartenza, StatoPartenza, CodAttributoIncaricoPartenza, AttributoPartenza, CodStatoWorkflowIncaricoDestinazione, StatoDestinazione, CodAttributoIncaricoDestinazione, AttributoDestinazione, inizio, fine, IdOperatore, OperatoreTransizione, MinutiTotali, MinutiStatoAttuale, [Minuti Lavorazione Pre-Istruttoria], [Minuti Lavorazione Istruttoria], [Minuti Lavorazione ESTERNA], [Lavorazione Pre-Istruttoria GIORNI], [Lavorazione Pre-Istruttoria HH_Resto], [Lavorazione Pre-Istruttoria MM_Resto], [Lavorazione Istruttoria GIORNI], [Lavorazione Istruttoria HH_Resto], [Lavorazione Istruttoria MM_Resto], [Lavorazione ESTERNA GIORNI], [Lavorazione ESTERNA HH_Resto], [Lavorazione ESTERNA MM_Resto], IdIncarico, FlagArchiviato, NatoUrgente, FlagStatoAttuale, CodStepLavorazioneAttuale, StepLavorazioneAttuale, FlagLavorata, IncaricoConcluso, DataArchiviazione, CompetenzaPF, CompetenzaAzimut, CompetenzaCESAM, DataCreazione, CodMeseCreazione, MeseCreazione, AnnoCreazione, SogliaMinuti, Periodo, Urgente)
SELECT
	v.IdTransizione
	,v.CodStatoWorkflowIncaricoPartenza
	,v.StatoPartenza
	,v.CodAttributoIncaricoPartenza
	,v.AttributoPartenza
	,v.CodStatoWorkflowIncaricoDestinazione
	,v.StatoDestinazione
	,v.CodAttributoIncaricoDestinazione
	,v.AttributoDestinazione
	,v.inizio
	,v.fine
	,v.IdOperatore
	,v.OperatoreTransizione
	,v.MinutiTotali
	,v.MinutiStatoAttuale
	,v.[Minuti Lavorazione Pre-Istruttoria]
	,v.[Minuti Lavorazione Istruttoria]
	,v.[Minuti Lavorazione ESTERNA]
	,v.[Lavorazione Pre-Istruttoria GIORNI]
	,v.[Lavorazione Pre-Istruttoria HH_Resto]
	,v.[Lavorazione Pre-Istruttoria MM_Resto]
	,v.[Lavorazione Istruttoria GIORNI]
	,v.[Lavorazione Istruttoria HH_Resto]
	,v.[Lavorazione Istruttoria MM_Resto]
	,v.[Lavorazione ESTERNA GIORNI]
	,v.[Lavorazione ESTERNA HH_Resto]
	,v.[Lavorazione ESTERNA MM_Resto]
	,v.IdIncarico
	,v.FlagArchiviato
	,v.NatoUrgente
	,v.FlagStatoAttuale
	,v.CodStepLavorazioneAttuale
	,v.StepLavorazioneAttuale
	,v.FlagLavorata
	,v.IncaricoConcluso
	,v.DataArchiviazione
	,v.CompetenzaPF
	,v.CompetenzaAzimut
	,v.CompetenzaCESAM
	,v.DataCreazione
	,v.CodMeseCreazione
	,v.MeseCreazione
	,v.AnnoCreazione
	,v.SogliaMinuti
	,v.Periodo
	,v.Urgente
FROM [BTSQLCL05\BTSQLCL05].CLC.rs.v_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato_prova v
JOIN #bkpSLA
	ON #bkpSLA.IdTransizione = v.IdTransizione

;
IF OBJECT_ID('tempdb.dbo.#tmpSLA') IS NOT NULL
	DROP TABLE #tmpSLA

SELECT
	v.IdTransizione
	,v.CodStatoWorkflowIncaricoPartenza
	,v.StatoPartenza
	,v.CodAttributoIncaricoPartenza
	,v.AttributoPartenza
	,v.CodStatoWorkflowIncaricoDestinazione
	,v.StatoDestinazione
	,v.CodAttributoIncaricoDestinazione
	,v.AttributoDestinazione
	,v.inizio
	,v.fine
	,v.IdOperatore
	,v.OperatoreTransizione
	,v.MinutiTotali
	,v.MinutiStatoAttuale
	,v.[Minuti Lavorazione Pre-Istruttoria]
	,v.[Minuti Lavorazione Istruttoria]
	,v.[Minuti Lavorazione ESTERNA]
	,v.[Lavorazione Pre-Istruttoria GIORNI]
	,v.[Lavorazione Pre-Istruttoria HH_Resto]
	,v.[Lavorazione Pre-Istruttoria MM_Resto]
	,v.[Lavorazione Istruttoria GIORNI]
	,v.[Lavorazione Istruttoria HH_Resto]
	,v.[Lavorazione Istruttoria MM_Resto]
	,v.[Lavorazione ESTERNA GIORNI]
	,v.[Lavorazione ESTERNA HH_Resto]
	,v.[Lavorazione ESTERNA MM_Resto]
	,v.IdIncarico
	,v.FlagArchiviato
	,v.NatoUrgente
	,v.FlagStatoAttuale
	,v.CodStepLavorazioneAttuale
	,v.StepLavorazioneAttuale
	,v.FlagLavorata
	,v.IncaricoConcluso
	,v.DataArchiviazione
	,v.CompetenzaPF
	,v.CompetenzaAzimut
	,v.CompetenzaCESAM
	,v.DataCreazione
	,v.CodMeseCreazione
	,v.MeseCreazione
	,v.AnnoCreazione
	,v.SogliaMinuti
	,v.Periodo
	,v.Urgente 
INTO #tmpSLA
FROM [BTSQLCL05\BTSQLCL05].CLC.rs.v_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato_prova v
LEFT JOIN scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato l
	ON v.IdTransizione = l.IdTransizione

WHERE v.fine >= CONVERT(DATE,GETDATE()) and 

l.IdTransizione IS NULL


INSERT INTO scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato (IdTransizione, CodStatoWorkflowIncaricoPartenza, StatoPartenza, CodAttributoIncaricoPartenza, AttributoPartenza, CodStatoWorkflowIncaricoDestinazione, StatoDestinazione, CodAttributoIncaricoDestinazione, AttributoDestinazione, inizio, fine, IdOperatore, OperatoreTransizione, MinutiTotali, MinutiStatoAttuale, [Minuti Lavorazione Pre-Istruttoria], [Minuti Lavorazione Istruttoria], [Minuti Lavorazione ESTERNA], [Lavorazione Pre-Istruttoria GIORNI], [Lavorazione Pre-Istruttoria HH_Resto], [Lavorazione Pre-Istruttoria MM_Resto], [Lavorazione Istruttoria GIORNI], [Lavorazione Istruttoria HH_Resto], [Lavorazione Istruttoria MM_Resto], [Lavorazione ESTERNA GIORNI], [Lavorazione ESTERNA HH_Resto], [Lavorazione ESTERNA MM_Resto], IdIncarico, FlagArchiviato, NatoUrgente, FlagStatoAttuale, CodStepLavorazioneAttuale, StepLavorazioneAttuale, FlagLavorata, IncaricoConcluso, DataArchiviazione, CompetenzaPF, CompetenzaAzimut, CompetenzaCESAM, DataCreazione, CodMeseCreazione, MeseCreazione, AnnoCreazione, SogliaMinuti, Periodo, Urgente)
sELECT
	*
FROM #tmpSLA


;WITH t2 AS (SELECT
	MAX(IdTransizione)
	IdTransizione
	,IdIncarico
FROM scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
GROUP BY IdIncarico), up AS (
SELECT t2up.IdIncarico, 
		t2up.CodStepLavorazioneAttuale CodStepLavorazioneAttuale_v2 
		,t2up.StepLavorazioneAttuale	 StepLavorazioneAttuale_v2
		,t2up.FlagLavorata			 FlagLavorata_v2
		,t2up.IncaricoConcluso		 IncaricoConcluso_v2
		,t2up.DataArchiviazione		 DataArchiviazione_v2
		,t2up.CompetenzaPF			 CompetenzaPF_v2
		,t2up.CompetenzaAzimut		 CompetenzaAzimut_v2
		,t2up.CompetenzaCESAM  		 CompetenzaCESAM_v2

FROM scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
JOIN t2 ON scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato.IdIncarico = t2.IdIncarico
JOIN scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato t2up ON t2.IdTransizione = t2up.IdTransizione
) UPDATE scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
SET CodStepLavorazioneAttuale =		CodStepLavorazioneAttuale_v2
		,StepLavorazioneAttuale =	StepLavorazioneAttuale_v2
		,FlagLavorata			=	FlagLavorata_v2
		,IncaricoConcluso		=	IncaricoConcluso_v2
		,DataArchiviazione		=	DataArchiviazione_v2
		,CompetenzaPF			=	CompetenzaPF_v2
		,CompetenzaAzimut		=	CompetenzaAzimut_v2
		,CompetenzaCESAM 		=	CompetenzaCESAM_v2	
		
FROM scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
JOIN up ON up.IdIncarico = scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato.IdIncarico


;SELECT 	IdIncarico,
		IdTransizione
		,CodStatoWorkflowIncaricoPartenza
		,StatoPartenza
		,CodAttributoIncaricoPartenza
		,AttributoPartenza
		,CodStatoWorkflowIncaricoDestinazione
		,StatoDestinazione
		,CodAttributoIncaricoDestinazione
		,AttributoDestinazione
		,inizio
		,fine
		,MinutiTotali
		,MinutiStatoAttuale
		,[Minuti Lavorazione Pre-Istruttoria]
		,[Minuti Lavorazione Istruttoria]
		,[Minuti Lavorazione ESTERNA]
		
FROM #tmpSLA


DROP TABLE #tmpSLA
DROP TABLE #bkpSLA

GO