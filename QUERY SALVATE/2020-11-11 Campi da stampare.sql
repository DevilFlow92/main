USE CLC
GO

ALTER VIEW rs.v_CESAM_AZ_TransferAgent_StampaRiconciliati AS


/*
11/11/2020
Lorenzo Spanu

Edit: Lorenzo Fiori
*/

--SELECT * FROM rs.v_CESAM_AZ_TransferAgent_StampaRiconciliati

SELECT 
	dbo.T_Incarico.IdIncarico
	,dbo.T_Incarico.CodTipoIncarico
   ,dbo.T_Documento.Documento_id
   ,Codice CodTipoDocumento
   ,D_Documento.Descrizione TipoDocumento
   ,dbo.T_Documento.Nome_file
   ,IIF(Nome_file LIKE '%.pdf',1,0) FlagPDF
   , --CAST(CAST(T_PagamentoInvestimento.Importo AS INT) AS VARCHAR(50)) + '_' 
   --CAST(dbo.T_MovimentoContoBancario.IdMovimentoContoBancario AS VARCHAR(20)) + '_' +
    CAST(dbo.T_Incarico.IdIncarico AS VARCHAR(20)) 
			+ '_' + CAST(Documento_id AS VARCHAR(30)) 
			+ '_' + CAST((ROW_NUMBER() OVER (PARTITION BY T_Incarico.IdIncarico, T_MovimentoContoBancario.IdMovimentoContoBancario ORDER BY T_Incarico.IdIncarico, T_MovimentoContoBancario.IdMovimentoContoBancario, T_Documento.Documento_id)) AS VARCHAR(3))
		 NomeFileOutput
   ,RIGHT(Nome_file, 4) EstensioneFileOutput
   ,T_MovimentoContoBancario.IdMovimentoContoBancario
   ,CAST(FORMAT(T_MovimentoContoBancario.Importo,'N','de-de') AS VARCHAR(100)) Importo
   ,CAST(FORMAT(SUM(ISNULL(T_OperazioneAzimut.Importo,0)),'N','de-de') AS VARCHAR(100)) ImportoIncarichi --Totale Somma Operazioni legate all'Incarico
   ,ISNULL(FORMAT(T_MovimentoContoBancario.DataValuta,'dd/MM/yyyy'),'N/D') DataValuta
   ,ISNULL(FORMAT(T_MovimentoContoBancario.DataOperazione,'dd/MM/yyyy'),'N/D') DataContabile
   ,ISNULL(ISNULL(T_MovimentoContoBancario.IbanOrdinante, Iban.IbanOrdinante),'N/D') IbanOrdinante
   ,ISNULL(SUBSTRING(isnull(T_MovimentoContoBancario.IbanOrdinante, Iban.IbanOrdinante),6,5),'N/D') Abi
   ,ISNULL(SUBSTRING(isnull(T_MovimentoContoBancario.IbanOrdinante,Iban.IbanOrdinante),11,5),'N/D') Cab
   ,ISNULL(SUBSTRING(ISNULL(T_MovimentoContoBancario.IbanOrdinante,iban.IbanOrdinante),16,4) + ' ' 
		  + SUBSTRING(ISNULL(T_MovimentoContoBancario.IbanOrdinante,iban.IbanOrdinante),20,4) + ' '
		  + SUBSTRING(ISNULL(T_MovimentoContoBancario.IbanOrdinante,iban.IbanOrdinante),24,4)
   ,'0') NumeroConto
   ,ISNULL(Ordinante.RiferimentoOrdinante,'N/D') RiferimentoOrdinante
   ,ISNULL(DescrizioneMovimento.Causale,'N/D') Causale
   ,CASE WHEN NotaAggiuntiva IS NULL OR NotaAggiuntiva = '' OR NotaAggiuntiva = ' ' THEN 'Nessuna'
    ELSE NotaAggiuntiva END NotaAggiuntiva

	,CASE WHEN NotaAggiuntiva LIKE '%maxfunds%' 
		--AND T_Incarico.CodTipoIncarico =  553
		THEN 'MAXFUNDS'
	 --WHEN T_Incarico.CodTipoIncarico = 553 THEN 'VERSAMENTI AGGIUNTIVI F2B'
	 --WHEN NotaAggiuntiva LIKE '%*%-%*%' THEN 'PAC'
	 ELSE 'RICONCILIATI'
	 END Gruppo

	 ,CASE WHEN T_Pagamento.IdPagamento IS NULL THEN 1 ELSE 0 END FlagErroreRiconciliazione
	 ,ISNULL((
		SELECT 
		 dbo.GROUP_CONCAT_D(CodiceNadir.CodiceFend + ' - ' + CAST(FORMAT(ISNULL(topa.Importo,0),'N','de-de') AS VARCHAR(100)),' ; ')
		
		FROM T_Incarico ti
		JOIN T_OperazioneAzimut  topa ON ti.IdIncarico = topa.IdIncarico
		AND topa.FlagAttivo = 1
		JOIN E_ProdottoAzimut epa ON topa.IdProdottoAzimut = epa.IdProdottoAzimut
		OUTER APPLY (
						SELECT TOP 1 fondi.Isin, fondi.CodiceFend
						FROM scratch.CESAM_AZ_Import_FondiAzimut fondi
						WHERE fondi.isin = epa.Isin
		) CodiceNadir

		WHERE ti.CodArea = 8
		AND ti.CodCliente = 23
		AND ti.CodTipoIncarico IN (83,540,553)
	
		AND ti.IdIncarico = T_Incarico.IdIncarico
		
	 ),'N/D') DettaglioProdotti


FROM dbo.T_Incarico
JOIN dbo.T_Documento
	ON dbo.T_Incarico.IdIncarico = dbo.T_Documento.IdIncarico
	AND dbo.T_Documento.FlagPresenzaInFileSystem = 1
	AND dbo.T_Documento.FlagScaduto = 0
	AND ( Nome_file LIKE '%.pdf' OR Nome_file LIKE '%.png' OR Nome_file LIKE '%.jpg' OR Nome_file LIKE '%.jpeg')

JOIN D_Documento ON T_Documento.Tipo_Documento = D_Documento.Codice

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico WF
	ON dbo.T_Incarico.IdIncarico = WF.IdIncarico

LEFT JOIn T_OperazioneAzimut ON T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico
AND T_OperazioneAzimut.FlagAttivo = 1

JOIN T_R_Incarico_MovimentoContoBancario ON T_Incarico.IdIncarico = T_R_Incarico_MovimentoContoBancario.IdIncarico

JOIN dbo.T_MovimentoContoBancario
	ON T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario

JOIN T_NotaIncarichi
	ON dbo.T_MovimentoContoBancario.IdNotaIncarichi = dbo.T_NotaIncarichi.IdNotaIncarichi
	
LEFT JOIN scratch.T_R_ImportRendicontazione_Movimento
	ON scratch.T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
LEFT JOIN scratch.L_Import_Rendicontazione_FlussoCBI
	ON scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
OUTER APPLY (SELECT TOP 1
	scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Id_Import_RendicontazioneBP_DatiAggiuntivi
   ,ISNULL(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ClienteOrdinante_63, scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoCliente_62) RiferimentoOrdinante
FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi
WHERE scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA = scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62
AND ISNULL(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ClienteOrdinante_63,RiferimentoCliente_62) IS NOT NULL
ORDER BY scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Id_Import_RendicontazioneBP_DatiAggiuntivi ASC) Ordinante
OUTER APPLY (SELECT TOP 1
	scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Id_Import_RendicontazioneBP_DatiAggiuntivi
   ,scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IbanOrdinante_63 IbanOrdinante
FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi
WHERE scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA = scratch.L_Import_Rendicontazione_FlussoCBi.Chiave_62
AND scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IbanOrdinante_63 IS NOT NULL
ORDER BY scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Id_Import_RendicontazioneBP_DatiAggiuntivi ASC) IBAN


OUTER APPLY (SELECT TOP 1
	scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Id_Import_RendicontazioneBP_DatiAggiuntivi
   ,scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DescrizioneMovimento_63 Causale
FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi
WHERE scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA = scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62
AND scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DescrizioneMovimento_63 IS NOT NULL
ORDER BY scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Id_Import_RendicontazioneBP_DatiAggiuntivi ASC) DescrizioneMovimento


OUTER APPLY ( SELECT TOP 1 IdPagamento
              FROM dbo.T_PagamentoInvestimento
			  WHERE dbo.T_PagamentoInvestimento.IdIncarico = T_Incarico.IdIncarico
			  AND dbo.T_PagamentoInvestimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
			  AND FlagAttivo = 1
) T_Pagamento

WHERE ( dbo.T_Incarico.CodCliente = 23
AND dbo.T_Incarico.CodTipoIncarico IN (83	--Sottoscrizioni/Versamenti FONDI Investimento
, 553	--Versamenti Aggiuntivi Lux - Zenith
, 540	--Sottoscrizioni Lux - Zenith
--, 580	--Sottoscrizioni Fondi - Zenith
--, 581	--Versamenti Aggiuntivi Fondi - Zenith
, 693	--Rata PAC
)	
AND dbo.T_Incarico.CodArea = 8
AND dbo.T_Incarico.FlagArchiviato = 0

AND (T_Incarico.CodAttributoIncarico IS NULL OR T_Incarico.CodAttributoIncarico !=17473) --Elaborato TA
AND dbo.T_MovimentoContoBancario.DataConferma >= CAST(GETDATE() AS DATE)
--AND DataRiconciliazione >= CONVERT(DATE,DATEADD(DAY,-1,GETDATE()))

AND NotaAggiuntiva NOT LIKE '%{Stampato}%'
AND T_Incarico.IdIncarico != 16498764

--AND DataConferma >= '2020-12-11 09:00' AND DataConferma < '2020-12-11 10:00'

--AND T_OperazioneAzimut.Importo is NULL


--AND dbo.T_Incarico.IdIncarico in ( 
-- 16472877

--)

--AND T_MovimentoContoBancario.IdMovimentoContoBancario IN (
--1273164
--)
) 

GROUP BY
	dbo.T_Incarico.IdIncarico
	,T_Incarico.CodTipoIncarico
   ,dbo.T_Documento.Documento_id
   ,D_Documento.Codice 
   ,D_Documento.Descrizione 
   ,dbo.T_Documento.Nome_file
    --CAST(CAST(T_PagamentoInvestimento.Importo AS INT) AS VARCHAR(50)) + '_' 
   --CAST(dbo.T_Incarico.IdIncarico AS VARCHAR(20)) 
			--+ '_' + CAST(Documento_id AS VARCHAR(30)) 
			--+ '_' + CAST((ROW_NUMBER() OVER (PARTITION BY T_Incarico.IdIncarico, T_MovimentoContoBancario.IdMovimentoContoBancario ORDER BY T_Incarico.IdIncarico, T_MovimentoContoBancario.IdMovimentoContoBancario, T_Documento.Documento_id)) AS VARCHAR(3))
		 
   ,RIGHT(Nome_file, 4) 
   ,T_MovimentoContoBancario.IdMovimentoContoBancario
   ,CAST(FORMAT(T_MovimentoContoBancario.Importo,'N','de-de') AS VARCHAR(100)) 
   ,ISNULL(FORMAT(T_MovimentoContoBancario.DataValuta,'dd/MM/yyyy'),'N/D') 
   ,ISNULL(FORMAT(T_MovimentoContoBancario.DataOperazione,'dd/MM/yyyy'),'N/D') 
   ,ISNULL(ISNULL(T_MovimentoContoBancario.IbanOrdinante, Iban.IbanOrdinante),'N/D') 
   ,ISNULL(SUBSTRING(isnull(T_MovimentoContoBancario.IbanOrdinante, Iban.IbanOrdinante),6,5),'N/D') 
   ,ISNULL(SUBSTRING(isnull(T_MovimentoContoBancario.IbanOrdinante,Iban.IbanOrdinante),11,5),'N/D') 
   ,ISNULL(SUBSTRING(ISNULL(T_MovimentoContoBancario.IbanOrdinante,iban.IbanOrdinante),16,4) + ' ' 
		  + SUBSTRING(ISNULL(T_MovimentoContoBancario.IbanOrdinante,iban.IbanOrdinante),20,4) + ' '
		  + SUBSTRING(ISNULL(T_MovimentoContoBancario.IbanOrdinante,iban.IbanOrdinante),24,4)
   ,'0') 
   ,ISNULL(Ordinante.RiferimentoOrdinante,'N/D') 
   ,ISNULL(DescrizioneMovimento.Causale,'N/D') 
   ,CASE WHEN NotaAggiuntiva IS NULL OR NotaAggiuntiva = '' OR NotaAggiuntiva = ' ' THEN 'Nessuna'
    ELSE NotaAggiuntiva END 

	,CASE WHEN NotaAggiuntiva LIKE '%maxfunds%' THEN 'MAXFUNDS'
	 --WHEN NotaAggiuntiva LIKE '%*%-%*%' THEN 'PAC'
	 ELSE 'RICONCILIATI'
	 END
	 ,CASE WHEN T_Pagamento.IdPagamento IS NULL THEN 1 ELSE 0 END

GO