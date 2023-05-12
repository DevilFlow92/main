

DECLARE @NumeroConto VARCHAR(100) = '000802626100'

--SELECT T_ContoBancarioPerAnno.IdIncarico, DataImport, Testo, * 
--FROM T_MovimentoContoBancario
--JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
--AND Anno = year(getdate())
--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
--AND Abi = '03479'
--AND cab = '01600'
--AND NumeroConto = '802626100'
--JOIN dbo.T_NotaIncarichi ON T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi


SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI
WHERE NumeroConto_61 = '000802626100'
AND Chiave_62 LIKE 'fake%'

SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi
JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON Chiave_62 = Chiave_62_DA
WHERE NumeroConto_61 = '000802626100'
AND Chiave_62_DA LIKE 'fake%'

IF OBJECT_ID('tempdb.dbo.#tmp_ImportRendicontazione') IS NOT NULL
begin
	DROP TABLE #tmp_ImportRendicontazione
end


SELECT TOP 50  T_ContoBancarioPerAnno.IdIncarico, T_MovimentoContoBancario.IdMovimentoContoBancario
,   scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP
   ,scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente
   ,scratch.L_Import_Rendicontazione_FlussoCBI.RH_Ricevente
   ,scratch.L_Import_Rendicontazione_FlussoCBI.RH_DataCreazione
   ,scratch.L_Import_Rendicontazione_FlussoCBI.RH_NomeSupporto
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Progressivo_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.ABIOriginarioBanca_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Causale_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Descrizione_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.TipoConto_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CIN_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.ABI_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CAB_61
   ,@NumeroConto NumeroConto_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CodiceDivisa_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.DataContabile_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Segno_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoInizialeQuadratura_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CodicePaese_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CheckDigit_61
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62
   ,'fake_'+Chiave_62  Chiave62_new
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Progressivo_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.DataValuta_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.ProgressivoMovimento_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.DataRegistrazione_Contabile_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SegnoMovimento_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.ImportoMovimento_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CausaleCBI_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CausaleInterna_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.NumeroAssegno_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoBanca_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.TipoRiferimentoCliente_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.RiferimentoCliente_62
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Progressivo_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.CodiceDivisa_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.DataContabile_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SegnoSaldoContabile_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoContabile_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SegnoSaldoLiquido_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoLiquido_64
   ,scratch.L_Import_Rendicontazione_FlussoCBI.Progressivo_65
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoLiquido1_65
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoLiquido2_65
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoLiquido3_65
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoLiquido4_65
   ,scratch.L_Import_Rendicontazione_FlussoCBI.SaldoLiquido5_65
   ,scratch.L_Import_Rendicontazione_FlussoCBI.EF_Mittente
   ,scratch.L_Import_Rendicontazione_FlussoCBI.EF_Ricevente
   ,scratch.L_Import_Rendicontazione_FlussoCBI.EF_DataCreazione
   ,scratch.L_Import_Rendicontazione_FlussoCBI.EF_NomeSupporto
   ,scratch.L_Import_Rendicontazione_FlussoCBI.EF_NumeroRendicontazioni
   ,scratch.L_Import_Rendicontazione_FlussoCBI.EF_NumeroRecord
INTO #tmp_ImportRendicontazione
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND Anno = year(getdate())
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND Abi = '03479'
AND cab = '01600'
AND NumeroConto = '802260103'
AND NotaAggiuntiva NOT LIKE '%{AUTO_%}%' AND NotaAggiuntiva NOT LIKE '%{Paperless_PAC}%'
AND Importo > 0
JOIN scratch.T_R_ImportRendicontazione_Movimento ON T_MovimentoContoBancario.IdMovimentoContoBancario = T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario
JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione = scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP

WHERE FlagConfermato = 1
AND FlagRiconciliato = 1
AND dbo.T_MovimentoContoBancario.DataImport >= '20230401'

ORDER BY NEWID()

BEGIN TRAN

INSERT INTO scratch.L_Import_Rendicontazione_FlussoCBI (RH_Mittente, RH_Ricevente, RH_DataCreazione, RH_NomeSupporto, Progressivo_61, ABIOriginarioBanca_61
, Causale_61, Descrizione_61, TipoConto_61, CIN_61, ABI_61, CAB_61, NumeroConto_61, CodiceDivisa_61, DataContabile_61, Segno_61, SaldoInizialeQuadratura_61
, CodicePaese_61, CheckDigit_61, Chiave_62, Progressivo_62, DataValuta_62, ProgressivoMovimento_62, DataRegistrazione_Contabile_62, SegnoMovimento_62
, ImportoMovimento_62, CausaleCBI_62, CausaleInterna_62, NumeroAssegno_62, RiferimentoBanca_62, TipoRiferimentoCliente_62, RiferimentoCliente_62, Progressivo_64
, CodiceDivisa_64, DataContabile_64, SegnoSaldoContabile_64, SaldoContabile_64, SegnoSaldoLiquido_64, SaldoLiquido_64, Progressivo_65, SaldoLiquido1_65, SaldoLiquido2_65, SaldoLiquido3_65
, SaldoLiquido4_65, SaldoLiquido5_65, EF_Mittente, EF_Ricevente, EF_DataCreazione, EF_NomeSupporto, EF_NumeroRendicontazioni, EF_NumeroRecord, DataImport)
SELECT RH_Mittente, RH_Ricevente, RH_DataCreazione, RH_NomeSupporto, Progressivo_61, ABIOriginarioBanca_61
, Causale_61, Descrizione_61, TipoConto_61, CIN_61, ABI_61, CAB_61, NumeroConto_61, CodiceDivisa_61, DataContabile_61, Segno_61, SaldoInizialeQuadratura_61
, CodicePaese_61, CheckDigit_61, Chiave62_new
, Progressivo_62, DataValuta_62, ProgressivoMovimento_62, DataRegistrazione_Contabile_62, SegnoMovimento_62
, ImportoMovimento_62, CausaleCBI_62, CausaleInterna_62, NumeroAssegno_62, RiferimentoBanca_62, TipoRiferimentoCliente_62, RiferimentoCliente_62, Progressivo_64
, CodiceDivisa_64, DataContabile_64, SegnoSaldoContabile_64, SaldoContabile_64, SegnoSaldoLiquido_64, SaldoLiquido_64, Progressivo_65, SaldoLiquido1_65, SaldoLiquido2_65, SaldoLiquido3_65
, SaldoLiquido4_65, SaldoLiquido5_65, EF_Mittente, EF_Ricevente, EF_DataCreazione, EF_NomeSupporto, EF_NumeroRendicontazioni, EF_NumeroRecord, GETDATE()
FROM #tmp_ImportRendicontazione

INSERT INTO scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi (Chiave_62_DA, Progressivo_63, ProgressivoMovimento_63
, FlagStruttura_63, IdentificativoRapporto_63, DataOrdine_63, CodificaFiscaleOrdinante_63, ClienteOrdinante_63, Localita_63, IndirizzoOrdinante_63
, IbanOrdinante_63, ImportoOriginalePagamento_63, CodiceDivisaImportoOriginario_63, ImportoRegolato_63, CodiceDivisaRegolamento_63, ImportoNegoziato_63
, CodiceDivisaImportoNegoziato_63, CambioApplicato_63, ImportoCommisioni_63, ImportoSpese_63, CodicePaese_63, OrdinantePagamento_63, Beneficiario_63, MotivazionePagamento_63
, DescrizioneMovimento_63, IDUnivocoMessaggio_63, IDEndToEnd_63, InformazioniRiconciliazione_63, DataImport)
SELECT Chiave62_new , Progressivo_63, ProgressivoMovimento_63
, FlagStruttura_63, IdentificativoRapporto_63, DataOrdine_63, CodificaFiscaleOrdinante_63, ClienteOrdinante_63, Localita_63, IndirizzoOrdinante_63
, IbanOrdinante_63, ImportoOriginalePagamento_63, CodiceDivisaImportoOriginario_63, ImportoRegolato_63, CodiceDivisaRegolamento_63, ImportoNegoziato_63
, CodiceDivisaImportoNegoziato_63, CambioApplicato_63, ImportoCommisioni_63, ImportoSpese_63, CodicePaese_63, OrdinantePagamento_63, Beneficiario_63, MotivazionePagamento_63
, DescrizioneMovimento_63, IDUnivocoMessaggio_63, IDEndToEnd_63, InformazioniRiconciliazione_63, DataImport 
FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi
JOIN #tmp_ImportRendicontazione ON Chiave_62 = Chiave_62_DA

COMMIT TRAN

DROP TABLE #tmp_ImportRendicontazione


