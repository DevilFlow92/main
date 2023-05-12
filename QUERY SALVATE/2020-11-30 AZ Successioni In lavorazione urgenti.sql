USE CLC
GO




SELECT ti.IdIncarico
,ti.ChiaveCliente
,ti.DataCreazione
,Urgenza.DataTransizione DataUrgenza
,tda.CodTipoDatoAggiuntivo
,Descrizione
,tda.Testo

FROM T_Incarico ti 
JOIN (
		SELECT MAX(lwi1.DataTransizione) DataTransizione, ti1.IdIncarico
		FROM L_WorkflowIncarico lwi1
		JOIN T_Incarico ti1 ON lwi1.idincarico = ti1.IdIncarico
		AND ti1.CodArea = 8 AND ti1.CodCliente = 23 AND ti1.CodTipoIncarico = 54
		WHERE (lwi1.FlagUrgentePartenza IS NULL OR lwi1.FlagUrgentePartenza = 0)
		AND lwi1.flagurgentedestinazione = 1
		GROUP BY ti1.IdIncarico
) Urgenza ON ti.IdIncarico = Urgenza.IdIncarico

JOIN T_DatoAggiuntivo tda ON ti.IdIncarico = tda.IdIncarico
AND tda.FlagAttivo = 1
JOIN D_TipoDatoAggiuntivo ON tda.CodTipoDatoAggiuntivo = D_TipoDatoAggiuntivo.Codice

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 54
AND ti.CodStatoWorkflowIncarico = 6510	--In lavorazione
AND ti.flagurgente = 1