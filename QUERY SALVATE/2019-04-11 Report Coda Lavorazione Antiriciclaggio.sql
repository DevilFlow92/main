USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_Antiriciclaggio_CodaLavorazione AS 

SELECT ti.IdIncarico
,ti.DataCreazione
,ti.DataUltimaTransizione
,descrizioni.TipoIncarico
,descrizioni.CodMacroStatoWFIncarico
,ti.CodStatoWorkflowIncarico
,descrizioni.StatoWorkflowIncarico
,so.Etichetta GestoreIncarico
,anagrafica.ChiaveClienteIntestatario CodiceCliente
,IIF(anagrafica.CognomeIntestatario is NULL or anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomeIntestatario) + ' ' + ISNULL(anagrafica.NomeIntestatario,'') Cliente
,anagrafica.CodicePromotore CodiceConsulente
,IIF(anagrafica.CognomePromotore is NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomePromotore,'') Consulente

,tap.IdAttivita
,tap.CodTipoAttivitaPianificata
,D_TipoAttivitaPianificataIncarico.Descrizione AttivitaPianificata
,tap.DataScadenza
,IIF(tap.CodTipoAttivitaPianificata <> 1065,tap.FlagScadenzaNotificata
		,IIF(DATEDIFF(DAY,inviorichiesta.DataTransizione,GETDATE()) < 30,0,1)) FlagScadenza
,CASE tap.CodTipoAttivitaPianificata
	WHEN 1062 THEN 'Effettuare transizione verso lo stato In Gestione - Primo Sollecito' + CHAR(10) + 'Invio sollecito al CF con in copia primo livello superiore'
	WHEN 1063 THEN 'Transitare verso lo stato In Gestione - Secondo Sollecito.'+ CHAR(10) +'Contattare telefonicamente il CF'
	WHEN 1064 THEN 'Transitare verso lo stato In Gestione - Terzo Sollecito.' + CHAR(10) + 'Inviare lettera scritta per BC o in copia struttura di rete sino a AD per CF.'
	WHEN 1065 THEN 'Inviare comunicazione a Direzione Commerciale e Internal Audit'

end as Azione

,IIF(tap.CodTipoAttivitaPianificata = 1062,0,1) FlagAP_TL
,IIF(descrizioni.CodMacroStatoWFIncarico = 14,1,0) CodaLavorazione_TL

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON ti.IdIncarico = anagrafica.IdIncarico

LEFT JOIN T_AttivitaPianificataIncarico tap ON ti.IdIncarico = tap.IdIncarico
AND tap.CodStatoAttivita = 1 --Aperta
AND tap.CodTipoAttivitaPianificata in (1062,1063,1064,1065) --Solleciti integrazioni al CF
LEFT JOIN D_TipoAttivitaPianificataIncarico ON tap.CodTipoAttivitaPianificata = D_TipoAttivitaPianificataIncarico.Codice

LEFT JOIN T_R_Incarico_Operatore ON ti.IdIncarico = T_R_Incarico_Operatore.IdIncarico
LEFT JOIN S_Operatore so ON T_R_Incarico_Operatore.IdOperatore = so.IdOperatore

LEFT JOIN (SELECT MAX(IdTransizione) IdTransizione, IdIncarico 
			FROM L_WorkflowIncarico 
			WHERE CodStatoWorkflowIncaricoDestinazione = 15540
			GROUP BY IdIncarico
		  ) inputinviorichiesta ON ti.IdIncarico = inputinviorichiesta.IdIncarico

LEFT JOIN L_WorkflowIncarico inviorichiesta ON inputinviorichiesta.IdTransizione = inviorichiesta.IdTransizione

WHERE ti.CodCliente = 23 
AND ti.CodArea = 8
AND ti.CodTipoIncarico IN (522,524)

--AND ti.IdIncarico = 12107770

AND descrizioni.CodMacroStatoWFIncarico <> 13 --Archiviata

GO