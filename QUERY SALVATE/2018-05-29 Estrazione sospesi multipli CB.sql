WITH cte AS 
(
	SELECT T_Sospeso.IdIncarico
	FROM T_Sospeso
	JOIN T_Incarico ON T_Sospeso.IdIncarico = T_Incarico.IdIncarico
	WHERE CodArea = 8
	AND CodCliente = 48
	AND CodTipoIncarico in (331,334,335,359,378)
	GROUP BY T_Sospeso.IdIncarico
	HAVING COUNT(IdSospeso) > 1
	
)
SELECT 	T_Incarico.IdIncarico,
		--T_Incarico.CodTipoIncarico,
		descrizioni.TipoIncarico [Tipo Incarico],
		--CodStatoWorkflowIncarico,
		descrizioni.StatoWorkflowIncarico [Stato Workflow],
		DataCreazione,		
		T_Sospeso.IdSospeso,
		apertura.DataModifica [Data Inserimento Sospeso],
		ISNULL(ultimamodifica.DataModifica, apertura.DataModifica) [Data UltimaModifica Sospeso],
		--CodTipoSospeso,
		--CodStato,
		D_StatoSospeso.Descrizione [Stato Sospeso],
		Nota [Nota Sospeso]
		 
FROM T_Incarico
JOIN cte on T_Incarico.IdIncarico = cte.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON T_Incarico.IdIncarico = descrizioni.IdIncarico

JOIN T_Sospeso ON T_Incarico.IdIncarico = T_Sospeso.IdIncarico
JOIN T_R_Sospeso_MotivazioneSottoMotivazioneModalita ON T_Sospeso.IdSospeso = T_R_Sospeso_MotivazioneSottoMotivazioneModalita.IdSospeso
JOIN D_StatoSospeso ON T_Sospeso.CodStato = D_StatoSospeso.Codice
JOIN storico.V_Log_T_Sospeso apertura ON T_Sospeso.IdSospeso = apertura.IdSospeso and CodTipoModifica = 1 
LEFT JOIN (SELECT MAX(IdLog) idlog, IdSospeso 
		FROM storico.V_Log_T_Sospeso
		WHERE CodTipoModifica = 2
		GROUP BY IdSospeso ) inputultimamodifica ON inputultimamodifica.IdSospeso = T_Sospeso.IdSospeso
LEFT JOIN storico.V_Log_T_Sospeso ultimamodifica ON inputultimamodifica.idlog = ultimamodifica.IdLog

WHERE T_Incarico.DataCreazione >= '20180501'


