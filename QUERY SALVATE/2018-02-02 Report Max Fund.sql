USE [CLC]
GO

/****** Object:  StoredProcedure [rs].[v_CESAM_AZ_AFB_MaxFund_Operazioni]    Script Date: 02/02/2018 12:56:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
andrea padricelli
*/

--CREATE PROCEDURE [rs].[v_CESAM_AZ_AFB_MaxFund_Operazioni] (@Oggi DATETIME
--,@Ieri DATETIME
--,@DataCreazioneFEADA DATETIME
--,@DataCreazioneFEAA DATETIME
--,@FlagClear SMALLINT) AS 

DECLARE @Oggi DATETIME
,@DataCreazioneFEADA DATETIME
,@DataCreazioneFEAA DATETIME
,@FlagClear SMALLINT
,@Ieri DATETIME

SET @Oggi = '2018-02-02'--'2017-11-24'
SET @Ieri = '2018-02-01'--'2017-11-23'
SET @DataCreazioneFEADA ='2018-02-01 10:00' --'2017-11-23 10:00'
SET @DataCreazioneFEAA = '2018-02-03 10:00' --'2017-11-24 10:00'
SET @FlagClear = 0

BEGIN

SELECT        
--T_Incarico.CodStatoWorkflowIncarico
--,wf.IdIncarico
--,
T_DatiAggiuntiviIncaricoAzimut.IdIncarico
,IdOperazioneAzimut
,Isin
, D_TipoIncarico.Descrizione
, primo.ChiaveCliente
, case when primo.Cognome = '' or primo.Nome = ''
                    OR primo.Cognome IS NULL or primo.Nome IS NULL then primo.RagioneSociale else primo.Cognome + ' ' + primo.Nome end AS cliente
, T_Mandato.DataSottoscrizione
, T_OperazioneAzimut.Importo Importo
--, REPLACE(T_operazioneAzimut.Importo,'.',',') importo
, T_Mandato.NumeroMandato
, T_Mandato.NumeroContratto AS MandatoRTO
, T_DatiAggiuntiviIncaricoAzimut.NumeroRaccomandazione
, D_TipoRaccomandazione.Descrizione AS Expr1
, D_TipoFea.Descrizione AS Expr2
, T_DatiAggiuntiviIncaricoAzimut.CodTipoFea
,CONVERT(varchar(10),GETDATE(),112) DataOggi
,Testo as ChiaveClienteDispositore
--INTO #temprendicontomaxfund
FROM            T_Incarico INNER JOIN
                         D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico INNER JOIN
                         T_R_Incarico_Mandato ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico INNER JOIN
                         T_Mandato ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato INNER JOIN
                         T_Dossier ON T_Dossier.IdDossier = T_Mandato.IdDossier INNER JOIN
                         T_R_Dossier_Persona AS dossier1 ON dossier1.IdDossier = T_Dossier.IdDossier AND dossier1.Progressivo = 1 INNER JOIN
                         T_Persona AS primo ON primo.IdPersona = dossier1.IdPersona INNER JOIN
                         T_OperazioneAzimut ON T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico left JOIN
                         T_DatiAggiuntiviIncaricoAzimut ON T_Incarico.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico left JOIN
                         D_TipoRaccomandazione ON T_DatiAggiuntiviIncaricoAzimut.CodTipoRaccomandazione = D_TipoRaccomandazione.Codice LEFT OUTER JOIN
                         D_TipoFea ON T_DatiAggiuntiviIncaricoAzimut.CodTipoFea = D_TipoFea.Codice
						 JOIN E_ProdottoAzimut ON T_OperazioneAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut
						LEFT JOIN (SELECT T_Incarico.IdIncarico, MAX(DataUltimaTransizione) DataUltimaTransizione FROM L_WorkflowIncarico 
							JOIN T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
							JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
							ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
							AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
							AND L_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
							WHERE T_Incarico.CodCliente = 23 AND T_Incarico.CodTipoIncarico IN (321,322) AND CodMacroStatoWorkflowIncarico = 2
							--AND T_Incarico.IdIncarico IN (9139289)
							GROUP by T_Incarico.IdIncarico
							) wf ON wf.IdIncarico = T_Incarico.IdIncarico

					JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
							ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
							AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
							AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico

					LEFT JOIN T_Documento on T_Incarico.IdIncarico = T_Documento.IdIncarico

					LEFT JOIN (
						SELECT L_WorkflowIncarico.IdIncarico, MIN(DataTransizione) transizione FROM L_WorkflowIncarico
							JOIN T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
							AND CodCliente = 23
							AND T_Incarico.CodArea = 8
							AND T_Incarico.CodTipoIncarico IN (321,322)
							WHERE CodStatoWorkflowIncaricoDestinazione IN (6603, 6604, 6605,8570,14336) --pronta per caricamento FEND
														--In Attesa Versamento Assegno
														--In Attesa Ricezione Bonifico
														--IN GESTIONE ACQUISITA POST REGOLARIZZAZIONE
														--In Attesa di Bonifico MAX FUNDS
							--AND T_Incarico.IdIncarico = 	9247454 		
							GROUP BY L_WorkflowIncarico.IdIncarico					


					) wftransizione ON wftransizione.IdIncarico = T_Incarico.IdIncarico
					
					---aggiunta
					 left join T_DatoAggiuntivo on T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico AND CodTipoDatoAggiuntivo = 1077 --codicecliente  dispositore	

WHERE        T_Incarico.CodCliente = 23 AND 
 T_Incarico.CodArea = 8 AND 
 T_Incarico.CodTipoIncarico IN (321,322)
AND CodTipoRaccomandazione = 2 --max
and T_Incarico.CodStatoWorkflowIncarico not in ( 820,14337,6565,6567)
and CodMacroStatoWorkflowIncarico != 2
AND (
(
	CodTipoFea = 3 --precompila
	AND wftransizione.transizione >= @Ieri -- -1
	AND wftransizione.transizione <= @Oggi
	AND ((T_Incarico.CodStatoWorkflowIncarico IN (6603, 6604, 6605,8570,14336) --pronta per caricamento FEND
														--In Attesa Versamento Assegno
														--In Attesa Ricezione Bonifico
														--IN GESTIONE ACQUISITA POST REGOLARIZZAZIONE
														--In Attesa di Bonifico MAX FUNDS	
										
							
							) OR (T_Incarico.CodStatoWorkflowIncarico = 6500 AND (CodAttributoIncarico = 1521 OR T_Documento.IdIncarico IS NOT NULL)) --cartaceo imbarcato
							
							))
										

	

OR(
	CodTipoFea <> 3
	AND (T_Incarico.DataCreazione >= @DataCreazioneFEADA) 
	AND (T_Incarico.DataCreazione < @DataCreazioneFEAA)
	OR (T_Incarico.DataUltimaTransizione >= @Ieri 
		AND T_Incarico.DataUltimaTransizione <= @Oggi
		AND CodMacroStatoWorkflowIncarico != 2 AND wf.IdIncarico IS NOT NULL) --passato in sospeso, ultima transizione oggi, stato attuale diverso da sospeso
		
)
)


--or T_Incarico.IdIncarico in (9192061,9189954,9190645,9190644)

--and T_Incarico.IdIncarico = 9690105 

group by T_DatiAggiuntiviIncaricoAzimut.IdIncarico
,IdOperazioneAzimut
,T_OperazioneAzimut.Importo
,Isin
, D_TipoIncarico.Descrizione
, primo.ChiaveCliente
, case when primo.Cognome = '' or primo.Nome = ''
                    OR primo.Cognome IS NULL or primo.Nome IS NULL then primo.RagioneSociale else primo.Cognome + ' ' + primo.Nome end
, T_Mandato.DataSottoscrizione
, T_Mandato.NumeroMandato
, T_Mandato.NumeroContratto 
, T_DatiAggiuntiviIncaricoAzimut.NumeroRaccomandazione
, D_TipoRaccomandazione.Descrizione 
, D_TipoFea.Descrizione 
, T_DatiAggiuntiviIncaricoAzimut.CodTipoFea
,Testo
--,T_Incarico.CodStatoWorkflowIncarico
--,wf.IdIncarico



END 

/*

DECLARE @importototale DECIMAL(18,3)
,@ChiaveDataDelete char(8) 

SET @importototale = (SELECT SUM(Importo) FROM #temprendicontomaxfund GROUP BY DataOggi)
SET @ChiaveDataDelete = CONVERT(varchar(10),GETDATE(),112) 


IF @FlagClear = 0
BEGIN
	INSERT into scratch.Y_CESAM_AZ_Riconciliazione_MaxFund (IdIncarico, ChiaveDescrizione, ImportoTotale,ChiaveData)
	SELECT #temprendicontomaxfund.IdIncarico,'MAX' chiave,@importototale importototale,DataOggi FROM #temprendicontomaxfund
	LEFT JOIN  scratch.Y_CESAM_AZ_Riconciliazione_MaxFund on #temprendicontomaxfund.IdIncarico = scratch.Y_CESAM_AZ_Riconciliazione_MaxFund.IdIncarico
	WHERE Y_CESAM_AZ_Riconciliazione_MaxFund.IdIncarico IS NULL
	GROUP BY #temprendicontomaxfund.IdIncarico, DataOggi
END
ELSE
BEGIN 

	DELETE scratch.Y_CESAM_AZ_Riconciliazione_MaxFund
	WHERE ChiaveData = @ChiaveDataDelete
	
END

SELECT 	#temprendicontomaxfund.IdIncarico,
		IdOperazioneAzimut,
		Isin,
		Descrizione,
		ChiaveCliente,
		cliente,
		DataSottoscrizione,
		Importo,
		NumeroMandato,
		MandatoRTO,
		NumeroRaccomandazione,
		Expr1,
		Expr2,
		CodTipoFea,
		DataOggi
		,ChiaveClienteDispositore
		 FROM #temprendicontomaxfund
JOIN scratch.Y_CESAM_AZ_Riconciliazione_MaxFund ON #temprendicontomaxfund.IdIncarico = scratch.Y_CESAM_AZ_Riconciliazione_MaxFund.IdIncarico
--	AND #temprendicontomaxfund.IdIncarico IN (9286743
--,9286744
--,9286745
--,9286746)

DROP TABLE #temprendicontomaxfund


GO


*/