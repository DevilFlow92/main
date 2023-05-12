USE CLC
GO

WITH RicSTATS AS (

SELECT DISTINCT

CAST( tmcb.DataValuta AS DATE) 'DataValuta'
,tmcb.IdMovimentoContoBancario
,tmcb.CodiceTipoRiconciliazione
,trimcb.IdIncarico 'IdIncarico SCRIPT'
,ti.IdIncarico AS 'IdIncarico CONF'

	,CASE WHEN
				FlagRiconciliato = 1 
				AND	FlagConfermato = 1 
				AND so.Etichetta IS NULL 
				AND	NotaAggiuntiva LIKE '%auto%' 		
			THEN '0: R-C (auto)'

		WHEN
				CodiceTipoRiconciliazione IS NOT null
				AND FlagRiconciliato = 1 
				AND	FlagConfermato = 1 
				AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NOT NULL --IdIncarico 
				AND ti.idincarico IS NOT NULL --IdIncarico confermato da OP
				
				THEN '1: R-C (p) Operatore (cod ric presente)'


		WHEN
				CodiceTipoRiconciliazione IS null
				AND FlagRiconciliato = 1 
				AND	FlagConfermato = 1 
				AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NOT NULL --IdIncarico 
				AND ti.idincarico IS NOT NULL --IdIncarico confermato da OP
				
				THEN '1: R-C (p) Operatore (senza ric presente why?)'

		WHEN
				CodiceTipoRiconciliazione IS null
				AND FlagRiconciliato = 1 
				AND	FlagConfermato = 1 
				AND so.Etichetta IS NULL 
				AND trimcb.IdIncarico IS NOT NULL --IdIncarico da script
				AND ti.idincarico IS NOT NULL --IdIncarico confermato da OP
				
				THEN '1: R-C (p) no Operatore (senza ric presente why?)'
		WHEN
				CodiceTipoRiconciliazione IS NOT NULL 
				--AND FlagRiconciliato = 1 (tolgo questo perché ci sono codici 1 non "riconciliati" quindi è cmq una condizione che dovrei aggiungere)
				AND	FlagConfermato = 0 
				--AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NOT NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '2: R-c (p) ancora da confermare ma IdInc presente'		

		WHEN
				CodiceTipoRiconciliazione IS NOT NULL 
				--AND FlagRiconciliato = 1 (tolgo questo perché ci sono codici 1 non "riconciliati" quindi è cmq una condizione che dovrei aggiungere)
				AND	FlagConfermato = 0 
				--AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '2: R-c (np) ancora da confermare ma IdInc assente'	

		WHEN
				CodiceTipoRiconciliazione IS NOT NULL 
				--AND FlagRiconciliato = 1 (tolgo questo perché ci sono codici 1 non "riconciliati" quindi è cmq una condizione che dovrei aggiungere)
				AND	FlagConfermato = 0 
				--AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '2: R-c (p - tolta) riconciliato ma tolta associazione a valle'		

		WHEN
				CodiceTipoRiconciliazione IS NULL 
				--AND FlagRiconciliato = 1 (tolgo questo perché ci sono codici 1 non "riconciliati" quindi è cmq una condizione che dovrei aggiungere)
				AND	FlagConfermato = 0 
				--AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '2: r-c (np) ancora da riconciliare (no ric auto)'
		
		WHEN
				CodiceTipoRiconciliazione IS null
				AND FlagRiconciliato = 1 
				AND	FlagConfermato = 1 
				AND so.Etichetta IS NULL 
				AND trimcb.IdIncarico IS NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '3: r-E (np) escluso da riconciliazione'

		WHEN
				CodiceTipoRiconciliazione IS NOT NULL 
				--AND FlagRiconciliato = 1 (tolgo questo perché ci sono codici 1 non "riconciliati" quindi è cmq una condizione che dovrei aggiungere)
				AND	FlagConfermato = 1
				--AND so.Etichetta IS NOT NULL 
				AND trimcb.IdIncarico IS NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '3: R-E (p - tolta) riconciliato ma tolta associazione a valle e confermato'

		WHEN
				CodiceTipoRiconciliazione = 9
				AND FlagRiconciliato = 1 
				AND	FlagConfermato = 1 
				AND so.Etichetta IS NULL 
				AND trimcb.IdIncarico IS NOT NULL --IdIncarico da script
				AND ti.idincarico IS NULL --IdIncarico confermato da OP
				
				THEN '4: r-C (np) rata pac data entry Simio'



		ELSE '9: check'
			END AS 'Stats R-C'

,tmcb.FlagRiconciliato
,tmcb.CodiceTipoRiconciliazione 'CodRic'
,tmcb.FlagConfermato
   --,dat.Descrizione 'attributo'
,so.Etichetta 'operatore'
,lwi1.DataTransizione 'DataOraRiconciliazione'
,CONVERT(DECIMAL, tmcb.Importo ) 'Importo'
--,tmcb.IdNotaIncarichi
,tmcb.NotaAggiuntiva
--,tmcb.DataRiconciliazione
,tni.Testo
--,trimcb.IdRelazione
--,tpi.IdPagamento


FROM T_ContoBancarioPerAnno tcbpa

LEFT JOIN T_ContoBancario tcb ON tcbpa.IdContoBancario = tcb.IdContoBancario
LEFT JOIN T_MovimentoContoBancario tmcb ON tcbpa.IdContoBancarioPerAnno = tmcb.IdContoBancarioPerAnno
LEFT JOIN T_NotaIncarichi tni ON tmcb.IdNotaIncarichi = tni.IdNotaIncarichi

LEFT JOIN T_R_Incarico_MovimentoContoBancario trimcb ON tmcb.IdMovimentoContoBancario = trimcb.IdMovimentoContoBancario

LEFT JOIN T_PagamentoInvestimento tpi ON tmcb.IdMovimentoContoBancario = tpi.IdMovimentoContoBancario
AND trimcb.IdIncarico = tpi.IdIncarico

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
	--,693 --Rata PAC

	)) ti
	ON ti.IdMovimentoContoBancario = tmcb.IdMovimentoContoBancario
	AND ti.IdIncarico=trimcb.IdIncarico --in caso togli questo


LEFT JOIN (SELECT
		MAX(dbo.L_WorkflowIncarico.IdTransizione) IdMax
	   ,IdIncarico
	FROM L_WorkflowIncarico
	WHERE dbo.L_WorkflowIncarico.CodAttributoIncaricoDestinazione = 1520
	AND (dbo.L_WorkflowIncarico.CodAttributoIncaricoPartenza != 1520
	OR dbo.L_WorkflowIncarico.CodAttributoIncaricoPartenza IS NULL)
	GROUP BY IdIncarico) lwi
	ON ti.IdIncarico = lwi.IdIncarico
	AND lwi.IdIncarico = trimcb.IdIncarico

LEFT JOIN L_WorkflowIncarico lwi1
	ON lwi.IdMax = lwi1.IdTransizione

LEFT JOIN S_Operatore so
	ON lwi1.IdOperatore = so.IdOperatore
LEFT JOIN D_AttributoIncarico dat
	ON lwi1.CodAttributoIncaricoDestinazione = dat.Codice

WHERE tcbpa.IdIncarico = 13943236

AND tmcb.DataImport >= '2020-11-26'

--AND tmcb.IdMovimentoContoBancario = 1257686
--AND trimcb.IdIncarico = 1257686 

--AND trimcb.IdIncarico= 16437319

--AND tpi.IdPagamento NOT IN(874467,874468,874469,874470,874471,874472,874473,874474,874475,874477,874478,874479,874480,874481,874482,874483, 874484,874485,874486,874487,874488,874489,874490,874491,874492, 874493,874494,874495,874498,874499,874500,874502,874503)


)

SELECT DataValuta
	  ,IdMovimentoContoBancario
	  ,CodiceTipoRiconciliazione
	  ,[IdIncarico SCRIPT]
	  ,[IdIncarico CONF]
	  ,CASE 
			WHEN [Stats R-C] LIKE '0%' THEN '0'
			WHEN [Stats R-C] LIKE '1%' THEN '1'
			WHEN [Stats R-C] LIKE '2%' THEN '2'
			WHEN [Stats R-C] LIKE '3%' THEN '3'
			WHEN [Stats R-C] LIKE '4%' THEN '4'
			ELSE 'check'
		END AS 'Stats R-C Macro'
	  ,[Stats R-C]
	  ,FlagRiconciliato
	  ,CodRic
	  ,FlagConfermato
	  ,operatore
	  ,DataOraRiconciliazione
	  ,Importo
	  ,NotaAggiuntiva
	  ,Testo


FROM RicSTATS


ORDER BY IdMovimentoContoBancario

