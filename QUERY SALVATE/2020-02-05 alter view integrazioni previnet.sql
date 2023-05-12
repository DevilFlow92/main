USE CLC
GO

/*Author: A. Padricelli 
	Date: 06/12/2016
	Description: utilizzata dalla tabella di spooling [export].[CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI] 
											dalla SP [export].[CESAM_AZ_Documenti_ICBPI] 
											e dal task per il trasferimento giornaliero documenti ICBPI fondi pensione (G.Salvo)

*/
	
	--SELECT * FROM rs.v_CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI where idincarico = 13109465


--ALTER VIEW rs.v_CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI AS


--ESTRAE I DOCUMENTI CARICATI SUGLI INCARICHI: 	

--SELECT * FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI where idincarico = 10127242

WITH inviati AS (
SELECT idincarico, ProgressivoZip, RowNum = ROW_NUMBER() OVER (PARTITION BY idincarico ORDER BY  ProgressivoZip)

FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI 
WHERE DataUpload >= '2019-12-27 13:00:01'

GROUP BY idincarico,ProgressivoZip	

					)

 ,sel as(
			select T_Documento.Documento_id documento_id, T_Documento.Tipo_Documento, T_Incarico.IdIncarico from T_Documento
			join T_Incarico on T_Documento.IdIncarico = T_Incarico.IdIncarico
			LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI ON dbo.T_Documento.Documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
			AND T_Incarico.IdIncarico = export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.idincarico
			where 
			T_Incarico.CodCliente = 23 
				and T_Incarico.CodTipoIncarico in (
				95	--Rimborso Fondi Pensione
				,173 --Disinvestimenti Previdenza
				,99,167	--Sottoscrizioni/Versamenti Fondi Pensione --> cambiare con azimut previdenza
				,102	--Switch Fondi Pensione
				,178	--Varie Fondo Pensione
				,57 --gestione SEPA 
				,572	--Sottoscrizioni Previdenza - Zenith
				--,573	--Versamenti Aggiuntivi Previdenza - Zenith

				)

				AND CodArea=8
				AND CodStatoWorkflowIncarico = 820
				and (CodAttributoIncarico IS NULL OR CodAttributoIncarico <> 1166)
				and T_Incarico.DataUltimaTransizione <=  cast(cast(getdate() as varchar(12)) as datetime)+1
				and T_Incarico.DataUltimaTransizione >=  cast(cast(getdate() as varchar(12)) as datetime)-6
				AND Nome_file like '%.pdf%'
				and FlagPresenzaInFileSystem = 1
				AND FlagScaduto = 0
				AND DataInserimento <= DataUltimaTransizione	--Viene imbarcato solo il documento che sale prima della chiusura dell'incarico
				AND export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id IS NULL
				--group by T_Documento.Tipo_Documento, T_Incarico.IdIncarico

--				AND T_Incarico.IdIncarico IN ( 14073599,
--14105150 )
				



			UNION ALL

			select T_Documento.documento_id, T_Documento.Tipo_Documento, T_Incarico.IdIncarico from T_Documento
			join T_Incarico WITH (nolock) on T_Documento.IdIncarico = T_Incarico.IdIncarico
			LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI ON dbo.T_Documento.Documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
			
			where 
			T_Incarico.CodCliente = 23 
				and T_Incarico.CodTipoIncarico = 175	--Successioni - Fondo Pensione

				AND CodArea=8
				AND CodStatoWorkflowIncarico = 820
				and (CodAttributoIncarico IS NULL OR CodAttributoIncarico <> 1166)
				and T_Incarico.DataUltimaTransizione <=  cast(cast(getdate() as varchar(12)) as datetime)+1
				and T_Incarico.DataUltimaTransizione >=  cast(cast(getdate() as varchar(12)) as datetime)-6
				AND Nome_file like '%.pdf%'
				and FlagPresenzaInFileSystem = 1
				AND FlagScaduto = 0	
				AND export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id IS NULL
		
						or (codarea = 8 
						and T_Incarico.codtipoincarico = 175 
						and T_Documento.Tipo_Documento = 594 --certificato di morte 
						and CodStatoWorkflowIncarico = 6509 --Verifica Disposizione 
						AND Nome_file like '%.pdf%'
						and FlagPresenzaInFileSystem = 1
						AND FlagScaduto = 0
						AND DataInserimento <= DataUltimaTransizione --Viene imbarcato solo il documento che sale prima della chiusura dell'incarico
						AND export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id IS NULL
						) --il certificato di morte viene inviato all'apertura della pratica
		
		
 
)

,estrazione as (

SELECT       
		T_Incarico.IdIncarico,
		isnull(T_R_Incarico_Persona.idpersona, T_R_Dossier_Persona.IdPersona) as idpersona,
		CASE WHEN UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') )))) 
			LIKE 'P-%' 
			--THEN '000000000'
			THEN  CAST(LEFT(ISNULL(Cliente.IdPersona,ClienteD.IdPersona),9) AS VARCHAR(9))
			ELSE UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') ))))
			END as ChiaveCliente,
		T_Incarico.CodTipoIncarico, 
		D_TipoIncarico.Descrizione as DescrizioneIncarico,
		T_documento.Documento_id,
		T_documento.Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		T_documento.Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto,
		CONVERT(char(10),[DataInserimento],121) as DataInserimento,

		
--INDICAZIONI FILE CSV
		--chiaveunivocaCESAM, ovvero idincarico
		IIF(inviati.idincarico is NULL, CAST(T_Incarico.IdIncarico AS VARCHAR(20)),CAST(T_Incarico.IdIncarico as VARCHAR(20)) + '_'+CAST(inviati.RowNum as varchar(5))) as chiaveunivocaCESAM,
		--datainvioflusso
		convert(char (10),getdate(), 112) as DataInvio
		
		--codicedocumento ICBPI
		,ISNULL(export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceTipoDocumentoCliente, 'ko') as  CodDocumentoICBPI
		
		--codice fondo, sempre AZI
		,'AZI' as CodiceFondo
		
		--nomedocumentopdf
		,
		ISNULL(export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceTipoDocumentoCliente, 'ko')
		+ '_' 
		+ IIF(ISNULL(Cliente.CodTipoPersona,ClienteD.CodTipoPersona) = 2
			,CASE WHEN ISNULL(Cliente.CodiceFiscale,ClienteD.CodiceFiscale) IS NULL
				THEN 'NDNDNDNDNDNDNDND'
			  ELSE CAST(ISNULL(Cliente.CodiceFiscale,ClienteD.CodiceFiscale) AS VARCHAR(MAX))
				END
			,	
		
		CASE
			WHEN LEN(isnull(ClienteD.CodiceFiscale, Cliente.CodiceFiscale)) < 16
			THEN 'NDNDNDNDNDNDNDND'
			WHEN Cast(isnull(ClienteD.CodiceFiscale, Cliente.CodiceFiscale)as VARCHAR(MAX)) IS NULL
			THEN 'NDNDNDNDNDNDNDND'
			ELSE Cast(isnull(ClienteD.CodiceFiscale, Cliente.CodiceFiscale)as VARCHAR(MAX)) 
			END
		)
		+'_'+ IIF(inviati.idincarico is NULL, CAST(T_Incarico.IdIncarico AS VARCHAR(20)),CAST(T_Incarico.IdIncarico as VARCHAR(20)) + '_'+CAST(inviati.RowNum as varchar(5)))
		
		 as NomeDocumentoPdf
		
		--Nome 
		,ISNULL(isnull(Cliente.Nome, ClienteD.Nome),'AZIENDA') as Nome
		
		--Cognome
		, ISNULL(isnull(Cliente.Cognome, ClienteD.Cognome),ISNULL(Cliente.RagioneSociale,ClienteD.RagioneSociale)) as Cognome
		
		--Codicefiscale
		,IIF(ISNULL(Cliente.CodTipoPersona,ClienteD.CodTipoPersona) = 2
			,CASE WHEN ISNULL(Cliente.CodiceFiscale,ClienteD.CodiceFiscale) IS NULL
				THEN 'NDNDNDNDNDNDNDND'
			  ELSE CAST(ISNULL(Cliente.CodiceFiscale,ClienteD.CodiceFiscale) AS VARCHAR(MAX))
				END
			,	
		
		CASE
			WHEN LEN(isnull(ClienteD.CodiceFiscale, Cliente.CodiceFiscale)) < 16
			THEN 'NDNDNDNDNDNDNDND'
			WHEN Cast(isnull(ClienteD.CodiceFiscale, Cliente.CodiceFiscale)as VARCHAR(MAX)) IS NULL
			THEN 'NDNDNDNDNDNDNDND'
			ELSE Cast(isnull(ClienteD.CodiceFiscale, Cliente.CodiceFiscale)as VARCHAR(MAX)) 
			END
		) as CodiceFiscale

		,CASE WHEN ISNULL(Cliente.DataNascita,ClienteD.DataNascita) 
		 end AS DataNascita
		,ISNULL(ComuneNascita.Descrizione,ComuneNascitaD.Descrizione) ComuneNascita
		,ISNULL(ProvinciaNascita.Sigla,ProvinciaNascitaD.Sigla) ProvinciaNascita
		,T_Indirizzo.PrimaRiga IndirizzoResidenza
		,T_Indirizzo.Cap CapResidenza
		,Localita LocalitaResidenza
		,'('+SiglaProvincia+')' ProvinciaResidenza

		--naming cartella zip
		, 'AZI' + '_' + left(replace(replace(replace(convert(char (14),getdate(),120), '-',''),':',''), ' ',''),8) as NamingCartellaZip



			,ISNULL(Cliente.CodTipoPersona,ClienteD.CodTipoPersona) codtipopersona
			,IIF(inviati.idincarico IS NOT NULL,1,0) IsIntegrazione
			,inviati.RowNum NumeroProgressivo
FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier 
		LEFT OUTER JOIN T_R_Incarico_Persona WITH (nolock) ON  T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico 
		AND (
				(T_Incarico.CodTipoIncarico <> 173 AND T_R_Incarico_Persona.Progressivo = 1)
			 OR (T_Incarico.CodTipoIncarico = 173 and T_R_Incarico_Persona.CodRuoloRichiedente <> 194) 
			)

		LEFT OUTER JOIN T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  
		LEFT JOIN D_Comune ComuneNascita ON Cliente.CodComuneNascita = ComuneNascita.Codice
		LEFT JOIN D_Provincia ProvinciaNascita ON ComuneNascita.CodProvincia = ProvinciaNascita.Codice
		
		LEFT OUTER JOIN	T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier 
			AND (
				 (T_Incarico.CodTipoIncarico <> 173 and T_R_Dossier_Persona.Progressivo = 1)
				 OR (T_Incarico.CodTipoIncarico = 173 AND T_R_Dossier_Persona.CodRuoloRichiedente <> 194)
			)
			--((dbo.T_Incarico.CodTipoIncarico = 167 AND dbo.T_R_Dossier_Persona.CodRuoloRichiedente = 11) 
			--OR (dbo.T_Incarico.CodTipoIncarico <> 167 AND dbo.T_R_Dossier_Persona.Progressivo = 1))
		
		--AND T_R_Dossier_Persona.Progressivo = 1 
		LEFT OUTER JOIN	T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona 
		LEFT JOIN D_Comune ComuneNascitaD ON ClienteD.CodComuneNascita = ComuneNascitaD.Codice
		LEFT JOIN D_Provincia ProvinciaNascitaD ON ComuneNascitaD.CodProvincia = ProvinciaNascitaD.Codice

		LEFT JOIN T_R_Persona_Indirizzo trpind ON ISNULL(Cliente.IdPersona,ClienteD.IdPersona) = trpind.IdPersona
		LEFT JOIN T_Indirizzo ON trpind.IdIndirizzo = T_Indirizzo.IdIndirizzo
		AND CodTipoIndirizzo = 2 --Residenza

		LEFT JOIN	T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico 
		AND FlagPresenzaInFileSystem = 1
		AND FlagScaduto = 0
		AND Nome_file like '%.pdf'
		LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository 
		LEFT JOIN export.Z_Cliente_TipoIncarico_TipoDocumento WITH (nolock) ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoDocumento = dbo.T_Documento.Tipo_Documento 
			AND T_Incarico.CodTipoIncarico = Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico 
			AND Z_Cliente_TipoIncarico_TipoDocumento.CodCliente = 23 
			AND CodSistemaEsterno = 5
		
		LEFT JOIN (SELECT MAX(RowNum) RowNum, idincarico FROM  inviati
					GROUP BY idincarico
					 ) inviati ON T_Incarico.IdIncarico = inviati.idincarico
		--AND T_Documento.Documento_id = inviati.documento_id

		where T_incarico.CodArea = 8
		and T_Incarico.CodCliente = 23 
				and T_incarico.CodTipoIncarico in (
				95	--Rimborso Fondi Pensione
				,173 --Disinvestimenti Previdenza
				,99,167	--Sottoscrizioni/Versamenti Fondi Pensione --> cambiare con azimut previdenza
				,102	--Switch Fondi Pensione
				,175	--Successioni - Fondo Pensione
				,178	--Varie Fondo Pensione
				,57 --gestione SEPA 
				,572	--Sottoscrizioni Previdenza - Zenith
				--,573	--Versamenti Aggiuntivi Previdenza - Zenith

				)
				and T_Incarico.DataUltimaTransizione <= cast(cast(getdate() as varchar(12)) as datetime)+1
				and T_Incarico.DataUltimaTransizione >= cast(cast(getdate() as varchar(12)) as datetime)-6
				AND DataInserimento <= DataUltimaTransizione --Viene imbarcato solo il documento che sale prima della chiusura dell'incarico
		
			
			--AND T_Incarico.IdIncarico = 13826790
--				AND T_Incarico.IdIncarico IN ( 14073599,
--14105150 )
		)

			
				
--SELECT DELLA VISTA	
--ko per chiave cliente provvisoria	e codice fiscale non presente o errato
SELECT DISTINCT
	estrazione.idincarico
	,idpersona
	,estrazione.chiavecliente
	,estrazione.codtipoincarico
	,estrazione.descrizioneincarico
	,estrazione.Documento_id
	,CASE WHEN s.n IS NULL --AND IsIntegrazione = 1 
		AND CodDocumentoICBPI = 'ac'
		THEN 'INT' ELSE estrazione.CodDocumentoICBPI
	 END AS CodDocumentoICBPI
	,estrazione.tipo_documento
	,estrazione.nomefile_input
	,estrazione.idrepository
	,estrazione.percorsocompleto
	,estrazione.NamingCartellaZip
	,IIF(s.n is null --and IsIntegrazione = 1 
		AND CodDocumentoICBPI = 'ac',REPLACE(estrazione.NomeDocumentoPdf,'ac','INT'),NomeDocumentoPdf) NomeDocumentoPdf
	,CAST(chiaveunivocaCESAM AS VARCHAR(20)) + ';' + CAST(datainvio AS VARCHAR(8)) + ';' 
		+ IIF(CodDocumentoICBPI = 'ac' AND IsIntegrazione = 1 AND s.n is NULL,'INT', CAST(coddocumentoICBPI AS VARCHAR(2))) 
		+ ';' + CAST(codicefondo AS VARCHAR(3)) + ';' 
		+ IIF(s.n is null --and IsIntegrazione = 1 
			AND CodDocumentoICBPI = 'ac',REPLACE(estrazione.NomeDocumentoPdf,'ac','INT'),CAST(NomeDocumentoPdf as VARCHAR(MAX)))
		+ '.pdf;' + nome + ';' + cognome + ';' + codicefiscale 
		
		+';'+ ComuneNascita
		+';'+ ProvinciaNascita
		 + ';'+DataNascita
		 + ';' + IndirizzoResidenza + ' ' + CapResidenza + ' ' + LocalitaResidenza +  ' ' +ProvinciaResidenza
		AS StringaCSV
	,IIF(estrazione.ChiaveCliente LIKE 'p%' OR (CodiceFiscale is null OR (codtipopersona <> 2 AND LEN(CodiceFiscale) < 16)), 2, 1) AS Stato
	,IIF(estrazione.ChiaveCliente LIKE 'p%' OR (CodiceFiscale is null OR (codtipopersona <> 2 AND LEN(CodiceFiscale) < 16)), 'VERIFICARE CHIAVECLIENTE O CODICEFISCALE', 'OK') AS DescrizioneKO
	,CodiceFiscale
	,IsIntegrazione
	,NumeroProgressivo
	--,s.*
FROM estrazione
JOIN sel
	ON sel.documento_id = estrazione.Documento_id
LEFT JOIN (SELECT COUNT(*) n, estrazione.IdIncarico
			FROM estrazione 
			LEFT JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI previnet ON estrazione.Documento_id = previnet.documento_id

			WHERE previnet.documento_id IS null 
			AND  CodDocumentoICBPI NOT IN ('ko','ac') --AND IsIntegrazione = 1 
			
		GROUP BY estrazione.IdIncarico
		) s ON s.IdIncarico = sel.IdIncarico	


		
--WHERE NomeDocumentoPdf NOT LIKE 'ko%'
----AND estrazione.IdIncarico IN (14357340 )
--ORDER BY estrazione.IdIncarico


--UNION ALL

--select DISTINCT
--estrazione.idincarico
--,idpersona
--, estrazione.chiavecliente
--, estrazione.codtipoincarico
--, estrazione.descrizioneincarico
--, estrazione.documento_id
--, estrazione.tipo_documento
--, estrazione.nomefile_input
--, estrazione.idrepository
--, estrazione.percorsocompleto
--, estrazione.NamingCartellaZip
--, estrazione.nomedocumentopdf
--, cast(chiaveunivocaCESAM as VARCHAR(8))+';'+cast(datainvio as VARCHAR(8))+';'+cast(coddocumentoICBPI as VARCHAR(2))+';'+cast(codicefondo as VARCHAR(3))+';'+cast(estrazione.nomedocumentopdf as VARCHAR(max))+'.pdf;'+nome+';'+cognome+';'+codicefiscale as StringaCSV
--, 1 as Stato
--, 'OK' AS DescrizioneKO
--,CodiceFiscale
--  from estrazione 
--  join sel on sel.documento_id = estrazione.Documento_id


--  where (CODICEFISCALE is NOT null and (len(codicefiscale) = 16 AND codtipopersona = 2)
--and estrazione.idincarico not in (select idincarico from estrazione where chiavecliente like 'P-%' ))

GO