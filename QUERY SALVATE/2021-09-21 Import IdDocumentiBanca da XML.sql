USE CLC
GO

DECLARE @idincaricocreato INT = 19071914 

DECLARE @xmlString AS XML = 
/*** INSERIRE CONTENUTO XML DELLA BANCA TRA GLI APICI ****/

'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<attachments>
    <attachment id="001">
        <contentPath>402677092_IDNCRT_P1.jpg</contentPath>
        <docType>IDNCRT</docType>
        <page>1</page>
        <items>
            <key>NDG</key>
            <value>402677092</value>
        </items>
        <items>
            <key>NOME</key>
            <value>MICHELE</value>
        </items>
        <items>
            <key>COGNOME</key>
            <value>DEL DOTTO</value>
        </items>
        <items>
            <key>DOSSIER_ID</key>
            <value>06100572287507</value>
        </items>
        <items>
            <key>ID_DOCUMENTO</key>
            <value>15bd66e3-323b-4c6f-ae92-cd42f25d724a</value>
        </items>
    </attachment>
    <attachment id="002">
        <contentPath>402677092_IDNCRT_P2.jpg</contentPath>
        <docType>IDNCRT</docType>
        <page>2</page>
        <items>
            <key>NDG</key>
            <value>402677092</value>
        </items>
        <items>
            <key>NOME</key>
            <value>MICHELE</value>
        </items>
        <items>
            <key>COGNOME</key>
            <value>DEL DOTTO</value>
        </items>
        <items>
            <key>DOSSIER_ID</key>
            <value>06100572287507</value>
        </items>
        <items>
            <key>ID_DOCUMENTO</key>
            <value>995c6282-3f9d-4d53-a2a6-5453638a066b</value>
        </items>
    </attachment>
    <attachment id="003">
        <contentPath>402677092_IDNCFS_P1.jpg</contentPath>
        <docType>IDNCFS</docType>
        <page>1</page>
        <items>
            <key>NDG</key>
            <value>402677092</value>
        </items>
        <items>
            <key>NOME</key>
            <value>MICHELE</value>
        </items>
        <items>
            <key>COGNOME</key>
            <value>DEL DOTTO</value>
        </items>
        <items>
            <key>DOSSIER_ID</key>
            <value>06100572287507</value>
        </items>
        <items>
            <key>ID_DOCUMENTO</key>
            <value>beef89e1-0ff8-41b2-8657-040894516082</value>
        </items>
    </attachment>
    <attachment id="004">
        <contentPath>402677092_IDNCFS_P2.jpg</contentPath>
        <docType>IDNCFS</docType>
        <page>2</page>
        <items>
            <key>NDG</key>
            <value>402677092</value>
        </items>
        <items>
            <key>NOME</key>
            <value>MICHELE</value>
        </items>
        <items>
            <key>COGNOME</key>
            <value>DEL DOTTO</value>
        </items>
        <items>
            <key>DOSSIER_ID</key>
            <value>06100572287507</value>
        </items>
        <items>
            <key>ID_DOCUMENTO</key>
            <value>283d003b-17aa-42f0-8d82-36bd2965f30c</value>
        </items>
    </attachment>
    <attachment id="005">
        <contentPath>402677092_IDNFIR_P1.pdf</contentPath>
        <docType>IDNFIR</docType>
        <page>1</page>
        <items>
            <key>NDG</key>
            <value>402677092</value>
        </items>
        <items>
            <key>NOME</key>
            <value>MICHELE</value>
        </items>
        <items>
            <key>COGNOME</key>
            <value>DEL DOTTO</value>
        </items>
        <items>
            <key>DOSSIER_ID</key>
            <value>06100572287507</value>
        </items>
        <items>
            <key>ID_DOCUMENTO</key>
            <value>e4bba706-374f-43b2-8bd4-055bc0ca8c39</value>
        </items>
    </attachment>
    <attachment id="006">
        <contentPath>402677092_CFD2_P1.pdf</contentPath>
        <docType>CFD2</docType>
        <page>1</page>
        <items>
            <key>NDG</key>
            <value>402677092</value>
        </items>
        <items>
            <key>NOME</key>
            <value>MICHELE</value>
        </items>
        <items>
            <key>COGNOME</key>
            <value>DEL DOTTO</value>
        </items>
        <items>
            <key>DOSSIER_ID</key>
            <value>06100572287507</value>
        </items>
        <items>
            <key>ID_DOCUMENTO</key>
            <value>ba7c0eb3-3418-4e84-ab89-6c4dd5cccdea</value>
        </items>
    </attachment>
</attachments>
'

SET @xmlString = CAST(REPLACE(CAST(@xmlString AS NVARCHAR(MAX)), '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>', '') AS XML)

DECLARE @hDoc AS INT
,@SQL NVARCHAR(MAX)

IF OBJECT_ID('tempdb.dbo.#tmpXMLCheBanca') IS NOT NULL
begin	
	DROP TABLE #tmpXMLCheBanca
end




EXEC sp_xml_preparedocument @hDoc OUTPUT,@xmlString

SELECT *
INTO #tmpXMLCheBanca
FROM OPENXML(@hDoc,'attachments/attachment')
WITH (
AttachmentID VARCHAR(3) '@id'
,ContentPath VARCHAR(100) 'contentPath'
,docType VARCHAR(100) 'docType'
,page smallint 'page'
,NDG VARCHAR(10) 'items[1]/value'
,nome VARCHAR(100) 'items[2]/value'
,cognome VARCHAR(100) 'items[3]/value'
,DOSSIER_ID VARCHAR(50) 'items[4]/value'
,ID_DOCUMENTO VARCHAR(100) 'items[5]/value'
)

EXEC sp_xml_removedocument @hDoc

--INSERT INTO T_FileOriginaleSistemaEsterno (CodSistemaEsterno, IdDocumento, ChiaveEsterna, NomeFileOriginale, NomeFileZip, DataGenerazioneFile)
SELECT 18, Documento_id, ID_DOCUMENTO,contentpath , '20210921_402498001_06100572287507.zip','20210921 18:00' 

FROM T_Documento
--JOIN D_Documento ON T_Documento.Tipo_Documento = D_Documento.Codice
JOIN #tmpXMLCheBanca ON ndg + '_' + doctype = Note
WHERE IdIncarico = @idincaricocreato 

DROP TABLE #tmpXMLCheBanca

