USE CLC
GO

/*
Author: Andrea Padricelli

utilizzata nella procedura di trasferimento verso DocBank

*/

--ALTER PROCEDURE export.CESAM_CB_DocBank_CreateXml_Attachments (@folder VARCHAR(8000)) AS 

--DECLARE @folder VARCHAR(8000) = --'20200304016_AssetMol'
--'20200304015_AssetMOL'


IF OBJECT_ID(N'tempdb..#temprkey', N'U') IS NOT NULL 
    DROP TABLE #temprkey;

CREATE TABLE #temprkey
(doctype VARCHAR(50),
[keyOld] varchar(50),
[key] varchar(50)
)
--key old = nome colonna mia tabella, key = nome colonna atteso da docbank
INSERT into #temprkey (doctype, keyOld, [key])
SELECT 'IDNCRT','NDG','ndg' UNION ALL
SELECT 'IDNCRT','DataDocumento','date' UNION ALL
SELECT 'IDNCRT','NumeroDocumento','referenceCode' UNION ALL
SELECT 'IDNCFS','NDG','ndg' UNION ALL
SELECT 'IDNCFS','DataDocumento','date' UNION ALL
SELECT 'IDNCFS','CodiceFiscale','referenceCode' UNION ALL


/*nuovi documenti Informativa sulle principali regole di comportamento - Dichiarazione di primo contatto */
SELECT 'CFD1','NDG','ndg' UNION ALL
SELECT 'CFD2','NDG','ndg' UNION ALL
select 'CFD1','PosizioneArchivio', 'location' UNION ALL
select 'CFD2','PosizioneArchivio', 'location' UNION ALL

/*nuovi documenti d'identita*/
SELECT 'IDNADV','NDG','ndg' UNION ALL
SELECT 'IDNADV','DataDocumento','date' UNION ALL
SELECT 'IDNADV','NumeroDocumento','referenceCode' UNION ALL
select 'IDNADV','PosizioneArchivio', 'location' UNION ALL
--
SELECT 'IDNARM','NDG','ndg' UNION ALL
SELECT 'IDNARM','DataDocumento','date' UNION ALL
SELECT 'IDNARM','NumeroDocumento','referenceCode' UNION ALL
select 'IDNARM','PosizioneArchivio', 'location' UNION ALL
--
SELECT 'IDNFIR','NDG','ndg' UNION ALL
SELECT 'IDNFIR','DataDocumento','date' UNION ALL
SELECT 'IDNFIR','NumeroDocumento','referenceCode' UNION ALL
select 'IDNFIR','PosizioneArchivio', 'location' UNION ALL

--
SELECT 'IDNPAS','NDG','ndg' UNION ALL
SELECT 'IDNPAS','DataDocumento','date' UNION ALL
SELECT 'IDNPAS','NumeroDocumento','referenceCode' UNION ALL
select 'IDNPAS','PosizioneArchivio', 'location' UNION ALL
--
SELECT 'IDNPAT','NDG','ndg' UNION ALL
SELECT 'IDNPAT','DataDocumento','date' UNION ALL
SELECT 'IDNPAT','NumeroDocumento','referenceCode' UNION ALL
select 'IDNPAT','PosizioneArchivio', 'location' UNION ALL
--
SELECT 'IDNPEN','NDG','ndg' UNION ALL
SELECT 'IDNPEN','DataDocumento','date' UNION ALL
SELECT 'IDNPEN','NumeroDocumento','referenceCode' UNION ALL
select 'IDNPEN','PosizioneArchivio', 'location' UNION ALL
--
SELECT 'IDNTES','NDG','ndg' UNION ALL
SELECT 'IDNTES','DataDocumento','date' UNION ALL
SELECT 'IDNTES','NumeroDocumento','referenceCode' UNION ALL
select 'IDNTES','PosizioneArchivio', 'location' UNION ALL
/*nuovi documenti d'identita*/

SELECT 'PRDCNT','NumeroRapporto','dossier' UNION ALL
SELECT 'PRDCNT','Operation','operation' UNION ALL

/* contratti rischedulati una tantum 2020-03-04 */
SELECT 'PRDCNT_NG','NumeroRapporto','dossier' UNION ALL
SELECT 'PRDCNT_NG','Operation','operation' UNION ALL

SELECT 'PRDCNT_DDS','NumeroRapporto','dossier' UNION ALL
SELECT 'PRDCNT_DDS','Operation','operation' UNION ALL
SELECT 'PRDCNT_INT','NumeroRapporto','dossier' UNION ALL
SELECT 'PRDCNT_INT','Operation','operation' UNION ALL
SELECT 'PRDCNT_INT','idPraticaDocBank','referenceCode' UNION ALL
SELECT 'PRDCNT_INTDDS','NumeroRapporto','dossier' UNION ALL
SELECT 'PRDCNT_INTDDS','Operation','operation' UNION ALL
SELECT 'PRDCNT_INTDDS','idPraticaDocBank','referenceCode' UNION ALL

SELECT 'Attestato','NumeroRapporto','dossier' UNION ALL
SELECT 'Attestato','Operation','operation' UNION ALL
select 'Attestato', 'idPraticaDocBank', 'referenceCode' UNION ALL

SELECT 'MTSPNF','NumeroRapporto','dossier' UNION ALL
SELECT 'MTSPNF','Operation','operation' UNION ALL
SELECT 'MTSPNF','idPraticaDocBank','referenceCode' UNION ALL
SELECT 'AUTCOMNF','NumeroRapporto','dossier' UNION ALL
SELECT 'AUTCOMNF','Operation','operation' UNION ALL
SELECT 'AUTCOMNF','idPraticaDocBank','referenceCode' UNION ALL
SELECT 'IDNFIR','NDG','ndg' UNION ALL
SELECT 'IDNFIR','DataDocumento','date' UNION ALL
SELECT 'TRASTIT','NumeroRapporto','dossier' UNION ALL
SELECT 'TRASTIT','Operation','operation' UNION ALL
SELECT 'TRASTIT','idPraticaDocBank','referenceCode' UNION ALL
SELECT 'WEBCOLL','NDG','ndg' UNION ALL
SELECT 'WEBCOLL','idPraticaDocBank','reference_cod' UNION ALL
SELECT 'DISP065','NDG','ndg' UNION ALL
--carta di credito
select 'RECAREST', 'NumeroRapporto', 'dossier' UNION ALL
select 'RECAREST', 'Operation', 'operation' UNION ALL
select 'RECAREST', 'idPraticaDocBank', 'referenceCode' UNION ALL

select 'PRDCNT_INTDDS','NumeroRapporto', 'dossier' UNION ALL
select 'PRDCNT_INTDDS','Operation', 'operation' UNION ALL
select 'PRDCNT_INTDDS', 'idPraticaDocBank', 'referenceCode' UNION ALL

select 'PRDCNT_INTOP','NumeroRapporto', 'dossier' UNION ALL
select 'PRDCNT_INTOP','Operation', 'operation' UNION ALL
select 'PRDCNT_INTOP','idPraticaDocBank', 'referenceCode' UNION ALL

select 'PRDCNT_INT_KK','NumeroRapporto', 'dossier' UNION ALL
select 'PRDCNT_INT_KK',  'Operation', 'operation' UNION ALL
select 'PRDCNT_INT_KK','idPraticaDocBank', 'referenceCode' UNION ALL


--location
select 'AUTCOMNF', 'PosizioneArchivio', 'location' union all
select 'DISP065', 'PosizioneArchivio', 'location' union all
select 'IDNFIR', 'PosizioneArchivio', 'location' union ALL 
select 'IDNCFS', 'PosizioneArchivio', 'location' union all
select 'IDNCRT', 'PosizioneArchivio', 'location' union all
select 'MTSPNF', 'PosizioneArchivio', 'location' union all
select 'PRDCNT', 'PosizioneArchivio', 'location' union ALL

/* contratti rischedulati una tantum 2020-03-04 */
select 'PRDCNT_NG', 'PosizioneArchivio', 'location' union all

select 'PRDCNT_DDS', 'PosizioneArchivio', 'location' union all
select 'PRDCNT_INT', 'PosizioneArchivio', 'location' union all
select 'PRDCNT_INTDDS', 'PosizioneArchivio', 'location' union all
select 'TRASTIT', 'PosizioneArchivio', 'location' union all
select 'WEBCOLL', 'PosizioneArchivio', 'location' UNION ALL
select 'RECAREST', 'PosizioneArchivio', 'location' UNION ALL
select 'PRDCNT_INTDDS','PosizioneArchivio', 'location' UNION ALL
select 'PRDCNT_INTOP','PosizioneArchivio', 'location' UNION ALL
select 'PRDCNT_INT_KK','PosizioneArchivio', 'location' UNION ALL
select 'Attestato','PosizioneArchivio', 'location' 


/* CODICI ANOMALIA 25/03/2020*/
UNION all
SELECT 'IDNCFS'		   ,'CodAnomalia', 'msgInvalid' union all
SELECT 'IDNCRT'		   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'IDNPAT'		   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'IDNPAS'		   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'IDNFIR'		   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'IDNFIR'		   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'PRDCNT'		   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'PRDCNT_INT'	   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'PRDCNT_INT'	   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'PRDCNT_INT'	   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'PRDCNT_INT'	   ,'CodAnomalia', 'msgInvalid'	union all
SELECT 'PRDCNT_INT_KK' ,'CodAnomalia', 'msgInvalid'


IF OBJECT_ID(N'tempdb..#templog', N'U') IS NOT NULL 
    DROP TABLE #templog;

CREATE TABLE #templog
(id VARCHAR(3),
contentPath varchar(50),
doctype VARCHAR(50),
[key] varchar(50),
value varchar(50))


INSERT INTO #templog (id, contentPath, doctype, [key], value)
SELECT 
RIGHT(ProgressivoDocumento,3) AS id,
		contentPath+'.pdf' AS contentPath,
		doctype,
		[key],
		value
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
UNPIVOT (
	value FOR [key] IN (ndg , numerodocumento,DataDocumento,codicefiscale,numerorapporto,operation,idpraticadocbank,PosizioneArchivio ,CodAnomalia)
) unpvt

WHERE FlagUpload = 0 --AND 
--NamingCartellaZip = @folder

--and ProgressivoDocumento = '000037'


DECLARE @xml AS XML
SET @xml = (
SELECT id AS [@id],
		t.contentPath,
		t.doctype,
		(
		SELECT 
		#temprkey.[key],
		ti.value
		FROM #templog ti
		JOIN #temprkey ON #temprkey.doctype = ti.doctype AND ti.[key] = #temprkey.keyOld
		WHERE ti.contentPath = t.contentPath
		GROUP BY 	#temprkey.[key],
		ti.value, ti.contentPath
		FOR XML PATH ('item'),TYPE
		) 

 FROM #templog t
JOIN #temprkey ON #temprkey.doctype = t.doctype AND t.[key] = #temprkey.keyOld
--WHERE t.contentPath = 'AM_8722287_000001.pdf'
GROUP BY id,
		t.contentPath,
		t.doctype
FOR XML PATH ('attachment'),ROOT ('attachments')
)


SELECT @xml AS XmlRec

GO