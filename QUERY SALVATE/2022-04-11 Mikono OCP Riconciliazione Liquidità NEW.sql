USE CLC
GO

ALTER VIEW rs.v_Mikono_CheckSaldi_Liquidita_BackOffice_csv_TEST as

SELECT CONVERT(VARCHAR(8), DataImportNormalizzata, 112) DataImportNormalizzata,	TipologiaMismatchFile,
		BancaMismatch,
		Banca,
		depositarieBanca,
		
		ValoreEuroAntanaDepositarie [ValoreAntanaDepositarie],
		CheckValoreEuroAntanaDepositarie [CheckValoreAntanaDepositarie],
		 NULL AS NoteOperatore,
		
		AccountTruncated,
		Divisa,
		depositarieDivisa,
		Valore_euro [Valore],
		depositarieValore_euro [DepositarieValore],
		Ndg,
			
		Conto_corrente,
		depositarieConto_corrente,
			Dossier_titoli,
		depositarieDossier_titoli,
		IsLiquidita,
		Nrow,
		DataFlusso,
		depositarieDataFlusso,
		FileImport,
		depositarieFileImport,j.RowNum IsPrimoGiornoMese
FROM rs.v_Mikono_SaldiLiquidita_AntanaDepositarie_TEST 
LEFT JOIN (SELECT DISTINCT CAST(S_Calendario.InizioMezzaGiornata as DATE) InizioMezzaGiornata
, RowNum = ROW_NUMBER() OVER (PARTITION BY LEFT(CONVERT(varchar, S_Calendario.InizioMezzaGiornata,112),6) ORDER BY S_Calendario.InizioMezzaGiornata)
 FROM S_Calendario 
where S_Calendario.CodCliente = 302 
--AND CAST(S_Calendario.InizioMezzaGiornata as DATE) = '20190603' 
AND S_Calendario.FlagLavorativo = 1
--AND S_Calendario.InizioMezzaGiornata >= '20190501'
) j on CAST(j.InizioMezzaGiornata as DATE) = rs.v_Mikono_SaldiLiquidita_AntanaDepositarie_TEST.DataImportNormalizzata AND j.RowNum =1

WHERE IsLiquidita = 1 

AND BancaMismatch <> 'STATE' 
AND (depositarieConto_corrente <> '010-0057435' OR depositarieConto_corrente is NULL)
AND DataImportNormalizzata = (SELECT TOP 1 DateImport FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Antana 
WHERE NomePartner = 'OCP' 
AND FlagAttivo = 1
ORDER BY DataImport_reale DESC, DateImport DESC)
-->= CAST(GETDATE() AS DATE)
--AND DataImportNormalizzata = '2019-04-01 00:00:00.000'

GO