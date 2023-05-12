USE clc

GO


ALTER VIEW rs.v_CESAM_CB_PraticheLavorateOperatore_Fasi AS

/* Author: Lorenzo Fiori
Utilizzata nel report: CB - Pratirche Lavorate per Operatore 2.0

*/


WITH 
lavorazioni AS (
select 1 CodTipoLavorazione, '1 - PRIMA FASE - ARRIVO E LAVORAZIONE DELLA DOCUMENTAZIONE - A.	Attività relative al giro logistico' TipoLavorazione, 2.58 Corrispettivo union all
select 2 CodTipoLavorazione, '1 - PRIMA FASE - ARRIVO E LAVORAZIONE DELLA DOCUMENTAZIONE - B.	Ricezione e lavorazione documentazione digitale' TipoLavorazione, 1.68 Corrispettivo union all
select 3 CodTipoLavorazione, '2 A- SECONDA FASE - CONTROLLO FORMALE  E WIZARD ( Conto Corrente Censito)' TipoLavorazione, 5.15 Corrispettivo union all
select 4 CodTipoLavorazione, '2 B- SECONDA FASE - CONTROLLO FORMALE  E WIZARD ( Conto Corrente non Censito)' TipoLavorazione, 11.55 Corrispettivo union all
select 5 CodTipoLavorazione, 'Integrazione Censita ' TipoLavorazione, 1.41 Corrispettivo union all
select 6 CodTipoLavorazione, 'Integrazione NON Censita ' TipoLavorazione, 3.44 Corrispettivo union all
select 7 CodTipoLavorazione, '3 A - TERZA FASE: CONTROLLO DI SECONDO LIVELLO E ATTIVAZIONE ACCORDO (conto e strumenti accessori es. carta di credito, dossier e assegni)' TipoLavorazione, 5.15 Corrispettivo union all
select 8 CodTipoLavorazione, '4 – QUARTA FASE: GESTIONE ANOMALIE CONTRATTUALI E DOCUMENTALI' TipoLavorazione, 5.25 Corrispettivo union all
select 9 CodTipoLavorazione, 'Web Collaboration' TipoLavorazione, 3.58 Corrispettivo union all
select 10 CodTipoLavorazione, 'Portabilità' TipoLavorazione, 9.58 Corrispettivo union all
select 11 CodTipoLavorazione, 'Predisposizione Kit (Gestione)' TipoLavorazione, 4.47 Corrispettivo union ALL
SELECT 12 CodTipoLavorazione, 'Predisposizione Kit (4 Eyes)' TipoLavorazione, 0 Corrispettivo UNION ALL
select 13 CodTipoLavorazione, 'Predisposizione SmallBusiness (Lavorazione Completa)' TipoLavorazione, 39.85 Corrispettivo union all
select 14 CodTipoLavorazione, 'Predisposizione SmallBusiness (KO Oggetto Sociale)' TipoLavorazione, 0 Corrispettivo union all
select 15 CodTipoLavorazione, 'Predisposizione SmallBusiness (KO Cerved Negativa)' TipoLavorazione, 15.33 Corrispettivo union all
select 16 CodTipoLavorazione, 'Predisposizione SmallBusiness Fil. (Lavorazione Completa)' TipoLavorazione, 39.85 Corrispettivo union all
select 17 CodTipoLavorazione, 'Predisposizione SmallBusiness Fil. (KO Oggetto Sociale)' TipoLavorazione, 0 Corrispettivo union all
select 18 CodTipoLavorazione, 'Predisposizione SmallBusiness Fil. (KO Cerved Negativa)' TipoLavorazione, 15.33 Corrispettivo  UNION ALL
SELECT 19 CodTipoLavorazione, 'Predisposizione SmallBusiness (4 eyes)' TipoLavorazione, 0 Corrispettivo 


)
, TML_LAV_SEDE AS (
SELECT 1 CodTipoLavorazione, 'MI' EtichettaSedeLavorazione, 1.8 TML union all
SELECT 2 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 1.95 TML union all
SELECT 1 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 1 TML union all
--SELECT 2 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 1.95 TML union all
SELECT 3 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 1.11 TML union all
SELECT 3 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 4 TML union all
SELECT 4 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 3.1 TML union all
SELECT 4 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 14.9 TML union all
SELECT 5 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 1.61 TML union all
SELECT 5 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 1.61 TML union all
SELECT 6 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 2.93 TML union all
SELECT 6 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 2.93 TML union all
SELECT 7 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 5.11 TML union all
SELECT 7 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5.11 TML union all
SELECT 8 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 11 TML union all
SELECT 8 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 11 TML union all
SELECT 9 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 4.5 TML union all
SELECT 9 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 4.5 TML union all
SELECT 10 CodTipoLavorazione, 'RO' EtichettaSedeLavorazione, 10 TML union all
SELECT 10 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 10 TML union all
SELECT 11 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML union ALL
SELECT 12 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 5 TML UNION all
SELECT 13 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 46 TML union all
SELECT 14 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 46 TML union all
SELECT 15 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 46 TML union all
SELECT 16 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 46 TML union all
SELECT 17 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 46 TML union all
SELECT 18 CodTipoLavorazione, 'CA' EtichettaSedeLavorazione, 46 TML UNION ALL
SELECT 19 CodTIpoLavorazione, 'CA' EtichettaSedeLavorazione, 10 TML
),

timesheet AS (

SELECT DISTINCT S_Operatore.IdOperatore
, S_Operatore.Etichetta
, S_Operatore.CodSede
, CASE WHEN CodSede IN (10, 3) THEN 'MI' 
	WHEN CodSede = 1 THEN 'CA' 
	WHEN codsede IN (2, 11) 
	THEN 'RO' 
END AS EtichettaSedeLavorazione, 
rs.S_Data.Data
, 8 AS OreDaTS
, codprofiloaccesso
FROM S_Operatore 
INNER JOIN   rs.S_Data ON rs.S_Data.FlagFestivo = 0	 
	--AND CodSede = 1
	AND Data BETWEEN '2020-06-15' AND GETDATE()

WHERE  S_Operatore.FlagAttivo = 1
)
,
estrazioni AS (

--Fase 1 nuovo processo: Lavorazioni 1 e 2
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase1 AS DATE) DataLavorazione

,IdOperatoreFase1 IdOperatoreLavorazione
, OperatoreFase1 OperatoreLavorazione

,CASE WHEN CodTipoIncarico = 613 THEN 1
	ELSE 2 END CodTipoLavorazione --Fase 1
,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase1 = 1
AND CodTipoIncarico IN (611,613)

UNION ALL
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase1 AS DATE) DataLavorazione

,IdOperatoreFase1AR IdOperatoreLavorazione
, OperatoreFase1AR OperatoreLavorazione

,CASE WHEN CodTipoIncarico = 613 THEN 1
	ELSE 2 END CodTipoLavorazione --Fase 1
,1 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase1AR = 1
AND CodTipoIncarico IN (611,613)

UNION ALL

--Fase 2 nuovo processo: lavorazioni 3,4,5,6 (Cagliari + Romania)
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2AR AS DATE) DataLavorazione

,IdOperatoreFase2AR IdOperatoreLavorazione
, OperatoreFase2AR OperatoreLavorazione

,CASE WHEN FlagCC_Censito = 1 THEN 3 
 WHEN FlagCC_DaCensire = 1 then 4 END CodTipoLavorazione --Fase2 ar
,1 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase2AR = 1
AND CodTipoIncarico IN (611,613)
AND (FlagCC_Censito = 1 OR FlagCC_DaCensire = 1)
UNION ALL
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2AR AS DATE) DataLavorazione

,IdOperatoreFase2AR IdOperatoreLavorazione
, OperatoreFase2AR OperatoreLavorazione

,CASE WHEN FlagDossier_Censito = 1 OR FlagKK_Censita = 1 THEN 5 
WHEN FlagDossier_DaCensire = 1 OR FlagKK_DaCensire = 1 THEN 6 
END CodTipoLavorazione --Fase2 ar
,1 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase2AR = 1
AND CodTipoIncarico IN (611,613)
AND (FlagDossier_Censito = 1 
OR FlagDossier_DaCensire =1
OR FlagKK_Censita = 1
OR FlagKK_DaCensire = 1

)
UNION ALL

SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione

, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2CA AS DATE) DataLavorazione

,IdOperatoreFase2CA IdOperatoreLavorazione
, OperatoreFase2CA OperatoreLavorazione

,CASE WHEN FlagCC_Censito = 1 THEN 3 
 WHEN FlagCC_DaCensire = 1 then 4 END CodTipoLavorazione 	

,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase2CA = 1
AND CodTipoIncarico IN (611,613)
AND (FlagCC_Censito = 1 OR FlagCC_DaCensire = 1)
UNION ALL
SELECT DISTINCT IdIncarico
,CAST(DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase2CA AS DATE) DataLavorazione

,IdOperatoreFase2CA IdOperatoreLavorazione
, OperatoreFase2CA OperatoreLavorazione

,CASE WHEN FlagDossier_Censito = 1 OR FlagKK_Censita = 1 THEN 5 
WHEN FlagDossier_DaCensire = 1 OR FlagKK_DaCensire = 1 THEN 6 
END CodTipoLavorazione --Fase2 ar
,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase2CA = 1
AND CodTipoIncarico IN (611,613)
AND (FlagDossier_Censito = 1 
OR FlagDossier_DaCensire =1
OR FlagKK_Censita = 1
OR FlagKK_DaCensire = 1

)

UNION ALL
--Fase 3 nuovo processo
SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase3 AS DATE) DataLavorazione

,IdOperatoreFase3 IdOperatoreLavorazione
, OperatoreFase3 OperatoreLavorazione

,7 CodTipoLavorazione --Fase3 

,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase3 = 1
AND CodTipoIncarico IN (611,613)
UNION ALL

SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(LavorazioneFase4 AS DATE) DataLavorazione
,IdOperatoreFase4 IdOperatoreLavorazione
, OperatoreFase4 OperatoreLavorazione
,8 CodTipoLavorazione --Fase4
,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase4 = 1
AND CodTipoIncarico IN (611,613)

UNION ALL


SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(DataCreazione AS DATE) DataLavorazione
,IdOperatoreGestore
,OperatoreGestore OperatoreLavorazione
,CASE 
WHEN FlagConsulenza = 1 THEN 9 --Consulenza
WHEN FlagTSP = 1 THEN 10 --Trasferimento Servizi Pagamento
WHEN FlagGenerazioneKit = 1 THEN 11 --Generazione Kit Persone Fisiche
WHEN [SB-LavorazioneCompleta] = 1 THEN 13 --SmallBusiness OK
WHEN [SB-SospesaOggettoSociale] = 1 THEN 14 --SmallBusiness KO Oggetto Sociale
WHEN [SB-SospesaCervedNegativa] = 1 THEN 15 --SmallBusiness KO Cerved Negativa
WHEN [SB-Fil-LavorazioneCompleta] = 1 THEN 16 --SmallBusiness Fil OK
WHEN [SB-Fil-SospesaOggettoSociale] = 1 THEN 17 --SmallBusiness Fil KO Oggetto Sociale
WHEN [SB-Fil-SospesaCervedNegativa] = 1 THEN 18 --SmallBusiness Fil KO Cerved Negativa

END CodTipoLavorazione 

,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE CodTipoIncarico NOT IN (611,613)
AND FlagAggiornamentoDocumentale = 0
AND IdOperatoreGestore IS NOT NULL


UNION ALL


SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(DataCreazione AS DATE) DataLavorazione
,IdOpertatoreGestoreSupporto IdOperatoreGestore
,OperatoreGestoreSupporto OperatoreLavorazione

,CASE 
WHEN FlagConsulenza = 1 THEN 9 --Consulenza
WHEN FlagTSP = 1 THEN 10 --Trasferimento Servizi Pagamento
WHEN FlagGenerazioneKit = 1 THEN 11 --Generazione Kit Persone Fisiche
WHEN [SB-LavorazioneCompleta] = 1 THEN 12 --SmallBusiness OK
WHEN [SB-SospesaOggettoSociale] = 1 THEN 13 --SmallBusiness KO Oggetto Sociale
WHEN [SB-SospesaCervedNegativa] = 1 THEN 14 --SmallBusiness KO Cerved Negativa
WHEN [SB-Fil-LavorazioneCompleta] = 1 THEN 15 --SmallBusiness Fil OK
WHEN [SB-Fil-SospesaOggettoSociale] = 1 THEN 16 --SmallBusiness Fil KO Oggetto Sociale
WHEN [SB-Fil-SospesaCervedNegativa] = 1 THEN 17 --SmallBusiness Fil KO Cerved Negativa

END CodTipoLavorazione 
,1 AS FlagRO

FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE CodTipoIncarico NOT IN (611,613)
AND FlagAggiornamentoDocumentale = 0
AND IdOpertatoreGestoreSupporto IS NOT NULL

UNION ALL

SELECT DISTINCT IdIncarico
,CAST( DataCreazione AS DATE) DataCreazione
, CodTipoIncarico,TipoIncarico,ChiaveIncarico,NDG,Cognome,Nome

,CAST(DataCreazione AS DATE) DataLavorazione
,IdOperatoreGestore4Eyes IdOperatoreGestore
,OperatoreGestore4Eyes OperatoreLavorazione
,CASE 
WHEN FlagGenerazioneKit = 1 THEN 12 --Generazione Kit 4 eyes
WHEN [SB-LavorazioneCompleta] = 1 THEN 19 --SmallBusiness 4 Eyes
WHEN [SB-SospesaOggettoSociale] = 1 THEN 19 
WHEN [SB-SospesaCervedNegativa] = 1 THEN 19 
WHEN [SB-Fil-LavorazioneCompleta] = 1 THEN 19 
WHEN [SB-Fil-SospesaOggettoSociale] = 1 THEN 19 
WHEN [SB-Fil-SospesaCervedNegativa] = 1 THEN 19 

END CodTipoLavorazione 
,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE CodTipoIncarico  IN (474	--Generazione kit Small Business
							,523	--Generazione Kit Small Business Filiali
							,593	--Generazione kit Persone Fisiche
						)
AND FlagAggiornamentoDocumentale = 0
AND IdOperatoreGestore4Eyes IS NOT NULL

union ALL

SELECT DISTINCT v.IdIncarico
,CAST( v.DataCreazione AS DATE) DataCreazione
,v.CodTipoIncarico,v.TipoIncarico,v.ChiaveIncarico,v.NDG,v.Cognome,v.Nome

,CAST(v.DataCreazione AS DATE) DataLavorazione
,so.IdOperatore IdOperatoreGestore
,so.Etichetta OperatoreLavorazione
,CASE 
WHEN FlagConsulenza = 1 THEN 9 --Consulenza
WHEN FlagTSP = 1 THEN 10 --Trasferimento Servizi Pagamento
WHEN FlagGenerazioneKit = 1 THEN 11 --Generazione Kit Persone Fisiche
WHEN [SB-LavorazioneCompleta] = 1 THEN 12 --SmallBusiness OK
WHEN [SB-SospesaOggettoSociale] = 1 THEN 13 --SmallBusiness KO Oggetto Sociale
WHEN [SB-SospesaCervedNegativa] = 1 THEN 14 --SmallBusiness KO Cerved Negativa
WHEN [SB-Fil-LavorazioneCompleta] = 1 THEN 15 --SmallBusiness Fil OK
WHEN [SB-Fil-SospesaOggettoSociale] = 1 THEN 16 --SmallBusiness Fil KO Oggetto Sociale
WHEN [SB-Fil-SospesaCervedNegativa] = 1 THEN 17 --SmallBusiness Fil KO Cerved Negativa

END CodTipoLavorazione 

,0 AS FlagRO
FROM rs.v_CESAM_CB_Fatturazione_Processo_2020 v
 JOIN (SELECT MAX(idtransizione) IdTransizione, T_Incarico.IdIncarico
			FROM  L_WorkflowIncarico 
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48
			AND CodTipoIncarico IN(359,474,523,564,593)
			AND IdOperatore NOT IN (21,12520,12667) --escludo bot/utenze di sistema
			GROUP BY T_Incarico.IdIncarico
			) wf ON wf.IdIncarico = v.IdIncarico
JOIN L_WorkflowIncarico ON wf.IdTransizione = L_WorkflowIncarico.IdTransizione
JOIN S_Operatore so ON L_WorkflowIncarico.IdOperatore = so.IdOperatore
WHERE CodTipoIncarico NOT IN (611,613)
AND FlagAggiornamentoDocumentale = 0
AND IdOperatoreGestore IS  NULL
AND IdOpertatoreGestoreSupporto IS  NULL
AND v.IdOperatoreGestore4Eyes IS NULL
)
,dataset AS (
SELECT ESTRAZIONI.IdIncarico
	  ,ESTRAZIONI.DataCreazione
	  ,ESTRAZIONI.CodTipoIncarico
	  ,ESTRAZIONI.TipoIncarico
	  ,ESTRAZIONI.ChiaveIncarico
	  ,ESTRAZIONI.NDG
	  ,ESTRAZIONI.Cognome
	  ,ESTRAZIONI.Nome
	  ,ESTRAZIONI.DataLavorazione

	  /* se capita che fase 1 cartaceo (creazione) risulta cagliari (es idincarico 15273868), attribuisco come operatore Marica, TL Acquisizione Milano) */

	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		 THEN 8420 ELSE  estrazioni.IdOperatoreLavorazione END IdOperatoreLavorazione
	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		THEN 'Maestrello M.' else ESTRAZIONI.OperatoreLavorazione END OperatoreLavorazione
	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		THEN 3 ELSE  CodSede END CodSedeLavorazione
	  ,CASE WHEN estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0 AND CodSede <> 3
		THEN 'Mi' ELSE D_SedeOperatore.Descrizione END SedeOperatore

	/******************************************************************************************************************************************/

	  ,CASE WHEN CodSede IN (10,3) OR (estrazioni.CodTipoLavorazione = 1 AND FlagRO = 0) THEN 'MI'
		WHEN CodSede = 1 THEN 'CA'
		WHEN codsede IN (2,11) THEN 'RO'
		END AS EtichettaSedeLavorazione
	  ,estrazioni.CodTipoLavorazione
	  ,TipoLavorazione
	  ,CASE WHEN CodSede IN (2,11) AND CodTipoIncarico IN (611,613) AND estrazioni.CodTipoLavorazione IN (3,4,5,6)
				 THEN 0
		WHEN ROW_NUMBER() OVER (PARTITION BY IdIncarico,estrazioni.CodTipoLavorazione 
									ORDER BY IdIncarico, estrazioni.CodTipoLavorazione, CodSede
								) >1 
			 THEN 0
		ELSE Corrispettivo
		
		END Corrispettivo
	 
FROM estrazioni
LEFT JOIN S_Operatore ON estrazioni.IdOperatoreLavorazione = S_Operatore.IdOperatore

LEFT JOIN D_SedeOperatore ON S_Operatore.CodSede = D_SedeOperatore.Codice
LEFT JOIN lavorazioni ON estrazioni.CodTipoLavorazione = lavorazioni.CodTipoLavorazione

--WHERE IdIncarico IN (15273868

--)


)
SELECT 

IdIncarico
	  ,DataCreazione
	  ,CodTipoIncarico
	  ,TipoIncarico
	  ,ChiaveIncarico
	  ,NDG
	  ,Cognome
	  ,Nome
	  ,ISNULL(DataLavorazione,Data) DataLavorazione
	  ,ISNULL(IdOperatoreLavorazione,IdOperatore) IdOperatoreLavorazione
	  ,ISNULL(OperatoreLavorazione,Etichetta) OperatoreLavorazione
	  ,ISNULL(CodSedeLavorazione,CodSede) CodSedeLavorazione
	  ,ISNULL(SedeOperatore,timesheet.EtichettaSedeLavorazione) SedeOperatore
	  ,ISNULL(dataset.EtichettaSedeLavorazione,timesheet.EtichettaSedeLavorazione) EtichettaSedeLavorazione
	  ,dataset.CodTipoLavorazione
	  ,TipoLavorazione
	  ,Corrispettivo	
	  ,IIF(Corrispettivo = 0,0,1) IsFatturata
	  ,TML / 55 TML
	  ,TML TMLMinuti
	  ,IIF(ROW_NUMBER() OVER (PARTITION BY IdOperatore,timesheet.Data ORDER BY IdOperatore,timesheet.Data)>1,0
	  ,OreDaTS	  
	  ) OreDaTS
	
	 FROM dataset
LEFT JOIN TML_LAV_SEDE ON dataset.EtichettaSedeLavorazione = TML_LAV_SEDE.EtichettaSedeLavorazione
AND TML_LAV_SEDE.CodTipoLavorazione = dataset.CodTipoLavorazione
FULL JOIN timesheet ON IdOperatoreLavorazione = IdOperatore
AND DataLavorazione = timesheet.Data
WHERE  timesheet.IdOperatore IN (SELECT DISTINCT IdOperatoreLavorazione FROM dataset)
--AND IdIncarico IN (15273868,
--15202352,
--15194841

--)

--AND dataset.DataLavorazione < '2020-07-01'
--AND IdIncarico IS NULL

--ORDER BY IdIncarico, dataset.CodTipoLavorazione

GO