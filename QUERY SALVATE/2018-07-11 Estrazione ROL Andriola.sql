USE CLC
GO

SELECT
	T_Comunicazione.IdComunicazione
	,D_TipoInvioPoste.Descrizione AS Tipologia
	,T_Comunicazione.DataInvio
	,T_Comunicazione.Oggetto
	,T_Comunicazione.IdIncarico AS incarico
	,D_TipoIncarico.Descrizione AS TipoIncarico
	,T_Incarico.ChiaveCliente
	,T_Comunicazione.IdOperatore AS codOperatoreInvio
	,S_Operatore.Etichetta AS [Operatore Invio]
	,ISNULL(T_Comunicazione.NomeDestinatarioPoste + T_Comunicazione.CognomeDestinatarioPoste, T_Comunicazione.NomeDestinatarioPoste) AS Destinatario
	,T_Comunicazione.IndirizzoDestinatarioPoste + ' ' + T_Comunicazione.CapDestinatarioPoste + ' ' + T_Comunicazione.LocalitaDestinatarioPoste + ' (' + T_Comunicazione.ProvinciaDestinatarioPoste
	+ ')' AS [Indirizzo Destinatario]
	,CASE
		WHEN Y_SpoolerInvioPostev2.FlagFallito = 1 AND
			Y_SpoolerInvioPostev2.FlagLavorato = 0 THEN 'INVIO FALLITO'
		WHEN Y_SpoolerInvioPostev2.FlagFallito = 0 AND
			Y_SpoolerInvioPostev2.FlagLavorato = 1 THEN 'INVIO RIUSCITO'
		WHEN Y_SpoolerInvioPostev2.FlagFallito = 0 AND
			Y_SpoolerInvioPostev2.FlagLavorato = 0 THEN 'IN CODA'
		WHEN Y_SpoolerInvioPostev2.FlagFallito = 1 AND
			Y_SpoolerInvioPostev2.FlagLavorato = 1 THEN 'ERRORE POST LAVORAZIONE'
	END AS EsitoInvio

	,IIF(Documento_id is NULL ,'Lettere Antiricilaggio','Rimborsi inviati da Ufficio Sospesi') Ufficio

FROM Y_SpoolerInvioPostev2 WITH (NOLOCK)
INNER JOIN T_Comunicazione WITH (NOLOCK)
	ON T_Comunicazione.IdComunicazione = Y_SpoolerInvioPostev2.IdComunicazione
INNER JOIN T_Incarico WITH (NOLOCK)
	ON T_Comunicazione.IdIncarico = T_Incarico.IdIncarico
INNER JOIN D_TipoIncarico WITH (NOLOCK)
	ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico
INNER JOIN S_Operatore WITH (NOLOCK)
	ON S_Operatore.IdOperatore = T_Comunicazione.IdOperatore
INNER JOIN D_TipoInvioPoste WITH (NOLOCK)
	ON D_TipoInvioPoste.Codice = T_Comunicazione.CodTipoInvioPoste

LEFT JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico AND Tipo_Documento = 8223 and CodOrigineDocumento = 2

WHERE (T_Incarico.CodCliente = 23)
AND (T_Incarico.CodArea = 8)

AND (
	 (Documento_id IS NULL AND CodTipoIncarico = 291)
	 OR (Documento_id IS NOT NULL and CodTipoIncarico IN ( 85
													,94
													,95
													,147
													,153
													,298
													,323
													,96
													,238
													,113
													)
		)
	 )
AND Y_SpoolerInvioPostev2.DataInserimento >= '20180101'
AND Y_SpoolerInvioPostev2.DataInserimento < GETDATE()










--SELECT * FROM D_TipoIncarico where Descrizione LIKE '%rimb%fondi%'

--SELECT IdIncarico
--	,	Documento_id
--		,Tipo_Documento
--		,D_Documento.Descrizione TipoDocumento
--		,CodOrigineDocumento
--		,D_OrigineDocumento.Descrizione OrigineDocumento
	
--FROM T_Documento 
--JOIN D_Documento on Tipo_Documento = Codice
--JOIN D_OrigineDocumento ON D_OrigineDocumento.Codice = T_Documento.CodOrigineDocumento
--where IdIncarico = 9348698

--SELECT * FROM D_Documento WHERE Descrizione LIKE '%richiesta%agg%'
----8223	Richiesta aggiornamento dati a/R

--SELECT * FROM S_TemplateDocumento where CodTipoDocumento = 8223

--SELECT * FROM R_Cliente_TemplateDocumento WHERE IdTemplateDocumento = 4116


--SELECT * FROM D_TipoIncarico where Codice in (94
--,95
--,147
--,153
--,298
--,323
--,96
--,238
--,113
--)