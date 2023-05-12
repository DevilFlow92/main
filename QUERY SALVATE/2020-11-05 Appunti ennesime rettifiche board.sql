USE clc
GO

INSERT INTO rs.KPI_BPODivision_RevenuesSpotPerServizio_InvestmentServices (CodLineaBusiness, CodUnitaOrganizzativa, CodServizio, idCliente, yy, mm, CodKPI, Valore, Note, CodFonteAggregazioneClienti)
select 3, 15, 38, 2,  2020, 9,   999999, -5000, 'Servizi On Top (MIKONO) - Rettifica mese di fatturazione', 13 union all
select 3, 15, 38, 2,  2020, 10,  999999, 7600, 'Servizi On Top (MIKONO) - Rettifica mese e importo di fatturazione', 13 union all
select 3, 15, 38, 9,  2020, 10,  999999, -833.67, 'Volumi Ricorrenti (MIKONO) - Importo non fatturato per ritardo configurazioni di sistema',13 union all
select 3, 15, 38, 9,  2020, 10,  999999, -5444, 'Servizi On Top (MIKONO) - Rettifica mese di fatturazione',13 union all
select 3, 15, 38, 9,  2020, 11,  999999, 500, 'Volumi Ricorrenti (MIKONO) - Attivazione nuovo servizio',13 union all
select 3, 15, 38, 9,  2020, 12,  999999, 500, 'Volumi Ricorrenti (MIKONO) - Attivazione nuovo servizio',13 union all
select 3, 15, 38, 9,  2020, 11,  999999, 11444, 'Servizi On Top (MIKONO) - Rettifica mese di fatturazione e nuovi sviluppi',13 union all
select 3, 15, 38, 9,  2020, 12,  999999, 10000, 'Servizi On Top (MIKONO) - Nuovi sviluppi',13 union all
select 3, 15, 38, 10, 2020, 10,  999999, 9600, 'Servizi On Top (MIKONO) - UT partenza nuovo cliente',13


SELECT * FROM rs.KPI_BPODivision_RevenuesSpotPerServizio_InvestmentServices
WHERE CodFonteAggregazioneClienti = 13

SELECT *
FROM [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_S_AggregazioneClienti
JOIN rs.Board_KPI_BPODivision_D_Cliente_AggregazioneClienti ON Codice = CodClienteAggregato
WHERE Codice = 348
WHERE CodFonteAggregazioneClienti = 13

SELECT * FROM rs.KPI_BPODivision_RevenuesSpotPerServizio_InvestmentServices 
WHERE CodFonteAggregazioneClienti = 13

SELECT * FROM rs.Board_KPI_BPODivision_D_Cliente_AggregazioneClienti WHERE Descrizione LIKE '%promete%'

SELECT * FROM 

SELECT 'CheBanca!' Cliente
,CodKPI
,dkpi.Descrizione
,yy
,mm

,
CASE codKPI
			WHEN 32 THEN valore * 28.01 
			WHEN 31 THEN valore * 6.29
			WHEN 33 THEN valore
			WHEN 199 THEN valore
			WHEN 198 THEN valore * 39.86
			END Importo
FROM rs.Board_KPI_BPODivision_InvestmentServices
JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_TipoKPI dkpi ON dkpi.Codice = CodKPI
WHERE idCliente = 48 AND yy = 2020 AND mm >= 10
UNION ALL
SELECT 'IW Bank' Cliente
,CodKPI
,dkpi.Descrizione
,yy
,mm

,Valore Importo
FROM rs.Board_KPI_BPODivision_InvestmentServices
JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_TipoKPI dkpi ON dkpi.Codice = CodKPI
AND idCliente = 73 AND yy = 2020 AND mm = 10




SELECT CodLineaBusiness, CodUnitaOrganizzativa, codservizio, codcliente, yy, mm, codKPI, Valore
FROM  rs.v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Mikono
WHERE yy = 2020
EXCEPT

SELECT CodLineaBusiness, CodUnitaOrganizzativa, CodServizio, idCliente, dcliente.Descrizione, yy, mm, CodKPI, dtipokpi.Descrizione, Valore
FROM rs.Board_KPI_BPODivision_InvestmentServices t
JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_S_AggregazioneClienti saggreg ON t.idCliente = saggreg.CodClienteFonte
AND t.CodFonteAggregazioneClienti = saggreg.CodFonteAggregazioneClienti
JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_Cliente_AggregazioneClienti dcliente ON saggreg.CodClienteAggregato = dcliente.Codice
JOIN [CASQLCL05\CASQLCL05].Leviticus.rs.Board_KPI_BPODivision_D_TipoKPI dtipokpi ON t.CodKPI = dtipokpi.Codice

WHERE t.CodFonteAggregazioneClienti = 13
AND yy = 2020

DELETE FROM rs.Board_KPI_BPODivision_InvestmentServices
WHERE CodFonteAggregazioneClienti = 13
AND yy = 2020


INSERT INTO rs.Board_KPI_BPODivision_InvestmentServices ( CodLineaBusiness, CodUnitaOrganizzativa, CodServizio, idCliente, idCanale, yy, mm, CodKPI, Valore, CodFonteAggregazioneClienti)
SELECT CodLineaBusiness, CodUnitaOrganizzativa, codservizio, codcliente, CodOriginator, yy, mm, codKPI, Valore, 13
FROM rs.v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Mikono
WHERE yy = 2020
