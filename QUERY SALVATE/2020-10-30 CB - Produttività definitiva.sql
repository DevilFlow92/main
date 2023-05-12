--ALTER VIEW rs.v_CESAM_CB_PraticheLavorateOperatore_Fasi AS

/* Author: Lorenzo Fiori
Utilizzata nel report: CB - Pratirche Lavorate per Operatore 2.0

*/

WITH 
fasi AS (
SELECT IdIncarico
	  ,CodTipoIncarico
	  ,TipoIncarico
	  ,DataCreazione
	  ,ChiaveIncarico
	  ,DataUltimaTransizione
	  ,StatoWorkflowIncarico
	  ,NDG
	  ,Cognome
	  ,Nome
	  ,FlagCC_Censito
	  ,FlagCC_DaCensire
	  ,FlagDossier_Censito
	  ,FlagDossier_DaCensire
	  ,FlagKK_Censita
	  ,FlagKK_DaCensire
	  ,FlagSwitch_Censito
	  ,FlagSwitch_DaCensire
	  ,Fase1
	  ,LavorazioneFase1
	  ,IdOperatoreFase1
	  ,OperatoreFase1
	  ,Fase1AR
	  ,LavorazioneFase1AR
	  ,IdOperatoreFase1AR
	  ,OperatoreFase1AR
	  ,Fase2AR
	  ,LavorazioneFase2AR
	  ,IdOperatoreFase2AR
	  ,OperatoreFase2AR
	  ,Fase2CA
	  ,LavorazioneFase2CA
	  ,IdOperatoreFase2CA
	  ,OperatoreFase2CA
	  ,Fase3
	  ,LavorazioneFase3
	  ,IdOperatoreFase3
	  ,OperatoreFase3
	  ,Fase4
	  ,LavorazioneFase4
	  ,IdOperatoreFase4
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE 
CodTipoIncarico IN (613,682, 611)
AND (LavorazioneFase1 >= DATEADD(MONTH,-3,GETDATE()) 
OR LavorazioneFase2CA >= DATEADD(MONTH,-3,GETDATE())
OR LavorazioneFase3 >= DATEADD(MONTH,-3,GETDATE())

)
--AND IdIncarico = 16011541
)

,lavorazioni AS (
/* core business */
select 1 CodTipoLavorazione, 'FASE 1 - A. Attività relative al giro logistico' TipoLavorazione, 2.58 Corrispettivo union all
select 2 CodTipoLavorazione, 'FASE 1 - B. Ricezione e lavorazione documentazione digitale' TipoLavorazione, 1.68 Corrispettivo union all

select 3 CodTipoLavorazione, 'FASE 2A - Conto Corrente Censito' TipoLavorazione, 5.15 Corrispettivo union all
select 4 CodTipoLavorazione, 'FASE 2B - Conto Corrente non Censito' TipoLavorazione, 11.55 Corrispettivo union all
select 5 CodTipoLavorazione, 'FASE 2C - Integrazione Censita' TipoLavorazione, 1.41 Corrispettivo union all
select 6 CodTipoLavorazione, 'FASE 2D - Integrazione NON Censita' TipoLavorazione, 3.44 Corrispettivo union all

select 7 CodTipoLavorazione, 'FASE 3 - ATTIVAZIONE ACCORDO' TipoLavorazione, 5.15 Corrispettivo union all

select 8 CodTipoLavorazione, 'FASE 4 - GESTIONE ANOMALIE - Regolarizzazione' TipoLavorazione, 5.25 Corrispettivo union ALL
SELECT 9 CodTipoLavorazione, 'FASE 4 - GESTIONE ANOMALIE - Apertura' TipoLavorazione, 0 Corrispettivo UNION ALL
SELECT 10 CodTipoLavorazione, 'FASE 4 - GESTIONE ANOMALIE - Pratiche SF' TipoLavorazione, 0 Corrispettivo UNION ALL
SELECT 11 CodTipoLavorazione, 'FASE 4 - GESTIONE ANOMALIE - Reworking Sospeso' TipoLavorazione, 0 Corrispettivo UNION ALL

/* supporto banking */
select 12 CodTipoLavorazione, 'Web Collaboration' TipoLavorazione, 3.58 Corrispettivo union all
select 13 CodTipoLavorazione, 'Portabilità' TipoLavorazione, 9.58 Corrispettivo union ALL
select 14 CodTipoLavorazione, 'Pred. Kit (Gestione)' TipoLavorazione, 4.47 Corrispettivo union ALL
SELECT 15 CodTipoLavorazione, 'Pred. Kit (4 Eyes)' TipoLavorazione, 0 Corrispettivo UNION ALL

/* Small Business */
select 16 CodTipoLavorazione, 'Pred. Kit SB (Lavorazione Completa)' TipoLavorazione, 39.85 Corrispettivo union all
select 17 CodTipoLavorazione, 'Pred. Kit SB (KO Oggetto Sociale)' TipoLavorazione, 0 Corrispettivo union all
select 18 CodTipoLavorazione, 'Pred. Kit SB (KO Cerved Negativa)' TipoLavorazione, 15.33 Corrispettivo union all
select 19 CodTipoLavorazione, 'Pred. Kit SB Fil. (Lavorazione Completa)' TipoLavorazione, 39.85 Corrispettivo union all
select 20 CodTipoLavorazione, 'Pred. Kit SB Fil. (KO Oggetto Sociale)' TipoLavorazione, 0 Corrispettivo union all
select 21 CodTipoLavorazione, 'Pred. Kit SB Fil. (KO Cerved Negativa)' TipoLavorazione, 15.33 Corrispettivo  UNION ALL
SELECT 22 CodTipoLavorazione, 'Pred. Kit SB (4 eyes)' TipoLavorazione, 0 Corrispettivo 


)
, TML_LAV_SEDE AS (
--FASE 1
SELECT 1 CodTipoLavorazione, 'MI' EtichettaSedeLavorazione, 1.35 TML, 613 CodTipoIncarico,  0 FlagCensito, 0 FlagCensire  union ALL
SELECT 2 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0 TML, 611 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL
SELECT 2 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0 TML, 682 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL

--FASE 2
SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 2.45 TML,  613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all
SELECT 4 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union all
SELECT 4 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 17.02 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union all
SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 2.45 TML,  611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all
SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 2.45 TML,  682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all

SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 1.05 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION all
SELECT 6 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 3.93 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union ALL
SELECT 6 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire UNION all

SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.67 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION ALL
SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.67 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION all

SELECT 7 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 6.23 TML, NULL CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL
SELECT 8 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 3.45 TML, NULL CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL
SELECT 9 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 6.1 TML, NULL CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL
SELECT 10 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.68 TML, NULL CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL
SELECT 11 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.72 TML, NULL CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL

--Supporto banking
SELECT 12 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 4.5 TML, 359 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL --webcoll
SELECT 12 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 4.5 TML, 359 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL

SELECT 13 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 10 TML, 564 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL --portabilità
SELECT 13 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 10 TML, 564 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL

SELECT 14 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 5 TML, 593 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL --predisp kit
SELECT 14 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML, 593 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL 
SELECT 15 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML, 593 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL --predisp kit 4eyes

--small business
SELECT 16 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 36 TML, 474 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union all
SELECT 17 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML, 474 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union all
SELECT 18 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML, 474 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union ALL

--smallbusiness fil
SELECT 19 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 36 TML, 523 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union all
SELECT 20 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML, 523 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire union all
SELECT 21 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML, 523 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL

--smallbusiness 4eyes
SELECT 22 CodTIpoLavorazione, 'CA' EtichettaSedeLavorazione, 10 TML, NULL CodTipoIncarico, 0 FlagCensito, 0 FlagCensire
),

timesheet AS (
/* 
	SONO INSERITE 4 ORE COSTANTI AL GIORNO DAL 15/6/2020 ALLA DATA ODIERNA PER OGNI OPERATORE
	A TENDERE QUESTA QUERY VERRA' SOSTITUITA AL TIMESHEET
*/
SELECT  S_Operatore.IdOperatore
, S_Operatore.Etichetta
, S_Operatore.CodSede
, CASE WHEN CodSede IN (10, 3) THEN 'MI' 
	WHEN CodSede = 1 THEN 'CA' 
	WHEN codsede IN (2, 11) 
	THEN 'RO' 
END AS EtichettaSedeLavorazione
,rs.S_Data.Data
, 4 AS OreDaTS
, S_Operatore.codprofiloaccesso
FROM S_Operatore 
INNER JOIN   rs.S_Data ON rs.S_Data.FlagFestivo = 0	 
	--AND CodSede = 1
	AND Data >= DATEADD(MONTH,-3,GETDATE())

JOIN T_AccessoOperatore ON S_Operatore.IdOperatore = T_AccessoOperatore.IdOperatore
AND DataUltimoAccesso >= DATEADD(MONTH,-3,getdate())

WHERE CodProfiloAccesso IN (1267,845,867,2063,2025,2039)
		
)
,

estrazioni AS (

--Fase 1 nuovo processo: Lavorazioni 1 e 2
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase1 AS DATE) DataLavorazione

,IdOperatoreFase1 IdOperatoreLavorazione
, OperatoreFase1 OperatoreLavorazione

,1 CodTipoLavorazione --Fase 1
,0 AS FlagRO
,0 FlagCensito
,0  FlagCensire
,1 N
FROM --rs.v_CESAM_CB_Fatturazione_Processo_2020
fasi
WHERE Fase1 = 1
AND CodTipoIncarico = 613

UNION ALL
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase1 AS DATE) DataLavorazione

,IdOperatoreFase1 IdOperatoreLavorazione
, OperatoreFase1 OperatoreLavorazione

,2 CodTipoLavorazione 
,1 AS FlagRO
,0  FlagCensito
,0   FlagCensire
,1 N
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase1 = 1
AND CodTipoIncarico IN (611,682)


UNION ALL

--Fase 2 nuovo processo: lavorazioni 3,4,5,6 (Cagliari + Romania)
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2AR AS DATE) DataLavorazione

,IdOperatoreFase2AR IdOperatoreLavorazione
, OperatoreFase2AR OperatoreLavorazione

,CASE WHEN FlagCC_Censito = 1 OR FlagSwitch_Censito = 1 THEN 3 
 WHEN FlagCC_DaCensire = 1 OR FlagSwitch_DaCensire = 1 then 4 END CodTipoLavorazione --Fase2 ar
,1 AS FlagRO
,CASE WHEN FlagCC_Censito = 1 OR FlagSwitch_Censito = 1  THEN 1
	ELSE 0 END FlagCensito
,CASE WHEN FlagCC_DaCensire = 1 OR FlagSwitch_DaCensire = 1  then 1 

 ELSE 0 END FlagCensire
,1 N
FROM --rs.v_CESAM_CB_Fatturazione_Processo_2020
fasi
WHERE Fase2AR = 1
AND CodTipoIncarico IN (611,613,682)
AND (FlagCC_Censito = 1 OR FlagCC_DaCensire = 1 OR FlagSwitch_Censito = 1 OR FlagSwitch_DaCensire = 1)

UNION ALL

SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione

, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2CA AS DATE) DataLavorazione

,IdOperatoreFase2CA IdOperatoreLavorazione
, OperatoreFase2CA OperatoreLavorazione

,CASE WHEN FlagCC_Censito = 1 OR FlagSwitch_Censito = 1 THEN 3 
 WHEN FlagCC_DaCensire = 1 OR FlagSwitch_DaCensire = 1 then 4 END CodTipoLavorazione --Fase2 ca
,0 AS FlagRO
,CASE WHEN FlagCC_Censito = 1 OR FlagSwitch_Censito = 1  THEN 1
	ELSE 0 END FlagCensito
,CASE WHEN FlagCC_DaCensire = 1 OR FlagSwitch_DaCensire = 1  then 1 

 ELSE 0 END FlagCensire
,1 N
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase2CA = 1
AND CodTipoIncarico IN (611,613,682)
AND (FlagCC_Censito = 1 OR FlagCC_DaCensire = 1 OR FlagSwitch_Censito = 1 OR FlagSwitch_DaCensire = 1)
UNION ALL
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2CA AS DATE) DataLavorazione

,IdOperatoreFase2CA IdOperatoreLavorazione
, OperatoreFase2CA OperatoreLavorazione

,CASE WHEN FlagDossier_Censito = 1 OR FlagKK_Censita = 1 THEN 5 
WHEN FlagDossier_DaCensire = 1 OR FlagKK_DaCensire = 1 THEN 6 
END CodTipoLavorazione --Fase2 ca
,0 AS FlagRO
,CASE WHEN FlagDossier_Censito = 1 OR FlagKK_Censita = 1 THEN 1

ELSE 0 END FlagCensito
,CASE WHEN FlagDossier_DaCensire = 1 OR FlagKK_DaCensire = 1 THEN 1
 ELSE 0 END FlagCensire
, 1 N
FROM --rs.v_CESAM_CB_Fatturazione_Processo_2020
fasi
WHERE Fase2CA = 1
AND CodTipoIncarico IN (611,613,682)
AND (FlagDossier_Censito = 1 
OR FlagDossier_DaCensire =1
OR FlagKK_Censita = 1
OR FlagKK_DaCensire = 1

)
UNION ALL
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2AR AS DATE) DataLavorazione

,IdOperatoreFase2AR IdOperatoreLavorazione
, OperatoreFase2AR OperatoreLavorazione

,CASE WHEN FlagDossier_Censito = 1 OR FlagKK_Censita = 1 THEN 5 
WHEN FlagDossier_DaCensire = 1 OR FlagKK_DaCensire = 1 THEN 6 
END CodTipoLavorazione --Fase2 ca
,1 AS FlagRO
,CASE WHEN FlagDossier_Censito = 1 OR FlagKK_Censita = 1 THEN 1

ELSE 0 END FlagCensito
,CASE WHEN FlagDossier_DaCensire = 1 OR FlagKK_DaCensire = 1 THEN 1
 ELSE 0 END FlagCensire
,1 N
FROM --rs.v_CESAM_CB_Fatturazione_Processo_2020
fasi
WHERE Fase2AR = 1
AND CodTipoIncarico IN (611,613,682)
AND (FlagDossier_Censito = 1 
OR FlagDossier_DaCensire =1
OR FlagKK_Censita = 1
OR FlagKK_DaCensire = 1

)


UNION ALL
--Fase 3 nuovo processo
SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase3 AS DATE) DataLavorazione

,IdOperatoreFase3 IdOperatoreLavorazione
, OperatoreFase3 OperatoreLavorazione

,7 CodTipoLavorazione --Fase3 

,0 AS FlagRO
,0 FlagCensito
,0 FlagCensire
,1 N
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase3 = 1
AND CodTipoIncarico IN (611,613,682)
UNION ALL

--Fase 4
SELECT ti.IdIncarico
,CAST(ti.DataCreazione AS DATE) DataCreazione
,ti.CodTipoIncarico
,D_TipoIncarico.Descrizione TipoIncarico
,CASE WHEN Ti.ChiaveCliente IS NULL OR ti.chiavecliente = ''
	THEN T_Persona.ChiaveCliente
	ELSE ti.chiavecliente 
	END ChiaveIncarico
, T_Persona.ChiaveCliente NDG ,T_Persona.Cognome ,T_Persona.Nome
,CAST(fasi4.DataTransizione AS DATE) DataLavorazione
,fasi4.IdOperatore IdOperatoreLavorazione
,fasi4.Etichetta OperatoreLavorazione
,CASE fasi4.CodStatoWorkflowIncaricoDestinazione
	WHEN 6560 THEN 8
	WHEN 13250 THEN 9
	WHEN 15546 THEN 10
	WHEN 15429 THEN 11
	END CodTipoLavorazione
,0 FlagRO
,0 FlagCensito
,0 FlagCensire
,IIF(fasi4.N = 0,1,fasi4.N) N


FROM T_Incarico ti
JOIN D_TipoIncarico ON ti.CodTipoIncarico = D_TipoIncarico.Codice
JOIN (
			SELECT lwi.IdTransizione, tix.IdIncarico, lwi.DataTransizione, lwi.IdOperatore, sox.Etichetta
			,lwi.CodStatoWorkflowIncaricoDestinazione,  count(IdMotivoTransizione) N

			FROM L_WorkflowIncarico lwi
			JOIN T_Incarico tix ON lwi.idincarico = tix.IdIncarico
			AND tix.CodArea = 8 AND tix.CodCliente = 48 AND tix.CodTipoIncarico IN (611,613,682)
			LEFT JOIN L_MotivoTransizione ON lwi.IdTransizione = L_MotivoTransizione.IdTransizione
			AND tix.IdIncarico = L_MotivoTransizione.IdIncarico
			JOIN S_Operatore sox ON lwi.IdOperatore = sox.IdOperatore
			WHERE lwi.codStatoWorkflowIncaricoPartenza != lwi.CodStatoWorkflowincaricodestinazione
			AND lwi.codstatoworkflowincaricodestinazione IN (  6560	 --Regolarizzata
															 ,13250	 --Gestione Anomalie														
															 ,15546	 --Integrazioni Ricevute
															)
			AND lwi.IdOperatore NOT IN (21,12520,12667) --escludo bot/utenze di sistema
			--AND  tix.idincarico = 16170388
			GROUP BY lwi.IdTransizione, tix.IdIncarico, lwi.DataTransizione, lwi.IdOperatore, sox.Etichetta
			,lwi.CodStatoWorkflowIncaricoDestinazione
			UNION ALL
			SELECT lwi.IdTransizione, tix.IdIncarico, lwi.DataTransizione, lwi.IdOperatore, sox.Etichetta
			,CASE CodMotivoTransizione 
				WHEN 130 THEN lwi.CodStatoWorkflowIncaricoDestinazione 
				WHEN 131 THEN 13250 
				END CodStatoWorkflowIncaricoDestinazione
				,1 N
			FROM L_WorkflowIncarico lwi
			JOIN T_Incarico tix ON lwi.idincarico = tix.IdIncarico
			AND tix.CodArea = 8 AND tix.CodCliente = 48 AND tix.CodTipoIncarico IN (611,613,682)
			JOIN L_MotivoTransizione ON lwi.IdTransizione = L_MotivoTransizione.IdTransizione
			AND tix.IdIncarico = L_MotivoTransizione.IdIncarico 
			JOIN S_Operatore sox ON lwi.IdOperatore = sox.IdOperatore
			WHERE lwi.codStatoWorkflowIncaricoPartenza != lwi.CodStatoWorkflowincaricodestinazione
			AND lwi.codstatoworkflowincaricodestinazione IN (15429	 --Richiesta chiarimenti/integrazioni															 
															)
			AND lwi.IdOperatore NOT IN (21,12520,12667) --escludo bot/utenze di sistema

) fasi4 ON ti.IdIncarico = fasi4.IdIncarico
LEFT JOIN T_R_Incarico_Persona ON ti.IdIncarico = T_R_Incarico_Persona.IdIncarico
AND Progressivo = 1
LEFT JOIN T_Persona ON T_R_Incarico_Persona.IdPersona = T_Persona.IdPersona
WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.CodTipoIncarico IN (611,613,682)
--AND ti.IdIncarico = 16135173  

UNION ALL

--Altri incarichi cb (Gestore Incarico)
SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(DataCreazione AS DATE) DataLavorazione
,IdOperatoreGestore
,OperatoreGestore OperatoreLavorazione
,CASE 
WHEN FlagConsulenza = 1 THEN 12 --Consulenza
WHEN FlagTSP = 1 THEN 13 --Trasferimento Servizi Pagamento

END CodTipoLavorazione 

,0 AS FlagRO
,0 FlagCensito
,0 FlagCensire
,1 n

FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE --CodTipoIncarico NOT IN (611,613,682)
CodTipoIncarico IN (359,564)
AND IdOperatoreGestore IS NOT NULL

UNION ALL

--Altri incarichi cb (Gestore Incarico Supporto)
SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(DataCreazione AS DATE) DataLavorazione
,IdOpertatoreGestoreSupporto IdOperatoreGestore
,OperatoreGestoreSupporto OperatoreLavorazione

,CASE 
WHEN FlagConsulenza = 1 THEN 12 --Consulenza
WHEN FlagTSP = 1 THEN 13 --Trasferimento Servizi Pagamento

END CodTipoLavorazione 
,1 AS FlagRO
,0 FlagCensito
,0 FlagCensire
, 1 N
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE --CodTipoIncarico NOT IN (611,613,682)
CodTipoIncarico IN (359,564)
AND FlagAggiornamentoDocumentale = 0
AND IdOpertatoreGestoreSupporto IS NOT NULL

UNION ALL

--Altri incarichi cb (Nessun Ruolo)
SELECT DISTINCT T_Incarico.IdIncarico
,CAST( T_Incarico.DataCreazione AS DATE) DataCreazione
, T_Incarico.CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,v.Cognome,v.Nome

,CAST(T_Incarico.DataCreazione AS DATE) DataLavorazione
,L_WorkflowIncarico.IdOperatore IdOperatoreGestore
,S_Operatore.Etichetta OperatoreLavorazione

,CASE 
WHEN FlagConsulenza = 1 THEN 12 --Consulenza
WHEN FlagTSP = 1 THEN 13 --Trasferimento Servizi Pagamento

END CodTipoLavorazione 
,0 AS FlagRO
,0 FlagCensito
,0 FlagCensire
, 1 N
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020 v
JOIN T_Incarico ON v.IdIncarico = T_Incarico.IdIncarico
JOIN L_WorkflowIncarico ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
AND DataTransizione = T_Incarico.DataUltimaTransizione
JOIN S_Operatore ON L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore
WHERE --CodTipoIncarico NOT IN (611,613,682)
T_Incarico.CodTipoIncarico IN (359,564)
AND FlagAggiornamentoDocumentale = 0
AND IdOpertatoreGestoreSupporto IS NULL
AND IdOperatoreGestore IS NULL

UNION ALL

--Generazioni Kit 
SELECT ti.IdIncarico
,ti.DataCreazione
,ti.CodTipoIncarico, dti.Descrizione TipoIncarico
,ti.ChiaveCliente ChiaveIncarico
,tp.ChiaveCliente NDG
,CASE WHEN tp.Cognome IS NULL OR tp.Cognome = ''
	THEN tp.RagioneSociale
	ELSE tp.Cognome
	END Cognome
,ISNULL(tp.nome,'') Nome
,lavorazione.DataTransizione DataLavorazione
,ISNULL(OperatoreSupporto.IdOperatore,OperatoreGestore.IdOperatore) IdOperatoreGestore
,ISNULL(OperatoreSupporto.Etichetta,OperatoreGestore.Etichetta) EtichettaOperatoreGestore

,CASE WHEN ti.CodTipoIncarico = 593 THEN 14
	WHEN ti.CodTipoIncarico = 474  --Lavorazione sb completa
		THEN 16 
	WHEN ti.CodTipoIncarico = 523  --Lavorazione sb Fil completa
		THEN 19
	END CodTipoLavorazione
,IIF(trOperatoreSupporto.CodRuoloOperatoreIncarico IS NOT NULL,1,0) FlagRO
,0 FlagCensito
,0 FlagCensire
,1 N
FROM T_Incarico ti
JOIN D_TipoIncarico dti ON ti.CodTipoIncarico = dti.Codice

LEFT JOIN T_R_Incarico_Operatore trOperatoreGestore ON ti.IdIncarico = trOperatoreGestore.IdIncarico
AND trOperatoreGestore.CodRuoloOperatoreIncarico = 1
LEFT JOIN S_Operatore OperatoreGestore ON trOperatoreGestore.IdOperatore = OperatoreGestore.IdOperatore

LEFT JOIN T_R_Incarico_Operatore trOperatoreSupporto ON ti.IdIncarico = trOperatoreSupporto.IdIncarico
AND trOperatoreSupporto.CodRuoloOperatoreIncarico = 2
LEFT JOIN S_Operatore OperatoreSupporto ON trOperatoreSupporto.IdOperatore = OperatoreSupporto.IdOperatore

JOIN T_R_Incarico_Persona trip ON ti.IdIncarico = trip.IdIncarico
AND trip.Progressivo = 1
JOIN T_Persona tp ON trip.IdPersona = tp.IdPersona
JOIN (
		SELECT MIN(lwi1.IdTransizione) IdTransizione, ti1.idincarico 
		FROM T_Incarico ti1
		JOIN L_WorkflowIncarico lwi1 ON ti1.idincarico = lwi1.IdIncarico
		AND ti1.CodArea = 8 AND ti1.CodCliente = 48 AND ti1.CodTipoIncarico IN (474,523,593)
		WHERE lwi1.CodStatoWorkflowIncaricoPartenza != lwi1.CodStatoWorkflowIncaricoDestinazione
		AND lwi1.CodStatoWorkflowIncaricoDestinazione = 14555 --Genera Controlli Predisposizione
		GROUP BY ti1.idincarico
	) inputLavorazione ON ti.IdIncarico = inputLavorazione.IdIncarico
JOIN L_WorkflowIncarico lavorazione ON inputLavorazione.IdTransizione = lavorazione.IdTransizione


WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.CodTipoIncarico IN (
474	--Generazione kit Small Business
,523	--Generazione Kit Small Business Filiali
,593	--Generazione kit Persone Fisiche
)
AND ti.FlagArchiviato = 0
AND ti.CodStatoWorkflowIncarico != 15447 --requisiti assenti
and ti.datacreazione >= '20200615'

UNION ALL

SELECT ti.IdIncarico
,ti.DataCreazione
,ti.CodTipoIncarico, dti.Descrizione TipoIncarico
,ti.ChiaveCliente ChiaveIncarico
,tp.ChiaveCliente NDG
,CASE WHEN tp.Cognome IS NULL OR tp.Cognome = ''
	THEN tp.RagioneSociale
	ELSE tp.Cognome
	END Cognome
,ISNULL(tp.nome,'') Nome
,sb.DataTransizione DataLavorazione
,ISNULL(OperatoreSupporto.IdOperatore,OperatoreGestore.IdOperatore) IdOperatoreGestore
,ISNULL(OperatoreSupporto.Etichetta,OperatoreGestore.Etichetta) EtichettaOperatoreGestore

,CASE WHEN ti.CodTipoIncarico = 474 AND sb.CodStatoWorkflowIncaricoDestinazione = 15446 --KO Oggetto sociale
		THEN 17
	WHEN ti.CodTipoIncarico = 474 AND sb.CodStatoWorkflowIncaricoDestinazione = 15445 --KO CERVED negativa
		THEN 18
	 
	WHEN ti.CodTipoIncarico = 523 AND sb.CodStatoWorkflowIncaricoDestinazione = 15446 --KO Oggetto sociale
		THEN 20
	WHEN ti.CodTipoIncarico = 523 AND sb.CodStatoWorkflowIncaricoDestinazione = 15445 --KO CERVED Fil negativa
		THEN 21
	
	END CodTipoLavorazione
,IIF(trOperatoreSupporto.CodRuoloOperatoreIncarico IS NOT NULL,1,0) FlagRO
,0 FlagCensito
,0 FlagCensire
,1 N
FROM T_Incarico ti
JOIN D_TipoIncarico dti ON ti.CodTipoIncarico = dti.Codice

LEFT JOIN T_R_Incarico_Operatore trOperatoreGestore ON ti.IdIncarico = trOperatoreGestore.IdIncarico
AND trOperatoreGestore.CodRuoloOperatoreIncarico = 1
LEFT JOIN S_Operatore OperatoreGestore ON trOperatoreGestore.IdOperatore = OperatoreGestore.IdOperatore

LEFT JOIN T_R_Incarico_Operatore trOperatoreSupporto ON ti.IdIncarico = trOperatoreSupporto.IdIncarico
AND trOperatoreSupporto.CodRuoloOperatoreIncarico = 2
LEFT JOIN S_Operatore OperatoreSupporto ON trOperatoreSupporto.IdOperatore = OperatoreSupporto.IdOperatore

JOIN T_R_Incarico_Persona trip ON ti.IdIncarico = trip.IdIncarico
AND trip.Progressivo = 1
JOIN T_Persona tp ON trip.IdPersona = tp.IdPersona

LEFT JOIN (
			SELECT MIN(lwi2.IdTransizione) IdTransizione, ti2.IdIncarico
			FROM L_WorkflowIncarico lwi2
			JOIN T_Incarico ti2 ON lwi2.IdIncarico = ti2.IdIncarico
			AND ti2.CodArea = 8 AND ti2.CodCliente = 48 AND ti2.CodTipoIncarico IN (474,523)
			WHERE lwi2.CodStatoWorkflowIncaricoPartenza != lwi2.CodStatoWorkflowIncaricoDestinazione
			AND lwi2.CodStatoWorkflowIncaricoDestinazione IN (15446,15445)
			GROUP BY ti2.IdIncarico
			) inputSB ON ti.IdIncarico = inputSB.idincarico

LEFT JOIN L_WorkflowIncarico SB ON inputSB.IdTransizione = sb.IdTransizione

WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.CodTipoIncarico IN (
474	--Generazione kit Small Business
,523	--Generazione Kit Small Business Filiali
,593	--Generazione kit Persone Fisiche
)

AND ti.FlagArchiviato = 0
AND ti.CodStatoWorkflowIncarico != 15447 --requisiti assenti
and ti.datacreazione >= '20200615'

UNION ALL

--Generazioni kit (4 eyes)
SELECT ti.IdIncarico
,ti.DataCreazione
,ti.CodTipoIncarico, dti.Descrizione TipoIncarico
,ti.ChiaveCliente ChiaveIncarico
,tp.ChiaveCliente NDG
,CASE WHEN tp.Cognome IS NULL OR tp.Cognome = ''
	THEN tp.RagioneSociale
	ELSE tp.Cognome
	END Cognome
,ISNULL(tp.nome,'') Nome
,lavorazione.DataTransizione DataLavorazione
,Operatore4Eyes.IdOperatore IdOperatoreGestore
,operatore4eyes.Etichetta EtichettaOperatoreGestore

,CASE WHEN ti.CodTipoIncarico = 593 THEN 15
	WHEN ti.CodTipoIncarico IN (474,523) THEN 22	
	END CodTipoLavorazione
,0 FlagRO
,0 FlagCensito
,0 FlagCensire
,1 N
FROM T_Incarico ti
JOIN D_TipoIncarico dti ON ti.CodTipoIncarico = dti.Codice

jOIN T_R_Incarico_Operatore trOperatore4Eyes ON ti.IdIncarico = trOperatore4Eyes.IdIncarico
AND trOperatore4Eyes.CodRuoloOperatoreIncarico = 3
JOIN S_Operatore Operatore4Eyes ON trOperatore4Eyes.IdOperatore = Operatore4Eyes.IdOperatore

JOIN T_R_Incarico_Persona trip ON ti.IdIncarico = trip.IdIncarico
AND trip.Progressivo = 1
JOIN T_Persona tp ON trip.IdPersona = tp.IdPersona
JOIN (
		SELECT MIN(lwi1.IdTransizione) IdTransizione, ti1.idincarico 
		FROM T_Incarico ti1
		JOIN L_WorkflowIncarico lwi1 ON ti1.idincarico = lwi1.IdIncarico
		AND ti1.CodArea = 8 AND ti1.CodCliente = 48 AND ti1.CodTipoIncarico IN (474,523,593)
		WHERE lwi1.CodStatoWorkflowIncaricoPartenza != lwi1.CodStatoWorkflowIncaricoDestinazione
		AND lwi1.CodStatoWorkflowIncaricoDestinazione = 14299 --Invio contratto
		GROUP BY ti1.idincarico
	) inputLavorazione ON ti.IdIncarico = inputLavorazione.IdIncarico
JOIN L_WorkflowIncarico lavorazione ON inputLavorazione.IdTransizione = lavorazione.IdTransizione

WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.CodTipoIncarico IN (
474	--Generazione kit Small Business
,523	--Generazione Kit Small Business Filiali
,593	--Generazione kit Persone Fisiche
)
AND ti.FlagArchiviato = 0
AND ti.CodStatoWorkflowIncarico != 15447 --requisiti assenti
and ti.datacreazione >= '20200615'

)
,dataset AS (
SELECT ESTRAZIONI.IdIncarico
	  ,ESTRAZIONI.DataCreazione
	  ,ESTRAZIONI.CodTipoIncarico
	  ,ESTRAZIONI.TipoIncarico
	  ,ESTRAZIONI.ChiaveIncarico
	  ,ESTRAZIONI.NDG
	  ,ESTRAZIONI.Cognome
	  ,ESTRAZIONI.Nome
	  ,CAST(ESTRAZIONI.DataLavorazione AS DATE) DataLavorazione

	  /* se capita che fase 1 cartaceo (creazione) risulta cagliari (es idincarico 15273868), attribuisco come operatore Marica, TL Acquisizione Milano) */

	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		 THEN 8420 ELSE  estrazioni.IdOperatoreLavorazione END IdOperatoreLavorazione
	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		THEN 'Maestrello M.' else ESTRAZIONI.OperatoreLavorazione END OperatoreLavorazione
	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		THEN 3 ELSE  CodSede END CodSedeLavorazione
	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		THEN 'Mi' ELSE D_SedeOperatore.Descrizione END SedeOperatore

	/******************************************************************************************************************************************/

	  ,CASE WHEN CodSede IN (10,3) OR (estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0) THEN 'MI'
		WHEN CodSede = 1 THEN 'CA'
		WHEN codsede IN (2,11) THEN 'RO'
		END AS EtichettaSedeLavorazione
	  ,estrazioni.CodTipoLavorazione
	  ,TipoLavorazione

	  ,CASE 
	  
		--WHEN CodSede IN (11) AND CodTipoIncarico IN (611,613,682) AND estrazioni.CodTipoLavorazione IN (3,4,5,6)
		--		 THEN 0
		WHEN ROW_NUMBER() OVER (PARTITION BY IdIncarico,estrazioni.CodTipoLavorazione 
									ORDER BY IdIncarico, estrazioni.CodTipoLavorazione, CodSede
								) >1 AND estrazioni.CodTipoLavorazione != 8
			 THEN 0
		ELSE n * Corrispettivo
		
		END Corrispettivo
	 , FlagCensito
	 , FlagCensire
	 ,N
FROM estrazioni
LEFT JOIN S_Operatore ON estrazioni.IdOperatoreLavorazione = S_Operatore.IdOperatore

LEFT JOIN D_SedeOperatore ON S_Operatore.CodSede = D_SedeOperatore.Codice
LEFT JOIN lavorazioni ON estrazioni.CodTipoLavorazione = lavorazioni.CodTipoLavorazione

)

--SELECT * FROM dataset WHERE IdIncarico = 16011541

SELECT 

dataset.IdIncarico
	  ,dataset.DataCreazione
	  ,dataset.CodTipoIncarico
	  ,dataset.TipoIncarico
	  ,dataset.ChiaveIncarico
	  ,dataset.NDG
	  ,dataset.Cognome
	  ,dataset.Nome
	  
	  ,ISNULL(DataLavorazione,Data) DataLavorazione
	  ,ISNULL(dataset.IdOperatoreLavorazione,IdOperatore) IdOperatoreLavorazione
	  ,ISNULL(OperatoreLavorazione,Etichetta) OperatoreLavorazione
	  ,ISNULL(CodSedeLavorazione,CodSede) CodSedeLavorazione
	  ,ISNULL(SedeOperatore,timesheet.EtichettaSedeLavorazione) SedeOperatore
	  ,ISNULL(dataset.EtichettaSedeLavorazione,timesheet.EtichettaSedeLavorazione) EtichettaSedeLavorazione
	  
	  ,dataset.CodTipoLavorazione
	  ,dataset.TipoLavorazione
	  ,dataset.Corrispettivo	
	  ,IIF(dataset.Corrispettivo = 0 OR Corrispettivo IS null,0,1) IsFatturata
	  ,TML / 55 TML
	  ,TML TMLMinuti
	  ,
		CASE WHEN 
		ROW_NUMBER() OVER (PARTITION BY IdOperatore,timesheet.Data ORDER BY IdOperatore,timesheet.Data) >1  THEN 0
		ELSE 
	  ISNULL(OreDaTS,0)  
	  END OreDaTS
	,N
FROM dataset
LEFT JOIN TML_LAV_SEDE ON dataset.EtichettaSedeLavorazione = TML_LAV_SEDE.EtichettaSedeLavorazione
AND TML_LAV_SEDE.CodTipoLavorazione = dataset.CodTipoLavorazione
AND dataset.FlagCensito = TML_LAV_SEDE.FlagCensito
AND dataset.FlagCensire = TML_LAV_SEDE.FlagCensire
AND ( dataset.CodTipoIncarico = TML_LAV_SEDE.CodTipoIncarico OR TML_LAV_SEDE.CodTipoIncarico IS NULL)
--AND TML_LAV_SEDE.CodTipoLavorazione IS NOT NULL

FULL JOIN timesheet ON IdOperatoreLavorazione = IdOperatore
AND DataLavorazione = timesheet.Data
--WHERE idincarico is not NULL
--WHERE DataLavorazione >= '2020-11-01' AND DataLavorazione < '2020-12-01'
--AND  IdIncarico IN (16246784 -- 16355568 --16307424 
----,16186690
--)

--SELECT * FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
--WHERE IdIncarico = 16246784


GO
