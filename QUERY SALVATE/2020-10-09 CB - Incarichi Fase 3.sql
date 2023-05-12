USE clc
GO

SELECT T_Incarico.IdIncarico
FROM T_Incarico 
JOIN T_MacroControllo ON T_Incarico.IdIncarico = T_MacroControllo.IdIncarico
AND IdTipoMacroControllo = 3205
JOIN T_Controllo ON T_MacroControllo.IdMacroControllo = T_Controllo.IdMacroControllo
AND IdTipoControllo = 8327
AND CodGiudizioControllo IN (2,4)
LEFT JOIN (SELECT MAX(IdTransizione) IdTransizione, L_WorkflowIncarico.IdIncarico FROM  L_WorkflowIncarico 
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48 AND CodTipoIncarico = 613
			WHERE CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione = 14276 --ContoCorrenteAttivo
			GROUP BY L_WorkflowIncarico.IdIncarico

) inputCCAttivo ON T_Incarico.IdIncarico = inputCCAttivo.IdIncarico
LEFT JOIN L_WorkflowIncarico ccAttivo ON inputCCAttivo.IdTransizione = ccAttivo.IdTransizione

LEFT  JOIN (SELECT MAX(IdTransizione) IdTransizione, L_WorkflowIncarico.IdIncarico
			FROM  L_WorkflowIncarico
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48 AND CodTipoIncarico IN (613)
			--AND L_WorkflowIncarico.IdIncarico = 15212756  
			WHERE CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione = 14275
			GROUP BY L_WorkflowIncarico.IdIncarico
			) inputeffettutate ON T_Incarico.IdIncarico = inputeffettutate.IdIncarico

 LEFT JOIN L_WorkflowIncarico effettuate ON inputeffettutate.IdTransizione = effettuate.IdTransizione

WHERE T_Incarico.CodArea = 8
AND CodCliente = 48
AND CodTipoIncarico IN (613)
AND (
		(ccAttivo.DataTransizione >= '20200901' AND ccAttivo.DataTransizione < '20201001')
	 OR (effettuate.DataTransizione >= '20200901' AND effettuate.DataTransizione < '20201001'
			AND ccAttivo.IdTransizione IS NULL
		)
)
--AND T_Incarico.IdIncarico = 15212756 

UNION 

SELECT T_Incarico.IdIncarico
FROM T_Incarico
LEFT JOIN (SELECT MAX(IdTransizione) IdTransizione, L_WorkflowIncarico.IdIncarico FROM  L_WorkflowIncarico 
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48 AND CodTipoIncarico = 611
			WHERE CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione = 14276 --ContoCorrenteAttivo
			GROUP BY L_WorkflowIncarico.IdIncarico

) inputCCAttivo ON T_Incarico.IdIncarico = inputCCAttivo.IdIncarico
LEFT JOIN L_WorkflowIncarico ccAttivo ON inputCCAttivo.IdTransizione = ccAttivo.IdTransizione

LEFT  JOIN (SELECT MAX(IdTransizione) IdTransizione, L_WorkflowIncarico.IdIncarico
			FROM  L_WorkflowIncarico
			JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			AND CodArea = 8 AND CodCliente = 48 AND CodTipoIncarico IN (611)
			--AND L_WorkflowIncarico.IdIncarico = 15603136 
			WHERE CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
			AND CodStatoWorkflowIncaricoDestinazione = 14275
			GROUP BY L_WorkflowIncarico.IdIncarico
			) inputeffettutate ON T_Incarico.IdIncarico = inputeffettutate.IdIncarico

LEFT JOIN L_WorkflowIncarico effettuate ON inputeffettutate.IdTransizione = effettuate.IdTransizione

WHERE T_Incarico.CodArea = 8
AND CodCliente = 48
AND CodTipoIncarico IN (611)
AND (
		(ccAttivo.DataTransizione >= '20200901' AND ccAttivo.DataTransizione < '20201001')
	 OR (effettuate.DataTransizione >= '20200901' AND effettuate.DataTransizione < '20201001'
			AND ccAttivo.IdTransizione IS NULL
		)
)