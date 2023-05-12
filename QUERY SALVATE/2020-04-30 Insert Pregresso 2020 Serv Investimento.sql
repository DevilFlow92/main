USE CLC
GO



DECLARE @dataStart DATETIME = '20200101'
,@dataFINE DATETIME = '20200229'

--INSERT INTO [rs].[Board_KPI_BPODivision_InvestmentServices] ([CodLineaBusiness]
--, [CodUnitaOrganizzativa]
--, [CodServizio]
--, [idCliente]
--, [idCanale]
--, [yy]
--, [mm]
--, [CodKPI]
--, [Valore]
--, [CodFonteAggregazioneClienti])

	SELECT
		[CodLineaBusiness]
		,[CodUnitaOrganizzativa]
		,[CodServizio]
		,[a].CodCiente
		,a.CodOrignator
		,[yy]
		,[mm]
		,[CodKPI]
		,[Valore]
		,CodFonteAggregazioneClienti

	FROM [rs].[v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Cesam] a
	JOIN (SELECT DISTINCT
		ANNO
		,Mese
	FROM rs.S_DATA sd
	WHERE Data >= @dataStart
	AND sd.Data <= @dataFINE) SD
		ON a.YY = SD.Anno
		AND a.mm = SD.Mese
	AND CodKPI IN (
186	--CESAM Canone per affitto locali
,183	--CESAM Remunerazione Servizi FeeOnly ON FLOOR
,182	--CESAM Remunerazione Servizi FeeOnly ON TOP
,181	--CESAM Numero pratiche lavorate AZ Libera Impresa
,180	--CESAM Numero pratiche lavorate AZ Life
)


--INSERT INTO [rs].[Board_KPI_BPODivision_InvestmentServices] ([CodLineaBusiness]
--, [CodUnitaOrganizzativa]
--, [CodServizio]
--, [idCliente]
--, [idCanale]
--, [yy]
--, [mm]
--, [CodKPI]
--, [Valore]
--, [CodFonteAggregazioneClienti])
	SELECT
		[CodLineaBusiness]
		,[CodUnitaOrganizzativa]
		,[CodServizio]
		,[a].CodCliente
		,a.[CodOriginator]
		,[yy]
		,[mm]
		,[CodKPI]
		,[Valore]
		,13 -- Fonte "Mikono Provvisorio"

	FROM [rs].[v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Mikono] a
	JOIN (SELECT DISTINCT
		ANNO
		,Mese
	FROM rs.S_DATA sd
	WHERE Data >= @dataStart
	AND sd.Data <= @dataFINE) SD
		ON a.YY = SD.Anno
		AND a.mm = SD.Mese
	AND a.codKPI IN (185	--MIKONO Valore canone Variabile (ON TOP)
,184	--MIKONO Valore canone Ricorrente
)