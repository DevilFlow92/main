

INSERT INTO rs.KPI_BPODivision_RevenuesSpotPerServizio_InvestmentServices 
(CodLineaBusiness, CodUnitaOrganizzativa, CodServizio, idCliente, yy, mm, CodKPI, Valore, Note, CodFonteAggregazioneClienti)
	SELECT 3, 14, 61, 23, 2022, 5, 999999, 65000, 'I tranche remediation AML', 2 UNION
	SELECT 3, 14, 61, 23, 2022, 9, 999999, 65000, 'II tranche remediation AML', 2 UNION
	SELECT 3, 14, 61, 23, 2022, 3, 999999, 21000, 'straordinari AML taskforce ispez Bankit', 2 UNION
	SELECT 3, 14, 61, 23, 2022, 6, 999999, 15000, 'Risorse aggiuntive per attività AML running H1 2022', 2 UNION
	SELECT 3, 14, 61, 23, 2022, 2, 999999, 30000, 'I tranche set-up Beewise', 2 UNION
	SELECT 3, 14, 61, 23, 2022, 4, 999999, 10000, 'II tranche set-up Beewise', 2 UNION
	SELECT 3, 14, 61, 23, 2022, 3, 999999, 5000, 'TASKFORCE CASE TERZE', 2


INSERT INTO  rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne (CodFonteAggregazioneClienti, Anno, Servizio, Mese, Valore, Note, FlagAttivo)
SELECT 2, 2022, 'AZ Caricamento Massivo da Docugest', 5, 5000, 'Docugest (inserito su servizio dedicato come richiesto', 1
