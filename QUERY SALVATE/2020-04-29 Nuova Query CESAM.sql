USE CLC_DatawareHouse
GO

--ALTER  VIEW rs.v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Cesam
--AS


/*
	Author:				andrea.padricelli / lorenzo.fiori
	Date:				04/03/2019
	Description:			- Vista di Export utilizzata per il popolamento di [rs].[Board_KPI_BPODivision_InvestmentServices] (Tabella richiamata da ODBC di Board)


	rs.Board_KPI_BPODivision_D_Servizi 
	rs.Board_KPI_BPODivision_D_TipoKPI 


*/



SELECT 	CodLineaBusiness,
		CodUnitaOrganizzativa,
		CodServizio,
		CodCiente,
		CodOrignator,
		yy,
		mm,
		KPI,
		codKPI,
		ISNULL(Valore,0) Valore 
		,2 CodFonteAggregazioneClienti
		
		FROM rs.v_CESAM_CB_KPI_Budgeting

UNION ALL


SELECT 	CodLineaBusiness,
		CodUnitaOrganizzativa,
		CodServizio,
		CodCiente,
		CodOrignator,
		yy,
		mm,
		KPI,
		codKPI,
		ISNULL(Valore,0) Valore 
		,2 CodFonteAggregazioneClienti

		FROM rs.v_CESAM_IW_KPI_Budgeting

UNION ALL


SELECT 	CodLineaBusiness,
		CodUnitaOrganizzativa,
		CodServizio,
		CodCiente,
		CodOrignator,
		yy,
		mm,
		KPI,
		codKPI,
		ISNULL(Valore,0) Valore 
		,2 CodFonteAggregazioneClienti

		FROM rs.v_CESAM_AZ_KPI_Budgeting


UNION ALL
SELECT 	CodLineaBusiness,
		CodUnitaOrganizzativa,
		CodServizio,
		codcliente CodCiente,
		CodOriginator CodOrignator,
		yy,
		mm,
		KPI,
		codKPI,
		ISNULL(Valore,0) Valore 
		,17 CodFonteAggregazioneClienti

		FROM rs.v_CESAM_FO_KPI_Budgeting
GO