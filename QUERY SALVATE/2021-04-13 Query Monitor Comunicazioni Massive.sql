USE CLC
;
WITH cubo AS (
SELECT T_Incarico.IdIncarico
,T_Incarico.DataCreazione
,T_Incarico.ChiaveCliente Mandato
,CASE WHEN T_Persona.IdPersona IS NOT NULL THEN 1 ELSE 0 END IsPersonaPopolata
,T_Persona.ChiaveCliente
,T_Persona.Cognome CognomePersona
,T_Persona.Nome NomePersona
,T_Persona.CodiceFiscale CFPersona
,CASE WHEN T_Promotore.IdPromotore IS NOT NULL THEN 1 ELSE 0 END IsPromotorePopolato
,T_Promotore.Codice CodiceCF
,perspromo.Cognome  CognomeCF
,perspromo.Nome NomeCF
,CASE WHEN PI_ConfermaInvestimento.IdPagamento IS NOT NULL THEN 1 ELSE 0 END IsPagamentoPopolato
,PI_ConfermaInvestimento.CodiceOperazione MandatoPagamento
,PI_ConfermaInvestimento.Importo 

,CASE WHEN DocumentoClosing.Documento_id IS NOT NULL THEN 1 ELSE 0 END IsDocumentoPopolato

,codstatoworkflowincarico
,CASE WHEN contatticf.IdContatto IS NOT NULL THEN 1 ELSE 0 END ContattoPrincipalePresente
,CASE WHEN comunicazionealCF.Destinatario IS NOT NULL THEN 1 ELSE 0 END MailInviata

,CASE WHEN lolCliente.IdComunicazione IS NOT NULL THEN 1 ELSE 0 END FlagLOLPartita

,CASE WHEN lolCliente.IdComunicazione IS NULL THEN 'Non Partita'
	WHEN lolCliente.FlagLavorato = 0 AND lolCliente.FlagFallito = 0 AND lolCliente.DataFineElaborazione IS NULL THEN 'LOL in coda'
	WHEN lolCliente.FlagFallito = 1 THEN 'LOL Fallita'
	WHEN lolCliente.FlagLavorato = 1 AND lolCliente.FlagFallito = 0 THEN 'LOL Inviata'
 END AS StatoInvioLOL

 ,Indirizzi.PrimaRiga
 ,Indirizzi.SecondaRiga
 ,Indirizzi.Cap
 ,Indirizzi.Localita
 ,Indirizzi.SiglaProvincia
 ,DocumentoClosing.Documento_id
 ,CodAttributoIncarico

FROM T_Incarico
left JOIN T_R_Incarico_Persona ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico
LEFT JOIN T_Persona ON T_R_Incarico_Persona.IdPersona = T_Persona.IdPersona
left JOIN T_R_Incarico_Promotore ON T_Incarico.IdIncarico = T_R_Incarico_Promotore.IdIncarico
LEFT JOIN T_Promotore ON T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
LEFT JOIN T_Persona perspromo ON T_Promotore.IdPersona = perspromo.IdPersona

OUTER APPLY (
				SELECT TOP 1 tpix.IdPagamento, tpix.Importo, tpix.CodiceOperazione, tpix.DataOperazione, tpix.DataValuta
				FROM T_PagamentoInvestimento tpix
				WHERE tpix.FlagAttivo = 1
				AND tpix.CodModalitaPagamento = 18 --Bonifico Bancario
				AND tpix.CodTipoPagamento = 65 --Conferma Investimento
				AND tpix.IdIncarico = T_Incarico.IdIncarico
				ORDER BY tpix.IdPagamento DESC

) PI_ConfermaInvestimento

OUTER APPLY (
SELECT TOP 1 tdocx.Documento_id 
FROM T_Documento tdocx
WHERE tdocx.FlagPresenzaInFileSystem = 1
AND tdocx.FlagScaduto = 0
AND tdocx.Tipo_Documento = 250981 --Comunicazione closing
AND tdocx.IdIncarico = T_Incarico.IdIncarico
) DocumentoClosing

OUTER  APPLY (
				SELECT TOP 1 tcx.IdContatto FROM T_Contatto tcx
				WHERE tcx.CodRuoloContatto = 7 --Sospesi Contatto Principale
				AND T_Promotore.IdPersona = tcx.IdPersona
				AND tcx.FlagAttivo = 1

) contatticf

OUTER APPLY (
		SELECT TOP 1 IdComunicazione , Destinatario, DataInvio
		FROM T_Comunicazione mail
		WHERE mail.IdTemplate = 16475
		AND mail.DataInvio IS NOT NULL
		AND mail.IdIncarico = T_Incarico.IdIncarico
		ORDER BY mail.idcomunicazione DESC
) comunicazionealCF

OUTER APPLY (
				SELECT TOP 1 lol.IdComunicazione, DataInizioElaborazione, DataFineElaborazione, FlagLavorato, FlagFallito
				FROM T_Comunicazione lol
				JOIN Y_SpoolerInvioPostev2 ON lol.IdComunicazione = Y_SpoolerInvioPostev2.IdComunicazione
				WHERE lol.CodTipoInvioPoste IS NOT NULL
				AND lol.IdTemplate = 15568 --LOL
				AND lol.IdIncarico = T_Incarico.IdIncarico
				ORDER BY lol.IdComunicazione DESC
) lolCliente


OUTER APPLY (
				SELECT TOP 1 tindx.IdIndirizzo, tindx.PrimaRiga, tindx.SecondaRiga, tindx.Localita, cap, tindx.SiglaProvincia
				FROM T_R_Persona_Indirizzo trpindx
				JOIN T_Indirizzo tindx ON trpindx.IdIndirizzo = tindx.IdIndirizzo
				AND tindx.CodTipoIndirizzo = 7
				AND trpindx.DataFine IS NULL
				WHERE trpindx.IdPersona = T_Persona.IdPersona
				ORDER BY tindx.IdIndirizzo DESC
) Indirizzi

WHERE T_Incarico.CodArea = 8
AND T_incarico.CodCliente = 23
AND T_incarico.CodTipoIncarico = 651
--AND CodAttributoIncarico = 17445 --Ophelia
AND DataCreazione >= '20210419'
--AND ( CodAttributoIncarico IS NULL OR CodAttributoIncarico != 17445)

)
SELECT --TOP 200  
IdIncarico, StatoInvioLOL, ChiaveCliente, CognomePersona, NomePersona, ISNULL(PrimaRiga,'') PrimaRiga, SecondaRiga, Cap, Localita, SiglaProvincia
FROM cubo
WHERE
 Mandato != '7661128' AND
CodAttributoIncarico = 17445
AND FlagLOLPartita = 1