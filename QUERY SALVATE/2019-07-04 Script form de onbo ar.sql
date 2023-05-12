USE clc
GO


SELECT * FROM orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE where CodFormDE = 116

IF OBJECT_ID('tempdb.dbo.#tmpFormDE') IS NOT NULL
	DROP TABLE #tmpFormDE


CREATE TABLE #tmpFormDE
(	id INT PRIMARY KEY IDENTITY,
	CodFormDE INT,
	Name VARCHAR(255),
	Value VARCHAR(50),
	type VARCHAR(50),
	Category VARCHAR(50),
	FieldValueOptionList VARCHAR(MAX)
)

--42 rows
INSERT into #tmpFormDE (CodFormDE, Name, Value, type, Category, FieldValueOptionList)
select 116,'CLIENTE_PERSONA_FISICA1_1Nome_e_Cognome','','STRING','DataEntry','' union ALL

select 116,'CLIENTE_PERSONA_FISICA1Soggetto_Incaricato1Area_geografica','','STRING','DataEntry','' union ALL

select 116,'CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto','','STRING','DataEntry','' union ALL

select 116,'CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire','','STRING','DataEntry','' union ALL

select 116,'CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto','','STRING','DataEntry','Investimento a medio/lungo termine;Investimento a breve termine;Finanziamento;Altro' union all

select 116,'CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Rilievo_trovato','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Presenza_liste_terroristi','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_NAZIONALE','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_ESTERO','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1PEP_COLLEGATI','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Smarrito/Rubato','','STRING','DataEntry','Sì;No;N/A (doc. id. estero)' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Documento_di_identità1Scaduto','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Professione','','STRING','DataEntry','Redditieri;Dirigenti Funz. sup.;Doc.Univers.Magistr.;Insegnanti di ruolo;Commercialisti;Avvocati Notai Medici;Geom.Rag. Periti;Agenti di assicurazione;Agenti rappresentanti;Consulenti aziendali;Coldiretti e simili;Disoccupati - Studenti;Medici ospedalieri;Impiegato/a;Operaio spec. paramedico;Operai comuni guardie;Temp.Det.Form.Lavoro;Militari ufficiali;Militari sotto ufficiali;Militari non graduati;Vigili del fuoco;Autotrasportatore;Artisti sportivi professionisti;Artigiano;Commerciante pubblico esercizio;Collaboratrice domestica;Lavoratore/trice a domicilio;Altro lavoratore/rice in proprio;Religiosi;Insegnanti non di ruolo;Politico;Ambulante;Autista;PENSIONATO;Casalinga;QUADRO/DIRIGENTE;IMPRENDITORE;Quadro' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Settore_occupazione','','STRING','DataEntry','Finanziario/Assicurativo;Pubblica Amministrazione;Servizi/Turismo;Artigianato/Commercio;Agricoltura;Industria;Altro' union all

select 116,'CLIENTE_PERSONA_FISICA1Verifica_Liste_Di_Controllo1Altro1Effettuata_visura_camerale','','STRING','DataEntry','Sì;No;N/A (soggetto non presente o non iscritto in CCIAA)' union all

select 116,'CLIENTE_PERSONA_FISICA1Note_Di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Esito_Analisi_AML1Parare_favorevole_all''apertura_del_rapporto','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_FISICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Ragione_Sociale','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Natura_Giuridica','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Visura_camerale_conforme','','STRING','DataEntry','Sì;No;N/A (soggetto non presente o non iscritto in CCIAA)' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Codice_Ateco','','STRING','DataEntry',(SELECT dbo.GROUP_CONCAT_D(Codice + ' - ' + Descrizione,';') FROM D_Ateco JOIN R_Cliente_TipoIncarico_Ateco ON D_Ateco.Codice = R_Cliente_TipoIncarico_Ateco.CodAteco WHERE CodCliente = 23) union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Codice_Sensibile','','STRING','DataEntry','Sì;No;N/A' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Codice_SAE','','STRING','DataEntry',(SELECT dbo.GROUP_CONCAT_D(CAST(Codice AS VARCHAR(10)) + ' - ' + Descrizione, ';') FROM D_Sae JOIN R_Cliente_TipoIncarico_Sae ON D_Sae.Codice = R_Cliente_TipoIncarico_Sae.CodSae WHERE CodCliente = 23) union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Persona_Giuridica_Privata','','STRING','DataEntry','Sì;No;N/A' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Ex_art._23','','BOOLEAN','DataEntry','Sì;No' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1_1Soggetto_iscritto_negli_Albi_tenuti_dalle_autorità_di_vigilanza_di_settore','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Soggetto_incaricato1Area_geografica','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Prodotto','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Ammontare_delle_somme_che_il_Cliente_intende_conferire','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Scopo_e_natura_del_rapporto','','STRING','DataEntry','Investimento a medio/lungo termine;Investimento a breve termine;Finanziamento;Altro' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Provenienza_fondi','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Informazioni_Sul_Potenziale_Rapporto1Mezzi_di_pagamento_utilizzati','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Titolare_Effettivo1Titolare_Effettivo','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Figure_Accessorie1Figure_Accessorie','','STRING','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Rilievo_trovato','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Verifica_Liste_di_Controllo1Presenza_liste_terroristi','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Note_di_Approfondimento_Soggetto_Incaricato1Note_di_approfondimento_soggetto_incaricato','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Esito_Analisi_AML1Parare_favorevole_all''apertura_del_rapporto','','BOOLEAN','DataEntry','' union all

select 116,'CLIENTE_PERSONA_GIURIDICA1Esito_Analisi_AML1Proposta_di_astensione_ex_art.42','','BOOLEAN','DataEntry','' 


--42 rows
INSERT INTO orga.S_FormDE 
SELECT CodFormDE, Name, Value, Type, id, Category, FieldValueOptionList
FROM #tmpFormDE


DROP TABLE #tmpFormDE
