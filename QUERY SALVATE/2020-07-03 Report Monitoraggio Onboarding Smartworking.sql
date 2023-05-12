USE CLC

--SELECT 	IdIncarico
--		,DataCreazioneQTask
--		,CodTipoIncarico
--		,TipoIncaricoQTask
--		,DataOnboarding
--		,Settimana
--		,CodiceClienteFEND
--		,TipoCanale
--		,FlagSmartworking 
--FROM rs.v_CESAM_AZ_Monitoring_Onboarding_Smartworking
--WHERE DataOnboarding >= '2020-06-01'

--ALTER VIEW rs.v_CESAM_AZ_Monitoring_Onboarding_Smartworking AS 

;
WITH 
smartworking AS (SELECT * FROM [VP-BTSQL02].CLC.rs.L_CESAM_AZ_Antiriciclaggio_Import_Vincolo_Covid),
QTask as (
SELECT ti.IdIncarico
,CONVERT(date,ti.DataCreazione) DataCreazioneQTask
,ti.CodTipoIncarico
,d.TipoIncarico TipoIncaricoQTask
,CONVERT(DATE,lwi.DataTransizione) DataOnboarding
,van.ChiaveClienteIntestatario CodiceClienteFEND

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van on ti.IdIncarico = van.IdIncarico
AND van.ProgressivoPersona = 1

JOIN (SELECT MAX(IdTransizione) IdTransizione ,T_Incarico.IdIncarico
		FROM L_WorkflowIncarico
		JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
		AND CodArea = 8 AND CodCliente = 23 AND CodTipoIncarico IN (288,396)
		WHERE CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
		AND ((
				CodTipoIncarico = 396 AND CodStatoWorkflowIncaricoDestinazione = 12180 --Caricata (Onboarding Digitale)
				)
			OR (
				 CodTipoIncarico = 288 AND CodStatoWorkflowIncaricoDestinazione = 8570	-- 
				)
			)		
		GROUP BY T_Incarico.IdIncarico
) wf ON ti.IdIncarico = wf.IdIncarico
JOIN L_WorkflowIncarico lwi on wf.IdTransizione = lwi.IdTransizione

WHERE  ti.CodCliente = 23 AND ti.CodArea = 8 and ti.CodTipoIncarico in (288,396)
AND ti.DataCreazione >= '20200101'

) 
,settimane as (
SELECT CONVERT(DATE,Data) Data
,Settimana - 15 Settimana
,MIN(Data) OVER (PARTITION BY Anno,Mese,Settimana) DataInizio
,MAX(Data) OVER (PARTITION BY Anno,Mese,Settimana) DataFine
FROM rs.S_Data
WHERE Data >= '2020-04-13'
AND Anno = 2020

)
SELECT 	IdIncarico
			,DataCreazioneQTask
			,CodTipoIncarico
			,TipoIncaricoQTask
			,DataOnboarding
			,CAST(Settimana as VARCHAR(2)) + ' (' + CONVERT(VARCHAR,DataInizio,103) + ' - ' + CONVERT(VARCHAR,DataFine,103) +')' Settimana
			,CodiceClienteFEND
			,CASE CodTipoIncarico
				WHEN 288 THEN 'Tradizionale'
				WHEN 396 THEN 'FEQ'
			  END TipoCanale
			,0 FlagSmartworking
FROM QTask
LEFT JOIN  smartworking on CodiceClienteFEND = ndg
JOIN settimane ON DataOnboarding = settimane.Data
WHERE ndg IS NULL
AND DataCreazioneQTask >= '2020-04-13'

UNION ALL

SELECT 	IdIncarico
		,DataCreazioneQTask
		,CodTipoIncarico
		,TipoIncaricoQTask
		,CONVERT(date,smartworking.data) DataOnboarding
		,CAST(Settimana as VARCHAR(2)) + ' (' + CONVERT(VARCHAR,DataInizio,103) + ' - ' + CONVERT(VARCHAR,DataFine,103) +')' Settimana
		,ndg CodiceClienteFEND
		,'Smartworking' TipoCanale
		,1 FlagSmartworking
FROM QTask
JOIN  smartworking on CodiceClienteFEND = ndg
JOIN settimane ON CONVERT(date,smartworking.Data) = settimane.Data
WHERE IdIncarico >0

UNION ALL

SELECT 	IdIncarico
		,DataCreazioneQTask
		,CodTipoIncarico
		,TipoIncaricoQTask
		,CONVERT(date,smartworking.Data) DataOnboarding
		,CAST(Settimana as VARCHAR(2)) + ' (' + CONVERT(VARCHAR,DataInizio,103) + ' - ' + CONVERT(VARCHAR,DataFine,103) + ')' Settimana
		,ndg CodiceClienteFEND
		,'Smartworking' TipoCanale	 
		,1 FlagSmartworking
FROM  smartworking
LEFT JOIN QTask on CodiceClienteFEND = ndg
JOIN settimane ON CONVERT(date,smartworking.Data) = settimane.Data
WHERE IdIncarico IS NULL

GO

SELECT * FROM rs.v_CESAM_AZ_Monitoring_Onboarding_Smartworking