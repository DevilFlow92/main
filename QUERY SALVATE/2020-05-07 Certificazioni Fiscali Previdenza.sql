USE CLC
GO

--ALTER  view rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali AS 

SELECT * FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali

SELECT --TOP 10
 ti.IdIncarico
,ti.ChiaveCliente
,ti.DataCreazione
,ti.CodStatoWorkflowIncarico
,v.CodicePromotore
,CASE when v.CognomePromotore is NULL OR v.CognomePromotore = ''
	THEN v.RagioneSocialePromotore
	ELSE v.CognomePromotore + ' ' + ISNULL(v.NomePromotore,'')
 END Promotore
 ,SUBSTRING(ti.ChiaveCliente,6,10) + '.zip' AllegatoAtteso
 ,tdoc.NomeFileOriginale AllegatoImbarcato
 ,IIF(SUBSTRING(ti.ChiaveCliente,6,10) + '.zip' <> tdoc.NomeFileOriginale,1,0) ErroreAllegato
,IIF(tdoc.Documento_id is NOT NULL,1,0) FlagPresenzaAllegato
,tdoc.Documento_id
,ContattoPrincipale.Email EmailContattoPrincipale
,ContattoSegreteria.Email EmailSegreteria
,tc.CodGiudizioControllo 
,CASE WHEN ti.DataCreazione BETWEEN '20200508' AND '20200509' THEN 1
	WHEN ti.DataCreazione BETWEEN '20200511' AND '20200511 20:00' THEN 2
	WHEN ti.DataCreazione BETWEEN '20200511 21:00' AND '20200512 09:40' THEN 3
	WHEN ti.DataCreazione BETWEEN '20200512 09:41' AND '20200513 09:00' THEN 4
 END LottoPrevinet

,T_Comunicazione.IdComunicazione
,T_Comunicazione.FlagAllegati

--,ListaAllegati

FROM T_Incarico ti
LEFT JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico
AND tdoc.FlagPresenzaInFileSystem = 1
AND tdoc.FlagScaduto = 0
AND tdoc.Tipo_Documento = 1558


LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore v ON ti.IdIncarico = v.IdIncarico


LEFT JOIN (SELECT MAX(idcontatto) IdContatto, idpersona
			from T_Contatto
			WHERE FlagAttivo = 1
			AND CodRuoloContatto = 7
			AND Email is NOT NULL
			GROUP BY IdPersona
			 ) InputContattoPrincipale ON v.IdPersonaPromotore = InputContattoPrincipale.IdPersona
LEFT JOIN T_Contatto ContattoPrincipale ON InputContattoPrincipale.IdContatto = ContattoPrincipale.IdContatto
 
LEFT JOIN (SELECT MAX(idcontatto) IdContatto, idpersona
			from T_Contatto
			WHERE FlagAttivo = 1
			AND CodRuoloContatto = 13
			AND Email is NOT NULL
			GROUP BY IdPersona
			 ) InputContattoSegreteria ON v.IdPersonaPromotore = InputContattoSegreteria.IdPersona
LEFT JOIN T_Contatto ContattoSegreteria ON ContattoSegreteria.IdContatto = InputContattoSegreteria.IdContatto

JOIN T_R_Incarico_Controllo tric ON ti.IdIncarico = tric.IdIncarico
JOIN T_Controllo tc ON tric.IdControllo = tc.IdControllo
LEFT JOIN T_Comunicazione ON ti.IdIncarico = T_Comunicazione.IdIncarico
AND CodOrigineComunicazione = 1 --Inviata


WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 401
AND ti.DataCreazione >= '20200508' 

AND ti.CodStatoWorkflowIncarico = 6500
--AND IdComunicazione IS  NULL

AND tdoc.Documento_id IS not NULL
--AND tc.CodGiudizioControllo = 4
--AND ContattoPrincipale.Email is NOT NULL
--AND ti.CodStatoWorkflowIncarico = 11435


GO


SELECT IdIncarico,  11435 CodStatoDestinazione
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali
WHERE DataCreazione >= '20200508'
AND CodStatoWorkflowIncarico = 6500
AND CodGiudizioControllo = 2

--AND Documento_id is NOT NULL

--ORDER by ti.ChiaveCliente



/*
SELECT ti.IdIncarico
--, 1194 CodAttributo
,11435 CodStatoWorkflowIncarico	--Gestita - Comunicazione Inviata
FROM T_Incarico ti
JOIN T_R_Incarico_Controllo tric ON ti.IdIncarico = tric.IdIncarico
JOIN T_Controllo tc ON tric.IdControllo = tc.IdControllo
--JOIN T_Documento on ti.IdIncarico = T_Documento.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 401
AND ti.CodStatoWorkflowIncarico = 6500
AND ti.DataCreazione >= '20200508'
and tc.CodGiudizioControllo = 2
and ti.DataCreazione BETWEEN '20200508' AND '20200511 20:00' --Lotti 1,2
--AND ti.DataCreazione BETWEEN '20200511 21:00' AND '20200513 09:00' --Lotti 3,4

--AND ti.DataCreazione BETWEEN '20200508'
--AND '20200511 20:00'
*/

/*


/**** contatti assenti (controlli in ko) ***/
SELECT DISTINCT CodicePromotore CodiceCF, ISNULL(Promotore,RagioneSocialePromotore) CF
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali JOIN T_Promotore on CodicePromotore = Codice
WHERE DataCreazione >= '20200508' AND 
CodGiudizioControllo = 4

/*** 1° invio ****/
SELECT distinct
	IdIncarico
	,11435 CodStatoDestinazione
	,CodicePromotore
	,Promotore
	,EmailContattoPrincipale
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali
WHERE DataCreazione >= '20200508'
AND CodStatoWorkflowIncarico = 6500
AND CodGiudizioControllo = 2
AND EmailContattoPrincipale IS NOT NULL
AND LottoPrevinet IN (1, 2)

UNION ALL
SELECT distinct
	IdIncarico
	,11435 CodStatoDestinazione
	,CodicePromotore
	,Promotore
	,EmailContattoPrincipale
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali
WHERE DataCreazione >= '20200508'
AND CodStatoWorkflowIncarico = 6500
AND CodGiudizioControllo = 2
AND EmailContattoPrincipale IS NOT NULL
AND LottoPrevinet = 3
AND CodicePromotore = (SELECT
	MAX(CodicePromotore)
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali
WHERE LottoPrevinet = 2)


/**** 2° invio ****/
SELECT distinct
IdIncarico
	,11435 CodStatoDestinazione
	,CodicePromotore
	,Promotore
	,EmailContattoPrincipale
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali
WHERE DataCreazione >= '20200508'
AND LottoPrevinet in (3,4)
AND CodGiudizioControllo = 2
AND CodStatoWorkflowIncarico = 6500
AND EmailContattoPrincipale IS NOT NULL
AND CodicePromotore != (SELECT
	MAX(CodicePromotore)
FROM rs.v_CESAM_AZ_Previdenza_CertificazioniFiscali
WHERE LottoPrevinet = 2)

*/


USE clc

SELECT ti.IdIncarico, ti.ChiaveCliente ,d.statoworkflowincarico,  d.AttributoIncarico
, van.CodicePromotore CodiceCF
, CASE WHEN van.CognomePromotore IS NULL OR van.CognomePromotore = ''
	THEN van.RagioneSocialePromotore
	ELSE van.CognomePromotore + ISNULL(' ' + van.NomePromotore,'')
	END CF
,van.DescrizioneSim MacroArea
,van.DescrizioneAreaCentroRaccolta Area
,van.DescrizioneCentroRaccolta CDR
,datainvio
,oggetto
--,testo TestoMail
--,Testo TestoMail
FROM T_Incarico ti
JOIN T_Comunicazione ON ti.IdIncarico = T_Comunicazione.IdIncarico
AND CodOrigineComunicazione = 1
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 401
AND YEAR(ti.DataCreazione) = YEAR(GETDATE())
AND van.CodicePromotore = '6915'
--AND ti.CodStatoWorkflowIncarico NOT IN (820, 22522)	--Comunicazione Imbarcata

SELECT * FROM D_OrigineComunicazione
