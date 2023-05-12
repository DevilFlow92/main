USE clc
GO

SELECT CASE codKPI
			WHEN 32 THEN SUM(valore) * 28.01
			WHEN 31 THEN SUM(valore) * 6.29
			WHEN 33 THEN SUM(valore)
			WHEN 199 THEN SUM(valore)
			WHEN 198 THEN SUM(valore) *39.86
			END
			  as Valore
,dkpi.Descrizione KPI
FROM rs.STG_Board_KPI_BPODivision_ServiziInvestimento t
JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_TipoKPI dkpi ON dkpi.Codice = t.CodKPI
--JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_Servizi dservizi

WHERE t.yy = 2021
AND t.mm = 8
AND t.CodFonteCliente = 2
AND t.CodCliente = 48

GROUP BY t.CodKPI, dkpi.Descrizione


--SELECT t.CodKPI,dkpi.Descrizione KPI, SUM(t.Valore) Valore 
--FROM rs.STG_Board_KPI_BPODivision_ServiziInvestimento t
--JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_TipoKPI dkpi ON dkpi.Codice = t.CodKPI

--WHERE CodFonteCliente = 2
--AND CodCliente = 73
--AND yy = 2021
--AND mm = 8
--GROUP BY T.CodKPI, dkpi.Descrizione