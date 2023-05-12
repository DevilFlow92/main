USE clc

GO

/*
Authors: Fiori L.
Description: Restituisce KO se non sono presenti per la persona censita nell'incarico i seguenti campi:
nome, cognome, codice fiscale , chiave persona, ruolo richiedente
, tipo documento di identità, data di rilascio, data di scadenza, ente di rilascio, numero documento di identità
, stato di residenza, email, cellulare


*/
ALTER PROCEDURE controlli.CESAM_AZ_BeeWise_ControlloDEPersonaCensita (@IdRiga INT)
AS

--DECLARE @idriga INT
--SET @idriga = --8926994 
--8927398 

BEGIN TRY


	DECLARE @RES_CodGiudizioControllo INT
		   ,@RED_Note AS NVARCHAR(255)
		   ,@RED_CodEsitoControllo VARCHAR(5)


	SET @RES_CodGiudizioControllo = 4
	SET @RED_Note = ''

	DECLARE @IdIncarico INT = @IdRiga
	,@CodTipoIncarico SMALLINT
	,@CodStatoWorkflowIncarico INT


	--TRA I DUE SEPARATORI INSERIRE I COMANDI DELLA SP
	--===========================================================================================================


	IF OBJECT_ID('tempdb.dbo.#DatiPersona') IS NOT NULL
		DROP TABLE #DatiPersona;

	SELECT ti.IdIncarico
	,ti.CodTipoIncarico
	,ti.CodStatoWorkflowIncarico
	,anagrafica.NomeIntestatario
	,anagrafica.CognomeIntestatario
	,anagrafica.CodiceFiscaleIntestatario
	,anagrafica.ChiaveClienteIntestatario
	,anagrafica.codruolorichiedente
	,CodTipoDocumentoIdentita
	,DataEmissione
	,DataScadenza
	,CodEnteEmissioneDocumenti
	,Numero
	,Residenza.CodStato
	,ContattoEmail.Email
	,ContattoCellulare.Cellulare
	
	   
	 INTO #DatiPersona
	
	FROM T_Incarico ti
	JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON ti.IdIncarico = anagrafica.IdIncarico
	OUTER APPLY (
					SELECT TOP 1 tc1.Email
                    FROM T_Contatto tc1
					WHERE tc1.Email IS NOT NULL
					AND tc1.FlagAttivo = 1
					AND tc1.IdPersona = anagrafica.idpersona
					ORDER BY tc1.IdContatto DESC
	) ContattoEmail
	OUTER APPLY (
					SELECT TOP 1 tc2.Cellulare
                    FROM T_Contatto tc2
					WHERE tc2.Cellulare IS NOT NULL
					AND tc2.FlagAttivo = 1
					AND tc2.IdPersona = anagrafica.idpersona
					ORDER BY tc2.IdContatto DESC

	) ContattoCellulare
	LEFT JOIN T_DocumentoIdentita ON anagrafica.idpersona = T_DocumentoIdentita.IdPersona
	OUTER APPLY (
					SELECT TOP 1 tindx.IdIndirizzo, primariga, tindx.SecondaRiga, cap, tindx.Localita, tindx.SiglaProvincia, tindx.CodStato
                    FROM T_Indirizzo tindx
					JOIN T_R_Persona_Indirizzo trpix ON tindx.IdIndirizzo = trpix.IdIndirizzo
					WHERE trpix.DataFine IS NULL
					AND codtipoindirizzo = 2 --Residenza
					AND trpix.IdPersona = anagrafica.idpersona
					ORDER BY tindx.IdIndirizzo DESC				
	) Residenza
	WHERE ti.IdIncarico = @IdIncarico

	SET @codtipoincarico = (SELECT DISTINCT CodTipoIncarico FROM #datipersona)
	SET @CodStatoWorkflowIncarico = (SELECT DISTINCT codstatoworkflowincarico FROM #DatiPersona)
	--SELECT * FROM #DatiPersona
	--SELECT @CodStatoWorkflowIncarico
	IF @CodTipoIncarico = 776 
	BEGIN
    	PRINT 'Checklist per la visi'
		IF EXISTS (
					SELECT * FROM #DatiPersona
					WHERE NomeIntestatario IS NULL
					OR CognomeIntestatario IS NULL
					OR CodiceFiscaleIntestatario IS NULL
					OR ChiaveClienteIntestatario IS NULL
					OR codruolorichiedente IS NULL
					OR CodTipoDocumentoIdentita IS NULL
					OR DataEmissione IS NULL
					OR DataScadenza IS NULL
					OR CodEnteEmissioneDocumenti IS NULL
					OR Numero IS NULL
					OR CodStato IS NULL
					OR Email IS NULL
					OR Cellulare IS NULL
					

		)
		BEGIN
        	SET @RED_Note = @RED_Note + 'Sono mancanti per la persona associata i seguenti elementi:'
			SET @RED_Note = @RED_Note + 
				(
					SELECT IIF(NomeIntestatario IS NULL, CHAR(10) + '- Nome','')
					+ IIF(CognomeIntestatario IS NULL,CHAR(10) + '- Cognome','')
					+ IIF((CodiceFiscaleIntestatario IS NULL OR LEN(CodiceFiscaleIntestatario) <> 16), CHAR(10)+ '- Codice Fiscale','')
					+ IIF(ChiaveClienteIntestatario IS NULL,CHAR(10) + '- ChiaveCliente','')
					+ IIF(codruolorichiedente IS NULL,CHAR(10) + '- Ruolo Richiedente','')
					+ IIF(CodTipoDocumentoIdentita IS NULL,CHAR(10) + '- Tipo Documento Identità','')
					+ IIF(DataEmissione IS NULL,CHAR(10) +  '- Data Emissione Documento','')
					+ IIF(DataScadenza IS NULL, char(10) + '- Data Scadenza Documento','')
					+ IIF(CodEnteEmissioneDocumenti IS NULL,CHAR(10)+ '- Ente Emissione Documenti','')
					+ IIF(Numero IS NULL,CHAR(10) + '- Numero Documento','')
					+ IIF(CodStato IS NULL, CHAR(10) + '- Stato Residenza (censire indirizzo residenza sulla persona)','')
					+ IIF(Email IS NULL, CHAR(10) + '- Email (inserire tra i contatti della persona)','')
					+ IIF(Cellulare IS NULL, CHAR(10) + '- Cellulare (inserire tra i contatti della persona)','')

					FROM #DatiPersona
				)
        END
		ELSE IF @CodStatoWorkflowIncarico = 270 --Stato Workflow Completata Procedura Identificazione 
		AND NOT EXISTS (
							SELECT * 
							FROM T_Documento tdoc 
							WHERE tdoc.FlagPresenzaInFileSystem = 1
							AND tdoc.FlagScaduto = 0
							AND tdoc.Tipo_Documento = 259773 --Estratto VISI AML
							AND idincarico = @IdIncarico
		)
		BEGIN
        	SET @RED_Note = @RED_Note + 'Completata Identificazione ma documento da firmare mancante'

        END
		ELSE
		BEGIN
        	SET @RES_CodGiudizioControllo = 2
			SET @RED_Note = 'Presenti tutti i campi necessari / Incarico OK'
        END
    END
	ELSE
	BEGIN
    	PRINT 'Checklist Profili 4 coming soon'
    END

	SELECT
		@RES_CodGiudizioControllo AS CodGiudizioControllo
	   ,@RED_CodEsitoControllo AS CodEsitoControllo
	   ,@RED_Note AS Note


END TRY

BEGIN CATCH
	PRINT 'Errore: inviare ad ORGA una segnalazione'
END CATCH

DROP TABLE #DatiPersona

GO