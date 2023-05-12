USE CLC
GO

--incarico AZF1 2020 --> 5

ALTER VIEW rs.v_CESAM_AZ_Riconciliatore_STATS AS

SELECT


	--,CONVERT(VARCHAR, DataValuta,3) AS 'Data Valuta' --> fatto a mano 
	CAST(DataValuta AS DATE) AS 'Data Valuta'
	--		T_ContoBancarioPerAnno.IdContoBancarioPerAnno
	--		  ,T_ContoBancarioPerAnno.Versione

	--		  ,tcbpa.IdIncarico 'AZF1'
	--,NomeConto

	--		  ,T_ContoBancarioPerAnno.IdContoBancario
	--		  ,Anno
	--		  ,T_ContoBancarioPerAnno.FlagCancellato
	--		  ,T_ContoBancario.IdContoBancario
	--		  ,T_ContoBancario.Versione

	--		  ,NumeroConto
	--		  ,CodBancaVD
	--		  ,CodValuta
	--		  ,FlagFittizio
	--		  ,CodTipoContoBancario
	--		  ,Abi
	--		  ,Cab
	--		  ,T_ContoBancario.FlagCancellato


   ,dbo.T_MovimentoContoBancario.IdMovimentoContoBancario 'IdMovBanc'


   ,trimcb.IdIncarico 'IdInc script'
   ,ciccio.IdIncarico 'IdInc conferm'
   ,dat.Descrizione 'attributo'
   ,so.Etichetta 'operatore'
	--,lwi.datamax 'DataOraRiconciliazione'
   ,lwi1.DataTransizione 'DataOraRiconciliazione'


	--		  ,T_MovimentoContoBancario.Versione
	--		  ,T_MovimentoContoBancario.IdContoBancarioPerAnno
	--		  ,Progressivo
	--		  ,CodTipoMovimentoContoBancario




	--		  ,DataATermine
	--		  ,IdOperazioneContoBancario
   ,Importo
	--		  ,IdTitoloFinanziario
	--		  ,Quantita
	--		  ,PrezzoUnitario
	--		  ,ImportoLordo
	--		  ,Commissioni
	--		  ,Rateo
	--		  ,Ritenute
	--		  ,FlagIncompleto
	--		  ,IdMovimentoContoBancarioCollegato
	--		  ,IdNotaIncarichi
	--		  ,IdDocumento
	--		  ,NumeroPagina
	--		  ,ChiaveEsterna
	--		  ,DataOperazione
	--		  ,FlagPresenzaContabile
	--		  ,FlagImportIncompleto
	--		  ,Euroritenute
	--		  ,CodPeriodicitaCedola
	--		  ,DataInizioTrade
	--		  ,DataFineTrade
	--		  ,IdTitoloFinanziarioDerivatoAssociato
	--		  ,QuantitaDerivatoAssociato
	--		  ,TassoCambioEffettivo
	--		  ,PrezzoDiMercato
	--		  ,FlagImportato


	--		  ,DataImport
	--		  ,cast(DataImport AS DATE) AS 'Data Import'



	--,CASE WHEN 
	--FlagConfermato = 1 AND FlagRiconciliato = 1 AND NotaAggiuntiva like'%auto%' THEN '0: pY - rY - cY (auto)'
	--WHEN
	--trimcb.IdIncarico IS NOT NULL AND CodiceTipoRiconciliazione IS NOT NULL AND FlagConfermato = 1 THEN '1: pY - rY - cY'
	--WHEN
	--trimcb.IdIncarico IS NOT NULL AND CodiceTipoRiconciliazione IS NOT NULL AND FlagConfermato = 0 THEN '2: pY - rY - cN'
	--WHEN
	--trimcb.IdIncarico IS NOT NULL AND CodiceTipoRiconciliazione IS NULL     AND FlagConfermato = 0 THEN '3: pY - rN - cN'
	--WHEN
	--trimcb.IdIncarico IS NULL     AND CodiceTipoRiconciliazione IS NULL     AND FlagConfermato = 0 THEN '4: pN - rN - cN'
	--ELSE
	--'000-check ciccio bbbello'
	--END
	--as 'Riconciliato/Confermato'


--   ,trimcb.IdIncarico 'IdInc script'
--   ,ciccio.IdIncarico 'IdInc conferm'
--	 ,so.Etichetta 'operatore'

   ,CASE
		WHEN
			FlagConfermato = 1 AND
			FlagRiconciliato = 1 AND
			NotaAggiuntiva LIKE '%auto%' AND NotaAggiuntiva NOT LIKE '%PAC%' THEN '0: R-C (auto)'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
		    so.Etichetta IS NULL AND
			FlagConfermato = 1 THEN '1: R-C'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
		    so.Etichetta IS NOT NULL AND 
			FlagConfermato = 1 THEN '1: R-C'
			
					WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva != '' and
			FlagConfermato = 1 THEN '1: R-C'

		WHEN CodiceTipoRiconciliazione = 9
		AND NotaAggiuntiva LIKE '%pac%'
		AND FlagConfermato = 1 THEN '1: R-C'

		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL and
			FlagConfermato = 0 THEN '2: R-c'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva != '' and
			FlagConfermato = 0 THEN '2: R-c'

		WHEN --trimcb.IdIncarico IS NULL 
			 CodiceTipoRiconciliazione = 9
			AND NotaAggiuntiva LIKE '%pac%'
			--AND FlagRiconciliato = 
			AND FlagConfermato = 0 THEN '2: R-c PAC'

		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NULL AND
			FlagConfermato = 1 THEN '3: r-c'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NULL AND
			FlagConfermato = 0 THEN '3: r-c'
					WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL and
			FlagConfermato = 0 AND FlagRiconciliato = 0 THEN '3: r-c'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL and
			FlagConfermato = 1 THEN '3: r-c'

		ELSE '000 - CHECK'
	END
	AS 'Riconciliato - Confermato MACRO'



   ,CASE
		WHEN
			FlagConfermato = 1 AND
			FlagRiconciliato = 1 AND
			NotaAggiuntiva LIKE '%auto%' AND NotaAggiuntiva NOT LIKE '%PAC%' THEN '0: R-C (auto)'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
		    so.Etichetta IS NOT NULL AND 
			FlagConfermato = 1 THEN '1a: R-C Operatore'
			
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
		    so.Etichetta IS NULL AND
			FlagConfermato = 1 THEN '1b: R-C Sistema'


	    WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva != '' and
			FlagConfermato = 1 THEN '1c: R-C ric con cod fake, conf da sist'

		WHEN CodiceTipoRiconciliazione = 9
		AND NotaAggiuntiva LIKE '%pac%'
		AND FlagConfermato = 1 THEN '1: R-C PAC'

		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL and
			FlagConfermato = 0 THEN '2a: R-c da confermare'
		
		WHEN --trimcb.IdIncarico IS NULL 
			 CodiceTipoRiconciliazione = 9
			AND NotaAggiuntiva LIKE '%pac%'
			--AND FlagRiconciliato = 1
			AND FlagConfermato = 0 THEN '2: R-c PAC'

		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva != '' and
			FlagConfermato = 0 THEN '2b: R-c nota (no cod ric)'
		
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NULL AND
			FlagConfermato = 1 THEN '3a: r-C cd "escluso da OP"'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NULL AND
			FlagConfermato = 0 THEN '3b: r-c non riconciliato'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL and
			FlagConfermato = 0 THEN '3c: R-c con codice fake da conf'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL and
			FlagConfermato = 1 THEN '3d: R-c con codice fake conf'

		ELSE '000 - CHECK'
	END
	AS 'Riconciliato - Confermato MICRO'

   ,CodiceTipoRiconciliazione 'CodRic'


   ,NotaAggiuntiva

,FlagRiconciliato
   ,FlagConfermato
	--		  ,dbo.T_MovimentoContoBancario.FlagAttivo
	--		  ,IdIntermediarioBancario
	--		  ,FlagStoricizzato
	--		  ,FlagRitenuteAllaFonte
	--		  ,IdMovimentoContoBancarioCollegatoStorno
	--		  ,IdDepositoTitolo
	--		  ,DataInserimento
	--		  ,DataUltimaModifica
	--		  ,DataRiconciliazione
	--		  ,DataConferma

	--		  ,IdMovimentoContoBancarioMaster
	--		  ,FlagParziale
	--		  ,ImportoValutaMovimento
	--		  ,CodValutaMovimento
	--		  ,TassoCambioValutaMovimento
	--		  ,PrezzoUnitarioValutaMovimento
	--		  ,ImportoLordoValutaMovimento
	--		  ,CommissioniValutaMovimento
	--		  ,RateoValutaMovimento
	--		  ,RitenuteValutaMovimento
	--		  ,EuroritenuteValutaMovimento
	--		  ,DataModificaManualeRateo
	--		  ,ImportoCalcolato
	--		  ,ImportoCalcolatoValutaMovimento
	--		  ,QuantitaOriginale
	--		  ,ValoreNominale
	--		  ,ValoreNominaleValutaMovimento
	--		  ,CodPrimaModalitaPagamento
	--		  ,CodSecondaModalitaPagamento
	--		  ,IdOperatoreInserimento	 
   ,tni.Testo 'Causale Bonifico'
--,D_AttributoIncarico.Descrizione

FROM dbo.T_ContoBancarioPerAnno tcbpa

JOIN dbo.T_ContoBancario
	ON tcbpa.IdContoBancario = dbo.T_ContoBancario.IdContoBancario
JOIN dbo.T_MovimentoContoBancario
	ON tcbpa.IdContoBancarioPerAnno = dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno
JOIN T_NotaIncarichi tni
	ON T_MovimentoContoBancario.IdNotaIncarichi = tni.IdNotaIncarichi


--join incasinata per tirare fuori idincarico del movimento associato
LEFT JOIN (SELECT
		ti.IdIncarico
	   ,tpi.IdMovimentoContoBancario
	FROM T_Incarico ti
	LEFT JOIN T_PagamentoInvestimento tpi
		ON ti.IdIncarico = tpi.IdIncarico
	WHERE ti.CodCliente = 23
	AND ti.CodArea = 8
	AND FlagAttivo = 1
	AND tpi.IdMovimentoContoBancario IS NOT NULL
	AND CodTipoIncarico IN (83,
	540, --sottoscrizioni lux zenith
	553 --aggiuntivi lux zenith
	)) ciccio
	ON ciccio.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario

LEFT JOIN (SELECT
		MAX(dbo.L_WorkflowIncarico.IdTransizione) IdMax
	   ,IdIncarico
	FROM L_WorkflowIncarico
	WHERE dbo.L_WorkflowIncarico.CodAttributoIncaricoDestinazione = 1520
	AND (dbo.L_WorkflowIncarico.CodAttributoIncaricoPartenza != 1520
	OR dbo.L_WorkflowIncarico.CodAttributoIncaricoPartenza IS NULL)
	GROUP BY IdIncarico) lwi
	ON ciccio.IdIncarico = lwi.IdIncarico
LEFT JOIN L_WorkflowIncarico lwi1
	ON lwi.IdMax = lwi1.IdTransizione

LEFT JOIN S_Operatore so
	ON lwi1.IdOperatore = so.IdOperatore
LEFT JOIN D_AttributoIncarico dat
	ON lwi1.CodAttributoIncaricoDestinazione = dat.Codice



--LEFT JOIN 
--(SELECT DISTINCT MAX(DataTransizione) datamax, IdIncarico 
--FROM L_WorkflowIncarico 
--GROUP BY IdIncarico 
--) lwi ON ciccio.IdIncarico = lwi.IdIncarico
--LEFT JOIN L_WorkflowIncarico lwi1 ON lwi.datamax=lwi1.DataTransizione

--LEFT JOIN S_Operatore so ON lwi1.IdOperatore = so.IdOperatore
--LEFT JOIN D_AttributoIncarico dat ON lwi1.CodAttributoIncaricoDestinazione = dat.Codice

LEFT JOIN T_R_Incarico_MovimentoContoBancario trimcb
	ON T_MovimentoContoBancario.IdMovimentoContoBancario = trimcb.IdMovimentoContoBancario

WHERE tcbpa.IdIncarico = 13943236
--AND DataValuta <= '20200901'
--AND 		  FlagConfermato = 1 AND FlagRiconciliato = 1 
--AND NotaAggiuntiva NOT LIKE '%auto%'

--AND
--so.IdOperatore=5316 --Cappiello 
--15405 Zanin
--AND Descrizione LIKE 'riconciliato'

--AND tni.Testo LIKE '%pac%'
-- AND dat.Descrizione LIKE 'riconciliato'

--ORDER BY DataImport desc, Importo
--AND NotaAggiuntiva  NOT LIKE '%AUTO%'

--AND DataValuta >= '20200923'

--AND tni.Testo LIKE '%case terze%'
--AND trimcb.IdMovimentoContoBancario=1192979

--AND NotaAggiuntiva LIKE '%pac%'
--AND T_MovimentoContoBancario.IdMovimentoContoBancario IN (1212631
--)
--AND FlagRiconciliato = 0
--AND trimcb.IdIncarico IS NOT NULL


--ORDER BY DataValuta ASC, [Riconciliato - Confermato MACRO] ASC,[Riconciliato - Confermato Micro] ASC, CodRic ASC, Importo DESC, IdMovBanc

