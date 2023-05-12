USE ScanDB_DWH
GO

--USE ScanDB_DWH

CREATE VIEW dbo.v_CESAM_AZ_SLA_Sospesi_v4_test as

--USE ScanDB_DWH
WITH selezione AS (
SELECT TIncarico.IdIncarico
,LWorkflowSospeso.IdTransizione IdTransizioneSospeso
,TSospeso.IdSospeso
,DataTransizione DataAperturaSospeso
,CONVERT(varchar(10),LWorkflowSospeso.DataTransizione,112) AS ChiaveAperturaSospeso
,TIncarico.DataUltimaTransizione
,ISNULL(ISNULL(DataCheckin,TDocumento.DataInserimento),TIncarico.DataCreazione) DataScansione
,ISNULL(ISNULL(CONVERT(varchar(10),DataCheckin,112),CONVERT(varchar(10),TDocumento.DataInserimento,112)),CONVERT(varchar(10),TIncarico.DataCreazione,112)) ChiaveScansione
,TIncarico.CodTipoIncarico 
,DTipoIncarico.Descrizione TipoIncarico
,GiornoSettimana
,SD.EtichettaGiornoSettimana
,dbo.S_Ora.Ora24
,IdComunicazione
,DataInvio

,OraSosp.Ora24 OraSosp

 FROM CLC.dbo.T_Incarico TIncarico WITH(NOLOCK) 
JOIN CLC.dbo.T_Sospeso TSospeso WITH(NOLOCK)  on TIncarico.IdIncarico = TSospeso.IdIncarico
JOIN CLC.dbo.L_WorkflowSospeso LWorkflowSospeso WITH(NOLOCK)  ON LWorkflowSospeso.IdSospeso = TSospeso.IdSospeso
LEFT JOIN dbo.T_Pacchetto on TIncarico.IdIncarico = QTask_idIncarico AND CONVERT(varchar(10),DataCheckin,112) <= CONVERT(varchar(10),LWorkflowSospeso.DataTransizione,112)
LEFT JOIN CLC.dbo.T_Documento TDocumento WITH(NOLOCK)  ON TIncarico.IdIncarico = TDocumento.IdIncarico 
	AND CONVERT(varchar(10),TDocumento.DataInserimento,112) <= CONVERT(varchar(10),LWorkflowSospeso.DataTransizione,112)
LEFT JOIN CLC.dbo.D_TipoIncarico DTipoIncarico WITH(NOLOCK)  ON DTipoIncarico.Codice = TIncarico.CodTipoIncarico
LEFT JOIN dbo.S_DATA SD on SD.ChiaveData = ISNULL(ISNULL(CONVERT(varchar(10),DataScansione,112),CONVERT(varchar(10),TDocumento.DataInserimento,112)),CONVERT(varchar(10),TIncarico.datacreazione,112))
LEFT JOIN dbo.S_Ora on dbo.S_Ora.ChiaveOra = ISNULL(ISNULL(CONVERT(VARCHAR(5), DataScansione,108),CONVERT(VARCHAR(5), TDocumento.DataInserimento,108)),CONVERT(VARCHAR(5), TIncarico.datacreazione,108))

LEFT JOIN S_Ora OraSosp ON OraSosp.ChiaveOra = CONVERT(VARCHAR(5), DataTransizione,108)

LEFT JOIN CLC.dbo.T_Comunicazione TComunicazione WITH(NOLOCK)  ON TComunicazione.IdIncarico = TIncarico.IdIncarico 
	AND CONVERT(varchar(10),ISNULL(LWorkflowSospeso.DataTransizione ,DataScansione),112) <= CONVERT(varchar(10),TComunicazione.DataInvio,112) 
	AND CodOrigineComunicazione = 1 --inviata

WHERE TIncarico.CodArea = 8 AND TIncarico.CodCliente = 23 --AND TIncarico.DataCreazione>= '20180101'
AND TIncarico.CodStatoWorkflowIncarico <> 440 
AND TSospeso.CodStato NOT IN (4) --annullato
	--							(5) --non bloccante
AND LWorkflowSospeso.CodStatoPartenza IS NULL 
--AND TIncarico.DataCreazione >= '20180101'

--AND TIncarico.IdIncarico = 10359091

AND DataCheckin >= dateadd(month,-3,cast(cast(getdate() as date)as datetime))
 --AND CONVERT(varchar(10),DataScansione,112) <= CONVERT(varchar(10),LWorkflowSospeso.DataTransizione,112)
--AND TIncarico.IdIncarico = 10544214


--GROUP BY 	TIncarico.IdIncarico
--,TSospeso.IdSospeso
--,TIncarico.CodTipoIncarico
--,DTipoIncarico.Descrizione
--,TIncarico.DataUltimaTransizione
--,GiornoSettimana
--,EtichettaGiornoSettimana
--,LWorkflowSospeso.DataTransizione
--,DataCheckin
--,CONVERT(varchar(10),DataCheckin,112)
--,Ora24
--,IdComunicazione
--,DataInvio
--,LWorkflowSospeso.IdTransizione

)

, elaborazione as (
SELECT 	IdIncarico,
		IdSospeso,
		MIN(IdTransizioneSospeso) IdTransizioneSospeso,
		MIN(DataAperturaSospeso) DataAperturaSospeso,
		MAX(DataScansione) DataScansione,
		TipoIncarico
		,CodTipoIncarico
		,MIN(GiornoSettimana) GiornoSettimana
		,MIN(CASE when Ora24 < 15 THEN 0 ELSE 15 END) as Ora24
		,MAX(ChiaveScansione) ChiaveScansione
		,MAX(ChiaveAperturaSospeso) ChiaveAperturaSospeso
		,MIN(IdComunicazione) IdComunicazione

		,MIN(CASE when OraSosp <15 then 0 ELSE 15 END) AS OraSosp
		
		 FROM selezione
--WHERE DataAperturaSospeso >= '20170501' AND DataAperturaSospeso < '20170601'
--where IdIncarico = 8174601





GROUP BY 	IdIncarico,
		IdSospeso,
		TipoIncarico,
		CodTipoIncarico
		)

,terminesla AS (
		SELECT 	
		ChiaveScansione, --
		elaborazione.IdIncarico,
				elaborazione.IdSospeso,
						DataScansione,
				DataAperturaSospeso,
				ISNULL(Comunicazione.DataInvio,DataAperturaSospeso) DataInvioComunicazione
		,Ora24
				,TipoIncarico
				,DProfiloAccesso.Descrizione
				,SOperatore.CodProfiloAccesso
				,CodTipoIncarico
				,
				CASE WHEN CodTipoIncarico in (197		--Finanziamenti e Affidamenti-BP
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
										THEN --calcolo sla a t+4 (ho un giorno in più oltre la protocollazione - che è t+3)
											(
											CASE WHEN SOperatore.CodProfiloAccesso in (
												 845		--CESAM AZ AR Gestione DOX TL
												,867		--CESAM AZ AR Gestione DOX
												,934		--CESAM AZ GCS Resp Gestione Contratti e Sospesi
												,935		--CESAM AZ GCS Acquisizione TL
												,943		--CESAM AZ GP Resp Gestione Partecipanti
												,1148	--[OBSOLETO] CESAM AZ GCS Acquisizione AUT
												,1204	--[OBSOLETO] CESAM AZ GCS Acquisizione Data Entry
												,1267	--CESAM AZ MI Gestione DOX TL
												,1268	--CESAM AZ GCS Acquisizione AUT
												,936  --CESAM AZ GCS Acquisizione
											) THEN --apertura sospeso entro t+1 (ufficio acquisizione apre il sospeso entro t+1)
													(CASE WHEN Ora24 = 0 THEN 
															(IntervalloScansione.IntervalloLavorativo - (5*8*60) ) --5 giorni
															ELSE 
															(IntervalloScansione.IntervalloLavorativo - (6*8*60) ) --6 giorni
															END
															)
												else --apertura sospeso entro t+2 (ufficio sospesi/altro apre il sospeso entro t+2)
															(CASE WHEN Ora24 = 0 THEN 
															(IntervalloScansione.IntervalloLavorativo - (6*8*60)) --5 giorni
															ELSE 
															(IntervalloScansione.IntervalloLavorativo - (7*8*60)) --6 giorni
															END
															)
														END)
				--#### GESTITO SOTTO PERCHE' VOGLIONO SLA 0
				--WHEN CodTipoIncarico IN (
				--87	--Cambio Collocatore
				--,319	--Deposito P.I.R.
				--,204	--Disposizioni Varie AZ Life
				--,152	--Documentazione UBS
				--,86	--Gestione Conto Corrente
				--,57	--Gestione SEPA
				--,296	--Private Insurance
				--,80	--Raccolta Ordini
				--,147	--Rimborsi Gestioni
				--,96	--Riscatto Assicurazioni
				--,238	--Riscatto Assicurazioni AzLife
				--,97	--Sottoscrizioni/versamenti gestioni
				--,102	--Switch Previdenza
				--,178	--Varie Previdenza
				--,288	--Censimento Cliente
				--) THEN 0
							
				ELSE --calcolo sla standard (non sono incarichi successione/finanziamento)
								(
								CASE WHEN SOperatore.CodProfiloAccesso in (
									 845		--CESAM AZ AR Gestione DOX TL
									,867		--CESAM AZ AR Gestione DOX
									,934		--CESAM AZ GCS Resp Gestione Contratti e Sospesi
									,935		--CESAM AZ GCS Acquisizione TL
									,943		--CESAM AZ GP Resp Gestione Partecipanti
									,1148	--[OBSOLETO] CESAM AZ GCS Acquisizione AUT
									,1204	--[OBSOLETO] CESAM AZ GCS Acquisizione Data Entry
									,1267	--CESAM AZ MI Gestione DOX TL
									,1268	--CESAM AZ GCS Acquisizione AUT
									,936 --CESAM AZ GCS Acquisizione
								) THEN --apertura sospeso entro t+1 (considerando che la protocollazione deve essere fatta in t0) (ufficio acquisizione)
										(CASE WHEN Ora24 = 0 THEN 
												(IntervalloScansione.IntervalloLavorativo - (2*8*60)) --1 giorno
												ELSE 
												(IntervalloScansione.IntervalloLavorativo - (3*8*60)) --2 giorni
												END
												)
										
									else --apertura sospeso entro t+2 (ufficio sospesi/altro)
									(CASE WHEN Ora24 = 0 THEN 
												(IntervalloScansione.IntervalloLavorativo - (3*8*60))
												ELSE 
												(IntervalloScansione.IntervalloLavorativo - (4*8*60))
												END
												)END)
											
							
											

									END AS IntervalloLavorativoSLA,




						CASE WHEN CodTipoIncarico in (197		--Finanziamenti e Affidamenti-BP
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
										THEN --calcolo sla a t+4 (ho un giorno in più oltre la protocollazione - che è t+3)
											(
											CASE WHEN SOperatore.CodProfiloAccesso in (
												 845		--CESAM AZ AR Gestione DOX TL
												,867		--CESAM AZ AR Gestione DOX
												,934		--CESAM AZ GCS Resp Gestione Contratti e Sospesi
												,935		--CESAM AZ GCS Acquisizione TL
												,943		--CESAM AZ GP Resp Gestione Partecipanti
												,1148	--[OBSOLETO] CESAM AZ GCS Acquisizione AUT
												,1204	--[OBSOLETO] CESAM AZ GCS Acquisizione Data Entry
												,1267	--CESAM AZ MI Gestione DOX TL
												,1268	--CESAM AZ GCS Acquisizione AUT
												,936  --CESAM AZ GCS Acquisizione
											) THEN --apertura sospeso entro t+1 (ufficio acquisizione apre il sospeso entro t+1)
													(CASE WHEN OraSosp = 0 THEN 
															(IntervalloAperturaSospeso.IntervalloLavorativo - (5*8*60) ) --5 giorni
															ELSE 
															(IntervalloAperturaSospeso.IntervalloLavorativo - (6*8*60) ) --6 giorni
															END
															)
												else --apertura sospeso entro t+2 (ufficio sospesi/altro apre il sospeso entro t+2)
															(CASE WHEN OraSosp = 0 THEN 
															(IntervalloAperturaSospeso.IntervalloLavorativo - (6*8*60)) --5 giorni
															ELSE 
															(IntervalloAperturaSospeso.IntervalloLavorativo - (7*8*60)) --6 giorni
															END
															)
														END)
				--#### GESTITO SOTTO PERCHE' VOGLIONO SLA 0
				--WHEN CodTipoIncarico IN (
				--87	--Cambio Collocatore
				--,319	--Deposito P.I.R.
				--,204	--Disposizioni Varie AZ Life
				--,152	--Documentazione UBS
				--,86	--Gestione Conto Corrente
				--,57	--Gestione SEPA
				--,296	--Private Insurance
				--,80	--Raccolta Ordini
				--,147	--Rimborsi Gestioni
				--,96	--Riscatto Assicurazioni
				--,238	--Riscatto Assicurazioni AzLife
				--,97	--Sottoscrizioni/versamenti gestioni
				--,102	--Switch Previdenza
				--,178	--Varie Previdenza
				--,288	--Censimento Cliente
				--) THEN 0
							
				ELSE --calcolo sla standard (non sono incarichi successione/finanziamento)
								(
								CASE WHEN SOperatore.CodProfiloAccesso in (
									 845		--CESAM AZ AR Gestione DOX TL
									,867		--CESAM AZ AR Gestione DOX
									,934		--CESAM AZ GCS Resp Gestione Contratti e Sospesi
									,935		--CESAM AZ GCS Acquisizione TL
									,943		--CESAM AZ GP Resp Gestione Partecipanti
									,1148	--[OBSOLETO] CESAM AZ GCS Acquisizione AUT
									,1204	--[OBSOLETO] CESAM AZ GCS Acquisizione Data Entry
									,1267	--CESAM AZ MI Gestione DOX TL
									,1268	--CESAM AZ GCS Acquisizione AUT
									,936 --CESAM AZ GCS Acquisizione
								) THEN --apertura sospeso entro t+1 (considerando che la protocollazione deve essere fatta in t0) (ufficio acquisizione)
										(CASE WHEN OraSosp = 0 THEN 
												(IntervalloAperturaSospeso.IntervalloLavorativo - (2*8*60)) --1 giorno
												ELSE 
												(IntervalloAperturaSospeso.IntervalloLavorativo - (3*8*60)) --2 giorni
												END
												)
										
									else --apertura sospeso entro t+2 (ufficio sospesi/altro)
									(CASE WHEN OraSosp = 0 THEN 
												(IntervalloAperturaSospeso.IntervalloLavorativo - (3*8*60))
												ELSE 
												(IntervalloAperturaSospeso.IntervalloLavorativo - (4*8*60))
												END
												)END)
											
							
											

									END AS IntervalloLavorativoSLA_AperturaSospeso,

									OraSosp




				FROM elaborazione 
				JOIN CLC.dbo.L_WorkflowSospeso Sospeso WITH(NOLOCK)  ON elaborazione.IdTransizioneSospeso = Sospeso.IdTransizione 
				LEFT JOIN CLC.dbo.T_Comunicazione Comunicazione WITH(NOLOCK)  ON elaborazione.IdComunicazione = Comunicazione.IdComunicazione
				LEFT JOIN CLC.dbo.S_Operatore SOperatore  WITH(NOLOCK)  ON Sospeso.IdOperatore = SOperatore.IdOperatore
				LEFT JOIN CLC.dbo.D_ProfiloAccesso DProfiloAccesso WITH(NOLOCK)  ON DProfiloAccesso.Codice = SOperatore.CodProfiloAccesso
				CROSS APPLY dbo.IntervalloLavorativo_Cliente(23,ChiaveScansione,Comunicazione.DataInvio) IntervalloScansione
				CROSS APPLY dbo.IntervalloLavorativo_Cliente(23,ChiaveAperturaSospeso,Comunicazione.DataInvio) IntervalloAperturaSospeso
		WHERE (DataAperturaSospeso >= DataScansione OR ChiaveScansione = ChiaveAperturaSospeso)
		--AND Comunicazione.DataInvio >= DataScansione  
		

		)


SELECT
ChiaveScansione,
		IdIncarico,
		IdSospeso,
		DataScansione,
		EtichettaGiornoSettimana,
		DataAperturaSospeso,
		DataInvioComunicazione,
		Ora24,
		TipoIncarico,
		Descrizione,
		CodProfiloAccesso,
		--IntervalloLavorativoSLA,
		CASE WHEN CodTipoIncarico IN (
				87	--Cambio Collocatore
				,319	--Deposito P.I.R.
				,204	--Disposizioni Varie AZ Life
				,152	--Documentazione UBS
				,86	--Gestione Conto Corrente
				,57	--Gestione SEPA
				,296	--Private Insurance
				,80	--Raccolta Ordini
				,147	--Rimborsi Gestioni
				,96	--Riscatto Assicurazioni
				,238	--Riscatto Assicurazioni AzLife
				,97	--Sottoscrizioni/versamenti gestioni
				,102	--Switch Previdenza
				,178	--Varie Previdenza
				,288	--Censimento Cliente
				) THEN 0 ELSE (CASE when IntervalloLavorativoSLA < 0 THEN 0 ELSE IntervalloLavorativoSLA END) END AS SLA_Sospeso ,
				
					CASE WHEN CodTipoIncarico IN (
				87	--Cambio Collocatore
				,319	--Deposito P.I.R.
				,204	--Disposizioni Varie AZ Life
				,152	--Documentazione UBS
				,86	--Gestione Conto Corrente
				,57	--Gestione SEPA
				,296	--Private Insurance
				,80	--Raccolta Ordini
				,147	--Rimborsi Gestioni
				,96	--Riscatto Assicurazioni
				,238	--Riscatto Assicurazioni AzLife
				,97	--Sottoscrizioni/versamenti gestioni
				,102	--Switch Previdenza
				,178	--Varie Previdenza
				,288	--Censimento Cliente
				) THEN 0 ELSE (CASE when IntervalloLavorativoSLA_AperturaSospeso < 0 THEN 0 ELSE IntervalloLavorativoSLA_AperturaSospeso END) END AS SLA_Sospeso_AperturaSospeso,
				OraSosp

				FROM terminesla
		LEFT JOIN dbo.S_DATA on ChiaveScansione = ChiaveData


		--WHERE IdIncarico = 10359091 






 
		--WHERE DataAperturaSospeso >= '20180501' AND DataAperturaSospeso < '20180601'

GO