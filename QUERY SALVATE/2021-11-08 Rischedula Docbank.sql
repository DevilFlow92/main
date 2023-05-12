USE clc

GO


--SELECT NamingCartellaZip, * FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
--WHERE idincarico = 18143695


DECLARE @Gruppo SMALLINT = 8

IF OBJECT_ID('tempdb.dbo.#Gruppi') IS NOT NULL
begin	
	DROP TABLE #Gruppi
end

CREATE TABLE #Gruppi
(
	IdIncarico INT PRIMARY KEY,
	Progressivo SMALLINT
)


BEGIN TRAN
INSERT INTO #Gruppi (IdIncarico, Progressivo)
select 17789784 IdIncarico, 1 progressivo union all
select 17814853 IdIncarico, 1 progressivo union all
select 17814870 IdIncarico, 1 progressivo union all
select 17826880 IdIncarico, 1 progressivo union all
select 17855589 IdIncarico, 1 progressivo union all
select 17855591 IdIncarico, 1 progressivo union all
select 17855612 IdIncarico, 1 progressivo union all
select 17880368 IdIncarico, 1 progressivo union all
select 17893634 IdIncarico, 1 progressivo union all
select 17893639 IdIncarico, 1 progressivo union all
select 17893647 IdIncarico, 1 progressivo union all
select 17893651 IdIncarico, 1 progressivo union all
select 17913237 IdIncarico, 1 progressivo union all
select 17930899 IdIncarico, 1 progressivo union all
select 17957934 IdIncarico, 1 progressivo union all
select 17957935 IdIncarico, 1 progressivo union all
select 17957936 IdIncarico, 1 progressivo union all
select 17970949 IdIncarico, 1 progressivo union all
select 17993030 IdIncarico, 1 progressivo union all
select 17993040 IdIncarico, 1 progressivo union all
select 18007767 IdIncarico, 2 progressivo union all
select 18050245 IdIncarico, 2 progressivo union all
select 18076131 IdIncarico, 2 progressivo union all
select 18076133 IdIncarico, 2 progressivo union all
select 18076152 IdIncarico, 2 progressivo union all
select 18086919 IdIncarico, 2 progressivo union all
select 18086921 IdIncarico, 2 progressivo union all
select 18099945 IdIncarico, 2 progressivo union all
select 18099950 IdIncarico, 2 progressivo union all
select 18099952 IdIncarico, 2 progressivo union all
select 18121876 IdIncarico, 2 progressivo union all
select 18133233 IdIncarico, 2 progressivo union all
select 18133234 IdIncarico, 2 progressivo union all
select 18143691 IdIncarico, 2 progressivo union all
select 18143695 IdIncarico, 2 progressivo union all
select 18157123 IdIncarico, 2 progressivo union all
select 18166792 IdIncarico, 2 progressivo union all
select 18166794 IdIncarico, 2 progressivo union all
select 18166802 IdIncarico, 2 progressivo union all
select 18192476 IdIncarico, 2 progressivo union all
select 18192494 IdIncarico, 3 progressivo union all
select 18192495 IdIncarico, 3 progressivo union all
select 18202960 IdIncarico, 3 progressivo union all
select 18202969 IdIncarico, 3 progressivo union all
select 18202979 IdIncarico, 3 progressivo union all
select 18215586 IdIncarico, 3 progressivo union all
select 18215592 IdIncarico, 3 progressivo union all
select 18244186 IdIncarico, 3 progressivo union all
select 18244258 IdIncarico, 3 progressivo union all
select 18259776 IdIncarico, 3 progressivo union all
select 18271850 IdIncarico, 3 progressivo union all
select 18271853 IdIncarico, 3 progressivo union all
select 18271861 IdIncarico, 3 progressivo union all
select 18286074 IdIncarico, 3 progressivo union all
select 18286080 IdIncarico, 3 progressivo union all
select 18286091 IdIncarico, 3 progressivo union all
select 18286092 IdIncarico, 3 progressivo union all
select 18296725 IdIncarico, 3 progressivo union all
select 18307442 IdIncarico, 3 progressivo union all
select 18318704 IdIncarico, 3 progressivo union all
select 18330058 IdIncarico, 4 progressivo union all
select 18339730 IdIncarico, 4 progressivo union all
select 18344132 IdIncarico, 4 progressivo union all
select 18353875 IdIncarico, 4 progressivo union all
select 18353880 IdIncarico, 4 progressivo union all
select 18368641 IdIncarico, 4 progressivo union all
select 18368642 IdIncarico, 4 progressivo union all
select 18368643 IdIncarico, 4 progressivo union all
select 18389654 IdIncarico, 4 progressivo union all
select 18389655 IdIncarico, 4 progressivo union all
select 18418618 IdIncarico, 4 progressivo union all
select 18436834 IdIncarico, 4 progressivo union all
select 18446744 IdIncarico, 4 progressivo union all
select 18458334 IdIncarico, 4 progressivo union all
select 18481373 IdIncarico, 4 progressivo union all
select 18481375 IdIncarico, 4 progressivo union all
select 18498987 IdIncarico, 4 progressivo union all
select 18498992 IdIncarico, 4 progressivo union all
select 18499004 IdIncarico, 4 progressivo union all
select 18525495 IdIncarico, 4 progressivo union all
select 18525530 IdIncarico, 5 progressivo union all
select 18547848 IdIncarico, 5 progressivo union all
select 18547891 IdIncarico, 5 progressivo union all
select 18562427 IdIncarico, 5 progressivo union all
select 18562432 IdIncarico, 5 progressivo union all
select 18575583 IdIncarico, 5 progressivo union all
select 18575602 IdIncarico, 5 progressivo union all
select 18575606 IdIncarico, 5 progressivo union all
select 18575611 IdIncarico, 5 progressivo union all
select 18575617 IdIncarico, 5 progressivo union all
select 18575621 IdIncarico, 5 progressivo union all
select 18575622 IdIncarico, 5 progressivo union all
select 18575625 IdIncarico, 5 progressivo union all
select 18584245 IdIncarico, 5 progressivo union all
select 18584288 IdIncarico, 5 progressivo union all
select 18594293 IdIncarico, 5 progressivo union all
select 18608302 IdIncarico, 5 progressivo union all
select 18608314 IdIncarico, 5 progressivo union all
select 18634272 IdIncarico, 5 progressivo union all
select 18634276 IdIncarico, 5 progressivo union all
select 18634277 IdIncarico, 6 progressivo union all
select 18634279 IdIncarico, 6 progressivo union all
select 18634280 IdIncarico, 6 progressivo union all
select 18643680 IdIncarico, 6 progressivo union all
select 18643689 IdIncarico, 6 progressivo union all
select 18653575 IdIncarico, 6 progressivo union all
select 18653585 IdIncarico, 6 progressivo union all
select 18663833 IdIncarico, 6 progressivo union all
select 18663834 IdIncarico, 6 progressivo union all
select 18663853 IdIncarico, 6 progressivo union all
select 18673181 IdIncarico, 6 progressivo union all
select 18681751 IdIncarico, 6 progressivo union all
select 18681755 IdIncarico, 6 progressivo union all
select 18681757 IdIncarico, 6 progressivo union all
select 18681771 IdIncarico, 6 progressivo union all
select 18706801 IdIncarico, 6 progressivo union all
select 18717491 IdIncarico, 6 progressivo union all
select 18717496 IdIncarico, 6 progressivo union all
select 18727394 IdIncarico, 6 progressivo union all
select 18727395 IdIncarico, 6 progressivo union all
select 18738121 IdIncarico, 7 progressivo union all
select 18751503 IdIncarico, 7 progressivo union all
select 18767314 IdIncarico, 7 progressivo union all
select 18767325 IdIncarico, 7 progressivo union all
select 18791682 IdIncarico, 7 progressivo union all
select 18791683 IdIncarico, 7 progressivo union all
select 18791684 IdIncarico, 7 progressivo union all
select 18791685 IdIncarico, 7 progressivo union all
select 18791689 IdIncarico, 7 progressivo union all
select 18801327 IdIncarico, 7 progressivo union all
select 18812149 IdIncarico, 7 progressivo union all
select 18812151 IdIncarico, 7 progressivo union all
select 18827848 IdIncarico, 7 progressivo union all
select 18827849 IdIncarico, 7 progressivo union all
select 18827858 IdIncarico, 7 progressivo union all
select 18860883 IdIncarico, 7 progressivo union all
select 18872684 IdIncarico, 7 progressivo union all
select 18897001 IdIncarico, 7 progressivo union all
select 18897002 IdIncarico, 7 progressivo union all
select 18951410 IdIncarico, 7 progressivo union all
select 18951412 IdIncarico, 8 progressivo union all
select 18951419 IdIncarico, 8 progressivo union all
select 18951425 IdIncarico, 8 progressivo union all
select 18961414 IdIncarico, 8 progressivo union all
select 18970180 IdIncarico, 8 progressivo union all
select 18970181 IdIncarico, 8 progressivo union all
select 18998684 IdIncarico, 8 progressivo union all
select 19008745 IdIncarico, 8 progressivo union all
select 19008763 IdIncarico, 8 progressivo union all
select 19029571 IdIncarico, 8 progressivo union all
select 19029584 IdIncarico, 8 progressivo union all
select 19050180 IdIncarico, 8 progressivo union all
select 19060877 IdIncarico, 8 progressivo union all
select 19060882 IdIncarico, 8 progressivo union all
select 19060897 IdIncarico, 8 progressivo union all
select 19060899 IdIncarico, 8 progressivo union all
select 19071314 IdIncarico, 8 progressivo union all
select 19082538 IdIncarico, 8 progressivo union all
select 19093967 IdIncarico, 8 progressivo union all
select 19104975 IdIncarico, 8 progressivo union all
select 19104986 IdIncarico, 9 progressivo union all
select 19104989 IdIncarico, 9 progressivo union all
select 19135093 IdIncarico, 9 progressivo union all
select 19194180 IdIncarico, 9 progressivo union all
select 19194181 IdIncarico, 9 progressivo union all
select 19194183 IdIncarico, 9 progressivo union all
select 19194185 IdIncarico, 9 progressivo union all
select 19232667 IdIncarico, 9 progressivo union all
select 19245761 IdIncarico, 9 progressivo union all
select 19245762 IdIncarico, 9 progressivo union all
select 19245763 IdIncarico, 9 progressivo union all
select 19257440 IdIncarico, 9 progressivo union all
select 19257444 IdIncarico, 9 progressivo union all
select 19257446 IdIncarico, 9 progressivo union all
select 19257447 IdIncarico, 9 progressivo union all
select 19257457 IdIncarico, 9 progressivo union all
select 19285659 IdIncarico, 9 progressivo union all
select 19285661 IdIncarico, 9 progressivo union all
select 19294649 IdIncarico, 9 progressivo union all
select 19319171 IdIncarico, 9 progressivo union all
select 19319172 IdIncarico, 10 progressivo union all
select 19319175 IdIncarico, 10 progressivo union all
select 19319176 IdIncarico, 10 progressivo union all
select 19319178 IdIncarico, 10 progressivo union all
select 19333878 IdIncarico, 10 progressivo union all
select 19352756 IdIncarico, 10 progressivo union all
select 19369491 IdIncarico, 10 progressivo union all
select 19395088 IdIncarico, 10 progressivo union all
select 19395111 IdIncarico, 10 progressivo union all
select 19423414 IdIncarico, 10 progressivo union all
select 19423415 IdIncarico, 10 progressivo union all
select 19423417 IdIncarico, 10 progressivo union all
select 19450220 IdIncarico, 10 progressivo union all
select 19473561 IdIncarico, 10 progressivo union all
select 19495200 IdIncarico, 10 progressivo union all
select 19495205 IdIncarico, 10 progressivo union all
select 19513198 IdIncarico, 10 progressivo union all
select 19513199 IdIncarico, 10 progressivo union all
select 19535955 IdIncarico, 10 progressivo union all
select 19535963 IdIncarico, 10 progressivo

DELETE t
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank t
JOIN #Gruppi ON t.idincarico = #Gruppi.IdIncarico
AND Progressivo = @Gruppo
WHERE t.NamingCartellaZip = '20211109022_AssetMOL'

;WITH
progressivozip AS (
SELECT CONVERT(VARCHAR(10), GETDATE(),112)+
CAST(format(COALESCE(RIGHT(MAX(docbank.ProgressivoZip),3),0)+1,'d3')as varchar(3))
 progressivo 
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank docbank
WHERE left(docbank.ProgressivoZip,8) = CAST(GETDATE() as DATE)

) 
,estrazione AS (
SELECT  DISTINCT 
T_Documento.Documento_id,
		T_Documento.Tipo_Documento,
		T_Documento.IdIncarico,
		D_TipoIncarico.Descrizione DescrizioneIncarico,
		dbo.T_Incarico.CodTipoIncarico,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto,
		CONVERT(char(10),[DataInserimento],121) as DataInserimento,

		export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceTipoDocumentoCliente, --doctype
		
		LTRIM(RTRIM(REPLACE(T_Persona.ChiaveCliente,CHAR(9),''))) AS NDG,
		ISNULL(T_DocumentoIdentita.Numero,T_Persona.ChiaveCliente) AS NumeroDocumento,
		ISNULL(CONVERT(varchar(19),T_DocumentoIdentita.DataScadenza,103),CONVERT(VARCHAR(19),GETDATE(),103)) AS DataDocumento,
		T_Persona.CodiceFiscale as CodiceFiscale,
		ISNULL(nrapporto.Leading_refCode,'06')+RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo,' ',''),CHAR(13),''),char(10),''),CHAR(9),''),12) as NumeroRapporto,
		export.Z_Cliente_TipoIncarico_TipoDocumento.CodiceAggiuntivoCliente as operation,
		CASE WHEN CodOggettoControlli = 48 THEN REPLACE(REPLACE(REPLACE(idpraticaDossier.Testo , CHAR(10),''),CHAR(13),''),CHAR(9),'')
			WHEN CodOggettoControlli = 46 THEN REPLACE(REPLACE(REPLACE(idpraticaPortabilita.Testo, CHAR(10), ''),CHAR(13),''),CHAR(9),'')
			WHEN CodOggettoControlli = 58 THEN REPLACE(REPLACE(REPLACE(idpraticaKK.Testo, CHAR(10), ''),CHAR(13),''),CHAR(9),'')
			WHEN T_Documento.Tipo_Documento = 8302 THEN REPLACE(REPLACE(REPLACE(idpraticaTDT.Testo, CHAR(10), ''),CHAR(13),''),CHAR(9),'')
			WHEN T_Documento.Tipo_Documento = 10053 THEN REPLACE(REPLACE(REPLACE(T_Documento.Documento_id, CHAR(10), ''),CHAR(13),''),CHAR(9),'')
			WHEN T_Documento.Tipo_Documento = 20002 THEN REPLACE(REPLACE(REPLACE(ISNULL(idpraticaWEBCOLL.Testo,idpraticaWEBCOLL_2.valore), CHAR(10), ''),CHAR(13),''),CHAR(9),'')
			WHEN T_Documento.Tipo_Documento IN ( 257320,257321) THEN REPLACE(REPLACE(REPLACE(idswitchconto.Testo, CHAR(10), ''),CHAR(13), ''),CHAR(9), '')
	
		END		
		AS idPraticaDocBank

		,T_Documento.Note
		,DataInserimento AS DataInserimentoFull

		,ISNULL(D_Scaffale.Descrizione+'-'+CAST(S_PosizioneArchivio.CodiceSezione AS VARCHAR(3))
			+'-'+CAST(S_PosizioneArchivio.CodicePiano AS VARCHAR(3))
			+'-'+CAST(S_PosizioneArchivio.CodiceScatola as VARCHAR(3))
			+'['+CAST(T_Incarico.IdIncarico as VARCHAR(20))+']','ArchivioMOL') AS PosizioneArchivio

,
IIF(CodiceAnomalia.Valore <>'',orga.ap_GetStringBetween2Chars(CAST(CodiceAnomalia.Valore AS VARCHAR(10)),'[',']')
,NULL) 
 AS CodiceAnomalia

,CASE WHEN T_Documento.Tipo_Documento = 5589 --Documento d'Identità - Codice Fiscale
		AND CodiceTipoDocumentoCliente = 'IDNCRT' --Solo CI
		AND CodiceAnomalia.Nome = 'Codice_Fiscale_-_Seleziona_Codice_di_Anomalia1Anomalia'
	  THEN 1
	  WHEN T_Documento.Tipo_Documento = 5589  
		AND CodiceTipoDocumentoCliente = 'IDNCFS'
		AND CodiceAnomalia.Nome = 'Documento_d''Identità_-_Seleziona_Codice_di_Anomalia1Anomalia'
		THEN 1
		ELSE 0
	 END AS FlagErrore
	 ,T_Persona.IdPersona
	,IdDocEsterno.IdDocBanca
	,IdDocEsterno.NomeFileZipBanca

FROM	
		T_Incarico
		JOIN #Gruppi ON #Gruppi.IdIncarico = T_Incarico.IdIncarico
		JOIN dbo.T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
		AND FlagPresenzaInFileSystem = 1 AND FlagScaduto = 0
		AND T_Documento.Tipo_Documento IN (259616 --Attestato avvenuta consegna KK - Nexi
											,259625 --Domande aggiuntive NEXI
											)
		LEFT JOIN S_PosizioneArchivio ON T_Documento.IdPosizioneArchivio = S_PosizioneArchivio.IdPosizioneArchivio 
		LEFT JOIN D_Scaffale on D_Scaffale.Codice = S_PosizioneArchivio.CodScaffale  
			
		JOIN D_Documento ON D_Documento.Codice=T_Documento.Tipo_Documento
		JOIN dbo.D_TipoIncarico ON  dbo.D_TipoIncarico.Codice= T_Incarico.CodTipoIncarico    
		JOIN S_RepositoryDocumenti on S_RepositoryDocumenti.IdRepository = dbo.T_Documento.IdRepository  
		LEFT JOIN T_DocumentoDataEntry ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
		LEFT JOIN T_Persona ON T_DocumentoDataEntry.IdPersona = T_Persona.IdPersona
		LEFT JOIN T_DocumentoIdentita ON T_DocumentoIdentita.IdPersona = T_Persona.IdPersona		
		
		LEFT JOIN T_DatoAggiuntivo ON T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico AND CodTipoDatoAggiuntivo = 643 and FlagAttivo = 1
		--643	IBAN
		LEFT JOIN T_DatoAggiuntivo idpraticaDossier ON idpraticaDossier.IdIncarico = T_Incarico.IdIncarico AND idpraticaDossier.CodTipoDatoAggiuntivo = 936 AND idpraticaDossier.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo idpraticaPortabilita ON idpraticaPortabilita.IdIncarico = T_Incarico.IdIncarico AND idpraticaPortabilita.CodTipoDatoAggiuntivo = 937 AND idpraticaPortabilita.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo idpraticaTDT ON idpraticaTDT.IdIncarico = T_Incarico.IdIncarico AND idpraticaTDT.CodTipoDatoAggiuntivo = 1020 AND idpraticaTDT.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo idpraticaKK ON idpraticaKK.IdIncarico = T_Incarico.IdIncarico AND idpraticaKK.CodTipoDatoAggiuntivo = 1159 AND idpraticaKK.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo idpraticaWEBCOLL ON idpraticaWEBCOLL.IdIncarico = T_Incarico.IdIncarico and idpraticaWEBCOLL.CodTipoDatoAggiuntivo = 1252 AND idpraticaWEBCOLL.FlagAttivo = 1	
		LEFT JOIN T_DatoAggiuntivo idswitchconto ON idswitchconto.IdIncarico = T_Incarico.IdIncarico AND idswitchconto.CodTipoDatoAggiuntivo = 2046 AND idswitchconto.FlagAttivo = 1
		
		LEFT JOIN (SELECT --MAX(l.IdLog) idlog
(
SELECT Valore FROM L_DocumentoDataEntry where IdLog = max(l.IdLog)) valore
,l.IdDocumentoDataEntry
 FROM L_DocumentoDataEntry l
WHERE l.Nome = 'Reference_code_WEBCOLL'
GROUP by l.IdDocumentoDataEntry) idpraticaWEBCOLL_2 ON idpraticaWEBCOLL_2.IdDocumentoDataEntry = T_DocumentoDataEntry.IdDocumentoDataEntry

		  JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON CodSistemaEsterno = 6 
		  AND T_Documento.Tipo_Documento = export.Z_Cliente_TipoIncarico_TipoDocumento.CodTipoDocumento
			AND T_Incarico.CodTipoIncarico = export.Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico  
			and T_Incarico.CodCliente = export.Z_Cliente_TipoIncarico_TipoDocumento.CodCliente 
			AND (T_Incarico.CodStatoWorkflowIncarico = export.Z_Cliente_TipoIncarico_TipoDocumento.CodStatoWorkflowIncarico
				OR T_Incarico.CodAttributoIncarico = export.Z_Cliente_TipoIncarico_TipoDocumento.CodAttributoIncarico
				)
		LEFT JOIN (
		SELECT MAX(DocNRapporto.documento_id) Documento_id, T_Incarico.IdIncarico,CASE Testo when 'Conto Tascabile' THEN '32' ELSE '06' END  Leading_refCode 
		FROM  T_Documento DocNRapporto 
		JOIN T_Incarico on DocNRapporto.IdIncarico = T_Incarico.IdIncarico
		JOIN T_DatoAggiuntivo ON T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico
		AND FlagAttivo = 1
		AND CodTipoDatoAggiuntivo = 1208
		GROUP BY T_Incarico.IdIncarico,CASE Testo when 'Conto Tascabile' THEN '32' ELSE '06' END 
				) nrapporto ON nrapporto.IdIncarico = T_Incarico.IdIncarico
		
		LEFT JOIN export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank ON T_Incarico.IdIncarico = Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.idincarico
			AND T_Documento.Tipo_Documento = Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.tipo_documento
			AND T_Documento.Documento_id = export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank.documento_id
			

		--## elimino tutti gli incarichi che ha preso in gestione il BOT
		LEFT JOIN (SELECT L_WorkflowIncarico.IdIncarico FROM L_WorkflowIncarico
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico AND CodCliente = 48 AND CodTipoIncarico = 331
			WHERE L_WorkflowIncarico.CodAttributoIncaricoDestinazione = 1465 AND IdOperatore = 12572
			) workflow ON workflow.IdIncarico = T_Incarico.IdIncarico
	
	/* LF 01/04/2020 CODICI ANOMALIA */	
	LEFT JOIN (
	SELECT  T_Incarico.IdIncarico, Documento_id,Tipo_Documento, T_DocumentoDataEntry.IdDocumentoDataEntry	
	,Nome
	,Valore
		FROM T_Incarico
	JOIN T_Documento on T_Incarico.IdIncarico = T_Documento.IdIncarico
	JOIN T_DocumentoDataEntry ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
	JOIN (SELECT MAX(IdLog) IdLog, IdDocumentoDataEntry
			 FROM L_DocumentoDataEntry
			 --WHERE Nome LIKE '%Seleziona_Codice_di_Anomalia1Anomalia%'
			 GROUP BY IdDocumentoDataEntry,Nome
			) inputlde ON T_DocumentoDataEntry.IdDocumentoDataEntry = inputlde.IdDocumentoDataEntry
			
	JOIN L_DocumentoDataEntry ON inputlde.IdLog = L_DocumentoDataEntry.IdLog
	
	WHERE T_Incarico.CodArea = 8
	AND T_Incarico.CodCliente = 48
	AND T_Incarico.CodTipoIncarico in (611,682,613)
	AND T_Incarico.DataCreazione >= '20200428'
	and T_Documento.FlagPresenzaInFileSystem = 1 AND T_Documento.FlagScaduto = 0
	AND Nome LIKE '%Seleziona_Codice_di_Anomalia1Anomalia%'
	AND Valore IS NOT NULL AND Valore <> '' AND Valore <> ' '
	--AND T_Incarico.IdIncarico = 8874402

	) CodiceAnomalia ON T_Documento.Documento_id = CodiceAnomalia.Documento_id 
	
/*  LF 2021-09-16 IdDocumento della banca */
OUTER APPLY (
				SELECT tfile.NomeFileZip NomeFileZipBanca, dbo.GROUP_CONCAT_D(tfile.ChiaveEsterna,'|') IdDocBanca
				FROM T_FileOriginaleSistemaEsterno tfile
				WHERE tfile.IdDocumento = T_Documento.Documento_id
				GROUP BY tfile.NomeFileZip
) IdDocEsterno

WHERE #Gruppi.progressivo = @Gruppo

) 
,sel as (
			SELECT DISTINCT 	
			estrazione.Documento_id
			,estrazione.Tipo_Documento
			,estrazione.IdIncarico
			,estrazione.DescrizioneIncarico
			,estrazione.CodTipoIncarico
			,estrazione.DescrizioneDocumento
			,estrazione.NomeFile_Input
			,estrazione.IdRepository
			,estrazione.PercorsoCompleto
			,estrazione.DataInserimento
			,CAST(format(dense_RANK() OVER (PARTITION BY (SELECT progressivo FROM progressivozip)  
	ORDER BY --(SELECT PROGRESSIVO FROM progressivozip)
	 estrazione.CodiceTipoDocumentoCliente+ISNULL(z.CodiceAggiuntivoCliente,1)+CAST(IdIncarico+IIF(estrazione.CodiceTipoDocumentoCliente IN ('PRDCNT'
																																,'PRDCNT_SWTCH'
																																,'PRDCNT_INT'
																																,'PRDCNT_INT_KK'
																																,'Attestato'
																																,'PRDCNT_NG'
																																,'PRDCNT_INT'
																																,'Dichiarazione'
																																,'MTSPNF'
																																,'AUTCOMNF'
																																),0, ISNULL(IdPersona,0)) AS VARCHAR(50))
	),'d6') AS VARCHAR(6)
	) 
	AS ProgressivoDocumento,
	
	+'AM'+'_'		
	+CAST(IdIncarico as varchar(10))+'_'
	+CAST(format(dense_RANK() OVER (PARTITION BY (SELECT progressivo FROM progressivozip)  
	ORDER BY estrazione.CodiceTipoDocumentoCliente+ISNULL(z.CodiceAggiuntivoCliente,1)+CAST(IdIncarico+IIF(estrazione.CodiceTipoDocumentoCliente IN ('PRDCNT'
																																		,'PRDCNT_SWTCH'
																																		,'PRDCNT_INT'
																																		,'PRDCNT_INT_KK'
																																		,'Attestato'
																																		,'PRDCNT_NG'
																																		,'PRDCNT_INT'
																																		,'Dichiarazione'
																																		,'MTSPNF'
																																		,'AUTCOMNF'
																																		),0, ISNULL(IdPersona,0)) AS VARCHAR(50))
),'d6') AS VARCHAR(6)) AS nomefileoutput,

	(SELECT progressivo FROM progressivozip)   AS ProgressivoZip,
	(SELECT progressivo FROM progressivozip)  
		+'_AssetMOL' as folder

			,estrazione.CodiceTipoDocumentoCliente
			,estrazione.NDG
			,estrazione.NumeroDocumento
			,estrazione.DataDocumento
			,estrazione.CodiceFiscale
			,estrazione.NumeroRapporto
			,estrazione.operation
			,estrazione.idPraticaDocBank
			,estrazione.Note
			,estrazione.DataInserimentoFull
			,estrazione.PosizioneArchivio
			,estrazione.CodiceAnomalia 
			,estrazione.IdDocBanca
			,estrazione.NomeFileZipBanca
			FROM estrazione
			JOIN ( SELECT DISTINCT CodCliente,CodTipoIncarico,CodTipoDocumento,CodiceTipoDocumentoCliente,CodiceAggiuntivoCliente from export.Z_Cliente_TipoIncarico_TipoDocumento ) z ON z.CodCliente = 48
		AND estrazione.CodTipoIncarico = z.CodTipoIncarico
		AND z.CodTipoDocumento = Tipo_Documento
		AND estrazione.CodiceTipoDocumentoCliente = z.CodiceTipoDocumentoCliente

		--ORDER BY IdIncarico
) 
INSERT INTO export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank	 (documento_id, idincarico, codtipoincarico
, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, ProgressivoZip
, NamingCartellaZip, ProgressivoDocumento, ContentPath, DocType, NDG, NumeroDocumento, DataDocumento
, CodiceFiscale, NumeroRapporto, Operation, idPraticaDocBank, PosizioneArchivio, FlagUpload
, CodAnomalia, IdDocBanca, NomeFileZipBanca)
SELECT DISTINCT sel.Documento_id,
				sel.IdIncarico,
				sel.CodTipoIncarico,
				sel.DescrizioneIncarico,
				sel.Tipo_Documento,
				sel.NomeFile_Input,
				sel.IdRepository,
				sel.PercorsoCompleto,
				sel.ProgressivoZip,			
				sel.folder AS NamingCartellaZip,
				sel.ProgressivoDocumento,
				sel.nomefileoutput + '_s' ContentPath,
				sel.CodiceTipoDocumentoCliente as DocType ,
				sel.NDG,
				sel.NumeroDocumento,
				sel.DataDocumento,
				sel.CodiceFiscale,
				sel.NumeroRapporto,
				sel.operation,
				sel.idPraticaDocBank,
				sel.PosizioneArchivio,
				0 FlagUpload,
				sel.CodiceAnomalia
				,sel.iddocbanca
				,sel.nomefilezipbanca
FROM sel 
ORDER BY IdIncarico

COMMIT TRAN

GO


/*
20211110006_AssetMOL
20211110007_AssetMOL
20211110008_AssetMOL
20211110025_AssetMOL
20211110026_AssetMOL
20211110027_AssetMOL
20211110028_AssetMOL
20211110030_AssetMOL
20211110031_AssetMOL
20211110032_AssetMOL
*/


SELECT DISTINCT NumeroRapporto, ProgressivoZip IdPayload, NamingCartellaZip NomeFileZip, idincarico IdIncaricoQTask
FROM export.Y_CESAM_CB_FlussoGiornaliero_Documenti_DocBank
WHERE NamingCartellaZip IN (
'20211110004_AssetMOL'
,'20211110006_AssetMOL'
,'20211110007_AssetMOL'
,'20211110008_AssetMOL'
,'20211110025_AssetMOL'
,'20211110026_AssetMOL'
,'20211110027_AssetMOL'
,'20211110028_AssetMOL'
,'20211110030_AssetMOL'
,'20211110031_AssetMOL'
,'20211110032_AssetMOL'
)
ORDER BY NamingCartellaZip

