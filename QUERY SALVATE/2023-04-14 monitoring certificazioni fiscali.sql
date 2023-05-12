USE CLC_Cesam
GO

WITH dati AS (
SELECT
	ti.IdIncarico
   ,tda1.Testo AS TipoFondo
   ,tda2.Testo AS NumeroLotto
   ,ti.ChiaveCliente
   ,CAST(ti.DataCreazione AS DATE) AS DataCreazione
   ,ti.CodStatoWorkflowIncarico
   ,ti.StatoWorkflowIncarico
   ,v.CodicePromotore
   ,CASE
		WHEN v.CognomePromotore IS NULL OR
			v.CognomePromotore = '' THEN v.RagioneSocialePromotore
		ELSE v.CognomePromotore + ' ' + ISNULL(v.NomePromotore, '')
	END Promotore
   ,SUBSTRING(ti.ChiaveCliente, 6, 12) + '.zip' AllegatoAtteso
   ,tdoc.NomeFileOriginale AllegatoImbarcato
   ,IIF(SUBSTRING(ti.ChiaveCliente, 6, 12) + '.zip' <> tdoc.NomeFileOriginale, 1, 0) ErroreAllegato
   ,tdoc.Documento_id
   ,Dimensione / 1024 AS DimensioneZipKB
   ,IIF(tdoc.Documento_id IS NOT NULL, 1, 0) FlagPresenzaAllegato
   ,ContattoPrincipale.Email EmailContattoPrincipale
   ,ContattoSegreteria.Email EmailSegreteria
   ,IdComunicazione
   ,Destinatario
   --,tc.CodGiudizioControllo

FROM (SELECT
		dbo.T_Incarico.IdIncarico
	   ,dbo.T_Incarico.CodStatoWorkflowIncarico
	   ,dbo.T_Incarico.DataCreazione
	   ,dbo.T_Incarico.ChiaveCliente
	   ,StatoWF.StatoWorkflowIncarico
	FROM dbo.T_Incarico
	JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico StatoWF
	ON T_Incarico.IdIncarico = StatoWF.IdIncarico
	WHERE dbo.T_Incarico.CodArea = 8
	AND dbo.T_Incarico.CodCliente = 23
	AND dbo.T_Incarico.CodTipoIncarico = 401
	AND dbo.T_Incarico.FlagArchiviato = 0 
	AND dbo.T_Incarico.CodStatoWorkflowIncarico != 820
	AND YEAR(dbo.T_Incarico.DataCreazione) = YEAR(GETDATE())) ti

 JOIN T_Documento tdoc
	ON ti.IdIncarico = tdoc.IdIncarico
		AND tdoc.FlagPresenzaInFileSystem = 1
		AND tdoc.FlagScaduto = 0
		AND tdoc.Tipo_Documento = 1558


JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore v
	ON ti.IdIncarico = v.IdIncarico


LEFT JOIN (SELECT
		MAX(IdContatto) IdContatto
	   ,IdPersona
	FROM T_Contatto
	WHERE FlagAttivo = 1
	AND CodRuoloContatto = 7
	AND Email IS NOT NULL
	GROUP BY IdPersona) InputContattoPrincipale
	ON v.IdPersonaPromotore = InputContattoPrincipale.IdPersona
LEFT JOIN T_Contatto ContattoPrincipale
	ON InputContattoPrincipale.IdContatto = ContattoPrincipale.IdContatto

LEFT JOIN (SELECT
		MAX(IdContatto) IdContatto
	   ,IdPersona
	FROM T_Contatto
	WHERE FlagAttivo = 1
	AND CodRuoloContatto = 13
	AND Email IS NOT NULL
	GROUP BY IdPersona) InputContattoSegreteria
	ON v.IdPersonaPromotore = InputContattoSegreteria.IdPersona
LEFT JOIN T_Contatto ContattoSegreteria
	ON ContattoSegreteria.IdContatto = InputContattoSegreteria.IdContatto

--JOIN T_R_Incarico_Controllo tric
--	ON ti.IdIncarico = tric.IdIncarico
--JOIN T_Controllo tc
--	ON tric.IdControllo = tc.IdControllo
--and tc.CodGiudizioControllo = 4

LEFT JOIN T_Comunicazione
	ON ti.IdIncarico = T_Comunicazione.IdIncarico
		AND CodOrigineComunicazione = 1 --Inviata
	

 JOIN dbo.T_DatoAggiuntivo tda1
	ON ti.IdIncarico = tda1.IdIncarico
		AND tda1.CodTipoDatoAggiuntivo = 2252

 JOIN dbo.T_DatoAggiuntivo tda2
	ON ti.IdIncarico = tda2.IdIncarico
		AND tda2.CodTipoDatoAggiuntivo = 644

		)

		SELECT * 
		FROM dati
		WHERE CodStatoWorkflowIncarico NOT IN (22467,22466)



