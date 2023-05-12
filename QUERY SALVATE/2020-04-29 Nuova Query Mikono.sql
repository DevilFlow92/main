USE CLC_DatawareHouse
GO


--ALTER  VIEW rs.v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Mikono
--AS


/*
	Author:				andrea.padricelli
	Date:				04/03/2019
	Description:			- Vista di Export utilizzata per il popolamento di [rs].[Board_KPI_BPODivision_InvestmentServices] (Tabella richiamata da ODBC di Board)


	rs.Board_KPI_BPODivision_D_Servizi 
	rs.Board_KPI_BPODivision_D_TipoKPI 


*/

/*

SELECT 	CodLineaBusiness,
		CodUnitaOrganizzativa,
		CodServizio,
		CodCiente,
		CodOrignator,
		yy,
		mm,
		KPI,
		codKPI,
		ISNULL(Valore,0) Valore FROM rs.v_CESAM_CB_KPI_Budgeting
*/
--;
WITH canoni as (select 2017 anno, 'Innofin (canone ricorrente)' servizio, 1 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 2 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 3 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 4 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 5 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 6 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 7 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 8 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 9 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 10 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 11 mese, 12633.33 valore union all
select 2017 anno, 'Innofin (canone ricorrente)' servizio, 12 mese, 12633.33 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 1 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 2 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 3 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 4 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 5 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 6 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 7 mese, 18166.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 8 mese, 18666.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 9 mese, 18666.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 10 mese, 18666.66 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 11 mese, 18666.67 valore union all
select 2017 anno, 'Anthilia (canone ricorrente)' servizio, 12 mese, 18666.67 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 1 mese, 0 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 2 mese, 0 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 3 mese, 6500 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 4 mese, 6500 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 5 mese, 6500 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 6 mese, 6500 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 7 mese, 22333.33 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 8 mese, 22333.33 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 9 mese, 22333.33 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 10 mese, 22333.33 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 11 mese, 22333.33 valore union all
select 2017 anno, 'OCP (canone ricorrente)' servizio, 12 mese, 22333.33 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 1 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 2 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 3 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 4 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 5 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 6 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 7 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 8 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 9 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 10 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 11 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone ricorrente)' servizio, 12 mese, 375 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 1 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 2 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 3 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 4 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 5 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 6 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 7 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 8 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 9 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 10 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 11 mese, 968.75 valore union all
select 2017 anno, 'F2A -Sator- (canone variabile)' servizio, 12 mese, 968.75 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 1 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 2 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 3 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 4 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 5 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 6 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 7 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 8 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 9 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 10 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 11 mese, 900 valore union all
select 2017 anno, '4Timing (canone ricorrente)' servizio, 12 mese, 900 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 1 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 2 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 3 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 4 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 5 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 6 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 7 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 8 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 9 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 10 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 11 mese, 12633.33 valore union all
select 2018 anno, 'Innofin (canone ricorrente)' servizio, 12 mese, 12633.33 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 1 mese, 18666.66 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 2 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 3 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 4 mese, 18666.66 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 5 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 6 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 7 mese, 18666.66 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 8 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 9 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 10 mese, 18666.66 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 11 mese, 18666.67 valore union all
select 2018 anno, 'Anthilia (canone ricorrente)' servizio, 12 mese, 18666.67 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 1 mese, 22333.34 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 2 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 3 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 4 mese, 22333.34 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 5 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 6 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 7 mese, 22333.34 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 8 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 9 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 10 mese, 22333.34 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 11 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone ricorrente)' servizio, 12 mese, 22333.33 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 1 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 2 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 3 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 4 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 5 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 6 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 7 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 8 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 9 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 10 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 11 mese, 1338.66 valore union all
select 2018 anno, 'OCP (canone variabile)' servizio, 12 mese, 1338.66 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 1 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 2 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 3 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 4 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 5 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 6 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 7 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 8 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 9 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 10 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 11 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone ricorrente)' servizio, 12 mese, 375 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 1 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 2 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 3 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 4 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 5 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 6 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 7 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 8 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 9 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 10 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 11 mese, 968.75 valore union all
select 2018 anno, 'F2A -Sator- (canone variabile)' servizio, 12 mese, 968.75 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 1 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 2 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 3 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 4 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 5 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 6 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 7 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 8 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 9 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 10 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 11 mese, 900 valore union all
select 2018 anno, '4Timing (canone ricorrente)' servizio, 12 mese, 900 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 1 mese, 6000 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 2 mese, 6000 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 3 mese, 6000 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 4 mese, 6000 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 5 mese, 6000 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 6 mese, 6000 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 7 mese, 0 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 8 mese, 0 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 9 mese, 0 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 10 mese, 0 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 11 mese, 0 valore union all
select 2018 anno, 'David Capital (canone ricorrente)' servizio, 12 mese, 0 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 1 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 2 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 3 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 4 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 5 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 6 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 7 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 8 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 9 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 10 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 11 mese, 12633.33 valore union all
select 2019 anno, 'Innofin (canone ricorrente)' servizio, 12 mese, 12633.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 1 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 2 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 3 mese, 17333.34 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 4 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 5 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 6 mese, 17333.34 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 7 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 8 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 9 mese, 17333.34 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 10 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 11 mese, 17333.33 valore union all
select 2019 anno, 'Anthilia (canone ricorrente)' servizio, 12 mese, 17333.34 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 1 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 2 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 3 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 4 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 5 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 6 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 7 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 8 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 9 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 10 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 11 mese, 24000 valore union all
select 2019 anno, 'OCP (canone ricorrente)' servizio, 12 mese, 24000 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 1 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 2 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 3 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 4 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 5 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 6 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 7 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 8 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 9 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 10 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 11 mese, 1338.66 valore union all
select 2019 anno, 'OCP (canone variabile)' servizio, 12 mese, 1338.66 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 1 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 2 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 3 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 4 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 5 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 6 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 7 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 8 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 9 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 10 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 11 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone ricorrente)' servizio, 12 mese, 375 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 1 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 2 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 3 mese, 583.34 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 4 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 5 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 6 mese, 583.34 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 7 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 8 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 9 mese, 583.34 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 10 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 11 mese, 583.33 valore union all
select 2019 anno, 'F2A -Sator- (canone variabile)' servizio, 12 mese, 583.34 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 1 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 2 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 3 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 4 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 5 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 6 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 7 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 8 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 9 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 10 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 11 mese, 900 valore union all
select 2019 anno, '4Timing (canone ricorrente)' servizio, 12 mese, 900 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 1 mese, 6000 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 2 mese, 6000 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 3 mese, 6000 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 4 mese, 6000 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 5 mese, 6000 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 6 mese, 6000 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 7 mese, 0 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 8 mese, 0 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 9 mese, 0 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 10 mese, 0 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 11 mese, 0 valore union all
select 2019 anno, 'David Capital (canone ricorrente)' servizio, 12 mese, 0 valore UNION ALL
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 1 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 2 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 3 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 4 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 5 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 6 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 7 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 8 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 9 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 10 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 11 mese, 12633.33 valore union all
select 2020 anno, 'Innofin (canone ricorrente)' servizio, 12 mese, 12633.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 1 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 2 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 3 mese, 17333.34 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 4 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 5 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 6 mese, 17333.34 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 7 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 8 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 9 mese, 17333.34 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 10 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 11 mese, 17333.33 valore union all
select 2020 anno, 'Anthilia (canone ricorrente)' servizio, 12 mese, 17333.34 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 1 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 2 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 3 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 4 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 5 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 6 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 7 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 8 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 9 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 10 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 11 mese, 24000 valore union all
select 2020 anno, 'OCP (canone ricorrente)' servizio, 12 mese, 24000 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 1 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 2 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 3 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 4 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 5 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 6 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 7 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 8 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 9 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 10 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 11 mese, 1338.66 valore union all
select 2020 anno, 'OCP (canone variabile)' servizio, 12 mese, 1338.66 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 1 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 2 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 3 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 4 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 5 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 6 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 7 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 8 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 9 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 10 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 11 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone ricorrente)' servizio, 12 mese, 375 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 1 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 2 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 3 mese, 583.34 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 4 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 5 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 6 mese, 583.34 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 7 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 8 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 9 mese, 583.34 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 10 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 11 mese, 583.33 valore union all
select 2020 anno, 'F2A -Sator- (canone variabile)' servizio, 12 mese, 583.34 valore union ALL
select 2020 anno, '4Timing (canone ricorrente)' servizio, 1 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 2 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 3 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 4 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 5 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 6 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 7 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 8 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 9 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 10 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 11 mese, 900 valore union all
select 2020 anno, '4Timing (canone ricorrente)' servizio, 12 mese, 900 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 1 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 2 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 3 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 4 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 5 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 6 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 7 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 8 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 9 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 10 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 11 mese, 0 valore union all
select 2020 anno, 'David Capital (canone ricorrente)' servizio, 12 mese, 0 valore UNION ALL

select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 1 mese, 5000 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 2 mese, 5000 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 3 mese, 5000 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 4 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 5 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 6 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 7 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 8 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 9 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 10 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 11 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone ricorrente)' servizio, 12 mese, 20542 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 1 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 2 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 3 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 4 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 5 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 6 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 7 mese, 10000 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 8 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 9 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 10 mese, 5000 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 11 mese, 0 valore union all
select 2020 anno, 'VONTOBEL (canone variabile)' servizio, 12 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 1 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 2 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 3 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 4 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 5 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 6 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 7 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 8 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 9 mese, 0 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 10 mese, 5000 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 11 mese, 5000 valore union all
select 2020 anno, 'BRERA (canone ricorrente)' servizio, 12 mese, 5000 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 1 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 2 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 3 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 4 mese, 10000 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 5 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 6 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 7 mese, 10000 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 8 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 9 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 10 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 11 mese, 0 valore union all
select 2020 anno, 'BRERA (canone variabile)' servizio, 12 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 1 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 2 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 3 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 4 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 5 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 6 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 7 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 8 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 9 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 10 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 11 mese, 7500 valore union all
select 2020 anno, 'GARDENA (canone ricorrente)' servizio, 12 mese, 7500 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 1 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 2 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 3 mese, 3000 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 4 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 5 mese, 8400 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 6 mese, 3000 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 7 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 8 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 9 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 10 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 11 mese, 0 valore union all
select 2020 anno, 'GARDENA (canone variabile)' servizio, 12 mese, 0 valore 

) 

,servizi_kpi AS (

/*37	Servizi IT
38	Servizi Operativi
7	Brera
8	Gardena
9	Vontobel

KPI
184	MIKONO Valore canone Ricorrente			Gestiamo su unico KPI (a differenza di altri mikono che sono dedicati ai clienti)
185	MIKONO Valore canone Variabile (ON TOP)	Gestiamo su unico KPI (a differenza di altri mikono che sono dedicati ai clienti)

*/
select '4Timing (canone ricorrente)'       servizio_fittizio, '1' codcliente, 38 codservizio, 102 codKPI, 'MIKONO Valore canone ricorrente 4Timing'			deskpi union all
select 'Anthilia (canone ricorrente)'	   servizio_fittizio, '2' codcliente, 38 codservizio, 103 codKPI, 'MIKONO Valore canone ricorrente Anthilia'			deskpi union all
select 'David Capital (canone ricorrente)' servizio_fittizio, '3' codcliente, 38 codservizio, 104 codKPI, 'MIKONO Valore canone ricorrente David Capital'	deskpi union all
select 'F2A -Sator- (canone ricorrente)'   servizio_fittizio, '4' codcliente, 38 codservizio, 105 codKPI, 'MIKONO Valore canone ricorrente F2A'				deskpi union all
select 'F2A -Sator- (canone variabile)'	   servizio_fittizio, '4' codcliente, 38 codservizio, 106 codKPI, 'MIKONO Valore canone variabile F2A'				deskpi union all
select 'Innofin (canone ricorrente)'	   servizio_fittizio, '5' codcliente, 38 codservizio, 107 codKPI, 'MIKONO Valore canone ricorrente Innofin'			deskpi union all
select 'OCP (canone ricorrente)'		   servizio_fittizio, '6' codcliente, 38 codservizio, 108 codKPI, 'MIKONO Valore canone ricorrente OCP'				deskpi union all
select 'OCP (canone variabile)'			   servizio_fittizio, '6' codcliente, 38 codservizio, 109 codKPI, 'MIKONO Valore canone variabile OCP'				deskpi UNION ALL
select 'Brera (canone ricorrente)'		   servizio_fittizio, '7' codcliente, 38 codservizio, 184 codKPI, 'MIKONO Valore canone Ricorrente'					deskpi union all
select 'Brera (canone variabile)'		   servizio_fittizio, '7' codcliente, 38 codservizio, 185 codKPI, 'MIKONO Valore canone Variabile (ON TOP)'			deskpi union all
select 'Gardena (canone ricorrente)'	   servizio_fittizio, '8' codcliente, 38 codservizio, 184 codKPI, 'MIKONO Valore canone Ricorrente'					deskpi union all
select 'Gardena (canone variabile)'		   servizio_fittizio, '8' codcliente, 38 codservizio, 185 codKPI, 'MIKONO Valore canone Variabile (ON TOP)'			deskpi union all
select 'Vontobel (canone ricorrente)'	   servizio_fittizio, '9' codcliente, 38 codservizio, 184 codKPI, 'MIKONO Valore canone Ricorrente'					deskpi union all
select 'Vontobel (canone variabile)'	   servizio_fittizio, '9' codcliente, 38 codservizio, 185 codKPI, 'MIKONO Valore canone Variabile (ON TOP)'			deskpi

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