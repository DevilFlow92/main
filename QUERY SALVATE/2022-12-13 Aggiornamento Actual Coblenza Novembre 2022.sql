USE CLC_Cesam
GO

UPDATE rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne
SET FlagAttivo = 0
FROM rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne t
JOIN rs.CESAM_ServiziInvestimento_Board_Servizi_KPI_Clienti s ON t.CodFonteAggregazioneClienti = s.CodFonteAggregazioneClienti
AND s.Servizio_fittizio = t.Servizio
WHERE s.CodFonteAggregazioneClienti = 20
AND t.Anno = 2022
AND t.mese = 11
AND t.FlagAttivo = 1


INSERT INTO rs.CESAM_ServiziInvestimento_Board_KPI_Budgeting_RevenuesEsterne (CodFonteAggregazioneClienti, Anno, Servizio, Mese, Valore, Note, FlagAttivo)
SELECT 20, 2022, 'COB - Servizi Middle Office - LUX', 11, 94033.33, NULL, 1 UNION
SELECT 20, 2022, 'COB - Licenza E Assistenza Sui Flussi Giornalieri new', 11, 13466.67, NULL, 1 UNION
SELECT 20, 2022, 'COB - Servizi Middle Office - Italia (Impact)', 11, 1208.33, NULL, 1 UNION
SELECT 20, 2022, 'COB - Dandsolutions - Italia', 11, 28000, 'Costo persone (imponibile) che erogano servizio fatturato ad Azimut da Dand', 1 UNION
SELECT 20, 2022, 'COB - Dansoluitions - LUX', 11, 68000, 'La fattura è emessa da DANDSOLUTIONS Non va inviata in contabilità', 1 UNION
SELECT 20, 2022, 'COB - Servizi Middle Office - Italia',11, 62310.22, NULL, 1 UNION
SELECT 20, 2022, 'COB - Licenza E Assistenza Sui Flussi Giornalieri new',11, 8978, NULL, 1

