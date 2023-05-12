USE CLC
GO

--Fase 1 giro logistico
SELECT T_Incarico.IdIncarico 
FROM T_Incarico
WHERE CodArea = 8
AND CodCliente = 48
AND CodTipoIncarico = 613 
AND DataCreazione >= '20200901' AND DataCreazione < '20201001'

SELECT * FROM rs.v_CESAM_CB_Fatturazione_Processo_2020
WHERE Fase1 = 1 AND CodTipoIncarico = 613 AND LavorazioneFase1 >= '20200901' AND LavorazioneFase1 < '20201001'


--Fase 1 processo digitale
SELECT  T_Incarico.IdIncarico 
FROM T_Incarico
LEFT JOIN (SELECT ti.IdIncarico
FROM T_Incarico ti
LEFT JOIN (SELECT MIN(IdTransizione) IdTransizione, tix.IdIncarico
			FROM L_WorkflowIncarico lwi
			JOIN T_Incarico tix ON lwi.idincarico = tix.IdIncarico
			WHERE tix.CodArea = 8
			AND tix.CodCliente = 48
			AND tix.CodTipoIncarico IN ( 611,682)
			AND lwi.idoperatore != 21
			AND lwi.CodStatoWorkflowIncaricoDestinazione = 6500
			GROUP BY tix.IdIncarico
) creazioneManuale ON ti.IdIncarico = creazioneManuale.IdIncarico
WHERE ti.CodCliente = 48
AND ti.CodArea = 8
AND ti.CodTipoIncarico IN ( 611,682)
AND creazioneManuale.IdTransizione IS NOT NULL
AND ti.DataCreazione >= '20200615') GiaClienti ON T_Incarico.IdIncarico = GiaClienti.IdIncarico
WHERE CodArea = 8
AND CodCliente = 48
AND CodTipoIncarico = 611
AND GiaClienti.IdIncarico IS NULL
AND DataCreazione >= '20200901' AND DataCreazione < '20201001'


