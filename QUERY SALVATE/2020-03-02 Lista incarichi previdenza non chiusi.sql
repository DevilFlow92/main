
--lista incarichi non ancora chiusi
SELECT DISTINCT
	IdIncarico
	,DataCreazione
	,DataUltimaTransizione
	,TipoIncarico
	,StatoWorkflowIncarico
	,ChiaveClienteIntestatario
	,RagioneSocialeIntestatario
	,CognomeIntestatario
	,NomeIntestatario
	,CodiceFiscaleIntestatario
	,PartitaIvaIntestatario

FROM rs.v_CESAM_AZ_Previdenza_ListaIncarichi
WHERE FlagStopDocumento = 0

AND DataUltimaTransizione >= '2019-12-27 13:00'
AND CodTipoIncarico NOT IN (288, 44, 396)
AND (StatoWorkflowIncarico NOT LIKE 'gestita%'
AND StatoWorkflowIncarico NOT LIKE 'sospesa%')

