--vp-btsql02

USE CLC
GO

BEGIN TRANSACTION

TRUNCATE TABLE R_GruppoMotiviTransizione_MotivoTransizione

--39 rows
INSERT INTO [VP-BTSQL02].CLC.dbo.R_GruppoMotiviTransizione_MotivoTransizione (CodGruppoMotiviTransizione, CodMotivoTransizione)
	SELECT
		CodGruppoMotiviTransizione
		,CodMotivoTransizione
	FROM [BTSQLCL05\BTSQLCL05].clc.dbo.R_GruppoMotiviTransizione_MotivoTransizione



TRUNCATE TABLE R_Cliente_TipoIncarico_GruppoMotiviTransizione

--20 rows
INSERT INTO [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_GruppoMotiviTransizione 
SELECT
	CodCliente
	,CodTipoIncarico
	,CodStatoWorkflowIncaricoPartenza
	,FlagAttesaPartenza
	,FlagUrgentePartenza
	,CodAttributoIncaricoPartenza
	,CodStatoWorkflowIncaricoDestinazione
	,FlagAttesaDestinazione
	,FlagUrgenteDestinazione
	,CodAttributoIncaricoDestinazione
	,CodGruppoMotiviTransizione
	,FlagBloccante
FROM [BTSQLCL05\BTSQLCL05].clc.dbo.R_Cliente_TipoIncarico_GruppoMotiviTransizione



TRUNCATE TABLE [VP-BTSQL02].CLC.dbo.D_MotivoTransizione

--35 rows
INSERT INTO D_MotivoTransizione 
SELECT
	Codice
	,Descrizione
FROM [BTSQLCL05\BTSQLCL05].clc.dbo.D_MotivoTransizione


TRUNCATE TABLE [VP-BTSQL02].CLC.dbo.D_GruppoMotiviTransizione

--10 rows
INSERT INTO [VP-BTSQL02].CLC.dbo.D_GruppoMotiviTransizione 
SELECT
	Codice
	,Descrizione
FROM [BTSQLCL05\BTSQLCL05].clc.dbo.D_GruppoMotiviTransizione

--COMMIT TRANSACTION
--ROLLBACK TRANSACTION
