USE clc

GO

ALTER VIEW rs.v_CESAM_CB_Fatturazione_Processo_2020 AS 


/*
Author: Chessa S. 
Fiori L

Utilizzata nel nuovo report fatturazione


Lista incarichi:
- Contratti Consulenza CheBanca (web collaboration)
  Generazione Kit Persone Fisiche
  Trasferimento Servizi Pagamento FEA

  CONTO UN PEZZO PER INCARICO, base dati CREAZIONE


- Generazione Kit Small Business (standard e filiali)
  CONTO UN PEZZO PER INCARICO MA C'E' DISCRIMINAZIONE DI PREZZO A SECONDA DELLA STATO WF FINALE
  --> Archiviata - Oggetto Sociale non ammissibile
  --> Archiviata - CERVED negativa
  --> Tutti gli altri stati sono "Lavorazione Completa" (quindi prezzo pieno)

  Base dati CREAZIONE

  Si utilizza la vista rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_LogicaStatiWorkflow


- Incarichi Nuovo Processo (cd 2.0)

  Perimetro: CodTipoIncarico  611,613,682
  
  Si fattura per fasi (determinate dalle transizioni sui seguenti stati wf chiave):

  FASE 1 --> Carta: Nuova - Creata
  		   FEA : In Gestione - Genera Controlli Gestione
  
  FASE 2 --> In Gestione - Popolamento e Verifiche Effettuate (RO) In Gestione - Acquisita (Cagliari)
  		   FEA: sempre conto / sempre switch (ci sono i tipi incarico dedicati 611 e 613)
  		   CARTA: Flag OK/KO su controllo "Conto Corrente Censito" e/o "Switch Conto Censito"
  				  Con il flag su uno o entrambi conto 1 fase 2 per il conto
  					
  				  Flag OK/KO su controllo "Dossier Censito" e/o "Carta di credito censita"
  				  Con il flag su uno e entrabi conto 1 fase 2 per eventuali integrazioni
  
  FASE 3 --> In Gestione - Accordo Attivo sempre e solo sul conto (non si contano fasi 3 per le integrazioni)
  
  FASE 4 --> Ogni Motivo Transizione appartenente al wf Sospesa - Regolarizzata
			 Lista motivi:
			 124	Documentale Conto Corrente
		     125	Documentale Dossier
		     126	Documentale Carta di Credito
		     127	Documentale Switch
		     128	Errore Tecnico
		     129	Mancata Attivazione Accordo
  

  Base dati: DATA TRANSIZIONE

- Aggiornamento Documentale. Incarichi utilizzati da dpe per tracciare gli aggiornamenti dei template dei kit generabili 
  su richiesta della banca
  CONTA UN PEZZO PER INCARICO, base dati: data Ingaggio MOL (dato aggiuntivo)

*/


WITH 
/*** INCARICHI FEA 2.0 CREATI DA OPERATORE - LAVORAZIONI NON STANDARD (PER QUESTE SI CONTANO SOLO FASE 3 E/O FASE 4 ***/
GiaClienti as (

SELECT ti.IdIncarico
FROM T_Incarico ti
JOIN (SELECT MIN(IdTransizione) IdTransizione, tix.IdIncarico
			FROM L_WorkflowIncarico lwi
			JOIN T_Incarico tix ON lwi.idincarico = tix.IdIncarico
			WHERE tix.CodArea = 8
			AND tix.CodCliente = 48
			AND tix.CodTipoIncarico IN ( 611,682)
			AND lwi.idoperatore != 21
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 6500
			GROUP BY tix.IdIncarico
) creazioneManuale ON ti.IdIncarico = creazioneManuale.IdIncarico
WHERE ti.CodCliente = 48
AND ti.CodArea = 8
AND ti.CodTipoIncarico IN ( 611,682)
AND ti.DataCreazione >= '20200615'
)
/**********************************************************************************************************************/

SELECT 
ti.IdIncarico
,ti.CodTipoIncarico
,d.TipoIncarico

,ti.DataCreazione
,CASE when ti.ChiaveCliente is null OR ti.ChiaveCliente = '' THEN tp.ChiaveCliente ELSE ti.ChiaveCliente END ChiaveIncarico
,ti.DataUltimaTransizione
,d.StatoWorkflowIncarico

,tp.ChiaveCliente NDG
,CASE when tp.Cognome is null or tp.Cognome = ' '
	THEN tp.RagioneSociale
	ELSE tp.Cognome 

	END Cognome

,tp.Nome

,CASE when cc.CodGiudizioControllo = 2 OR ti.CodTipoIncarico IN ( 611) THEN 1 ELSE 0 END FlagCC_Censito
,CASE when cc.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagCC_DaCensire
,CASE when Dossier.CodGiudizioControllo = 2 THEN 1 ELSE 0 END FlagDossier_Censito
,CASE WHEN Dossier.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagDossier_DaCensire
,CASE WHEN kk.CodGiudizioControllo = 2 then 1 else 0 END FlagKK_Censita
,CASE WHEN kk.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagKK_DaCensire
,CASE WHEN SWITCH.CodGiudizioControllo = 2 OR ti.CodTipoIncarico = 682 THEN 1 ELSE 0 END FlagSwitch_Censito
,CASE WHEN SWITCH.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagSwitch_DaCensire

,CASE when fase1.IdTransizione IS not NULL AND ti.CodTipoIncarico = 613 AND (ROW_NUMBER() OVER ( PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico ) ) = 1
	THEN 1 
 WHEN Fase1AR.IdTransizione IS NOT NULL AND ti.CodTipoIncarico IN (611,682) AND GiaClienti.IdIncarico IS NULL AND (ROW_NUMBER() OVER ( PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico ) ) = 1 THEN 1
	else 0 END Fase1
,CASE WHEN ti.CodTipoIncarico = 613 THEN fase1.DataTransizione
	WHEN ti.CodTipoIncarico IN ( 611,682) AND GiaClienti.IdIncarico IS NULL THEN fase1ar.DataTransizione
	END LavorazioneFase1
,CASE WHEN  ti.CodTipoIncarico = 613  THEN fase1.IdOperatore
	WHEN ti.CodTipoIncarico IN ( 611,682) AND GiaClienti.IdIncarico IS NULL THEN Fase1AR.IdOperatore
END IdOperatoreFase1
,CASE when ti.CodTipoIncarico = 613 THEN OperatoreFase1.Etichetta
	WHEN ti.CodTipoIncarico IN (611,682) AND GiaClienti.IdIncarico IS NULL  THEN OperatoreFase1AR.Etichetta
	END OperatoreFase1

,CASE WHEN ti.CodTipoIncarico = 613 AND Fase1AR.IdTransizione IS NOT NULL AND (ROW_NUMBER() OVER ( PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico ) ) = 1 THEN 1 ELSE 0 END Fase1AR
,CASE WHEN ti.CodTipoIncarico = 613 THEN Fase1AR.DataTransizione ELSE NULL  END LavorazioneFase1AR
,CASE WHEN ti.codtipoincarico = 613 THEN Fase1AR.IdOperatore ELSE NULL END IdOperatoreFase1AR
,CASE WHEN ti.CodTipoIncarico = 613 THEN OperatoreFase1AR.Etichetta ELSE NULL END OperatoreFase1AR

,CASE WHEN Fase2AR.IdTransizione is not NULL AND GiaClienti.IdIncarico IS NULL AND (ROW_NUMBER() OVER ( PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico ) ) = 1 then 1 ELSE 0 END Fase2AR
,case when GiaClienti.IdIncarico is  null  then Fase2AR.DataTransizione    END LavorazioneFase2AR
,case when GiaClienti.IdIncarico is  null  then Fase2AR.IdOperatore        END IdOperatoreFase2AR
,case when GiaClienti.IdIncarico is  null  then OperatoreFase2AR.Etichetta END OperatoreFase2AR

,CASE when Fase2CA.IdTransizione is NOT NULL AND (ROW_NUMBER() OVER ( PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico ) ) = 1 then 1 ELSE 0 END Fase2CA
,case when GiaClienti.IdIncarico is NULL then Fase2CA.DataTransizione	 end	LavorazioneFase2CA
,case when GiaClienti.IdIncarico is NULL then Fase2CA.IdOperatore		 end	IdOperatoreFase2CA
,case when GiaClienti.IdIncarico is NULL then OperatoreFase2CA.Etichetta end	OperatoreFase2CA

,CASE WHEN Fase3.IdTransizione IS NOT NULL AND ( cc.CodGiudizioControllo IN (2,4) OR switch.CodGiudizioControllo IN (2,4) OR ti.CodTipoIncarico IN (611,682)) AND (ROW_NUMBER() OVER ( PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico ) ) = 1 THEN 1 ELSE 0 END Fase3
,CASE WHEN cc.CodGiudizioControllo IN (2,4) or switch.CodGiudizioControllo IN (2,4) OR ti.CodTipoIncarico IN (611,682) THEN  Fase3.DataTransizione END  LavorazioneFase3
,case when cc.CodGiudizioControllo in (2,4) or switch.CodGiudizioControllo IN (2,4) OR ti.CodTipoIncarico IN (611,682) then Fase3.IdOperatore END IdOperatoreFase3
,case when cc.CodGiudizioControllo in (2,4) or switch.CodGiudizioControllo IN (2,4) OR ti.CodTipoIncarico IN (611,682) then OperatoreFase3.Etichetta END OperatoreFase3

,CASE WHEN Fase4.IdTransizione is NOT NULL AND Fase4.DataTransizione < '20201001' THEN 1
WHEN fase4.IdTransizione IS NOT NULL AND Fase4.DataTransizione >= '20201001' THEN inputFase4.N 
ELSE 0 END Fase4
,Fase4.DataTransizione LavorazioneFase4
,Fase4.IdOperatore IdOperatoreFase4
,OperatoreFase4.Etichetta OperatoreFase4

,CASE WHEN ti.CodTipoIncarico = 359 THEN 1 ELSE 0 END FlagConsulenza
,CASE when ti.CodTipoIncarico = 564 THEN 1 ELSE 0 END FlagTSP
,CASE WHEN ti.CodTipoIncarico = 593 then 1 else 0 END FlagGenerazioneKit
,0 AS FlagAggiornamentoDocumentale
,NULL AS TipoPackAggiornato
,NULL AS PrezzoPack
,0 [SB-LavorazioneCompleta]
,0 [SB-SospesaOggettoSociale]
,0 [SB-SospesaCervedNegativa]
,0 [SB-Fil-LavorazioneCompleta]
,0 [SB-Fil-SospesaOggettoSociale]
,0 [SB-Fil-SospesaCervedNegativa]

,triop1.IdOperatore IdOperatoreGestore
,so1.Etichetta OperatoreGestore
,triop2.IdOperatore IdOpertatoreGestoreSupporto
,so2.Etichetta OperatoreGestoreSupporto
,triop3.IdOperatore IdOperatoreGestore4Eyes
,so3.Etichetta OperatoreGestore4Eyes

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico

LEFT JOIN T_R_Incarico_Persona trip ON ti.IdIncarico = trip.IdIncarico
AND trip.Progressivo = 1
LEFT JOIN T_Persona tp on trip.IdPersona = tp.IdPersona


LEFT JOIN T_MacroControllo tmc ON ti.IdIncarico = tmc.IdIncarico
AND IdTipoMacroControllo = 3205

LEFT JOIN T_Controllo cc ON tmc.IdMacroControllo = cc.IdMacroControllo
AND cc.IdTipoControllo = 8327	--Conto Corrente censito
LEFT JOIN T_Controllo Dossier ON tmc.IdMacroControllo = Dossier.IdMacroControllo
AND Dossier.IdTipoControllo = 8328	--Dossier censito
LEFT JOIN T_Controllo kk ON tmc.IdMacroControllo = kk.IdMacroControllo
AND kk.IdTipoControllo = 8329	--Carta di Credito censita

LEFT JOIN T_Controllo switch ON tmc.IdMacroControllo = switch.IdMacroControllo
AND switch.IdTipoControllo = 8442 --switch censito

left JOIN (
SELECT min(lwi.IdTransizione) IdTransizione, tix.IdIncarico
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodCliente = 48
AND tix.CodArea = 8
AND tix.CodTipoIncarico IN (613)
AND lwi.CodStatoWorkflowIncaricoPartenza is NULL
AND lwi.CodStatoWorkflowIncaricoDestinazione = 6500 --Nuova - Creata

GROUP BY tix.IdIncarico


) inputFase1 ON ti.IdIncarico = inputFase1.IdIncarico

LEFT JOIN L_WorkflowIncarico Fase1 ON inputFase1.IdTransizione = Fase1.IdTransizione

LEFT JOIN (
SELECT min(lwi.IdTransizione) IdTransizione, tix.IdIncarico
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodCliente = 48
AND tix.CodArea = 8
AND tix.CodTipoIncarico IN (611,682,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione = 14550	--Genera Controlli Gestione 
GROUP BY tix.IdIncarico
) inputFase1AR ON ti.IdIncarico = inputFase1AR.IdIncarico
LEFT JOIN L_WorkflowIncarico Fase1AR ON inputFase1AR.IdTransizione = Fase1AR.IdTransizione

LEFT JOIN (
			SELECT MIN(lwi.IdTransizione) IdTransizione, tix.IdIncarico
			FROM T_Incarico tix
			JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
			WHERE tix.CodCliente = 48
			AND tix.CodArea = 8
			AND tix.CodTipoIncarico IN (611,682,613)
			AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
			AND (
					( lwi.CodStatoWorkflowIncaricoDestinazione  = 14530	--Popolamento e Verifiche Effettuate
						AND lwi.DataTransizione >= '20201001'
						)
					OR (
					 lwi.CodStatoWorkflowIncaricoDestinazione  in(20978,20979, 8570) --In Gestione - Acquisita
					AND lwi.DataTransizione < '20201001'
					)
				)
			GROUP BY tix.IdIncarico
) inputFase2ar ON ti.IdIncarico = inputFase2AR.IdIncarico

left JOIN L_WorkflowIncarico Fase2AR ON inputFase2AR.IdTransizione = Fase2AR.IdTransizione


LEFT JOIN (
			SELECT MIN(lwi.IdTransizione) IdTransizione, tix.IdIncarico
			FROM T_Incarico tix
			JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
			WHERE tix.CodCliente = 48
			AND tix.CodArea = 8
			AND tix.CodTipoIncarico IN (611,682,613)
			AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
			AND (
				  ( lwi.CodStatoWorkflowIncaricoDestinazione = 8570 --In Gestione - Acquisita
					AND lwi.DataTransizione >= '20201001'
				  )
				  OR (
					 lwi.CodStatoWorkflowIncaricoDestinazione = 20977 --In Gestione - Trasferimento PayLoad
					AND lwi.DataTransizione < '20201001'
				  )
				)
			GROUP BY tix.IdIncarico

			--- RICONCILIAZIONE SPOT SETTEMBRE 2020 ---
			UNION 
			SELECT MAX(spot1.IdTransizione) IdTransizione, spot1.IdIncarico 
			FROM L_WorkflowIncarico spot1
			WHERE spot1.IdIncarico IN (15803144 
			,15265857
			,15636923
			,15754972
			,15754983
			,15754977
			,15786392
			,15794578
			,15803145
			,15887069
			,15830056
			,15907289
			,15907763
			)
			AND spot1.CodStatoWorkflowIncaricoDestinazione = 14275
			AND spot1.DataTransizione >= '20200901' AND spot1.DataTransizione < '20201001'
			GROUP BY spot1.IdIncarico
) inputFase2CA ON ti.IdIncarico = inputFase2CA.IdIncarico

left JOIN L_WorkflowIncarico Fase2CA ON inputFase2CA.IdTransizione = Fase2CA.IdTransizione

LEFT JOIN (
			SELECT max(lwi.IdTransizione) IdTransizione, tix.IdIncarico
			FROM T_Incarico tix
			JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
			WHERE tix.CodCliente = 48
			AND tix.CodArea = 8
			AND tix.CodTipoIncarico IN (611,682,613)
			AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
			AND tix.IdIncarico NOT IN (
			15212756
			,15633096
			,15636927
			,15641203
			,15547370
			,15821332
			,15850425
			,15881181
			,15887061
			,15908105
			)
			AND (
				 (
					lwi.CodStatoWorkflowIncaricoDestinazione = 20980 --Accordo Attivo
					AND lwi.DataTransizione >= '20201001'
				 )
				OR (lwi.CodStatoWorkflowIncaricoDestinazione = 14275 --Lavorazioni Effettuate
					AND lwi.DataTransizione < '20201001'
					)
				)
			GROUP BY tix.IdIncarico
			
			-----------RICONCILIAZIONE SPOT SETTEMBRE 2020--------------
			UNION 
			SELECT spot2.IdTransizione, spot2.IdIncarico--, spot2.DataTransizione
			FROM L_WorkflowIncarico spot2
			WHERE spot2.IdIncarico IN (15212756
			,15633096
			,15636927
			,15641203
			)
			AND spot2.CodStatoWorkflowIncaricoDestinazione = 14276
			AND spot2.DataTransizione < '20200901'
			UNION 
			SELECT spot3.IdTransizione, spot3.IdIncarico--, spot3.DataTransizione
			FROM L_WorkflowIncarico spot3
			WHERE spot3.IdIncarico IN (15547370
			,15821332
			,15850425
			,15881181
			,15887061
			,15908105
			
			)
			AND spot3.CodStatoWorkflowIncaricoDestinazione = 14276
			AND spot3.DataTransizione < '20201001'
			
			----------- FINE RICONCILIAZIONE SPOT -------------------
			
) inputFase3 ON ti.IdIncarico = inputFase3.IdIncarico

LEFT JOIN L_WorkflowIncarico Fase3 ON inputFase3.IdTransizione = Fase3.IdTransizione

LEFT JOIN (
SELECT min(lwi.IdTransizione) IdTransizione, tix.IdIncarico, COUNT(lwi.IdTransizione) N
 FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodArea = 8
AND tix.CodCliente = 48
AND tix.CodTipoIncarico IN (611,682,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione IN 
(
15468	--Mancata attivazione accordo
,8611	--In attesa di riscontro banca
,14332	--Documentale
,14334	--Errore tecnico
)
AND lwi.DataTransizione < '20201001'


group by tix.idincarico
UNION
SELECT max(lwi.IdTransizione) IdTransizione, tix.IdIncarico, COUNT(lmt.IdMotivoTransizione) N
 FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
JOIN L_MotivoTransizione lmt ON lwi.IdTransizione = lmt.IdTransizione
AND tix.IdIncarico = lmt.IdIncarico
WHERE tix.CodArea = 8
AND tix.CodCliente = 48
AND tix.CodTipoIncarico IN (611,682,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione = 6560 --Sospesa - Regolarizzata
AND lmt.CodMotivoTransizione IN ( 124	--Documentale Conto Corrente
		     ,125	--Documentale Dossier
		     ,126	--Documentale Carta di Credito
		     ,127	--Documentale Switch
		     ,128	--Errore Tecnico
		     ,129	--Mancata Attivazione Accordo
			)

AND lwi.DataTransizione >= '20201001'
--AND tix.IdIncarico = 15953355 
group by tix.idincarico, MONTH(lwi.DataTransizione)

) inputFase4 ON inputFase4.IdIncarico = ti.IdIncarico


LEFT JOIN L_WorkflowIncarico Fase4 ON inputFase4.IdTransizione = Fase4.IdTransizione

LEFT JOIN S_Operatore OperatoreFase1 ON Fase1.IdOperatore = OperatoreFase1.IdOperatore
LEFT JOIN S_Operatore OperatoreFase1AR ON Fase1AR.IdOperatore = OperatoreFase1AR.IdOperatore
LEFT JOIN S_Operatore OperatoreFase2AR ON Fase2AR.IdOperatore = OperatoreFase2AR.IdOperatore
LEFT JOIN S_Operatore OperatoreFase2CA ON Fase2CA.IdOperatore = OperatoreFase2CA.IdOperatore
LEFT JOIN S_Operatore OperatoreFase3 ON Fase3.IdOperatore = OperatoreFase3.IdOperatore
LEFT JOIN S_Operatore OperatoreFase4 ON Fase4.IdOperatore = OperatoreFase4.IdOperatore

LEFT JOIN T_R_Incarico_Operatore triop1 ON ti.IdIncarico = triop1.IdIncarico
AND triop1.CodRuoloOperatoreIncarico = 1
LEFT JOIN S_Operatore so1 ON triop1.IdOperatore = so1.IdOperatore

LEFT JOIN T_R_Incarico_Operatore triop2 ON ti.IdIncarico = triop2.IdIncarico
AND triop2.CodRuoloOperatoreIncarico = 2
LEFT JOIN S_Operatore so2 ON triop2.IdOperatore = so2.IdOperatore

LEFT JOIN T_R_Incarico_Operatore triop3 ON ti.IdIncarico = triop3.IdIncarico
AND triop3.CodRuoloOperatoreIncarico = 3
LEFT JOIN s_operatore so3 ON triop3.IdOperatore = so3.IdOperatore

LEFT JOIN GiaClienti on ti.IdIncarico = GiaClienti.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.DataCreazione >= '20200615'
AND ti.CodTipoIncarico IN (	359 --Contratti Consulenza CheBanca

									,564	--Trasferimento servizi pagamento FEA
									,593 --predisposizioni - slegate dal cartaceo

									,611 --Nuovo Processo CB FEA
									,613 --Nuovo Processo CB Cartaceo
									,682 --Switch Conto FEA
									)

--AND NonStandard.IdIncarico IS NULL

--AND ti.IdIncarico = 15887061
  


UNION ALL

SELECT 	DISTINCT
v.IdIncarico

,v.CodTipoIncarico
,v.Descrizione TipoIncarico
,v.DataCreazione	
,tp.PartitaIva ChiaveIncarico	
,v.DataUltimaTransizione
,v.StatoMOL

,CASE when tp.ChiaveCliente IS NULL OR tp.ChiaveCliente = '' OR tp.ChiaveCliente = '.' 
	THEN tp.PartitaIva ELSE tp.ChiaveCliente 
	END  NDG
,CASE when tp.Cognome is null or tp.Cognome = ' '
	THEN tp.RagioneSociale
	ELSE tp.Cognome 

	END Cognome

,tp.Nome
,0 FlagCC_Censito
,0 FlagCC_DaCensire
,0 FlagDossier_Censito
,0 FlagDossier_DaCensire
,0 FlagKK_Censita
,0 FlagKK_DaCensire
,0 FlagSwitch_Censito
,0 FlagSwitch_DaCensire

, 0  Fase1
,NULL LavorazioneFase1
,NULL IdOperatoreFase1
,NULL OperatoreFase1

, 0  Fase1AR
,nuLL  LavorazioneFase1AR
,NULL IdOperatoreFase1AR
,NULL  OperatoreFase1AR

, 0 Fase2AR
,NULL LavorazioneFase2AR
,NULL IdOperatoreFase2AR
,NULL OperatoreFase2AR

,0 Fase2CA
,NULL LavorazioneFase2CA
,NULL IdOperatoreFase2CA
,NULL OperatoreFase2CA

, 0  Fase3
,NULL LavorazioneFase3
,NULL IdOperatoreFase3
,NULL OperatoreFase3

, 0  Fase4
,NULL LavorazioneFase4
,NULL IdOperatoreFase4
,NULL OperatoreFase4

, 0 FlagConsulenza
, 0 FlagTSP
, 0 FlagGenerazioneKit
,0 AS FlagAggiornamentoDocumentale
,NULL AS TipoPackAggiornato
,NULL AS PrezzoPack

,v.[SB-LavorazioneCompleta]
,v.[SB-SospesaOggettoSociale]
,v.[SB-SospesaCervedNegativa]
,v.[SB-Fil-LavorazioneCompleta]
,v.[SB-Fil-SospesaOggettoSociale]
,v.[SB-Fil-SospesaCervedNegativa]

,v.IdOperatoreGestore
,v.Etichetta OperatoreGestore
,NULL IdOpertatoreGestoreSupporto
,NULL OperatoreGestoreSupporto
,triop.IdOperatore IdOperatoreGestore4eyes
,so.Etichetta OperatoreGestore4Eyes
FROM rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_LogicaStatiWorkflow v
LEFT JOIN T_R_Incarico_Persona trip ON v.IdIncarico = trip.IdIncarico
AND trip.Progressivo = 1
LEFT JOIN T_Persona tp on trip.IdPersona = tp.IdPersona
LEFT JOIN T_R_Incarico_Operatore triop ON v.IdIncarico = triop.IdIncarico
AND triop.CodRuoloOperatoreIncarico = 3
LEFT JOIN S_Operatore so ON triop.IdOperatore = so.IdOperatore
WHERE v.DataCreazione >= '20200615'


/*** AGGIORNAMENTO DOCUMENTALE ****/
UNION ALL

SELECT ti.IdIncarico

,ti.CodTipoIncarico
,D_TipoIncarico.Descrizione TipoIncarico
,CONVERT(DATETIME,DataLavorazione.Testo,103) DataCreazione
,NULL ChiaveIncarico	
,CONVERT(DATETIME,DataLavorazione.Testo,103) DataUltimaTransizione
,'Gestita - Pack Aggiornato' StatoMOL

,NULL  NDG
,NULL Cognome

,NULL Nome
,0 FlagCC_Censito
,0 FlagCC_DaCensire
,0 FlagDossier_Censito
,0 FlagDossier_DaCensire
,0 FlagKK_Censita
,0 FlagKK_DaCensire
,0 FlagSwitch_Censito
,0 FlagSwitch_DaCensire

, 0  Fase1
,NULL LavorazioneFase1
,NULL IdOperatoreFase1
,NULL OperatoreFase1

, 0  Fase1AR
,nuLL  LavorazioneFase1AR
,NULL IdOperatoreFase1AR
,NULL  OperatoreFase1AR

, 0 Fase2AR
,NULL LavorazioneFase2AR
,NULL IdOperatoreFase2AR
,NULL OperatoreFase2AR

,0 Fase2CA
,NULL LavorazioneFase2CA
,NULL IdOperatoreFase2CA
,NULL OperatoreFase2CA

, 0  Fase3
,NULL LavorazioneFase3
,NULL IdOperatoreFase3
,NULL OperatoreFase3

, 0  Fase4
,NULL LavorazioneFase4
,NULL IdOperatoreFase4
,NULL OperatoreFase4

, 0 FlagConsulenza
, 0 FlagTSP
, 0 FlagGenerazioneKit
,1 AS FlagAggiornamentoDocumentale
,tipoProdotto.Testo TipoPackAggiornato
,CASE tipoProdotto.Testo
when 'Retail - Kit Conto Yellow' then 472.5
when 'Retail - Kit Conto Digital' then 441
when 'Retail - Kit Conto Tascabile' then 378
when 'Retail - Kit Conto Deposito' then 378
when 'Retail - Kit Servizi di Investimento Conto Yellow' then 346.5
when 'Small Business - Pack Fuori Sede Conto Corrente' then 451.5
when 'Small Business - Pack Fuori Sede Carta di Debito' then 346.5
when 'Small Business - Pack Fuori Sede Deposito Titoli' then 378
when 'Small Business - Pack Fuori Sede Modulo Apertura servizio CBI Passivo' then 378
when 'Retail - Kit Conto Premier' then 472.5
when 'Retail - Kit Servizi di Investimento Conto Premier' then 346.5
when 'Small Business - Pack Fuori Sede Modulo Apertura servizio CBI Attivo' then 336

END AS PrezzoPack

,0 [SB-LavorazioneCompleta]
,0 [SB-SospesaOggettoSociale]
,0 [SB-SospesaCervedNegativa]
,0 [SB-Fil-LavorazioneCompleta]
,0 [SB-Fil-SospesaOggettoSociale]
,0 [SB-Fil-SospesaCervedNegativa]

,NULL IdOperatoreGestore
,NULL OperatoreGestore
,NULL IdOpertatoreGestoreSupporto
,NULL OperatoreGestoreSupporto
,NULL IdOperatoreGestore4eyes
,NULL OperatoreGestore4Eyes
FROM T_Incarico ti
JOIN D_TipoIncarico ON ti.CodTipoIncarico = D_TipoIncarico.Codice 
LEFT JOIN T_DatoAggiuntivo tipoProdotto ON ti.IdIncarico = tipoProdotto.IdIncarico
AND tipoProdotto.CodTipoDatoAggiuntivo = 2064 
AND tipoProdotto.FlagAttivo = 1
LEFT JOIN T_DatoAggiuntivo DataLavorazione ON ti.IdIncarico = DataLavorazione.IdIncarico
AND DataLavorazione.CodTipoDatoAggiuntivo = 2065
AND DataLavorazione.FlagAttivo = 1

WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.CodTipoIncarico = 408 --Aggiornamento Documentale CB

GO