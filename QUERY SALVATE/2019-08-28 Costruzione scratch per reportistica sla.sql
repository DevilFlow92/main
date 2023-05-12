USE CLC
GO

/*
CREATE TABLE scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato
(
	IdTransizione INT,
	CONSTRAINT PK_L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato_IdTransizione PRIMARY KEY (IdTransizione)
	,CodStatoWorkflowIncaricoPartenza INT 
		,StatoPartenza VARCHAR(250)
		,CodAttributoIncaricoPartenza INT 
		,AttributoPartenza VARCHAR(200)
		,CodStatoWorkflowIncaricoDestinazione INT
		,StatoDestinazione VARCHAR(250)
		,CodAttributoIncaricoDestinazione INT 
		,AttributoDestinazione VARCHAR(200)
		,inizio DATETIME
		,fine DATETIME
		,IdOperatore INT
		,OperatoreTransizione VARCHAR(100)
		,MinutiTotali								INT
		,MinutiStatoAttuale							INT
		,[Minuti Lavorazione Pre-Istruttoria]		INT
		,[Minuti Lavorazione Istruttoria]			INT
		,[Minuti Lavorazione ESTERNA]				INT
		,[Lavorazione Pre-Istruttoria GIORNI]		INT
		,[Lavorazione Pre-Istruttoria HH_Resto]		INT
		,[Lavorazione Pre-Istruttoria MM_Resto]		INT
		,[Lavorazione Istruttoria GIORNI]			INT
		,[Lavorazione Istruttoria HH_Resto]			INT
		,[Lavorazione Istruttoria MM_Resto]			INT
		,[Lavorazione ESTERNA GIORNI]				INT
		,[Lavorazione ESTERNA HH_Resto]				INT
		,[Lavorazione ESTERNA MM_Resto]				INT
		,IdIncarico INT NOT NULL
		,FlagArchiviato BIT
		,TipoIncarico INT
		,CodMotivoVerifica SMALLINT
		,MotivoVerifica VARCHAR(100)
		,Cliente VARCHAR(MAX)
		,GestoreIncarico VARCHAR(100)
		,NatoUrgente BIT
		,CodMacroStatoAttuale INT
		,CodStatoAttuale INT
		,StatoAttuale VARCHAR(255)
		,CodAttributoAttuale INT
		,AttributoAttuale VARCHAR(255)
		,FlagStatoAttuale BIT
		,CodStepLavorazioneAttuale TINYINT
		,StepLavorazioneAttuale VARCHAR(50)
		,FlagLavorata BIT
		,IncaricoConcluso BIT
		,DataArchiviazione DATETIME
		,CompetenzaPF		BIT
		,CompetenzaAzimut	BIT
		,CompetenzaCESAM	BIT
		,DataCreazione DATETIME
		,CodMeseCreazione SMALLINT
		,MeseCreazione VARCHAR(100)
		,AnnoCreazione INT
		,SogliaMinuti SMALLINT
		,Periodo VARCHAR(100)
		,Urgente VARCHAR(50)
		,DataUltimaTransizione DATETIME

)
GO
*/

IF OBJECT_ID('tempdb.dbo.#tmpSLA') IS NOT NULL
	DROP TABLE #tmpSLA

SELECT 	v.IdTransizione
	,V.CodStatoWorkflowIncaricoPartenza
	,V.StatoPartenza
	,V.CodAttributoIncaricoPartenza
	,V.AttributoPartenza
	,V.CodStatoWorkflowIncaricoDestinazione
	,V.StatoDestinazione
	,V.CodAttributoIncaricoDestinazione
	,V.AttributoDestinazione
	,V.inizio
	,V.fine
	,V.IdOperatore
	,V.OperatoreTransizione
	,V.MinutiTotali
	,V.MinutiStatoAttuale
	,V.[Minuti Lavorazione Pre-Istruttoria]
	,V.[Minuti Lavorazione Istruttoria]
	,V.[Minuti Lavorazione ESTERNA]
	,V.[Lavorazione Pre-Istruttoria GIORNI]
	,V.[Lavorazione Pre-Istruttoria HH_Resto]
	,V.[Lavorazione Pre-Istruttoria MM_Resto]
	,V.[Lavorazione Istruttoria GIORNI]
	,V.[Lavorazione Istruttoria HH_Resto]
	,V.[Lavorazione Istruttoria MM_Resto]
	,V.[Lavorazione ESTERNA GIORNI]
	,V.[Lavorazione ESTERNA HH_Resto]
	,V.[Lavorazione ESTERNA MM_Resto]
	,V.IdIncarico
	,V.FlagArchiviato
	,V.TipoIncarico
	,V.CodMotivoVerifica
	,V.MotivoVerifica
	,V.Cliente
	,V.GestoreIncarico
	,V.NatoUrgente
	,V.CodMacroStatoAttuale
	,V.CodStatoAttuale
	,V.StatoAttuale
	,V.CodAttributoAttuale
	,V.AttributoAttuale
	,V.FlagStatoAttuale
	,V.CodStepLavorazioneAttuale
	,V.StepLavorazioneAttuale
	,V.FlagLavorata
	,V.IncaricoConcluso
	,V.DataArchiviazione
	,V.CompetenzaPF
	,V.CompetenzaAzimut
	,V.CompetenzaCESAM
	,V.DataCreazione
	,V.CodMeseCreazione
	,V.MeseCreazione
	,V.AnnoCreazione
	,V.SogliaMinuti
	,V.Periodo
	,V.Urgente
	,V.DataUltimaTransizione
	INTO #tmpSLA
 FROM [BTSQLCL05\BTSQLCL05].CLC.rs.v_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato_prova v
LEFT JOIN scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato l ON v.IdTransizione = l.IdTransizione

WHERE v.fine >= '20190828' --CONVERT(DATE,GETDATE())

AND l.IdTransizione IS NULL


--INSERT INTO scratch.L_CESAM_AZ_Antiriciclaggio_SLACalcolati_DettaglioStato (IdTransizione, CodStatoWorkflowIncaricoPartenza, StatoPartenza, CodAttributoIncaricoPartenza, AttributoPartenza, CodStatoWorkflowIncaricoDestinazione, StatoDestinazione, CodAttributoIncaricoDestinazione, AttributoDestinazione, inizio, fine, IdOperatore, OperatoreTransizione, MinutiTotali, MinutiStatoAttuale, [Minuti Lavorazione Pre-Istruttoria], [Minuti Lavorazione Istruttoria], [Minuti Lavorazione ESTERNA], [Lavorazione Pre-Istruttoria GIORNI], [Lavorazione Pre-Istruttoria HH_Resto], [Lavorazione Pre-Istruttoria MM_Resto], [Lavorazione Istruttoria GIORNI], [Lavorazione Istruttoria HH_Resto], [Lavorazione Istruttoria MM_Resto], [Lavorazione ESTERNA GIORNI], [Lavorazione ESTERNA HH_Resto], [Lavorazione ESTERNA MM_Resto], IdIncarico, FlagArchiviato, TipoIncarico, CodMotivoVerifica, MotivoVerifica, Cliente, GestoreIncarico, NatoUrgente, CodMacroStatoAttuale, CodStatoAttuale, StatoAttuale, CodAttributoAttuale, AttributoAttuale, FlagStatoAttuale, CodStepLavorazioneAttuale, StepLavorazioneAttuale, FlagLavorata, IncaricoConcluso, DataArchiviazione, CompetenzaPF, CompetenzaAzimut, CompetenzaCESAM, DataCreazione, CodMeseCreazione, MeseCreazione, AnnoCreazione, SogliaMinuti, Periodo, Urgente, DataUltimaTransizione)
SELECT * FROM #tmpSLA


DROP TABLE #tmpSLA