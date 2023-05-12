USE CLC
GO


--ALTER VIEW rs.v_CESAM_AZ_AFB_Report_CaricamentoRimborsi as

SELECT
	CASE
		WHEN NumeroMandato IS NULL THEN 0
		ELSE 1
	END AS IsDossierPopolato
   ,D_TipoIncarico.Descrizione AS tipoincarico
   ,T_Incarico.IdIncarico
   ,T_Incarico.CodTipoIncarico
   ,T_Incarico.CodStatoWorkflowIncarico
   ,T_Mandato.NumeroMandato
   ,T_Mandato.DataSottoscrizione
   ,T_Mandato.NumeroContratto AS MandatoRTO
   ,D_TipoRaccomandazione.Descrizione AS TipoRaccomandazione
   ,T_Dossier.NumeroDossier
   ,primo.ChiaveCliente
   ,ISNULL(ISNULL(primo.Cognome, primo.RagioneSociale) + ' ' + ISNULL(primo.Nome, ''), ISNULL(anagrafica.CognomeIntestatario, anagrafica.RagioneSocialeIntestatario) + ' ' + anagrafica.NomeIntestatario) AS cliente1
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
   ,ISNULL(T_Promotore.Codice, anagrafica.CodicePromotore) AS CodicePF
   ,ISNULL(p.Nome, anagrafica.NomePromotore) AS NomePF
   ,ISNULL(p.Cognome, anagrafica.CognomePromotore) AS CognomePF
   ,D_TipoMandato.Descrizione AS Tipomandato
   ,D_ProvenienzaDenaro.Descrizione AS ProvenienzaDenaro
   ,dispositore.Testo AS Chiave_Dispositore
   ,beneficiario.Testo AS Chiave_Beneficiario

   --,IdPersonaEsecutore
   ,Persona_esecutore.ChiaveCliente ChiaveClienteEsecutore
   ,ISNULL(Persona_esecutore.Cognome,Persona_esecutore.RagioneSociale) + SPACE(1) + ISNULL(Persona_esecutore.Nome,'') Esecutore
   --,IdPersonaBeneficiario
   ,Persona_beneficiario.ChiaveCliente ChiaveClienteBeneficiario
   ,ISNULL(Persona_beneficiario.Cognome,Persona_beneficiario.RagioneSociale) + SPACE(1) + ISNULL(Persona_beneficiario.Nome,'') Beneficiario

   ,SocietaSIA
   ,ProdottoSIA
   ,DataCreazione
   ,ISNULL(CodTipoFea, 3) CodTipoFea
   ,
	--L_WorkflowIncarico.DataTransizione TransizioneDocImbarcatoPrecompila
	MIN(DataInserimento) Datainserimento
   ,MAX(L_WorkflowIncarico.DataTransizione) DataRegolamentoSospeso
   ,CASE WHEN E_SocietaProdottoAzimut.IdSocietaProdottoAzimut IN (22
   ,92
   ,116
   ,156
   ,29
   ,113
   ,7
   ,110
   ,194
   ,26
   ,106
   ,123
   ,134
   ,192
   ,167 --GoldMan Sachs
   ,143 --T ROWE PRICE FUNDS SICAV
   )
   THEN 1 ELSE 0 END AS FlagDueDecimali
   ,IIF(DataCreazione >= '20180701', NumeroRaccomandazione, NULL) AS NumeroRaccomandazione
   
FROM T_Incarico
INNER JOIN D_TipoIncarico
	ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico
LEFT JOIN T_R_Incarico_Mandato
	ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
LEFT JOIN T_Mandato
	ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
LEFT JOIN T_Dossier
	ON T_Dossier.IdDossier = T_Mandato.IdDossier
LEFT JOIN T_R_Dossier_Persona AS dossier1
	ON dossier1.IdDossier = T_Dossier.IdDossier
LEFT JOIN T_Persona AS primo
	ON primo.IdPersona = dossier1.IdPersona
LEFT OUTER JOIN D_RuoloRichiedente AS ruolo1
	ON dossier1.CodRuoloRichiedente = ruolo1.Codice
LEFT OUTER JOIN T_Promotore
	ON T_Dossier.IdPromotore = T_Promotore.IdPromotore
LEFT OUTER JOIN T_Persona AS p
	ON p.IdPersona = T_Promotore.IdPersona
LEFT OUTER JOIN T_OperazioneAzimut
	ON T_OperazioneAzimut.IdIncarico = T_Incarico.IdIncarico
		AND (T_OperazioneAzimut.FlagAttivo = 1)
LEFT OUTER JOIN D_TipoOperazioneAzimut
	ON D_TipoOperazioneAzimut.Codice = T_OperazioneAzimut.CodTipoOperazioneAzimut
LEFT OUTER JOIN D_TipoMandato
	ON T_OperazioneAzimut.CodTipoMandato = D_TipoMandato.Codice
LEFT OUTER JOIN E_MacroProdottoAzimut
	ON E_MacroProdottoAzimut.IdMacroProdottoAzimut = T_OperazioneAzimut.IdMacroProdottoAzimut
LEFT OUTER JOIN E_ProdottoAzimut
	ON E_ProdottoAzimut.IdProdottoAzimut = T_OperazioneAzimut.IdProdottoAzimut
LEFT OUTER JOIN E_SocietaProdottoAzimut
	ON E_SocietaProdottoAzimut.IdSocietaProdottoAzimut = E_MacroProdottoAzimut.IdSocietaProdottoAzimut
LEFT OUTER JOIN T_DatiAggiuntiviIncaricoAzimut
	ON T_DatiAggiuntiviIncaricoAzimut.IdIncarico = T_Incarico.IdIncarico
LEFT OUTER JOIN D_TipoRaccomandazione
	ON T_DatiAggiuntiviIncaricoAzimut.CodTipoRaccomandazione = D_TipoRaccomandazione.Codice
LEFT OUTER JOIN D_ProvenienzaDenaro
	ON D_ProvenienzaDenaro.Codice = T_DatiAggiuntiviIncaricoAzimut.CodProvenienzaDenaro
LEFT OUTER JOIN T_PagamentoInvestimento
	ON T_Incarico.IdIncarico = T_PagamentoInvestimento.IdIncarico
		AND T_PagamentoInvestimento.CodTipoPagamento <> 38
		AND T_PagamentoInvestimento.FlagAttivo = 1
LEFT OUTER JOIN D_TipoPagamento
	ON T_PagamentoInvestimento.CodTipoPagamento = D_TipoPagamento.Codice
LEFT OUTER JOIN D_ModalitaPagamento
	ON D_ModalitaPagamento.Codice = T_PagamentoInvestimento.CodModalitaPagamento

LEFT OUTER JOIN T_DatoAggiuntivo dispositore
	ON dispositore.IdIncarico = T_Incarico.IdIncarico
		AND dispositore.CodTipoDatoAggiuntivo = 1077
LEFT OUTER JOIN T_DatoAggiuntivo beneficiario
	ON beneficiario.IdIncarico = T_Incarico.IdIncarico
		AND beneficiario.CodTipoDatoAggiuntivo = 1044

LEFT JOIN T_Persona Persona_esecutore ON T_DatiAggiuntiviIncaricoAzimut.IdPersonaEsecutore = Persona_esecutore.IdPersona
LEFT JOIN T_Persona Persona_beneficiario ON T_DatiAggiuntiviIncaricoAzimut.IdPersonaBeneficiario = Persona_beneficiario.IdPersona

LEFT JOIN scratch.R_ISIN_Societa_Prodotto_SIA
	ON E_ProdottoAzimut.Isin = scratch.R_ISIN_Societa_Prodotto_SIA.Isin
JOIN T_Documento
	ON T_Incarico.IdIncarico = T_Documento.IdIncarico
LEFT JOIN L_WorkflowIncarico
	ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
		AND CodStatoWorkflowIncaricoPartenza = 8570
		AND CodStatoWorkflowIncaricoDestinazione = 6603
-- regolarizzata -> acquisita --> pronta caricamento fend

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
	ON T_Incarico.IdIncarico = anagrafica.IdIncarico

WHERE (T_Incarico.CodCliente = 23)
AND (T_Incarico.CodTipoIncarico IN (323))
AND (T_Incarico.CodArea = 8)
AND (T_Incarico.CodStatoWorkflowIncarico IN (6603, 6604, 6605, 6500))


/*
Creata
Pronta per caricamento FEND
In Attesa Versamento Assegno
In Attesa Ricezione Bonifico
*/

--AND T_Incarico.IdIncarico = 9602909

--AND T_Incarico.IdIncarico = 9940062


GROUP BY CASE
		WHEN NumeroMandato IS NULL THEN 0
		ELSE 1
	END
   ,D_TipoIncarico.Descrizione 
   ,T_Incarico.IdIncarico
   ,T_Incarico.CodTipoIncarico
   ,T_Incarico.CodStatoWorkflowIncarico
   ,T_Mandato.NumeroMandato
   ,T_Mandato.DataSottoscrizione
   ,T_Mandato.NumeroContratto 
   ,D_TipoRaccomandazione.Descrizione 
   ,T_Dossier.NumeroDossier
   ,primo.ChiaveCliente
   ,ISNULL(ISNULL(primo.Cognome, primo.RagioneSociale) + ' ' + ISNULL(primo.Nome, ''), ISNULL(anagrafica.CognomeIntestatario, anagrafica.RagioneSocialeIntestatario) + ' ' + anagrafica.NomeIntestatario) 
   ,primo.CodiceFiscale 
   ,ruolo1.Codice
   ,ruolo1.Descrizione
   ,D_TipoOperazioneAzimut.Descrizione 
   ,E_SocietaProdottoAzimut.Descrizione 
   ,E_MacroProdottoAzimut.Descrizione 
   ,E_ProdottoAzimut.Descrizione 
   ,T_OperazioneAzimut.IdOperazioneAzimut
   ,T_OperazioneAzimut.Importo
   ,E_ProdottoAzimut.Isin
   ,T_OperazioneAzimut.NumeroQuoteAzioni
   ,T_OperazioneAzimut.ValoreQuoteInEuro
   ,T_OperazioneAzimut.ValoreQuoteInDivisaFondo
   ,T_OperazioneAzimut.PercentualeSconto
   ,D_TipoPagamento.Descrizione 
   ,D_ModalitaPagamento.Descrizione 
   ,T_PagamentoInvestimento.NumeroAssegno
   ,T_Mandato.NumeroDisposizione
   ,T_PagamentoInvestimento.IbanDestinazione
   ,T_OperazioneAzimut.ClasseFondo
   ,ISNULL(T_Promotore.Codice, anagrafica.CodicePromotore) 
   ,ISNULL(p.Nome, anagrafica.NomePromotore) 
   ,ISNULL(p.Cognome, anagrafica.CognomePromotore) 
   ,D_TipoMandato.Descrizione 
   ,D_ProvenienzaDenaro.Descrizione 
   ,dispositore.Testo 
   ,beneficiario.Testo

   --,IdPersonaEsecutore
   ,Persona_esecutore.ChiaveCliente 
   ,ISNULL(Persona_esecutore.Cognome,Persona_esecutore.RagioneSociale) + SPACE(1) + ISNULL(Persona_esecutore.Nome,'') 
   --,IdPersonaBeneficiario
   ,Persona_beneficiario.ChiaveCliente 
   ,ISNULL(Persona_beneficiario.Cognome,Persona_beneficiario.RagioneSociale) + SPACE(1) + ISNULL(Persona_beneficiario.Nome,'') 

   ,SocietaSIA
   ,ProdottoSIA
   ,DataCreazione
   ,ISNULL(CodTipoFea, 3) 
   
	--L_WorkflowIncarico.DataTransizione TransizioneDocImbarcatoPrecompila

   ,CASE WHEN E_SocietaProdottoAzimut.IdSocietaProdottoAzimut IN (22
   ,92
   ,116
   ,156
   ,29
   ,113
   ,7
   ,110
   ,194
   ,26
   ,106
   ,123
   ,134
   ,192
   ,167 --GoldMan Sachs
   ,143 --T ROWE PRICE FUNDS SICAV
   )
   THEN 1 ELSE 0 END 
   ,IIF(DataCreazione >= '20180701', NumeroRaccomandazione, NULL)

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
