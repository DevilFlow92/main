--85849374

BEGIN TRANSACTION
IF OBJECT_ID('tempdb.dbo.#tmpPREVINET') IS NOT NULL
	DROP TABLE #tmpPREVINET

SELECT documento_id,
 CAST(idincarico AS VARCHAR(20)) + '_' + CAST(COUNT(documento_id) AS VARCHAR(2)) ChiaveCESAM
,'AZI' + '_' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8) as NuovaCartella
,(SELECT MAX(ProgressivoZip)+1 FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI) NuovoZIP
,LEFT(nomedocumentopdf,2) CodDocumentoICBPI
,SUBSTRING(nomedocumentopdf,4,16) CodiceFiscale

,Nome
,Cognome
INTO #tmpPrevinet
FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
JOIN T_Persona ON export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.chiavecliente = T_Persona.ChiaveCliente
WHERE documento_id = 84907580
GROUP BY documento_id
,idincarico
,LEFT(nomedocumentopdf,2) 
,SUBSTRING(nomedocumentopdf,4,16)
,Nome
,Cognome


--INSERT into export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI (documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, NamingCartellaZip, ProgressivoZip, nomedocumentopdf, StringaCSV, FlagUpload)

SELECT DISTINCT
#tmpPrevinet.documento_id
, idincarico
, chiavecliente
, codtipoincarico
, descrizioneincarico,tipo_documento
,nomefile_input
, idrepository
, percorsocompleto
,'AZI' + '_' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8) as NamingCartellaZip
,NuovoZIP
,CodDocumentoICBPI+'_'+CodiceFiscale+'_'+ChiaveCESAM AS NomeDocumentoPDF

,ChiaveCESAM +';'+ CAST(NuovoZIP as VARCHAR(10)) +';'+CodDocumentoICBPI + ';AZI;'+CodDocumentoICBPI+'_'+CodiceFiscale+'_'+ ChiaveCESAM+'.pdf;' + Nome +';'+ Cognome +';' + codicefiscale  StringaCSV
 ,0 FlagUpload


 --,CodiceFiscale
 --,CodDocumentoICBPI

 FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI icbpi
 JOIN #tmpPrevinet ON icbpi.documento_id = #tmpPrevinet.documento_id

 

 DROP TABLE #tmpPrevinet

--ROLLBACK TRANSACTION
--COMMIT TRANSACTION

--SELECT * FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI where idincarico = 13739707

--SELECT * FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI where FlagUpload = 0