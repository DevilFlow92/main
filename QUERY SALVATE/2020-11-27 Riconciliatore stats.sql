USE CLC
GO

--incarico AZF1 2020 --> 13943236 (con flussi da novembre)


SELECT T_MovimentoContoBancario.IdMovimentoContoBancario, trimcb.IdIncarico
/*
	CAST(DataValuta AS DATE) AS 'Data Valuta'
   ,dbo.T_MovimentoContoBancario.IdMovimentoContoBancario 'IdMovBanc'
   ,trimcb.IdIncarico 'IdInc script'
   --,ciccio.IdIncarico 'IdInc conferm'
   ,dat.Descrizione 'attributo'
   ,so.Etichetta 'operatore'
   ,lwi1.DataTransizione 'DataOraRiconciliazione'
   ,Importo

	,CASE WHEN
				FlagConfermato = 1 
				AND	FlagRiconciliato = 1 
				AND so.Etichetta IS NULL 
				AND	CodiceTipoRiconciliazione IS NOT NULL
				AND	NotaAggiuntiva LIKE '%auto%' 			
				
				THEN '0: R-C (auto)'
		WHEN
				FlagConfermato = 1 
				AND	FlagRiconciliato = 1 
				AND so.Etichetta IS NOT NULL 
				AND	FlagConfermato = 1 
				--AND	NotaAggiuntiva LIKE '%auto%' 			
				
				THEN '1: R-C Operatore'



			ELSE '9: check'
			END AS 'new R-C'


   ,CASE
		WHEN
			FlagConfermato = 1 AND
			FlagRiconciliato = 1 AND
			NotaAggiuntiva LIKE '%auto%' THEN '0: R-C (auto)'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL AND
			FlagConfermato = 1 THEN '1: R-C'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NOT NULL AND
			FlagConfermato = 1 
			AND lwi1.IdOperatore IS NOT NULL 
			THEN '1: R-C'

		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva <> '' AND
			FlagConfermato = 1 THEN '1: R-C'

		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			FlagConfermato = 0 THEN '2: R-c'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva <> '' AND
			FlagConfermato = 0 THEN '2: R-c'

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
			CodiceTipoRiconciliazione IS NOT NULL AND CodiceTipoRiconciliazione = 9 and
			so.Etichetta IS NULL AND
			FlagConfermato = 0 THEN '2: R-c'


		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND CodiceTipoRiconciliazione <> 9 and
			so.Etichetta IS NULL AND
			FlagConfermato = 0 THEN '3: r-c'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL AND
			FlagConfermato = 1 THEN '3: r-c'

		ELSE '000-check ciccio bbbello'
	END
	AS 'Riconciliato - Confermato MACRO'



   ,CASE
		WHEN
			FlagConfermato = 1 AND
			FlagRiconciliato = 1 AND
			NotaAggiuntiva LIKE '%auto%' THEN '0: R-C (auto)'
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
			NotaAggiuntiva <> '' AND
			FlagConfermato = 1 THEN '1c: R-C ric con cod fake, conf da sist'

		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			FlagConfermato = 0 THEN '2a: R-c da confermare'
		WHEN
			trimcb.IdIncarico IS NOT NULL AND
			NotaAggiuntiva <> '' AND
			FlagConfermato = 0 THEN '2b: R-c nota (no cod ric)'



		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NULL AND
			FlagConfermato = 1 THEN '3a: r-C cd "escluso da OP"'

		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND CodiceTipoRiconciliazione = 9 and
			so.Etichetta IS NULL AND
			FlagConfermato = 0 THEN '2c: R-c PAC'

					WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND CodiceTipoRiconciliazione <> 9 and
			so.Etichetta IS NULL AND
			FlagConfermato = 0 THEN '3c: R-c con codice fake da conf'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NOT NULL AND
			so.Etichetta IS NULL AND
			FlagConfermato = 1 THEN '3d: R-c con codice fake conf'
		WHEN
			trimcb.IdIncarico IS NULL AND
			CodiceTipoRiconciliazione IS NULL AND
			FlagConfermato = 0 THEN '3b: r-c non riconciliato'
	ELSE '000-check ciccio bbbello'
	END
	AS 'Riconciliato - Confermato MICRO'

   ,CodiceTipoRiconciliazione 'CodRic'
   ,NotaAggiuntiva
   ,FlagConfermato
   ,tni.Testo 'Causale Bonifico'

*/

FROM dbo.T_ContoBancarioPerAnno tcbpa

JOIN dbo.T_ContoBancario
	ON tcbpa.IdContoBancario = dbo.T_ContoBancario.IdContoBancario
	AND NumeroConto = '802260103' --azfund
JOIN dbo.T_MovimentoContoBancario
	ON tcbpa.IdContoBancarioPerAnno = dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno
JOIN T_NotaIncarichi tni
	ON T_MovimentoContoBancario.IdNotaIncarichi = tni.IdNotaIncarichi

----join incasinata per tirare fuori idincarico del movimento associato
--LEFT JOIN (SELECT
--		ti.IdIncarico
--	   ,tpi.IdMovimentoContoBancario
--	FROM T_Incarico ti
--	LEFT JOIN T_PagamentoInvestimento tpi
--		ON ti.IdIncarico = tpi.IdIncarico
--	WHERE ti.CodCliente = 23
--	AND ti.CodArea = 8
--	AND FlagAttivo = 1
--	AND tpi.IdMovimentoContoBancario IS NOT NULL
--	AND CodTipoIncarico IN (83,
--	540, --sottoscrizioni lux zenith
--	553, --aggiuntivi lux zenith
--	693 --Rata PAC
--	)
--	) ciccio
--	ON ciccio.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
--LEFT JOIN T_R_Incarico_MovimentoContoBancario trimcb1 ON T_MovimentoContoBancario.IdMovimentoContoBancario = trimcb1.IdMovimentoContoBancario

--LEFT JOIN ( SELECT trimcb1.*
--				FROM T_R_Incarico_MovimentoContoBancario trimcb1
--			JOIN T_Incarico ti1 ON trimcb1.IdIncarico = ti1.IdIncarico
--			WHERE  ti1.CodArea = 8 AND ti1.CodCliente = 23 AND ti1.CodTipoIncarico IN (83,540,553,693)
--			) trimcb ON trimcb.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario

OUTER APPLY (
				SELECT trimcb1.*
				FROM T_R_Incarico_MovimentoContoBancario trimcb1
			JOIN T_Incarico ti1 ON trimcb1.IdIncarico = ti1.IdIncarico
			WHERE  ti1.CodArea = 8 AND ti1.CodCliente = 23 AND ti1.CodTipoIncarico IN (83,540,553,693)
			AND trimcb1.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
			) trimcb

/*			
LEFT JOIN (SELECT
		MAX(dbo.L_WorkflowIncarico.IdTransizione) IdMax
	   ,L_WorkflowIncarico.IdIncarico
	FROM L_WorkflowIncarico
	JOIN T_Incarico ti ON L_WorkflowIncarico.IdIncarico = ti.IdIncarico
	AND ti.CodArea = 8 AND ti.CodCliente = 23 AND ti.CodTipoIncarico IN (83,540,553,693)
	WHERE dbo.L_WorkflowIncarico.CodAttributoIncaricoDestinazione = 1520
	AND (dbo.L_WorkflowIncarico.CodAttributoIncaricoPartenza != 1520
	OR dbo.L_WorkflowIncarico.CodAttributoIncaricoPartenza IS NULL)
	GROUP BY L_WorkflowIncarico.IdIncarico
	) lwi
	ON trimcb.IdIncarico = lwi.IdIncarico

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

*/

WHERE tcbpa.IdIncarico = 13943236 --azfund
--WHERE tcbpa.IdIncarico = 13943228  --case terze

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

AND DataValuta >= '20201101'
AND tni.Testo NOT LIKE '%reinv%div%'
--AND trimcb.IdMovimentoContoBancario=1192979
--AND T_MovimentoContoBancario.IdMovimentoContoBancario = 1250918
--AND tni.Testo LIKE '%vers%iniz%pac%'

--ORDER BY DataValuta ASC, [Riconciliato - Confermato MACRO] ASC, [Riconciliato - Confermato Micro] ASC, CodRic ASC, Importo DESC, IdMovBanc


