USE CLC
GO


--ALTER VIEW rs.v_CESAM_AZ_ServizioConcierge_ControlloIntegrazioni AS

/*
Author: Lorenzo Fiori
Utilizzata nel report: AZ - Servizio Concierge - Code di Lavorazione
*/


WITH incarichicollegati AS (SELECT
	T_Incarico.IdIncarico
	,T_Incarico.DataCreazione DataCreazioneIncaricoCollegato
	,DataUltimaTransizione
	,CodTipoIncarico
	,CodStatoWorkflowIncarico
	,CodAttributoIncarico
	,idpersona
	,idpromotore
	,T_Documento.Documento_id IdDocumentoCollegato
	,Tipo_Documento CodTipoDocumentoCollegato
	,D_Documento.Descrizione TipoDocumentoCollegato
	,DataInserimento DataInserimentoCollegato
	,S_Operatore.Etichetta OperatoreInserimentoCollegato

FROM T_Incarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore
	ON T_Incarico.IdIncarico = rs.v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico
	AND ProgressivoPersona = 1

JOIN T_Documento
	ON T_Incarico.IdIncarico = T_Documento.IdIncarico
	AND DataInserimento >= --(SELECT rs.DateStrip_GiorniLavorativi(23, GETDATE(), 3))
	DATEADD(DAY,-3,CONVERT(DATE,GETDATE()))
	AND FlagScaduto = 0
	AND FlagPresenzaInFileSystem = 1


JOIN D_Documento
	ON Codice = Tipo_Documento
JOIN S_Operatore
	ON IdOperatoreInserimento = IdOperatore

WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 23

AND CodTipoIncarico <> 517
AND CodStatoWorkflowIncarico <> 440
--AND T_Incarico.IdIncarico = 12015701
)
SELECT
	Concierge.IdIncarico IdIncaricoConcierge
	,anagrafica.ChiaveClienteIntestatario
	,IIF(CognomeIntestatario IS NULL OR CognomeIntestatario = '', RagioneSocialeIntestatario, CognomeIntestatario) + ' ' + ISNULL(NomeIntestatario, '') Intestatario
	,anagrafica.CodicePromotore CodiceConsulente
	,IIF(CognomePromotore IS NULL OR CognomePromotore = '', RagioneSocialeIntestatario, CognomePromotore) + ' ' + ISNULL(NomePromotore, '') Consulente
	,incarichicollegati.IdIncarico IdIncaricoCollegato
	,incarichicollegati.CodTipoIncarico CodTipoIncaricoCollegato
	,dticollegato.Descrizione TipoIncaricoCollegato
	,IIF(tdoc.Documento_id IS NOT NULL, 1, 0) IntegrazioniServizioConcierge
	,IIF(incarichicollegati.IdIncarico IS NOT NULL, 1, 0) IntegrazioniIncaricoCollegato
	,IdDocumentoCollegato
	,CodTipoDocumentoCollegato
	,TipoDocumentoCollegato
	,DataInserimentoCollegato
	,OperatoreInserimentoCollegato

	,tdoc.Documento_id IdDocumentoConcierge
	,tdoc.Tipo_Documento CodTipoDocumentoConcierge
	,ddoc.Descrizione TipoDocumentoConcierge
	,tdoc.DataInserimento DataInserimentoDocumentoConcierge
	,so.Etichetta OperatoreInserimentoDocumentoConcierge

FROM T_Incarico Concierge
JOIN D_StatoWorkflowIncarico StatoWfConcierge
	ON Concierge.CodStatoWorkflowIncarico = StatoWfConcierge.Codice
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rwfconcierge
	ON StatoWfConcierge.Codice = rwfconcierge.CodStatoWorkflowIncarico
	AND Concierge.CodCliente = rwfconcierge.CodCliente
	AND Concierge.CodTipoIncarico = rwfconcierge.CodTipoIncarico
JOIN D_MacroStatoWorkflowIncarico macroConcierge
	ON rwfconcierge.CodMacroStatoWorkflowIncarico = macroConcierge.Codice

JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
	ON Concierge.IdIncarico = anagrafica.IdIncarico
	AND anagrafica.ProgressivoPersona = 1

LEFT JOIN incarichicollegati
	ON incarichicollegati.idpersona = anagrafica.idpersona
--AND anagrafica.idpromotore = incarichicollegati.idpromotore

LEFT JOIN D_TipoIncarico dticollegato
	ON incarichicollegati.CodTipoIncarico = dticollegato.Codice

LEFT JOIN T_Documento tdoc
	ON Concierge.IdIncarico = tdoc.IdIncarico
	AND tdoc.FlagPresenzaInFileSystem = 1
	AND tdoc.FlagScaduto = 0
	AND DataInserimento >= --(SELECT rs.DateStrip_GiorniLavorativi(23,GETDATE(),3))
	DATEADD(DAY,-3,GETDATE())

LEFT JOIN D_Documento ddoc
	ON tdoc.Tipo_Documento = ddoc.Codice
LEFT JOIN S_Operatore so
	ON tdoc.IdOperatoreInserimento = so.IdOperatore
WHERE Concierge.CodCliente = 23
AND Concierge.CodArea = 8
AND Concierge.CodTipoIncarico = 517

AND Concierge.CodStatoWorkflowIncarico <> 820
AND rwfconcierge.CodMacroStatoWorkflowIncarico <> 13

AND (incarichicollegati.IdIncarico IS NOT NULL
OR tdoc.Documento_id IS NOT NULL)


GO

