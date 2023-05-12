USE ScanDB_DWH
GO

CREATE vIEW dbo.v_CESAM_AZ_SLA_Globale_v4_test AS 
--USE ScanDB_DWH

--##################################################################
--SCANSIONE INCARICO
--##################################################################
WITH scansionati AS(
SELECT	QTask_idIncarico
		,MIN(DataRicezione) DataRicezione
		,MIN(DataCheckin) DataCheckin
		,CASE when DATEDIFF(HOUR,DataRicezione,DataCheckin) > 2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0 THEN DataAnomalo.ChiaveData ELSE S_DATA.ChiaveData END AS ChiaveDataRicezione

		,MIN(DataScansione) DataScansione
		,CONVERT(varchar(10),DataScansione,112) ChiaveDataScansione
		,CASE when DATEDIFF(HOUR,DataRicezione,DataCheckin) > 2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0 THEN DataAnomalo.GiornoSettimana ELSE S_DATA.GiornoSettimana END AS GiornoSettimana
		,CASE when DATEDIFF(HOUR,DataRicezione,DataCheckin) > 2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0 THEN DataAnomalo.EtichettaGiornoSettimana ELSE S_DATA.EtichettaGiornoSettimana END AS EtichettaGiornoSettimana
		,Codice CodTipoIncaricoS
		,Descrizione DescrizioneIncarico
FROM dbo.T_Pacchetto
LEFT JOIN dbo.S_DATA on CONVERT(varchar(10),DataRicezione,112) = ChiaveData
LEFT JOIN dbo.S_DATA DataAnomalo ON CONVERT(varchar(10),DataCheckin,112) = DataAnomalo.ChiaveData
LEFT JOIN dbo.S_Ora on CONVERT(VARCHAR(5), DataRicezione,108) = ChiaveOra
LEFT JOIN dbo.S_Ora OraAnomalo on CONVERT(VARCHAR(5), DataCheckin,108) = OraAnomalo.ChiaveOra
LEFT JOIN CLC.dbo.D_TipoIncarico clcdtipoincarico WITH(NOLOCK)  on clcdtipoincarico.Codice = QTask_CodTipoIncarico


WHERE CodSede IN (13,26)
--AND DataScansione >= '20170619' AND DataScansione < '20170620'
AND DataScansione IS NOT NULL 
AND QTask_CodCliente = 23
AND CodSistema = 3 
--AND CodStatoPacchetto IN( 3,2)
--AND QTask_idIncarico = 5570690
AND DataCheckin >= dateadd(month,-3,cast(cast(getdate() as date)as datetime))

GROUP BY QTask_idIncarico
		,CASE when DATEDIFF(HOUR,DataRicezione,DataCheckin) > 2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0 THEN DataAnomalo.ChiaveData ELSE S_DATA.ChiaveData END
		,CONVERT(varchar(10),DataScansione,112)
		,CASE when DATEDIFF(HOUR,DataRicezione,DataCheckin) > 2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0 THEN DataAnomalo.GiornoSettimana ELSE S_DATA.GiornoSettimana END
		,CASE when DATEDIFF(HOUR,DataRicezione,DataCheckin) > 2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0 THEN DataAnomalo.EtichettaGiornoSettimana ELSE S_DATA.EtichettaGiornoSettimana END
		,Codice
		,Descrizione
)

--##################################################################
--ESTRAZIONE FINALE
--##################################################################
, estrazione AS (
SELECT 	
	scansionati.QTask_idIncarico,
	CASE WHEN DATEDIFF(HOUR,DataRicezione,DataCheckin) >2 OR DATEDIFF(HOUR,DataRicezione,DataCheckin) < 0  THEN 
		( CASE when DATEPART(HOUR,DataCheckin) >= 15 THEN 15 ELSE 0 END)
		ELSE ( CASE when DATEPART(HOUR,DataRicezione) >= 15 THEN 15 ELSE 0 END) 
		 END  AS ChiaveOraRicezione
		,scansionati.DataRicezione
		,scansionati.DataCheckin
		,GiornoSettimana
		,EtichettaGiornoSettimana
		,scansionati.DataScansione
	,scansionati.ChiaveDataRicezione
	,ChiaveDataScansione
	,ISNULL(MIN(LWorkFlowIncarico.DataTransizione),DATEADD(MINUTE,10,DataScansione)) DataTransizione
	,MIN(LWorkFlowIncarico.IdTransizione) IdTransizione
	,tincarico.CodTipoIncarico
	,DescrizioneIncarico
FROM scansionati 
LEFT JOIN CLC.dbo.L_WorkflowIncarico LWorkFlowIncarico WITH(NOLOCK)  ON LWorkFlowIncarico.IdIncarico = QTask_idIncarico
	AND CONVERT(varchar(10),DataScansione,112) <= CONVERT(varchar(10),LWorkFlowIncarico.DataTransizione,112) 
	AND  LWorkFlowIncarico.CodStatoWorkflowIncaricoPartenza IS NOT NULL
    AND (LWorkFlowIncarico.IdOperatore <> 21)
LEFT JOIN CLC.dbo.T_Incarico TIncarico WITH(NOLOCK)  ON QTask_idIncarico =TIncarico.IdIncarico
WHERE TIncarico.CodArea = 8 AND TIncarico.CodCliente = 23 AND TIncarico.CodStatoWorkflowIncarico <> 440
	

GROUP BY 
scansionati.QTask_idIncarico,
		scansionati.DataRicezione,
		scansionati.DataCheckin,
		TIncarico.CodTipoIncarico ,
		scansionati.DataScansione,
		scansionati.ChiaveDataScansione
	,ChiaveDataRicezione
	,		GiornoSettimana
	,EtichettaGiornoSettimana
	,DescrizioneIncarico
	,CodTipoIncaricoS
	)

--query finale
,terminesla AS (
	SELECT QTask_idIncarico
			,ChiaveDataRicezione
			,ChiaveOraRicezione
			,GiornoSettimana
			,EtichettaGiornoSettimana
			,DataRicezione,
			DataCheckin,
			DataScansione,
			 estrazione.DataTransizione
			,estrazione.IdTransizione
			,estrazione.CodTipoIncarico,
			CodStatoWorkflowIncaricoDestinazione,
			CodAttributoIncaricoDestinazione,
			FlagAttesaDestinazione,
			FlagUrgenteDestinazione,
			DescrizioneIncarico
				,ISNULL(DMacroStatoWF.Descrizione, 'In Gestione') DescrizioneMacroStato
	,ISNULL(DStatoworkflow.Descrizione, 'Acquisita') DescrizioneStato
	,DAttributo.Descrizione DescrizioneAttributo 
			--protocollazione documentazione
			,
			CASE WHEN estrazione.CodTipoIncarico in (197		--Finanziamenti e Affidamenti-BP
										,205	--Variazioni - Finanziamenti e Affidamenti-BP
										,54		--Successioni
										,151	--Successioni - Sicav
										,164	--Successioni - Polizze AzLife
										,165	--Successioni - Fondi di Investimento
										,166	--Successioni - Polizze Compagnie Terze
										,175	--Successioni - Previdenza
										,184	--Successioni - Gestioni Individuali
										,185	--Successioni - Raccolta Ordini
										,193	--Successioni - Banco Popolare
										)
										THEN --calcolo sla a t+3 (se il documento mi arriva dopo t0 - h15 ho un giorno in più)
										(
												(CASE when ChiaveOraRicezione = 0 THEN 
													(intervalloprotocollazione.IntervalloLavorativo - (4*8*60) ) --4 giorni
													ELSE --entro le 24 di t+4
													(intervalloprotocollazione.IntervalloLavorativo - (5*8*60)) --5 giorni
													END)
												)
												
										
										ELSE --calcolo sla standard (NON si tratta di successioni/finanziamenti) sla t0
										(
											
													(CASE when ChiaveOraRicezione = 0 THEN --in giornata
													(intervalloprotocollazione.IntervalloLavorativo - (1*8*60)) --mezzanotte di t0
													ELSE 
													(intervalloprotocollazione.IntervalloLavorativo - (2*8*60))
													END
												))
												
							END AS SLA_Protocollazione

				--gestione documentazione
				,CASE when estrazione.CodTipoIncarico in (197		--Finanziamenti e Affidamenti-BP
										,205	--Variazioni - Finanziamenti e Affidamenti-BP
										,54		--Successioni
										,151	--Successioni - Sicav
										,164	--Successioni - Polizze AzLife
										,165	--Successioni - Fondi di Investimento
										,166	--Successioni - Polizze Compagnie Terze
										,175	--Successioni - Previdenza
										,184	--Successioni - Gestioni Individuali
										,185	--Successioni - Raccolta Ordini
										,193	--Successioni - Banco Popolare
										) 

										THEN --calcolo sla a t+3 (se il documento mi arriva dopo t0 - h15 ho un giorno in più)
											(
												(CASE when ChiaveOraRicezione = 0 THEN --ricevuto prima delle 15
													(intervallogestione.IntervalloLavorativo - (4*8*60)) 
													ELSE --ricevuto dopo le 15 ho un giorno in più
													(intervallogestione.IntervalloLavorativo - (5*8*60))
													END
												))
												

										ELSE --calcolo sla standard (non si tratta di successioni/finanziamenti) sla t0
												(
												(CASE when ChiaveOraRicezione = 0 THEN 
													(intervallogestione.IntervalloLavorativo - (1*8*60)) 
													ELSE 
													(intervallogestione.IntervalloLavorativo - (2*8*60))
													END
												)
												
							)END AS SLA_Gestione

	FROM estrazione
	LEFT JOIN CLC.dbo.L_WorkflowIncarico wfincarico WITH(NOLOCK)  on estrazione.IdTransizione = wfincarico.IdTransizione
LEFT JOIN CLC.dbo.D_StatoWorkflowIncarico  DStatoworkflow WITH(NOLOCK)  ON wfincarico.CodStatoWorkflowIncaricoDestinazione = DStatoworkflow.Codice
LEFT JOIN CLC.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow RClienteTipoIncaricoMacrostatoWf WITH(NOLOCK) 
	ON RClienteTipoIncaricoMacrostatoWf.CodCliente = 23
		AND RClienteTipoIncaricoMacrostatoWf.CodTipoIncarico = estrazione.CodTipoIncarico
		AND RClienteTipoIncaricoMacrostatoWf.CodStatoWorkflowIncarico = wfincarico.CodStatoWorkflowIncaricoDestinazione
LEFT JOIN CLC.dbo.D_MacroStatoWorkflowIncarico DMacroStatoWF WITH(NOLOCK)  ON RClienteTipoIncaricoMacrostatoWf.CodMacroStatoWorkflowIncarico = DMacroStatoWF.Codice
LEFT JOIN CLC.dbo.D_AttributoIncarico DAttributo WITH(NOLOCK)  ON DAttributo.Codice = wfincarico.CodAttributoIncaricoDestinazione

CROSS APPLY dbo.IntervalloLavorativo_Cliente(23,chiavedataricezione,datascansione) AS intervalloprotocollazione
CROSS APPLY dbo.IntervalloLavorativo_Cliente(23,chiavedataricezione,datascansione) AS intervallogestione


)


SELECT 	QTask_idIncarico,
		ChiaveDataRicezione,
		ChiaveOraRicezione,
		GiornoSettimana,
		EtichettaGiornoSettimana,
		DataRicezione,
		DataCheckin,
		DataScansione,
		DataTransizione,
		IdTransizione,
		CodTipoIncarico,
		CodStatoWorkflowIncaricoDestinazione,
		CodAttributoIncaricoDestinazione,
		FlagAttesaDestinazione,
		FlagUrgenteDestinazione,
		DescrizioneIncarico,
		DescrizioneMacroStato,
		DescrizioneStato,
		DescrizioneAttributo,
		--TermineSLA_Protocollazione,
		--TermineSla_Gestione,
		CASE WHEN SLA_Protocollazione<0 THEN 0 ELSE SLA_Protocollazione END AS SLA_Protocollazione ,
		CASE WHEN SLA_Gestione <0 THEN 0 ELSE SLA_Gestione END AS SLA_Gestione
		
		
		FROM terminesla

GO