USE clc

GO


ALTER VIEW rs.v_CESAM_CB_KPI_Budgeting AS


--DECLARE	@DataCreazione DATETIME,
--		@DataCreazioneAEscluso DATETIME

--SET @DataCreazione = '20200601'
--SET @DataCreazioneAEscluso = GETDATE() 
--;

 WITH mesecorrente AS (
SELECT (SELECT 3500 / COUNT(ChiaveData) FROM rs.S_Data
WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0

), quadratura AS (
--giugno 2020
SELECT 32 codKPI, 'CESAM Numero pratiche lavorate core banking' AS KPI, 2020 yy, 6 mm, 13835.376285825 Valore UNION ALL
SELECT 31 codKPI, 'CESAM Numero pratiche lavorate supporto banking' AS KPI, 2020 yy, 6 mm,  2058.3678259575 Valore UNION ALL
SELECT 33 codKPI, 'CESAM Valore canone mensile Banking' AS KPI, 2020 yy, 6 mm, 1787.331735 Valore UNION ALL
SELECT 198 codKPI, 'CESAM Numero Pezzi Generazione Doc Small Business' KPI, 2020 yy, 6 mm, 3881.6 Valore UNION ALL
SELECT 199 codKPI, 'CESAM Valore Revenue Pratiche Lease Banking' KPI, 2020 yy, 6 mm,  756 Valore union ALL

--luglio 2020
SELECT 32 codKPI, 'CESAM Numero pratiche lavorate core banking' AS KPI, 2020 yy, 7 mm,  12854.6 Valore UNION ALL
--SELECT 31 codKPI, 'CESAM Numero pratiche lavorate supporto banking' AS KPI, 2020 yy, 7 mm, 1866.31 Valore UNION All
--SELECT 198 codKPI, 'CESAM Numero Pezzi Generazione Doc Small Business' KPI, 2020 yy, 7 mm, 4644.99 Valore UNION ALL
SELECT 199 codKPI, 'CESAM Valore Revenue Pratiche Lease Banking' KPI, 2020 yy, 7 mm, 1890 Valore UNION ALL

--agosto 2020
SELECT 32 codKPI, 'CESAM Numero pratiche lavorate core banking' AS KPI, 2020 yy, 8 mm,  7925.29 Valore UNION ALL
--SELECT 31 codKPI, 'CESAM Numero pratiche lavorate supporto banking' AS KPI, 2020 yy, 8 mm, 1262.68 Valore UNION ALL
--SELECT 198 codKPI, 'CESAM Numero Pezzi Generazione Doc Small Business' KPI, 2020 yy, 8 mm, 1395 Valore UNION ALL
SELECT 199 codKPI, 'CESAM Valore Revenue Pratiche Lease Banking' KPI, 2020 yy, 8 mm, 0 Valore

)

/*
/************************** FINO A maggio 2020 **************/
SELECT
	3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	/*CORE banking activities*/
	48 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(DataCreazione) AS [yy],
	MONTH(DataCreazione) AS [mm],
	'CESAM Numero pratiche lavorate core banking' AS KPI, --prezzo medio 27.7 €
	32 AS codKPI,
	ISNULL(SUM(
	ContiDossier + [SB-LavorazioneCompleta] + [SB-SospesaCervedNegativa]+ v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_IpotesiSubincarichi.[SB-Fil-LavorazioneCompleta]
	+v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_IpotesiSubincarichi.[SB-Fil-SospesaCervedNegativa]
	),0) AS Valore
FROM rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_IpotesiSubincarichi
WHERE DataCreazione < '20200601'
--AND DataCreazione >= @DataCreazione
--AND DataCreazione < @DataCreazioneAEscluso

GROUP BY	YEAR(DataCreazione),
			MONTH(DataCreazione)

UNION ALL


SELECT
	3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	/*non core banking activities*/
	48 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(DataCreazione) AS [yy],
	MONTH(DataCreazione) AS [mm],
	'CESAM Numero pratiche lavorate supporto banking' AS KPI, --prezzo medio 4 €
	31 AS codKPI,
	ISNULL(SUM(
	Predisposizione +
	TDT +
	TrasferimentoTitoli +
	Portabilita +
	ContrattoConsulenza +
	CartaDiCredito +
	[SB-SospesaOggettoSociale]+
	v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_IpotesiSubincarichi.[SB-Fil-SospesaOggettoSociale]
	),0) AS Valore
FROM rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_IpotesiSubincarichi
WHERE DataCreazione < '20200601'
--and DataCreazione >= @DataCreazione
--AND DataCreazione < @DataCreazioneAEscluso

GROUP BY	YEAR(DataCreazione),
			MONTH(DataCreazione)

UNION ALL

SELECT DISTINCT 
3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	/* CORE banking activities*/
	48 AS CodCiente,
	NULL AS CodOrignator,
	Anno AS [yy],
	Mese AS [mm],
	'CESAM Valore canone mensile Banking' AS KPI,
	33 AS codKPI,
	 ISNULL(CASE WHEN Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE())
	 THEN (SELECT 	SUM(canone) canone
								 FROM mesecorrente)
	 ELSE 3500
	 END,0) AS Valore

	 
FROM rs.S_Data 
WHERE DataInizioSettimana <= CAST(GETDATE() AS DATE)
AND ChiaveData < '20200601'
--AND DataInizioSettimana < @DataCreazioneAEscluso

/**************************************************************************/
union all

*/
/******************* A PARTIRE DA GIUGNO 2020 ****************************/

/** QUADRATURA I: GIUGNO 2020 **/

SELECT 3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	48 AS CodCiente,
	NULL AS CodOrignator,
	quadratura.YY AS [yy],
	quadratura.MM AS [mm],	
	KPI,
	codKPI,
	CASE WHEN MM = DATEPART(MONTH,GETDATE()) 
			AND YY = DATEPART(YEAR,GETDATE())
			THEN 
			CASE codKPI
			WHEN 32 THEN CONVERT(INT,(valore /28.01 ))
			WHEN 31 THEN CONVERT(INT,(valore/ 6.29))
			WHEN 33 THEN valore
			WHEN 199 THEN valore
			WHEN 198 THEN CONVERT(INT,(valore /39.86))
			END
			 /  (SELECT COUNT(ChiaveData) FROM rs.S_Data
			WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) --AND FlagFestivo = 0
			AND ChiaveData <=  EOMONTH(GETDATE())) * (
			
			SELECT COUNT(ChiaveData) FROM rs.S_Data
			WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) --AND FlagFestivo = 0
			AND ChiaveData <= CAST(GETDATE() as DATE) --AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
			
			)			
			
			ELSE CASE codKPI
			WHEN 32 THEN CONVERT(INT,(valore /28.01 ))
			WHEN 31 THEN CONVERT(INT,(valore/ 6.29))
			WHEN 33 THEN valore
			WHEN 199 THEN valore
			WHEN 198 THEN CONVERT(INT,(valore /39.86))
			END
			 END as Valore
FROM quadratura
WHERE YY = 2020 
AND MM = 6


/** NEW 2020 CORE BANKING --Da Sostituire con report fatturazione fasi **/
UNION ALL
SELECT 3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	48 AS CodCiente,
	NULL AS CodOrignator,
	quadratura.YY AS [yy],
	quadratura.MM AS [mm],	
	KPI,
	codKPI,
	CASE WHEN MM = DATEPART(MONTH,GETDATE()) 
			AND YY = DATEPART(YEAR,GETDATE())
			THEN CONVERT(INT,((valore /28.01) /  (SELECT COUNT(ChiaveData) FROM rs.S_Data
			WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) --AND FlagFestivo = 0
			AND ChiaveData <=  EOMONTH(GETDATE())) * (
			
			SELECT COUNT(ChiaveData) FROM rs.S_Data
			WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) --AND FlagFestivo = 0
			AND ChiaveData <= CAST(GETDATE() as DATE) --AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
			
			)
			))
			
			
			ELSE CONVERT(INT,(valore / 28.01)) END as Valore
FROM quadratura
WHERE CODKPI = 32
AND YY = 2020
AND MM>6

/** NEW 2020 SMALLBUSINESS **/
UNION ALL
SELECT 3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	48 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(DataCreazione) AS [yy],
	MONTH(DataCreazione) AS [mm],
	'CESAM Numero Pezzi Generazione Doc Small Business' KPI,
	198 codKPI,
	COUNT(IdIncarico) Valore
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE ([SB-LavorazioneCompleta] = 1 OR [SB-SospesaOggettoSociale] = 1 OR [SB-SospesaCervedNegativa] = 1 
		OR [SB-Fil-LavorazioneCompleta] = 1	OR [SB-Fil-SospesaOggettoSociale] = 1  OR [SB-Fil-SospesaCervedNegativa] = 1
		)
AND DataCreazione >= '20200701'

GROUP BY	YEAR(DataCreazione),
			MONTH(DataCreazione)

/** NEW 2020 SUPPORTO BANKING **/
UNION ALL
SELECT 3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	48 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(DataCreazione) AS [yy],
	MONTH(DataCreazione) AS [mm],
	'CESAM Numero pratiche lavorate supporto banking' KPI,
	31 codKPI,
	COUNT(IdIncarico) Valore
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE (FlagGenerazioneKit = 1 OR FlagConsulenza = 1 OR FlagTSP = 1
		)
AND DataCreazione >= '20200701'

GROUP BY	YEAR(DataCreazione),
			MONTH(DataCreazione)

/** QUADRATURA: LEASE BANKING (KIT DOCUMENTALE) --da sostituire con query fatturazione where FlagAggiornamentoDocumentale = 1 **/
UNION ALL
SELECT 3 AS CodLineaBusiness,
	14 AS CodUnitaOrganizzativa,
	54 AS CodServizio,
	48 AS CodCiente,
	NULL AS CodOrignator,
	YEAR(DataCreazione) AS [yy],
	MONTH(DataCreazione) AS [mm],	
	'CESAM Valore Revenue Pratiche Lease Banking' KPI,
	199 codKPI,
	 SUM(PrezzoPack)  as Valore
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE FlagAggiornamentoDocumentale = 1
AND DataCreazione >= '20200701'

GROUP BY YEAR(DataCreazione)
,MONTH(DataCreazione)



GO

SELECT * FROM rs.v_CESAM_CB_KPI_Budgeting
WHERE yy = 2020 AND mm > = 6
ORDER BY yy, mm, codKPI

SELECT * FROM rs.v_CESAM_IW_KPI_Budgeting
WHERE yy = 2020 

