USE CLC
GO

--ALTER FUNCTION orga.CheckListDocumentale_CheBanca_Asset
-- (@TipoDocumentoPrincipale INT
--	,@TipoIncarico  INT
--	, @idincarico int
--	)
--RETURNS @documenti TABLE (

--	tipodocumento INT
--	,idpersona INT
--	,FlagPersona SMALLINT
--)
--AS
BEGIN

DECLARE @Tipoincarico INT	
		,@idincarico INT 

SET @TipoIncarico = 331
SET @idincarico = 10241050

	DECLARE @documenti TABLE ( tipodocumento INT
	,idpersona INT
	,FlagPersona SMALLINT
)

	DECLARE @TipoDocumentoPrincipale INT	--, @TipoIncarico  INT, @ProgressivoClienti  INT
	SET @TipoDocumentoPrincipale = 8275
	--SET @TipoIncarico = 331
	--SET @ProgressivoClienti = 2

	/*	APERTURA CONTO
	,8275	--Modulo di apertura Conto Yellow
			,8398	--Modulo di apertura Conto Deposito .
			,8397	--Modulo di apertura Conto Digital .
			,8399	--Modulo di apertura CC Business .
			,10025	--Modulo di apertura Conto Tascabile .
			,20062	--Modulo di apertura Carta di Credito
	
	*/

	IF (@TipoDocumentoPrincipale IN (8275, 8276))  --Modulo di apertura Conto Yellow
		BEGIN
         
		INSERT INTO @documenti 
			SELECT
				documenti.tipodocumento,
				v.idpersona,
				1 AS FlagPersona
			FROM rs.v_CESAM_Anagrafica_Cliente_Promotore v
			JOIN (SELECT	5589 tipodocumento,	@idincarico IdIncarico	UNION ALL	--Documento d’identità – codice fiscale
				  SELECT	8258 tipodocumento, @idincarico IdIncarico	UNION ALL	--Dichiarazione primo contatto
				  SELECT	8257 tipodocumento, @idincarico IdIncarico  			--Informativa regole di comportamento del consulente

			) documenti	ON documenti.IdIncarico = v.IdIncarico
			
			UNION ALL
			SELECT	8275,	null , 0 as FlagPersona UNION ALL --Modulo di apertura Conto Yellow
			SELECT	8276,	null , 0 as FlagPersona UNION ALL --Documento di Sintesi Frontespizio Conto Yellow
			SELECT	20157,	null , 0 as FlagPersona			  --Attestato avvenuta consegna informativa pre-contrattuale
			
		 END

	IF (@TipoDocumentoPrincipale IN (8398, 8384))	--Modulo di apertura Conto Deposito
		INSERT INTO @documenti
			SELECT
				8398, NULL, 0
			UNION ALL --Modulo di apertura Conto Deposito
			SELECT
				8384, NULL, 0
			UNION ALL		--Documento di Sintesi Frontespizio Conto Deposito
			SELECT
				20157, NULL, 0  --Attestato avvenuta consegna informativa pre-contrattuale

	IF (@TipoDocumentoPrincipale IN (8397	--Modulo di apertura Conto Digital
		, 8383	--Documento di Sintesi Frontespizio Conto Digital
		, 10048))	--Attestato avvenuta consegna informativa pre-contrattuale Conto Digital))	--Modulo di apertura Conto Digital
		INSERT INTO @documenti
			SELECT
				8397, NULL, 0
			UNION ALL --Modulo di apertura Conto Digital
			SELECT
				8383, NULL, 0
			UNION ALL --Documento di Sintesi Frontespizio Conto Digital
			SELECT
				20157, NULL, 0 --Attestato avvenuta consegna informativa pre-contrattuale

	IF (@TipoDocumentoPrincipale IN (8399))	--Modulo di apertura CC Business
		INSERT INTO @documenti
			SELECT
				8399, NULL, 0
			UNION ALL--Modulo di apertura CC Business
			SELECT
				8276, NULL, 0
			UNION ALL --Documento di Sintesi Frontespizio Conto Yellow
			SELECT
				20157, NULL, 0 --Attestato avvenuta consegna informativa pre-contrattuale

	IF (@TipoDocumentoPrincipale IN (10025	--Modulo di apertura Conto Tascabile
		, 8385	--Documento di Sintesi Frontespizio Conto Tascabile
		, 20015)) --Attestato avvenuta consegna informativa pre-contrattuale Conto Tascabile
		INSERT INTO @documenti
			SELECT
				10025, NULL, 0
			UNION ALL	--Modulo di apertura Conto Tascabile
			SELECT
				8385, NULL, 0
			UNION ALL	--Documento di Sintesi Frontespizio Conto Tascabile
			SELECT
				20157, NULL, 0 --Attestato avvenuta consegna informativa pre-contrattuale

	IF (@TipoDocumentoPrincipale IN (20062	--Modulo di apertura Carta di Credito
		, 20063	--Richiesta Estinzione Carta Di Credito
		, 20094	--DDS Carta di Credito
		, 20093	--Condizioni Generali Carta di Credito
		))
		INSERT INTO @documenti
			SELECT
				20062, NULL, 0
			UNION ALL --Modulo di apertura Carta di Credito
			SELECT
				20063, NULL, 0
			UNION ALL --Richiesta Estinzione Carta Di Credito
			SELECT
				20094, NULL, 0
			UNION ALL --DDS Carta di Credito
			SELECT
				20093, NULL, 0	--Condizioni Generali Carta di Credito


	/* APERTURA DOSSIER
	
	8266	Richiesta Abilitazione Servizi di Investimento e Attivazione Deposito Strumenti Finanziari
	*/
	IF (@TipoDocumentoPrincipale IN (8266, 8267, 8265, 8261)) --Richiesta Abilitazione Servizi di Investimento e Attivazione Deposito Strumenti Finanziari
		INSERT INTO @documenti
			SELECT
				8266, NULL, 0
			UNION ALL --Richiesta Abilitazione Servizi di Investimento e Attivazione Deposito Strumenti Finanziari
			SELECT
				8267, NULL, 0
			UNION ALL --Documento di Sintesi Frontespizio Servizi di Investimento (Conto Yellow)
			SELECT
				8265, NULL, 0
			UNION ALL--Avvenuta consegna informativa pre-contrattuale Servizi Investimento
			SELECT
				8261, NULL, 0	--Questionario MIFID Persone Fisiche Fuori Sede


	SELECT * FROM @documenti
	JOIN D_Documento ON [@documenti].tipodocumento = Codice

	--RETURN



END

GO