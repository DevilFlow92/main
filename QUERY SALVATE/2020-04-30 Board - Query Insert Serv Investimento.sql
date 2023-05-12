USE CLC_DatawareHouse
GO

ALTER  PROCEDURE rs.p_RS_BPO_Load_Board_KPI_BPODivision_InvestmentServices --( @dataStart datetime )

AS
 
BEGIN

/*

	Date:			22/03/2019
	Author:			G.Piga, A.Padricelli, L.Spanu, L. Fiori
	Description:
	
	
		
	- Estrae i dati da:
							[rs].[v_RS_BPO_EXPORT_Board_KPI_BPODivision_InvestmentServices_Cesam]

	- Carica i dati su:		[rs].[Board_KPI_BPODivision_InvestmentServices]

*/




SET NOCOUNT ON
SET XACT_ABORT ON

--/*
	BEGIN TRAN
	BEGIN TRY
--*/


--SET STATISTICS TIME ON 
--SET STATISTICS TIME OFF 

-- -- DICHIARO @dataStart E @dataFINE per desterminare il periodo da aggiornare 

DECLARE 
		  @dataStart	DATETIME
		, @dataFINE		DATETIME

SET		@dataStart =	DATEADD(MONTH,-1,rs.f_DateSerial(YEAR(GETDATE()),MONTH(GETDATE()),1))
SET     @dataFINE =		CAST(GETDATE() AS DATE)



--SELECT	@dataStart , @dataFINE



-- -- ELIMINO dalla tabella di destinazione le righe da aggiornare


DELETE xx  FROM [rs].[Board_KPI_BPODivision_InvestmentServices] xx 
	JOIN 
		(
			SELECT DISTINCT ANNO, Mese 
			FROM rs.S_DATA sd WHERE Data >= @dataStart
			AND sd.Data <= @dataFINE
		) SD ON xx.YY = SD.Anno AND xx.mm = SD.Mese



-- -- INSERISCO sulla tabella di destinazione le nuove righe estratte dalla vista di EXPORT


INSERT INTO [rs].[Board_KPI_BPODivision_InvestmentServices]
           (
            [CodLineaBusiness]
           ,[CodUnitaOrganizzativa]
           ,[CodServizio]
           ,[idCliente]
           ,[idCanale]
           ,[yy]
           ,[mm]
           ,[CodKPI]
           ,[Valore]
		   ,[CodFonteAggregazioneClienti]
		   )
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
	JOIN 
		(
			SELECT DISTINCT ANNO, Mese 
			FROM rs.S_DATA sd WHERE Data >= @dataStart
			AND sd.Data <= @dataFINE
		) SD ON a.YY = SD.Anno AND a.mm = SD.Mese



INSERT INTO [rs].[Board_KPI_BPODivision_InvestmentServices]
           (
            [CodLineaBusiness]
           ,[CodUnitaOrganizzativa]
           ,[CodServizio]
           ,[idCliente]
           ,[idCanale]
           ,[yy]
           ,[mm]
           ,[CodKPI]
           ,[Valore]
		   ,[CodFonteAggregazioneClienti]
		   )
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
	JOIN 
		(
			SELECT DISTINCT ANNO, Mese 
			FROM rs.S_DATA sd WHERE Data >= @dataStart
			AND sd.Data <= @dataFINE
		) SD ON a.YY = SD.Anno AND a.mm = SD.Mese





--/*
  		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
--*/


END

GO