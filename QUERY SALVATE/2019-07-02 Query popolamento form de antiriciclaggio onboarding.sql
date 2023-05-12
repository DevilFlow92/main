USE CLC
GO

--ALTER PROCEDURE controlli.CESAM_AZ_Antiriciclaggio_Popolamento_FormDE (@IdRiga INT)

--AS

/*
Author: Fiori L. 

*/

--declare @IdRiga INT = 4426858   

DECLARE @idincarico INT  = @IdRiga 

DECLARE @CodTipoIncarico INT = (SELECT CodTipoIncarico FROM T_Incarico where IdIncarico = @idincarico)

BEGIN

----------------------------------------
SET XACT_ABORT ON;
SET NOCOUNT ON;
----------------------------------------


DECLARE @idDocumento INT
,@idDocumentoDataEntry INT
,@tipoIncarico INT


,@RED_Note NVARCHAR(MAX)

--set puntamenti
SET @tipoIncarico = (SELECT CodTipoIncarico from T_Incarico where idincarico = @idIncarico)
--SET @tipoDocumento = 8309
SET @idDocumento = (SELECT MAX(Documento_id) FROM T_Documento where idincarico = @idIncarico AND Tipo_Documento IN (251255	--AZ-Form Data Entry Documento
                                                                                                                    ) 
                                                                                                     AND FlagPresenzaInFileSystem = 1 
                                                                                                                    AND FlagScaduto = 0
                                                                                                                    )

DECLARE @listaiddocumentodataentry AS TABLE (iddocumentodataentry INT)

--SET @idDocumentoDataEntry = (SELECT MAX(IdDocumentoDataEntry) FROM T_DocumentoDataEntry WHERE IdDocumento = @idDocumento)

INSERT into @listaiddocumentodataentry (iddocumentodataentry)
SELECT MAX(IdDocumentoDataEntry) iddocdataentry FROM T_DocumentoDataEntry 
JOIN T_Documento on T_DocumentoDataEntry.IdDocumento = T_Documento.Documento_id
where idincarico = @idIncarico 
AND Tipo_Documento IN (251255	--AZ-Form Data Entry Documento
                      ) 
AND FlagPresenzaInFileSystem = 1 
AND FlagScaduto = 0
                                                                                                                    

GROUP BY IdIncarico, Tipo_Documento 

BEGIN
--trans table 
IF OBJECT_ID('tempdb.dbo.#tmpAntiriciclaggio') IS NOT NULL
	DROP TABLE #tmpAntiriciclaggio


CREATE TABLE #tmpAntiriciclaggio
(	CodTipoIncarico INT ,
	Tabella VARCHAR(100),
	NomeCampoTab VARCHAR(100),
	Datatype VARCHAR(20),
	NomeFormDE VARCHAR(max),
	CodTipoNotaIncarichi INT,
	CampoFiltro VARCHAR(100),
	--TabellaDescrittiva VARCHAR(100)
)

INSERT INTO #tmpAntiriciclaggio (CodTipoIncarico,Tabella, NomeCampoTab, Datatype, NomeFormDE, CodTipoNotaIncarichi, CampoFiltro)

	VALUES (112,'T_Antiriciclaggio','AreaPromotore','STRING','CLIENTE_PERSONA_FISICA1Soggetto_Incaricato1Area_geografica',null,'IdIncarico')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto',6982,'IdControllo')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire',6984,'IdControllo')
,(112,'T_DatiAggiuntiviPersona','CodNaturaRapporto','COD','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto',null,'IdPersona')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi',6983,'IdControllo')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati',6986,'IdControllo')
,(112,'T_Antiriciclaggio','FlagRilievoTrovato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Rilievo_trovato',null,'IdIncarico')
,(112,'T_Antiriciclaggio','FlagPresenzaListeTerroristi','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Presenza_liste_terroristi',null,'IdIncarico')
,(112,'T_DatiAggiuntiviPersona','FlagPepNazionaleVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_NAZIONALE',null,'IdPersona')
,(112,'T_DatiAggiuntiviPersona','FlagPepEsteroVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_ESTERO',null,'IdPersona')
,(112,'T_DatiAggiuntiviPersona','FlagPepCollegatiVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_COLLEGATI',null,'IdPersona')
,(112,'T_DatiAggiuntiviPersona','FlagSmarritoRubato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Smarrito/Rubato',null,'IdPersona')
,(112,'T_DatiAggiuntiviPersona','FlagScaduto','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Scaduto',null,'IdPersona')
,(112,'T_DatiAggiuntiviPersona','CodProfessione','COD','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Professione',null,'IdPersona')
,(112,'T_DatiAggiuntiviPersona','CodSettoreOccupazione','COD','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Settore_occupazione',null,'IdPersona')
,(112,'T_Antiriciclaggio','FlagVisuraCamerale','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Effettuata_visura_camerale',null,'IdIncarico')
,(112,'T_Antiriciclaggio','FlagApprofondimentoPf','BIT','CLIENTE_PERSONA_FISICA1Note_Di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato',null,'IdIncarico')
,(112,'T_Antiriciclaggio','FlagAstensioneArt23','BIT','CLIENTE_PERSONA_FISICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42',null,'IdIncarico')
,(112,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Natura_Giuridica',385,'IdNotaIncarichi')
,(112,'T_Antiriciclaggio','FlagVisuraCamerale','BIT','CLIENTE_PERSONA_GIURIDICA1_1Visura_camerale_conforme',null,'IdIncarico')
,(112,'T_DatiAggiuntiviPersona','CodAteco','COD','CLIENTE_PERSONA_GIURIDICA1_1Codice_Ateco',null,'IdPersona')
,(112,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Codice_Sensibile',386,'IdNotaIncarichi')
,(112,'T_DatiAggiuntiviPersona','CodSae','COD','CLIENTE_PERSONA_GIURIDICA1_1Codice_SAE',null,'IdPersona')
,(112,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Persona_Giuridica_Privata',387,'IdNotaIncarichi')
,(112,'T_NotaIncarichi','Testo','NOTE','CLIENTE_PERSONA_GIURIDICA1_1Ex_art._23',388,'IdNotaIncarichi')
,(112,'T_NotaIncarichi','Testo','NOTE','CLIENTE_PERSONA_GIURIDICA1_1Soggetto_iscritto_negli_Albi_tenuti_dalle_autorità_di_vigilanza_di_settore',389,'IdNotaIncarichi')
,(112,'T_Antiriciclaggio','AreaPromotore','STRING','CLIENTE_PERSONA_GIURIDICA1Soggetto_incaricato1Area_geografica',null,'IdIncarico')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto',6982,'IdControllo')
,(112,'T_DatiAggiuntiviPersona','CodNaturaRapporto','COD','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto',null,'IdPersona')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi',6983,'IdControllo')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire',6984,'IdControllo')
,(112,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati',6986,'IdControllo')
,(112,'T_Antiriciclaggio','FlagRilievoTrovato','BIT','CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Rilievo_trovato',null,'IdIncarico')
,(112,'T_Antiriciclaggio','FlagPresenzaListeTerroristi','BIT','CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Presenza_liste_terroristi',null,'IdIncarico')
,(112,'T_Antiriciclaggio','FlagApprofondimentoPf','BIT','CLIENTE_PERSONA_GIURIDICA1Note_di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato',null,'IdIncarico')
,(112,'T_Antiriciclaggio','FlagAstensioneArt23','BIT','CLIENTE_PERSONA_GIURIDICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42',null,'IdIncarico')
,(288,'T_Antiriciclaggio','AreaPromotore','STRING','CLIENTE_PERSONA_FISICA1Soggetto_Incaricato1Area_geografica',null,'IdIncarico')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto',5787,'IdControllo')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire',5789,'IdControllo')
,(288,'T_DatiAggiuntiviPersona','CodNaturaRapporto','COD','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto',null,'IdPersona')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi',5788,'IdControllo')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati',5791,'IdControllo')
,(288,'T_Antiriciclaggio','FlagRilievoTrovato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Rilievo_trovato',null,'IdIncarico')
,(288,'T_Antiriciclaggio','FlagPresenzaListeTerroristi','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Presenza_liste_terroristi',null,'IdIncarico')
,(288,'T_DatiAggiuntiviPersona','FlagPepNazionaleVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_NAZIONALE',null,'IdPersona')
,(288,'T_DatiAggiuntiviPersona','FlagPepEsteroVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_ESTERO',null,'IdPersona')
,(288,'T_DatiAggiuntiviPersona','FlagPepCollegatiVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_COLLEGATI',null,'IdPersona')
,(288,'T_DatiAggiuntiviPersona','FlagSmarritoRubato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Smarrito/Rubato',null,'IdPersona')
,(288,'T_DatiAggiuntiviPersona','FlagScaduto','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Scaduto',null,'IdPersona')
,(288,'T_DatiAggiuntiviPersona','CodProfessione','COD','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Professione',null,'IdPersona')
,(288,'T_DatiAggiuntiviPersona','CodSettoreOccupazione','COD','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Settore_occupazione',null,'IdPersona')
,(288,'T_Antiriciclaggio','FlagVisuraCamerale','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Effettuata_visura_camerale',null,'IdIncarico')
,(288,'T_Antiriciclaggio','FlagApprofondimentoPf','BIT','CLIENTE_PERSONA_FISICA1Note_Di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato',null,'IdIncarico')
,(288,'T_Antiriciclaggio','FlagAstensioneArt23','BIT','CLIENTE_PERSONA_FISICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42',null,'IdIncarico')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Natura_Giuridica',385,'IdNotaIncarichi')
,(288,'T_Antiriciclaggio','FlagVisuraCamerale','BIT','CLIENTE_PERSONA_GIURIDICA1_1Visura_camerale_conforme',null,'IdIncarico')
,(288,'T_DatiAggiuntiviPersona','CodAteco','COD','CLIENTE_PERSONA_GIURIDICA1_1Codice_Ateco',null,'IdPersona')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Codice_Sensibile',386,'IdNotaIncarichi')
,(288,'T_DatiAggiuntiviPersona','CodSae','COD','CLIENTE_PERSONA_GIURIDICA1_1Codice_SAE',null,'IdPersona')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Persona_Giuridica_Privata',387,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','NOTE','CLIENTE_PERSONA_GIURIDICA1_1Ex_art._23',388,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','NOTE','CLIENTE_PERSONA_GIURIDICA1_1Soggetto_iscritto_negli_Albi_tenuti_dalle_autorità_di_vigilanza_di_settore',389,'IdNotaIncarichi')
,(288,'T_Antiriciclaggio','AreaPromotore','STRING','CLIENTE_PERSONA_GIURIDICA1Soggetto_incaricato1Area_geografica',null,'IdIncarico')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto',5787,'IdControllo')
,(288,'T_DatiAggiuntiviPersona','CodNaturaRapporto','COD','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto',null,'IdPersona')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi',5788,'IdControllo')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire',5789,'IdControllo')
,(288,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati',5791,'IdControllo')
,(288,'T_Antiriciclaggio','FlagRilievoTrovato','BIT','CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Rilievo_trovato',null,'IdIncarico')
,(288,'T_Antiriciclaggio','FlagPresenzaListeTerroristi','BIT','CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Presenza_liste_terroristi',null,'IdIncarico')
,(288,'T_Antiriciclaggio','FlagApprofondimentoPf','BIT','CLIENTE_PERSONA_GIURIDICA1Note_di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato',null,'IdIncarico')
,(288,'T_Antiriciclaggio','FlagAstensioneArt23','BIT','CLIENTE_PERSONA_GIURIDICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42',null,'IdIncarico')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_I',391,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_II',392,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_III',393,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_IV',394,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_V',395,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_I',396,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_II',397,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_III',398,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_IV',399,'IdNotaIncarichi')
,(288,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_V',400,'IdNotaIncarichi')
,(396,'T_Antiriciclaggio','AreaPromotore','STRING','CLIENTE_PERSONA_FISICA1Soggetto_Incaricato1Area_geografica',null,'IdIncarico')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto',6997,'IdControllo')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire',6999,'IdControllo')
,(396,'T_DatiAggiuntiviPersona','CodNaturaRapporto','COD','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto',null,'IdPersona')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi',6998,'IdControllo')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati',7001,'IdControllo')
,(396,'T_Antiriciclaggio','FlagRilievoTrovato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Rilievo_trovato',null,'IdIncarico')
,(396,'T_Antiriciclaggio','FlagPresenzaListeTerroristi','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Presenza_liste_terroristi',null,'IdIncarico')
,(396,'T_DatiAggiuntiviPersona','FlagPepNazionaleVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_NAZIONALE',null,'IdPersona')
,(396,'T_DatiAggiuntiviPersona','FlagPepEsteroVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_ESTERO',null,'IdPersona')
,(396,'T_DatiAggiuntiviPersona','FlagPepCollegatiVerificato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_COLLEGATI',null,'IdPersona')
,(396,'T_DatiAggiuntiviPersona','FlagSmarritoRubato','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Smarrito/Rubato',null,'IdPersona')
,(396,'T_DatiAggiuntiviPersona','FlagScaduto','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Scaduto',null,'IdPersona')
,(396,'T_DatiAggiuntiviPersona','CodProfessione','COD','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Professione',null,'IdPersona')
,(396,'T_DatiAggiuntiviPersona','CodSettoreOccupazione','COD','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Settore_occupazione',null,'IdPersona')
,(396,'T_Antiriciclaggio','FlagVisuraCamerale','BIT','CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Effettuata_visura_camerale',null,'IdIncarico')
,(396,'T_Antiriciclaggio','FlagApprofondimentoPf','BIT','CLIENTE_PERSONA_FISICA1Note_Di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato',null,'IdIncarico')
,(396,'T_Antiriciclaggio','FlagAstensioneArt23','BIT','CLIENTE_PERSONA_FISICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42',null,'IdIncarico')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Natura_Giuridica',385,'IdNotaIncarichi')
,(396,'T_Antiriciclaggio','FlagVisuraCamerale','BIT','CLIENTE_PERSONA_GIURIDICA1_1Visura_camerale_conforme',null,'IdIncarico')
,(396,'T_DatiAggiuntiviPersona','CodAteco','COD','CLIENTE_PERSONA_GIURIDICA1_1Codice_Ateco',null,'IdPersona')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Codice_Sensibile',386,'IdNotaIncarichi')
,(396,'T_DatiAggiuntiviPersona','CodSae','COD','CLIENTE_PERSONA_GIURIDICA1_1Codice_SAE',null,'IdPersona')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1_1Persona_Giuridica_Privata',387,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','NOTE','CLIENTE_PERSONA_GIURIDICA1_1Ex_art._23',388,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','NOTE','CLIENTE_PERSONA_GIURIDICA1_1Soggetto_iscritto_negli_Albi_tenuti_dalle_autorità_di_vigilanza_di_settore',389,'IdNotaIncarichi')
,(396,'T_Antiriciclaggio','AreaPromotore','STRING','CLIENTE_PERSONA_GIURIDICA1Soggetto_incaricato1Area_geografica',null,'IdIncarico')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto',6997,'IdControllo')
,(396,'T_DatiAggiuntiviPersona','CodNaturaRapporto','COD','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto',null,'IdPersona')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi',6998,'IdControllo')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire',6999,'IdControllo')
,(396,'T_Controllo','Note','STRING','CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati',7001,'IdControllo')
,(396,'T_Antiriciclaggio','FlagRilievoTrovato','BIT','CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Rilievo_trovato',null,'IdIncarico')
,(396,'T_Antiriciclaggio','FlagPresenzaListeTerroristi','BIT','CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Presenza_liste_terroristi',null,'IdIncarico')
,(396,'T_Antiriciclaggio','FlagApprofondimentoPf','BIT','CLIENTE_PERSONA_GIURIDICA1Note_di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato',null,'IdIncarico')
,(396,'T_Antiriciclaggio','FlagAstensioneArt23','BIT','CLIENTE_PERSONA_GIURIDICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42',null,'IdIncarico')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_I',391,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_II',392,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_III',393,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_IV',394,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Titolari_Effettivi1Titolare_Effettivo_V',395,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_I',396,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_II',397,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_III',398,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_IV',399,'IdNotaIncarichi')
,(396,'T_NotaIncarichi','Testo','STRING','CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie_V',400,'IdNotaIncarichi')

;

END

--start of procedure

BEGIN

DECLARE @NomeFormDE VARCHAR(200)
,@ValoreFormDE VARCHAR(250)
--,@ValoreFormDE2 VARCHAR(250)
,@Tabella VARCHAR(100)
,@Campo VARCHAR(100)
,@CampoFiltro VARCHAR(100)

,@CodTipoNotaIncarichi INT 
,@FlagUpdate BIT
,@Comando nVARCHAR(MAX)

,@IdPersona INT = (SELECT idpersona FROM rs.v_CESAM_Anagrafica_Cliente_Promotore WHERE IdIncarico = @idincarico AND ProgressivoPersona = 1)

,@IdNota INT 

,@IdControllo INT

,@ValoreFiltro VARCHAR(20)


SET @RED_Note = ''

DECLARE cur CURSOR STATIC FOR

SELECT
	Nome
	,ValoreForm
	--,ValoreForm2
	,Tabella
	,NomeCampoTab
	,CampoFiltro
	,CodTipoNota
	,ISNULL([385], ISNULL([386], ISNULL([387], ISNULL([388], ISNULL([389], ISNULL([391],ISNULL([392],ISNULL([393],ISNULL([394],ISNULL([395],ISNULL([396],ISNULL([397],ISNULL([398],ISNULL([399],[400])))))))))))))) IdNota
	,IdControllo
FROM (SELECT
	L_DocumentoDataEntry.Nome
	,CASE Datatype
		WHEN 'BIT' THEN (
			CASE
				WHEN Valore = 'Sì' THEN '1'
				WHEN Valore = 'No' THEN '0'
				WHEN Valore LIKE 'N/A%' THEN NULL
				ELSE Valore
			END)
		WHEN 'cod' THEN --'4'
			--(CAST(D_NaturaRapporto.Codice AS VARCHAR(100)))
			CAST(ISNULL(D_NaturaRapporto.Codice,
			ISNULL(D_Professione.Codice,
			ISNULL(D_SettoreOccupazione.Codice, ISNULL(D_Sae.Codice, D_Ateco.Codice))))
			AS VARCHAR(10))
		WHEN 'NOTE' THEN IIF(Valore = 0,'No','Sì')
		ELSE Valore
	END AS ValoreForm
	--,IIF(Datatype = 'CODv',D_Ateco.Codice,Valore) ValoreForm2
	--,Valore ValoreForm2
	,#tmpAntiriciclaggio.Tabella
	,NomeCampoTab
	,CampoFiltro
	,#tmpAntiriciclaggio.CodTipoNotaIncarichi CodTipoNota
	,T_NotaIncarichi.CodTipoNotaIncarichi
	,IdNota
	,T_Controllo.IdControllo
	,IIF(T_Controllo.IdControllo IS NULL AND CampoFiltro = 'IdControllo', 1, 0) FlagEscludi
FROM L_DocumentoDataEntry
JOIN #tmpAntiriciclaggio
	ON L_DocumentoDataEntry.Nome = #tmpAntiriciclaggio.NomeFormDE
	AND CodTipoIncarico = @CodTipoIncarico
JOIN @listaiddocumentodataentry ls
	ON L_DocumentoDataEntry.IdDocumentoDataEntry = ls.iddocumentodataentry
	AND IdLog IN (SELECT
		MAX(IdLog)
	FROM L_DocumentoDataEntry
	JOIN #tmpAntiriciclaggio
		ON L_DocumentoDataEntry.Nome = #tmpAntiriciclaggio.NomeFormDE
	JOIN @listaiddocumentodataentry ls
		ON L_DocumentoDataEntry.IdDocumentoDataEntry = ls.iddocumentodataentry
	--WHERE IdDocumentoDataEntry = @idDocumentoDataEntry
	GROUP BY Nome)

LEFT JOIN T_DocumentoDataEntry
	ON L_DocumentoDataEntry.IdDocumentoDataEntry = T_DocumentoDataEntry.IdDocumentoDataEntry
LEFT JOIN T_Documento
	ON Documento_id = T_DocumentoDataEntry.IdDocumento
LEFT JOIN T_R_Incarico_Nota
	ON T_Documento.IdIncarico = T_R_Incarico_Nota.IdIncarico
	AND FlagAttiva = 1
LEFT JOIN T_NotaIncarichi
	ON T_NotaIncarichi.IdNotaIncarichi = T_R_Incarico_Nota.IdNota
	AND #tmpAntiriciclaggio.CodTipoNotaIncarichi = T_NotaIncarichi.CodTipoNotaIncarichi

LEFT JOIN (SELECT
	CAST(Codice AS VARCHAR(10)) Codice
	,Descrizione
FROM D_Professione) D_Professione
	ON Valore = D_Professione.Descrizione
LEFT JOIN (SELECT
	CAST(Codice AS VARCHAR(10)) Codice
	,Descrizione
FROM D_SettoreOccupazione) D_SettoreOccupazione
	ON Valore = D_SettoreOccupazione.Descrizione
LEFT JOIN (SELECT
	CAST(Codice AS VARCHAR(10)) Codice
	,Descrizione
FROM D_NaturaRapporto) D_NaturaRapporto
	ON Valore = D_NaturaRapporto.Descrizione

LEFT JOIN (SELECT
	CAST(Codice AS VARCHAR(10)) Codice
	,Descrizione
FROM D_Sae) D_Sae
	ON D_Sae.Codice = LEFT(REPLACE(Valore, CHAR(13) + CHAR(10), ''), IIF(CHARINDEX('-', REPLACE(Valore, CHAR(13) + CHAR(10), '')) = 0, 2, CHARINDEX('-', REPLACE(Valore, CHAR(13) + CHAR(10), ''))) - 2)

LEFT JOIN D_Ateco
	ON D_Ateco.Codice = LEFT(REPLACE(Valore, CHAR(13) + CHAR(10), ''), IIF(CHARINDEX('-', REPLACE(Valore, CHAR(13) + CHAR(10), '')) = 0, 2, CHARINDEX('-', REPLACE(Valore, CHAR(13) + CHAR(10), ''))) - 2)
--ORDER BY NomeCampoTab 

JOIN T_R_Incarico_Controllo
	ON T_Documento.IdIncarico = T_R_Incarico_Controllo.IdIncarico
LEFT JOIN T_Controllo
	ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
	AND IdTipoControllo = #tmpAntiriciclaggio.CodTipoNotaIncarichi) t
PIVOT (
MIN(IdNota)
FOR CodTipoNotaIncarichi IN ([385]
, [386]
, [387]
, [388]
, [389]
, [391]
, [392]
, [393]
, [394]
, [395]
, [396]
, [397]
, [398]
, [399]
, [400]


)

) p
WHERE FlagEscludi = 0


OPEN cur
FETCH NEXT FROM cur INTO @NomeFormDE, @ValoreFormDE, @Tabella, @Campo, @CampoFiltro, @CodTipoNotaIncarichi, @IdNota, @IdControllo
                    
WHILE @@fetch_status = 0
BEGIN
SET @FlagUpdate = 1
--SELECT @NomeFormDE, @ValoreFormDE,  @Tabella, @Campo, @CampoFiltro, @CodTipoNotaIncarichi, @IdNota, @IdControllo
-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------

IF @Tabella = 'T_Antiriciclaggio'
BEGIN
SET @ValoreFiltro = (select CAST(@idincarico as VARCHAR(20)))

	IF NOT EXISTS (SELECT * FROM T_Antiriciclaggio WHERE IdIncarico = @idincarico
	)
	BEGIN
		PRINT 'INSERT Tab Antiriciclaggio'
		SET @RED_Note = @RED_Note + CHAR(10) + 'Inserimento Tab Antiriciclaggio' + @Campo + ' = ' + CAST(@ValoreFormDE AS VARCHAR(100))
		SET @FlagUpdate = 0
		SET @Comando = 'INSERT INTO ' + @Tabella + '(IdIncarico,' + @Campo + ')'
		+ CHAR(10) + 'select ' + CAST(@idincarico AS VARCHAR(20)) + ',' + CAST(REPLACE(@ValoreFormDE,'''','''''') AS VARCHAR(100))
		
		EXEC sys.sp_executesql @Comando;
	
	END

END
ELSE IF @Tabella = 'T_NotaIncarichi'
BEGIN
SET @ValoreFiltro = (SELECT CAST(@IdNota AS VARCHAR(100)))

	IF NOT EXISTS (SELECT TOP 1 * FROM T_NotaIncarichi 
					JOIN T_R_Incarico_Nota ON IdNotaIncarichi = IdNota
					WHERE CodTipoNotaIncarichi = @CodTipoNotaIncarichi AND IdIncarico = @idincarico AND FlagAttiva = 1 )
	BEGIN
		PRINT 'Insert Nota Incarichi'
		SET @FlagUpdate = 0
		INSERT INTO T_NotaIncarichi (CodTipoNotaIncarichi, DataInserimento, IdOperatore, Testo)
		SELECT @CodTipoNotaIncarichi, GETDATE(),21,REPLACE(@ValoreFormDE,'''','''''')

		SET @IdNota = (select SCOPE_IDENTITY())
		INSERT into T_R_Incarico_Nota (IdIncarico, IdNota, FlagAttiva)
		VALUES (@idincarico, @IdNota, 1);

		SET @RED_Note = @RED_Note + CHAR(10) + 'Inserimento dati aggiuntivi su note blindate' 
	END
END
ELSE IF @Tabella = 'T_DatiAggiuntiviPersona'
BEGIN
SET @ValoreFiltro = (SELECT CAST(@IdPersona as VARCHAR(100)))

	IF @IdPersona IS NULL
	BEGIN
    	SET @FlagUpdate = 0
    END
END
ELSE IF @Tabella = 'T_Controllo'
BEGIN
SET @ValoreFiltro = (SELECT CAST(@IdControllo as VARCHAR(100)))
	IF @IdControllo is NULL
	BEGIN
    	SET @FlagUpdate = 0
    END
	
END


IF @FlagUpdate = 1
Begin
PRINT 'UPDATE' 
SET @Comando = 'UPDATE ' + @Tabella 
+ CHAR(10) + 'set ' + @Campo + ' = ' + IIF(@ValoreFormDE IS NULL,'NULL','''' + REPLACE(@ValoreFormDE,'''','''''') + '''')
 + CHAR(10) + 'where ' + @CampoFiltro + ' = ' + @ValoreFiltro

 PRINT @Comando
EXEC sys.sp_executesql @Comando;
SET @RED_Note = @RED_Note + CHAR(10) + 'Aggiornamento Tabella ' + @Tabella + ' ' + @Campo + ' = ' + CAST(@ValoreFormDE as VARCHAR(100))
END 

-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
       IF @@TRANCOUNT > 0
       BEGIN
       print 'rolling back transaction al nome '+ CAST(@NomeFormDE as VARCHAR(200))

       ROLLBACK
       END
END CATCH


FETCH NEXT FROM cur INTO   @NomeFormDE, @ValoreFormDE, @Tabella, @Campo, @CampoFiltro, @CodTipoNotaIncarichi, @IdNota, @IdControllo
END

CLOSE cur
DEALLOCATE cur

END


--select       @RES_CodGiudizioControllo as CodGiudizioControllo,
--             @RED_CodEsitoControllo  as CodEsitoControllo ,
--             @RED_Note as Note

SELECT 2 AS CodGiudizioControllo,
NULL AS CodEsitoControllo,
'ok' AS Note

DROP TABLE #tmpAntiriciclaggio

END

GO