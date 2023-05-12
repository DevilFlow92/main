USE CLC
GO

WITH sospesi AS (

SELECT
	tix.IdIncarico
	,tix.CodCliente
	,tix.CodTipoIncarico
	,COUNT(lwi.IdTransizione) N
FROM T_Incarico tix
JOIN L_WorkflowIncarico lwi
	ON tix.IdIncarico = lwi.IdIncarico
WHERE tix.CodArea = 8
AND tix.CodCliente = 48
AND tix.CodTipoIncarico IN (611, 613)
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione IN (15468	--Mancata attivazione accordo
, 8611 --In attesa di riscontro banca
, 14332      --Documentale
, 14334      --Errore tecnico
)
AND tix.DataCreazione >= '20200615'
GROUP BY 	tix.IdIncarico
	,tix.CodCliente
	,tix.CodTipoIncarico

HAVING COUNT(lwi.IdTransizione) > 1

)

SELECT 	sospesi.IdIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		,ProgressivoSospeso = ROW_NUMBER() OVER (PARTITION BY sospesi.IdIncarico ORDER BY sospesi.IdIncarico, IdTransizione)
		,D_StatoWorkflowIncarico.Descrizione TipoSospeso
		,DataTransizione DataWFSopeso
FROM sospesi
JOIN L_WorkflowIncarico ON sospesi.IdIncarico = L_WorkflowIncarico.IdIncarico
AND CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
AND CodStatoWorkflowIncaricoDestinazione IN (15468	--Mancata attivazione accordo
, 8611 --In attesa di riscontro banca
, 14332      --Documentale
, 14334      --Errore tecnico
)

JOIN D_TipoIncarico on CodTipoIncarico = D_TipoIncarico.Codice

JOIN D_StatoWorkflowIncarico ON CodStatoWorkflowIncaricoDestinazione = D_StatoWorkflowIncarico.Codice
