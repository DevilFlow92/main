USE CLC
SELECT DISTINCT
	T_Incarico.IdIncarico
	,DataCreazione
	,descrizioni.TipoIncarico
	,descrizioni.DescrizioneMacroStatoWorkFlowIncarico MacroStatoWorkflow
	,T_Incarico.CodStatoWorkflowIncarico
	,descrizioni.DescrizioneStatoWorkflowIncarico StatoWorkflow
	,anagrafica.ChiaveClienteIntestatario
	,IIF(anagrafica.CognomeIntestatario IS NULL OR anagrafica.CognomeIntestatario = '', anagrafica.RagioneSocialeIntestatario, anagrafica.CognomeIntestatario) + ' ' + ISNULL(anagrafica.NomeIntestatario, '') Intestatario
	,anagrafica.CodicePromotore CodiceConsulente
	,IIF(anagrafica.CognomePromotore IS NULL OR anagrafica.CognomePromotore = '', anagrafica.RagioneSocialePromotore, anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomePromotore, '') Consulente

	,T_Sospeso.IdSospeso
	,D_TipoSospeso.Descrizione TipoSospeso
	,D_StatoSospeso.Descrizione StatoSospeso
	,D_TipoProdotto.Descrizione TipoProdotto
	,D_TipoOperazione.Descrizione TipoOperazione
	,D_MotivazioneSospeso.Descrizione Motivazione
	,D_SottoMotivazioneSospeso.Descrizione SottoMotivazione
	,D_ModalitaSospeso.Descrizione ModalitaSospeso
	,tr.Nota Note

FROM T_Incarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
	ON T_Incarico.IdIncarico = anagrafica.IdIncarico

	AND anagrafica.ProgressivoPersona = 1

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON T_Incarico.IdIncarico = descrizioni.IdIncarico
LEFT JOIN T_Sospeso
	ON T_Incarico.IdIncarico = T_Sospeso.IdIncarico

LEFT JOIN D_StatoSospeso WITH (NOLOCK)
	ON D_StatoSospeso.codice = T_Sospeso.CodStato
LEFT JOIN D_TipoOperazione WITH (NOLOCK)
	ON D_TipoOperazione.codice = T_Sospeso.CodTipoOperazione
LEFT JOIN D_TipoProdotto WITH (NOLOCK)
	ON D_TipoProdotto.Codice = T_Sospeso.CodTipoProdotto
LEFT JOIN D_TipoSospeso WITH (NOLOCK)
	ON D_TipoSospeso.Codice = T_Sospeso.CodTipoSospeso

LEFT JOIN T_R_Sospeso_MotivazioneSottoMotivazioneModalita tr WITH (NOLOCK)
	ON T_Sospeso.IdSospeso = tr.IdSospeso
LEFT JOIN R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso AS CodMSM WITH (NOLOCK)
	ON CodMSM.IdRelazione = tr.IdMotivazioneSottoMotivazioneModalita
LEFT JOIN D_MotivazioneSospeso WITH (NOLOCK)
	ON CodMSM.codmotivazionesospeso = D_MotivazioneSospeso.codice
LEFT JOIN D_SottoMotivazioneSospeso WITH (NOLOCK)
	ON CodMSM.codsottomotivazionesospeso = D_sottoMotivazioneSospeso.codice
LEFT JOIN D_ModalitaSospeso WITH (NOLOCK)
	ON CodMSM.codmodalitasospeso = D_ModalitaSospeso.Codice


WHERE CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico = 463
AND T_Incarico.CodStatoWorkflowIncarico NOT IN (440)
AND descrizioni.CodMacroStatoWFIncarico = 2 --sospesi
