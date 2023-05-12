USE CLC
GO

--USE CLC
--GO

--ALTER VIEW rs.Prova32 AS 

/*
	Author: Stefania Chessa
*/



with ultimaTransizione
AS(
SELECT 
MAX (IdTransizione) AS ID, 
IdIncarico 
FROM L_WorkflowIncarico WITH (nolock)
GROUP BY IdIncarico),

primatransizione AS (
SELECT IdTransizione ID
,IdIncarico
,CodStatoWorkflowIncaricoPartenza
,CodStatoWorkflowIncaricoDestinazione
,FlagUrgentePartenza
,FlagUrgenteDestinazione

FROM L_WorkflowIncarico WITH (NOLOCK)
WHERE CodStatoWorkflowIncaricoPartenza IS NULL AND CodStatoWorkflowIncaricoDestinazione = 6500

),
--==========================ELENCO

elenco
AS(
SELECT  RANK() OVER 
    (PARTITION BY L_WorkflowIncarico.IdIncarico ORDER BY IdTransizione   asc) AS [OrdineTransizioni]
       , L_WorkflowIncarico.IdTransizione
       , L_WorkflowIncarico.IdIncarico
       , L_WorkflowIncarico.DataTransizione
       , L_WorkflowIncarico.CodTipoWorkflow
       , L_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza
       , L_WorkflowIncarico.FlagUrgentePartenza
       , L_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione
       , L_WorkflowIncarico.FlagUrgenteDestinazione
       , L_WorkflowIncarico.FlagManuale
       , L_WorkflowIncarico.CodAttributoIncaricoPartenza
       , L_WorkflowIncarico.CodAttributoIncaricoDestinazione
       , L_WorkflowIncarico.FlagAttesaPartenza
       , L_WorkflowIncarico.FlagAttesaDestinazione
       , L_WorkflowIncarico.CodAreaPartenza
       , L_WorkflowIncarico.CodAreaDestinazione 
       , T_Incarico.FlagUrgente AS FlagUrgente 

       , CASE WHEN primatransizione.FlagUrgenteDestinazione = 1 AND primatransizione.CodStatoWorkflowIncaricoDestinazione = 6500 
         THEN 1
         ELSE 0 
         END AS [Urgente Calcolato] -- (inserito alla nascita della pratica)

       , T_Incarico.CodStatoWorkflowIncarico 
       , T_Incarico.CodAttributoIncarico     
       , T_Incarico.DataCreazione
       , T_Incarico.DataUltimaTransizione
       , ultimaTransizione.ID AS MaxTransizione
	   
FROM L_WorkflowIncarico WITH (nolock)
INNER JOIN T_Incarico WITH (nolock) ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
LEFT JOIN ultimaTransizione WITH (nolock) ON L_WorkflowIncarico.IdIncarico = ultimaTransizione.IdIncarico
LEFT JOIN primatransizione WITH (NOLOCK) ON L_WorkflowIncarico.IdIncarico = primatransizione.IdIncarico
WHERE CodCliente           = 23 -- Azimut
      AND CodTipoIncarico  = 522 -- Antiriciclaggio 
      AND CodArea           =8 -- Gestione SIM
      AND T_Incarico.DataCreazione >= '2019-01-01 00:00:00.000'                  -- Monitoraggio inizia per incarichi creati dopo 01.01.2015
      )

--========================OUTPUT QUERY
,Base AS (
SELECT 
   elenco.IdIncarico
,  T_Antiriciclaggio.codmotivoverifica
,  elenco.FlagUrgente  -- da t_incarico
,  elenco.[Urgente Calcolato]  --assegnato
,  elenco.CodStatoWorkflowIncarico  -- stato in cui si trova la pratica
,  elenco.CodAttributoIncarico  --attributo presente sulla pratica 

,  CASE WHEN elenco.IdTransizione = elenco.MaxTransizione 
   THEN 1 
   ELSE 0 
   END AS FlagStatoAttuale, -- SE SI TRATTA DELL'ULTIMA TRANSIZIONE METTE 1


--------------------  ASSEGNAZIONE STEP LAVORAZIONE ATTUALE -------------------- 
		                                                                               
CASE WHEN elenco.CodStatoWorkflowIncarico IN 
(
6500   -- Creata
,7130  --In valutazione
,15541 --Riscontro Ricevuto
,15542 --Scheda Ricevuta
,15546 --Integrazioni Ricevute
,6566  --Da Firmare
,15551 --Riesame per verifica dati
,15552 --Riesame per approfondimenti
,6590  --Da segnalare
,8560  --Segnalazione Validata
,6596  --Firma Interna
)
AND (elenco.CodAttributoIncarico IS NULL OR elenco.CodAttributoIncarico = 239) --Integrazioni ricevute
THEN 1 -- Lavorazione MOL
ELSE 0 -- Stati di Attesa / Competenza altri Interlocutori

END AS StepLavorazioneAttuale


--------------------  ASSEGNAZIONE STEP LAVORAZIONE RAGGIUNTI -------------------- 

,CASE WHEN elenco.CodStatoWorkflowIncaricoPartenza IN 
(
6500   -- Creata
,7130  --In valutazione
,15541 --Riscontro Ricevuto
,15542 --Scheda Ricevuta
,15546 --Integrazioni Ricevute
,6566  --Da Firmare
,15551 --Riesame per verifica dati
,15552 --Riesame per approfondimenti
,6590  --Da segnalare
,8560  --Segnalazione Validata
,6596  --Firma Interna
)
AND (elenco.CodAttributoIncarico IS NULL OR elenco.CodAttributoIncarico = 239) --Integrazioni ricevute
THEN 1 -- Lavorazione MOL

ELSE 0 -- Stati di Attesa / Competenza altri Interlocutori

END AS StepLavorazioneRaggiunti

---------------------------------------------------------------------- 
,  elenco.DataCreazione
,  elenco.DataUltimaTransizione

,  Calcola.IntervalloLavorativo AS IntervalloMINUTI

,  CASE WHEN elenco.IdTransizione = elenco.MaxTransizione 
   THEN Calcola2.IntervalloLavorativo  END AS StatoAttualePermanenzaMINUTI

, e2.DataTransizione as inizio
, elenco.DataTransizione as fine

, elenco.CodStatoWorkflowIncaricoPartenza
, elenco.CodStatoWorkflowIncaricoDestinazione
, elenco.CodattributoincaricoPartenza
, elenco.CodAttributoIncaricoDestinazione

,IIF(elenco.IdTransizione = elenco.MaxTransizione,MinutiTotali.IntervalloLavorativo,NULL) AS MinutiTotali
-------------------- -------------------- -------------------- -------------------- 

FROM elenco WITH (nolock)

LEFT JOIN T_Antiriciclaggio WITH (nolock) ON T_Antiriciclaggio.idincarico = elenco.IdIncarico

LEFT JOIN elenco AS e2 WITH (nolock) ON elenco.IdIncarico = e2.IdIncarico AND elenco.OrdineTransizioni = (e2.OrdineTransizioni+1)

cross apply [rs].[IntervalloLavorativoPerCliente2](
             23, 
             e2.DataTransizione,                  
             elenco.DataTransizione        
             ) as Calcola

cross apply [rs].[IntervalloLavorativoPerCliente2](
             23, 
             elenco.DataTransizione,                  
             GETDATE()       
             ) as Calcola2

cross apply [rs].[IntervalloLavorativoPerCliente2](
             23, 
             elenco.DataCreazione,                  
             GETDATE()       
             ) as MinutiTotali


--WHERE elenco.idincarico IN (4426601 )

),

calcolo AS

(
SELECT Base.[IdIncarico]
      ,Base.[codmotivoverifica]
	  ,ISNULL(Base.[Urgente Calcolato],0) AS [Urgente Calcolato] -- "Urgente Calcolato" --se flagurgente è null allora assegna zero
	  ,Base.FlagUrgente
	  ,Base.[CodStatoWorkflowIncarico]
	  ,Base.[CodAttributoIncarico]
	  ,Base.[StepLavorazioneAttuale]
      ,Base.[DataCreazione]
      ,Base.[DataUltimaTransizione]
	  , SUM (Base.[StatoAttualePermanenzaMINUTI]) AS [StatoAttualePermanenzaMINUTI]
	  , SUM (CASE WHEN Base.[StepLavorazioneRaggiunti] =  1 THEN Base.[IntervalloMINUTI] ELSE 0 end) AS 'Lavorazione MOL'
	  , SUM (CASE WHEN Base.[StepLavorazioneRaggiunti] =  0 THEN Base.[IntervalloMINUTI] ELSE 0 end) AS 'Lavorazione ESTERNA'
	    
FROM Base

GROUP BY 
	   Base.[IdIncarico]
      ,Base.[codmotivoverifica]
      ,base.[Urgente Calcolato]
	  ,Base.FlagUrgente
      ,Base.[CodStatoWorkflowIncarico]
	  ,Base.[CodAttributoIncarico]
	  ,Base.[StepLavorazioneAttuale]
      ,Base.[DataCreazione]
      ,Base.[DataUltimaTransizione]
	  
--il flag urgente vale solo se inserito alla creazione --ok verificato
--Stato attuale permanenza minuti conta i minuti in cui si trova l'ultimo stato (attuale)
--Lavorazione MOL conta i minuti in cui la pratica è di competenza Cesam
--Lavorazione Esterna conta i minuti in cui la pratica è di competenza Ext
)

SELECT
	[IdIncarico]
	,[codmotivoverifica]
	,[Urgente Calcolato]
	,FlagUrgente
	,[CodStatoWorkflowIncarico]
	,[CodAttributoIncarico]
	,[StepLavorazioneAttuale] -- se MOL oppure Lavorazione Esterna
	,[DataCreazione]
	,[DataUltimaTransizione]
	,[StatoAttualePermanenzaMINUTI] AS [MINUTI TOT. PermanenzaStatoAttuale]

	,CASE
		WHEN [StepLavorazioneAttuale] = 1 THEN ([StatoAttualePermanenzaMINUTI] + [Lavorazione MOL]) --somma i min in cui si trova ora + quelli precedenti
		WHEN [StepLavorazioneAttuale] = 0 THEN ([StatoAttualePermanenzaMINUTI] + [Lavorazione ESTERNA])
	END AS [MINUTI TOT. STEPattuale]

	,[Lavorazione MOL] AS [MINUTI TOT. Lavorazione MOL]
	,[Lavorazione ESTERNA] AS [MINUTI TOT. Attesa Riscontro Esterno]

	,([StatoAttualePermanenzaMINUTI] / 60) / 8 AS [PermanenzaStatoAttuale GIORNI]
	,([StatoAttualePermanenzaMINUTI] / 60) % 8 AS [PermanenzaStatoAttuale HH_Resto]
	,[StatoAttualePermanenzaMINUTI] % 60 AS [PermanenzaStatoAttuale MM_Resto]


	-- PermanenzaStepAttuale

	,CASE
		WHEN [StepLavorazioneAttuale] = 1 THEN (([StatoAttualePermanenzaMINUTI] + [Lavorazione MOL]) / 60) / 8
		WHEN [StepLavorazioneAttuale] = 0 THEN (([StatoAttualePermanenzaMINUTI] + [Lavorazione ESTERNA]) / 60) / 8
	END AS [STEPattuale GIORNI]


	,CASE
		WHEN [StepLavorazioneAttuale] = 1 THEN (([StatoAttualePermanenzaMINUTI] + [Lavorazione MOL]) / 60) % 8
		WHEN [StepLavorazioneAttuale] = 0 THEN (([StatoAttualePermanenzaMINUTI] + [Lavorazione ESTERNA]) / 60) % 8
	END AS [STEPattuale HH_Resto]

	,CASE
		WHEN [StepLavorazioneAttuale] = 1 THEN ([StatoAttualePermanenzaMINUTI] + [Lavorazione MOL]) % 60
		WHEN [StepLavorazioneAttuale] = 0 THEN ([StatoAttualePermanenzaMINUTI] + [Lavorazione ESTERNA]) % 60
	END AS [STEPattuale MM_Resto]

	-- Lavorazione MOL

	,([Lavorazione MOL] / 60) / 8 AS [Lavorazione MOL GIORNI]
	,([Lavorazione MOL] / 60) % 8 AS [Lavorazione MOL HH_Resto]
	,[Lavorazione MOL] % 60 AS [Lavorazione MOL MM_Resto]


	-- Lavorazione Esterna

	,([Lavorazione ESTERNA] / 60) / 8 AS [Lavorazione ESTERNA GIORNI]
	,([Lavorazione ESTERNA] / 60) % 8 AS [Lavorazione ESTERNA HH_Resto]
	,[Lavorazione ESTERNA] % 60 AS [Lavorazione ESTERNA MM_Resto]


FROM calcolo

GO

SELECT * FROM rs.Prova32