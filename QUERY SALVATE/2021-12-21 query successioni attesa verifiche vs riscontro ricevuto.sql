--SELECT DISTINCT  Codice, Descrizione--, CodTipoIncarico
--FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
--JOIN D_StatoWorkflowIncarico ON R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice

--WHERE CodCliente = 23
--AND CodTipoIncarico IN (54,164,165,166,175,184,185,193,351,659,783)
--AND Descrizione LIKE '%riscontro%'

--AND Codice = 6594

/* 
problema: TA è ferma per passaggi verso soggetti esterni, questo pregiudica il calcolo degli sla.
Oggi è un problema solo di TA, domani lo sarà anche degli 
solution: usiamo  lo stato 22343 come base
, da cambiare etichetta in maniera più generica (in attesa)
, i vari dettagli verranno indicati in motivi transizione

*/


/*
problema: quando arrivano integrazioni (via mail/tramite documenti)
	cambia lo stato
; questo pregiudica le code di lavorazione delle dispositive quando un master è in coda di un ufficio <> da successioni
*/

USE CLC
GO



SELECT T_Incarico.IdIncarico
,ISNULL(AttesaVerifiche.n,0) NAttese
,AttesaVerifiche.Ufficio

,ISNULL(riscontroricevuto.n,0) NRiscontri
,riscontroricevuto.Ufficio
FROM T_Incarico
outer APPLY (
				SELECT COUNT(lmx.IdMotivoTransizione) n
				,lmx.CodMotivoTransizione, dmx.Descrizione Ufficio, lwix.IdIncarico
				FROM L_WorkflowIncarico lwix
				JOIN L_MotivoTransizione lmx ON lwix.IdTransizione = lmx.IdTransizione
				JOIN D_MotivoTransizione dmx ON lmx.CodMotivoTransizione = dmx.Codice
				WHERE lwix.CodStatoWorkflowIncaricoPartenza != lwix.CodStatoWorkflowIncaricoDestinazione
				AND lwix.CodStatoWorkflowIncaricoDestinazione = 22320	--In Attesa verifiche uffici competenti
				AND lwix.IdIncarico = T_Incarico.IdIncarico
				GROUP BY lmx.CodMotivoTransizione,dmx.Descrizione, lwix.IdIncarico
) AttesaVerifiche

OUTER APPLY (
				SELECT COUNT(lmx2.IdMotivoTransizione) n
				,lmx2.CodMotivoTransizione, dmx2.Descrizione Ufficio, lwix2.IdIncarico
				FROM L_WorkflowIncarico lwix2
				JOIN L_MotivoTransizione lmx2 ON lwix2.IdTransizione = lmx2.IdTransizione
				JOIN D_MotivoTransizione dmx2 ON lmx2.CodMotivoTransizione = dmx2.Codice
				WHERE lwix2.CodStatoWorkflowIncaricoPartenza != lwix2.CodStatoWorkflowIncaricoDestinazione
				AND lwix2.CodStatoWorkflowIncaricoDestinazione = 22321	--Riscontro Ricevuto da uffici competenti
				AND lwix2.IdIncarico = T_Incarico.IdIncarico
				GROUP BY lmx2.CodMotivoTransizione,dmx2.Descrizione, lwix2.IdIncarico

) RiscontroRicevuto

WHERE T_Incarico.CodArea = 8
AND CodCliente = 23
AND CodTipoIncarico = 54
AND T_Incarico.IdIncarico = 17700271



SELECT * FROM R_ComunicazioneImbarcata_TransizioneIncarico


SELECT * FROM R_Transizione_AttivitaPianificata