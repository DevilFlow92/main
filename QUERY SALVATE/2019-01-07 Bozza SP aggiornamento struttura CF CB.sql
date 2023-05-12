USE CLC
GO

/*
Author: Andrea Padricelli

*/



--ALTER PROCEDURE scratch.CESAM_CB_Import_Rete_CF AS

BEGIN

----------------------------------------
SET XACT_ABORT ON; 
SET NOCOUNT ON;
----------------------------------------

BEGIN

DECLARE @idimport int 
,@indirizzo VARCHAR(200)
,@cap VARCHAR(5)
,@citta VARCHAR(50)
,@provincia VARCHAR(2)
,@telufficio VARCHAR(50)
,@fax VARCHAR(50)
,@codice VARCHAR(50)	


DECLARE cur CURSOR STATIC FOR
--select del cursore
SELECT IndirizzoUfficio,CAPUfficio,CittaUfficio,ProvinciaUfficio,TelUfficio,Fax FROM scratch.CESAM_CB_Rete_CF
WHERE IndirizzoUfficio <> '' AND 
idCentroRaccolta IS NULL
GROUP by IndirizzoUfficio,CAPUfficio,CittaUfficio,ProvinciaUfficio,TelUfficio,Fax
ORDER by IndirizzoUfficio

OPEN cur
FETCH NEXT FROM cur INTO @indirizzo, @cap,@citta, @provincia, @telufficio, @fax
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------
SET @Codice = CAST((SELECT COALESCE(MAX(CAST(right(Codice, LEN(Codice)-CHARINDEX('B', Codice))AS INT)),0) FROM T_CentroRaccolta WHERE Codice LIKE 'CB%')+1 AS VARCHAR(50))

IF NOT EXISTS (SELECT T_CentroRaccolta.IdCentroRaccolta FROM T_CentroRaccolta
JOIN T_Promotore ON T_CentroRaccolta.IdCentroRaccolta = T_Promotore.IdCentroRaccolta
JOIN T_Persona ON T_Promotore.IdPersona = T_Persona.IdPersona
JOIN T_R_CentroRaccolta_Indirizzo ON T_CentroRaccolta.IdCentroRaccolta = T_R_CentroRaccolta_Indirizzo.IdCentroRaccolta
JOIN T_Indirizzo ON T_R_CentroRaccolta_Indirizzo.IdIndirizzo = T_Indirizzo.IdIndirizzo
WHERE CodCliente = 48 AND PrimaRiga = @indirizzo and Cap = @cap AND Localita = @citta AND SiglaProvincia = @provincia )
BEGIN
--censimento centro raccolta
INSERT into dbo.T_CentroRaccolta (IdAreaCentroRaccolta, Codice, Descrizione)
	VALUES (NULL, CAST('CB'+@codice AS VARCHAR(50)), CAST(@indirizzo+'-'+@citta AS VARCHAR(50)));

DECLARE @idcentroraccolta INT = SCOPE_IDENTITY()

INSERT into dbo.T_Contatto (Telefono, Fax, FlagAttivo, CodRuoloContatto)
	SELECT @telufficio, @fax, 1, 2

DECLARE @idcontatto INT = SCOPE_IDENTITY()

INSERT into dbo.T_R_CentroRaccolta_Contatto (IdCentroRaccolta, IdContatto)
	VALUES (@idcentroraccolta, @idcontatto);

INSERT into dbo.T_Indirizzo (IdPratica, CodTipoIndirizzo, PrimaRiga, SecondaRiga, Cap, Localita, SiglaProvincia, IdSedeAtc, CodStato)
	VALUES (NULL, 6, @indirizzo, NULL, @cap, @citta, @provincia, NULL, 119);

DECLARE @idindirizzo INT = SCOPE_IDENTITY()

INSERT into dbo.T_R_CentroRaccolta_Indirizzo (IdCentroRaccolta, IdIndirizzo)
	VALUES (@idcentroraccolta, @idindirizzo);
END

ELSE

BEGIN

SET @idcentroraccolta = (SELECT T_CentroRaccolta.IdCentroRaccolta FROM T_CentroRaccolta
JOIN T_Promotore ON T_CentroRaccolta.IdCentroRaccolta = T_Promotore.IdCentroRaccolta
JOIN T_Persona ON T_Promotore.IdPersona = T_Persona.IdPersona
JOIN T_R_CentroRaccolta_Indirizzo ON T_CentroRaccolta.IdCentroRaccolta = T_R_CentroRaccolta_Indirizzo.IdCentroRaccolta
JOIN T_Indirizzo ON T_R_CentroRaccolta_Indirizzo.IdIndirizzo = T_Indirizzo.IdIndirizzo
WHERE CodCliente = 48 AND PrimaRiga = @indirizzo and Cap = @cap AND Localita = @citta AND SiglaProvincia = @provincia)

END


UPDATE scratch.CESAM_CB_Rete_CF
SET idCentroRaccolta = @idcentroraccolta
WHERE IndirizzoUfficio = @indirizzo AND CAPUfficio = @cap AND CittaUfficio = @citta AND ProvinciaUfficio = @provincia

-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction all''IMPORT'+ CAST(@indirizzo as VARCHAR(200))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO  @indirizzo, @cap,@citta, @provincia, @telufficio, @fax
END

CLOSE cur
DEALLOCATE cur

END

--*/

--################################################
--################################################ CONSULENTE FINANZIARIO
--################################################


BEGIN

----------------------------------------
SET XACT_ABORT ON; 
SET NOCOUNT ON;
----------------------------------------
DECLARE @NDG_SEC VARCHAR(50)
,@CodiceUtente VARCHAR(50)
,@Ruolo VARCHAR(50)
,@Cognome VARCHAR(200)
,@Nome VARCHAR(200)
,@Manager VARCHAR(50)
,@MobileCF VARCHAR(50)
,@MailCF VARCHAR(50)
,@idcdr INT
,@idpersona INT
,@idpersonaricerca INT
,@idpersonapromotore INT

DECLARE cur CURSOR STATIC FOR
--select del cursore
SELECT scratchcf.NDG_SEC
,scratchcf.CodiceUtente
,scratchcf.Ruolo
,scratchcf.Cognome
,scratchcf.Nome
,scratchcf.Manager
, scratchcf.MobileCF
,scratchcf.MailCF
,scratchcf.idCentroRaccolta  
,T_Persona.IdPersona 
,T_Promotore.IdPersona personapromotore
FROM scratch.CESAM_CB_Rete_CF scratchcf
LEFT JOIN dbo.T_Promotore ON scratchcf.CodiceUtente = Codice
LEFT JOIN T_Persona ON T_Promotore.IdPersona = T_Persona.IdPersona AND ChiaveCliente = NDG_SEC
WHERE IdPromotore IS NULL OR T_Persona.IdPersona IS NULL



OPEN cur
FETCH NEXT FROM cur INTO @NDG_SEC, @CodiceUtente, @Ruolo, @Cognome, @Nome, @Manager , @MobileCF, @MailCF,@idcdr,@idpersonaricerca,@idpersonapromotore
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------
SET @idpersona = NULL

IF @idpersonaricerca IS NULL AND @idpersonapromotore IS NOT NULL
BEGIN

UPDATE T_Persona
SET ChiaveCliente = @NDG_SEC
WHERE IdPersona = @idpersonapromotore
	
	--ho censito su qtask il promotore senza ndg, i contatti li ho inseriti?
	IF EXISTS (SELECT * FROM T_Contatto WHERE IdPersona = @idpersonapromotore)
	BEGIN
		--disattivo ogni contatto presente a db per la persona
		UPDATE T_Contatto
		SET FlagAttivo = 0
		WHERE IdPersona = @idpersonapromotore
		
		--prendo il primo contatto censito a db per la persona, lo modifico con i dati del cursore e lo tengo attivo	
		 UPDATE T_Contatto
		 SET CodRuoloContatto = 1 --Contatto Principale
		 ,Cellulare = @MobileCF
		 ,Email = @MailCF
		 ,FlagAttivo = 1
		 WHERE IdContatto = (SELECT TOP 1 IdContatto
								FROM T_Contatto
								WHERE IdPersona = @idpersonapromotore)
	END
	ELSE
	BEGIN
		INSERT INTO dbo.T_Contatto (IdPersona, Email, Cellulare, FlagAttivo, CodRuoloContatto)
			VALUES (@idpersonapromotore, @MailCF, @MobileCF, 1, 1);
	END

UPDATE scratch.CESAM_CB_Rete_CF
SET DataAggiornamentoDB = GETDATE(), CodTipoAggiornamento = 2 --update persona
WHERE NDG_SEC = @NDG_SEC 
AND CodiceUtente = @CodiceUtente

END

else


BEGIN

IF NOT EXISTS (SELECT IdPersona FROM T_Persona where CodCliente = 48 AND ChiaveCliente = @NDG_SEC AND Nome = @Nome AND Cognome = @Cognome)
BEGIN
	
	INSERT INTO dbo.T_Persona (ChiaveCliente,cognome, Nome, CodStatoNascita, CodCliente, CodTipoPersona)
	SELECT @NDG_SEC, @Cognome, @Nome, 119, 48,1

set @idpersona  = SCOPE_IDENTITY()
END
ELSE
BEGIN

set @idpersona  = (SELECT TOP 1 IdPersona FROM T_Persona where CodCliente = 48 AND ChiaveCliente = @NDG_SEC AND Nome = @Nome AND Cognome = @Cognome)

END


INSERT into dbo.T_Promotore (IdPersona, IdCentroRaccolta, Codice,  RagioneSocialePromotore,  DescrizioneCanale)
	VALUES (@idpersona, @idcdr, @CodiceUtente,  @Cognome+' '+@Nome,  @Ruolo);

INSERT into dbo.T_Contatto (IdPersona, Email, Cellulare,FlagAttivo, CodRuoloContatto)
	VALUES (@idpersona, @MailCF, @MobileCF, 1, 1);

UPDATE scratch.CESAM_CB_Rete_CF
SET DataAggiornamentoDB = GETDATE(), CodTipoAggiornamento = 1 --inserimento completo
WHERE NDG_SEC = @NDG_SEC 
AND CodiceUtente = @CodiceUtente

END



-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction all''IMPORT'+ CAST(@NDG_SEC as VARCHAR(200))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO @NDG_SEC, @CodiceUtente, @Ruolo, @Cognome, @Nome, @Manager , @MobileCF, @MailCF,@idcdr,@idpersonaricerca,@idpersonapromotore
END

CLOSE cur
DEALLOCATE cur

END

END


SELECT 	idimport,
		NDG_SEC,
		CodiceUtente,
		Ruolo,
		Cognome,
		Nome,
		Manager,
		IndirizzoUfficio,
		CAPUfficio,
		CittaUfficio,
		ProvinciaUfficio,
		TelUfficio,
		MobileCF,
		Fax,
		MailCF,
		DataAggiornamentoDB,
		idCentroRaccolta,
		DataDelibera,
		CodTipoAggiornamento,
		NomeFileSorgente,
		NumeroDelibera FROM scratch.CESAM_CB_Rete_CF WHERE CodTipoAggiornamento IS NOT NULL

GO