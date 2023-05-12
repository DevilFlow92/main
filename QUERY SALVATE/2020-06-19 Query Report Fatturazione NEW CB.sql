USE CLC
GO

--SELECT * FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
--WHERE Fase4 = 1
--AND CodTipoIncarico = 613

ALTER VIEW rs.v_CESAM_CB_Fatturazione_Processo_2020 AS 

/*
Author: Chessa S. 
Fiori L

Utilizzata nel nuovo report fatturazione

--Dossier e carta di credito: guardo i controlli
--web collaboration, gestione kit persone fisiche, Servizio TSP: conto il singolo incarico come pezzo

--small business: utilizzo vista rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_LogicaStatiWorkflow


/*
mi interessano le fasi da mappare con stati wf 
FASE 1 : Nuova Creata
FASE 2 AR: Gestione Acquisita
FASE 2 CA: In attesa gestione portale BO
FASE 3 CA: Gestita - Lavorazioni Effettuate
FASE 4 (ANOMALIE): sospesi --> utilizziamo per stato di entrata considerando
la prima transizione avvenuta in qualunque stato sospeso.

*/

*/
WITH 
/*** INCARICHI FEA CREATI DA OPERATORE - LAVORAZIONI NON STANDARD ***/
NonStandard as (
SELECT DISTINCT
	T_Incarico.IdIncarico

FROM T_Incarico
JOIN L_WorkflowIncarico
	ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
	AND CodStatoWorkflowIncaricoDestinazione = 6500
	AND IdOperatore <> 21
WHERE CodCliente = 48
AND CodTipoIncarico = 611
AND CodArea = 8
AND DataCreazione >= '20200615'
)
/********************************************************************/

SELECT 
ti.IdIncarico
,ti.CodTipoIncarico
,d.TipoIncarico

,ti.DataCreazione
,ti.DataUltimaTransizione
,d.StatoWorkflowIncarico

,CASE when cc.CodGiudizioControllo = 2 OR ti.CodTipoIncarico = 611 THEN 1 ELSE 0 END FlagCC_Censito
,CASE when cc.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagCC_DaCensire
,CASE when Dossier.CodGiudizioControllo = 2 THEN 1 ELSE 0 END FlagDossier_Censito
,CASE WHEN Dossier.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagDossier_DaCensire
,CASE WHEN kk.CodGiudizioControllo = 2 then 1 else 0 END FlagKK_Censita
,CASE WHEN kk.CodGiudizioControllo = 4 THEN 1 ELSE 0 END FlagKK_DaCensire

,CASE when fase1.IdTransizione IS not NULL THEN 1 else 0 END Fase1
,Fase1.DataTransizione LavorazioneFase1
,Fase1.IdOperatore IdOperatoreFase1
,OperatoreFase1.Etichetta OperatoreFase1

,CASE WHEN Fase2AR.IdTransizione is not NULL then 1 ELSE 0 END Fase2AR
,Fase2AR.DataTransizione LavorazioneFase2AR
,Fase2AR.IdOperatore IdOperatoreFase2AR
,OperatoreFase2AR.Etichetta OperatoreFase2AR

,CASE when Fase2CA.IdTransizione is NOT NULL then 1 ELSE 0 END Fase2CA
,Fase2CA.DataTransizione LavorazioneFase2CA
,Fase2CA.IdOperatore IdOperatoreFase2CA
,OperatoreFase2CA.Etichetta OperatoreFase2CA

,CASE WHEN Fase3.IdTransizione IS NOT NULL THEN 1 ELSE 0 END Fase3
,Fase3.DataTransizione LavorazioneFase3
,Fase3.IdOperatore IdOperatoreFase3
,OperatoreFase3.Etichetta OperatoreFase3

,CASE WHEN Fase4.IdTransizione is NOT NULL THEN 1
--inputFase4.N 
ELSE 0 END Fase4
,Fase4.DataTransizione LavorazioneFase4
,Fase4.IdOperatore IdOperatoreFase4
,OperatoreFase4.Etichetta OperatoreFase4

,CASE WHEN ti.CodTipoIncarico = 359 THEN 1 ELSE 0 END FlagConsulenza
,CASE when ti.CodTipoIncarico = 564 THEN 1 ELSE 0 END FlagTSP
,CASE WHEN ti.CodTipoIncarico = 593 then 1 else 0 END FlagGenerazioneKit
,0 AS FlagAggiornamentoDocumentale

,0 [SB-LavorazioneCompleta]
,0 [SB-SospesaOggettoSociale]
,0 [SB-SospesaCervedNegativa]
,0 [SB-Fil-LavorazioneCompleta]
,0 [SB-Fil-SospesaOggettoSociale]
,0 [SB-Fil-SospesaCervedNegativa]

,ISNULL(so1.Etichetta,so2.Etichetta) OperatoreGestore

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
LEFT JOIN T_MacroControllo tmc ON ti.IdIncarico = tmc.IdIncarico
AND IdTipoMacroControllo = 3205

LEFT JOIN T_Controllo cc ON tmc.IdMacroControllo = cc.IdMacroControllo
AND cc.IdTipoControllo = 8327	--Conto Corrente censito
LEFT JOIN T_Controllo Dossier ON tmc.IdMacroControllo = Dossier.IdControllo
AND Dossier.IdControllo = 8328	--Dossier censito
LEFT JOIN T_Controllo kk ON tmc.IdMacroControllo = kk.IdMacroControllo
AND kk.IdTipoControllo = 8329	--Carta di Credito censita

left JOIN (
SELECT MAX(lwi.IdTransizione) IdTransizione, tix.IdIncarico
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodCliente = 48
AND tix.CodArea = 8
AND lwi.CodStatoWorkflowIncaricoPartenza is NULL
AND lwi.CodStatoWorkflowIncaricoDestinazione = 6500 --Nuova - Creata

GROUP BY tix.IdIncarico
) inputFase1 ON ti.IdIncarico = inputFase1.IdIncarico



LEFT JOIN L_WorkflowIncarico Fase1 ON inputFase1.IdTransizione = Fase1.IdTransizione

LEFT JOIN (
SELECT MIN(lwi.IdTransizione) IdTransizione, tix.IdIncarico
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodCliente = 48
AND tix.CodArea = 8
AND tix.CodTipoIncarico IN (611,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione  in(20978,20979, 8570) --In Gestione - Acquisita
GROUP BY tix.IdIncarico
) inputFase2ar ON ti.IdIncarico = inputFase2AR.IdIncarico

left JOIN L_WorkflowIncarico Fase2AR ON inputFase2AR.IdTransizione = Fase2AR.IdTransizione


LEFT JOIN (
SELECT MIN(lwi.IdTransizione) IdTransizione, tix.IdIncarico
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodCliente = 48
AND tix.CodArea = 8
AND tix.CodTipoIncarico IN (611,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione = 20986 --In attesa gestione portale BO 
GROUP BY tix.IdIncarico
) inputFase2CA ON ti.IdIncarico = inputFase2CA.IdIncarico

left JOIN L_WorkflowIncarico Fase2CA ON inputFase2CA.IdTransizione = Fase2CA.IdTransizione

LEFT JOIN (
SELECT MIN(lwi.IdTransizione) IdTransizione, tix.IdIncarico
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodCliente = 48
AND tix.CodArea = 8
AND tix.CodTipoIncarico IN (611,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione = 14275 --Gest Lavorazioni Effettuate

GROUP BY tix.IdIncarico
) inputFase3 ON ti.IdIncarico = inputFase3.IdIncarico

LEFT JOIN L_WorkflowIncarico Fase3 ON inputFase3.IdTransizione = Fase3.IdTransizione



LEFT JOIN (
SELECT MAX(lwi.IdTransizione) IdTransizione, tix.IdIncarico, COUNT(lwi.IdTransizione) N
 FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodArea = 8
AND tix.CodCliente = 48
AND tix.CodTipoIncarico IN (611,613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15468	--Mancata attivazione accordo
--,8611	--In attesa di riscontro banca
,14332	--Documentale
,14334	--Errore tecnico

)


group by tix.idincarico

) inputFase4 ON inputFase4.IdIncarico = ti.IdIncarico


LEFT JOIN L_WorkflowIncarico Fase4 ON inputFase4.IdTransizione = Fase4.IdTransizione

LEFT JOIN S_Operatore OperatoreFase1 ON Fase1.IdOperatore = OperatoreFase1.IdOperatore
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

LEFT JOIN NonStandard on ti.IdIncarico = NonStandard.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.DataCreazione >= '20200615'
AND ti.CodTipoIncarico IN (331
									,334 --Solo Dossier fea
									,335 --conto corrente fea

									,359 --Contratti Consulenza CheBanca

									,564	--Trasferimento servizi pagamento FEA
									,593 --predisposizioni - slegate dal cartaceo

									,611 --Nuovo Processo CB FEA
									,613 --Nuovo Processo CB Cartaceo
									)

AND NonStandard.IdIncarico IS NULL

--AND ti.IdIncarico = 15202354
UNION ALL

SELECT 	DISTINCT
IdIncarico
--,issubincarico
--,IdSubincarico
,CodTipoIncarico
,Descrizione TipoIncarico
,DataCreazione		
,DataUltimaTransizione
,StatoMOL

,0 FlagCC_Censito
,0 FlagCC_DaCensire
,0 FlagDossier_Censito
,0 FlagDossier_DaCensire
,0 FlagKK_Censita
,0 FlagKK_DaCensire

, 0  Fase1
,NULL LavorazioneFase1
,NULL IdOperatoreFase1
,NULL OperatoreFase1

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

,[SB-LavorazioneCompleta]
,[SB-SospesaOggettoSociale]
,[SB-SospesaCervedNegativa]
,[SB-Fil-LavorazioneCompleta]
,[SB-Fil-SospesaOggettoSociale]
,[SB-Fil-SospesaCervedNegativa]

,Etichetta OperatoreGestore
	
FROM rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_LogicaStatiWorkflow
WHERE DataCreazione >= '20200615'

GO