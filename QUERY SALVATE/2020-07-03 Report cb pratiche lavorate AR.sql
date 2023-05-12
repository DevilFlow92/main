
--20978	Contratto Censito
--20979	Contratto da Censire

SELECT ti.IdIncarico
,ti.DataCreazione
,dti.Descrizione TipoIncarico
,lwi.DataTransizione DataTransizione
,'In Gestione' + ' - ' + dstato.Descrizione StatoDestinazione
,so.Etichetta OperatoreTransizione
,dsede.Descrizione SedeOperatore

FROM T_Incarico ti
JOIN D_TipoIncarico dti ON ti.CodTipoIncarico = dti.Codice

JOIN L_WorkflowIncarico lwi ON ti.IdIncarico = lwi.IdIncarico
AND lwi.CodStatoWorkflowIncaricoPartenza <> lwi.CodStatoWorkflowIncaricoDestinazione
AND lwi.CodStatoWorkflowIncaricoDestinazione in (8570,20978,20979)

JOIN D_StatoWorkflowIncarico dstato ON dstato.Codice = lwi.CodStatoWorkflowIncaricoDestinazione


JOIN S_Operatore so ON lwi.IdOperatore = so.IdOperatore
JOIN D_SedeOperatore dsede ON so.CodSede = dsede.Codice

WHERE ti.CodArea = 8
AND ti.CodCliente = 48
AND ti.CodTipoIncarico in (611,613)
AND lwi.DataTransizione >= '20200601'
AND so.CodSede <> 1


