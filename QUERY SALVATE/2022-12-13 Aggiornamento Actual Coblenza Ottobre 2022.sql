USE CLC_Cesam
GO

SELECT * 
FROM rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne t
JOIN rs.CESAM_ServiziInvestimento_Board_Servizi_KPI_Clienti s ON t.CodFonteAggregazioneClienti = s.CodFonteAggregazioneClienti
AND s.Servizio_fittizio = t.Servizio
WHERE s.CodFonteAggregazioneClienti = 20
AND t.Anno = 2022
AND mese = 10
AND t.FlagAttivo = 1

UPDATE rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne
SET FlagAttivo = 0
FROM rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne t
JOIN rs.CESAM_ServiziInvestimento_Board_Servizi_KPI_Clienti s ON t.CodFonteAggregazioneClienti = s.CodFonteAggregazioneClienti
AND s.Servizio_fittizio = t.Servizio
WHERE s.CodFonteAggregazioneClienti = 20
AND t.Anno = 2022
AND mese = 10
AND t.FlagAttivo = 1


SELECT * FROM rs.CESAM_ServiziInvestimento_Board_Servizi_KPI_Clienti
WHERE CodFonteAggregazioneClienti = 20
AND CodServizio = 420

INSERT INTO rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne (CodFonteAggregazioneClienti, Anno, Servizio, Mese, Valore, Note, FlagAttivo)
SELECT 20, 2022, 'COB - Servizi Middle Office - LUX', 10,  94033.33, null, 1 UNION
SELECT 20, 2022, 'COB - Licenza E Assistenza Sui Flussi Giornalieri new', 10,  13466.67, NULL, 1 UNION
SELECT 20, 2022, 'COB - Servizi Middle Office - Italia (Impact)', 10, 1208.33, NULL, 1 UNION
SELECT 20, 2022, 'COB - Dandsolutions - Italia', 10, 28000, 'Costo persone (imponibile)  che erogano servizio fatturato  ad Azimut da Dand', 1 UNION
SELECT 20, 2022, 'COB - Dansoluitions - LUX', 10, 68000, 'La Fattura è emessa da DANDSOLUTIONS Non va inviata in contabilità', 1 UNION 
SELECT 20, 2022, 'COB - Servizi Middle Office - Italia', 10, 62310.22, NULL, 1 UNION
SELECT 20, 2022, 'COB - Licenza E Assistenza Sui Flussi Giornalieri new', 10, 8978, NULL, 1 UNION
SELECT 20, 2022, 'COB - Servizi Middle Office - Italia (Arca Fondi)', 10, 30000, 'Attività NON ricorrente, vale SOLO per ottobre', 1


INSERT INTO rs.CESAM_ServiziInvestimento_Board_Servizi_KPI_Clienti (CodFonteAggregazioneClienti, Servizio_fittizio, CodCliente, CodServizio, CodKPI, DescrizioneKPI)
	VALUES (20, 'COB - Servizi Middle Office - Italia (Arca Fondi)', 3, 420, 200,null);





