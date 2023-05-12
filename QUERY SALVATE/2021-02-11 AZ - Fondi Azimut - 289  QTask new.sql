WITH estrazione AS (

SELECT T_MovimentoContoBancario.IdMovimentoContoBancario
,T_MovimentoContoBancario.DataImport
,T_MovimentoContoBancario.DataConferma DataRiconciliazioneQTask
,Stampa.DataTransizione DataStampa
,T_MovimentoContoBancario.Importo ImportoMovimentoRiconciliato
,T_NotaIncarichi.Testo DescrizioneMovimento
,T_Incarico.IdIncarico
,T_Incarico.CodTipoIncarico
,d.TipoIncarico
,d.StatoWorkflowIncarico
,T_PagamentoInvestimento.Importo ImportoPagamentoRiconciliato
,van.ChiaveClienteIntestatario
,CASE WHEN van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = ''
	THEN van.RagioneSocialeIntestatario
	ELSE van.CognomeIntestatario + ISNULL(' ' + van.NomeIntestatario,'')
	END Intestatario
,Operazioni.N_Prodotti
,Operazioni.SommaImportoIncarichi
,ISNULL(T_Mandato.NumeroMandato,Mandato.Testo) NumeroMandato
,prodotto.CodiceFend + ' - ' + E_ProdottoAzimut.Descrizione DescrizioneProdotto
,T_OperazioneAzimut.Importo ImportoProdottoIncarico
,CodTipoProdottoDispositive
,IdPagamento

,CASE WHEN CodTipoProdottoDispositive IN (4) THEN 'PAC'
	WHEN CodTipoProdottoDispositive IN (1,2,3) THEN 'PIC + MultiPAC'


	WHEN T_Incarico.CodTipoIncarico = 693 AND CodSocietaPAC.Testo = '74'  THEN 'Rata PAC'
	WHEN T_Incarico.CodTipoIncarico = 693 AND CodSocietaPAC.Testo = '77' THEN 'Rata MultiPAC'

	WHEN CodTipoOperazioneAzimut = 1
		AND Operazioni.N_Prodotti > 1 AND Operazioni.N_Prodotti <= 5 
		THEN 'PIC + MultiPAC'

	WHEN CodTipoOperazioneAzimut = 32
		AND Operazioni.N_Prodotti > 1 AND Operazioni.N_Prodotti <= 5 
		THEN 'PIC + MultiPAC'
	WHEN CodTipoOperazioneAzimut = 1
		AND Operazioni.N_Prodotti > 5 
		THEN 'PIC + MultiPAC'
	WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 
		AND Operazioni.N_Prodotti = 1 
		AND	T_OperazioneAzimut.Importo < 500 THEN 'PAC'

	WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 
		AND Operazioni.N_Prodotti = 1 
		AND T_OperazioneAzimut.Importo < 500 THEN  'PAC'

	WHEN CodTipoOperazioneAzimut = 1 
		AND Operazioni.N_Prodotti = 1 
		AND T_OperazioneAzimut.Importo >= 500 THEN 'PAC'

	WHEN CodTipoOperazioneAzimut = 32 
		AND	Operazioni.N_Prodotti = 1 
		AND	T_OperazioneAzimut.Importo >= 500 THEN 'PAC'		

	WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 
		AND Operazioni.N_Prodotti = 1 
		AND	T_OperazioneAzimut.Importo < 500 THEN 'PAC'

	WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 
		AND Operazioni.N_Prodotti > 1 
		AND	T_OperazioneAzimut.Importo < 500 THEN 'PIC + MultiPAC'

	WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 
		AND	Operazioni.N_Prodotti = 1 
		AND	T_OperazioneAzimut.Importo < 500 THEN 'PAC'

	WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 
		AND	Operazioni.N_Prodotti > 1 
		AND	T_OperazioneAzimut.Importo < 500 THEN 'PIC + MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 THEN 'PIC + MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 THEN 'PIC + MultiPAC'
 END TipoDispositiva


FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno

JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND Abi = '03479' AND Cab = '01600'
AND NumeroConto IN (
'802260103'
--,'802260302'
--,''
)
JOIN T_NotaIncarichi ON T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi
JOIN T_R_Incarico_MovimentoContoBancario ON T_MovimentoContoBancario.IdMovimentoContoBancario = T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario
JOIN T_Incarico ON T_R_Incarico_MovimentoContoBancario.IdIncarico = T_Incarico.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON T_Incarico.IdIncarico = d.IdIncarico

LEFT JOIN T_R_Incarico_Mandato ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
AND T_R_Incarico_Mandato.Progressivo = 1
LEFT JOIN T_Mandato ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
LEFT JOIN T_DatoAggiuntivo Mandato ON T_Incarico.IdIncarico = Mandato.IdIncarico
AND Mandato.FlagAttivo = 1
AND Mandato.CodTipoDatoAggiuntivo = 230


OUTER APPLY (
				SELECT ISNULL(COUNT(topax.IdOperazioneAzimut),0) N_Prodotti, ISNULL(SUM(topax.Importo),0) SommaImportoIncarichi, IdIncarico
				
				FROM T_OperazioneAzimut topax
				WHERE topax.FlagAttivo = 1
				AND topax.IdIncarico = T_Incarico.IdIncarico
				GROUP BY IdIncarico
				
) Operazioni


OUTER APPLY (
				SELECT max(DataTransizione) DataTransizione
				--DataTransizione
				, L_WorkflowIncarico.IdIncarico, CONVERT(DATE,DataTransizione) GiornoTransizione
				FROM L_WorkflowIncarico
				WHERE L_WorkflowIncarico.IdIncarico = T_Incarico.idincarico
				AND ( 
						( CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
							AND CodStatoWorkflowIncaricoDestinazione = 20606
						) 
					 OR (
						  (CodAttributoIncaricoPartenza IS NULL OR CodAttributoIncaricoPartenza != CodAttributoIncaricoDestinazione)
							AND CodAttributoIncaricoDestinazione = 17473
					   )
					)
			
				AND CONVERT(DATE,DataTransizione) = CONVERT(DATE,DataConferma)
				GROUP BY IdIncarico, CONVERT(date,DataTransizione)
) Stampa

LEFT JOIN T_PagamentoInvestimento ON T_Incarico.IdIncarico = T_PagamentoInvestimento.IdIncarico
AND T_PagamentoInvestimento.FlagAttivo = 1
AND T_MovimentoContoBancario.IdMovimentoContoBancario = T_PagamentoInvestimento.IdMovimentoContoBancario

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON T_Incarico.IdIncarico = van.IdIncarico
AND van.ProgressivoPersona = 1

LEFT JOIN T_OperazioneAzimut ON T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico
LEFT JOIN E_ProdottoAzimut ON T_OperazioneAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut
OUTER APPLY (SELECT TOP 1  CodiceFend FROM scratch.CESAM_AZ_Import_FondiAzimut WHERE E_ProdottoAzimut.Isin = Isin) prodotto

LEFT JOIN T_DatoAggiuntivo CodSocietaPAC ON T_Incarico.IdIncarico = CodSocietaPAC.IdIncarico
AND CodSocietaPAC.CodTipoDatoAggiuntivo = 2125 --Societa Prodotto


WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 23
--AND T_Incarico.IdIncarico = 16466557

--AND T_Incarico.CodTipoIncarico IN (@TipiIncarico)

--AND DataConferma >= @DataUltimaTransizioneDal 
--AND DataConferma < @DataUltimaTransizioneAl
AND DataConferma >= '20210222' AND DataConferma < '20210223'
)

SELECT DISTINCT IdMovimentoContoBancario
			   ,DataImport
			   ,DataRiconciliazioneQTask
			   ,DataStampa
			   ,ImportoMovimentoRiconciliato
			   ,DescrizioneMovimento
			   ,IdIncarico
			   ,CodTipoIncarico
			   ,TipoIncarico
			   ,StatoWorkflowIncarico
			   ,ImportoPagamentoRiconciliato
			   ,ChiaveClienteIntestatario
			   ,Intestatario
			   ,N_Prodotti
			   ,SommaImportoIncarichi
			   ,NumeroMandato
			   ,IdPagamento
			   ,TipoDispositiva

FROM estrazione

