USE clc
GO

WITH dati AS (

SELECT ti.IdIncarico
,datacreazione
,ti.ChiaveCliente ChiaveClienteIncarico
,ti.CodStatoWorkflowIncarico
,ti.CodAttributoIncarico
,Codice CodiceCF
,RagioneSocialePromotore CF
,CASE WHEN zip.Documento_id IS NOT NULL THEN 1 ELSE 0 END FlagZipInserito
,zip.Dimensione / 1024 [DimensioneZip (KB)]
,TipoFondo.Testo TipoFondo
,CASE WHEN contatticf.IdContatto IS NOT NULL THEN 1 ELSE 0 END ContattoPrincipaleCFPresente
, CASE WHEN ti.CodStatoWorkflowIncarico NOT IN (
		22466	--Comunicazione Inviata - Azimut Previdenza
		,22467	--Comunicazione Inviata - Azimut Sustainable Future
) AND TipoFondo.Testo = 'Azimut Sustainable Future'
	THEN 22467
 ELSE 22466
 END CodStatoDestinazione
 ,TipoFondo.IdDatoAggiuntivo
 --,CASE WHEN CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagKOContattoPrincipale
 ,CASE WHEN TipoFondo.Testo = 'Azimut Sustainable Future' THEN 'Lotto 1'
	WHEN ti.DataCreazione >= '2021-05-05 14:58:29.673' AND ti.DataCreazione < '2021-05-05 17:17' THEN 'Lotto 1'
	WHEN ti.DataCreazione >= '2021-05-05 17:18' AND ti.DataCreazione < '2021-05-06' THEN 'Lotto 2'
	WHEN ti.DataCreazione >= '2021-05-06' AND ti.DataCreazione < '2021-05-06 12:39' THEN 'Lotto 3'
	WHEN ti.DataCreazione >= '2021-05-06 12:39' AND ti.DataCreazione < '2021-05-06 16:06' THEN 'Lotto 4'
	WHEN ti.DataCreazione >= '2021-05-06 16:07' AND ti.DataCreazione < '2021-05-06 17:53' THEN 'Lotto 5'
	WHEN ti.DataCreazione >= '2021-05-06 17:55' AND ti.DataCreazione < '2021-05-07' THEN 'Lotto 6'

	END AS Lotto
	,TipoFondo.CodTipoDatoAggiuntivo

,   mail.IdComunicazione
   ,mail.Mittente
   ,mail.Destinatario
   ,mail.IdMail
   ,CASE WHEN mail.IdMail IS NOT NULL THEN 1 ELSE 0 END FlagComunicazioneInviata
   ,CASE WHEN mail.Destinatario IS NOT NULL THEN 1 ELSE 0 END FlagDestinatarioPresente
FROM T_Incarico ti
LEFT JOIN T_R_Incarico_Promotore trip ON ti.IdIncarico = trip.IdIncarico
LEFT JOIN T_Promotore ON trip.IdPromotore = T_Promotore.IdPromotore

LEFT JOIN T_Documento zip ON ti.IdIncarico = zip.IdIncarico
AND zip.FlagPresenzaInFileSystem = 1
AND zip.FlagScaduto = 0
AND zip.Tipo_Documento = 1558

LEFT JOIN T_DatoAggiuntivo TipoFondo ON ti.IdIncarico = TipoFondo.IdIncarico
AND TipoFondo.FlagAttivo = 1
AND TipoFondo.CodTipoDatoAggiuntivo = 2252

OUTER  APPLY (
				SELECT TOP 1 tcx.IdContatto FROM T_Contatto tcx
				WHERE tcx.CodRuoloContatto = 7 --Sospesi Contatto Principale
				AND T_Promotore.IdPersona = tcx.IdPersona
				AND tcx.FlagAttivo = 1

) contatticf

OUTER APPLY (
				SELECT TOP 1 IdComunicazione, Mittente, Destinatario, IdMail
                FROM T_Comunicazione
				WHERE IdTemplate = 12135
				AND TipoFondo.Testo = 'Azimut Previdenza'
				AND T_Comunicazione.IdIncarico = ti.IdIncarico
				ORDER BY IdComunicazione DESC
				UNION
				SELECT TOP 1  IdComunicazione, Mittente, Destinatario, IdMail
                FROM dbo.T_Comunicazione
				WHERE IdTemplate = 16498
				AND TipoFondo.Testo = 'Azimut Sustainable Future'
				AND T_Comunicazione.IdIncarico = ti.IdIncarico
				ORDER BY IdComunicazione DESC

) mail

--JOIN T_MacroControllo ON ti.IdIncarico = T_MacroControllo.IdIncarico
--JOIN T_Controllo ON T_MacroControllo.IdMacroControllo = T_Controllo.IdMacroControllo

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 401
--AND ti.DataCreazione >=  CONVERT(date,getdate())
AND ti.DataCreazione >= '20210505'
--AND zip.Documento_id IS NULL


) SELECT IdIncarico, CodiceCF, CF, ChiaveClienteIncarico ZIP, tipofondo
FROM dati
WHERE 
CodiceCF = '6664'
--TipoFondo = 'azimut previdenza'
--AND Lotto IN ('Lotto 1','Lotto 2', 'LOTTO 3')
 --CodStatoWorkflowIncarico = 22466
 --FlagComunicazioneInviata = 0
--AND CodiceCF != '4168'
--AND ContattoPrincipaleCFPresente = 1
--AND CodiceCF IN (
--'5057' --	REMORINI MARCO
--,'6156' --	FIOCCO DAVIDE
--,'A425' --	CASCIOLI ROBERTO
--,'A829' --	GALLO GIAMPIERO
--)
--idincarico IN (
--17972541 
--,17972540 
--,17970224 

--)


