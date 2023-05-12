/*
Author: Andrea Padricelli
Date: 20170711

utilizzata per la riconciliazione dei pagamenti effettuati dai clienti verso il banco popolare, estratto conto

*/

--SELECT * FROM rs.v_CESAM_AZ_Rendicontazione_BancoPopolare_Raggruppa



ALTER VIEW rs.v_CESAM_AZ_Rendicontazione_BNP AS 
WITH a AS (
SELECT 
scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP
,DataContabile_61 
,ABI_61 ABI
,CAB_61 CAB	
,SUBSTRING(NumeroConto_61, PATINDEX('%[^0]%', NumeroConto_61+'.'), LEN(NumeroConto_61)) Conto
--,101 AS CodBanca
,ISNULL(CodBancaVD,111) CodBanca
,ISNULL(T_ContoBancario.IdContoBancario,1) IdContoBancario
,T_ContoBancarioPerAnno.IdContoBancarioPerAnno
,ISNULL(ISNULL(abicabconto.Descrizione,IIF(Descrizione_61 = '',NULL,Descrizione_61)),'CONTODACENSIRE') [DescrizioneConto] --DESCRIZIONE CONTO DA TRANSCODIFICARE
,CAST(CASE Segno_61 WHEN 'C' THEN '+' WHEN 'D' THEN '-' ELSE NULL END +CAST(SaldoInizialeQuadratura_61 AS VARCHAR(50))AS DECIMAL(18,2)) [SaldoInizialeSegno]
,CAST(CASE SegnoSaldoContabile_64 WHEN 'C' THEN '+' WHEN 'D' THEN '-' ELSE NULL END + CAST(SaldoContabile_64 AS VARCHAR(50))AS DECIMAL(18,2)) [SaldoContabileSegno]
,CAST(CASE SegnoSaldoLiquido_64 WHEN 'C' THEN '+' WHEN 'D' THEN '-' ELSE NULL END + CAST(SaldoLiquido_64 AS VARCHAR(50))AS DECIMAL(18,2)) [SaldoLiquidoSegno]
,CodiceDivisa_61 Divisa
,D_Valuta.Codice CodDivisa
, scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP [ProgressivoOperazione]
,DataRegistrazione_Contabile_62 [DataOperazione]
,ISNULL(DataValuta_62,GETDATE()) [DataValuta]
,CASE WHEN SegnoMovimento_62 = 'C' THEN ImportoMovimento_62 ELSE NULL END AS Entrate
,CASE WHEN SegnoMovimento_62 = 'D' THEN ImportoMovimento_62 ELSE NULL END AS Uscite
--,IdOperazioneContoBancario
,UPPER(CASE CausaleCBI_62 WHEN '' THEN Causale_61 ELSE CausaleCBI_62
	+ISNULL(L_Import_Rendicontazione_FlussoCBI.CausaleInterna_62,'') END) Causale --DA TRANSCODIFICARE
,UPPER(CASE CausaleCBI_62 WHEN '' THEN Causale_61 ELSE CausaleCBI_62
	+ISNULL(L_Import_Rendicontazione_FlussoCBI.CausaleInterna_62,'') END ) RiferimentoCliente_62

,	LTRIM(RTRIM(CAST(scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoCliente_62 AS VARCHAR(100)))) AS a1,
	CASE WHEN Id_Import_RendicontazioneBP_DatiAggiuntivi IS NULL
	THEN LTRIM(RTRIM(CAST(scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoCliente_62 AS VARCHAR(100))))
	ELSE LTRIM(RTRIM(CAST(scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.IdentificativoRapporto_63 AS VARCHAR(100)))) 
	END as a2,

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


FROM scratch.L_Import_Rendicontazione_FlussoCBI
LEFT JOIN scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi ON Chiave_62 = Chiave_62_DA

LEFT JOIN scratch.D_Abi_Cab_NumeroContoCorrente abicabconto ON abicabconto.Abi = scratch.L_Import_Rendicontazione_FlussoCBI.ABI_61
	AND abicabconto.Cab = scratch.L_Import_Rendicontazione_FlussoCBI.CAB_61
	AND abicabconto.NumeroConto = scratch.L_Import_Rendicontazione_FlussoCBI.NumeroConto_61

LEFT JOIN T_ContoBancario on T_ContoBancario.NumeroConto = SUBSTRING(NumeroConto_61, PATINDEX('%[^0]%', NumeroConto_61+'.'), LEN(NumeroConto_61))  
	AND T_ContoBancario.Abi = ABI_61
	AND T_ContoBancario.Cab = CAB_61
LEFT JOIN T_ContoBancarioPerAnno ON T_ContoBancario.IdContoBancario = T_ContoBancarioPerAnno.IdContoBancario
	AND Anno = YEAR(GETDATE())
--LEFT JOIN S_OperazioneContoBancario ON S_OperazioneContoBancario.NomeOperazione = ISNULL(CAST(scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoCliente_62 AS VARCHAR(100)),Causale_61)
--	AND S_OperazioneContoBancario.SegnoImporto = CASE SegnoMovimento_62 WHEN 'C' THEN 1 WHEN 'D' THEN -1 ELSE 1 END
--	AND S_OperazioneContoBancario.CodiceCausale = (CASE CausaleCBI_62 WHEN '' THEN Causale_61 ELSE CausaleCBI_62 END)

LEFT JOIN D_Valuta on D_Valuta.Sigla = CodiceDivisa_61

LEFT JOIN scratch.T_R_ImportRendicontazione_Movimento 
	ON L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
		--AND T_ContoBancarioPerAnno.IdContoBancarioPerAnno = scratch.T_R_ImportRendicontazione_Movimento.IdContoBancarioPerAnno

WHERE scratch.T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario is NULL AND 
 ABI_61 IN ('03479')
AND CAB_61 IN ('01600')
AND NumeroConto_61 IN (

'000802240901'	--AZIMUT CAP. MANAG. SGR	Conto SIA/SISTEMA FORMULA 1	AZCM SIA/SIST FORM1
,'000802260103'	--AZ FUND 1	Conto Sottoscrizioni	AZCM/AZ FUND1 SOTT
,'000802260302'	--AZ Multi Asset	Conto Sottoscrizioni	AZCM/AZ MULTI AS SOT
,'000801241000'	--AZIMUT DINAMICO	Conto Afflusso	AZIMUT DINAMICO AF
,'000801241100'	--AZIMUT TREND   	Conto Afflusso	AZIMUT TREND AF
,'000801241200'	--AZIMUT SOLIDITY 	Conto Afflusso	AZIMUT SOLIDITY AF
,'000801241300'	--AZIMUT TREND ITALIA              	Conto Afflusso	AZIMUT TREND ITA AF
,'000801241400'	--AZIMUT TREND TASSI               	Conto Afflusso	AZIMUT TREND TASSI
,'000801241500'	--AZIMUT SCUDO         	Conto Afflusso	AZIMUT SCUDO AF
,'000801241600'	--AZIMUT TREND EUROPA              	Conto Afflusso	AZIMUT TREND EUR AF
,'000801241700'	--AZIMUT TREND AMERICA             	Conto Afflusso	AZIMUT TREND AMER AF
,'000801241800'	--AZIMUT  ITALIA ALTO POTENZIALE	Conto Afflusso	AZIMUT ITA. ALTO POTENZ.AF
,'000801241900'	--AZIMUT TARGET 2017 		AZIMUT TAR21 E.OP AF
,'000801242000'	--FORMULA 1 ABSOLUTE 	Conto Afflusso	AZIMUT FOR1 ABSOL AF
,'000801242100'	--AZIMUT REDDITO USA 	Conto Afflusso	AZIMUT RED USA AF
,'000801242200'	--AZIMUT STRATEGIC TREND           	Conto Afflusso	AZIMUT STRA TREND AF
,'000802258100'	--Azimut   Azimut Previdenza	conto afflusso	AZIMUT PREV/ AFFLUS 
  

)

AND L_Import_Rendicontazione_FlussoCBI.DataImport >=  DATEADD(DAY,-1,GETDATE())
--AND L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP in ( 4101577 --tre venezie che manca
--,4111855 --movimento che c'è già

--)

)

--SELECT * FROM a


SELECT 	unpvt.IdImport_RendicontazioneBP,
		unpvt.DataContabile_61,
		unpvt.ABI,
		unpvt.CAB,
		unpvt.Conto,
		unpvt.CodBanca,
		unpvt.IdContoBancario,
		unpvt.IdContoBancarioPerAnno,
		unpvt.DescrizioneConto,
		unpvt.SaldoInizialeSegno,
		unpvt.SaldoContabileSegno,
		unpvt.SaldoLiquidoSegno,
		unpvt.Divisa,
		unpvt.CodDivisa,
		unpvt.ProgressivoOperazione,
		unpvt.DataOperazione,
		unpvt.DataValuta,
		unpvt.Entrate,
		unpvt.Uscite,
		unpvt.Causale,
		unpvt.RiferimentoCliente_62,
		DescrizioneOperazione,
		unpvt.ClienteOrdinante_63,
		unpvt.SegnoSaldoIniziale,
		unpvt.SaldoIniziale,
		unpvt.SegnoSaldoContabile,
		unpvt.SaldoContabile,
		unpvt.SegnoSaldoLiquido,
		unpvt.SaldoLiquido,
		unpvt.SegnoMovimento,
		unpvt.ImportoMovimento FROM a
UNPIVOT (
	DescrizioneOperazione FOR details IN (a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24)

) AS unpvt
WHERE descrizioneoperazione != ''


GO