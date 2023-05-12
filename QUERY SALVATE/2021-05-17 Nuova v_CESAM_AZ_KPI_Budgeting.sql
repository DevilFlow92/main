USE CLC
GO

ALTER VIEW rs.v_CESAM_AZ_KPI_Budgeting AS

/* Author: Padricelli A.
	Edit 2020: Fiori L.
	Edit 2021: Fiori L.

	Per recuperare lo storico fino al 31/12/2020 interrogare la vista rs.v_CESAM_AZ_KPI_Budgeting_bkp20210303
	Edit 2021-05-17 Fiori L.
	Aggiunta in UNION ALL la vista rs.v_CESAM_AZ_Coblenza_KPI_Budgeting per gestire il business COBLENZA (valori costanti provenienti da file excel forniti dal team Board
*/


WITH prezzicategoriaservizio AS (

SELECT 1 categoria, 6     prezzo ,36  CodServizio, 'Gestione Case Terze' DesServizio, 89 codKPI, 'CESAM Numero pratiche lavorate gestione case terze' desKPI UNION ALL --case terze

SELECT 2 categoria, 8.9   prezzo ,32  CodServizio, 'Gestione Fondi Carta Chimica' DesServizio, 97 codKPI, 'CESAM Numero pratiche lavorate gestione fondi (carta chimica)' desKPI UNION all --fondi azimut
SELECT 2 categoria, 5.15  prezzo ,310 CodServizio, 'Gestione Fondi FEQ' DesServizio, 97 codKPI, 'CESAM Numero pratiche lavorate gestione fondi (FEQ)' desKPI UNION all --fondi azimut
SELECT 2 categoria, 7.15  prezzo ,311 CodServizio, 'Gestione Fondi Precompila' DesServizio, 97 codKPI, 'CESAM Numero pratiche lavorate gestione fondi (Precompila)' desKPI UNION all --fondi azimut

SELECT 3 categoria, 115   prezzo ,33  CodServizio, 'Finanziamenti' DesServizio, 94 codKPI, 'CESAM Numero pratiche lavorate finanziamenti' desKPI  UNION all --finanziamenti
SELECT 4 categoria, 200   prezzo ,34  CodServizio, 'Successioni' DesServizio, 95 codKPI, 'CESAM Numero pratiche lavorate successioni' desKPI  UNION ALL --successioni

SELECT 5 categoria, 25    prezzo ,56  CodServizio, 'On Boarding' DesServizio, 96 codKPI, 'CESAM Numero pratiche lavorate onboarding' desKPI	UNION all		--onboarding clienti
SELECT 5 categoria, 12.31 prezzo, 312 CodServizio, 'On Boarding Digitale FEQ' DesServizio, 96 codKPI, 'CESAM Numero pratiche lavorate onboarding (Digitale FEQ)' desKPI	UNION all		--onboarding clienti
SELECT 5 categoria, 13.72 prezzo, 313 CodServizio, 'On Boarding Digitale Precompila' DesServizio, 96 codKPI, 'CESAM Numero pratiche lavorate onboarding (Digitale Precompila)' desKPI	UNION all		--onboarding clienti

SELECT 6 categoria, 2.69 prezzo ,250 CodServizio, 'Gestione Az Libera Impresa' DesServizio, 181 codKPI, 'CESAM Numero pratiche lavorate AZ Libera Impresa' desKPI --Azimut Libera Impresa

) 
/*   non serve per il momento 
, WIP AS (
SELECT (
	SELECT (500000 / 12)
		/ COUNT(chiavedata) 
	FROM rs.S_Data
	WHERE Mese = DATEPART(MONTH,GETDATE()) AND ANNO = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0
	
) CANONE, DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data
WHERE ChiaveData <= CAST(GETDATE() AS DATE) AND ChiaveData >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE()),0) AND FlagFestivo = 0
)

,ROL_LOL AS (
SELECT (
	SELECT (43000 / 12)
		/ COUNT(chiavedata) 
	FROM rs.S_Data
	WHERE Mese = DATEPART(MONTH,GETDATE()) AND ANNO = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0
	
) CANONE, DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data
WHERE ChiaveData <= CAST(GETDATE() AS DATE) AND ChiaveData >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE()),0) AND FlagFestivo = 0
)

,Prj_Coblenza AS (
SELECT (
	SELECT (1000000 / 12)
		/ COUNT(chiavedata) 
	FROM rs.S_Data
	WHERE Mese = DATEPART(MONTH,GETDATE()) AND ANNO = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0
	
) CANONE, DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data
WHERE ChiaveData <= CAST(GETDATE() AS DATE) AND ChiaveData >= DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE()),0) AND FlagFestivo = 0
)
*/

, mesecorrente_giacenzamedia AS (
SELECT (SELECT (3221279 / 12)

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0
GROUP BY CASE WHEN ChiaveData >= '20200101' THEN 250000 ELSE 270000 END
) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0

)

/****** NUOVO CANONE RICORRENTE AZ LIFE ******/

,az_life AS (
SELECT(SELECT  (90000/12)   --servizio canone azlife

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0
)

/*********************************************/

, mesecorrente_canoni as (

SELECT(SELECT (62400/12)

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0
GROUP BY CASE WHEN chiavedata >= '20200401' THEN 5200 ELSE  18000 END
) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0

)
,altriservizi_canoni as  (

SELECT(SELECT  (30000 /12)   --Project Team Re Hosting e test ( circa 25/40 K mese) 

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0

)

,affitti_canoni as  (

SELECT(SELECT  59244 / 12   --Affitto locali che CESAM fa ad Azimut


/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0


)

,BaseQTask AS (

SELECT IdIncarico,DataCreazione, CodTipoIncarico, TipoIncarico, Categoria, FlagCartaceo, FlagFEQ, FlagPrecompila 
,CASE WHEN Categoria = 1 THEN 36 --Gestione Fondi Case Terze
	WHEN Categoria = 2 AND FlagCartaceo = 1 THEN 32 --Gestione Fondi Casa Carta
	WHEN Categoria = 2 AND FlagFEQ = 1 THEN 310 --Gestione Fondi Casa FEQ
	WHEN Categoria = 2 AND FlagPrecompila = 1 THEN 311 --Gestione Fondi Casa Precompila
	WHEN Categoria = 3 THEN 33 --Finanziamenti
	WHEN Categoria = 4 THEN 34 --Successioni
	WHEN Categoria = 5 AND FlagCartaceo = 1 THEN 56 --OnBoarding
	WHEN Categoria = 5 AND FlagFEQ = 1 THEN 312 --OnBoarding Digitale FEQ
	WHEN Categoria = 5 AND FlagPrecompila = 1 THEN 313 --OnBoarding Digitale Precompila
	WHEN Categoria = 6 THEN 250 --Azimut Libera Impresa
 END AS CodServizio
FROM rs.v_CESAM_AZ_FatturazioneIncarichi_Board
WHERE DataCreazione >= '20210101'
AND Categoria IS NOT NULL

)

/*FINE CTE*/

--*/
SELECT 	3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	v.CodServizio AS CodServizio,
	/*servizi a numero incarichi*/
	23 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(v.DataCreazione) AS [yy],
	MONTH(v.DataCreazione) AS [mm],
	desKPI AS KPI,
	codKPI AS codKPI,
	ISNULL(COUNT(v.IdIncarico),0) as Valore

FROM BaseQTask v
join prezzicategoriaservizio ON v.Categoria = prezzicategoriaservizio.categoria
AND v.CodServizio = prezzicategoriaservizio.CodServizio

GROUP BY	YEAR(v.DataCreazione),
			MONTH(v.DataCreazione),
			v.CodServizio,
			desKPI ,
			codKPI
					   			 
UNION 

SELECT DISTINCT 
3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	35 AS CodServizio,
	/* Gestione Portafoglio*/
	23 AS CodCiente,
	NULL AS CodOrignator,
	Anno AS [yy],
	Mese AS [mm],
	'CESAM Valore base-point giacenza media azimut' AS KPI,
	90 AS codKPI,
	 ISNULL(CASE WHEN Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE())
	 THEN (SELECT 	SUM(canone) canone
								 FROM mesecorrente_giacenzamedia)
	  
	 ELSE 3221279/12 END
	 ,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20210101'
AND FlagFestivo = 0

UNION ALL

SELECT DISTINCT 
3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	60 AS CodServizio,
	/* Gestione servizio concierge*/
	23 AS CodCiente,
	NULL AS CodOrignator,
	Anno AS [yy],
	Mese AS [mm],
	'CESAM Valore canone mensile servizio concierge' AS KPI,
	100 AS codKPI,
	 ISNULL(CASE WHEN Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE())
	 THEN (SELECT 	SUM(canone) canone
								 FROM mesecorrente_canoni)
	 ELSE 62400/12
	 END,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20210101'
AND FlagFestivo = 0

--33 CESAM Valore canone mensile Banking
--57 Altri servizi 
--altriservizi_canoni


UNION ALL

SELECT DISTINCT 
3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	57 AS CodServizio,
	/* altri servizi*/
	23 AS CodCiente,
	NULL AS CodOrignator,
	Anno AS [yy],
	Mese AS [mm],
	'CESAM Valore altri servizi' AS KPI,
	101 AS codKPI,
	 ISNULL(
			CASE 
				WHEN Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE())
					THEN (SELECT 	SUM(canone) canone FROM altriservizi_canoni)
				ELSE 30000 /12
			END
	 ,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20210101'
AND FlagFestivo = 0

UNION all

/* *************** VOCI AGGIUNTIVE CANONE 29/04/2020 *****************/

SELECT DISTINCT
	3 AS CodLineaBusiness
	,14 AS CodUnitaOrganizzativa
	,252 AS CodServizio --57
	,23 AS CodCiente
	,NULL AS CodOrignator
	,Anno AS [yy]
	,Mese AS [mm]
	,'CESAM Valore affitti' AS KPI
	,186 AS codKPI
	,ISNULL(CASE
		WHEN Mese = DATEPART(MONTH, GETDATE()) AND
			Anno = DATEPART(YEAR, GETDATE()) THEN (SELECT
				SUM(canone) canone
			FROM affitti_canoni)
		ELSE 59244 / 12
	END, 0) AS Valore
		
FROM rs.S_Data
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20210101'
AND FlagFestivo = 0

union ALL

SELECT DISTINCT
	3 AS CodLineaBusiness
	,14 AS CodUnitaOrganizzativa
	,249 AS CodServizio 
	,23 AS CodCiente
	,NULL AS CodOrignator
	,Anno AS [yy]
	,Mese AS [mm]
	,'CESAM Valore Canone Lavorazioni AZ Life' AS KPI
	,180 AS codKPI
	,ISNULL(CASE
		WHEN Mese = DATEPART(MONTH, GETDATE()) AND
			Anno = DATEPART(YEAR, GETDATE()) THEN (SELECT
				SUM(canone) canone
			FROM az_life)
		ELSE 90000/12
	END, 0) AS Valore

FROM rs.S_Data
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20210101'
AND FlagFestivo = 0 

UNION ALL
SELECT CodLineaBusiness
,CodUnitaOrganizzativa
,codservizio
,codcliente
,CodOriginator
,yy
,mm
,KPI
,codKPI
,Valore
FROM rs.v_cesam_az_coblenza_kpi_budgeting

/* non serve per il momento 
UNION ALL

SELECT DISTINCT
3 AS CodLineaBusiness
,14 AS CodUnitaOrganizzativa
,57 AS CodServizio
,23 AS CodCiente
,NULL AS CodOriginator
,Anno AS yy
,Mese AS mm
,'WIP' AS KPI
,101 AS codKPI
,ISNULL(
		CASE 
			WHEN mese = DATEPART(MONTH,GETDATE()) 
				AND anno = DATEPART(YEAR,GETDATE())
			THEN (
					SELECT SUM(canone) canone FROM WIP			
				)
		ELSE 500000/12
		end
,0) AS Valore

FROM rs.S_Data
WHERE DataInizioSettimana >= '20210101'
AND DataInizioSettimana <= CONVERT(DATE,GETDATE())

UNION ALL

SELECT DISTINCT
3 AS CodLineaBusiness
,14 AS CodUnitaOrganizzativa
,57 AS CodServizio
,23 AS CodCiente
,NULL AS CodOriginator
,Anno AS yy
,Mese AS mm
,'ROL/LOL' AS KPI
,101 AS codKPI
,ISNULL(
		CASE 
			WHEN mese = DATEPART(MONTH,GETDATE()) 
				AND anno = DATEPART(YEAR,GETDATE())
			THEN (
					SELECT SUM(canone) canone FROM ROL_LOL			
				)
		ELSE 43000/12
		end
,0) AS Valore

FROM rs.S_Data
WHERE DataInizioSettimana >= '20210101'
AND DataInizioSettimana <= CONVERT(DATE,GETDATE())

UNION ALL
SELECT DISTINCT
3 AS CodLineaBusiness
,14 AS CodUnitaOrganizzativa
,57 AS CodServizio
,23 AS CodCiente
,NULL AS CodOriginator
,Anno AS yy
,Mese AS mm
,'Project Coblenza' AS KPI
,101 AS codKPI
,ISNULL(
		CASE 
			WHEN mese = DATEPART(MONTH,GETDATE()) 
				AND anno = DATEPART(YEAR,GETDATE())
			THEN (
					SELECT SUM(canone) canone FROM Prj_Coblenza			
				)
		ELSE 1000000/12
		end
,0) AS Valore

FROM rs.S_Data
WHERE DataInizioSettimana >= '20210101'
AND DataInizioSettimana <= CONVERT(DATE,GETDATE())
*/

GO