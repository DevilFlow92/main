USE CLC_Cesam
GO

SELECT * FROM [DB-CLC-SETUPBT].CLC_Cesam.dbo.R_ProfiloAccesso_LimiteRigheRicerche
JOIN [DB-CLC-SETUPBT].CLC_Cesam.app.D_TipoRicerca ON R_ProfiloAccesso_LimiteRigheRicerche.CodTipoRicerca = D_TipoRicerca.Codice
JOIN [DB-CLC-SETUPBT].CLC_Cesam.app.D_DatoAssociabile ON R_Cliente_TipoIncarico_DatoAssociabile.CodDatoAssociabile = D_DatoAssociabile.Codice
WHERE codcliente = 302 AND CodTipoIncarico = 1001

SELECT * FROM R_Cliente_TipoIncarico_DatoAssociabile
JOIN app.D_DatoAssociabile ON R_Cliente_TipoIncarico_DatoAssociabile.CodDatoAssociabile = D_DatoAssociabile.Codice
WHERE CodCliente = 302 AND CodTipoIncarico = 1001

SELECT * FROM R_ProfiloAccesso_UrlSistemaCollegato

SELECT * FROM [DB-CLC-SETUPBT].CLC_Cesam.dbo.R_UrlAccesso_Abilitazione
JOIN [DB-CLC-SETUPBT].CLC_Cesam.dbo.S_UrlAccesso ON R_UrlAccesso_Abilitazione.IdUrlAccesso = S_UrlAccesso.IdUrlAccesso
WHERE CodCliente = 302

USE CLC_Cesam
SELECT * FROM R_UrlAccesso_Abilitazione
JOIN S_UrlAccesso ON R_UrlAccesso_Abilitazione.IdUrlAccesso = S_UrlAccesso.IdUrlAccesso
WHERE CodCliente = 23

SELECT * FROM R_TemplateComunicazione_StatoWorkflowIncarico
WHERE CodCliente = 302

SELECT * FROM S_TemplateComunicazione
WHERE IdTemplate = 18458

SELECT * FROM D_TipoComunicazione
WHERE Codice = 11236

SELECT * FROM R_Cliente_CategoriaComunicazione
WHERE CodCategoriaComunicazione = 4
AND CodCliente = 302

SELECT * FROM R_CategoriaComunicazione_Privilegio

WHERE CodCategoriaComunicazione = 4

SELECT * FROM R_ProfiloAccesso_CategoriaComunicazione
WHERE CodProfiloAccesso = 839
AND CodCategoriaComunicazione = 4

SELECT * FROM R_ProfiloAccesso_TipoComunicazione
WHERE CodProfiloAccesso = 2062

SELECT * FROM R_ProfiloAccesso_TemplateComunicazione
WHERE CodProfiloAccesso = 839


SELECT * FROM D_PrivilegioEsterno
WHERE Descrizione LIKE '%banca%'

SELECT * FROM S_UrlAccesso
WHERE Descrizione LIKE '%test%cesam%'


WITH codici AS (

SELECT Codice FROM [DB-CLC-SETUPBT].CLC_Cesam.dbo.D_TipoComunicazione
EXCEPT
SELECT codice FROM D_TipoComunicazione
)
--INSERT INTO D_TipoComunicazione (Codice, Descrizione, CodCategoriaComunicazione, Etichetta, TestoHelp, Ordinamento)
SELECT d.* FROM [DB-CLC-SETUPBT].CLC_Cesam.dbo.D_TipoComunicazione d
JOIN codici ON d.Codice = codici.Codice

--INSERT INTO D_TipoIncarico (Codice, Descrizione)
--	VALUES (1001, 'Rendicontazione KPI Vontobel');
 
 SELECT * FROM D_TipoIncarico
 WHERE Codice = 1001


--INSERT INTO D_TipoWorkflow (Codice, Descrizione)
--SELECT MAX(Codice + 1), 'WF Mikono' FROM D_TipoWorkflow


--INSERT INTO R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow
--, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster
--, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore
--, FlagMostraWorkflowSubincarichi)
--SELECT 302, 1001, 31656, 1, NULL, 1, NULL, 0, 1 


--INSERT INTO R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
SELECT 302, 1001, Codice
FROM D_Area
WHERE Codice IN (2,8)


--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita
--, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
SELECT 302, 1001, app.D_DatoAssociabile.Codice, NULL, 1,100
FROM app.D_DatoAssociabile
WHERE Codice IN (2,3,21,40,66)

--INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, FlagAbilita)
SELECT 2062, 302, 1 UNION
SELECT 839, 302, 1



--6500	Creata
--22601	Imbarco Report
--22497	Comunicazione inviata al cliente


--INSERT INTO R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico
--, Ordinamento)
--VALUES (302,1001,6500,12,1)
--,(302,1001,22601,9,2)
--,(302,1001,22497,14,3)


--INSERT INTO D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase
--, Ordinamento, TestoHelp, FlagScanCEI)
--SELECT 260397+1, 'Report KPI Vontobel', 'Report KPI Vontobel',158,0,1
--,'Report di riepilogo riconciliazioni in OK e KO per Vontobel.' + CHAR(10)
-- + 'Il file è inizialmente generato al mattino in automatico e poi integrato e convalidato da OPS.' + CHAR(10)
-- + 'Il suddetto allegato è da inviare ai Clienti Vontobel.'
--,0 UNION

--SELECT 260397+2, 'Riconciliazione Vontobel Contratti Dossier', 'Riconciliazione Vontobel Contratti Dossier', 158,0,1
--,'Riconciliazione giornaliera tra saldi Antana Contratti Dossier e saldi depositaria Vontobel.' + CHAR(10)
--+ 'Il suddetto allegato è da inviare ai Clienti Vontobel.'
--,0


--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza)
SELECT 302, 1001, Codice, 1
FROM D_Documento
WHERE codice IN (260398,260399)


--INSERT INTO D_PrivilegioEsterno (Codice, Descrizione)
SELECT MAX(codice) + 1, 'Visualizza oggetto controlli Report'
FROM D_PrivilegioEsterno

--INSERT INTO R_OggettoControlli_Privilegio (CodOggettoControlli, CodPrivilegio)
--	VALUES (158, 12074);

--INSERT INTO R_ProfiloAccesso_PrivilegioEsterno (CodProfiloAccesso, CodPrivilegioEsterno, FlagDisabilita)
--	VALUES (839, 12074, 0);

--INSERT INTO R_ProfiloAccesso_PrivilegioEsterno (CodProfiloAccesso, CodPrivilegioEsterno, FlagDisabilita)
--	VALUES (2062, 12074, 0);

--INSERT INTO R_Cliente_ProfiloAccesso_InserimentoIncarico (CodCliente, CodProfiloAccesso, CodTipoIncarico, FlagAbilitaInserimento)
--SELECT 302, 839, 1001, 1 union
--SELECT 302, 2062, 1001, 1

--INSERT INTO S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione
--, FlagCreazione)
--SELECT 31656, NULL, 6500, 1 UNION
--SELECT 31656, 6500, 22601,0 UNION
--SELECT 31656, 22601, 22497, 0 

--SELECT * FROM app.D_Silo

--4	Cesam

SELECT * FROM app.D_Silo
JOIN app.D_Modo ON D_Silo.Codice = D_Modo.CodSilo
WHERE CodSilo = 4

SELECT * FROM app.D_Modo
JOIN app.D_Ambiente ON D_Modo.CodAmbiente = D_Ambiente.Codice
WHERE CodSilo = 4

SELECT * FROM D_Cliente
JOIN R_UrlAccesso_Abilitazione ON D_Cliente.Codice = R_UrlAccesso_Abilitazione.CodCliente



--INSERT INTO R_UrlAccesso_Abilitazione (IdUrlAccesso, CodCliente)

SELECT R_UrlAccesso_Abilitazione.IdUrlAccesso, 302--, Url, NomeDns, Descrizione
FROM R_UrlAccesso_Abilitazione
JOIN S_UrlAccesso ON R_UrlAccesso_Abilitazione.IdUrlAccesso = S_UrlAccesso.IdUrlAccesso
WHERE codcliente = 23




--INSERT INTO S_ValutazioneDatiIncarico ( Descrizione, CodCliente, CodTipoIncarico, FlagAbilitaInvio, Priorita)
--SELECT  'MIKONO VONTOBEL KPI', 302, 1001, 1, 10

--INSERT INTO R_TemplateComunicazione_ValutazioneDatiIncarico (IdTemplateComunicazione, IdValutazioneDatiIncarico)
--	VALUES (18458, 1624);

/* dati aggiuntivi */
/*
DECLARE @Descrizione VARCHAR(100)
,@i SMALLINT = 1

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
SELECT 'KO Riconciliazione Contratti Dossier Presenti' union all
SELECT 'KO KPI Presenti'							   union all
select 'KP01_OKPostCorrezione'						   union all
select 'KP01_KO'									   union all
select 'KP02_OKPostCorrezione'						   union all
select 'KP02_KO'									   union all
select 'KP03_OKPostCorrezione'						   union all
select 'KP03_KO'									   union all
select 'KP04_OKPostCorrezione'						   union all
select 'KP04_KO'									   union all
select 'KP05_OKPostCorrezione'						   union all
select 'KP05_KO'									   union all
select 'KP06_OKPostCorrezione'						   union all
select 'KP06_KO'									   union all
select 'KP07_OKPostCorrezione'						   union all
select 'KP07_KO'									   union all
select 'KP08_OKPostCorrezione'						   union all
select 'KP08_KO'									   union all
select 'KP15_OKPostCorrezione'						   union all
select 'KP15_KO'									   union all
select 'KP16_OKPostCorrezione'						   union all
select 'KP16_KO'									   union all
select 'KP17_OKPostCorrezione'						   union all
select 'KP17_KO'									   union all
select 'KP18_OKPostCorrezione'						   union all
select 'KP18_KO'									   union all
select 'KP19_OKPostCorrezione'						   union all
select 'KP19_KO'									   union all
select 'KP20_OKPostCorrezione'						   union all
select 'KP20_KO'									   union all
select 'KP21_OKPostCorrezione'						   union all
select 'KP21_KO'									   union all
select 'KP22_OKPostCorrezione'						   union all
select 'KP22_KO'									   union all
select 'KP23_OKPostCorrezione'						   union all
select 'KP23_KO'									   union all
select 'KP24_OKPostCorrezione'						   union all
select 'KP24_KO'									   union all
select 'KP25_OKPostCorrezione'						   union all
select 'KP25_KO'									   union all
select 'KP26_OKPostCorrezione'						   union all
select 'KP26_KO'									   union all
select 'KP28_OKPostCorrezione'						   union all
select 'KP28_KO'									   union all
select 'KP29_OKPostVerifica'						   union all
select 'KP29_KO'									   union all
select 'KP34_SaldiTitoliKO'							   union all
select 'KP35_SaldiLiquiditaKO'

OPEN cur

FETCH NEXT FROM cur INTO @Descrizione

WHILE @@FETCH_STATUS = 0 BEGIN

	INSERT INTO D_TipoDatoAggiuntivo (Codice, Descrizione, CodFormatoDatoAggiuntivo)
	SELECT MAX(Codice) +1, @Descrizione,CASE WHEN @Descrizione NOT LIKE 'KP%' THEN 9 ELSE 4 END
	FROM D_TipoDatoAggiuntivo

	INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, Ordinamento)
	SELECT 302, 1001, MAX(Codice), @i
	FROM D_TipoDatoAggiuntivo

	SET @i = @i + 1

	FETCH NEXT FROM cur INTO @Descrizione

END

CLOSE cur
DEALLOCATE cur
*/


/*** fine dati aggiuntivi ***/


--INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo, ValoreLista)
SELECT 302, 1001, Codice, campi.Risp
FROM D_TipoDatoAggiuntivo
JOIN (SELECT 'Sì' Risp UNION SELECT 'No' Risp) AS campi
ON Codice IN (2880,2881)

--INSERT INTO R_DocumentoImbarcato_TransizioneIncarico (CodCliente, CodTipoIncarico, CodTipoDocumento,  CodStatoWorkflowIncaricoPartenza 
--, CodStatoWorkflowIncaricoDestinazione, FlagAbilita)
--SELECT 302,1001,260398,6500,22601,1


--INSERT INTO R_ProfiloAccesso_CategoriaComunicazione (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodCategoriaComunicazione, FlagVisualizza)
--	VALUES (839, 302, 1001, 4, DEFAULT),
--(2062, 302, 1001, 4, DEFAULT);


--INSERT INTO R_Cliente_CategoriaComunicazione (CodCliente, CodTipoIncarico, CodCategoriaComunicazione)
--SELECT 302,1001,4

SELECT * FROM S_TemplateComunicazione
WHERE IdTemplate = 18458

--UPDATE S_TemplateComunicazione
--SET FlagRinominaDocumenti = 1
--WHERE IdTemplate = 18458


--INSERT INTO R_Cliente_TipoIncarico_NomeDocumento (CodCliente, CodTipoIncarico, FlagNota, FlagAbilita
--, CodTipoDocumento, FlagNomeFileOriginale, FlagNomeFileOriginaleInInvio, FlagDownload)
--SELECT CodCliente, CodTipoIncarico, 0, 1, CodDocumento, 1,1,1
--FROM R_Cliente_TipoIncarico_TipoDocumento
--WHERE CodCliente = 302
--AND CodTipoIncarico = 1001


SELECT * FROM S_DestinatarioComunicazione
WHERE DestinatarioSpecifico LIKE '%cesam%'

SELECT * FROM D_TipoDestinatarioComunicazione

--SELECT * FROM S_DestinatarioComunicazione
--WHERE DestinatarioSpecifico LIKE '%fiori%'

--INSERT INTO S_DestinatarioComunicazione (Descrizione, CodTipoDestinatarioComunicazione
--, DestinatarioSpecifico
--, FlagEMail, FlagPec
--, CodTipoDestinatarioMail,
--FlagFax, FlagSms, FlagRol, FlagLol, FlagFtp, IdDestinatarioFtp, CodTipoIndirizzoPoste, CodRuoloContatto, FlagLolPrioritaria, CodRuoloRichiedenteDestinatario, CodRuoloOperatoreIncaricoDestinatario
--)
--SELECT 'DPE CESAM' Descrizione, CodTipoDestinatarioComunicazione
--,'DPE_CESAM@gruppomol.it' DestinatarioSpecifico
--, FlagEMail, FlagPec
--,3 CodTipoDestinatarioMail,
--FlagFax, FlagSms, FlagRol, FlagLol, FlagFtp, IdDestinatarioFtp, CodTipoIndirizzoPoste, CodRuoloContatto, FlagLolPrioritaria, CodRuoloRichiedenteDestinatario, CodRuoloOperatoreIncaricoDestinatario 
--FROM S_DestinatarioComunicazione
--JOIN R_TemplateComunicazione_DestinatarioComunicazione ON S_DestinatarioComunicazione.IdDestinatarioComunicazione = R_TemplateComunicazione_DestinatarioComunicazione.IdDestinatarioComunicazione
--WHERE IdTemplateComunicazione = 18458
--AND R_TemplateComunicazione_DestinatarioComunicazione.IdDestinatarioComunicazione = 6088

--INSERT INTO R_TemplateComunicazione_DestinatarioComunicazione (IdTemplateComunicazione, IdDestinatarioComunicazione)
--	VALUES (18458, 6089);


