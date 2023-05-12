USE clc
GO

--ALTER VIEW rs.v_CESAM_AZ_Previdenza_ListaIncarichi AS 

--;
WITH estrazione AS (

SELECT 
/* DATI INCARICO QTASK */
ti.IdIncarico
,ti.DataCreazione
,ti.DataUltimaTransizione
,ti.CodTipoIncarico
,d.TipoIncarico
,ti.CodStatoWorkflowIncarico
,d.StatoWorkflowIncarico
,ti.CodAttributoIncarico
,d.AttributoIncarico
,IIF(ti.CodAttributoIncarico = 1166,1,0	) FlagStopDocumento --DOCUMENTAZIONE DA NON INVIARE

/* DATI ANAGRAFICA QTASK */
,van.idpersona
,van.ChiaveClienteIntestatario
,van.RagioneSocialeIntestatario
,van.CognomeIntestatario
,van.NomeIntestatario
,van.CodiceFiscaleIntestatario
,van.PartitaIvaIntestatario
,van.CodTipoPersona

/* DATI DOCUMENTO IMBARCATO SU QTASK TRASFERIBILE A PREVINET */
,tdoc.Documento_id
,tdoc.DataInserimento
,tdoc.Tipo_Documento CodTipoDocumento
,tdoc.Nome_file
,ddoc.Descrizione TipoDocumento


/* DATI TRANSCODIFICA */
,ISNULL(zdoc.CodiceTipoDocumentoCliente,
	CASE WHEN LEFT(TabellaExport.nomedocumentopdf,3) = 'INT'
		THEN 'INT'
		ELSE LEFT(TabellaExport.nomedocumentopdf,2)

		END
		) CodiceTipoDocumentoCliente

, IIF( LEFT(TabellaExport.nomedocumentopdf,3) = 'INT', 'INTEGRAZIONE'
	,CASE LEFT(TabellaExport.nomedocumentopdf, 2)
		WHEN 'AN' THEN 'ANTICIPAZIONI'
		WHEN 'CA' THEN 'ANAGRAFICA AZIENDE'
		WHEN 'CB' THEN 'CENSIM. BENEFICIARI'
		WHEN 'CL' THEN 'COLLOCATORI'
		WHEN 'CV' THEN 'CESSIONI V STIPENDIO'
		WHEN 'DC' THEN 'DISTINTA CORRIERE'
		WHEN 'DF' THEN 'DFP ADESIONI'
		WHEN 'DI' THEN 'DISTINTA'
		WHEN 'DP' THEN 'CODICE OASI DP'
		WHEN 'DT' THEN 'DOM. TRASF. AD ALTRO FONDO'
		WHEN 'EC' THEN 'ESTRATTI CONTO'
		WHEN 'GI' THEN 'VARIAZIONI ANAGRAFICHE UNIFICATE'
		WHEN 'IC' THEN 'ISCRIZIONI COLLETTIVE'
		WHEN 'II' THEN 'ISCRIZIONI INDIVIDUALI'
		WHEN 'IT' THEN 'ISCRIZIONI IND. CON TFR'
		WHEN 'LI' THEN 'LETTERE INTEGRAZIONE DATI / SOLLECITO'
		WHEN 'MF' THEN 'SWITCH MOV. FINANZIARI'
		WHEN 'ND' THEN 'CONTRIBUTI NON DEDOTTI'
		WHEN 'PB' THEN 'PREGRESSO BENEFICIARI'
		WHEN 'PE' THEN 'PREGR.ENTRATA'
		WHEN 'PN' THEN 'PREGRESSO NON DEDOTTI'
		WHEN 'PR' THEN 'PRESTAZIONI'
		WHEN 'PU' THEN 'PREGR.USCITA'
		WHEN 'PV' THEN 'PREGRESSO CESSIONI DEL QUINTO'
		WHEN 'R2' THEN 'RISCATTI PARZIALI'
		WHEN 'RD' THEN 'RID (attivazione e revoca)'
		WHEN 'RI' THEN 'RISCATTI TOTALI'
		WHEN 'RN' THEN 'SWITCH UNIFICATO'
		WHEN 'RR' THEN 'RICHIESTA RICEZIONI'
		WHEN 'RZ' THEN 'RICEZ. ALTRO FONDO'
		WHEN 'SW' THEN 'SWITCH'
		WHEN 'TI' THEN 'UNIFICAZIONE POSIZIONI (TRASFERIMENTO INTERNO)'
		WHEN 'V1' THEN 'ANNULLAMENTI ADESIONE'
		WHEN 'VA' THEN 'VARIAZIONI ANAGRAFICHE'
		WHEN 'VD' THEN 'VARIAZIONI ADESIONE'
		WHEN 'VZ' THEN 'VARIAZIONI ISCRITTO'
		WHEN 'ZA' THEN 'BPER - AN - ANTICIPAZIONI PREGRESSE'
		WHEN 'ZI' THEN 'BPER -  ADESIONI E VARIAZIONI'
		WHEN 'ZR' THEN 'BPER - RZ - RICEZIONI ALTRO FONDO'
		WHEN 'ZV' THEN 'BPER - CESSIONI DEL QUINTO PREGRESSE'
		WHEN 'ZZ' THEN 'PREGRESSO RZ ARCA'
		WHEN 'TF' THEN 'TRASFERIMENTI OUT'

		ELSE 'ND'	
	END 
	) AS DescrizioneDocICBPI

/* DATI EXPORT VS PREVINET */
,TabellaExport.documento_id IdDocumentoTrasferito
	,TabellaExport.chiavecliente
	,TabellaExport.nomefile_input
	,TabellaExport.idrepository
	,TabellaExport.percorsocompleto
	,TabellaExport.NamingCartellaZip
	,TabellaExport.ProgressivoZip
	,TabellaExport.nomedocumentopdf
	,TabellaExport.StringaCSV
	,TabellaExport.FlagUpload
	,TabellaExport.DataUpload
	--,TabellaExport.DescrizioneKO

	,(select value from rs.Split(TabellaExport.StringaCSV,';')
		WHERE Id = 1) ProtocolloVSPrevinet
	
FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico
AND (
	( ti.CodTipoIncarico = 173 AND van.codruolorichiedente <> 194)
  OR (ti.CodTipoIncarico <> 173 AND van.ProgressivoPersona = 1)
  )

JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico
AND tdoc.FlagPresenzaInFileSystem = 1
AND tdoc.FlagScaduto = 0
JOIN D_Documento ddoc ON Tipo_Documento = ddoc.Codice

LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI TabellaExport ON ti.IdIncarico = TabellaExport.idincarico
AND tdoc.Documento_id = TabellaExport.documento_id

JOIN export.Z_Cliente_TipoIncarico_TipoDocumento zdoc ON ti.CodCliente = zdoc.CodCliente
AND ti.CodTipoIncarico = zdoc.CodTipoIncarico
AND tdoc.Tipo_Documento = zdoc.CodTipoDocumento

WHERE ti.CodArea = 8
AND ti.CodCliente = 23

AND ti.CodTipoIncarico IN (
173		--Disinvestimenti Previdenza
,572	--Sottoscrizioni Previdenza - Zenith
,175	--Successioni - Previdenza
,178	--Varie Previdenza
,57		--Gestione SEPA
,167	--Sottoscrizioni Previdenza
,102	--Switch Previdenza

--,44		--Variazione Anagrafica
--,288	--Censimento Cliente
--,396	--OnBoarding Digitale

)
AND ti.DataCreazione >= '2019-01-01'
--AND van.idpersona = 4024736

)
, docID AS (
SELECT v.Documento_id, v.IdPersona
 FROM rs.v_CESAM_AZ_Documento_Identita_Recente v
JOIN  estrazione e on v.IdPersona = e.idpersona
--WHERE v.Tipo_Documento <> 7348
--GROUP BY v.IdPersona
)

,DocIdentita as (

SELECT DISTINCT	
	tiDocID.IdIncarico
	,tiDocID.DataCreazione
	,tiDocID.DataUltimaTransizione
	,tiDocID.CodTipoIncarico
	,descrizioni.TipoIncarico
	,tiDocID.CodStatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico
	,tiDocID.CodAttributoIncarico
	,descrizioni.AttributoIncarico
	,0 FlagStopDocumento

	,van.idpersona
	,van.ChiaveClienteIntestatario
	,van.RagioneSocialeIntestatario
	,van.CognomeIntestatario
	,van.NomeIntestatario
	,van.CodiceFiscaleIntestatario
	,van.PartitaIvaIntestatario
	,van.CodTipoPersona

	,T_Documento.Documento_id
	,T_Documento.DataInserimento
	,T_Documento.Tipo_Documento CodTipoDocumento
	,T_Documento.Nome_file
	,D_Documento.Descrizione TipoDocumento

	,'ac' CodiceTipoDocumentoCliente
	,'DOCUMENTAZIONE ANAGARAFICA ACCORPATA' AS DescrizioneDocICBP
	,previnetDocID.documento_id IdDocumentoTrasferito
	,previnetDocID.chiavecliente
	,previnetDocID.nomefile_input
	,previnetDocID.idrepository
	,previnetDocID.percorsocompleto
	,previnetDocID.NamingCartellaZip
	,previnetDocID.ProgressivoZip
	,previnetDocID.nomedocumentopdf
	,previnetDocID.StringaCSV
	,previnetDocID.FlagUpload
	,previnetDocID.DataUpload
	,(select value from rs.Split(previnetDocID.StringaCSV,';')
		WHERE Id = 1) ProtocolloVSPrevinet
	
FROM  docID
JOIN T_Documento
	ON DocID.Documento_id = T_Documento.Documento_id
JOIN T_Incarico tiDocID
	ON T_Documento.IdIncarico = tiDocID.IdIncarico

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON tiDocID.IdIncarico = descrizioni.IdIncarico

JOIN D_Documento
	ON Codice = T_Documento.Tipo_Documento

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON tiDocID.IdIncarico = van.IdIncarico
AND (
	( tiDocID.CodTipoIncarico = 173 AND van.codruolorichiedente <> 194)
  OR (tiDocID.CodTipoIncarico <> 173 AND van.ProgressivoPersona = 1)
  )


LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI previnetDocID
	ON T_Documento.Documento_id = previnetDocID.documento_id
	AND tiDocID.IdIncarico = previnetDocID.idincarico


	--WHERE tiDocID.IdIncarico = 14141200
)

SELECT 	*	FROM estrazione 
UNION ALL 
SELECT * FROM DocIdentita


GO


