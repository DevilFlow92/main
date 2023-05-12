--ALTER VIEW rs.v_CESAM_IW_Fatturazione_Incarichi AS

/*

Autore --> Lorenzo S.
Data Creazione --> 12/09/2018

Utilizzata nel report:
- IWBank - Fatturazione


*/

--PRESA IN CARICO LAVORAZIONE
WITH PrimaLavorazione
AS (SELECT
	L_WorkflowIncarico.IdIncarico,
	RowNum = ROW_NUMBER() OVER (PARTITION BY L_WorkflowIncarico.IdIncarico ORDER BY L_WorkflowIncarico.IdTransizione ASC),
	L_WorkflowIncarico.DataTransizione,
	S_Operatore.Etichetta
FROM L_WorkflowIncarico
JOIN T_Incarico
	ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
JOIN S_Operatore
	ON L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore
	AND (dbo.S_Operatore.CodSede NOT IN (11,2)
	AND dbo.L_WorkflowIncarico.IdOperatore != 12533)
WHERE T_Incarico.CodCliente = 73
AND dbo.T_Incarico.CodTipoIncarico != 93
AND T_Incarico.CodArea = 8),
/*
AND (CodStatoWorkflowIncaricoPartenza = 6500
AND CodStatoWorkflowIncaricoDestinazione != 6500)
*/

Sospeso
AS (SELECT
	L_WorkflowIncarico.IdIncarico,
	RowNum = ROW_NUMBER() OVER (PARTITION BY L_WorkflowIncarico.IdIncarico ORDER BY L_WorkflowIncarico.IdTransizione DESC),
	DataTransizione AS DataSospeso,
	S_Operatore.Etichetta
FROM L_WorkflowIncarico
JOIN T_Incarico
	ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
JOIN S_Operatore
	ON L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore
WHERE T_Incarico.CodCliente = 73
AND dbo.T_Incarico.CodTipoIncarico != 93
AND T_Incarico.CodArea = 8
AND (CodStatoWorkflowIncaricoDestinazione = 6594 --Sospesa - In Attesa di Riscontro
AND CodStatoWorkflowIncaricoPartenza != 6594))

,Pre_Vista AS (

SELECT DISTINCT

	CASE 
		WHEN T_R_Incarico_SubIncarico.IdIncarico IS NOT NULL THEN master.DataCreazione 
		ELSE ISNULL(CONVERT(DATETIME,DataCreazione.Testo,105),T_Incarico.DataCreazione) 
		END DataCreazione,
	ISNULL(CONVERT(DATETIME,DataCreazione.Testo,105),dbo.T_Incarico.DataCreazione) DataCreazioneSLA,
	rs.DateAdd_GiorniLavorativi(73, ISNULL(CONVERT(DATETIME,DataCreazione.Testo,105),dbo.T_Incarico.DataCreazione), 1) DataSLAOK,
	T_Incarico.IdIncarico,
	T_Incarico.CodTipoIncarico,
	T_Incarico.ChiaveCliente ChiaveClienteIncarico,
	IncaricoSW.TipoIncarico,
	IncaricoSW.CodStatoWorkflowIncarico,
	IIF(T_Incarico.CodStatoWorkflowIncarico IN (15395,15474), D_StatoWorkflowIncarico.Descrizione, D_MacroStatoWorkflowIncarico.Descrizione) AS MacroStatoWorkflowIncarichi,
	IncaricoSW.StatoWorkflowIncarico,
	ISNULL(Anagrafica.IdPersona, T_Incarico.IdIncarico) IdPersona,
	Anagrafica.ChiaveClienteIntestatario ChiaveCliente,
	ISNULL(Anagrafica.CognomeIntestatario, '') + SPACE(1) + ISNULL(Anagrafica.NomeIntestatario, '') + SPACE(1) + ISNULL(Anagrafica.RagioneSocialeIntestatario, '') AS AnagraficaCliente,
	SiSLA.Testo SlaLavorazione,
	PrimaLavorazione.DataTransizione DataLavorazione,
	PrimaLavorazione.Etichetta OP_PrimaLavorazione,
	Sospeso.DataSospeso,
	Sospeso.Etichetta OP_Sospeso,
	UltimaLavorazione.DataTransizione DataUltimaLavorazione,
	S_Operatore.Etichetta OP_UltimaLavorazione

	/*
	IIF(T_Incarico.CodTipoIncarico = 288, 
		IIF(DENSE_RANK() OVER (PARTITION BY Anagrafica.idpersona ORDER BY IdPersona) > 1, 0, 1), 
		IIF(DENSE_RANK() OVER (PARTITION BY T_Incarico.IdIncarico ORDER BY T_Incarico.IdIncarico) > 1, 0, 1)) Conteggio,

	IIF(T_Incarico.CodTipoIncarico = 288, 
		IIF(DENSE_RANK() OVER (PARTITION BY Anagrafica.idpersona ORDER BY IdPersona) > 1, 0, 
		CASE 
    	WHEN T_Incarico.CodTipoIncarico IN (91,288,431)
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 10.25
		WHEN T_Incarico.CodTipoIncarico IN (91,288,431)
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 1.54
		WHEN T_Incarico.CodTipoIncarico IN (429,432)
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 1.52
		WHEN T_Incarico.CodTipoIncarico IN (429,432)
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 0.23
		WHEN T_Incarico.CodTipoIncarico = 44
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 7.66
		WHEN T_Incarico.CodTipoIncarico = 44
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 1.15
		WHEN T_Incarico.CodTipoIncarico = 368
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 31.93
		WHEN T_Incarico.CodTipoIncarico = 368
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 4.79
		WHEN T_Incarico.CodTipoIncarico IN (369,508)
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 22.13
		WHEN T_Incarico.CodTipoIncarico IN (369,508)
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 3.32
		WHEN T_Incarico.CodTipoIncarico = 507
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 16.72
		WHEN T_Incarico.CodTipoIncarico = 507
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 2.51
		END), 
		IIF(DENSE_RANK() OVER (PARTITION BY T_Incarico.IdIncarico ORDER BY T_Incarico.IdIncarico) > 1, 0,
		CASE 
    	WHEN T_Incarico.CodTipoIncarico IN (91,288,431)
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 10.25
		WHEN T_Incarico.CodTipoIncarico IN (91,288,431)
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 1.54
		WHEN T_Incarico.CodTipoIncarico IN (429,432)
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 1.52
		WHEN T_Incarico.CodTipoIncarico IN (429,432)
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 0.23
		WHEN T_Incarico.CodTipoIncarico = 44
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 7.66
		WHEN T_Incarico.CodTipoIncarico = 44
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 1.15
		WHEN T_Incarico.CodTipoIncarico = 368
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 31.93
		WHEN T_Incarico.CodTipoIncarico = 368
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 4.79
		WHEN T_Incarico.CodTipoIncarico IN (369,508)
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 22.13
		WHEN T_Incarico.CodTipoIncarico IN (369,508)
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 3.32
		WHEN T_Incarico.CodTipoIncarico = 507
			AND T_Incarico.CodStatoWorkflowIncarico != 15395 THEN 16.72
		WHEN T_Incarico.CodTipoIncarico = 507
			AND T_Incarico.CodStatoWorkflowIncarico = 15395 THEN 2.51
		END)) Prezzo
		*/

FROM T_Incarico

LEFT JOIN T_R_Incarico_SubIncarico
	ON T_Incarico.IdIncarico = T_R_Incarico_SubIncarico.IdSubIncarico
LEFT JOIN T_Incarico master
	ON master.IdIncarico = T_R_Incarico_SubIncarico.IdIncarico
LEFT JOIN PrimaLavorazione AS PrimaLavMaster
	ON PrimaLavMaster.IdIncarico = master.IdIncarico
	AND PrimaLavMaster.RowNum = 2
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico IncaricoSW
	ON T_Incarico.IdIncarico = IncaricoSW.IdIncarico
JOIN D_MacroStatoWorkflowIncarico
	ON D_MacroStatoWorkflowIncarico.Codice = IncaricoSW.CodMacroStatoWFIncarico
JOIN D_StatoWorkflowIncarico
	ON T_Incarico.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore Anagrafica
	ON T_Incarico.IdIncarico = Anagrafica.IdIncarico

--PRESA IN CARICO LAVORAZIONE (
LEFT JOIN PrimaLavorazione
	ON PrimaLavorazione.IdIncarico = T_Incarico.IdIncarico
	AND PrimaLavorazione.RowNum = 2

--SOSPENSIONE
LEFT JOIN Sospeso
	ON T_Incarico.IdIncarico = Sospeso.IdIncarico
	AND Sospeso.RowNum = 1

--DATI AGGIUNTIVI - NO SLA LAVORAZIONE
LEFT JOIN T_DatoAggiuntivo NoSLA
	ON T_Incarico.IdIncarico = NoSLA.IdIncarico
	AND NoSLA.FlagAttivo = 1
	AND CodTipoDatoAggiuntivo <> 1209

--DATI AGGIUNTIVI - SI LA LAVORAZIONE
LEFT JOIN T_DatoAggiuntivo SiSLA
	ON T_Incarico.IdIncarico = SiSLA.IdIncarico
	AND SiSLA.FlagAttivo = 1
	AND SiSLA.CodTipoDatoAggiuntivo = 1209
LEFT JOIN D_TipoDatoAggiuntivo
	ON D_TipoDatoAggiuntivo.Codice = NoSLA.CodTipoDatoAggiuntivo

--DATA CREAZIONE DA DATO AGGIUNTIVO
LEFT JOIN T_DatoAggiuntivo DataCreazione
	ON T_Incarico.IdIncarico = DataCreazione.IdIncarico
	AND DataCreazione.CodTipoDatoAggiuntivo = 1205
	AND DataCreazione.FlagAttivo = 1

--ULTIMA LAVORAZIONE
LEFT JOIN L_WorkflowIncarico UltimaLavorazione
	ON T_Incarico.IdIncarico = UltimaLavorazione.IdIncarico
	AND UltimaLavorazione.DataTransizione = T_Incarico.DataUltimaTransizione
LEFT JOIN S_Operatore
	ON UltimaLavorazione.IdOperatore = S_Operatore.IdOperatore 

WHERE T_Incarico.CodCliente = 73
AND dbo.T_Incarico.CodTipoIncarico != 93
AND T_Incarico.CodArea = 8
AND T_Incarico.FlagArchiviato = 0
AND T_Incarico.CodStatoWorkflowIncarico NOT IN (440)
--AND T_Incarico.IdIncarico = 13494052
--AND dbo.T_Incarico.DataCreazione >= '20200101' 
--AND dbo.T_Incarico.DataCreazione < '20200201'

)

,Vista AS (

SELECT 	Pre_Vista.DataCreazione,
		Pre_Vista.DataCreazioneSLA,
		Pre_Vista.DataSLAOK,
		Pre_Vista.IdIncarico,
		Pre_Vista.CodTipoIncarico,
		Pre_Vista.ChiaveClienteIncarico,
		Pre_Vista.TipoIncarico,
		Pre_Vista.CodStatoWorkflowIncarico,
		Pre_Vista.MacroStatoWorkflowIncarichi,
		Pre_Vista.StatoWorkflowIncarico,
		Pre_Vista.IdPersona,
		Pre_Vista.ChiaveCliente,
		Pre_Vista.AnagraficaCliente,
		Pre_Vista.SlaLavorazione,
		Pre_Vista.DataLavorazione,
		Pre_Vista.OP_PrimaLavorazione,
		Pre_Vista.DataSospeso,
		Pre_Vista.OP_Sospeso,
		Pre_Vista.DataUltimaLavorazione,
		Pre_Vista.OP_UltimaLavorazione,
		IIF(Pre_Vista.CodTipoIncarico = 288,
		IIF(ROW_NUMBER() OVER (PARTITION BY Pre_Vista.IdIncarico,Pre_Vista.IdPersona ORDER BY Pre_Vista.IdPersona)>1,0,1),
		IIF(ROW_NUMBER() OVER (PARTITION BY Pre_Vista.IdIncarico ORDER BY Pre_Vista.IdIncarico)>1,0,1)) Conteggio
		FROM Pre_Vista

)

SELECT 	Vista.DataCreazione,
		Vista.DataCreazioneSLA,
		Vista.DataSLAOK,
		Vista.IdIncarico,
		Vista.CodTipoIncarico,
		Vista.ChiaveClienteIncarico,
		Vista.TipoIncarico,
		Vista.CodStatoWorkflowIncarico,
		Vista.MacroStatoWorkflowIncarichi,
		Vista.StatoWorkflowIncarico,
		Vista.IdPersona,
		Vista.ChiaveCliente,
		Vista.AnagraficaCliente,
		Vista.SlaLavorazione,
		Vista.DataLavorazione,
		Vista.OP_PrimaLavorazione,
		Vista.DataSospeso,
		Vista.OP_Sospeso,
		Vista.DataUltimaLavorazione,
		Vista.OP_UltimaLavorazione,
		Vista.Conteggio,
		IIF(Vista.Conteggio = 0,0,
		CASE 
    		WHEN Vista.CodTipoIncarico IN (91,288,431)
				AND Vista.CodStatoWorkflowIncarico != 15395 THEN 10.25
			WHEN Vista.CodTipoIncarico IN (91,288,431)
				AND Vista.CodStatoWorkflowIncarico = 15395 THEN 1.54
			WHEN Vista.CodTipoIncarico IN (429,432)
				AND Vista.CodStatoWorkflowIncarico != 15395 THEN 1.52
			WHEN Vista.CodTipoIncarico IN (429,432)
				AND Vista.CodStatoWorkflowIncarico = 15395 THEN 0.23
			WHEN Vista.CodTipoIncarico = 44
				AND Vista.CodStatoWorkflowIncarico != 15395 THEN 7.66
			WHEN Vista.CodTipoIncarico = 44
				AND Vista.CodStatoWorkflowIncarico = 15395 THEN 1.15
			WHEN Vista.CodTipoIncarico = 368
				AND Vista.CodStatoWorkflowIncarico != 15395 THEN 31.93
			WHEN Vista.CodTipoIncarico = 368
				AND Vista.CodStatoWorkflowIncarico = 15395 THEN 4.79
			WHEN Vista.CodTipoIncarico IN (369,508)
				AND Vista.CodStatoWorkflowIncarico != 15395 THEN 22.13
			WHEN Vista.CodTipoIncarico IN (369,508)
				AND Vista.CodStatoWorkflowIncarico = 15395 THEN 3.32
			WHEN Vista.CodTipoIncarico = 507
				AND Vista.CodStatoWorkflowIncarico != 15395 THEN 16.72
			WHEN Vista.CodTipoIncarico = 507
				AND Vista.CodStatoWorkflowIncarico = 15395 THEN 2.51
			END) Prezzo
		FROM Vista

GO