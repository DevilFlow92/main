USE CLC
GO

SELECT 	v.IdIncarico
		,v.DataCreazione
		,v.DataUltimaTransizione
		,v.DataInserimento
		,v.CodTipoIncarico
		,v.TipoIncarico
		,v.CodStatoWorkflowIncarico
		,v.StatoWorkflowIncarico
		,v.CodAttributoIncarico
		,v.AttributoIncarico
		--,v.FlagStopDocumento

		,codtipopersona
		,v.ChiaveClienteIntestatario
		,IIF(v.CognomeIntestatario is NULL OR v.CognomeIntestatario = '',v.RagioneSocialeIntestatario,v.CognomeIntestatario)
			+ ' ' + ISNULL(v.NomeIntestatario,'') Intestatario
		,v.CodiceFiscaleIntestatario
		,v.PartitaIvaIntestatario

		,v.Documento_id
		
		,v.CodTipoDocumento
		,v.TipoDocumento
		,v.CodiceTipoDocumentoCliente
		
FROM rs.v_CESAM_AZ_Previdenza_ListaIncarichi v
LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI flussoPrevinet ON v.Documento_id = flussoPrevinet.documento_id
LEFT JOIN rs.v_CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI CodaFlussoPrevinet ON v.Documento_id = CodaFlussoPrevinet.documento_id
WHERE v.DataCreazione >= '2019-12-27 13:00' AND
DataUltimaTransizione >= '2019-12-27 13:00'
AND CodStatoWorkflowIncarico = 820
AND FlagStopDocumento = 0
AND flussoPrevinet.documento_id is NULL
AND CodaFlussoPrevinet.documento_id is NULL
--AND v.documento_id = 86161368

--AND v.IdIncarico = 14064567 
--AND v.DataUltimaTransizione >= '2020-02-05'

--brnmhl85l19a944f

ORDER BY v.IdIncarico

--SELECT * FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI where idincarico = 14238430


----INSERT into export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI

--SELECT MAX(ProgressivoZip) FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI

--SELECT
--	documento_id
--	,idincarico
--	,chiavecliente
--	,codtipoincarico
--	,descrizioneincarico
--	,tipo_documento
--	,nomefile_input
--	,idrepository
--	,percorsocompleto
--	,NamingCartellaZip
--	,ProgressivoZip 
--	,nomedocumentopdf
--	,StringaCSV
--	,FlagUpload
--	,DataUpload
--	,DescrizioneKO
--FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
--WHERE idincarico IN (
--13924765
--, 13924771
--, 13968608
--, 13968613
--, 13972009
--, 13987574
--, 13989898
--, 13994024
--)