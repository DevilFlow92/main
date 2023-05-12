USE clc
GO

IF OBJECT_ID('tempdb.dbo.#dataset') IS NOT NULL
begin	
	DROP TABLE #dataset
end



;WITH cte AS (
select 'CHIARIMENTI LIQUIDAZIONI / SIMULAZIONI' LavorazioneCasella, 'BS Azimut ' Owner union
select 'DICHIARAZIONE CONTRIBUTI NON DEDOTTI' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTA CERTIFICAZIONE FISCALE' LavorazioneCasella, 'CESAM' Owner union
select 'RICHIESTA INVIO DOCUMENTAZIONE VIA MAIL (NON PIU'' PER POSTA ORDINARIA)' LavorazioneCasella, 'CESAM' Owner union
select 'RICHIESTA SALDO POSIZIONE' LavorazioneCasella, 'BS Azimut ' Owner union
select 'SOLLECITO TRASFERIMENTO OUT' LavorazioneCasella, 'CESAM' Owner union
select 'VARIAZIONE DATORE DI LAVORO/TIPO ADESIONE' LavorazioneCasella, 'Previnet' Owner union
select 'VARIAZIONI/SEGNALAZIONI ANAGRAFICHE/BENEFICIARI E INDIRIZZO MAIL' LavorazioneCasella, 'CESAM' Owner union
select 'RICHIESTE PER SUCCESSIONE' LavorazioneCasella, 'CESAM' Owner union
select 'AUTORIZZAZIONE PER TRASFERIMENTO OUT' LavorazioneCasella, 'Previnet' Owner union
select 'DETTAGLIO FISCALE' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTA/SOLLECITO AUTORIZZAZIONE PER TRASFERIMENTO IN' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTA DOCUMENTI MANCANTI PER TRASFERIMENTO IN/ NON TRASFERIBILITA''' LavorazioneCasella, 'Previnet' Owner union
select 'SOLLECITO DETTAGLIO FISCALE' LavorazioneCasella, 'Previnet' Owner union
select 'COMUNICAZIONE FUSIONE/CESSIONE AZIENDA' LavorazioneCasella, 'CESAM + 1' Owner union
select 'COMUNICAZIONE NUOVI DIPENDENTI / CESSAZIONI DIPENDENTI' LavorazioneCasella, 'Previnet' Owner union
select 'COMUNICAZIONI BONIFICI DOPPI E/O ERRATI' LavorazioneCasella, 'CESAM' Owner union
select 'INVIO DISTINTE CONTRIBUZIONE E COPIA BONIFICO' LavorazioneCasella, 'Previnet' Owner union
select 'RICHESTA INFORMAZIONI PER PAGAMENTO TFR E CONTRIBUTI VARI - CARICAMENTO DISTINTA' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTA AZIENDA DELLA COPIA MANDATO DEL DIPENDENTE' LavorazioneCasella, 'CESAM' Owner union
select 'RICHIESTA RICONCILIAZIONE BONIFICI' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTE SISTEMAZIONI DISTINTE/BONIFICI' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTA CODICE AZIENDA/PASSWORD' LavorazioneCasella, 'BS Azimut' Owner union
select 'MODULO SR98/INPS' LavorazioneCasella, 'Previnet' Owner union
select 'RICHIESTA CONTATTO DA CONSULENTE O AZIMUT' LavorazioneCasella, 'BS Azimut ' Owner union
select 'COMUNICAZIONI FALLIMENTI (POSTA CERTIFICATA)' LavorazioneCasella, 'Previnet e Azimut contestualmente' Owner union
select 'VARIE ( ES.: AZIENDE CHIEDONO BILANCI, COMPILARE DOCUMENTI, RECLAMI, …. )' LavorazioneCasella, 'miscellaneous ' Owner UNION
SELECT 'RICHIESTA CERTIFICAZIONE FISCALE E/O COMUNICAZIONE PERIODICA' LavorazioneCasella, 'CESAM' Owner UNION 
SELECT 'RICHIESTA CREDENZIALI WELFARE' LavorazioneCasella, 'Previnet' Owner UNION
SELECT 'RICHIESTA/VERIFICA AGGANCI RID' LavorazioneCasella, 'Previnet' Owner UNION
SELECT 'RICHIESTE VARIE CLIENTI' LavorazioneCasella, 'miscellaneous' owner

)

SELECT ti.IdIncarico
,CASE WHEN sospeso.IdSospeso IS NOT NULL THEN 'SI' ELSE 'NO' END Sospeso
,CASE WHEN previdenza.IdTransizione IS NOT NULL THEN 'SI' ELSE 'NO' END LavoratoPrevidenza
,CASE WHEN acquisizione.IdTransizione IS NOT NULL THEN 'SI' ELSE 'NO' END LavoratoAcquisizione
,CASE WHEN romania.IdTransizione IS NOT NULL THEN 'SI' ELSE 'NO' END LavoratoRomania
,CASE WHEN successioni.IdTransizione IS NOT NULL THEN 'SI' ELSE 'NO' END LavoratoTASuccessioni
,CASE WHEN previdenza.IdTransizione IS NULL 
	   AND acquisizione.IdTransizione IS NULL
	   AND romania.IdTransizione IS NULL
	   AND successioni.IdTransizione IS NULL
	   THEN 1 ELSE 0 END [Check]
,ti.DataCreazione
,CAST((YEAR(ti.DataCreazione)) AS VARCHAR(4)) + '-'+ FORMAT(MONTH(ti.DataCreazione),'0#') MeseCreazione
,ti.CodTipoIncarico
,d.TipoIncarico
,ti.CodStatoWorkflowIncarico
,ISNULL(d.StatoWorkflowIncarico,' - '+d.DescrizioneStatoWorkflowIncarico) StatoWorkflowIncarico
,ISNULL(TipoLavorazioneCasella.Testo,'') TipoLavorazioneCasella
,ISNULL(Owner,'') OwnerGestioneCasella
,CASE WHEN TipoLavorazioneCasella.IdDatoAggiuntivo IS NULL AND ti.CodTipoIncarico IN (753,765) THEN 1 ELSE 0 END FlagDatoAggiuntivoMancante
,CASE WHEN LavorazioneCasella IS NULL AND TipoLavorazioneCasella.IdDatoAggiuntivo IS NOT NULL THEN 1 ELSE 0 END FlagVoceMancante

INTO #dataset

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
AND ti.CodArea = 8 AND ti.CodCliente = 23 
AND ti.CodTipoIncarico IN (
102	--Switch Previdenza
,167	--Sottoscrizioni Previdenza
,169	--Gestione RID Previdenza
,170	--Versamenti Aggiuntivi Previdenza
,173	--Disinvestimenti Previdenza
,175	--Successioni - Previdenza
,177	--Distinte Contributive Previdenza
,178	--Varie Previdenza
,179	--Distinta Assegni v/Previdenza
,180	--Riepilogo Bonifici da Fondi Az v/Previdenza
,181	--Riepilogo Bonifici da Polizze Az v/Previdenza
,526	--Rap (Report Analisi Previdenziale)
,572	--Sottoscrizioni Previdenza - Zenith
,573	--Versamenti Aggiuntivi Previdenza - Zenith
,575	--Switch Previdenza - Zenith
,649	--Autorizzazioni Trasferimenti OUT Previdenza
,656	--AZISF - Switch Previdenza
,657	--AZISF - Sottoscrizioni Previdenza
,658	--AZISF - Disinvestimenti Previdenza
,659	--AZISF - Successioni - Previdenza
,660	--AZISF - Varie Previdenza
,661	--AZISF - Sottoscrizioni Previdenza - Zenith
,685	--AZISF - Versamenti Aggiuntivi Previdenza
,686	--AZISF - Versamenti Aggiuntivi Previdenza - Zenith
,753	--Gestione Caselle Previdenza
,765	--AZISF - Gestione Caselle Previdenza
,817	--Comunicazioni ADV Previdenza
)

OUTER APPLY (
			SELECT TOP 1 IdSospeso 
            FROM T_Sospeso
			WHERE T_Sospeso.IdIncarico = ti.IdIncarico
) sospeso

OUTER APPLY (
				SELECT TOP 1 lwix.IdTransizione 
                FROM L_WorkflowIncarico lwix
				WHERE lwix.IdIncarico = ti.idincarico
				AND lwix.IdOperatore IN (
								5311	--D'agostino A.
								,5312	--Deriu A.
								,5318	--Catanzaro E.
								,8670	--Dell'Acqua C.
								,12701 --Fiori DPE Previdenza
								)
) previdenza

OUTER APPLY (
				SELECT TOP 1 lwix3.IdTransizione
                FROM dbo.L_WorkflowIncarico lwix3
				JOIN S_Operatore ON lwix3.IdOperatore = S_Operatore.IdOperatore
				WHERE lwix3.IdIncarico = ti.idincarico
				AND CodProfiloAccesso IN (
							845	--CESAM AZ AR Gestione DOX TL
							,867	--CESAM AZ AR Gestione DOX

				)

) romania

OUTER APPLY (

			SELECT TOP 1 lwix2.IdTransizione 
            FROM L_WorkflowIncarico lwix2
			JOIN S_Operatore ON lwix2.IdOperatore = S_Operatore.IdOperatore
			
			WHERE lwix2.IdIncarico = ti.IdIncarico
			AND CodProfiloAccesso IN (935	--CESAM AZ GCS Acquisizione TL
										,936	--CESAM AZ GCS Acquisizione
										,1268	--CESAM AZ GCS Acquisizione AUT
										,1267 --CESAM AZ MI Gestione DOX TL
										,2266 --Ballabio
										,2136 --WebApp Az Reply
										,2764 --JMK
									  )
) acquisizione

OUTER APPLY (
			SELECT TOP 1 lwix4.IdTransizione 
            FROM dbo.L_WorkflowIncarico lwix4
			JOIN S_Operatore ON lwix4.IdOperatore = S_Operatore.IdOperatore
			WHERE lwix4.IdIncarico = ti.idincarico
			AND (
				CodProfiloAccesso IN (3404 --successioni
										,1386	--CESAM AZ GP Successioni
										,945 --TA Successioni
									   )
			 OR lwix4.IdOperatore = 12657 --M. Virga
			 )
	
) successioni

LEFT JOIN T_DatoAggiuntivo TipoLavorazioneCasella ON ti.IdIncarico = TipoLavorazioneCasella.IdIncarico
AND TipoLavorazioneCasella.FlagAttivo = 1
AND TipoLavorazioneCasella.CodTipoDatoAggiuntivo = 2302
AND ti.CodTipoIncarico IN (753	--Gestione Caselle Previdenza
,765	--AZISF - Gestione Caselle Previdenza
)
LEFT JOIN cte ON TipoLavorazioneCasella.testo = cte.LavorazioneCasella

WHERE  ti.DataCreazione >= '20210101' AND ti.DataCreazione < '20220101'
--AND D.StatoWorkflowIncarico IS NULL
--AND ti.IdIncarico IN (16754757
--,16754932
--,16756335

--)

SELECT IdIncarico
	  ,Sospeso
	  ,LavoratoPrevidenza
	  ,LavoratoAcquisizione
	  ,LavoratoRomania
	  ,LavoratoTASuccessioni
	  --,[Check]
	  ,DataCreazione
	  ,MeseCreazione
	  --,CodTipoIncarico
	  ,TipoIncarico
	  --,CodStatoWorkflowIncarico
	  ,StatoWorkflowIncarico

FROM #dataset
--WHERE [Check] = 1


SELECT IdIncarico
--,CodTipoIncarico
,TipoIncarico
,TipoLavorazioneCasella
,OwnerGestioneCasella
,FlagDatoAggiuntivoMancante
,FlagVoceMancante
FROM #dataset
WHERE CodTipoIncarico IN (753,765)


DROP TABLE #dataset