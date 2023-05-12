USE clc

GO



SELECT DATEADD(DAY,-7,CAST(GETDATE() AS DATE)) DataDAL
, CAST(GETDATE() AS DATE) DataAL

DECLARE @DataDal DATETIME = --'2021-05-01'
(SELECT CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + format(MONTH(DATEADD(MONTH,-1,GETDATE())),'d2')+'-01')

,@DataAl DATETIME = --'2021-05-17'
(SELECT CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '-' + format(MONTH(GETDATE()),'d2')+'-01')

SELECT @DataDal, @DataAl

--BEGIN TRANSACTION

--SELECT * FROM [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.sospesi
--WHERE  DataAperturaSospeso >= @DataDal
--AND DataAperturaSospeso < @DataAl

DELETE sospesi
FROM [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.sospesi sospesi
where DataAperturaSospeso >= @DataDal
AND DataAperturaSospeso < @DataAl
--ROLLBACK TRAN
DELETE globale 
from [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.globale
WHERE ChiaveDataRicezione >= @DataDal
AND ChiaveDataRicezione < @DataAl

INSERT into [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.sospesi
SELECT
	ChiaveScansione
	,IdIncarico
	,IdSospeso
	,DataScansione
	,EtichettaGiornoSettimana
	,DataAperturaSospeso
	,DataInvioComunicazione
	,Ora24
	,TipoIncarico
	,Descrizione
	,CodProfiloAccesso
	,SLA_Sospeso
	,SLA_Sospeso_AperturaSospeso
	,OraSosp
FROM rs.v_CESAM_AZ_SLA_Sospesi_v4
WHERE DataAperturaSospeso >= @DataDal
AND DataAperturaSospeso < @DataAl

INSERT into [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.globale
SELECT
	QTask_idIncarico
	,CAST(ChiaveDataRicezione AS DATETIME) ChiaveDataRicezione
	,ChiaveOraRicezione
	,GiornoSettimana
	,EtichettaGiornoSettimana
	,DataRicezione
	,DataCheckin
	,DataScansione
	,DataTransizione
	,CodTipoIncarico
	,CodStatoWorkflowIncaricoDestinazione
	,CodAttributoIncaricoDestinazione
	,FlagAttesaDestinazione
	,FlagUrgenteDestinazione
	,DescrizioneIncarico
	,DescrizioneMacroStato
	,DescrizioneStato
	,DescrizioneAttributo
	,SLA_Protocollazione
	,SLA_Gestione

FROM rs.v_CESAM_AZ_SLA_Globale_v4
WHERE ChiaveDataRicezione >= --DATEADD(DAY,-7,GETDATE())
@DataDal
AND ChiaveDataRicezione < @DataAl



SELECT * FROM [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.sospesi
WHERE  DataAperturaSospeso >= @DataDal
AND DataAperturaSospeso < @DataAl

SELECT * FROM [BTSQLCL05\BTSQLCL05].scandb_dwh.scratch.globale
WHERE ChiaveDataRicezione >= @DataDal
AND ChiaveDataRicezione < @DataAl

--ROLLBACK TRANSACTION
--COMMIT TRANSACTION


