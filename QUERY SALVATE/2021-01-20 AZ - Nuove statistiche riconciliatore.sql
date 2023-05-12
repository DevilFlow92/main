--ALTER VIEW rs.v_CESAM_AZ_Riconciliatore_STATS AS

/* Author: Zanin A.
	Edit e maintenance: Fiori L.

	Utilizzata nel report: AZ - Riconciliatore STATS
*/

SELECT tmcb.IdMovimentoContoBancario 
,trimcb.IdIncarico IncaricoAssociato
,CAST(tmcb.DataImport AS DATE) DataImport
, CAST(tmcb.DataValuta AS DATE) DataValuta
, tmcb.Importo
,tmcb.CodiceTipoRiconciliazione
,tmcb.NotaAggiuntiva
,tmcb.FlagRiconciliato
,tmcb.FlagConfermato
,Testo 'Causale Bonifico'

,Riconciliazione.Utente
,Riconciliazione.IdOperatore
,Riconciliazione.Etichetta

,CASE WHEN tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1 
			AND tmcb.NotaAggiuntiva LIKE '%AUTO%' THEN '0: R-C (auto)'

	  WHEN tmcb.NotaAggiuntiva LIKE '*%-%*%' THEN '3c: r-c Non Riconciliato' --'4: DataEntry PAC'

	  WHEN tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1
			AND trimcb.IdIncarico IS NOT NULL
			--AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND Riconciliazione.IdOperatore IS NULL				
	  THEN '1: R-C Sistema'

	  WHEN tmcb.FlagConfermato = 0
			--AND tmcb.FlagRiconciliato = 1
			--AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND trimcb.IdIncarico IS NOT NULL
			AND Riconciliazione.IdOperatore IS NULL
	  THEN '2: R-c Sistema'

	  WHEN tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1
			AND trimcb.IdIncarico IS NOT NULL
			--AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND Riconciliazione.IdOperatore IS NOT NULL				
	  THEN '3a: r-c Operatore'

	  WHEN trimcb.IdIncarico IS NULL
		   AND tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1
	  THEN '3b: r-c Escluso dalla stampa'	
	  WHEN trimcb.IdIncarico IS NULL
			AND tmcb.FlagConfermato = 0 AND tmcb.FlagRiconciliato = 0
	  THEN '3c: r-c Non Riconciliato'

 ELSE 'CHECK'
 END [Riconciliato - Confermato MACRO]

,CASE WHEN  tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1
			AND tmcb.NotaAggiuntiva LIKE '%auto%' 
	  THEN '0: R-C (auto)'
	  
	  WHEN tmcb.NotaAggiuntiva LIKE '*%-%*%' THEN '3e: r-c Data Entry Rata PAC'

	  WHEN trimcb.IdIncarico IS NOT NULL
			AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND Riconciliazione.IdOperatore IS NULL
			AND tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1
	  THEN '1a: R-C Sistema'

	  
	  	   
	  WHEN trimcb.IdIncarico IS NOT NULL 
			AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND Riconciliazione.IdOperatore IS NULL
			AND tmcb.FlagConfermato = 0 AND tmcb.FlagRiconciliato = 1

	  THEN '2a: R-c Sistema'

	  WHEN tmcb.FlagConfermato = 0
			AND tmcb.FlagRiconciliato = 0
			AND Riconciliazione.IdOperatore IS NULL
			AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND trimcb.IdIncarico IS NOT NULL
	  THEN '2a: R-c Sistema'

	  WHEN trimcb.IdIncarico IS NOT NULL
			AND tmcb.CodiceTipoRiconciliazione IS NULL
			AND Riconciliazione.IdOperatore IS NOT NULL
		THEN '3a: r-c Operatore'
		
	  	  WHEN trimcb.IdIncarico IS NOT NULL
			AND tmcb.CodiceTipoRiconciliazione IS NOT NULL
			AND Riconciliazione.IdOperatore IS NOT NULL
	  THEN '3b: r-c Operatore Revisore'
	  	   	  
	  WHEN trimcb.IdIncarico IS NULL
			AND tmcb.FlagConfermato = 0 AND tmcb.FlagRiconciliato = 0	  
	 THEN '3c: r-c non riconciliato'

	 WHEN trimcb.IdIncarico IS NULL
			AND tmcb.FlagConfermato = 1 AND tmcb.FlagRiconciliato = 1
	 then '3d: r-c Escluso da Stampa'

	 ELSE 'CHECK'
END [Riconciliato - Confermato MICRO]


FROM T_MovimentoContoBancario tmcb
JOIN T_ContoBancarioPerAnno tcbpa ON tmcb.IdContoBancarioPerAnno = tcbpa.IdContoBancarioPerAnno
JOIN T_ContoBancario ON tcbpa.IdContoBancario = T_ContoBancario.IdContoBancario
	AND T_ContoBancario.NumeroConto = '802260103'
JOIN T_NotaIncarichi ON tmcb.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi

LEFT JOIN T_R_Incarico_MovimentoContoBancario trimcb ON tmcb.IdMovimentoContoBancario = trimcb.IdMovimentoContoBancario

OUTER APPLY (
				SELECT TOP 1 vlog1.IdRelazione, vlog1.Utente, vlog1.IdOperatore, so.Etichetta
                FROM storico.V_Log_T_R_Incarico_MovimentoContoBancario vlog1
				LEFT JOIN S_Operatore so ON vlog1.IdOperatore = so.IdOperatore
				WHERE vlog1.IdRelazione = trimcb.IdRelazione
				AND vlog1.CodTipoModifica = 1 --Insert
) Riconciliazione

--pac o pic?
--OUTER APPLY (
--				SELECT * 


--)

WHERE DATAimport >= DATEADD(DAY,-7,CONVERT(DATE,getdate()))

GO