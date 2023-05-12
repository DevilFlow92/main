USE CLC
SELECT DISTINCT
T_Incarico.IdIncarico
,DataCreazione
,descrizioni.TipoIncarico
,T_Incarico.CodStatoWorkflowIncarico
,descrizioni.StatoWorkflowIncarico
,anagrafica.ChiaveClienteIntestatario
,anagrafica.RagioneSocialeIntestatario
,anagrafica.CodicePromotore
,anagrafica.CognomePromotore
,anagrafica.NomePromotore
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

JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON T_Incarico.IdIncarico = anagrafica.IdIncarico
AND anagrafica.CodTipoPersona = 2 --Persone Giuridiche
AND anagrafica.ProgressivoPersona = 1

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni on T_Incarico.IdIncarico = descrizioni.IdIncarico
JOIN T_Sospeso ON T_Incarico.IdIncarico = T_Sospeso.IdIncarico

LEFT JOIN D_StatoSospeso  WITH (nolock) ON D_StatoSospeso.codice = T_Sospeso.CodStato
LEFT JOIN D_TipoOperazione   WITH (nolock) ON D_TipoOperazione.codice = T_Sospeso.CodTipoOperazione
LEFT JOIN D_TipoProdotto WITH (nolock) ON D_TipoProdotto.Codice = T_Sospeso.CodTipoProdotto
LEFT JOIN D_TipoSospeso  WITH (nolock) ON D_TipoSospeso.Codice = T_Sospeso.CodTipoSospeso

leFT JOIN T_R_Sospeso_MotivazioneSottoMotivazioneModalita tr WITH (nolock) ON T_Sospeso.IdSospeso = tr.IdSospeso
LEFT JOIN R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso AS CodMSM WITH (nolock) ON CodMSM.IdRelazione = tr.IdMotivazioneSottoMotivazioneModalita
LEFT JOIN D_MotivazioneSospeso WITH (nolock) ON CodMSM.codmotivazionesospeso  = D_MotivazioneSospeso.codice
LEFT JOIN D_SottoMotivazioneSospeso WITH (nolock) ON CodMSM.codsottomotivazionesospeso = D_sottoMotivazioneSospeso.codice
LEFT JOIN D_ModalitaSospeso WITH (nolock) ON CodMSM.codmodalitasospeso = D_ModalitaSospeso.Codice


WHERE CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico = 288

