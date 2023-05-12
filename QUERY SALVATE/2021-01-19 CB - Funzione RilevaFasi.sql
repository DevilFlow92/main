USE clc
GO

--CREATE FUNCTION rs.f_CESAM_CB_RilevaFasi_Incarico
--(
	--IdIncarico INT
	--,InizioDataLavorazione DATETIME
	--,FineDataLavorazione DATETIME

--)

--RETURNS @Fasi  TABLE (
    --   IdIncarico INT
    --   ,CodTipoLavorazione SMALLINT
	   --,TipoLavorazione VARCHAR(255)
    --   ,DataLavorazione DATETIME
	   --,IdOperatoreLavorazione INT
	   --,EtichettaOperatore varchar(100)
	   --,EtichettaSedeLavorazione VARCHAR(5)
	   --,Corrispettivo DECIMAL(18,2)
	   --,IsFatturata BIT
	   --,TML DECIMAL(18,2)
	   --,TMLMinuti DECIMAL (18,2)
	   --,n SMALLINT
	   
--) AS
BEGIN


/********* decommentare per test ***********************/

--DECLARE @idincarico INT = --16573670  --613
--16829033 --611
--16978283 --359 con gestore popolato
--16983723 --359 senza gestore popolato
--13367910 --564 senza gestore popolato
--15575525  --564 con gestore popolato
--17029704 --593 gen kit pf con gestori

--,@InizioDataLavorazione DATETIME = '20210101'
--,@FineDataLavorazione DATETIME = '20210115'

/****************************************************/

DECLARE @Fasi  TABLE (
       IdIncarico INT
       ,CodTipoLavorazione SMALLINT
	   ,TipoLavorazione VARCHAR(255)
       ,DataLavorazione DATETIME
	   ,IdOperatoreLavorazione INT
	   ,EtichettaOperatore varchar(100)
	   ,EtichettaSedeLavorazione VARCHAR(5)
	   ,Corrispettivo DECIMAL(18,2)
	   ,IsFatturata BIT
	   ,TML DECIMAL(18,2)
	   ,TMLMinuti DECIMAL (18,2)
	   ,n SMALLINT
	   		    
)

/******************************/

/******* IMPOSTARE LAVORAZIONI E CORRISPETTIVI *******/
DECLARE @Lavorazioni TABLE (
CodTipoLavorazione INT
,TipoLavorazione VARCHAR(255)
,Corrispettivo DECIMAL(18,2)

)
/* core business */
INSERT INTO @Lavorazioni (CodTipoLavorazione, TipoLavorazione, Corrispettivo)
select 1 CodTipoLavorazione, 'FASE 1 - A. Attività relative al giro logistico' TipoLavorazione, 2.58 Corrispettivo union all
select 2 CodTipoLavorazione, 'FASE 1 - B. Ricezione e lavorazione documentazione digitale' TipoLavorazione, 1.68 Corrispettivo union all

select 3 CodTipoLavorazione, 'FASE 2A - Conto Corrente Censito (Pre-Istruttoria)' TipoLavorazione, 0 Corrispettivo union all
select 4 CodTipoLavorazione, 'FASE 2B - Conto Corrente non Censito (Pre-Istruttoria)' TipoLavorazione, 0 Corrispettivo union all
select 5 CodTipoLavorazione, 'FASE 2C - Integrazione Censita (Pre-Istruttoria)' TipoLavorazione, 0 Corrispettivo union all
select 6 CodTipoLavorazione, 'FASE 2D - Integrazione NON Censita (Pre-Istruttoria)' TipoLavorazione, 0 Corrispettivo union all

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
SELECT 22 CodTipoLavorazione, 'Pred. Kit SB (4 eyes)' TipoLavorazione, 0 Corrispettivo UNION ALL

/* fase 2 core business "istruttoria" */
select 23 CodTipoLavorazione, 'FASE 2A - Conto Corrente Censito (Istruttoria)' TipoLavorazione, 5.15 Corrispettivo union all
select 24 CodTipoLavorazione, 'FASE 2B - Conto Corrente non Censito (Istruttoria)' TipoLavorazione, 11.55 Corrispettivo union all
select 25 CodTipoLavorazione, 'FASE 2C - Integrazione Censita (Istruttoria)' TipoLavorazione, 1.41 Corrispettivo union all
select 26 CodTipoLavorazione, 'FASE 2D - Integrazione NON Censita (Istruttoria)' TipoLavorazione, 3.44 Corrispettivo 

/*****************************************************/


/******* IMPOSTARE TEMPI MEDI LAVORAZIONE ************/
DECLARE @TML_LAV_SEDE TABLE (
CodTipoLavorazione INT
,EtichettaSedeLavorazione VARCHAR(5)
,TML DECIMAL(18,2)
,CodTipoIncarico INT
,FlagCensito BIT
,FlagCensire BIT
)
INSERT INTO @TML_LAV_SEDE (CodTipoLavorazione, EtichettaSedeLavorazione, TML, CodTipoIncarico, FlagCensito, FlagCensire)
--FASE 1
SELECT 1 CodTipoLavorazione, 'MI' EtichettaSedeLavorazione, 1.35 TML, 613 CodTipoIncarico,  0 FlagCensito, 0 FlagCensire  union ALL
SELECT 2 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0 TML, 611 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL
SELECT 2 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0 TML, 682 CodTipoIncarico, 0 FlagCensito, 0 FlagCensire UNION ALL

--FASE 2
SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 9.12 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 23 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 2.45 TML,  613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all
SELECT 23 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 2.45 TML,  613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all

SELECT 4 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union all
SELECT 4 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 9.12 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union all
SELECT 24 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 17.02 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union all
SELECT 24 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 17.02 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union all

SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 9.12 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 23 CodTipoLavorazione,'CA' EtichettaSedeLavorazione, 2.45 TML,  611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all
SELECT 23 CodTipoLavorazione,'RO' EtichettaSedeLavorazione, 2.45 TML,  611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all

SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 9.12 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 9.12 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 23 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 2.45 TML,  682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all
SELECT 23 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 2.45 TML,  682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union all

SELECT 25 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 1.05 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 25 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 1.05 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION all
SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.97 TML, 613 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION all

SELECT 26 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 3.93 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union ALL
SELECT 26 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 3.93 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire union ALL
SELECT 6 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire UNION all
SELECT 6 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.97 TML, 613 CodTipoIncarico, 0 FlagCensito, 1 FlagCensire UNION all

SELECT 25 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.67 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 25 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.67 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION ALL
SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.97 TML, 611 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION ALL

SELECT 25 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.67 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 25 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.67 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire union ALL
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 0.97 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION all
SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 0.97 TML, 682 CodTipoIncarico, 1 FlagCensito, 0 FlagCensire UNION all

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
SELECT 22 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 10 TML, null CodTipoIncarico, 0 FlagCensito, 0 FlagCensire

/*****************************************************/

DECLARE @Estrazioni TABLE (
		IdIncarico INT
	  ,CodTipoIncarico INT
	  ,DataLavorazione DATETIME
	  ,IdOperatoreLavorazione INT
	  ,EtichettaOperatoreLavorazione VARCHAR(100)
	  ,CodTipoLavorazione INT
	  --,FlagRO BIT
	  ,FlagCensito bit
	  ,FlagCensire bit
	  ,N SMALLINT
	  )

DECLARE @FlagCensiti TABLE (
IdIncarico INT 
,FlagCensito BIT
,FlagCensire BIT
,FlagConto_Censito BIT
,FlagConto_Censire BIT
,FlagIntegrazione_Censito BIT
,FlagIntegrazione_Censire BIT

)

INSERT INTO @FlagCensiti (IdIncarico, FlagCensito, FlagCensire, FlagConto_Censito, FlagConto_Censire, FlagIntegrazione_Censito, FlagIntegrazione_Censire)
SELECT tix.IdIncarico
,CASE WHEN tix.CodTipoIncarico IN (611,682) then 1
	WHEN cc.CodGiudizioControllo = 2 THEN 1
	WHEN Dossier.CodGiudizioControllo = 2 THEN 1
	WHEN kk.CodGiudizioControllo = 2  THEN 1
	WHEN switch.CodGiudizioControllo = 2 THEN 1
	
	ELSE 0 END FlagCensito
,CASE WHEN cc.CodGiudizioControllo = 4 THEN 1
	WHEN Dossier.CodGiudizioControllo = 4 THEN 1
	WHEN kk.CodGiudizioControllo = 4 THEN 1
	WHEN SWITCH.CodGiudizioControllo = 4 THEN 1
	ELSE 0 END FlagCensire

,CASE WHEN tix.CodTipoIncarico IN (611,682) THEN 1
	WHEN cc.CodGiudizioControllo = 2 THEN 1
	WHEN switch.CodGiudizioControllo = 2 THEN 1
	ELSE 0
END AS FlagConto_Censito
,CASE WHEN cc.CodGiudizioControllo = 4 THEN 1
		WHEN SWITCH.CodGiudizioControllo = 4 THEN 1
	ELSE 0
 END FlagConto_Censire

,CASE WHEN Dossier.CodGiudizioControllo = 2 THEN 1
	WHEN kk.CodGiudizioControllo = 2 THEN 1
 ELSE 0
 END FlagIntegrazione_Censito
,CASE WHEN Dossier.CodGiudizioControllo = 4 THEN 1
 WHEN kk.CodGiudizioControllo = 4 THEN 1
 ELSE 0
 END FlagIntegrazione_Censire
FROM T_Incarico tix

LEFT JOIN T_MacroControllo tmc ON tix.IdIncarico = tmc.IdIncarico
AND IdTipoMacroControllo = 3205

LEFT JOIN T_Controllo cc ON tmc.IdMacroControllo = cc.IdMacroControllo
AND cc.IdTipoControllo = 8327	--Conto Corrente censito
LEFT JOIN T_Controllo Dossier ON tmc.IdMacroControllo = Dossier.IdMacroControllo
AND Dossier.IdTipoControllo = 8328	--Dossier censito
LEFT JOIN T_Controllo kk ON tmc.IdMacroControllo = kk.IdMacroControllo
AND kk.IdTipoControllo = 8329	--Carta di Credito censita

LEFT JOIN T_Controllo switch ON tmc.IdMacroControllo = switch.IdMacroControllo
AND switch.IdTipoControllo = 8442 --switch censito
WHERE tix.IdIncarico = @idincarico


DECLARE @CodTipoIncarico INT = (SELECT CodTipoIncarico FROM T_Incarico WHERE IdIncarico = @idincarico)

--SELECT @CodTipoIncarico

/***** ALGORITMO ESTRAZIONE FASI *****/
IF @CodTipoIncarico = 613
BEGIN
	--fase 1 CHECK-IN CARTACEO MI
	INSERT INTO @Estrazioni (IdIncarico, CodTipoIncarico, DataLavorazione, IdOperatoreLavorazione, EtichettaOperatoreLavorazione, CodTipoLavorazione, FlagCensito, FlagCensire, N)
	SELECT Ti1.IdIncarico, Ti1.CodTipoIncarico, wf1.DataTransizione, wf1.IdOperatore, Etichetta, 1 CodTipoLavorazione,0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico Ti1	

	CROSS APPLY (SELECT TOP 1 lwi1.IdTransizione, lwi1.DataTransizione, lwi1.IdOperatore, lwi1.IdIncarico
                 FROM L_WorkflowIncarico lwi1
					WHERE lwi1.IdIncarico = ti1.idincarico
						AND lwi1.CodStatoWorkflowIncaricoPartenza IS NULL
						AND lwi1.CodStatoWorkflowIncaricoDestinazione = 6500 --Creazione
						--AND lwi1.DataTransizione >= @InizioDataLavorazione AND lwi1.DataTransizione < @FineDataLavorazione
					--ORDER BY lwi1.DataTransizione ASC
				) wf1
	JOIN S_Operatore ON wf1.IdOperatore = S_Operatore.IdOperatore
	WHERE Ti1.IdIncarico = @IdIncarico
END

IF @CodTipoIncarico IN (611,682)
BEGIN
		INSERT INTO @Estrazioni (IdIncarico, CodTipoIncarico, DataLavorazione, IdOperatoreLavorazione, EtichettaOperatoreLavorazione, CodTipoLavorazione,  FlagCensito, FlagCensire, N)
		--FASE 1 AR FEA
		SELECT ti1.IdIncarico, ti1.CodTipoIncarico, wf1.DataTransizione,  wf1.IdOperatore, so1.Etichetta, 2 CodTipoLavorazione,0  FlagCensito,0 FlagCensire,1 N
		FROM T_Incarico ti1
		
		CROSS APPLY (
						SELECT TOP 1 lwi1.IdTransizione, lwi1.DataTransizione, lwi1.IdOperatore, lwi1.IdIncarico
						FROM L_WorkflowIncarico lwi1
						WHERE lwi1.IdIncarico = ti1.idincarico
								AND lwi1.CodStatoWorkflowIncaricoPartenza <> lwi1.CodStatoWorkflowIncaricoDestinazione
								AND lwi1.CodStatoWorkflowIncaricoDestinazione = 14550 --Genera Controlli Gestione
								--AND lwi1.DataTransizione >= @InizioDataLavorazione	AND lwi1.DataTransizione < @FineDataLavorazione
						
		) wf1
		JOIN S_Operatore so1 ON wf1.IdOperatore = so1.IdOperatore
		WHERE ti1.IdIncarico = @idincarico
END

IF @CodTipoIncarico IN (613,611,682)
BEGIN
	INSERT INTO @Estrazioni (IdIncarico, CodTipoIncarico, DataLavorazione, IdOperatoreLavorazione, EtichettaOperatoreLavorazione, CodTipoLavorazione, FlagCensito, FlagCensire, N)
	--Fase 2 Pre-Istruttoria (Conto)
	SELECT  ti2.IdIncarico, ti2.CodTipoIncarico, wf2.DataTransizione, wf2.IdOperatore, Etichetta
	,CASE WHEN FlagCensito = 1 THEN 3 WHEN FlagCensire = 1 THEN 4 END  CodTipoLavorazione, FlagCensito, FlagCensire, 1 N
	FROM T_Incarico ti2
	JOIN @FlagCensiti ON ti2.IdIncarico = [@FlagCensiti].IdIncarico
	AND (FlagConto_Censito = 1 OR FlagConto_Censire = 1)
	CROSS APPLY (
					SELECT TOP 1 lwi2.IdTransizione, lwi2.DataTransizione, lwi2.IdOperatore, lwi2.IdIncarico
					FROM L_WorkflowIncarico lwi2
					WHERE lwi2.IdIncarico = ti2.idincarico
						AND lwi2.CodStatoWorkflowIncaricoPartenza <> lwi2.CodStatoWorkflowIncaricoDestinazione
						AND lwi2.CodStatoWorkflowIncaricoDestinazione = 14530 --Popolamento e Verifiche Effettuate
						--AND lwi2.DataTransizione >= @InizioDataLavorazione AND lwi2.DataTransizione < @FineDataLavorazione
					--ORDER BY lwi2.DataTransizione ASC
	) wf2
	JOIN S_Operatore ON wf2.IdOperatore = S_Operatore.IdOperatore
	WHERE ti2.IdIncarico = @IdIncarico
		
	UNION 
	--Fase 2 Pre-Istruttoria (Integrazione)
	SELECT  ti2.IdIncarico, ti2.CodTipoIncarico, wf2.DataTransizione, wf2.IdOperatore, Etichetta
	,CASE WHEN FlagCensito = 1 THEN 5 WHEN FlagCensire = 1 THEN 6 END CodTipoLavorazione, FlagCensito, FlagCensire, 1 N
	FROM T_Incarico ti2

	JOIN @FlagCensiti ON ti2.IdIncarico = [@FlagCensiti].IdIncarico
	AND (FlagIntegrazione_Censito = 1 OR FlagIntegrazione_Censire = 1)
	CROSS APPLY (
					SELECT TOP 1 lwi2.IdTransizione, lwi2.DataTransizione, lwi2.IdOperatore, lwi2.IdIncarico
					FROM L_WorkflowIncarico lwi2
					WHERE lwi2.IdIncarico = ti2.idincarico
						AND lwi2.CodStatoWorkflowIncaricoPartenza <> lwi2.CodStatoWorkflowIncaricoDestinazione
						AND lwi2.CodStatoWorkflowIncaricoDestinazione = 14530 --Popolamento e Verifiche Effettuate
						--AND lwi2.DataTransizione >= @InizioDataLavorazione AND lwi2.DataTransizione < @FineDataLavorazione
					--ORDER BY lwi2.DataTransizione ASC
	) wf2
	JOIN S_Operatore ON wf2.IdOperatore = S_Operatore.IdOperatore
	WHERE ti2.IdIncarico = @IdIncarico

	UNION
	--Fase 2 Istruttoria (Conto)
	SELECT  ti2.IdIncarico, ti2.CodTipoIncarico, wf2.DataTransizione, wf2.IdOperatore, Etichetta
	,CASE WHEN FlagCensito = 1 THEN 23 WHEN FlagCensire = 1 THEN 24 END  CodTipoLavorazione, FlagCensito, FlagCensire, 1 N
	FROM T_Incarico ti2
	JOIN @FlagCensiti ON ti2.IdIncarico = [@FlagCensiti].IdIncarico
	AND (FlagConto_Censito = 1 OR FlagConto_Censire = 1)
	CROSS APPLY (
					SELECT TOP 1 lwi2.IdTransizione, lwi2.DataTransizione, lwi2.IdOperatore, lwi2.IdIncarico
					FROM L_WorkflowIncarico lwi2
					WHERE lwi2.IdIncarico = ti2.idincarico
						AND lwi2.CodStatoWorkflowIncaricoPartenza <> lwi2.CodStatoWorkflowIncaricoDestinazione
						AND lwi2.CodStatoWorkflowIncaricoDestinazione = 8570 --Popolamento e Verifiche Effettuate
						AND lwi2.DataTransizione >= @InizioDataLavorazione AND lwi2.DataTransizione < @FineDataLavorazione
					--ORDER BY lwi2.DataTransizione ASC
	) wf2
	JOIN S_Operatore ON wf2.IdOperatore = S_Operatore.IdOperatore
	WHERE ti2.IdIncarico = @IdIncarico

	UNION 
	--Fase 2 Istruttoria (Integrazione)
	SELECT  ti2.IdIncarico, ti2.CodTipoIncarico, wf2.DataTransizione, wf2.IdOperatore, Etichetta
	,CASE WHEN FlagCensito = 1 THEN 25 WHEN FlagCensire = 1 THEN 26 END CodTipoLavorazione, FlagCensito, FlagCensire, 1 N
	FROM T_Incarico ti2
	JOIN @FlagCensiti ON ti2.IdIncarico = [@FlagCensiti].IdIncarico
	AND (FlagIntegrazione_Censito = 1 OR FlagIntegrazione_Censire = 1)
	CROSS APPLY (
					SELECT TOP 1 lwi2.IdTransizione, lwi2.DataTransizione, lwi2.IdOperatore, lwi2.IdIncarico
					FROM L_WorkflowIncarico lwi2
					WHERE lwi2.IdIncarico = ti2.idincarico
						AND lwi2.CodStatoWorkflowIncaricoPartenza <> lwi2.CodStatoWorkflowIncaricoDestinazione
						AND lwi2.CodStatoWorkflowIncaricoDestinazione = 8570 --Popolamento e Verifiche Effettuate
						--AND lwi2.DataTransizione >= @InizioDataLavorazione AND lwi2.Datatransizione < @FineDataLavorazione
					--ORDER BY lwi2.DataTransizione ASC
	) wf2
	JOIN S_Operatore ON wf2.IdOperatore = S_Operatore.IdOperatore
	WHERE ti2.IdIncarico = @IdIncarico
	UNION 
	--Fase 3 Attivazione Conto
	SELECT ti3.IdIncarico, ti3.CodTipoIncarico, wf3.DataTransizione, wf3.IdOperatore, Etichetta, 7 CodTipoLavorazione,0 FlagCensito,0 FlagCensire, 1 N
	FROM T_Incarico ti3
	CROSS APPLY (
					SELECT TOP 1 lwi3.IdTransizione, lwi3.DataTransizione, lwi3.IdOperatore, lwi3.IdIncarico
					FROM L_WorkflowIncarico lwi3
					WHERE lwi3.IdIncarico = ti3.IdIncarico
					AND lwi3.CodStatoWorkflowIncaricoPartenza <> lwi3.CodStatoWorkflowIncaricoDestinazione
					AND lwi3.CodStatoWorkflowIncaricoDestinazione = 20980 --Accordo Attivo
					--AND lwi3.DataTransizione >= @InizioDataLavorazione AND lwi3.DataTransizione < @FineDataLavorazione

	) wf3
	JOIN S_Operatore ON wf3.IdOperatore = S_Operatore.IdOperatore
	WHERE ti3.IdIncarico = @IdIncarico

	UNION 
	--Fasi 4 (SOSPESI)
	SELECT ti4.IdIncarico, ti4.CodTipoIncarico, fasi4.DataTransizione, fasi4.IdOperatore, Etichetta
	,CASE fasi4.CodStatoWorkflowIncaricoDestinazione
	WHEN 6560 THEN 8
	WHEN 13250 THEN 9
	WHEN 15546 THEN 10
	WHEN 15429 THEN 11
	END CodTipoLavorazione
	,0 FlagCensito, 0 FlagCensire
	,IIF(fasi4.N = 0,1,fasi4.N) N
	FROM T_Incarico ti4
	CROSS APPLY (
					SELECT lwi4.IdTransizione, lwi4.IdIncarico, lwi4.DataTransizione, lwi4.IdOperatore, lwi4.CodStatoWorkflowIncaricoDestinazione, COUNT(IdMotivoTransizione) N
					FROM L_WorkflowIncarico lwi4
					LEFT JOIN L_MotivoTransizione ON lwi4.IdTransizione = L_MotivoTransizione.IdTransizione
					WHERE lwi4.IdIncarico = ti4.IdIncarico
					AND lwi4.CodStatoWorkflowIncaricoPartenza <> lwi4.CodStatoWorkflowIncaricoDestinazione
					AND lwi4.CodStatoWorkflowIncaricoDestinazione IN (  6560	 --Regolarizzata
															 ,13250	 --Gestione Anomalie														
															 ,15546	 --Integrazioni Ricevute
															) 
					AND lwi4.IdOperatore NOT IN (21,12520,12667) --escludo bot/utenze di sistema
					GROUP BY lwi4.IdTransizione, lwi4.IdIncarico, lwi4.DataTransizione, lwi4.IdOperatore, lwi4.CodStatoWorkflowIncaricoDestinazione
					UNION ALL
					SELECT lwi4.IdTransizione, lwi4.IdIncarico, lwi4.DataTransizione, lwi4.IdOperatore
					,CASE CodMotivoTransizione 
						WHEN 130 THEN lwi4.CodStatoWorkflowIncaricoDestinazione 
						WHEN 131 THEN 13250 
					 END CodStatoWorkflowIncaricoDestinazione
					 ,1 N
					FROM L_WorkflowIncarico lwi4
					JOIN L_MotivoTransizione ON lwi4.IdTransizione = L_MotivoTransizione.IdTransizione
					WHERE lwi4.IdIncarico = ti4.IdIncarico
					AND lwi4.CodStatoWorkflowIncaricoPartenza <> lwi4.CodStatoWorkflowIncaricoDestinazione
					AND lwi4.CodStatoWorkflowIncaricoDestinazione IN (15429	 --Richiesta chiarimenti/integrazioni															 
															)
					AND lwi4.IdOperatore NOT IN (21,12520,12667) --escludo bot/utenze di sistema
	) fasi4
	JOIN S_Operatore ON fasi4.IdOperatore = S_Operatore.IdOperatore
	WHERE ti4.IdIncarico = @idincarico
END

IF @CodTipoIncarico IN (359,564)
BEGIN

	INSERT INTO @Estrazioni (IdIncarico, CodTipoIncarico, DataLavorazione, IdOperatoreLavorazione, EtichettaOperatoreLavorazione, CodTipoLavorazione, FlagCensito, FlagCensire, N)
	SELECT ti1.idincarico, ti1.codtipoincarico, ti1.datacreazione, so1.IdOperatore, so1.Etichetta,
	CASE ti1.CodTipoIncarico
		WHEN 359 THEN 12
		WHEN 564 THEN 13
		END 
	, 0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico ti1
	JOIN T_R_Incarico_Operatore trip1 ON ti1.idincarico = trip1.idincarico
	AND trip1.CodRuoloOperatoreIncarico  = 1
	JOIN S_Operatore so1 ON trip1.idoperatore = so1.idoperatore
	WHERE ti1.idincarico = @idincarico
	UNION 
	SELECT ti2.idincarico, ti2.codtipoincarico, ti2.datacreazione, so2.IdOperatore, so2.Etichetta,
	CASE ti2.CodTipoIncarico
	WHEN 593 THEN 14
		WHEN 359 THEN 12
		WHEN 564 THEN 13
		END 
	, 0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico ti2
	JOIN T_R_Incarico_Operatore trip2 ON ti2.idincarico = trip2.idincarico
	AND trip2.CodRuoloOperatoreIncarico  = 2
	JOIN S_Operatore so2 ON trip2.idoperatore = so2.idoperatore
	WHERE ti2.idincarico = @IdIncarico
	UNION
		SELECT ti3.idincarico, ti3.codtipoincarico, ti3.datacreazione, so3.IdOperatore, so3.Etichetta,
	CASE ti3.CodTipoIncarico
		WHEN 359 THEN 12
		WHEN 564 THEN 13
		END 
	, 0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico ti3
	LEFT JOIN T_R_Incarico_Operatore trip3 ON ti3.idincarico = trip3.idincarico
	AND trip3.CodRuoloOperatoreIncarico  IN (1,2)
	JOIN L_WorkflowIncarico lwi3 ON ti3.IdIncarico = lwi3.IdIncarico
	AND ti3.DataUltimaTransizione = lwi3.DataTransizione
	JOIN S_Operatore so3 ON lwi3.IdOperatore = so3.IdOperatore
	WHERE ti3.idincarico = @IdIncarico
	AND trip3.IdRelazione IS NULL

END

IF @CodTipoIncarico IN (474,523,593)
BEGIN
	INSERT INTO @Estrazioni (IdIncarico, CodTipoIncarico, DataLavorazione, IdOperatoreLavorazione, EtichettaOperatoreLavorazione, CodTipoLavorazione, FlagCensito, FlagCensire, N)
	SELECT ti1.IdIncarico, ti1.CodTipoIncarico, lavorazione1.DataTransizione, ISNULL(trip1.IdOperatore, trip2.IdOperatore), ISNULL(so1.Etichetta,so2.Etichetta)
	,CASE ti1.CodTipoIncarico
		WHEN 474 THEN 16
		WHEN 523 THEN 19
		WHEN 593 THEN 14
	END
	,0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico ti1
	LEFT JOIN T_R_Incarico_Operatore trip1 ON ti1.IdIncarico = trip1.IdIncarico
	AND trip1.CodRuoloOperatoreIncarico = 1
	LEFT JOIN S_Operatore so1 ON trip1.IdOperatore = so1.IdOperatore
	LEFT JOIN T_R_Incarico_Operatore trip2 ON ti1.IdIncarico = trip2.IdIncarico
	AND trip2.CodRuoloOperatoreIncarico = 2
	LEFT JOIN S_Operatore so2 ON trip2.IdOperatore = so2.IdOperatore

	CROSS APPLY (
					SELECT TOP 1 lwi1.IdTransizione, lwi1.IdIncarico, lwi1.DataTransizione
                    FROM L_WorkflowIncarico lwi1
					WHERE lwi1.CodStatoWorkflowIncaricoPartenza != lwi1.CodStatoWorkflowIncaricoDestinazione
					AND lwi1.CodStatoWorkflowIncaricoDestinazione = 14555 --Genera Controlli Predisposizione 
					AND lwi1.IdIncarico = ti1.idincarico
					ORDER BY lwi1.DataTransizione asc
	) lavorazione1
	WHERE ti1.idincarico = @idincarico

	UNION
	SELECT ti1.IdIncarico, ti1.CodTipoIncarico, lavorazione2.DataTransizione, ISNULL(trip1.IdOperatore, trip2.IdOperatore), ISNULL(so1.Etichetta,so2.Etichetta)
	,CASE when ti1.CodTipoIncarico = 474 AND lavorazione2.CodStatoWorkflowIncaricoDestinazione = 15446 THEN 17
		WHEN ti1.codtipoincarico = 474 AND lavorazione2.CodStatoWorkflowIncaricoDestinazione = 15445 THEN 18
		WHEN ti1.codtipoincarico = 523 AND lavorazione2.codstatoworkflowincaricoDestinazione = 15446 THEN 20
		WHEN ti1.codtipoincarico = 523 AND lavorazione2.codstatoworkflowincaricodestinazione = 15445 THEN 21
	END
	,0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico ti1
	LEFT JOIN T_R_Incarico_Operatore trip1 ON ti1.IdIncarico = trip1.IdIncarico
	AND trip1.CodRuoloOperatoreIncarico = 1
	LEFT JOIN S_Operatore so1 ON trip1.IdOperatore = so1.IdOperatore
	LEFT JOIN T_R_Incarico_Operatore trip2 ON ti1.IdIncarico = trip2.IdIncarico
	AND trip2.CodRuoloOperatoreIncarico = 2
	LEFT JOIN S_Operatore so2 ON trip2.IdOperatore = so2.IdOperatore

	CROSS APPLY (
					SELECT TOP 1 lwi1.IdTransizione, lwi1.IdIncarico, lwi1.DataTransizione, lwi1.CodStatoWorkflowIncaricoDestinazione
                    FROM L_WorkflowIncarico lwi1
					WHERE lwi1.CodStatoWorkflowIncaricoPartenza != lwi1.CodStatoWorkflowIncaricoDestinazione
					AND lwi1.CodStatoWorkflowIncaricoDestinazione IN (15446,15445)
					AND lwi1.IdIncarico = ti1.idincarico
					ORDER BY lwi1.DataTransizione asc
	) lavorazione2
	WHERE ti1.idincarico = @idincarico
	UNION
		SELECT ti1.IdIncarico, ti1.CodTipoIncarico, lavorazione1.DataTransizione, ISNULL(trip1.IdOperatore, trip3.IdOperatore), ISNULL(so1.Etichetta,so3.Etichetta)
	,CASE ti1.CodTipoIncarico
		WHEN 474 THEN 22
		WHEN 523 THEN 22
		WHEN 593 THEN 15
	END
	,0 FlagCensito, 0 FlagCensire, 1 N
	FROM T_Incarico ti1
	LEFT JOIN T_R_Incarico_Operatore trip1 ON ti1.IdIncarico = trip1.IdIncarico
	AND trip1.CodRuoloOperatoreIncarico = 1
	LEFT JOIN T_R_Incarico_Operatore trip3 ON ti1.IdIncarico = trip3.IdIncarico
	AND trip3.CodRuoloOperatoreIncarico = 3
	LEFT JOIN S_Operatore so1 ON trip1.IdOperatore = so1.IdOperatore
	LEFT JOIN S_Operatore so3 ON trip3.IdOperatore = so3.IdOperatore


	CROSS APPLY (
					SELECT TOP 1 lwi1.IdTransizione, lwi1.IdIncarico, lwi1.DataTransizione
                    FROM L_WorkflowIncarico lwi1
					WHERE lwi1.CodStatoWorkflowIncaricoPartenza != lwi1.CodStatoWorkflowIncaricoDestinazione
					AND lwi1.CodStatoWorkflowIncaricoDestinazione = 14299 --Invio contratto 
					AND lwi1.IdIncarico = ti1.idincarico
					ORDER BY lwi1.DataTransizione asc
	) lavorazione1
	WHERE ti1.idincarico = @idincarico

END
/***** FINE ALGORITMO ESTRAZIONE FASI ************/
	

	--SELECT * FROM @FlagCensiti

	--SELECT * FROM @Estrazioni

	;WITH dataset AS (
			SELECT IdIncarico, CodTipoIncarico, [@Estrazioni].CodTipoLavorazione, DataLavorazione,  CASE WHEN [@Estrazioni].CodTipoLavorazione = 1 AND CodSede <> 3 THEN 8420
				ELSE IdOperatoreLavorazione END
				IdOperatoreLavorazione
			,CASE WHEN [@Estrazioni].CodTipoLavorazione = 1 AND CodSede <> 3 THEN 'Maestrello M.' ELSE EtichettaOperatoreLavorazione
			END EtichettaOperatore
			,CASE WHEN [@Estrazioni].CodTipoLavorazione = 1 AND CodSede <> 3 THEN 'Mi' ELSE Descrizione END SedeOperatore

			,CASE WHEN CodSede IN (10,3) OR [@Estrazioni].CodTipoLavorazione = 1 THEN 'MI'
			WHEN CodSede = 1 THEN 'CA'
			WHEN CodSede IN (2,11) THEN 'RO'
			END AS EtichettaSedeLavorazione
			,TipoLavorazione
			,N * Corrispettivo Corrispettivo
			,FlagCensito
			,FlagCensire
			,N
			FROM @Estrazioni
			LEFT JOIN @Lavorazioni ON [@Estrazioni].CodTipoLavorazione = [@Lavorazioni].CodTipoLavorazione 
			LEFT JOIN S_Operatore ON IdOperatoreLavorazione = IdOperatore
			LEFT JOIN D_SedeOperatore ON S_Operatore.CodSede = D_SedeOperatore.Codice

	)
	INSERT INTO @Fasi (IdIncarico, CodTipoLavorazione, TipoLavorazione, DataLavorazione, IdOperatoreLavorazione, EtichettaOperatore, EtichettaSedeLavorazione, Corrispettivo, IsFatturata, TML, TMLMinuti, n)
	
	SELECT IdIncarico, dataset.CodTipoLavorazione, TipoLavorazione, DataLavorazione, IdOperatoreLavorazione, dataset.EtichettaOperatore,dataset.EtichettaSedeLavorazione, dataset.Corrispettivo
	,IIF(dataset.Corrispettivo = 0 OR corrispettivo IS NULL,0,1) IsFatturata
	,[@TML_LAV_SEDE].TML / 55 TML
	,[@TML_LAV_SEDE].TML TMLMinuti
	,dataset.n
	FROM dataset
	LEFT JOIN @TML_LAV_SEDE ON dataset.CodTipoLavorazione = [@TML_LAV_SEDE].CodTipoLavorazione
	AND [@TML_LAV_SEDE].EtichettaSedeLavorazione = dataset.EtichettaSedeLavorazione
	AND [@TML_LAV_SEDE].FlagCensito = dataset.flagCensito
	AND [@TML_LAV_SEDE].FlagCensire = dataset.FlagCensire
	AND (dataset.CodTipoIncarico = [@TML_LAV_SEDE].CodTipoIncarico OR [@TML_LAV_SEDE].CodTipoIncarico IS NULL )

	SELECT * FROM @Fasi

	--RETURN
END
GO