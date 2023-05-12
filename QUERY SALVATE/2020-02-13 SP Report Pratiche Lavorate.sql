USE clc
GO


--ALTER PROCEDURE rs.CESAM_CB_PraticheLavoratePerOperatore
--AS

	IF OBJECT_ID('tempdb.dbo.#tmpFatt') IS NOT NULL
		DROP TABLE #tmpFatt;

	CREATE TABLE #tmpFatt (
		IdIncarico INT
		,issubincarico INT
		,IdSubIncarico INT
		,CodTipoIncarico INT
		,Descrizione VARCHAR(255)
		,ContiDossier INT
		,TrasferimentoTitoli INT
		,TDT int
		,Predisposizione int
		,Portabilita int
		,CartaDiCredito int
		,ContrattoConsulenza INT
		,SubDossier INT
		,SubCC INT
		,[SB-LavorazioneCompleta] INT
		,[SB-SospesaOggettoSociale]     int
		,[SB-SospesaCervedNegativa] 	int
		,[SB-Fil-LavorazioneCompleta] 	int
		,[SB-Fil-SospesaOggettoSociale] int
		,[SB-Fil-SospesaCervedNegativa] int
		,DataCreazione DATETIME
		,DataUltimaTransizione DATETIME
		,Mese INT
		,StatoMOL VARCHAR(200)
		,Etichetta VARCHAR(255)
		,DataAcquisizione DATETIME
		,OperatoreAcquisita VARCHAR(255)
		,OperatoreLavEffettuate VARCHAR(255)
		,DataSospensione DATETIME
		,DataUscitaSospensione DATETIME
		,IdPromotore INT
	)
	;
	INSERT INTO #tmpFatt
		SELECT DISTINCT
			v.IdIncarico
			,
			--RowNum = ROW_NUMBER() OVER (PARTITION by v.IdIncarico ORDER BY v.IdIncarico),
			v.issubincarico
			,v.IdSubIncarico
			,v.CodTipoIncarico
			,v.Descrizione
			,CASE
				WHEN v.CodCategoriaDocumenti IN (44, 48) THEN 1
				ELSE 0
			END AS ContiDossier
			,CASE
				WHEN v.CodCategoriaDocumenti IN (45) AND
					Tipo_Documento = 8268 THEN 1
				ELSE 0
			END AS TrasferimentoTitoli
			, --trasferimentoTitoli
			CASE
				WHEN v.CodCategoriaDocumenti IN (45) AND
					Tipo_Documento = 8302 THEN 1
				ELSE 0
			END AS TDT
			, --CB-TDT
			CASE
				WHEN (v.CodCategoriaDocumenti IN (50) AND
					v.CodTipoIncarico IN (331)) OR
					v.CodTipoIncarico IN (593) THEN 1
				ELSE 0
			END AS Predisposizione
			,CASE
				WHEN v.CodCategoriaDocumenti IN (46) OR
					v.CodTipoIncarico = 564 THEN 1
				ELSE 0
			END AS Portabilita
			,CASE
				WHEN v.CodCategoriaDocumenti IN (58) THEN 1
				ELSE 0
			END AS CartaDiCredito
			,CASE
				WHEN v.CodCategoriaDocumenti IN (63) AND
					v.CodTipoIncarico != 331 THEN 1
				ELSE 0
			END AS ContrattoConsulenza
			,CASE
				WHEN v.SubincaricoCodCategoriaDocumenti IN (48) THEN 1
				ELSE 0
			END AS SubDossier
			,CASE
				WHEN v.SubincaricoCodCategoriaDocumenti IN (44) THEN 1
				ELSE 0
			END AS SubCC
			,0 AS [SB-LavorazioneCompleta]
			,0 AS [SB-SospesaOggettoSociale]
			,0 AS [SB-SospesaCervedNegativa]
			,0 AS [SB-Fil-LavorazioneCompleta]
			,0 AS [SB-Fil-SospesaOggettoSociale]
			,0 AS [SB-Fil-SospesaCervedNegativa]
			,v.DataCreazione
			,v.DataUltimaTransizione
			,DATEPART(MONTH, v.DataCreazione) Mese
			,v.StatoMOL
			,
			--S_Operatore.Etichetta,
			ISNULL(ISNULL(S_Operatore.Etichetta, opp3.Etichetta), opp2.Etichetta) Etichetta
			,v.DataAcquisizione
			,v.OperatoreAcquisita
			,v.OperatoreLavEffettuate
			,v.DataSospensione
			,v.DataUscitaSospensione
			,ISNULL(IdPromotore, 1) IdPromotore

		FROM rs.v_CESAM_CB_Overview_Lavorazione_CatDoc_fatturazione_IpotesiSubincarichi v
		JOIN T_Documento WITH (NOLOCK)
			ON v.IdIncarico = T_Documento.IdIncarico
		LEFT JOIN T_R_Incarico_Operatore WITH (NOLOCK)
			ON v.IdIncarico = T_R_Incarico_Operatore.IdIncarico
			AND T_R_Incarico_Operatore.CodRuoloOperatoreIncarico = 1
		LEFT JOIN T_R_Incarico_Operatore op2 WITH (NOLOCK)
			ON v.IdIncarico = op2.IdIncarico
			AND op2.CodRuoloOperatoreIncarico = 2
		LEFT JOIN T_R_Incarico_Operatore op3 WITH (NOLOCK)
			ON v.IdIncarico = op3.IdIncarico
			AND op3.CodRuoloOperatoreIncarico = 3
		LEFT JOIN S_Operatore WITH (NOLOCK)
			ON T_R_Incarico_Operatore.IdOperatore = S_Operatore.IdOperatore
		LEFT JOIN S_Operatore opp2 WITH (NOLOCK)
			ON op2.IdOperatore = opp2.IdOperatore
		LEFT JOIN S_Operatore opp3 WITH (NOLOCK)
			ON op3.IdOperatore = opp3.IdOperatore
		LEFT JOIN T_R_Incarico_Promotore
			ON v.IdIncarico = T_R_Incarico_Promotore.IdIncarico
		WHERE v.IdIncarico > 0
	;
	INSERT INTO #tmpFatt
		SELECT
			IdIncarico
			,
			--RowNum = ROW_NUMBER() OVER (PARTITION by IdIncarico ORDER BY IdIncarico),
			issubincarico
			,IdSubincarico
			,CodTipoIncarico
			,Descrizione
			,ContiDossier
			,TrasferimentoTitoli
			,TDT
			,Predisposizione
			,Portabilita
			,CartaDiCredito
			,ContrattoConsulenza
			,SubDossier
			,SubCC
			,[SB-LavorazioneCompleta]
			,[SB-SospesaOggettoSociale]
			,[SB-SospesaCervedNegativa]
			,[SB-Fil-LavorazioneCompleta]
			,[SB-Fil-SospesaOggettoSociale]
			,[SB-Fil-SospesaCervedNegativa]
			,DataCreazione
			,DataUltimaTransizione
			,Mese
			,StatoMOL
			,Etichetta
			,DataAcquisizione
			,OperatoreAcquisita
			,OperatoreLavEffettuate
			,DataSospensione
			,DataUscitaSospensione
			,IdPromotore

		FROM rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_LogicaStatiWorkflow

	--SELECT * FROM #tmpFattConteggioDocumenti

	IF OBJECT_ID('tempdb.dbo.#tmpLav') IS NOT NULL
		DROP TABLE #tmpLav;

	CREATE TABLE #tmpLav (
		IdIncarico INT
		,IdTransizione INT
		,CodTipoIncarico INT
		,DataCreazione DATETIME
		,DataTransizione DATETIME
		,DataTransizioneFormato VARCHAR(10)
		,Ora VARCHAR(10)
		,TipoIncarico VARCHAR(50)
		,CodStatoWorkflowIncaricoPartenza INT
		,CodMacroStatoWorkflow INT
		,CodMacroStatoWorkflowPartenza INT
		,CodStatoWorkflowIncaricoDestinazione INT
		,MacroStatoWorkflowIncarico VARCHAR(100)
		,MacroStatoWorkflowIncaricoPartenza VARCHAR(100)
		,StatoWorkflowIncarico VARCHAR(100)
		,StatoWorkflowIncaricoPartenza VARCHAR(100)
		,CodAttributoIncarico INT
		,AttributoIncarico VARCHAR(100)
		,CodAttributoIncaricoPartenza INT
		,AttributoIncaricoPartenza VARCHAR(100)
		,IdOperatore INT
		,Operatore VARCHAR(50)
		,FlagAttesaPartenza int
		,FlagAttesaDestinazione int
		,CodSede INT
		,DescrizioneSede VARCHAR(100)
		,IsFaseAttraversata INT
		,FaseAttraversata VARCHAR(100)

	);

	INSERT INTO #tmpLav
		SELECT
			IdIncarico
			,IdTransizione
			,CodTipoIncarico
			,DataCreazione
			,DataTransizione
			,DataTransizioneFormato
			,Ora
			,TipoIncarico
			,CodStatoWorkflowIncaricoPartenza
			,CodMacroStatoWorkflow
			,CodMacroStatoWorkflowPartenza
			,CodStatoWorkflowIncaricoDestinazione
			,MacroStatoWorkflowIncarico
			,MacroStatoWorkflowIncaricoPartenza
			,StatoWorkflowIncarico
			,StatoWorkflowIncaricoPartenza
			,CodAttributoIncarico
			,AttributoIncarico
			,CodAttributoIncaricoPartenza
			,AttributoIncaricoPartenza
			,IdOperatore
			,Operatore
			,FlagAttesaPartenza
			,FlagAttesaDestinazione
			,CodSede
			,DescrizioneSede
			,IsFaseAttraversata
			,FaseAttraversata

		FROM rs.v_CESAM_CB_PraticheLavorate

	;
SELECT 
	RowNum = DENSE_RANK() OVER (PARTITION BY lav.IdIncarico, lav.FaseAttraversata, lav.DataTransizioneFormato ORDER BY lav.DataTransizione DESC)
	,RowNumASC = DENSE_RANK() OVER (PARTITION BY lav.IdIncarico, lav.FaseAttraversata ORDER BY lav.DataTransizione ASC)
	,RowNum_contariga = ROW_NUMBER() OVER (PARTITION BY lav.IdIncarico, lav.FaseAttraversata, lav.DataTransizioneFormato ORDER BY lav.DataTransizione DESC)
	,RowNumTransizione = DENSE_RANK() OVER (PARTITION BY lav.IdTransizione ORDER BY IdTransizione)
	,RowNumTransizioneOperatore = DENSE_RANK() OVER (PARTITION BY lav.IdOperatore ORDER BY lav.IdIncarico)
	,lav.IdIncarico
	,lav.IdTransizione
	,lav.CodTipoIncarico
	,lav.DataCreazione
	,lav.DataTransizione
	,lav.DataTransizioneFormato
	,lav.Ora
	,lav.TipoIncarico
	,lav.CodStatoWorkflowIncaricoPartenza
	,lav.CodMacroStatoWorkflow
	,lav.CodMacroStatoWorkflowPartenza
	,lav.CodStatoWorkflowIncaricoDestinazione
	,lav.MacroStatoWorkflowIncarico
	,lav.MacroStatoWorkflowIncaricoPartenza
	,lav.StatoWorkflowIncarico
	,lav.StatoWorkflowIncaricoPartenza
	,lav.CodAttributoIncarico
	,lav.AttributoIncarico
	,lav.CodAttributoIncaricoPartenza
	,lav.AttributoIncaricoPartenza
	,lav.IdOperatore
	,lav.Operatore
	,lav.FlagAttesaPartenza
	,lav.FlagAttesaDestinazione
	,lav.CodSede
	,lav.DescrizioneSede
	,lav.IsFaseAttraversata
	,lav.FaseAttraversata
	,fatt.issubincarico
	,fatt.IdSubIncarico
	,fatt.Descrizione
	,fatt.ContiDossier
	,fatt.TrasferimentoTitoli
	,fatt.TDT
	,fatt.Predisposizione
	,fatt.Portabilita
	,fatt.CartaDiCredito
	,fatt.ContrattoConsulenza
	,fatt.SubDossier
	,fatt.SubCC
	,fatt.[SB-LavorazioneCompleta]
	,fatt.[SB-SospesaOggettoSociale]
	,fatt.[SB-SospesaCervedNegativa]
FROM /*rs.v_CESAM_CB_PraticheLavorate*/ #tmpLav lav
LEFT JOIN #tmpFatt /*rs.v_CESAM_CB_Fatturazione_ConteggioDocumenti_Operatore_IpotesiSubincarichi_v2*/ fatt
	ON fatt.IdIncarico = lav.IdIncarico

--WHERE lav.DataTransizione < '2020-02-13'



DROP TABLE #tmpFatt, #tmpLav

GO