USE clc
GO


;WITH cubo AS (
SELECT 
mandato
,Import.commitment_lordo 
,Import.cliente
,tp.IdPersona
,Import.desc_cliente
,CASE WHEN tp.CodTipoPersona = 1 THEN 1 ELSE 0 END AS IsPF
,DATALENGTH(Import.indirizzo_res) LunghezzaIndirizzoRes
,DATALENGTH(Import.indirizzo_corrisp) LunghezzaIndirizzoCorrisp
,CASE WHEN Import.cognome_corrisp !='' AND Import.nome_corrisp != '' AND (Import.cognome_corrisp + ' ' + Import.nome_corrisp) != Import.desc_cliente
	THEN 'C/O ' + Import.cognome_corrisp + ISNULL(' ' + Import.nome_corrisp,'')
	WHEN import.cognome_corrisp != ''  AND Import.indirizzo_corrisp = 'Via Cusani 4' AND Import.localita_corrisp = 'MILANO'
	THEN 'C/O ' + Import.cognome_corrisp + ISNULL(' ' + Import.nome_corrisp,'')
END PrimaRiga

,CASE WHEN Import.indirizzo_corrisp IS NULL OR Import.indirizzo_corrisp  = '' 
	THEN Import.indirizzo_res
	ELSE Import.indirizzo_corrisp
END SecondaRiga
,CASE WHEN Import.localita_corrisp IS NULL OR Import.localita_corrisp = ''
	THEN Import.loc_res
	ELSE Import.localita_corrisp
END Localita
, CASE WHEN Import.prov_corrisp IS NULL OR Import.prov_corrisp = ''
	THEN Import.prov_res
	ELSE Import.prov_corrisp
	END SiglaProvincia
,tpromo.Codice CodicePromotore
,tpromo.RagioneSocialePromotore
,tpromo.IdPromotore

/*
,CASE WHEN incaricoCreato.IdIncarico IS NULL THEN 17445 ELSE '' END CodAttributoIncarico
,CASE WHEN incaricoCreato.IdIncarico IS NOT NULL AND comunicazionealCF.IdComunicazione IS NULL THEN  14510	ELSE '' END CodStatoWorkflowMailCF
,CASE WHEN lolCliente.IdComunicazione IS NULL AND comunicazionealCF.IdComunicazione IS NOT NULL then 15471 ELSE '' END CodStatoWorkflowInvioLOL
,incaricoCreato.IdIncarico
,CASE WHEN comunicazionealCF.IdComunicazione IS NULL THEN 0 ELSE 1 END ComunicazioneInviata
,comunicazionealCF.Destinatario 
,comunicazionealCF.DataInvio

,CASE WHEN lolCliente.IdComunicazione IS NULL THEN 'Non Partita'
	WHEN lolCliente.FlagLavorato = 0 AND lolCliente.FlagFallito = 0 AND lolCliente.DataFineElaborazione IS NULL THEN 'LOL in coda'
	WHEN lolCliente.FlagFallito = 1 THEN 'LOL Fallita'
	WHEN lolCliente.FlagLavorato = 1 AND lolCliente.FlagFallito = 0 THEN 'LOL Inviata'
 END AS StatoInvioLOL
*/
FROM scratch.L_CESAM_AZ_FIA_ImportAnagrafica Import
LEFT JOIN T_Persona tp ON tp.ChiaveCliente = Import.cliente
AND codcliente = 23
LEFT JOIN T_Promotore tpromo ON Import.agente = tpromo.Codice

WHERE Import.IdFondoFIAAzimut = 7 --Ophelia
AND import.status_mandato != 5

) SELECT --TOP 1

'' IdIncaricoInput
,23 CodCliente
,651 CodTipoIncarico
,8 CodArea
,mandato ChiaveClienteIncarico
,cliente CodiceCliente
,desc_cliente Cognome
,'' Nome
,'' CodiceFiscalePIva
,IsPF IsPersonaFisica
,11 CodRuoloRichiedente
,2248 CodDatoAggiuntivo
,'Closing' TestoDatoAggiuntivo
,CodicePromotore CodPromotore
,'' ChiaveClientePromotore
,'' RagioneSocialePromotore
,'' StatoWorkflowTransizione1
,'' Attributo1
,'' StatoWorkflowTransizione2
,'' Attributo2
,'' Dossier
,'' Mandato
,'' TipoOperazione
,'' ISINOperazione
,'' ImportoOperazione
,65 TipoPagamento
,18 ModalitaPagamento
,convert(INT,commitment_lordo) ImportoPagamento
,FORMAT(GETDATE(),'yyyy-MM-dd') DataOperazionePagamento
,FORMAT(GETDATE(),'yyyy-MM-dd') DataValutaPagamento
,mandato CodiceOperazionePagamento
,2249 CodDatoAggiuntivo2
, '2' TestoDatoAggiuntivo2
, '' PathDocumentoDaImbarcare
, '' TipoDocumentoDaImbarcare
, '' NoteDocumentoDaImbarcare
, '' TipoPagamento2
, '' ModalitaPagamento2
, '' ImportoPagamento2
, '' DataOperazionePagamento2
, '' DataValutaPagamento2
, '' CodiceOperazionePagamento2
, '' TipoPagamento3
, '' ModalitaPagamento3
, '' ImportoPagamento3
, '' DataOperazionePagamento3
, '' DataValutaPagamento3
, '' CodiceOperazionePagamento3
, '' TipoPagamento4
, '' ModalitaPagamento4
, '' ImportoPagamento4
, '' DataOperazionePagamento4
, '' DataValutaPagamento4
, '' CodiceOperazionePagamento4
, '' TipoPagamento5
, '' ModalitaPagamento5
, '' ImportoPagamento5
, '' DataOperazionePagamento5
, '' DataValutaPagamento5
, '' CodiceOperazionePagamento5
, '' TipoPagamento6
, '' ModalitaPagamento6
, '' ImportoPagamento6
, '' DataOperazionePagamento6
, '' DataValutaPagamento6
, '' CodiceOperazionePagamento6
, '' TipoPagamento7
, '' ModalitaPagamento7
, '' ImportoPagamento7
, '' DataOperazionePagamento7
, '' DataValutaPagamento7
, '' CodiceOperazionePagamento7
, '' TipoPagamento8
, '' ModalitaPagamento8
, '' ImportoPagamento8
, '' DataOperazionePagamento8
, '' DataValutaPagamento8
, '' CodiceOperazionePagamento8
, '' TipoPagamento9
, '' ModalitaPagamento9
, '' ImportoPagamento9
, '' DataOperazionePagamento9
, '' DataValutaPagamento9
, '' CodiceOperazionePagamento9

FROM cubo
--LEFT JOIN D_Provincia ON Sigla = SiglaProvincia
--WHERE D_Provincia.codice IS NULL

GO


