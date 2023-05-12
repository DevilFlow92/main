
USE CLC

--ALTER VIEW rs.v_CESAM_AZ_AFB_Report_CaricamentoRimborsi as

SELECT
	CASE WHEN docrimborso.IdIncarico IS NULL THEN 0 ELSE 1 END AS IsDocumentoRimborsoDiretto
   ,D_TipoIncarico.Descrizione AS tipoincarico
   ,T_Incarico.IdIncarico
   ,T_Incarico.CodTipoIncarico
   ,T_Mandato.NumeroMandato
   ,T_Mandato.DataSottoscrizione
   ,T_Mandato.NumeroContratto AS MandatoRTO
   ,D_TipoRaccomandazione.Descrizione AS TipoRaccomandazione
   ,T_Dossier.NumeroDossier
   ,primo.ChiaveCliente
   ,ISNULL(primo.Cognome, primo.RagioneSociale) + ' ' + ISNULL(primo.Nome, '') AS cliente1
   ,primo.CodiceFiscale AS CodiceFiscale1
   ,ruolo1.Codice AS Cod_Ruolo1
   ,ruolo1.Descrizione AS Ruolo1
   ,D_TipoOperazioneAzimut.Descrizione AS TipoOperazione
   ,E_SocietaProdottoAzimut.Descrizione AS SP
   ,E_MacroProdottoAzimut.Descrizione AS MP
   ,E_ProdottoAzimut.Descrizione AS P
   ,T_OperazioneAzimut.IdOperazioneAzimut
   ,T_OperazioneAzimut.Importo
   ,E_ProdottoAzimut.Isin
   ,T_OperazioneAzimut.NumeroQuoteAzioni
   ,T_OperazioneAzimut.ValoreQuoteInEuro
   ,T_OperazioneAzimut.ValoreQuoteInDivisaFondo
   ,T_OperazioneAzimut.PercentualeSconto
   ,D_TipoPagamento.Descrizione AS TipoPagamento
   ,D_ModalitaPagamento.Descrizione AS ModalitaPagamento
   ,T_PagamentoInvestimento.NumeroAssegno
   ,T_Mandato.NumeroDisposizione
   ,T_PagamentoInvestimento.IbanDestinazione
   ,T_OperazioneAzimut.ClasseFondo
   ,T_Promotore.Codice AS CodicePF
   ,p.Nome AS NomePF
   ,p.Cognome AS CognomePF
   ,D_TipoMandato.Descrizione AS Tipomandato
   ,D_ProvenienzaDenaro.Descrizione AS ProvenienzaDenaro
   ,dispositore.Testo AS Chiave_Dispositore
   ,beneficiario.Testo AS Chiave_Beneficiario
   ,SocietaSIA
   ,ProdottoSIA
   ,DataCreazione
   ,ISNULL(CodTipoFea, 3) CodTipoFea
   ,
	--L_WorkflowIncarico.DataTransizione TransizioneDocImbarcatoPrecompila
	MIN(DataInserimento) Datainserimento
   ,MAX(L_WorkflowIncarico.DataTransizione) DataRegolamentoSospeso


FROM T_Incarico
	INNER JOIN D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico

	LEFT JOIN T_R_Incarico_Mandato ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
	LEFT JOIN T_Mandato	ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
	LEFT JOIN T_Dossier	ON T_Dossier.IdDossier = T_Mandato.IdDossier
	LEFT JOIN T_R_Dossier_Persona AS dossier1 ON dossier1.IdDossier = T_Dossier.IdDossier AND dossier1.Progressivo = 1
	LEFT JOIN T_Persona AS primo ON primo.IdPersona = dossier1.IdPersona

	LEFT OUTER JOIN D_RuoloRichiedente AS ruolo1 ON dossier1.CodRuoloRichiedente = ruolo1.Codice

	LEFT OUTER JOIN T_Promotore	ON T_Dossier.IdPromotore = T_Promotore.IdPromotore
	LEFT OUTER JOIN T_Persona AS p	ON p.IdPersona = T_Promotore.IdPersona

	LEFT OUTER JOIN T_OperazioneAzimut	ON T_OperazioneAzimut.IdIncarico = T_Incarico.IdIncarico
	LEFT OUTER JOIN D_TipoOperazioneAzimut	ON D_TipoOperazioneAzimut.Codice = T_OperazioneAzimut.CodTipoOperazioneAzimut
	LEFT OUTER JOIN D_TipoMandato	ON T_OperazioneAzimut.CodTipoMandato = D_TipoMandato.Codice
	LEFT OUTER JOIN E_MacroProdottoAzimut	ON E_MacroProdottoAzimut.IdMacroProdottoAzimut = T_OperazioneAzimut.IdMacroProdottoAzimut
	LEFT OUTER JOIN E_ProdottoAzimut	ON E_ProdottoAzimut.IdProdottoAzimut = T_OperazioneAzimut.IdProdottoAzimut
	LEFT OUTER JOIN E_SocietaProdottoAzimut	ON E_SocietaProdottoAzimut.IdSocietaProdottoAzimut = E_MacroProdottoAzimut.IdSocietaProdottoAzimut

	LEFT OUTER JOIN T_DatiAggiuntiviIncaricoAzimut	ON T_DatiAggiuntiviIncaricoAzimut.IdIncarico = T_Incarico.IdIncarico
	LEFT OUTER JOIN D_TipoRaccomandazione	ON T_DatiAggiuntiviIncaricoAzimut.CodTipoRaccomandazione = D_TipoRaccomandazione.Codice

	LEFT OUTER JOIN D_ProvenienzaDenaro	ON D_ProvenienzaDenaro.Codice = T_DatiAggiuntiviIncaricoAzimut.CodProvenienzaDenaro
	LEFT OUTER JOIN T_PagamentoInvestimento	ON T_Incarico.IdIncarico = T_PagamentoInvestimento.IdIncarico
																				AND T_PagamentoInvestimento.CodTipoPagamento <> 38
																				AND T_PagamentoInvestimento.FlagAttivo = 1
	LEFT OUTER JOIN D_TipoPagamento	ON T_PagamentoInvestimento.CodTipoPagamento = D_TipoPagamento.Codice
	LEFT OUTER JOIN D_ModalitaPagamento	ON D_ModalitaPagamento.Codice = T_PagamentoInvestimento.CodModalitaPagamento

	LEFT OUTER JOIN T_DatoAggiuntivo dispositore	ON dispositore.IdIncarico = T_Incarico.IdIncarico
																				AND dispositore.CodTipoDatoAggiuntivo = 1077
	LEFT OUTER JOIN T_DatoAggiuntivo beneficiario ON beneficiario.IdIncarico = T_Incarico.IdIncarico
																				AND beneficiario.CodTipoDatoAggiuntivo = 1044

	LEFT JOIN scratch.R_ISIN_Societa_Prodotto_SIA ON E_ProdottoAzimut.Isin = scratch.R_ISIN_Societa_Prodotto_SIA.Isin
	JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
	LEFT JOIN L_WorkflowIncarico ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
																				AND CodStatoWorkflowIncaricoPartenza = 8570
																				AND CodStatoWorkflowIncaricoDestinazione = 6603 -- regolarizzata -> acquisita --> pronta caricamento fend

	--andrea:
	LEFT JOIN T_Documento docrimborso ON docrimborso.IdIncarico = T_Incarico.IdIncarico
																				AND docrimborso.Tipo_Documento = 20045	--modulo sottoscrizione non standard ("rimborso diretto")


WHERE (T_Incarico.CodCliente = 23)
AND (T_Incarico.CodTipoIncarico IN (323))
--AND (T_Incarico.CodArea = 8)
--AND (T_Incarico.CodStatoWorkflowIncarico IN (6603, 6604, 6605, 6500))



/*
Creata
Pronta per caricamento FEND
In Attesa Versamento Assegno
In Attesa Ricezione Bonifico
*/
--AND T_Incarico.IdIncarico = 9602909


GROUP BY 
CASE WHEN docrimborso.IdIncarico IS NULL THEN 0 ELSE 1 END,
D_TipoIncarico.Descrizione ,
T_Incarico.IdIncarico,
T_Incarico.CodTipoIncarico,
T_Mandato.NumeroMandato, 
T_Mandato.DataSottoscrizione, 
T_Mandato.NumeroContratto, 
D_TipoRaccomandazione.Descrizione , 
T_Dossier.NumeroDossier, 
primo.ChiaveCliente, 
ISNULL(primo.Cognome,primo.RagioneSociale) + ' '+ISNULL(primo.Nome,'') ,
primo.CodiceFiscale , 
ruolo1.Codice ,
ruolo1.Descrizione , 
D_TipoOperazioneAzimut.Descrizione ,
E_SocietaProdottoAzimut.Descrizione , 
E_MacroProdottoAzimut.Descrizione , 
E_ProdottoAzimut.Descrizione , 
T_OperazioneAzimut.IdOperazioneAzimut, 
T_OperazioneAzimut.Importo, E_ProdottoAzimut.Isin, 
T_OperazioneAzimut.NumeroQuoteAzioni, 
T_OperazioneAzimut.ValoreQuoteInEuro, 
T_OperazioneAzimut.ValoreQuoteInDivisaFondo, 
T_OperazioneAzimut.PercentualeSconto, 
D_TipoPagamento.Descrizione  , 
D_ModalitaPagamento.Descrizione , 
T_PagamentoInvestimento.NumeroAssegno, 
T_Mandato.NumeroDisposizione, 
T_PagamentoInvestimento.IbanDestinazione, 
T_OperazioneAzimut.ClasseFondo, 
T_Promotore.Codice  , 
p.Nome , 
p.Cognome , 
D_TipoMandato.Descrizione  , 
D_ProvenienzaDenaro.Descrizione , 
dispositore.Testo  ,
beneficiario.Testo  ,
SocietaSIA,
ProdottoSIA,
DataCreazione,
CodTipoFea


--SELECT * FROM T_DatoAggiuntivo where IdIncarico = 9125109 











--WHERE        (T_Incarico.CodCliente = 23) AND (T_Incarico.CodTipoIncarico IN (323)) AND (T_Incarico.CodArea = 8) AND (T_DatiAggiuntiviIncaricoAzimut.CodTipoFea IN (1, 2)) AND 
--                         (T_Incarico.CodStatoWorkflowIncarico IN (6603, 6604, 6605)) AND (T_Incarico.DataCreazione >= @DataCreazioneFEADA) AND 
--                         (T_Incarico.DataCreazione < @DataCreazioneFEAA)
--ORDER BY T_DatiAggiuntiviIncaricoAzimut.CodTipoFea, T_Incarico.DataCreazione












--selecT*
--from [rs].[v_CESAM_AZ_AFB_Report_CaricamentoSwitch]
--where 

----(CodTipoFea = 3) AND (DataUltimaTransizione >= @oggi) AND (CodAttributoIncarico = 1521) 

----OR


--(CodTipoFea <> 3)  AND (DataCreazione >= @DataCreazioneFEADA) AND (DataCreazione < @DataCreazioneFEAA)


--WHERE         AND (T_DatiAggiuntiviIncaricoAzimut.CodTipoFea IN (1, 2)) AND 
--                         AND (T_Incarico.DataCreazione >= @DataCreazioneFEADA) AND 
--                         (T_Incarico.DataCreazione < @DataCreazioneFEAA)
--ORDER BY T_DatiAggiuntiviIncaricoAzimut.CodTipoFea, T_Incarico.DataCreazione

GO

