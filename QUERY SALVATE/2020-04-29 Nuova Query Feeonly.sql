USE CLC_DatawareHouse
GO


--ALTER  VIEW rs.v_CESAM_FO_KPI_Budgeting
--AS

/*
	Author:				lorenzo.fiori
	Date:				04/03/2019
	Description:			- Vista di Export utilizzata per il popolamento di [rs].[Board_KPI_BPODivision_InvestmentServices] (Tabella richiamata da ODBC di Board)


	rs.Board_KPI_BPODivision_D_Servizi 
	rs.Board_KPI_BPODivision_D_TipoKPI 

	Aggregazione cliente: 17	Feeonly Provvisorio

*/

--;
WITH canoniannui as (
select 2019 anno, 'NEXTAM (canone ricorrente)' servizio, 6937.5 valore union all
select 2020 anno, '8A+ SGR (canone ricorrente)' servizio, 6000 valore union all
select 2020 anno, '8A+ SGR (canone variabile)' servizio, 16000 valore union all
select 2020 anno, 'AMARANTO  (canone ricorrente)' servizio, 13500 valore union all
select 2020 anno, 'ANTHILIA SGR (canone ricorrente)' servizio, 21464 valore union all
select 2020 anno, 'ASSITECA SIM (canone ricorrente)' servizio, 23508 valore union all
select 2020 anno, 'ATAILAB  (canone ricorrente)' servizio, 11000 valore union all
select 2020 anno, 'BANOR (canone ricorrente)' servizio, 12811 valore union all
select 2020 anno, 'CAMPERIO (canone ricorrente)' servizio, 20442 valore union all
select 2020 anno, 'CLASSIS CAPITAL (canone ricorrente)' servizio, 2500 valore union all
select 2020 anno, 'CLASSIS CAPITAL (canone variabile)' servizio, 4000 valore union all
select 2020 anno, 'CONSILIA OFFICE  (canone ricorrente)' servizio, 13000 valore union all
select 2020 anno, 'FAMILY ADVISOR SIM (canone ricorrente)' servizio, 2000 valore union all
select 2020 anno, 'GIOTTO SIM (canone ricorrente)' servizio, 23183 valore union all
select 2020 anno, 'GSA (canone ricorrente)' servizio, 20000 valore union all
select 2020 anno, 'LAMARCK SIM (canone variabile)' servizio, 4000 valore union all
select 2020 anno, 'MOVING (canone variabile)' servizio, 9000 valore union all
select 2020 anno, 'PRIVATE CONSULTING SRL (canone ricorrente)' servizio, 7000 valore union all
select 2020 anno, 'PROMETEIA (canone ricorrente)' servizio, 3000 valore union all
select 2020 anno, 'SELLA FIDUCIARIA (canone ricorrente)' servizio, 22000 valore union all
select 2020 anno, 'SEMPIONE SIM (canone ricorrente)' servizio, 18565 valore union all
select 2020 anno, 'SIMGEST (canone variabile)' servizio, 2000 valore union all
select 2020 anno, 'TACCONIS ADVISOR (canone ricorrente)' servizio, 12532 valore union all
select 2020 anno, 'THUX (canone ricorrente)' servizio, 3000 valore union all
select 2020 anno, 'TOSETTI VALUE (canone ricorrente)' servizio, 27815.4 valore union all
select 2020 anno, 'MIKONO - INNOFIN SIM (canone ricorrente)' servizio, 25552 valore union all
select 2020 anno, 'MIKONO - OCP (canone ricorrente)' servizio, 32448 valore union all
select 2020 anno, 'MIKONO - OCP (canone variabile)' servizio, 2250 valore union all
select 2020 anno, 'MIKONO - VONTOBEL (canone variabile)' servizio, 9000 valore union all
select 2020 anno, 'MIKONO - VONTOBEL (canone ricorrente)' servizio, 31500 valore union all
select 2020 anno, 'NEXTAM (canone ricorrente)' servizio, 27750 valore union all
select 2021 anno, 'ATAILAB  (canone ricorrente)' servizio, 6000 valore --50 % risconto attivo (sarà da aggiornare al 2021 con la voce per intero!)


) , canoni AS (SELECT 	canoniannui.anno
						,canoniannui.servizio
						,data.Mese
						,canoniannui.valore / 12 valore
				FROM canoniannui
				JOIN (SELECT DISTINCT Mese, Anno  FROM rs.S_Data) data
				ON canoniannui.anno = data.Anno
			
				)
				

,servizi_kpi AS (
select '8A+ SGR (canone ricorrente)' servizio_fittizio, '3' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select '8A+ SGR (canone variabile)' servizio_fittizio, '3' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'AMARANTO  (canone ricorrente)' servizio_fittizio, '6' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'ANTHILIA SGR (canone ricorrente)' servizio_fittizio, '16' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'ASSITECA SIM (canone ricorrente)' servizio_fittizio, '14' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'ATAILAB  (canone ricorrente)' servizio_fittizio, '23' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'BANOR (canone ricorrente)' servizio_fittizio, '8' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'CAMPERIO (canone ricorrente)' servizio_fittizio, '13' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'CLASSIS CAPITAL (canone ricorrente)' servizio_fittizio, '4' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'CLASSIS CAPITAL (canone variabile)' servizio_fittizio, '4' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'CONSILIA OFFICE  (canone ricorrente)' servizio_fittizio, '24' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'FAMILY ADVISOR SIM (canone ricorrente)' servizio_fittizio, '2' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'GIOTTO SIM (canone ricorrente)' servizio_fittizio, '12' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'GSA (canone ricorrente)' servizio_fittizio, '26' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'LAMARCK SIM (canone variabile)' servizio_fittizio, '10' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'MOVING (canone variabile)' servizio_fittizio, '27' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'PRIVATE CONSULTING SRL (canone ricorrente)' servizio_fittizio, '5' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'PROMETEIA (canone ricorrente)' servizio_fittizio, '9' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'SELLA FIDUCIARIA (canone ricorrente)' servizio_fittizio, '25' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'SEMPIONE SIM (canone ricorrente)' servizio_fittizio, '7' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'SIMGEST (canone variabile)' servizio_fittizio, '1' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'TACCONIS ADVISOR (canone ricorrente)' servizio_fittizio, '15' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'THUX (canone ricorrente)' servizio_fittizio, '22' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'TOSETTI VALUE (canone ricorrente)' servizio_fittizio, '11' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'MIKONO - INNOFIN SIM (canone ricorrente)' servizio_fittizio, '18' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'MIKONO - OCP (canone ricorrente)' servizio_fittizio, '19' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'MIKONO - OCP (canone variabile)' servizio_fittizio, '19' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'MIKONO - VONTOBEL (canone variabile)' servizio_fittizio, '20' codcliente, 251 codservizio, 183 codkpi, 'CESAM Remunerazione Servizi FeeOnly FLOOR' deskpi union all
select 'MIKONO - VONTOBEL (canone ricorrente)' servizio_fittizio, '20' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi union all
select 'NEXTAM (canone ricorrente)' servizio_fittizio, '21' codcliente, 251 codservizio, 182 codkpi, 'CESAM Remunerazione Servizi FeeOnly ON TOP' deskpi

)


SELECT 8 AS  CodLineaBusiness,
15 as CodUnitaOrganizzativa,
codservizio,
codcliente,
NULL as CodOriginator,
anno yy,
mese mm,
deskpi KPI,
codKPI,
	CASE WHEN mese = DATEPART(MONTH,GETDATE()) 
			AND anno = DATEPART(YEAR,GETDATE())
			THEN valore /  (SELECT COUNT(ChiaveData) FROM rs.S_Data
			WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) --AND FlagFestivo = 0
			AND ChiaveData <=  EOMONTH(GETDATE())) * (
			
			SELECT COUNT(ChiaveData) FROM rs.S_Data
			WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) --AND FlagFestivo = 0
			AND ChiaveData <= CAST(GETDATE() as DATE) --AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
			
			)
			
			
			ELSE valore END as Valore
		
		 FROM canoni
JOIN servizi_kpi on servizi_kpi.servizio_fittizio = canoni.servizio
WHERE anno < DATEPART(YEAR, GETDATE())
OR (anno = DATEPART(YEAR, GETDATE()) AND mese <= DATEPART(MONTH,GETDATE()))
--/ COUNT(ChiaveData) FROM rs.S_Data
--WHERE Mese = DATEPART(MONTH,GETDATE()) AND Anno = DATEPART(YEAR,GETDATE()) AND FlagFestivo = 0) canone , DATEPART(MONTH,GETDATE()) mm
--FROM rs.S_Data where ChiaveData <= CAST(GETDATE() as DATE) AND ChiaveData >=  DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) AND FlagFestivo = 0

GO