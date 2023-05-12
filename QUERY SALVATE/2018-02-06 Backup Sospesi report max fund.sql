--backup query sospesi REPORT OPERAZIONI MAX FUND
USE CLC

SELECT
	T_DatiAggiuntiviIncaricoAzimut.IdIncarico
   ,T_OperazioneAzimut.IdOperazioneAzimut
   ,E_ProdottoAzimut.Isin
   ,D_TipoIncarico.Descrizione
   ,primo.ChiaveCliente
   ,primo.Cognome + ' ' + primo.Nome AS cliente
   ,T_Mandato.DataSottoscrizione
   ,T_OperazioneAzimut.Importo
   ,T_Mandato.NumeroMandato
   ,T_Mandato.NumeroContratto AS MandatoRTO
   ,T_DatiAggiuntiviIncaricoAzimut.NumeroRaccomandazione
   ,D_TipoRaccomandazione.Descrizione AS Expr1
   ,D_TipoFea.Descrizione AS Expr2
   ,T_DatiAggiuntiviIncaricoAzimut.CodTipoFea
   ,CONVERT(VARCHAR(10), GETDATE(), 112) AS DataOggi
FROM T_Incarico
INNER JOIN D_TipoIncarico
	ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico
INNER JOIN T_R_Incarico_Mandato
	ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
INNER JOIN T_Mandato
	ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
INNER JOIN T_Dossier
	ON T_Dossier.IdDossier = T_Mandato.IdDossier
INNER JOIN T_R_Dossier_Persona AS dossier1
	ON dossier1.IdDossier = T_Dossier.IdDossier
		AND dossier1.Progressivo = 1
INNER JOIN T_Persona AS primo
	ON primo.IdPersona = dossier1.IdPersona
INNER JOIN T_OperazioneAzimut
	ON T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico
INNER JOIN T_DatiAggiuntiviIncaricoAzimut
	ON T_Incarico.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico
INNER JOIN D_TipoRaccomandazione
	ON T_DatiAggiuntiviIncaricoAzimut.CodTipoRaccomandazione = D_TipoRaccomandazione.Codice
LEFT OUTER JOIN D_TipoFea
	ON T_DatiAggiuntiviIncaricoAzimut.CodTipoFea = D_TipoFea.Codice
INNER JOIN E_ProdottoAzimut
	ON T_OperazioneAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut
LEFT OUTER JOIN (SELECT
		T_Incarico_1.IdIncarico
	   ,MAX(T_Incarico_1.DataUltimaTransizione) AS DataUltimaTransizione
	FROM L_WorkflowIncarico
	INNER JOIN T_Incarico AS T_Incarico_1
		ON L_WorkflowIncarico.IdIncarico = T_Incarico_1.IdIncarico
	INNER JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
		ON T_Incarico_1.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
		AND T_Incarico_1.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
		AND L_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
	WHERE (T_Incarico_1.CodCliente = 23)
	AND (T_Incarico_1.CodTipoIncarico IN (321, 322))
	AND (R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodMacroStatoWorkflowIncarico = 2)
	GROUP BY T_Incarico_1.IdIncarico) AS wf
	ON wf.IdIncarico = T_Incarico.IdIncarico
INNER JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow AS R_Cliente_TipoIncarico_MacroStatoWorkFlow_1
	ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow_1.CodCliente
		AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow_1.CodTipoIncarico
		AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow_1.CodStatoWorkflowIncarico
LEFT OUTER JOIN T_Documento
	ON T_Incarico.IdIncarico = T_Documento.IdIncarico
LEFT OUTER JOIN (SELECT
		MAX(DataTransizione) AS m
	   ,IdIncarico
	FROM L_WorkflowIncarico AS L_WorkflowIncarico_1
	WHERE (CodStatoWorkflowIncaricoDestinazione = 8500)
	GROUP BY IdIncarico) AS l
	ON l.IdIncarico = T_Incarico.IdIncarico
WHERE (T_Incarico.CodCliente = 23)
AND (T_Incarico.CodArea = 8)
AND (T_Incarico.CodTipoIncarico IN (321, 322))
AND (T_DatiAggiuntiviIncaricoAzimut.CodTipoRaccomandazione = 2)
AND (T_Incarico.CodStatoWorkflowIncarico NOT IN (820, 14337, 6603, 6604, 6605, 8570, 14336))
AND (l.m >= @Ieri)
AND (l.m <= @Oggi)