USE clc
GO

BEGIN TRAN

IF OBJECT_ID('tempdb.dbo.#tmpDatiAggiuntivi') IS NOT NULL
	DROP TABLE #tmpDatiAggiuntivi


CREATE TABLE #tmpDatiAggiuntivi
(
	CodTipoDatoAggiuntivo INT,
	CodCliente INT,
	CodTipoIncarico INT,
	FraseVecchia VARCHAR(255),
	FraseNuova VARCHAR(255),
	IdRelazioneFormDE INT
)

INSERT INTO #tmpDatiAggiuntivi (CodTipoDatoAggiuntivo, CodCliente, CodTipoIncarico,FraseVecchia, FraseNuova, IdRelazioneFormDE)
select 949, 48, 408, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 15 union all
select 949, 48, 593, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 15 union all
select 949, 48, 408, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 15 union all
select 949, 48, 593, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 15 union all
select 949, 48, 408, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 15 union all
select 949, 48, 593, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 15 union all
select 982, 48, 408, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 47 union all
select 982, 48, 593, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 47 union all
select 982, 48, 408, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 47 union all
select 982, 48, 593, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 47 union all
select 982, 48, 408, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 47 union all
select 982, 48, 593, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 47 union all
select 950, 48, 408, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 26 union all
select 950, 48, 408, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 26 union all
select 950, 48, 408, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 26 union all
select 950, 48, 408, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 26 union all
select 950, 48, 408, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 26 union all
select 950, 48, 408, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 26 union all
select 950, 48, 408, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 26 union all
select 950, 48, 408, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 26 union all
select 950, 48, 408, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 26 union all
select 950, 48, 593, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 26 union all
select 950, 48, 593, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 26 union all
select 950, 48, 593, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 26 union all
select 950, 48, 593, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 26 union all
select 950, 48, 593, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 26 union all
select 950, 48, 593, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 26 union all
select 950, 48, 593, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 26 union all
select 950, 48, 593, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 26 union all
select 950, 48, 593, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 26 union all
select 983, 48, 408, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 48 union all
select 983, 48, 408, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 48 union all
select 983, 48, 408, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 48 union all
select 983, 48, 408, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 48 union all
select 983, 48, 408, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 48 union all
select 983, 48, 408, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 48 union all
select 983, 48, 408, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 48 union all
select 983, 48, 408, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 48 union all
select 983, 48, 408, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 48 union all
select 983, 48, 593, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 48 union all
select 983, 48, 593, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 48 union all
select 983, 48, 593, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 48 union all
select 983, 48, 593, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 48 union all
select 983, 48, 593, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 48 union all
select 983, 48, 593, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 48 union all
select 983, 48, 593, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 48 union all
select 983, 48, 593, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 48 union all
select 983, 48, 593, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 48 union all
select 1097, 48, 408, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3139 union all
select 1097, 48, 593, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3139 union all
select 1097, 48, 408, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 3139 union all
select 1097, 48, 593, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 3139 union all
select 1097, 48, 408, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3139 union all
select 1097, 48, 593, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3139 union all
select 1098, 48, 408, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 3140 union all
select 1098, 48, 408, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 3140 union all
select 1098, 48, 408, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 3140 union all
select 1098, 48, 408, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 3140 union all
select 1098, 48, 408, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 3140 union all
select 1098, 48, 408, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 3140 union all
select 1098, 48, 408, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 3140 union all
select 1098, 48, 408, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 3140 union all
select 1098, 48, 408, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 3140 union all
select 1098, 48, 593, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 3140 union all
select 1098, 48, 593, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 3140 union all
select 1098, 48, 593, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 3140 union all
select 1098, 48, 593, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 3140 union all
select 1098, 48, 593, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 3140 union all
select 1098, 48, 593, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 3140 union all
select 1098, 48, 593, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 3140 union all
select 1098, 48, 593, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 3140 union all
select 1098, 48, 593, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 3140 union all
select 1128, 48, 408, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3170 union all
select 1128, 48, 593, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3170 union all
select 1128, 48, 408, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 3170 union all
select 1128, 48, 593, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 3170 union all
select 1128, 48, 408, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3170 union all
select 1128, 48, 593, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3170 union all
select 1129, 48, 408, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 3171 union all
select 1129, 48, 408, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 3171 union all
select 1129, 48, 408, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 3171 union all
select 1129, 48, 408, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 3171 union all
select 1129, 48, 408, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 3171 union all
select 1129, 48, 408, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 3171 union all
select 1129, 48, 408, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 3171 union all
select 1129, 48, 408, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 3171 union all
select 1129, 48, 408, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 3171 union all
select 1129, 48, 593, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 3171 union all
select 1129, 48, 593, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 3171 union all
select 1129, 48, 593, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 3171 union all
select 1129, 48, 593, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 3171 union all
select 1129, 48, 593, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 3171 union all
select 1129, 48, 593, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 3171 union all
select 1129, 48, 593, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 3171 union all
select 1129, 48, 593, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 3171 union all
select 1129, 48, 593, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 3171 union all
select 1298, 48, 408, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3201 union all
select 1298, 48, 593, 'residente estero con importanti cariche pubbliche', 'un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3201 union all
select 1298, 48, 408, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 3201 union all
select 1298, 48, 593, 'residente nel territorio nazionale con importanti cariche pubbliche', 'un familiare diretto', 3201 union all
select 1298, 48, 408, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3201 union all
select 1298, 48, 593, 'familiare diretto o che intrattiene stretti legami con un soggetto con importanti cariche pubbliche', 'una persona che intrattiene stretti legami con un soggetto che occupa o ha occupato nell’ultimo anno importanti cariche pubbliche in una delle categorie della lista sottostante', 3201 union all
select 1299, 48, 408, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 3202 union all
select 1299, 48, 408, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 3202 union all
select 1299, 48, 408, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 3202 union all
select 1299, 48, 408, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 3202 union all
select 1299, 48, 408, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 3202 union all
select 1299, 48, 408, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 3202 union all
select 1299, 48, 408, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 3202 union all
select 1299, 48, 408, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 3202 union all
select 1299, 48, 408, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 3202 union all
select 1299, 48, 593, 'Ambasciatori,...,ufficiali', 'Presidente della Repubblica, … , Sindaco … con più di 15.000 abitanti, nonché altre cariche analoghe in  Stati esteri', 3202 union all
select 1299, 48, 593, 'Capi di Stato,...,Parlamentari', 'Presidente della Provincia, … ,Sindaco … con meno di 15.000 abitanti nonché cariche analoghe in Stati esteri', 3202 union all
select 1299, 48, 593, 'Membri degli organi di amministrazione,...,vigilanza imprese', 'membro degli organi direttivi centrali di partiti politici, membro degli organi direttivi delle banche centrali e delle autorità indipendenti', 3202 union all
select 1299, 48, 593, 'Membri delle corti dei conti e dei CDA delle BC', 'giudice della Corte Costituzionale, magistrato … per la Regione siciliana nonché cariche analoghe in Stati esteri', 3202 union all
select 1299, 48, 593, 'Membri delle corti supreme e altri organi giudiziari', 'ambasciatore, incaricato d''affari ... Stati esteri, ufficiale di grado apicale delle forze armate ovvero cariche analoghe in Stati esteri', 3202 union all
select 1299, 48, 593, 'Presidenti,...,in Giunte Provinciali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con più di 15.000 abitanti', 3202 union all
select 1299, 48, 593, 'Presidenti,...,in Giunte Regionali', 'componente degli organi di amministrazione di imprese controllate, anche indirettamente, dallo Stato italiano ... , e da comuni con meno di 15.000 abitanti', 3202 union all
select 1299, 48, 593, 'Sindaci,...,con meno di 100.000 abitanti', 'direttore generale di ASL , … ,e degli altri enti del servizio sanitario nazionale', 3202 union all
select 1299, 48, 593, 'Sindaci,...,con piu di 100.000 abitanti', 'direttore, vicedirettore e membro dell''organo di gestione o soggetto svolgenti funzioni equivalenti in organizzazioni internazionali', 3202

--SELECT r.*, FraseNuova
----UPDATE R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista
----SET ValoreLista = FraseNuova
--FROM R_Cliente_TipoIncarico_TipoDatoAggiuntivo_ValoreLista r
--JOIN #tmpDatiAggiuntivi ON r.CodTipoDatoAggiuntivo = #tmpDatiAggiuntivi.CodTipoDatoAggiuntivo
--AND r.CodCliente = #tmpDatiAggiuntivi.CodCliente
--AND r.CodTipoIncarico = #tmpDatiAggiuntivi.CodTipoIncarico
--AND r.ValoreLista = FraseVecchia


SELECT orga.S_FormDE.idRelazione, CodFormDE, Name, Value, FieldValueOptionList, formde.ElencoNuovo
--UPDATE orga.S_FormDE
--SET FieldValueOptionList = formde.ElencoNuovo
FROM orga.S_FormDE
JOIN (SELECT dbo.GROUP_CONCAT_D(FraseNuova,';') ElencoNuovo, MAX(IdRelazioneFormDE) IdRelazione
		FROM #tmpDatiAggiuntivi 
		WHERE CodTipoIncarico = 408 AND CodCliente = 48
		GROUP BY CodTipoDatoAggiuntivo--, CodCliente
	) formde ON formde.IdRelazione = S_FormDE.idRelazione


DROP TABLE #tmpDatiAggiuntivi


--COMMIT TRAN