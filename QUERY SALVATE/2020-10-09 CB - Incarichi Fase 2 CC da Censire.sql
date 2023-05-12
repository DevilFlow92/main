USE clc

GO

SELECT T_Incarico.IdIncarico
FROM T_Incarico
JOIN T_MacroControllo ON T_Incarico.IdIncarico = T_MacroControllo.IdIncarico
AND IdTipoMacroControllo = 3205
JOIN T_Controllo ON T_MacroControllo.IdMacroControllo = T_Controllo.IdMacroControllo
AND IdTipoControllo = 8327
AND CodGiudizioControllo = 4
LEFT JOIN (SELECT MIN(IdTransizione) IdTransizione, L_WorkflowIncarico.IdIncarico FROM  L_WorkflowIncarico 
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48 AND CodTipoIncarico = 613
			WHERE CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione = 20977
			GROUP BY L_WorkflowIncarico.IdIncarico

) inputpayload ON T_Incarico.IdIncarico = inputpayload.IdIncarico
LEFT JOIN L_WorkflowIncarico payload ON inputpayload.IdTransizione = payload.IdTransizione

LEFT JOIN (SELECT MAX(IdTransizione) IdTransizione, L_WorkflowIncarico.IdIncarico
			FROM  L_WorkflowIncarico
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48 AND CodTipoIncarico = 613
			WHERE CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione = 14275
			GROUP BY L_WorkflowIncarico.IdIncarico
			) inputeffettutate ON T_Incarico.IdIncarico = inputeffettutate.IdIncarico

LEFT JOIN L_WorkflowIncarico effettuate ON inputeffettutate.IdTransizione = effettuate.IdTransizione

WHERE CodCliente = 48
AND CodArea = 8
AND CodTipoIncarico = 613
AND (
		(payload.DataTransizione >= '20200901' AND payload.DataTransizione < '20201001')
	 OR (effettuate.DataTransizione >= '20200901' AND effettuate.DataTransizione < '20201001'
			AND payload.IdTransizione IS NULL
		)
)
