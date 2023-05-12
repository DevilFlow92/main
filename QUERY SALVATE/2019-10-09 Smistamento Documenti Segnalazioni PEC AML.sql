USE clc
GO

--EXEC controlli.CESAM_AZ_Antiriciclaggio_CreaSubincarichiPEC @idriga = 14455494

ALTER  PROCEDURE controlli.CESAM_AZ_Antiriciclaggio_CreaSubincarichiPEC (@idriga INT) as

--DECLARE @idriga INT =  14407473 --14827990 --4427268  --4427063 

DECLARE	@RES_CodGiudizioControllo INT
		,@RED_Note AS NVARCHAR(2000)
		,@RED_CodEsitoControllo VARCHAR(5)


DECLARE @Esito INT
DECLARE @Note VARCHAR(MAX)
SET @RES_CodGiudizioControllo = 1	--N/D
SET @RED_Note = ''

DECLARE @IdIncarico INT

SET @IdIncarico = @idriga

IF OBJECT_ID('tempdb.dbo.#Documenti') IS NOT NULL
	DROP TABLE #Documenti


;WITH dati AS (
SELECT tdoc.Documento_id
	,CASE WHEN ISNUMERIC(ndg.Valore) = 1 --è stato inserito un codice cliente
		THEN RIGHT('000000000'+ CONVERT(varchar(10),ndg.Valore),9)  --faccio in modo che il codice cliente riporti i 9 caratteri attesi

		ELSE ndg.Valore --ho inserito il codice fiscale perchè non ho ndg fend
     END AS ndgDE
	,ISNULL(cognome.Valore,'') CognomeDE
	,ISNULL(nome.Valore,'') NomeDE
	,ISNULL(cf.Valore,'') CodiceFiscaleDE
	,ISNULL(CodiceRichiesta.Valore,'') CodiceRichiesta
	,ISNULL(DataRichiesta.Valore,'') DataRichiesta
	,ISNULL(CodiceOrganoProcedente.Valore,'') CodiceOrganoProcedente
	,ISNULL(StrutturaRichiedente.Valore,'') StrutturaRichiedente
	,ISNULL(StrutturaAutorizzante.Valore,'') StrutturaAutorizzante
	,ISNULL(DataInizioIndagine.Valore,'') DataInizioIndagine
	,ISNULL(DataFineIndagine.Valore,'') DataFineIndagine
	,ISNULL(CFOpsFinanziario.Valore,'') CFOpsFinanziario

FROM  T_Documento tdoc
JOIN T_DocumentoDataEntry tde ON Documento_id = tde.IdDocumento

JOIN L_DocumentoDataEntry ndg ON tde.IdDocumentoDataEntry = ndg.IdDocumentoDataEntry
AND ndg.Nome = 'Codice Cliente'

LEFT JOIN L_DocumentoDataEntry cf ON tde.IdDocumentoDataEntry = cf.IdDocumentoDataEntry
AND cf.Nome = 'Codice Fiscale'
LEFT JOIN L_DocumentoDataEntry cognome ON tde.IdDocumentoDataEntry = cognome.IdDocumentoDataEntry
AND cognome.Nome = 'Cognome Cliente'
LEFT JOIN L_DocumentoDataEntry nome ON tde.IdDocumentoDataEntry = nome.IdDocumentoDataEntry
AND nome.Nome = 'Nome Cliente'

LEFT JOIN L_DocumentoDataEntry CodiceRichiesta ON tde.IdDocumentoDataEntry = CodiceRichiesta.IdDocumentoDataEntry
AND CodiceRichiesta.Nome = 'Codice Univoco della Richiesta'
LEFT JOIN L_DocumentoDataEntry CodiceOrganoProcedente ON tde.IdDocumentoDataEntry = CodiceOrganoProcedente.IdDocumentoDataEntry
AND CodiceOrganoProcedente.Nome = 'Codice Organo Procedente'
LEFT JOIN L_DocumentoDataEntry DataRichiesta ON tde.IdDocumentoDataEntry = DataRichiesta.IdDocumentoDataEntry
AND DataRichiesta.Nome = 'Data Richiesta'
LEFT JOIN L_DocumentoDataEntry StrutturaRichiedente ON tde.IdDocumentoDataEntry = StrutturaRichiedente.IdDocumentoDataEntry
AND StrutturaRichiedente.Nome = 'Descrizione Struttura Richiedente'
LEFT JOIN L_DocumentoDataEntry DataInizioIndagine ON tde.IdDocumentoDataEntry = DataInizioIndagine.IdDocumentoDataEntry
AND DataInizioIndagine.Nome = 'Data Inizio Indagine'
LEFT JOIN L_DocumentoDataEntry DataFineIndagine ON tde.IdDocumentoDataEntry = DataFineIndagine.IdDocumentoDataEntry
AND DataFineIndagine.Nome = 'Data Fine Indagine'
LEFT JOIN L_DocumentoDataEntry StrutturaAutorizzante ON tde.IdDocumentoDataEntry = StrutturaAutorizzante.IdDocumentoDataEntry
AND StrutturaAutorizzante.Nome = 'Descrizione Struttura Autorizzante'
LEFT JOIN L_DocumentoDataEntry CFOpsFinanziario ON tde.IdDocumentoDataEntry = CFOpsFinanziario.IdDocumentoDataEntry
AND CFOpsFinanziario.Nome = 'Codice Fiscale Operatore Finanziario'

WHERE FlagPresenzaInFileSystem = 1
AND FlagScaduto = 0
AND IdIncarico = @IdIncarico

) SELECT 	dati.Documento_id
			,ISNULL(T_Persona.ChiaveCliente,dati.ndgDE) ndgDE
			,dati.CognomeDE
			,dati.NomeDE
			,dati.CodiceFiscaleDE
			,dati.CodiceRichiesta
			,dati.DataRichiesta
			,dati.CodiceOrganoProcedente
			,dati.StrutturaRichiedente
			,dati.StrutturaAutorizzante
			,dati.DataInizioIndagine
			,dati.DataFineIndagine
			,dati.CFOpsFinanziario	
			,T_Persona.IdPersona
INTO #documenti
FROM dati
LEFT JOIN (SELECT IdPersona, CodiceFiscale, chiavecliente, RowNum = ROW_NUMBER() OVER (PARTITION BY CodiceFiscale ORDER BY IdPersona DESC) 
			FROM T_Persona WHERE CodCliente = 23) T_Persona ON CodiceFiscaleDE = T_Persona.CodiceFiscale
			AND T_Persona.RowNum = 1

--SELECT * FROM #Documenti



BEGIN TRY 

IF NOT EXISTS (SELECT * FROM #Documenti)
BEGIN
	SET @RED_Note = 'Nessun Subincarico da inserire'
END
ELSE 
BEGIN

DECLARE @IdPersona INT
,@CognomeDE VARCHAR(100)
,@NomeDE VARCHAR(100)
,@CodiceFiscaleDE VARCHAR(50)
,@ndgDE VARCHAR(50)
,@CodiceRichiesta VARCHAR(100)
,@DataRichiesta VARCHAR(20)
,@CodiceOrganoProcedente VARCHAR(100)
,@StrutturaRichiedente VARCHAR(200)
,@StrutturaAutorizzante VARCHAR(200)
,@DataInizioIndagine VARCHAR(20)
,@DataFineIndagine VARCHAR(20)
,@CFOpsFinanziario	VARCHAR(100)
,@IdSubincarico INT

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR

SELECT  IdPersona, CognomeDE, NomeDE, CodiceFiscaleDE , ndgDE	
																
,CodiceRichiesta
,DataRichiesta
,CodiceOrganoProcedente
,StrutturaRichiedente
,StrutturaAutorizzante
,DataInizioIndagine
,DataFineIndagine
--,CFOpsFinanziario

FROM #Documenti
WHERE ndgDE is NOT NULL OR ISNUMERIC(ndgDE) = 1
GROUP BY IdPersona, CognomeDE, NomeDE, CodiceFiscaleDE , ndgDE
,CodiceRichiesta
,DataRichiesta
,CodiceOrganoProcedente
,StrutturaRichiedente
,StrutturaAutorizzante
,DataInizioIndagine
,DataFineIndagine
--,CFOpsFinanziario

OPEN cur

FETCH NEXT FROM cur INTO @IdPersona, @CognomeDE, @NomeDE, @CodiceFiscaleDE, @ndgDE
,@CodiceRichiesta 
,@DataRichiesta
,@CodiceOrganoProcedente 
,@StrutturaRichiedente 
,@StrutturaAutorizzante 
,@DataInizioIndagine 
,@DataFineIndagine 
--,@CFOpsFinanziario	


WHILE @@FETCH_STATUS = 0 BEGIN

		IF EXISTS ( SELECT * FROM T_R_Incarico_SubIncarico tris
					JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore v ON tris.IdSubIncarico = v.IdIncarico
					JOIN T_Incarico sub ON tris.IdSubIncarico = sub.IdIncarico
					WHERE tris.IdIncarico = @IdIncarico
						AND  v.idpersona = @IdPersona
						AND sub.CodCliente = 23
						--AND sub.CodArea = 8
						AND sub.CodTipoIncarico = 549
						AND sub.CodStatoWorkflowIncarico <> 440
				)

		BEGIN
        	SET @RED_Note = @RED_Note +  ' Esiste già un subincarico Segnalazione PEC associato a ' + @CognomeDE + ' ' + @NomeDE  + CHAR(10)
        END

		ELSE 
			BEGIN
				DECLARE @IdIncaricoGestito INT = (SELECT ti.IdIncarico	FROM T_Incarico ti
													JOIN T_Antiriciclaggio ta ON ti.IdIncarico = ta.IdIncarico
													AND ta.NotaConclusivaCompilatore LIKE '%Codice Univoco della Richiesta: ' + @CodiceRichiesta + '%'
													JOIN T_R_Incarico_SubIncarico ON ti.IdIncarico = T_R_Incarico_SubIncarico.IdSubIncarico
													WHERE ti.CodArea = 8
													AND ti.CodCliente = 23
													AND ti.CodTipoIncarico = 549
													AND T_R_Incarico_SubIncarico.IdIncarico <> @IdIncarico
												)
				IF @IdIncaricoGestito IS NOT NULL
				BEGIN
                	PRINT 'Ho trovato codice richiesta in un altro incarico'
					IF NOT EXISTS (SELECT * FROM T_Documento
								JOIN #documenti on T_Documento.IdDocumentoOrigine = #documenti.Documento_id
								AND IdIncarico = @IdIncaricoGestito
								AND FlagPresenzaInFileSystem = 1
								AND FlagScaduto = 0
								)
					BEGIN                    	
                    
					INSERT INTO T_Documento (T_Pratica_id, Tipo_Documento,  CodOrigineDocumento,  Nome_file,   FlagGenerazioneInCorso, FlagPresenzaInFileSystem, FlagIlleggibile, FlagSospettaFrode, FlagIncompleto, FlagScaduto, FlagInserimentoCompletato, FlagIntegrazione, FlagFax,  Dimensione, DataAcquisizione, DataInserimento, IdRepository, CodEsitoDataEntry,  DataSpedizione, DataRicezione, IdIncarico, IdAtc, NomeFileOriginale, IdOperatoreInserimento, IdPosizioneArchivio, CodOrigineDocumentoImbarcato, CodRichiedenteDocumento, IdDocumentoOrigine, DataAssegnazionePosizioneArchivio, CodiceArchivioFreddo, NumRichiestePratica, HashMd5, IdScatolaArchivio, FlagFirmato, FlagControfirmato, FlagAnomalo)
					SELECT
						T_Pratica_id,Tipo_Documento,CodOrigineDocumento	
						,Nome_file		
						,FlagGenerazioneInCorso	,FlagPresenzaInFileSystem,FlagIlleggibile,FlagSospettaFrode,FlagIncompleto,FlagScaduto,FlagInserimentoCompletato	,FlagIntegrazione	,FlagFax,Dimensione	
						,GETDATE() DataAcquisizione
						,GETDATE() DataInserimento		
						,IdRepository,FlagSbloccato	,DataSpedizione	,DataRicezione				
						,@IdIncaricoGestito IdIncarico				
						,IdAtc,NomeFileOriginale		
						,21 IdOperatoreInserimento		
						,NULL IdPosizioneArchivio,CodOrigineDocumentoImbarcato	,CodRichiedenteDocumento
						,#Documenti.Documento_id IdDocumentoOrigine
						,NULL DataAssegnazionePosizioneArchivio	,CodiceArchivioFreddo	,NumRichiestePratica	,HashMd5	,NULL IdScatolaArchivio	,FlagFirmato	,FlagControfirmato,FlagAnomalo
					FROM T_Documento
						JOIN #documenti ON T_Documento.Documento_id = #Documenti.Documento_id
						AND ndgDE = @ndgDE 
				END

				SET @RED_Note = @RED_Note + CHAR(10) + 'Rilevato ed inserito su incarico già gestito ' + CAST(@IdIncaricoGestito as VARCHAR(20)) + ' Documento con codice univoco richiesta ' + @CodiceRichiesta
				END

				/* 
				BUGFIX 2020-06-11 Riconoscere Ente Segnalante 
				from: andriola to: fiori  INCARICO 15097202 - SEGNALAZIONI CANALE PEC (AZIMUT) 
				*/



				/********************************************************************************/

				ELSE 
				BEGIN
				
				PRINT 'Devo creare incarico intestato a ' + @CognomeDE + ' ' + @NomeDE

				--Creo Incarico
					PRINT 'creo incarico'
					PRINT @ndgDE	
					PRINT ISNUMERIC(@ndgde)	
					PRINT @IdIncarico			
					INSERT into T_Incarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, CodStatoWorkflowIncarico, FlagUrgente, DataCreazione, DataUltimaModifica, DataUltimaTransizione, ChiaveCliente, FlagAttesa, CodArea, FlagArchiviato)
					SELECT  DISTINCT
					 CodCliente, CodTipoIncarico, CodTipoWorkflow, 6500, FlagUrgente, GETDATE(), GETDATE(), GETDATE(), 
					IIF(ISNUMERIC(@ndgDE) = 1,CAST(CAST(@ndgDE as INT) AS VARCHAR(20)),@ndgDE)
					, FlagAttesa, CodArea, FlagArchiviato
					FROM T_Incarico
					WHERE IdIncarico = @IdIncarico
				
				--Associo l'incarico creato al subincarico
					SET @IdSubincarico = (SELECT SCOPE_IDENTITY())					
					PRINT 'associo subincarico'
					SET @RED_Note = @RED_Note + 'Creato Subincarico ' + CAST(@IdSubincarico as VARCHAR(50)) + CHAR(10)
					
					INSERT into T_R_Incarico_SubIncarico (IdIncarico, IdSubIncarico, FlagArchiviato)
					VALUES (@IdIncarico, @IdSubincarico, 0);

				--Log Della transizione creazione
				PRINT 'L_Workflow'
					INSERT INTO L_WorkflowIncarico (IdIncarico, IdOperatore, DataTransizione, CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgenteDestinazione, FlagManuale, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodAreaPartenza, CodAreaDestinazione)
						SELECT
							IdIncarico
							,21 IdOperatore
							,DataCreazione DataTransizione
							,CodTipoWorkflow
							,NULL CodStatoWorkflowIncaricoPartenza
							,NULL FlagUrgentePartenza
							,6500 CodStatoWorkflowIncaricoDestinazione
							,FlagUrgente FlagUrgenteDestinazione
							,0 FlagManuale
							,NULL CodAttributoIncaricoPartenza
							,CodAttributoIncarico CodAttributoIncaricoDestinazione
							,NULL FlagAttesaPartenza
							,FlagAttesa FlagAttesaDestinazione
							,NULL CodAreaPartenza
							,CodArea CodAreaDestinazione							
						FROM T_Incarico
						WHERE IdIncarico = @IdSubincarico
	
					--Clono Tab Antiriciclaggio
					PRINT 'T_Antiriciclaggio'
				
	INSERT INTO T_Antiriciclaggio (IdIncarico, CodMotivoVerifica, CodEnteSegnalante, CodAltroEnteSegnalante, NotaConclusivaCompilatore)
	SELECT 	@IdSubincarico
			,CodMotivoVerifica

			/* 
			BUGFIX 2020-06-11 Riconoscere Ente Segnalante 
			from: andriola to: fiori  INCARICO 15097202 - SEGNALAZIONI CANALE PEC (AZIMUT) 
			*/
			,(SELECT TOP 1 CASE CFOpsFinanziario
				WHEN '04631200963' THEN 5 --az capital
				WHEN '04316120965' THEN 8 --az life
				END  FROM #documenti WHERE IdPersona = @IdPersona  
				ORDER BY Documento_id ASC
			 )	CodEnteSegnalante
			,IIF((SELECT COUNT(IdPersona) FROM #documenti WHERE IdPersona = @IdPersona) > 1
				,(SELECT TOP 1
					CASE CFOpsFinanziario
					WHEN '04631200963' THEN 5 --az capital
					WHEN '04316120965' THEN 8 --az life
					END
					FROM #documenti
				 WHERE IdPersona = @IdPersona ORDER BY Documento_id DESC
				)
				,NULL) CodAltroEnteSegnalante
			/************************************************************************************/

			,'Codice Univoco della Richiesta: '+ @CodiceRichiesta + char(10) +
			'Data richiesta: ' + @DataRichiesta + CHAR(10) + 
			'Struttura Richiedente: ' + @StrutturaRichiedente + CHAR(10) +
			'Struttura Autorizzante: ' + @StrutturaAutorizzante + char(10) + 
			'Codice Organo Procedente: '+ @CodiceOrganoProcedente + char(10) + 
			'Data Inizio Indagine: ' + @DataInizioIndagine + CHAR(10) + 
			'Data Fine Indagine: ' + @DataFineIndagine
		FROM T_Antiriciclaggio
		WHERE T_Antiriciclaggio.IdIncarico = @IdIncarico

				--Popolo Tab Persona
				IF @IdPersona is NULL AND @CodiceFiscaleDE IS NOT NULL
				AND @CognomeDE is NOT NULL and @NomeDE IS NOT NULL
			
				BEGIN
				PRINT 'Persona non censita su db'
				INSERT INTO T_Persona (ChiaveCliente, Cognome, Nome, CodiceFiscale,  CodCliente,  CodTipoPersona,  FlagCancellato, FlagPresenteDocumentazioneFatca, FlagPresenteDocumentazioneCrs)
				SELECT
					@ndgDE ChiaveCliente
					,@CognomeDE Cognome
					,@NomeDE Nome
					,@CodiceFiscaleDE CodiceFiscale
					,23 CodCliente
					,1 CodTipoPersona
					,0 FlagCancellato
					,0 FlagPresenteDocumentazioneFatca
					,0 FlagPresenteDocumentazioneCrs
					
					SET @IdPersona = (SELECT SCOPE_IDENTITY())	
				
				PRINT 'Associo persona censita'		
				INSERT INTO T_R_Incarico_Persona (IdIncarico, IdPersona, Progressivo, CodRuoloRichiedente, DataInizioRapporto)
				VALUES (@IdSubincarico, @IdPersona, 1, 11, NULL);
				
END
				ELSE IF @IdPersona IS NULL 
				BEGIN
                	SET @RED_Note = @RED_Note + 'Chiave Cliente ' + @ndgDE + ' non presente su QTask. Inserire cortesemente nel Form DE anche il nome, cognome e codice fiscale e riprovare.' + char(10)
                END
				ELSE
				BEGIN
				PRINT 'Associo persona sull''incarico'
				INSERT INTO T_R_Incarico_Persona (IdIncarico, IdPersona, Progressivo, CodRuoloRichiedente, DataInizioRapporto)
					VALUES (@IdSubincarico, @IdPersona, 1, 11, NULL);
                END
					
						
				--Clono Documenti di interesse
				PRINT 'Documenti'
					INSERT INTO T_Documento (T_Pratica_id, IdAmministrazione, Tipo_Documento, Id_Referente, CodOrigineDocumento, DescrizioneCEI, Nome_file, Note, Originale, FlagGenerazioneInCorso, FlagPresenzaInFileSystem, FlagIlleggibile, FlagSospettaFrode, FlagIncompleto, FlagScaduto, FlagScadutoAutomaticamente, FlagImbarcatoScaduto, FlagInserimentoCompletato, FlagIntegrazione, FlagFax, NumImport, Dimensione, DataAcquisizione, DataInserimento, IdRepository, CodEsitoDataEntry, FlagSbloccato, DataSpedizione, DataRicezione, IdIncarico, IdAtc, NomeFileOriginale, IdOperatoreInserimento, IdPosizioneArchivio, CodOrigineDocumentoImbarcato, CodRichiedenteDocumento, IdDocumentoOrigine, DataAssegnazionePosizioneArchivio, CodiceArchivioFreddo, NumRichiestePratica, HashMd5, IdScatolaArchivio, FlagFirmato, FlagControfirmato, FlagAnomalo)
	SELECT
		T_Pratica_id,IdAmministrazione,Tipo_Documento,Id_Referente,CodOrigineDocumento	,DescrizioneCEI
		,Nome_file	,NULL Note
		,Originale
		,FlagGenerazioneInCorso	,FlagPresenzaInFileSystem	,FlagIlleggibile	,FlagSospettaFrode	,FlagIncompleto	,FlagScaduto	,FlagScadutoAutomaticamente	,FlagImbarcatoScaduto	,FlagInserimentoCompletato	,FlagIntegrazione	,FlagFax	,NumImport	,Dimensione	
		,GETDATE() DataAcquisizione
		,GETDATE() DataInserimento		
		,IdRepository	,CodEsitoDataEntry	,FlagSbloccato	,DataSpedizione	,DataRicezione	
			
		,@IdSubincarico IdIncarico	
			
		,IdAtc,NomeFileOriginale		
		,21 IdOperatoreInserimento		
		,NULL IdPosizioneArchivio,CodOrigineDocumentoImbarcato	,CodRichiedenteDocumento
		,#Documenti.Documento_id IdDocumentoOrigine
		,NULL DataAssegnazionePosizioneArchivio	,CodiceArchivioFreddo	,NumRichiestePratica	,HashMd5	,NULL IdScatolaArchivio	,FlagFirmato	,FlagControfirmato,FlagAnomalo
	FROM T_Documento
	JOIN #Documenti
		ON T_Documento.Documento_id = #Documenti.Documento_id
	AND ndgDE = @ndgDE 

	IF (SELECT COUNT(*) FROM T_Documento tdoc
		JOIN #documenti on tdoc.IdDocumentoOrigine = #documenti.Documento_id
		WHERE tdoc.IdIncarico = @IdSubincarico
		) > 1
		BEGIN
        	UPDATE T_Antiriciclaggio
			SET CodAltroEnteSegnalante = 8 
			WHERE IdIncarico = @IdSubincarico
        END

	END


END

	FETCH NEXT FROM cur INTO @IdPersona, @CognomeDE, @NomeDE, @CodiceFiscaleDE, @ndgDE
	,@CodiceRichiesta 
	,@DataRichiesta
,@CodiceOrganoProcedente 
,@StrutturaRichiedente 
,@StrutturaAutorizzante 
,@DataInizioIndagine 
,@DataFineIndagine 
--,@CFOpsFinanziario	

	SET @RES_CodGiudizioControllo = 2
END

CLOSE cur
DEALLOCATE cur

END


SELECT  @RES_CodGiudizioControllo as CodGiudizioControllo,
             @RED_CodEsitoControllo  as CodEsitoControllo ,
             @RED_Note as Note

END TRY 

BEGIN CATCH

SET @RED_Note = 'Errore: inviare ad ORGA una segnalazione'
PRINT ERROR_MESSAGE()
SELECT
	@RES_CodGiudizioControllo AS CodGiudizioControllo
	,@RED_CodEsitoControllo AS CodEsitoControllo
	,@RED_Note AS Note

END CATCH


DROP TABLE #Documenti

GO