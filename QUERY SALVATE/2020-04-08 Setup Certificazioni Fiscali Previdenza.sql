USE CLC
GO

/*

--incarico esempio
SELECT * FROM T_Incarico where IdIncarico = 12149044

--CodTipoIncarico
--401

--Etichette documento disponibili per il tipoincarico Certificazioni Fiscali
SELECT * FROM R_Cliente_TipoIncarico_TipoDocumento
JOIN D_Documento on CodDocumento = D_Documento.Codice
WHERE CodCliente = 23 --azimut
AND CodTipoIncarico = 401

--Template comunicazione (email) disponibili per il tipoincarico
SELECT r.IdTemplateComunicazione, stc.CodTipoComunicazione, dtc.Descrizione TipoComunicazione
,stc.FlagConfermaInvio
FROM R_TemplateComunicazione_StatoWorkflowIncarico r
JOIN S_TemplateComunicazione stc ON stc.IdTemplate = r.IdTemplateComunicazione
JOIN D_TipoComunicazione dtc ON dtc.Codice = stc.CodTipoComunicazione
WHERE r.CodCliente = 23
AND r.CodTipoIncarico = 401

--IdTemplatecomunicazione 12135 Certificazioni Fiscali


--setup per l'invio automatico
-- 1) FlagConfermaInvio = 0 nella S_TemplateComunicazione
-- 2) Setup nella seguente tabella:

SELECT * FROM R_TemplateComunicazione_ValutazioneDatiIncarico
WHERE IdTemplateComunicazione = 12135

-- 3) Invia la mail a transizione in Gestita - Comunicazione Inviata
SELECT 	r.IdRelazione
		,r.IdTemplateComunicazione
		,r.CodStatoWorkflowPartenza
		,r.FlagUrgentePartenza
		,r.CodAttributoPartenza
		,r.CodStatoWorkflowDestinazione
		,dmacro.Descrizione + ' - ' + dstato.Descrizione StatoWorkflowIncaricoDestinazione
		,r.FlagUrgenteDestinazione
		,r.CodAttributoDestinazione
		,r.CodCliente
		,r.CodTipoIncarico
		,r.FlagCreazione FROM R_TemplateComunicazione_TransizioneIncarico r
JOIN D_StatoWorkflowIncarico dstato ON dstato.Codice = r.CodStatoWorkflowDestinazione
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rctims ON r.CodStatoWorkflowDestinazione = rctims.CodStatoWorkflowIncarico
AND r.CodCliente = rctims.CodCliente
AND r.CodTipoIncarico = rctims.CodTipoIncarico
JOIN D_MacroStatoWorkflowIncarico dmacro ON rctims.CodMacroStatoWorkflowIncarico = dmacro.Codice
WHERE r.CodCliente = 23 
AND r.CodTipoIncarico = 401
AND IdTemplateComunicazione = 12135

--Setup per l'inserimento di allegati in automatico per l'invio mail

SELECT * FROM R_TemplateComunicazione_Documento
WHERE IdTemplateComunicazione = 12135
--AND CodDocumento =  1558



*/

--Setup controllo presenza contatto principale

SELECT * FROM R_TemplateComunicazione_Documento
WHERE IdTemplateComunicazione = 12135

UPDATE R_TemplateComunicazione_Documento
SET Ordinamento = NULL
WHERE IdTemplateComunicazione = 12135


--BEGIN TRANSACTION

--DECLARE @IdMacroControllo INT
--,@IdControllo INT

--INSERT into S_MacroControllo
--SELECT  CodCliente, 401 CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento, CodCategoriaMacroControllo, CodiceGruppo
--FROM S_MacroControllo
--WHERE IdMacroControllo = 2680

--SET @IdMacroControllo = (SELECT SCOPE_IDENTITY())

--INSERT INTO S_Controllo 
--SELECT
--	CodDatoAssociabile
--	,@IdMacroControllo IdTipoMacroControllo
--	,NomeStoredProcedure,FlagEsitoNonDefinito,FlagEsitoPositivo	,FlagEsitoPositivoConRiserva,FlagEsitoNegativo,FlagNotaObbligatoria	,Descrizione
--	,TestoHelp	,CodEsitoControlloDefault	,NomeStoredProcedurePreparatoria	,Ordinamento	,CodTipoRilievoControlloDefault	,FlagSolaLettura
--	,FlagCommenti	,FlagCommentiObbligatori	,CodCategoriaControllo	,NomeStoredProcedureInfoRilevanti	,FlagDettaglioEspanso
--FROM S_Controllo
--WHERE IdTipoMacroControllo = 2680

--SET @IdControllo = (SELECT SCOPE_IDENTITY())

--INSERT into R_Transizione_MacroControllo 
--SELECT
--	23 CodCliente
--	,401 CodTipoIncarico
--	,null CodStatoWorkflowIncaricoPartenza
--	,null CodAttributoIncaricoPartenza
--	,null FlagUrgentePartenza
--	,null FlagAttesaPartenza
--	,6500 CodStatoWorkflowIncaricoDestinazione
--	,null CodAttributoIncaricoDestinazione
--	,null FlagUrgenteDestinazione
--	,null FlagAttesaDestinazione
--	,@IdMacroControllo IdTipoMacroControllo
--	,1 FlagCreazione

--INSERT INTO R_EsitoControllo_BloccoTransizione	
--SELECT
--	23 CodCliente
--	,401 CodTipoIncarico
--	,null CodAttributoIncaricoPartenza
--	,null CodAttributoIncaricoDestinazione
--	,NULL CodStatoWorkflowIncaricoPartenza
--	,11435 CodStatoWorkflowIncaricoDestinazione
--	,null FlagUrgentePartenza
--	,null FlagUrgenteDestinazione
--	,null FlagAttesaPartenza
--	,null FlagAttesaDestinazione
--	,4 CodGiudizioControllo
--	,NULL CodEsitoControllo
--	,@IdControllo IdControllo
--	,NULL IdMacroControllo
--	,1 FlagAbilitaBlocco


SELECT
	*
FROM S_MacroControllo
JOIN S_Controllo
	ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo
WHERE CodCliente = 23
AND CodTipoIncarico = 401

--ROLLBACK TRANSACTION

--COMMIT TRANSACTION

SELECT * FROM app.D_DatoAssociabile WHERE Descrizione LIKE '%contro%'

SELECT * FROM R_Cliente_TipoIncarico_DatoAssociabile
WHERE CodCliente = 23
AND CodTipoIncarico = 401
AND CodDatoAssociabile = 32

--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile 
--SELECT CodCliente, CodTipoIncarico,32 CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili
--FROM R_Cliente_TipoIncarico_DatoAssociabile
--WHERE IdRelazione = 8918


SELECT * FROM D_AttributoIncarico
WHERE Descrizione LIKE '%aggiorna control%'

--1194	Aggiorna Controlli


SELECT * FROM R_Cliente_Attributo
WHERE CodCliente = 23
AND CodTipoIncarico = 401
AND CodAttributo = 1194

USE CLC
--INSERT INTO R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
--	VALUES (23, 401, 1194);


INSERT into R_Transizione_MacroControllo 
SELECT
	CodCliente
	,CodTipoIncarico
	, CodStatoWorkflowIncaricoPartenza
	,CodAttributoIncaricoPartenza
	, FlagUrgentePartenza
	, FlagAttesaPartenza
	,NULL CodStatoWorkflowIncaricoDestinazione
	,1194 CodAttributoIncaricoDestinazione
	, FlagUrgenteDestinazione
	, FlagAttesaDestinazione
	,IdTipoMacroControllo
	,0 FlagCreazione
FROM R_Transizione_MacroControllo
WHERE IdRelazione = 5002
