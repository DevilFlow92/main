USE CLC
GO

/*
FR0011981851
FR0010923375
FR0010923359
FR0011015460
FR0010923367

*/

SELECT T_Incarico.IdIncarico
		,DataCreazione
		,DataUltimaTransizione
		,DataUltimaModifica
		--,T_Incarico.CodTipoIncarico
		,descrizioni.TipoIncarico
		,descrizioni.StatoWorkflowIncarico
		,anagrafica.ChiaveClienteIntestatario
		,IIF(anagrafica.CognomeIntestatario IS null OR anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomeIntestatario) + ' ' + ISNULL(anagrafica.NomeIntestatario,'') Intestatario
		,anagrafica.CodicePromotore
		,IIF(anagrafica.CognomePromotore IS NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomePromotore,'') Promotore

		,NumeroDossier
		,NumeroMandato
		,NumeroDisposizione
		,NumeroSimula
		,DataSottoscrizione DataSottoscrizioneMandato
		,E_SocietaProdottoAzimut.Descrizione SocietaProdotto
		,E_MacroProdottoAzimut.Descrizione MacroProdotto
		,E_ProdottoAzimut.Descrizione Prodotto
		,Isin
		,CAST(Importo AS DECIMAL(18,2)) Importo


FROM T_Incarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON T_Incarico.IdIncarico = anagrafica.IdIncarico AND anagrafica.ProgressivoPersona = 1
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON T_Incarico.IdIncarico = descrizioni.IdIncarico
left JOIN T_R_Incarico_Mandato ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
left JOIN T_Mandato ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
left JOIN T_Dossier ON T_Mandato.IdDossier = T_Dossier.IdDossier
left JOIN T_OperazioneAzimut ON T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico
--AND T_Mandato.IdMandato = T_OperazioneAzimut.IdMandato

left JOIN E_ProdottoAzimut ON T_OperazioneAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut
left JOIN E_R_MacroProdottoAzimut_ProdottoAzimut ON E_ProdottoAzimut.IdProdottoAzimut = E_R_MacroProdottoAzimut_ProdottoAzimut.IdProdottoAzimut
left JOIN E_MacroProdottoAzimut ON T_OperazioneAzimut.IdMacroProdottoAzimut = E_MacroProdottoAzimut.IdMacroProdottoAzimut
left JOIN E_SocietaProdottoAzimut ON E_MacroProdottoAzimut.IdSocietaProdottoAzimut = E_SocietaProdottoAzimut.IdSocietaProdottoAzimut

WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico IN (321,322)
AND T_Incarico.CodStatoWorkflowIncarico IN ( 

6605	--In Attesa Ricezione Bonifico
,14336	--In Attesa di Bonifico MAX FUNDS
)
AND E_ProdottoAzimut.Isin IN ('FR0011981851'
,'FR0010923375'
,'FR0010923359'
,'FR0011015460'
,'FR0010923367'
)

--EXEC orga.CESAM_AZ_VariazioneIncarichi