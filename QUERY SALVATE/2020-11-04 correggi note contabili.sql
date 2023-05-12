USE CLC
GO

IF OBJECT_ID('tempdb.dbo.#tmpNota') IS NOT NULL
	DROP TABLE #tmpNota


;
WITH a AS (
SELECT scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP
,	LTRIM(RTRIM(CAST(scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoCliente_62 AS VARCHAR(100)))) AS a1,
	LTRIM(RTRIM(CAST(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IdentificativoRapporto_63 AS VARCHAR(100)))) as a2,

	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.CodificaFiscaleOrdinante_63 AS VARCHAR(100)))) AS a3,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ClienteOrdinante_63 AS VARCHAR(100))))  AS a4,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Localita_63 AS VARCHAR(100)))) AS a5,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IndirizzoOrdinante_63 AS VARCHAR(100))))	AS a6,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IbanOrdinante_63 AS VARCHAR(100)))) AS a7,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ImportoOriginalePagamento_63 AS VARCHAR(100))))  AS a8,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.CodiceDivisaImportoOriginario_63 AS VARCHAR(100)))) AS a9,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ImportoRegolato_63 AS VARCHAR(100))))  AS a10,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.CodiceDivisaRegolamento_63 AS VARCHAR(100)))) as a11,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ImportoNegoziato_63 AS VARCHAR(100))))  AS a12,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.CodiceDivisaImportoNegoziato_63 AS VARCHAR(100)))) AS a13,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.CambioApplicato_63 AS VARCHAR(100)))) AS a14,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ImportoCommisioni_63 AS VARCHAR(100))))  AS a15,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.ImportoSpese_63 AS VARCHAR(100)))) AS a16,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.CodicePaese_63 AS VARCHAR(100))))  AS a17,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.OrdinantePagamento_63 AS VARCHAR(100)))) AS a18,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Beneficiario_63 AS VARCHAR(100)))) AS a19,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.MotivazionePagamento_63 AS VARCHAR(100)))) AS a20,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DescrizioneMovimento_63 AS VARCHAR(100))))  AS a21,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IDUnivocoMessaggio_63 AS VARCHAR(100)))) 	AS a22,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IDEndToEnd_63 AS VARCHAR(100)))) 	AS a23,
	ltrim(rtrim(cast(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.InformazioniRiconciliazione_63 AS VARCHAR(100))))  as a24
	--	[DescrizioneOperazione]

--------riconciliazione
	,RiferimentoCliente_62 ClienteOrdinante_63
--,* 
,Segno_61 SegnoSaldoIniziale
,SaldoInizialeQuadratura_61 SaldoIniziale
,SegnoSaldoContabile_64 SegnoSaldoContabile
,SaldoContabile_64 SaldoContabile
,SegnoSaldoLiquido_64 SegnoSaldoLiquido
,SaldoLiquido_64 SaldoLiquido
,CASE SegnoMovimento_62 WHEN 'C' THEN 1 WHEN 'D' THEN -1 else 1 END SegnoMovimento
,CASE SegnoMovimento_62 WHEN 'C' THEN ImportoMovimento_62 ELSE CAST('-'+CAST(ImportoMovimento_62 AS VARCHAR(100))AS DECIMAL(18,4)) END ImportoMovimento
,T_MovimentoContoBancario.IdMovimentoContoBancario
,IdNotaIncarichi
FROM scratch.L_Import_Rendicontazione_FlussoCBI
JOIN scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi ON Chiave_62 = Chiave_62_DA
JOIN scratch.T_R_ImportRendicontazione_Movimento tr ON tr.IdImport_Rendicontazione = scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP
JOIN T_MovimentoContoBancario ON tr.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
AND tr.IdContoBancarioPerAnno = T_MovimentoContoBancario.IdContoBancarioPerAnno
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND IdIncarico = 13943236
WHERE T_MovimentoContoBancario.DataImport >= CONVERT(DATE,GETDATE()) 
--AND tr.IdMovimentoContoBancario IN ( 1236072, 1236102) --IdImport_RendicontazioneBP = 4404625

) ,Contabile AS (
SELECT 	unpvt.IdImport_RendicontazioneBP,
		DescrizioneOperazione,
		unpvt.ClienteOrdinante_63,
		unpvt.SegnoSaldoIniziale,
		unpvt.SaldoIniziale,
		unpvt.SegnoSaldoContabile,
		unpvt.SaldoContabile,
		unpvt.SegnoSaldoLiquido,
		unpvt.SaldoLiquido,
		unpvt.SegnoMovimento,
		unpvt.ImportoMovimento,
		unpvt.IdMovimentoCOntoBancario
		
		FROM a
UNPIVOT ( 
	DescrizioneOperazione FOR details IN (a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24) 

) AS unpvt

) ,nuovacontabile AS ( SELECT DISTINCT IdImport_RendicontazioneBP, ISNULL(Contabile.ClienteOrdinante_63,'')+ REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST((SELECT DescrizioneOperazione
			FROM Contabile X
			WHERE x.IdImport_RendicontazioneBP = Contabile.IdImport_RendicontazioneBP
			FOR XML PATH(''),TYPE) as varchar(max)),'<DescrizioneOperazione>',' '),'</DescrizioneOperazione>',' '),'<DescrizioneOperazione/>' ,' '),'</ClienteOrdinante_63>',' '),'<ClienteOrdinante_63>',' ')
			 AS DescrizioneOperazione 

FROM Contabile

) SELECT T_MovimentoContoBancario.IdMovimentoContoBancario, T_NotaIncarichi.IdNotaIncarichi, T_NotaIncarichi.Testo, DescrizioneOperazione
INTO #tmpNota
FROM nuovacontabile
JOIN scratch.T_R_ImportRendicontazione_Movimento tr ON IdImport_RendicontazioneBP = tr.IdImport_Rendicontazione
JOIN T_MovimentoContoBancario ON tr.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
AND tr.IdContoBancarioPerAnno = T_MovimentoContoBancario.IdContoBancarioPerAnno
JOIN T_NotaIncarichi ON T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi

UPDATE T_NotaIncarichi
SET Testo = DescrizioneOperazione
FROM T_NotaIncarichi
JOIN #tmpNota ON T_NotaIncarichi.IdNotaIncarichi = #tmpNota.IdNotaIncarichi

/*

SELECT DISTINCT IdImport_RendicontazioneBP, ISNULL(Contabile.ClienteOrdinante_63,'')+ REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST((SELECT DescrizioneOperazione
			FROM Contabile 
			FOR XML PATH(''),TYPE) as varchar(max)),'<DescrizioneOperazione>',' '),'</DescrizioneOperazione>',' '),'<DescrizioneOperazione/>' ,' '),'</ClienteOrdinante_63>',' '),'<ClienteOrdinante_63>',' ')
			 AS DescrizioneOperazione
			 ,T_MovimentoContoBancario.IdMovimentoContoBancario
			 ,T_MovimentoContoBancario.IdNotaIncarichi
FROM Contabile
JOIN scratch.T_R_ImportRendicontazione_Movimento tr ON Contabile.IdImport_RendicontzioneBP = tr.IdImport_Rendicontazione
JOIN T_MovimentoContoBancario ON tr.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
AND tr.IdContoBancarioPerAnno = T_MovimentoContoBancario.IdContoBancarioPerAnno

*/