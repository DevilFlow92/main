--vt-btsql04
USE SELFID
GO

INSERT INTO S_Processo (DescrizioneProcesso, CodSistema, IdBanca, CodCliente, CodTipoIncarico, IdRegolaControllo, FunctionRecuperoCredenzialiFirma, IdParametriAutenticazioneNamirial, FlagPrecompilazioneEsclusivaOperatore, PercorsoRelativoTemplate, IdDatiAggiuntivi, IdAbilitazioneRiepilogoPratica, PercorsoImmaginiGuidaScattaFoto, FlagVisualizzaLoaderScattaFoto, FlagAbilitaLogInputCampiPrecompilazione)
SELECT 'AZ Previdenza Caselle Istituzionali', CodSistema, IdBanca, 23, 753,IdRegolaControllo, FunctionRecuperoCredenzialiFirma, IdParametriAutenticazioneNamirial, FlagPrecompilazioneEsclusivaOperatore, PercorsoRelativoTemplate, 2, IdAbilitazioneRiepilogoPratica, PercorsoImmaginiGuidaScattaFoto,FlagVisualizzaLoaderScattaFoto, FlagAbilitaLogInputCampiPrecompilazione
FROM S_Processo
WHERE IdProcesso = 24

SELECT * FROM s_processo WHERE idprocesso = 31

SELECT * FROM S_AbilitaIdentificazioneProcesso
WHERE IdProcesso = 24

SELECT * FROM 

SELECT * FROM T_TokenAccesso
WHERE IdIncarico = 8925856  

SELECT * FROM Z_TemplateDocumento

SELECT * FROM S_Modulo
WHERE IdModulo = 175



SELECT * FROM S_Modulo sm WHERE sm.IdModulo = 174						--(Modulo Questionario contenete la sezione)
SELECT * FROM S_Sezione ss WHERE ss.IdSezione = 463						--(sezione contenente le due domande)
SELECT * FROM S_Domanda sd WHERE sd.IdDomanda IN (649, 650)				--(domande richieste)
SELECT * FROM S_Risposta sr WHERE sr.IdRisposta IN (253, 254, 255, 256) --(risposte associate alle domande).

SELECT * FROM S_Processo
JOIN S_AbilitazioneUrlAccesso ON S_Processo.IdProcesso = S_AbilitazioneUrlAccesso.IdProcesso
JOIN S_UrlAccesso ON S_AbilitazioneUrlAccesso.IdUrlAccesso = S_UrlAccesso.IdUrlAccesso
JOIN S_ApiKeySpid ON S_UrlAccesso.IdApiKeySpid = S_ApiKeySpid.IdApiKeySpid
WHERE S_Processo.IdProcesso IN(24,31)

SELECT * FROM S_Processo
WHERE S_Processo.IdProcesso = 24

SELECT * FROM S_Modulo
WHERE IdModulo = 175

SELECT * FROM S_DatiAggiuntivi


SELECT * FROM R_Modulo_Sezione
JOIN S_Sezione ON R_Modulo_Sezione.IdSezione = S_Sezione.IdSezione
WHERE IdModulo = 175

SELECT * FROM R_Sezione_Domanda
JOIN S_Domanda ON R_Sezione_Domanda.IdDomanda = S_Domanda.IdDomanda
WHERE IdSezione = 464



SELECT * FROM R_Domanda_Risposta
JOIN S_Risposta ON R_Domanda_Risposta.IdRisposta = S_Risposta.IdRisposta
WHERE IdDomanda IN ( 650,651)


--INSERT INTO Z_Risposta_DocumentoSurrogante (IdRisposta, CodiceDocumento, CodSistema)
SELECT 257, 259719, 3 UNION
SELECT 258, 259720, 3 UNION
SELECT 259, 259721, 3 

SELECT * FROM Z_Risposta_DocumentoSurrogante

--INSERT INTO S_TemplateDocumento (Nome, FlagAbilita, FlagFirmaRichiesta, FlagFirmaSemplice, IdModulo, CodTipoFirma)
SELECT 'CESAM_AZ_Previdenza_FeedbackAknowledgement.docx', 1, 0,0,175,NULL


--INSERT INTO Z_TemplateDocumento (IdTemplateDocumento, CodiceTipoDocumento, CodSistema)
--	VALUES (108, 259748, 3);

SELECT * FROM Z_Domanda_Documento
WHERE IdDomanda = 651



SELECT * FROM [db-clc-prodbt].clc.dbo.D_Documento
ORDER BY codice DESC

--INSERT INTO Z_Domanda_Documento (IdDomanda, CodiceDocumento, CodiceGruppoDocumentiEquivalenti)
--SELECT 651, 259748, null 

/***** SETUP LATO CLC ************/

--DB-CLC-TESTINT
USE CLC

SELECT * FROM D_Documento
WHERE Codice IN (259748
				 ,259719
				 ,259720
				 ,259721
				 )

SELECT * FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodCliente = 23 AND CodTipoIncarico = 753
AND CodDocumento IN (259748
				 ,259719
				 ,259720
				 ,259721
				 )
/**************************** SETUP FASE LAVORAZIONE INCARICO ************************/
SELECT * FROM R_Cliente_TipoIncarico_GenerazioneDocumentoRichiestoIncarico
JOIN S_FaseLavorazioneIncarico ON R_Cliente_TipoIncarico_GenerazioneDocumentoRichiestoIncarico.IdFaseLavorazioneIncarico = S_FaseLavorazioneIncarico.IdFaseLavorazioneIncarico
WHERE CodCliente = 23
AND CodTipoIncarico = 753



SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodCliente = 23 AND CodTipoIncarico = 753

--e' corretto inserire la fase lavorazione incarico 11 (Richiesta selfie) occorre censirne una nuova? Serve uno sviluppo?

/**************************** SETUP FASE LAVORAZIONE INCARICO ************************/

SELECT * FROM R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico
JOIN D_TipoWorkflowDocumentoRichiestoIncarico ON R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico.CodTipoWorkflowDocumentoRichiestoIncarico = D_TipoWorkflowDocumentoRichiestoIncarico.Codice
JOIN D_InterazioneSelfId ON D_TipoWorkflowDocumentoRichiestoIncarico.CodInterazioneSelfId = D_InterazioneSelfId.Codice
WHERE CodCliente = 23
AND CodTipoIncarico = 753

USE clc

--DELETE FROM R_Cliente_TipoIncarico_GenerazioneDocumentoRichiestoIncarico
--WHERE CodTipoDocumento IN (				 259719
--				 ,259720
--				 ,259721
--				 )

--DELETE FROM R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico
--WHERE CodTipoDocumento IN (				 259719
--				 ,259720
--				 ,259721
--				 )


SELECT * FROM app.K_DataModificaTabelle
WHERE nometabella LIKE '%gruppodocumentiequivalenti%' AND DataModifica >= '20210617 16:00'

SELECT * FROM s_processo
WHERE idprocesso = 24

SELECT * FROM [BTSQLCL05\BTSQLCL05].SELFID.dbo.s_processo
WHERE descrizioneprocesso = 'azimut'

SELECT * FROM R_GruppoDocumentiEquivalenti_TipoDocumento
WHERE CodGruppoDocumentiEquivalenti = 35



SELECT * FROM D_StatoDocumentoRichiesto


SELECT * FROM app.D_StatoWorkflowDocumentoRichiestoIncarico

SELECT * FROM R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico
JOIN D_TipoWorkflowDocumentoRichiestoIncarico ON R_Cliente_TipoIncarico_WorkflowDocumentoRichiestoIncarico.CodTipoWorkflowDocumentoRichiestoIncarico = D_TipoWorkflowDocumentoRichiestoIncarico.Codice
WHERE CodCliente = 23 AND CodTipoIncarico = 753

SELECT * FROM D_TipoWorkflowDocumentoRichiestoIncarico


SELECT * FROM app.D_StatoWorkflowDocumentoRichiestoIncarico
JOIN T_DocumentoRichiestoIncarico ON D_StatoWorkflowDocumentoRichiestoIncarico.Codice = T_DocumentoRichiestoIncarico.CodStatoWorkflowDocumentoRichiestoIncarico

WHERE IdIncarico = 8925856 

SELECT * FROM R_Cliente_TipoIncarico_OrigineDocumentoImbarcato
WHERE CodCliente = 23

SELECT * FROM app.D_StatoWorkflowDocumentoRichiestoIncarico