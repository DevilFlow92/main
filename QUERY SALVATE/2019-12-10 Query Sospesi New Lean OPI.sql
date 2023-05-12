;
WITH sospesiaperti AS (SELECT
	ti.IdIncarico
	,wf.IdTransizione
FROM T_Incarico ti
JOIN (SELECT
	MAX(lwi.IdTransizione) IdTransizione
	,ti.IdIncarico
FROM L_WorkflowIncarico lwi
JOIN T_Incarico ti
	ON lwi.IdIncarico = ti.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND lwi.CodStatoWorkflowIncaricoDestinazione = 8500	--Da Verificare
GROUP BY ti.IdIncarico) wf
	ON ti.IdIncarico = wf.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.DataCreazione >= '20190101'),
regolarizzati AS (SELECT
	ti.IdIncarico
	,wf.IdTransizione
FROM T_Incarico ti
JOIN (SELECT
	MAX(lwi.IdTransizione) IdTransizione
	,ti.IdIncarico
FROM L_WorkflowIncarico lwi
JOIN T_Incarico ti
	ON lwi.IdIncarico = ti.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND lwi.CodStatoWorkflowIncaricoDestinazione = 6560	--Regolarizzata
GROUP BY ti.IdIncarico) wf
	ON ti.IdIncarico = wf.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.DataCreazione >= '20190101'),
sospesi AS (SELECT
	MAX(lwi.IdTransizione) IdTransizione
	,ti.IdIncarico
	,'Sospesa - Da Verificare --> In Gestione' TipoCasistica
FROM L_WorkflowIncarico lwi
JOIN T_Incarico ti
	ON lwi.IdIncarico = ti.IdIncarico
	AND ti.CodArea = 8
	AND ti.CodCliente = 23
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rdestinazione
	ON lwi.CodStatoWorkflowIncaricoDestinazione = rdestinazione.CodStatoWorkflowIncarico
	AND ti.CodCliente = rdestinazione.CodCliente
	AND ti.CodTipoIncarico = rdestinazione.CodTipoIncarico

WHERE lwi.CodStatoWorkflowIncaricoPartenza = 8500 --Da Verificare
AND rdestinazione.CodMacroStatoWorkflowIncarico = 9 --In Gestione
AND ti.DataCreazione >= '20190101'
GROUP BY ti.IdIncarico

UNION ALL

SELECT
	MAX(lwi.IdTransizione) IdTransizione
	,ti.IdIncarico
	,'Sospesa - Regolarizzata --> Sospesa' tipocasistica
FROM L_WorkflowIncarico lwi
JOIN T_Incarico ti
	ON lwi.IdIncarico = ti.IdIncarico
	AND ti.CodArea = 8
	AND ti.CodCliente = 23
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rdestinazione
	ON lwi.CodStatoWorkflowIncaricoDestinazione = rdestinazione.CodStatoWorkflowIncarico
	AND ti.CodCliente = rdestinazione.CodCliente
	AND ti.CodTipoIncarico = rdestinazione.CodTipoIncarico

WHERE lwi.CodStatoWorkflowIncaricoPartenza = 6560	--Regolarizzata
AND lwi.CodStatoWorkflowIncaricoDestinazione <> 6560 --rego
AND rdestinazione.CodMacroStatoWorkflowIncarico = 2 --rimane in sospesa (torno indietro con l'incarico)
AND ti.DataCreazione >= '20190101'
GROUP BY ti.IdIncarico)

SELECT
	ti.IdIncarico
	,ti.DataCreazione
	,CAST(YEAR(ti.DataCreazione) AS VARCHAR(4)) + ' - ' + CAST(format(MONTH(ti.DataCreazione), 'd2') AS VARCHAR(2)) PeriodoCreazione

	,d.TipoIncarico
	,d.StatoWorkflowIncarico StatoAttuale

	,van.ChiaveClienteIntestatario + ' - '
	+ CASE
		WHEN van.CognomeIntestatario IS NULL OR
			van.CognomeIntestatario = '' THEN van.RagioneSocialeIntestatario
		ELSE van.CognomeIntestatario + ' ' + ISNULL(van.NomeIntestatario, '')
	END PrimoIntestatario

	,van.CodicePromotore + ' - ' +
	CASE
		WHEN van.CognomePromotore IS NULL OR
			van.CognomePromotore = '' THEN van.RagioneSocialePromotore
		ELSE van.CognomePromotore + ' ' + ISNULL(van.NomePromotore, '')
	END Consulente
	,van.DescrizioneCentroRaccolta CentroRaccolta
	,van.DescrizioneAreaCentroRaccolta AreaCentroRaccolta
	,van.DescrizioneSim Sim

	,IIF(sospesiaperti.IdTransizione IS NOT NULL, 1, 0) SospesoAperto
	,IIF(regolarizzati.IdTransizione IS NOT NULL, 1, 0) Regolarizzato
	,TipoCasistica

FROM T_Incarico ti

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d
	ON ti.IdIncarico = d.IdIncarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van
	ON ti.IdIncarico = van.IdIncarico
	AND van.ProgressivoPersona = 1

JOIN sospesiaperti
	ON ti.IdIncarico = sospesiaperti.IdIncarico
LEFT JOIN regolarizzati
	ON ti.IdIncarico = regolarizzati.IdIncarico
LEFT JOIN sospesi
	ON ti.IdIncarico = sospesi.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
--AND ti.IdIncarico = 11522615

--and TipoCasistica IS NULL