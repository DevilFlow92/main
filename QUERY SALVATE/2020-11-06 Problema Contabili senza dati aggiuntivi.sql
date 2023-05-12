--SELECT IdImport_RendicontazioneBP, NumeroConto_61, ABI_61, CAB_61, DataImport, RiferimentoCliente_62
--FROM scratch.L_Import_Rendicontazione_FlussoCBI
--WHERE DataImport >= '20201020' AND DataImport < '20201027'
--AND RiferimentoBanca_62 IN ('IT2029021875OMTS', 'IT2029616417OMTS','IT2029707827OMTS')


--SELECT * FROM scratch.T_R_ImportRendicontazione_Movimento
--WHERE IdImport_Rendicontazione IN( 4101577
--,4111855
--)

--SELECT * FROM T_ContoBancario
--WHERE NumeroConto = '802260103'

--SELECT * FROM T_ContoBancario

SELECT * FROM T_ContoBancarioPerAnno
WHERE IdContoBancarioPerAnno = 203271

SELECT scratch.L_Import_Rendicontazione_FlussoCBI.*
FROM scratch.L_Import_Rendicontazione_FlussoCBI
LEFT JOIN scratch.T_R_ImportRendicontazione_Movimento ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
LEFT JOIN scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi ON Chiave_62 = Chiave_62_DA
WHERE NumeroConto_61 IN (

'000802240901'	--AZIMUT CAP. MANAG. SGR	Conto SIA/SISTEMA FORMULA 1	AZCM SIA/SIST FORM1
,'000802260103'	--AZ FUND 1	Conto Sottoscrizioni	AZCM/AZ FUND1 SOTT
,'000802260302'	--AZ Multi Asset	Conto Sottoscrizioni	AZCM/AZ MULTI AS SOT
,'000801241000'	--AZIMUT DINAMICO	Conto Afflusso	AZIMUT DINAMICO AF
,'000801241100'	--AZIMUT TREND   	Conto Afflusso	AZIMUT TREND AF
,'000801241200'	--AZIMUT SOLIDITY 	Conto Afflusso	AZIMUT SOLIDITY AF
,'000801241300'	--AZIMUT TREND ITALIA              	Conto Afflusso	AZIMUT TREND ITA AF
,'000801241400'	--AZIMUT TREND TASSI               	Conto Afflusso	AZIMUT TREND TASSI
,'000801241500'	--AZIMUT SCUDO         	Conto Afflusso	AZIMUT SCUDO AF
,'000801241600'	--AZIMUT TREND EUROPA              	Conto Afflusso	AZIMUT TREND EUR AF
,'000801241700'	--AZIMUT TREND AMERICA             	Conto Afflusso	AZIMUT TREND AMER AF
,'000801241800'	--AZIMUT  ITALIA ALTO POTENZIALE	Conto Afflusso	AZIMUT ITA. ALTO POTENZ.AF
,'000801241900'	--AZIMUT TARGET 2017 		AZIMUT TAR21 E.OP AF
,'000801242000'	--FORMULA 1 ABSOLUTE 	Conto Afflusso	AZIMUT FOR1 ABSOL AF
,'000801242100'	--AZIMUT REDDITO USA 	Conto Afflusso	AZIMUT RED USA AF
,'000801242200'	--AZIMUT STRATEGIC TREND           	Conto Afflusso	AZIMUT STRA TREND AF
,'000802258100'	--Azimut   Azimut Previdenza	conto afflusso	AZIMUT PREV/ AFFLUS 
  

)
--AND scratch.L_Import_Rendicontazione_FlussoCBI.DataImport >= '20201001' AND L_Import_Rendicontazione_FlussoCBI.DataImport < '20201101'
AND L_Import_Rendicontazione_FlussoCBI.DataImport >= CONVERT(DATE,getdate())
AND Id_Import_RendicontazioneBP_DatiAggiuntivi IS NULL
AND idrelazione IS NULL
--AND IdImport_RendicontazioneBP = 4101577


SELECT  FROM T_MovimentoContoBancario