USE CLC
GO

--SELECT * FROM D_StatoWorkflowIncarico
--JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow ON Codice = CodStatoWorkflowIncarico
--and CodCliente = 23 AND CodTipoIncarico = 66 

--WHERE Descrizione like '%valutazione%'

--SELECT * FROM D_AttributoIncarico
--JOIN R_Cliente_Attributo on Codice = CodAttributo and CodCliente = 23 and CodTipoIncarico = 66



SELECT ti.IdIncarico, ti.DataCreazione
	,ti.FlagArchiviato
	,descrizioni.StatoWorkflowIncarico
	,D_MotivoVerifica.Descrizione MotivoVerifica
	,D_SanatoriaFiscale.Descrizione SanatoriaFiscale
	,van.idpersona
	,ISNULL(van.ChiaveClienteIntestatario,'') + ' - ' 
		+ IIF(van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = '',van.RagioneSocialeIntestatario,van.CognomeIntestatario)
		+ ' ' + ISNULL(van.NomeIntestatario,'') Anagrafica
	,van.idpromotore
	,ISNULL(van.CodicePromotore,'') + ' - '
		+ IIF(van.CognomePromotore is NULL or van.CognomePromotore = '',van.RagioneSocialePromotore,van.CognomePromotore)
		+ ' ' + ISNULL(van.NomePromotore,'') Promotore
	,IIF(wf.IdTransizione IS NOT NULL,1,0) FlagRiesame

FROM T_Incarico ti
LEFT JOIN (SELECT IdTransizione, IdIncarico,DataTransizione FROM L_WorkflowIncarico
		WHERE CodStatoWorkflowIncaricoPartenza = 6570	--Definita - Inviata
			
				AND CodAttributoIncaricoDestinazione = 270 --RIESAME PER APPROFONDIMENTI
	) wf ON ti.IdIncarico = wf.IdIncarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico

LEFT JOIN T_Antiriciclaggio ON ti.IdIncarico = T_Antiriciclaggio.IdIncarico
LEFT JOIN D_MotivoVerifica ON CodMotivoVerifica = D_MotivoVerifica.Codice
LEFT JOIN D_SanatoriaFiscale ON CodSanatoriaFiscale = D_SanatoriaFiscale.Codice

WHERE ti.CodArea = 8
AND ti.CodCliente = 23 
AND ti.CodTipoIncarico = 66
AND ti.DataCreazione >= DATEADD(YEAR,-1,CONVERT(DATE,GETDATE()))

--6570	--Definita - Inviata
--7130	--Gestita - In valutazione
--6590	--Da segnalare
--6595	--Non segnalata
--6600	--Segnalata