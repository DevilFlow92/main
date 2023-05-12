--USE CLC_DatawareHouse
--GO

--ALTER VIEW rs.v_CESAM_AZ_KPI_Budgeting AS

WITH prezzicategoriaservizio AS (

SELECT 1 categoria, 6 prezzo,36 CodServizio, 'Gestione Case Terze' DesServizio, 89 codKPI, 'CESAM Numero pratiche lavorate gestione case terze' desKPI UNION ALL --case terze
SELECT 2 categoria, 10 prezzo  ,32 CodServizio, 'Gestione Fondi' DesServizio, 97 codKPI, 'CESAM Numero pratiche lavorate gestione fondi' desKPI UNION all --fondi azimut
SELECT 3 categoria, 115 prezzo ,33 CodServizio, 'Finanziamenti' DesServizio, 94 codKPI, 'CESAM Numero pratiche lavorate finanziamenti' desKPI  UNION all --finanziamenti
SELECT 4 categoria, 200 prezzo ,34 CodServizio, 'Successioni' DesServizio, 95 codKPI, 'CESAM Numero pratiche lavorate successioni' desKPI  UNION ALL --successioni
SELECT 5 categoria, 25 prezzo,56 CodServizio, 'Onboarding' DesServizio, 96 codKPI, 'CESAM Numero pratiche lavorate onboarding' desKPI	UNION all		--onboarding clienti
SELECT 6 categoria, 1 prezzo, 249 CodServizio, 'Gestione Assicurativo' DesServizio, 180 codKPI, 'CESAM Numero pratiche lavorate AZ Life' desKPI union all --assicurativo
SELECT 7 categoria, 1 prezzo, 250 CodServizio, 'Gestione Az Libera Impresa' DesServizio, 181 codKPI, 'CESAM Numero pratiche lavorate AZ Libera Impresa' desKPI union all --Azimut Libera Impresa

---- pregresso
select 2017 categoria, 8.34 prezzo, 61 CodServizio, 'Gestione globale' DesServizio, 98 codKPI, 'CESAM Numero pratiche lavorate 2017' desKPI UNION ALL --pregresso 2017
select 2018 categoria, 9.73 prezzo, 61 CodServizio, 'Gestione globale' DesServizio, 99 codKPI, 'CESAM Numero pratiche lavorate 2018' desKPI  --pregresso 2018
) 
, mesecorrente_giacenzamedia AS (
SELECT (SELECT 270000   --2 punti base sul gestito, si aggira sui 16 miliardi circa

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0

)
, mesecorrente_canoni as (

SELECT(SELECT  18000   --servizio concierge sospesi

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0
)
,altriservizi_canoni as  (

SELECT(SELECT  30000    --Project Team Re Hosting e test ( circa 25/40 K mese) 

/*
•	Supporto Canale App: non partito Canone 125K x 6 mesi 4 risorse al mese ) non ancora partito
•	Supporto Libera impresa: ( to be 70 K anno )
•	Progetti speciali con Solution 

*/

/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0
)

,affitti_canoni as  (

SELECT(SELECT  59244    --Affitto locali che CESAM fa ad Azimut


/ COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0
)


, pregresso as (select 2018 anno, 1 mese, 57719 qt union ALL --prezzo medio 9.73
select 2018 anno, 2 mese, 60664 qt union all
select 2018 anno, 3 mese, 62941 qt union all
select 2018 anno, 4 mese, 46865 qt union all
select 2018 anno, 5 mese, 63496 qt union all
select 2018 anno, 6 mese, 56486 qt union all
select 2018 anno, 7 mese, 58041 qt union all
select 2018 anno, 8 mese, 36421 qt union all
select 2018 anno, 9 mese, 48718 qt union all
select 2018 anno, 10 mese, 66373 qt union all
select 2018 anno, 11 mese, 60122 qt union all
select 2018 anno, 12 mese, 63642 qt union all
select 2017 anno, 1 mese, 74545 qt union ALL --prezzo medio 8.34
select 2017 anno, 2 mese, 78630 qt union all
select 2017 anno, 3 mese, 99337 qt union all
select 2017 anno, 4 mese, 76931 qt union all
select 2017 anno, 5 mese, 89751 qt union all
select 2017 anno, 6 mese, 67435 qt union all
select 2017 anno, 7 mese, 65129 qt union all
select 2017 anno, 8 mese, 36797 qt union all
select 2017 anno, 9 mese, 59415 qt union all
select 2017 anno, 10 mese, 79369 qt union all
select 2017 anno, 11 mese, 83372 qt union all
select 2017 anno, 12 mese, 73364 qt 
)




/*FINE CTE*/



--*/
SELECT 	8 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	CodServizio AS CodServizio,
	/*servizi a numero incarichi*/
	23 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(DataCreazione) AS [yy],
	MONTH(DataCreazione) AS [mm],
	desKPI AS KPI,
	codKPI AS codKPI,
	ISNULL(COUNT(v.IdIncarico),0) as Valore

FROM rs.v_CESAM_AZ_FatturazioneIncarichi_v2 v
join prezzicategoriaservizio ON v.Categoria = prezzicategoriaservizio.categoria
--WHERE DataCreazione >= '20190101'
--WHERE DataCreazione >= @DataDal
--AND DataCreazione < @DataAl

WHERE DataCreazione >= '20190101' 
AND v.Categoria is not null


GROUP BY	YEAR(DataCreazione),
			MONTH(DataCreazione),
			CodServizio,
			desKPI ,
	codKPI

			
UNION ALL

SELECT DISTINCT 
8 AS CodLineaBusiness,
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
	 ELSE 270000
	 END,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20190101'
--AND DataInizioSettimana < @DataCreazioneAEscluso


	
UNION ALL

SELECT DISTINCT 
8 AS CodLineaBusiness,
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
	 ELSE 18000
	 END,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20190101'
--AND DataInizioSettimana < @DataCreazioneAEscluso


--33 CESAM Valore canone mensile Banking
--57 Altri servizi 
--altriservizi_canoni


UNION ALL

SELECT DISTINCT 
8 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	57 AS CodServizio,
	/* altri servizi*/
	23 AS CodCiente,
	NULL AS CodOrignator,
	Anno AS [yy],
	Mese AS [mm],
	'CESAM Valore altri servizi' AS KPI,
	101 AS codKPI,
	 ISNULL(CASE WHEN Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE())
	 THEN (SELECT 	SUM(canone) canone
								 FROM altriservizi_canoni)
	 ELSE 30000
	 END,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20190101'
--AND DataInizioSettimana < @DataCreazioneAEscluso

UNION all

/* *************** VOCE AGGIUNTIVA CANONE 29/04/2020 *****************/
SELECT DISTINCT
	8 AS CodLineaBusiness
	,14 AS CodUnitaOrganizzativa
	,252 AS CodServizio --57
	,
	/* altri servizi*/
	23 AS CodCiente
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
		ELSE 59244
	END, 0) AS Valore


FROM rs.S_Data
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND DataInizioSettimana >= '20190101'
--AND DataInizioSettimana < @DataCreazioneAEscluso

/*******************************************************/

UNION ALL

/*pregresso, anni 2017 2018*/
SELECT 8 CodLineaBusiness,
14 CodUnitaOrganizzativa,
CodServizio,
23 CodCliente,
NULL CodOriginator,
anno AS yy,
mese AS mm,
desKPI KPI,
codKPI,
pregresso.qt AS Valore
 FROM pregresso
JOIN prezzicategoriaservizio ON categoria = anno

GO