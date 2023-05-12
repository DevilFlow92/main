USE [CLC]
--GO

--/****** Object:  View [rs].[v_CESAM_AZ_AFB_Operazioni_Riconciliate]    Script Date: 28/12/2017 12:14:34 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




--ALTER view [rs].[v_CESAM_AZ_AFB_Operazioni_Riconciliate] AS

/*use clc
selecT*
from T_Mandato
where NumeroMandato = '4000404'*/
SELECT   DISTINCT     D_TipoIncarico.Descrizione AS tipoincarico
, T_Incarico.IdIncarico
, T_Incarico.CodTipoIncarico
, T_Mandato.NumeroMandato
, T_Mandato.DataSottoscrizione
, T_Mandato.NumeroContratto AS MandatoRTO
, D_TipoRaccomandazione.Descrizione AS TipoRaccomandazione
, T_Dossier.NumeroDossier
, primo.ChiaveCliente
, primo.Cognome + ' ' + primo.Nome AS cliente1
, primo.CodiceFiscale AS CodiceFiscale1
, ruolo1.Codice as cod_ruolo1
, ruolo1.Descrizione AS Ruolo1, 
                         D_TipoOperazioneAzimut.Descrizione AS TipoOperazione
                                        , E_SocietaProdottoAzimut.Descrizione AS SP
                                        , ISNULL(SocietaSIA,E_MacroProdottoAzimut.Descrizione) AS MP, 
                         ISNULL(ProdottoSIA,E_ProdottoAzimut.Descrizione) AS P
                                        , T_OperazioneAzimut.IdOperazioneAzimut
                                        , T_OperazioneAzimut.Importo
                                        , E_ProdottoAzimut.Isin, 
                         T_OperazioneAzimut.NumeroQuoteAzioni
                                        , T_OperazioneAzimut.ValoreQuoteInEuro
                                        , T_OperazioneAzimut.ValoreQuoteInDivisaFondo, 
                         T_OperazioneAzimut.PercentualeSconto
                                        , D_TipoPagamento.Descrizione AS TipoPagamento
                                        , D_ModalitaPagamento.Descrizione AS ModalitaPagamento, 
                         T_PagamentoInvestimento.NumeroAssegno
                                        , T_Mandato.NumeroDisposizione
                                        , T_PagamentoInvestimento.IbanDestinazione
                                        , T_OperazioneAzimut.ClasseFondo
                                        , T_Promotore.Codice AS CodicePF
                                        , p.Nome AS NomePF
                                        , p.Cognome AS CognomePF
                                        , D_TipoMandato.Descrizione AS Tipomandato, 
                         D_ProvenienzaDenaro.Descrizione AS ProvenienzaDenaro
                                        , D_TipoFea.Descrizione
                                        , ISNULL(T_DatiAggiuntiviIncaricoAzimut.CodTipoFea,3) CodTipoFea
                                        --,REPLACE(DescrizioneMovimento_63,'  ','') DescrizioneMovimento_63
                                        , ISNULL(DescrizioneMovimento_63,'')+ISNULL(InformazioniRiconciliazione_63,'') DescrizioneMovimento_63
                                        ,DataContabile_61
                                        ,DataValuta_62
                                        ,scratch.L_CESAM_AZ_Import_RendicontazioneBP.ImportoMovimento_62
                                        ,IdImport_RendicontazioneBP
                                        ,Id_Import_RendicontazioneBP_DatiAggiuntivi
                                        ,ISNULL(CodTipoRaccomandazione,99) CodTipoRaccomandazione
                                        ,D_TipoAssegno.Descrizione as TipoAssegno
                                        , Abi
                                        ,Cab
                                        --,T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
FROM            T_Incarico INNER JOIN
                         D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico LEFT JOIN
                         T_R_Incarico_Mandato ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico LEFT JOIN
                         T_Mandato ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT JOIN
                         T_Dossier ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT JOIN
                         T_R_Dossier_Persona AS dossier1 ON dossier1.IdDossier = T_Dossier.IdDossier LEFT JOIN
                         T_Persona AS primo ON primo.IdPersona = dossier1.IdPersona LEFT OUTER JOIN
                         D_RuoloRichiedente AS ruolo1 ON dossier1.CodRuoloRichiedente = ruolo1.Codice LEFT OUTER JOIN
                         T_Promotore ON T_Dossier.IdPromotore = T_Promotore.IdPromotore LEFT OUTER JOIN
                         T_Persona AS p ON p.IdPersona = T_Promotore.IdPersona LEFT OUTER JOIN
                         T_OperazioneAzimut ON T_OperazioneAzimut.IdIncarico = T_Incarico.IdIncarico LEFT OUTER JOIN
                         D_TipoOperazioneAzimut ON D_TipoOperazioneAzimut.Codice = T_OperazioneAzimut.CodTipoOperazioneAzimut LEFT OUTER JOIN
                         D_TipoMandato ON T_OperazioneAzimut.CodTipoMandato = D_TipoMandato.Codice LEFT OUTER JOIN
                         E_MacroProdottoAzimut ON E_MacroProdottoAzimut.IdMacroProdottoAzimut = T_OperazioneAzimut.IdMacroProdottoAzimut LEFT OUTER JOIN
                         E_ProdottoAzimut ON E_ProdottoAzimut.IdProdottoAzimut = T_OperazioneAzimut.IdProdottoAzimut LEFT OUTER JOIN
                         E_SocietaProdottoAzimut ON E_SocietaProdottoAzimut.IdSocietaProdottoAzimut = E_MacroProdottoAzimut.IdSocietaProdottoAzimut LEFT OUTER JOIN
                         T_DatiAggiuntiviIncaricoAzimut ON T_DatiAggiuntiviIncaricoAzimut.IdIncarico = T_Incarico.IdIncarico LEFT OUTER JOIN
                         D_TipoRaccomandazione ON T_DatiAggiuntiviIncaricoAzimut.CodTipoRaccomandazione = D_TipoRaccomandazione.Codice LEFT OUTER JOIN
                         D_ProvenienzaDenaro ON D_ProvenienzaDenaro.Codice = T_DatiAggiuntiviIncaricoAzimut.CodProvenienzaDenaro LEFT OUTER JOIN
                         D_TipoFea ON D_TipoFea.Codice = T_DatiAggiuntiviIncaricoAzimut.CodTipoFea LEFT OUTER JOIN
                         T_PagamentoInvestimento ON T_Incarico.IdIncarico = T_PagamentoInvestimento.IdIncarico AND T_PagamentoInvestimento.CodTipoPagamento <> 38 AND 
                         T_PagamentoInvestimento.FlagAttivo = 1 LEFT OUTER JOIN
                         D_TipoPagamento ON T_PagamentoInvestimento.CodTipoPagamento = D_TipoPagamento.Codice LEFT OUTER JOIN
                         D_ModalitaPagamento ON D_ModalitaPagamento.Codice = T_PagamentoInvestimento.CodModalitaPagamento LEFT OUTER JOIN
                                        D_TipoAssegno on D_TipoAssegno.codice=CodTipoAssegno

                                        left JOIN T_R_Incarico_MovimentoContoBancario ON T_Incarico.IdIncarico = T_R_Incarico_MovimentoContoBancario.IdIncarico
                                        left JOIN scratch.T_R_ImportRendicontazione_Movimento ON T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario = T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario
                                        LEFT JOIN scratch.L_CESAM_AZ_Import_RendicontazioneBP ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
                                        LEFT JOIN scratch.L_CESAM_AZ_Import_RendicontazioneBP_DatiAggiuntivi ON Chiave_62_DA = Chiave_62

                                              
                                               JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
                                               ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
                                               AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
                                               AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
                                               
       LEFT JOIN scratch.R_ISIN_Societa_Prodotto_SIA  ON E_ProdottoAzimut.Isin = scratch.R_ISIN_Societa_Prodotto_SIA.Isin



WHERE        

(T_Incarico.CodCliente = 23) AND (T_Incarico.CodArea = 8) AND (T_Incarico.CodAttributoIncarico = 1520) AND (T_Incarico.CodStatoWorkflowIncarico <> 820)
AND (CodMacroStatoWorkflowIncarico != 2)

AND 

(
     (
	 ((CodModalitaPagamento <> 19 OR CodModalitaPagamento is NULL) AND T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario IS NOT NULL)  -- diverso da assegno
     AND (scratch.L_CESAM_AZ_Import_RendicontazioneBP_DatiAggiuntivi.DescrizioneMovimento_63 IS NOT NULL 
     OR scratch.L_CESAM_AZ_Import_RendicontazioneBP_DatiAggiuntivi.InformazioniRiconciliazione_63 is not NULL))
       
     OR CodModalitaPagamento = 19 --assegno
       
     )

     AND T_OperazioneAzimut.FlagAttivo = 1


	 -----
--AND T_Incarico.IdIncarico IN ( 9136168 ,9148810)


--AND T_Incarico.IdIncarico = 9148810


                                  



GO


