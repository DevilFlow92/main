USE CLC_Cesam
GO

WITH prezzi AS (

SELECT t.CodLineaBusiness
		,t.CodUnitaOrganizzativa
		,t.CodServizio
		,t.CodMisura
		,sfonte.CodClienteFonte CodCliente
		,Prezzo
		,CAST(r.CodKpi as INT) CodKPI
		,dkpi.Descrizione KPI
		,rcss.CodSocieta

		FROM BudgetBPO.DBO.v_Board_KPI_BPODivision_Budget_ServiziInvestimento t --LF 2022-05-23
		JOIN budgetbpo.dbo.Board_KPI_BPODivision_S_ClienteFonte_Cliente sfonte ON t.CodCliente = sfonte.CodCliente
		AND sfonte.CodFonteCliente = 2 --qtask
		AND sfonte.CodClienteFonte IN ( 48 --Chebanca in qtask
										,73 --iwbank in qtask
										)
		JOIN BudgetBPO.dbo.Board_KPI_BPODivision_R_Cliente_Servizio_Societa rcss ON t.CodCliente = rcss.CodCliente
		AND t.CodServizio = rcss.CodServizio
		
		JOIN budgetbpo.dbo.Board_KPI_BPODivision_R_Kpi_Servizio_Misura r ON t.CodServizio = r.CodServizio
		AND t.CodMisura = r.CodMisura
		JOIN budgetbpo.dbo.Board_KPI_BPODivision_D_Kpi dkpi ON r.CodKpi = dkpi.Codice
		WHERE t.Anno = YEAR(getdate())
		)

SELECT t.CodLineaBusiness, t.CodUnitaOrganizzativa, t.CodServizio, t.CodKPI, dkpi.Descrizione, D_Cliente.Descrizione, SUM(t.Valore) 
FROM rs.STG_Board_KPI_BPODivision_ServiziInvestimento t
JOIN BudgetBPO.dbo.Board_KPI_BPODivision_D_Kpi dkpi ON dkpi.Codice = T.CodKPI
JOIN D_Cliente ON t.CodCliente = D_Cliente.Codice
WHERE t.CodFonteCliente = 2 --qtask
AND t.CodCliente IN (48,73)
AND t.yy = 2022

GROUP BY yy, mm, t.CodKPI, dkpi.Descrizione, t.CodCliente