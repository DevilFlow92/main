/*
Author: A. Padricelli
Description: restituisce un esito ko se il dataentry non è corretto
Date: 20170918

*/

--980380580
ALTER PROCEDURE controlli.CESAM_CB_Controllo_DataEntry (@IdRiga INT)
AS


--DECLARE @idriga INT 
--SET @idriga = --14253268    
----13584178
----13565121     
--15036673



BEGIN TRY


	DECLARE	@RES_CodGiudizioControllo INT
			,@RED_Note AS NVARCHAR(255)
			,@RED_CodEsitoControllo VARCHAR(5)

	--T Dichiarazione variabili generali di controllo

	DECLARE @Esito INT
	DECLARE @Note VARCHAR(MAX)
	SET @RES_CodGiudizioControllo = 2
	SET @RED_Note = 'Esito: £ $ # % | & ^ ì ò §'

	DECLARE @IdIncarico INT
	SET @IdIncarico = @IdRiga




	--      IF EXISTS (SELECT *from t_incarico
	--left join T_MacroControllo on T_MacroControllo.idincarico = t_incarico.idincarico
	--left join t_controllo on t_controllo.IdMacroControllo = T_MacroControllo.IdMacroControllo
	--where t_incarico.idincarico = @IdIncarico
	--and IdTipoControllo in  (1866) --verifica documentazione anagrafica

	--       )  
	--TRA I DUE SEPARATORI INSERIRE I COMANDI DELLA SP
	--===========================================================================================================

	BEGIN
		--dichiaro le variabili utilizzate all'interno della sp
		DECLARE	@IBAN_PAESE VARCHAR(2)
				,@IBAN_CIN VARCHAR(1)
				,@IBAN VARCHAR(50)
				,@IBAN_NUMERIC VARCHAR(22)
				,@ReferenceCodeDossier VARCHAR(50)
				,@ReferenceCodePortabilita VARCHAR(50)
				,@ReferenceCodeTDT VARCHAR(50)
				,@codtipoincarico INT
				,@ReferenceCodeKK VARCHAR(50)
				,@referencecodewebcoll VARCHAR(50)
				,@datasottoscrizionecontratto VARCHAR(50)
				,@datacreazioneincarico DATETIME

		--valorizzo le variabili
		SELECT
			@IBAN = REPLACE(REPLACE(REPLACE(REPLACE(IBAN.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
			,@IBAN_PAESE = LEFT(REPLACE(REPLACE(REPLACE(REPLACE(IBAN.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 2)
			,@IBAN_CIN = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(IBAN.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 5, 1)
			,@IBAN_NUMERIC = SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(IBAN.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 6, 22)
			,@referencecodedossier = REPLACE(ReferenceCodeDossier.Testo, CHAR(10), '')
			,@referencecodeportabilita = REPLACE(ReferenceCodePortabilita.Testo, CHAR(10), '')
			,@ReferenceCodeTDT = REPLACE(ReferenceCodeTDT.Testo, CHAR(10), '')
			,@ReferenceCodeKK = REPLACE(ReferenceCodeKK.Testo, CHAR(10), '')
			,@codtipoincarico = CodTipoIncarico
			,@referencecodewebcoll = REPLACE(ReferenceCodewebcoll.Testo, CHAR(10), '')
			,@datasottoscrizionecontratto = datasottoscrizionecontratto.Testo
			,@datacreazioneincarico = dbo.T_Incarico.DataCreazione
		FROM T_Incarico
		LEFT JOIN T_DatoAggiuntivo IBAN
			ON IBAN.IdIncarico = T_Incarico.IdIncarico
			AND IBAN.CodTipoDatoAggiuntivo = 643
			AND IBAN.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo ReferenceCodeDossier
			ON ReferenceCodeDossier.IdIncarico = T_Incarico.IdIncarico
			AND ReferenceCodeDossier.CodTipoDatoAggiuntivo = 936
			AND ReferenceCodeDossier.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo ReferenceCodePortabilita
			ON ReferenceCodePortabilita.IdIncarico = T_Incarico.IdIncarico
			AND ReferenceCodePortabilita.CodTipoDatoAggiuntivo = 937
			AND ReferenceCodePortabilita.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo ReferenceCodeTDT
			ON ReferenceCodeTDT.IdIncarico = T_Incarico.IdIncarico
			AND ReferenceCodeTDT.CodTipoDatoAggiuntivo = 1020
			AND ReferenceCodeTDT.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo ReferenceCodeKK
			ON ReferenceCodeKK.IdIncarico = T_Incarico.IdIncarico
			AND ReferenceCodeKK.CodTipoDatoAggiuntivo = 1159
			AND ReferenceCodeKK.FlagAttivo = 1
		LEFT JOIN T_DatoAggiuntivo ReferenceCodewebcoll
			ON ReferenceCodewebcoll.IdIncarico = T_Incarico.IdIncarico
			AND ReferenceCodewebcoll.CodTipoDatoAggiuntivo = 1252
			AND ReferenceCodewebcoll.FlagAttivo = 1
		LEFT JOIN dbo.T_DatoAggiuntivo datasottoscrizionecontratto
			ON datasottoscrizionecontratto.IdIncarico = dbo.T_Incarico.IdIncarico
			AND datasottoscrizionecontratto.CodTipoDatoAggiuntivo = 1592
			AND datasottoscrizionecontratto.FlagAttivo = 1


		WHERE T_Incarico.IdIncarico = @IdIncarico

		--SELECT @IBAN,@IBAN_CIN,@IBAN_NUMERIC,@IBAN_PAESE
		--SELECT ISNUMERIC(@IBAN_CIN)
		--SELECT ISNUMERIC(@IBAN_PAESE)
		--select (CAST(PATINDEX('%[^0-9]%', @IBAN_NUMERIC) as BIT)) 
		--select (CAST(PATINDEX('%[^0-9]%', @IBAN_PAESE) as BIT))
		--SELECT @ReferenceCodePortabilita

		--controllo su IBAN
		IF EXISTS (SELECT
				Documento_id
			FROM T_Documento
			JOIN D_Documento
				ON Codice = Tipo_Documento
			WHERE IdIncarico = @IdIncarico
			AND CodOggettoControlli IN (44, 48, 45, 58,46)
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf') --documenti conto corrente


		BEGIN
		BEGIN
			IF @IBAN IS NULL
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '£', 'IBAN non popolato /')
			END
			ELSE
			IF (CAST(PATINDEX('%[^0-9]%', @IBAN_NUMERIC) AS BIT)) = 1 --Restituisce 1 quando c'è un carattere alfanumerico
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '£', 'IBAN caratteri sconosciuti /')
			END
			ELSE
			IF LEN(@IBAN) <> 27
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '£', 'IBAN Lunghezza /')
			END
			ELSE
			IF (CAST(PATINDEX('%[^0-9]%', @IBAN_CIN) AS BIT)) = 0
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '£', 'IBAN CIN errato /')
			END
			ELSE
			IF @IBAN_PAESE <> 'IT'
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '£', 'IBAN Paese errato /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, '£', 'IBAN ok /')
			END
		END
		BEGIN
		--data sottoscrizione contratto
				IF @datasottoscrizionecontratto IS NULL AND @datacreazioneincarico >= '20190730' AND @codtipoincarico = 331
			BEGIN 
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, 'ò', 'Data Sott Non popolato /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, 'ò', 'Data Sott ok /')
			END
		
		END
		END

			--controllo su reference code portabilità
		IF @codtipoincarico NOT IN (611,613)
		and EXISTS (SELECT
				Documento_id
			FROM T_Documento
			JOIN D_Documento
				ON Tipo_Documento = Codice
			WHERE IdIncarico = @IdIncarico
			AND CodOggettoControlli IN (46)
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf')
			AND (SELECT
				CodMacroStatoWorkflowIncarico
			FROM T_Incarico
			JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
				ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
				AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
				AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
			WHERE IdIncarico = @IdIncarico
			)
			<> 2 
		BEGIN
			IF @ReferenceCodePortabilita IS NULL
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '§', 'Ref Portabilità non popolato /')
			END
			ELSE
			IF ISNUMERIC(@ReferenceCodePortabilita) = 0
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '§', 'Ref Portabilità eliminare spazi /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, '§', 'Ref Portabilità ok /')
			END
		END

		--controllo su reference code dossier
		IF EXISTS (SELECT
				Documento_id
			FROM T_Documento
			JOIN D_Documento
				ON Tipo_Documento = Codice
			WHERE IdIncarico = @IdIncarico
			AND CodOggettoControlli IN (48)
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf')
			AND (SELECT
				CodMacroStatoWorkflowIncarico
			FROM T_Incarico
			JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
				ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
				AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
				AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
			WHERE IdIncarico = @IdIncarico
			AND T_Incarico.CodTipoIncarico = 331)
			<> 2 --dossier
		BEGIN
			IF @ReferenceCodeDossier IS NULL
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '$', 'Ref Dossier non popolato /')
			END
			ELSE
			IF ISNUMERIC(@ReferenceCodeDossier) = 0
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '$', 'Ref Dossier eliminare spazi /')
			END
			ELSE
			IF LEN(@ReferenceCodeDossier) NOT IN(9, 10)
			BEGIN

				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '$', 'Ref Dossier errato /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, '$', 'Ref Dossier ok /')
			END
		END

		--controllo su reference code carta di credito
		IF @codtipoincarico NOT in (611,613)
		and EXISTS (SELECT
				Documento_id
			FROM T_Documento
			JOIN D_Documento
				ON Tipo_Documento = Codice
			WHERE IdIncarico = @IdIncarico
			AND CodOggettoControlli IN (58)
			AND Tipo_Documento <> 20123
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf')
			AND (SELECT
				CodMacroStatoWorkflowIncarico
			FROM T_Incarico
			JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
				ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
				AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
				AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
			WHERE IdIncarico = @IdIncarico)
			<> 2 --dossier
		BEGIN
			IF @ReferenceCodeKK IS NULL
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '#', 'Ref KK non popolato /')
			END
			ELSE
			IF ISNUMERIC(@ReferenceCodeKK) = 0
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '#', 'Ref KK eliminare spazi /')
			END
			ELSE
			IF LEN(@ReferenceCodeKK) <> 10
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '#', 'Ref KK errato /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, '#', 'Ref KK ok /')
			END
		END


		--controllo su reference code TDT
		IF EXISTS (SELECT
				Documento_id
			FROM T_Documento
			JOIN D_Documento
				ON Tipo_Documento = Codice
			WHERE IdIncarico = @IdIncarico
			AND D_Documento.Codice = 8302
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf') --tdt
			AND (SELECT
				CodMacroStatoWorkflowIncarico
			FROM T_Incarico
			JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
				ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
				AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
				AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
			WHERE IdIncarico = @IdIncarico)
			<> 2
		BEGIN
			IF @ReferenceCodeTDT IS NULL
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '^', 'Ref TDT non popolato /')
			END
			--ELSE IF ISNUMERIC(@ReferenceCodeTDT) = 0
			--     BEGIN 
			--     SET @RES_CodGiudizioControllo = 4
			--     SET @RED_Note = REPLACE(@RED_Note,'^','Ref TDT eliminare spazi /')
			--     END
			ELSE
			IF LEN(@ReferenceCodeTDT) <> 18
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, '^', 'Ref TDT errato /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, '^', 'Ref TDT ok /')
			END
		END

		
		--controllo su reference code WEBCOLLABORATION
		IF @codtipoincarico NOT IN (611,613)
		and  EXISTS (SELECT
				Documento_id
			FROM T_Documento
			JOIN D_Documento
				ON Tipo_Documento = Codice
			WHERE IdIncarico = @IdIncarico
			AND D_Documento.Codice = 20002
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf') --webcollaboration
			AND (SELECT
				CodMacroStatoWorkflowIncarico
			FROM T_Incarico
			JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
				ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
				AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
				AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
			WHERE IdIncarico = @IdIncarico and dbo.T_Incarico.CodTipoIncarico != 331)
			<> 2
		BEGIN
			IF @referencecodewebcoll IS NULL
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, 'ì', 'Ref webcoll non popolato /')
			END
			
			ELSE
			IF LEN(@referencecodewebcoll) NOT IN (9,10)
			BEGIN
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = REPLACE(@RED_Note, 'ì', 'Ref webcoll errato /')
			END
			ELSE
			BEGIN
				SET @RED_Note = REPLACE(@RED_Note, 'ì', 'Ref webcoll ok /')
			END
		END


		--controllo su HBRETAIL associazione a persona
		IF @codtipoincarico NOT IN (611) AND
		NOT EXISTS (SELECT
				T_Persona.ChiaveCliente
				,CodiceFiscale
			FROM T_Incarico
			JOIN T_Documento
				ON T_Documento.IdIncarico = T_Incarico.IdIncarico
			JOIN T_DocumentoDataEntry
				ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
			JOIN T_Persona
				ON T_DocumentoDataEntry.IdPersona = T_Persona.IdPersona
			WHERE T_Incarico.IdIncarico = @IdIncarico
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf'
			AND Tipo_Documento = 10001
			GROUP BY	T_Persona.ChiaveCliente
						,CodiceFiscale)
			AND EXISTS (SELECT
				Documento_id
			FROM T_Documento
			WHERE Tipo_Documento = 10001
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND IdIncarico = @IdIncarico
			AND Nome_file LIKE '%.pdf') --se non è presente l'associazione persona ed esiste un hbretail
		BEGIN
			SET @RES_CodGiudizioControllo = 4
			SET @RED_Note = REPLACE(@RED_Note, '|', 'associare HBRETAIL a persona /')
		END

	
		--controllo su ndg e cf persona

		DECLARE	@ndg VARCHAR(50)
		,@codicefiscale VARCHAR(50)

		IF @codtipoincarico NOT IN (611,613) 
		BEGIN
       		IF (SELECT
				COUNT(T_Persona.ChiaveCliente)
			FROM T_Incarico
			JOIN T_Documento
				ON T_Documento.IdIncarico = T_Incarico.IdIncarico
			JOIN T_DocumentoDataEntry
				ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
			JOIN T_Persona
				ON T_DocumentoDataEntry.IdPersona = T_Persona.IdPersona
			WHERE T_Incarico.IdIncarico = @IdIncarico
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf'
			AND Tipo_Documento = 5589)
			<> (SELECT
				COUNT(Documento_id)
			FROM T_Documento
			WHERE Tipo_Documento = 5589
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND IdIncarico = @IdIncarico
			AND Nome_file LIKE '%.pdf'
			AND @codtipoincarico != 359) --se non è presente l'associazione persona ed esiste un doc identita
			
		BEGIN
			SET @RES_CodGiudizioControllo = 4
			SET @RED_Note = REPLACE(@RED_Note, '%', 'associare doc identita a persona /')
		END
		ELSE
		BEGIN				

			DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR 
			SELECT
				T_Persona.ChiaveCliente
				,CodiceFiscale
			FROM T_Incarico
			JOIN T_Documento
				ON T_Documento.IdIncarico = T_Incarico.IdIncarico
			JOIN T_DocumentoDataEntry
				ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
			JOIN T_Persona
				ON T_DocumentoDataEntry.IdPersona = T_Persona.IdPersona
	
			WHERE T_Incarico.IdIncarico = @IdIncarico
			AND FlagScaduto = 0
			AND FlagPresenzaInFileSystem = 1
			AND Nome_file LIKE '%.pdf'
			GROUP BY	T_Persona.ChiaveCliente
						,CodiceFiscale

			OPEN cur

			FETCH NEXT FROM cur INTO @ndg, @codicefiscale

			WHILE @@FETCH_STATUS = 0
			BEGIN

			--
			BEGIN		
				--ndg
				BEGIN
					IF ISNUMERIC(@ndg) = 0
					BEGIN
						SET @RES_CodGiudizioControllo = 4
						SET @RED_Note = REPLACE(@RED_Note, '%', 'NDG popola /')
						SET @RED_Note = REPLACE(@RED_Note, 'NDG ok /', 'NDG popola /')
					END
					ELSE
					IF LEN(@ndg) <> 9
					BEGIN
						SET @RES_CodGiudizioControllo = 4
						SET @RED_Note = REPLACE(@RED_Note, '%', 'NDG errato /')
						SET @RED_Note = REPLACE(@RED_Note, 'NDG ok /', 'NDG errato /')

					END
					ELSE
					BEGIN
						SET @RED_Note = REPLACE(@RED_Note, '%', 'NDG ok /')
					END
				END
				--codice fiscale
				BEGIN
					IF @codicefiscale IS NULL
					BEGIN
						SET @RES_CodGiudizioControllo = 4
						SET @RED_Note = REPLACE(@RED_Note, '&', 'CF popola /')
						SET @RED_Note = REPLACE(@RED_Note, 'CF ok /', 'CF popola /')
					END
					ELSE
					IF LEN(@codicefiscale) <> 16
					BEGIN
						SET @RES_CodGiudizioControllo = 4
						SET @RED_Note = REPLACE(@RED_Note, '&', 'CF errato /')
						SET @RED_Note = REPLACE(@RED_Note, 'CF ok /', 'CF errato /')
					END
					ELSE
					BEGIN
						SET @RED_Note = REPLACE(@RED_Note, '&', 'CF ok /')
					END
				END
				
			END
				--

				FETCH NEXT FROM cur INTO @ndg, @codicefiscale

			END

			CLOSE cur
			DEALLOCATE cur

		END
		
		END
	
		ELSE 
		BEGIN	
		IF (SELECT
		COUNT(T_Persona.ChiaveCliente)
		FROM T_Incarico
		JOIN T_Documento
		ON T_Documento.IdIncarico = T_Incarico.IdIncarico
		JOIN T_DocumentoDataEntry
		ON T_Documento.Documento_id = T_DocumentoDataEntry.IdDocumento
		JOIN T_Persona
		ON T_DocumentoDataEntry.IdPersona = T_Persona.IdPersona
		WHERE T_Incarico.IdIncarico = @IdIncarico
		AND FlagScaduto = 0
		AND FlagPresenzaInFileSystem = 1
		AND Nome_file LIKE '%.pdf'
		AND Tipo_Documento IN ( 5589 --Documento d'identità - Codice Fiscale
		,9	--Codice fiscale (fotocopia)
		,7003	--Documento di identità
		,20699	--Specimen di firma
		,20718	--Patente
		)

		)
		<> (SELECT
			COUNT(Documento_id)
		FROM T_Documento
		WHERE Tipo_Documento IN ( 5589 --Documento d'identità - Codice Fiscale
		,9	--Codice fiscale (fotocopia)
		,7003	--Documento di identità
		,20699	--Specimen di firma
		,20718	--Patente
		)
		AND FlagScaduto = 0
		AND FlagPresenzaInFileSystem = 1
		AND IdIncarico = @IdIncarico
		AND Nome_file LIKE '%.pdf'
		) --se non è presente l'associazione persona ed esiste un doc identita

		BEGIN
			SET @RES_CodGiudizioControllo = 4
			SET @RED_Note = REPLACE(@RED_Note, '%', 'associare documenti a persona /')
		END
        ELSE 
		BEGIN

		DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR SELECT
			T_Persona.ChiaveCliente
			,CodiceFiscale
		FROM T_Persona
		JOIN T_R_Incarico_Persona ON T_Persona.IdPersona = T_R_Incarico_Persona.IdPersona
		
		WHERE T_R_Incarico_Persona.IdIncarico = @IdIncarico
	
		GROUP BY	T_Persona.ChiaveCliente
					,CodiceFiscale

		OPEN cur

		FETCH NEXT FROM cur INTO @ndg, @codicefiscale

		WHILE @@FETCH_STATUS = 0
		BEGIN

		--
		BEGIN
			--ndg
			BEGIN
				IF ISNUMERIC(@ndg) = 0
				BEGIN
					SET @RES_CodGiudizioControllo = 4
					SET @RED_Note = REPLACE(@RED_Note, '%', 'NDG popola /')
					SET @RED_Note = REPLACE(@RED_Note, 'NDG ok /', 'NDG popola /')
				END
				ELSE
				IF LEN(@ndg) <> 9
				BEGIN
					SET @RES_CodGiudizioControllo = 4
					SET @RED_Note = REPLACE(@RED_Note, '%', 'NDG errato /')
					SET @RED_Note = REPLACE(@RED_Note, 'NDG ok /', 'NDG errato /')

				END
				ELSE
				BEGIN
					SET @RED_Note = REPLACE(@RED_Note, '%', 'NDG ok /')
				END
			END
			--codice fiscale
			BEGIN
				IF @codicefiscale IS NULL
				BEGIN
					SET @RES_CodGiudizioControllo = 4
					SET @RED_Note = REPLACE(@RED_Note, '&', 'CF popola /')
					SET @RED_Note = REPLACE(@RED_Note, 'CF ok /', 'CF popola /')
				END
				ELSE
				IF LEN(@codicefiscale) <> 16
				BEGIN
					SET @RES_CodGiudizioControllo = 4
					SET @RED_Note = REPLACE(@RED_Note, '&', 'CF errato /')
					SET @RED_Note = REPLACE(@RED_Note, 'CF ok /', 'CF errato /')
				END
				ELSE
				BEGIN
					SET @RED_Note = REPLACE(@RED_Note, '&', 'CF ok /')
				END
			END

		END
			--

			FETCH NEXT FROM cur INTO @ndg, @codicefiscale

		END

		CLOSE cur
		DEALLOCATE cur
        END
	END
	END
	--===========================================================================================================



	SELECT
		IIF(@ndg IS NULL AND @codtipoincarico = 359, '4', @RES_CodGiudizioControllo) AS CodGiudizioControllo
		,@RED_CodEsitoControllo AS CodEsitoControllo
		,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@RED_Note, '£', ''), '$', ''), '%', ''), '&', ''), '|', ''), '^', ''), '#', ''), 'ì', ''),'ò',''),'§','') AS Note



END TRY

BEGIN CATCH
	PRINT 'Errore: inviare ad ORGA una segnalazione'
END CATCH

GO