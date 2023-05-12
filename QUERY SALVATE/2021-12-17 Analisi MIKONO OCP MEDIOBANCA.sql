USE CLC

WITH antana
AS
(SELECT
		LEFT(Account, 6) AccountTruncated
	   ,IIF(Titolo = 'LIQUID', Titolo, NULL) Titolo
	   ,Isin
	   ,Descr_titolo
	   ,SUM(Quantita) Quantita
	   ,Prezzo
	   ,Divisa
	   ,SUM(Valore_euro) Valore_euro
	   ,Ndg
	   ,Dossier_titoli
	   ,Banca
	   ,Conto_corrente
	   ,Deposito
	   ,a.FileImport
	   ,JobDescription
	   ,a.DateImport
	   ,Cambio
	   ,Cognome
	   ,Nome
	   ,RagioneSociale
	   ,DataFlusso
	   ,note
	FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Antana a
	WHERE a.NomePartner = 'ocp'
	AND a.Banca = 'besp'
	AND a.DateImport >= DATEADD(MONTH, -1, GETDATE())
	AND a.FlagAttivo = 1
	AND a.DateImport = '20211201'
	--AND a.Isin = 'IE00B0M62Q58'
	--AND a.FileImport = 'posizioni20211214154340.csv'
	/*
	si rileva anomalia flusso antana per la DataFlusso 30/11/2021

	SELECT IdImport, FileImport,Dossier_titoli, Isin, Quantita, Prezzo, Valore_euro, FlagAttivo, Note
	FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Antana
	WHERE NomePartner = 'ocp'
	AND banca = 'besp'
	AND DateImport = '20211201'
	and titolo != 'LIQUID'
	ORDER BY Dossier_titoli, Isin,FileImport

	VIENE FLAGGATO = 1 OGNI POSIZIONE CORRISPONDENTE AL PENULTIMO FILE, IN SFAVORE DELL'ULTIMO, SEMPRE FLAGATTIVO = 0
	L'operativo ha messo le note riferendosi all'ultimo file, che al momento non è visibile sul report

	*/

	GROUP BY LEFT(Account, 6)
			,Isin
			,Descr_titolo
			,IIF(Titolo = 'LIQUID', Titolo, NULL)
			,Prezzo
			,Divisa
			,Ndg
			,Dossier_titoli
			,Banca
			,Conto_corrente
			,Deposito
			,a.FileImport
			,JobDescription
			,a.DateImport
			,Cambio
			,Cognome
			,Nome
			,RagioneSociale
			,DataFlusso
			,note),
depositarie
AS
(SELECT
		IIF(Titolo = 'LIQUID', Titolo, NULL) Titolo
	   ,Isin
	   ,NULL Descr_titolo
	   ,SUM(Quantita) Quantita
	   ,Prezzo
	   ,Divisa
	   ,SUM(Valore_euro) Valore_euro
	   ,Ndg
	   ,Dossier_titoli
	   ,Banca
	   ,Conto_corrente
	   ,Deposito
	   ,d.FileImport
	   ,JobDescription
	   ,DateImport
	   ,Cambio
	   ,DataFlusso
	   ,note
	FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Depositarie d
	WHERE d.NomePartner = 'ocp'
	AND d.Banca = 'besp'
	AND d.DateImport >= DATEADD(MONTH, -1, GETDATE())
	AND d.FlagAttivo = 1
	AND d.Isin = 'IE00B0M62Q58'
	AND d.FileImport = 'saldititolidaily2021-12-01.txt'

	GROUP BY Isin
			,IIF(Titolo = 'LIQUID', Titolo, NULL)
			,Prezzo
			,Divisa
			,Ndg
			,Dossier_titoli
			,Banca
			,Conto_corrente
			,Deposito
			,d.FileImport
			,JobDescription
			,DateImport
			,Cambio
			,DataFlusso
			,note),
estr
AS
(SELECT
		CASE
			WHEN antana.Isin IS NULL AND
				AccountTruncated IS NULL THEN CAST('NO ANTANA' AS VARCHAR(10))
			WHEN depositarie.Isin IS NULL THEN CAST('NO DEPOSIT' AS VARCHAR(10))
			ELSE CAST('OK' AS VARCHAR(10))
		END AS TipologiaMismatchFile
	   ,ISNULL(antana.Quantita, 0) - ISNULL(depositarie.Quantita, 0) QuantitaAntanaDepositarie
	   ,ISNULL(antana.Prezzo, 0) - ISNULL(depositarie.Prezzo, 0) PrezzoAntanaDepositarie
	   ,ISNULL(antana.Valore_euro, 0) - ISNULL(depositarie.Valore_euro, 0) ValoreEuroAntanaDepositarie
	   ,CASE
			WHEN antana.Divisa != depositarie.Divisa THEN 'KO'
			ELSE 'OK'
		END AS CheckDivisaDiversa
	   ,AccountTruncated
	   ,antana.Titolo
	   ,antana.Isin
	   ,antana.Descr_titolo
	   ,antana.Quantita
	   ,antana.Prezzo
	   ,antana.Divisa
	   ,antana.Valore_euro
	   ,antana.Ndg
	   ,antana.Dossier_titoli
	   ,antana.Banca
	   ,antana.Conto_corrente
	   ,antana.Deposito
	   ,antana.FileImport
	   ,antana.JobDescription
	   ,antana.DateImport
	   ,antana.Cambio
	   ,antana.Cognome
	   ,antana.Nome
	   ,antana.RagioneSociale
	   ,antana.DataFlusso
	   ,antana.note
	   ,depositarie.Titolo depositarieTitolo
	   ,depositarie.Isin depositarieIsin
	   ,depositarie.Descr_titolo depositarieDescr_titolo
	   ,depositarie.Quantita depositarieQuantita
	   ,depositarie.Prezzo depositariePrezzo
	   ,depositarie.Divisa depositarieDivisa
	   ,depositarie.Valore_euro depositarieValore_euro
	   ,depositarie.Ndg depositarieNdg
	   ,depositarie.Dossier_titoli depositarieDossier_titoli
	   ,depositarie.Banca depositarieBanca
	   ,depositarie.Conto_corrente depositarieConto_corrente
	   ,depositarie.Deposito depositarieDeposito
	   ,depositarie.FileImport depositarieFileImport
	   ,depositarie.JobDescription depositarieJobDescription
	   ,depositarie.DateImport depositarieDateImport
	   ,depositarie.Cambio depositarieCambio
	   ,depositarie.DataFlusso depositarieDataflusso
	   ,depositarie.note depositarieNote

	FROM antana
	--FULL OUTER JOIN 
	JOIN depositarie
		ON antana.DateImport = depositarie.DateImport
		AND antana.Banca = depositarie.Banca
		AND antana.Isin = depositarie.Isin
		AND antana.Deposito = depositarie.Deposito
		AND antana.Dossier_titoli = depositarie.Dossier_titoli),
vistabesp
AS
(SELECT
		TipologiaMismatchFile
	   ,CASE
			WHEN TipologiaMismatchFile = 'NO DEPOSIT' THEN estr.Banca
			WHEN TipologiaMismatchFile = 'NO ANTANA' THEN estr.depositarieBanca
			ELSE 'OK'
		END AS BancaMismatch
	   ,IIF(ISNULL(Titolo, depositarieTitolo) = 'LIQUID', 1, 0) IsLiquidita
	   ,QuantitaAntanaDepositarie
	   ,CASE
			WHEN QuantitaAntanaDepositarie = 0 THEN 'OK'
			WHEN QuantitaAntanaDepositarie BETWEEN -1 AND 1 THEN 'SFRIDO'
			ELSE 'KO'
		END AS CheckQuantitaAntanaDepositarie
	   ,PrezzoAntanaDepositarie
	   ,CASE
			WHEN PrezzoAntanaDepositarie = 0 THEN 'OK'
			ELSE 'KO'
		END AS CheckPrezzoAntanaDepositarie
	   ,ValoreEuroAntanaDepositarie
	   ,CASE
			WHEN ValoreEuroAntanaDepositarie = 0 THEN 'OK'
			ELSE 'KO'
		END AS CheckValoreEuroAntanaDepositarie
	   ,ISNULL(DateImport, depositarieDateImport) DataImportNormalizzata
	   ,CheckDivisaDiversa
	   ,AccountTruncated
	   ,
		--Linea,
		Titolo
	   ,Isin
	   ,Descr_titolo
	   ,Quantita
	   ,Prezzo
	   ,Divisa
	   ,Valore_euro
	   ,Ndg
	   ,Dossier_titoli
	   ,Banca
	   ,Conto_corrente
	   ,Deposito
	   ,FileImport
	   ,JobDescription
	   ,DateImport
	   ,DataFlusso
	   ,Cambio
	   ,Cognome
	   ,Nome
	   ,RagioneSociale
	   ,ISNULL(Note, depositarieNote) Note
	   ,estr.depositarieTitolo
	   ,estr.depositarieIsin
	   ,estr.depositarieDescr_titolo
	   ,estr.depositarieQuantita
	   ,estr.depositariePrezzo
	   ,estr.depositarieDivisa
	   ,estr.depositarieValore_euro
	   ,estr.depositarieNdg
	   ,estr.depositarieDossier_titoli
	   ,estr.depositarieBanca
	   ,estr.depositarieConto_corrente
	   ,estr.depositarieDeposito
	   ,estr.depositarieFileImport
	   ,estr.depositarieJobDescription
	   ,estr.depositarieDateImport
	   ,estr.depositarieCambio
	   ,estr.depositarieDataflusso
	FROM estr),
reportMediobanca
AS
(SELECT
		Banca
	   ,depositarieBanca
	   ,BancaMismatch
	   ,TipologiaMismatchFile
	   ,JobDescription
	   ,Isin
	   ,Descr_titolo
	   ,SUM(Quantita) QuantitaTot
	   ,Divisa
	   ,depositarieIsin
	   ,Descr_titolo depositarieDescr_titolo
	   ,SUM(depositarieQuantita) depositarieQuantitaTot
	   ,depositarieDivisa
	   ,DataImportNormalizzata
	   ,note
	   ,DataFlusso
	   ,depositarieDataflusso
	FROM vistabesp
	WHERE vistabesp.IsLiquidita = 0
	AND vistabesp.BancaMismatch = 'OK'
	AND vistabesp.Banca = 'besp'
	GROUP BY Banca
			,depositarieBanca
			,BancaMismatch
			,TipologiaMismatchFile
			,JobDescription
			,Isin
			,Descr_titolo
			,Divisa
			,depositarieIsin
			,Descr_titolo
			,depositarieDivisa
			,DataImportNormalizzata
			,note
			,DataFlusso
			,depositarieDataflusso

	UNION ALL

	SELECT
		Banca
	   ,depositarieBanca
	   ,BancaMismatch
	   ,TipologiaMismatchFile
	   ,JobDescription
	   ,ISNULL(Isin, '') Isin
	   ,Descr_titolo
	   ,SUM(Quantita) QuantitaTot
	   ,ISNULL(Divisa, '') Divisa
	   ,ISNULL(depositarieIsin, '') depositarieIsin
	   ,Descr_titolo depositarieDescr_titolo
	   ,SUM(depositarieQuantita) depositarieQuantitaTot
	   ,ISNULL(depositarieDivisa, '') depositarieDivisa
	   ,DataImportNormalizzata
	   ,note
	   ,DataFlusso
	   ,depositarieDataflusso
	FROM vistabesp
	WHERE IsLiquidita = 0
	AND BancaMismatch = 'besp'

	GROUP BY Banca
			,depositarieBanca
			,BancaMismatch
			,TipologiaMismatchFile
			,Isin
			,Descr_titolo
			,JobDescription
			,Divisa
			,depositarieIsin
			,Descr_titolo
			,depositarieDivisa
			,DataImportNormalizzata
			,note
			,DataFlusso
			,depositarieDataflusso)
SELECT
	RowNum = ROW_NUMBER() OVER (ORDER BY NEWID())
   ,Banca
   ,depositarieBanca
   ,BancaMismatch
   ,TipologiaMismatchFile
   ,JobDescription
   ,Isin
   ,Descr_titolo
   ,QuantitaTot
   ,Divisa
   ,depositarieIsin
   ,depositarieDescr_titolo
   ,depositarieQuantitaTot
   ,depositarieDivisa
   ,DataImportNormalizzata
   ,note
   ,DataFlusso
   ,depositarieDataflusso
FROM reportMediobanca
WHERE DataImportNormalizzata = '20211201'
