USE clc
GO

--SELECT DISTINCT Banca
--FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Antana
--WHERE NomePartner = 'ocp'
--AND Banca = 'akro'
WITH antana AS (
SELECT COUNT(IdImport) Nrow,
	LEFT(Account,7) AccountTruncated,
		Titolo,
		Isin,
		Descr_titolo,
		SUM(Quantita) Quantita,
		Prezzo,
		Divisa,
		SUM(Valore_euro) Valore_euro,
		Ndg,
		Dossier_titoli,
		Banca,
		Conto_corrente,
		Deposito,
		FileImport,
		JobDescription,
		DateImport
		, Nome, Cognome, RagioneSociale
		,dataflusso ,Note
		,FlagAttivo
FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Antana
WHERE NomePartner = 'ocp'
AND Banca = 'akro'
AND Titolo = 'liquid'
AND DateImport = '20211201'
AND Ndg = '00000034'
--AND DataFlusso = '2021-11-30 00:00:00.000'
AND FlagAttivo = 1
--AND FileImport = 'posizioni20211214154340.csv'
--AND note IS NOT NULL
GROUP BY
LEFT(Account,7),
		Titolo,
		Isin,
		Descr_titolo,
		Prezzo,
		Divisa,
		Ndg,
		Dossier_titoli,
		Banca,
		Conto_corrente,
		Deposito,
		FileImport,
		JobDescription,
		DateImport , Nome, Cognome, RagioneSociale,DataFlusso, Note,FlagAttivo
--ORDER BY DataFlusso, Ndg

/*
Anomalia su dataflusso 30/11
di tutti i movimenti in nome di GIORGIO DE NOVA, proprio quello in cui ha inserito le note
,proveniente dal file posizioni20211214154340.csv risulta flagattivo = 0
mentre quello che a db risulta attivo, proviene dal file posizioni20211213163221.csv

rilevato schema su data flusso 30/11. è l'unica data flusso in cui è attiva la posizione relativa all'ultimo file e non l'ultima

*/

),depositarie AS (
SELECT IdImport,
		Famiglia,
		Account,
		Linea,
		Titolo,
		Isin,
		Descr_titolo,
		Quantita,
		Prezzo,
		Divisa,
		Valore_euro,
		Ndg,
		Dossier_titoli,
		Banca,
		Conto_corrente,
		Deposito,
		FileImport,
		JobDescription,
		DateImport,
		Cambio,
		Note,
		DataFlusso,
		DataImport_reale,
		NomePartner,
		CodiceAmbiente,
		CodiceTitolo
FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Depositarie
WHERE NomePartner = 'ocp'
AND Banca = 'akro'
AND Conto_corrente = '00014562'
AND Titolo = 'LIQUID'
AND DateImport = '20211201'
)
--nessuna anomalia su file depositarie

,estr AS (
SELECT CASE when antana.Titolo IS NULL THEN CAST('NO ANTANA' AS VARCHAR(10))
WHEN depositarie.IdImport IS NULL THEN CAST('NO DEPOSIT' AS VARCHAR(10)) ELSE CAST('OK' AS VARCHAR(10)) END AS TipologiaMismatchFile,



ISNULL(antana.Valore_euro,0) - ISNULL(depositarie.Valore_euro,0) ValoreEuroAntanaDepositarie,
CASE when antana.Divisa != depositarie.Divisa THEN 'KO' ELSE 'OK' END AS CheckDivisaDiversa,

		antana.Nrow,
		ANTANA.AccountTruncated,
		antana.Titolo,
		antana.Isin,
		antana.Descr_titolo,
		antana.Quantita,
		antana.Prezzo,
		antana.Divisa,
		antana.Valore_euro,
		antana.Ndg,
		antana.Dossier_titoli,
		antana.Banca,
		antana.Conto_corrente,
		antana.Deposito,
		antana.FileImport,
		antana.JobDescription,
		antana.DateImport, ANTANA.Nome, ANTANA.Cognome, ANTANA.RagioneSociale,ANTANA.DataFlusso,ANTANA.Note,
		depositarie.IdImport depositarieIdImport,
		depositarie.Famiglia depositarieFamiglia ,
		depositarie.Account depositarieAccount,
		depositarie.Linea depositarieLinea,
		depositarie.Titolo depositarieTitolo,
		depositarie.Isin depositarieIsin,
		depositarie.Descr_titolo depositarieDescr_titolo,
		depositarie.Quantita depositarieQuantita,
		depositarie.Prezzo depositariePrezzo,
		depositarie.Divisa depositarieDivisa,
		depositarie.Valore_euro depositarieValore_euro,
		depositarie.Ndg depositarieNdg,
		depositarie.Dossier_titoli depositarieDossier_titoli,
		depositarie.Banca depositarieBanca,
		depositarie.Conto_corrente depositarieConto_corrente,
		depositarie.Deposito depositarieDeposito,
		depositarie.FileImport depositarieFileImport,
		depositarie.JobDescription depositarieJobDescription,
		depositarie.DateImport depositarieDateImport,
		depositarie.DataFlusso depositarieDataFlusso,depositarie.Note depositarieNote
FROM antana
FULL OUTER JOIN  depositarie ON antana.Titolo = depositarie.Titolo
AND antana.Conto_corrente = depositarie.Conto_corrente
AND antana.DateImport = depositarie.DateImport

) ,vistaakro AS (
SELECT 	TipologiaMismatchFile,
CASE WHEN TipologiaMismatchFile = 'NO DEPOSIT' THEN estr.Banca 
	WHEN TipologiaMismatchFile = 'NO ANTANA' THEN estr.depositarieBanca
	ELSE 'OK' END AS BancaMismatch,
	iIf(ISNULL(Titolo,depositarieTitolo)='LIQUID',1,0) IsLiquidita,




		ValoreEuroAntanaDepositarie,
		CASE WHEN ValoreEuroAntanaDepositarie = 0 then 'OK' 
			ELSE 'KO' END AS CheckValoreEuroAntanaDepositarie,
		ISNULL(DateImport,depositarieDateImport)	DataImportNormalizzata,
		CheckDivisaDiversa,

		
		
		Nrow,
				AccountTruncated,
		Titolo,

		Isin,
		Descr_titolo,
		Quantita,
		Prezzo,
		Divisa,
		Valore_euro,
		Ndg,
		Dossier_titoli,
		Banca,
		Conto_corrente,
		Deposito,
		FileImport,
		JobDescription,
		DateImport, Nome, Cognome, RagioneSociale, DataFlusso,
		depositarieIdImport,
		depositarieFamiglia,
		depositarieAccount,
		depositarieLinea,
		depositarieTitolo,
		depositarieIsin,
		depositarieDescr_titolo,
		depositarieQuantita,
		depositariePrezzo,
		depositarieDivisa,
		depositarieValore_euro,
		depositarieNdg,
		depositarieDossier_titoli,
		depositarieBanca,
		depositarieConto_corrente,
		depositarieDeposito,
		depositarieFileImport,
		depositarieJobDescription,
		depositarieDateImport,
		depositarieDataFlusso,ISNULL(Note,depositarieNote) Note FROM estr

		) ,report_akro AS (
		SELECT * FROM vistaakro
		WHERE IsLiquidita = 1
		AND BancaMismatch = 'OK'
		AND Banca = 'akro'
		UNION ALL
		SELECT * FROM vistaakro
		WHERE IsLiquidita = 1
		AND BancaMismatch = 'akro'
		) SELECT * FROM report_akro
		WHERE DataImportNormalizzata = '20211201'


		SELECT * FROM rs.v_Mikono_SaldiLiquid_AntanaDepositarie_Clienti_AKRO
		WHERE DataImportNormalizzata = '20211201'
		AND Cognome = 'DE NOVA' AND Nome = 'GIORGIO'
