USE clc

GO

ALTER VIEW rs.v_CESAM_AZ_Operazioni_Caricamento_FONDI_RataPAC AS 

SELECT  ti.IdIncarico
,ti.DataCreazione
,ti.CodStatoWorkflowIncarico
,ti.CodAttributoIncarico
,ti.DataUltimaTransizione
,'20' AS FunzionePrincipale
,SPr.Testo [SocProdotto]
,CPr.Testo [CodProdotto]
,Mandato.Testo Mandato
,'E' [E/Q]

,FORMAT(rs.DateStrip_GiorniLavorativi(23,tmcb.DataOperazione,2),'dd MM yyyy') Dt_Sottoscrizione
,FORMAT(tmcb.DataValuta,'dd MM yyyy') Dt_Valuta
,FORMAT(tmcb.DataOperazione,'dd MM yyyy') Dt_BonificoFondo
,'99' S_Pagamento
,'04' Pagamento
,CAST(FORMAT(tmcb.Importo,'N','de-de') AS VARCHAR(100)) Importo_Lordo

,ISNULL(tmcb.IbanOrdinante, iban.IbanOrdinante_63) IBAN
,SUBSTRING(ISNULL(tmcb.IbanOrdinante, iban.IbanOrdinante_63), 6, 5) 
	+ ' ' + SUBSTRING(ISNULL(tmcb.IbanOrdinante, iban.IbanOrdinante_63) ,11 ,5) 
	+ ' ' + SUBSTRING(ISNULL(tmcb.ibanordinante, iban.IbanOrdinante_63) ,16 ,12) CoordinateBancarie

,tmcb.IdMovimentoContoBancario

FROM T_Incarico ti
JOIN T_DatoAggiuntivo SPr ON ti.IdIncarico = SPr.IdIncarico
AND SPr.FlagAttivo = 1
AND SPr.CodTipoDatoAggiuntivo = 2125 --Società Prodotto

JOIN T_DatoAggiuntivo CPr ON ti.IdIncarico = CPr.IdIncarico
AND CPr.FlagAttivo = 1
AND cpr.CodTipoDatoAggiuntivo = 2126 --Codice Prodotto

JOIN T_DatoAggiuntivo Mandato ON ti.IdIncarico = Mandato.IdIncarico
AND Mandato.FlagAttivo = 1
AND Mandato.CodTipoDatoAggiuntivo = 230 --Mandato

JOIN T_R_Incarico_MovimentoContoBancario trimcb ON ti.IdIncarico = trimcb.IdIncarico
JOIN T_MovimentoContoBancario tmcb ON trimcb.IdMovimentoContoBancario = tmcb.IdMovimentoContoBancario

OUTER APPLY (
				SELECT TOP 1 IbanOrdinante_63
				FROM scratch.T_R_ImportRendicontazione_Movimento
				JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
				JOIN scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi ON Chiave_62 = Chiave_62_DA
				WHERE scratch.T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario = tmcb.idmovimentocontobancario
				AND IbanOrdinante_63 IS NOT NULL
			) iban

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 693
AND ti.CodStatoWorkflowIncarico = 8570
--AND tmcb.DataConferma >= CONVERT(DATE,getdate())


AND ti.IdIncarico = 16656047
AND tmcb.IdMovimentoContoBancario = 1282182


GO
