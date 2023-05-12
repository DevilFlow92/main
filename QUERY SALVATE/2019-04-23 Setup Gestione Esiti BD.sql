USE CLC
GO

SELECT * FROM D_TipoAttivitaPianificataIncarico
ORDER BY Codice DESC

/*
t0 invio al cf
t1 6gg lavorativi - invio primo sollecito
t2 11gg lavorativi (5 gg dal primo sollecito) - invio secondo sollecito
t3 16gg lavorativi (5 gg dal secondo sollecito) - invio terzo ed ultimo sollecito
t4 30gg calendario - invio comunicazione a direzione commerciale


t0 --> apro l'attività pianificata Invio Richiesta, scade in 6gg lavorativi si apre alla transizione in Invio Scheda Conoscitiva al CF
t1 --> il cf non risponde, transito in Invio primo sollectito --> si apre l'attività pianificata Primo Sollecito che scade in 5gg lavorativi
t2 --> il cf non risponde nemmeno stavolta, transito in Invio Secondo Sollecito --> si apre l'attività pianificata Secondo sollecito che scade in 5gg lavorativi
t3 --> il cf non risponde nemmeno stavolta, transito in Invio Ultimo Sollecito --> si apre l'attività pianificata Terzo Sollecito (scadenza in 30gg di calendario dalla transizione in Invio Richiesta)
*/

--INSERT into D_TipoAttivitaPianificataIncarico	 (Codice, Descrizione, Nota)
----	VALUES (1064, 'Secondo Sollecito', '')
--VALUES (1065,'Terzo Sollecito','')



--INSERT into R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
SELECT --IdRelazione,
	CodCliente
	,CodTipoIncarico
	,CodStatoWorkflowIncarico
	,1064
	,CodStatoWorkflowDeadline
	,MinutiDeadline
	,NomeStoredProcedureMatch
	,FlagUrgente
	,FlagNotaObbligatoria
	,CodAttributo
	,FlagIntervalloLavorativo
	,NomeStoredProcedureAggiornamentoDataScadenza
FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
WHERE CodCliente = 23
AND CodTipoIncarico = 522
AND IdRelazione = 6336
UNION ALL
SELECT
	
	CodCliente
	,CodTipoIncarico
	,CodStatoWorkflowIncarico
	,1065
	,CodStatoWorkflowDeadline
	,NULL
	,NomeStoredProcedureMatch
	,FlagUrgente
	,FlagNotaObbligatoria
	,CodAttributo
	,FlagIntervalloLavorativo
	,NomeStoredProcedureAggiornamentoDataScadenza
FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
WHERE CodCliente = 23
AND CodTipoIncarico = 522
AND IdRelazione = 6336

SELECT * FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata WHERE CodTipoIncarico = 522


SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
JOIN D_StatoWorkflowIncarico ON R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice
WHERE CodTipoIncarico = 522

/*
12360	Primo Sollecito
12370	Secondo Sollecito 6370
12380	Terzo Sollecito 6371
*/

SELECT * FROM D_UfficioAttivitaPianificata WHERE Descrizione like '%ricicl%'

SELECT * FROM R_TipoAttivitaPianificata_UfficioAttivitaPianificata
WHERE CodUfficioAttivitaPianificata = 33 --AZ Antiriciclaggio

--INSERT into R_TipoAttivitaPianificata_UfficioAttivitaPianificata (CodTipoAttivitaPianificata, CodUfficioAttivitaPianificata, FlagDefault, CodCliente, CodTipoIncarico)
SELECT
	D_TipoAttivitaPianificataIncarico.Codice
	,CodUfficioAttivitaPianificata
	,FlagDefault
	,CodCliente
	,CodTipoIncarico
FROM R_TipoAttivitaPianificata_UfficioAttivitaPianificata
JOIN D_TipoAttivitaPianificataIncarico
	ON IdRelazione = 3879
	AND Codice IN (1064, 1065)

--INSERT into R_Transizione_AttivitaPianificata (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoAttivitaInserimento, CodTipoAttivitaChiusura, FlagStatoWorkflowModificato, FlagAttributoModificato, FlagUrgenteModificato, FlagAttesaModificato, FlagAbilita, NomeStoredProcedureMatch)
SELECT
	rtran.CodCliente
	,rtran.CodTipoIncarico
	,FlagCreazione
	,CodStatoWorkflowIncaricoPartenza
	,CodAttributoIncaricoPartenza
	,FlagUrgentePartenza
	,FlagAttesaPartenza
	,IIF(r.IdRelazione = 6370,12370,12380) CodStatoWorkflowIncaricoDestinazione
	,CodAttributoIncaricoDestinazione
	,FlagUrgenteDestinazione
	,FlagAttesaDestinazione
	,r.IdRelazione IdTipoAttivitaInserimento
	,CodTipoAttivitaChiusura
	,FlagStatoWorkflowModificato
	,FlagAttributoModificato
	,FlagUrgenteModificato
	,FlagAttesaModificato
	,FlagAbilita
	,rtran.NomeStoredProcedureMatch
FROM R_Transizione_AttivitaPianificata rtran
JOIN R_Cliente_TipoIncarico_TipoAttivitaPianificata r
	ON rtran.IdRelazione = 37516
	AND r.IdRelazione IN (6370, 6371)
UNION ALL
SELECT
	rtran.CodCliente
	,rtran.CodTipoIncarico
	,FlagCreazione
	,IIF(r.IdRelazione = 6370, 12370, 12380) CodStatoWorkflowIncaricoPartenza
	,CodAttributoIncaricoPartenza
	,FlagUrgentePartenza
	,FlagAttesaPartenza
	,CodStatoWorkflowIncaricoDestinazione
	,CodAttributoIncaricoDestinazione
	,FlagUrgenteDestinazione
	,FlagAttesaDestinazione
	,rtran.IdTipoAttivitaInserimento
	,r.CodTipoAttivitaPianificata
	,FlagStatoWorkflowModificato
	,FlagAttributoModificato
	,FlagUrgenteModificato
	,FlagAttesaModificato
	,FlagAbilita
	,rtran.NomeStoredProcedureMatch
FROM R_Transizione_AttivitaPianificata rtran
JOIN R_Cliente_TipoIncarico_TipoAttivitaPianificata r
	ON rtran.IdRelazione = 37517
	AND r.IdRelazione IN (6370, 6371)




USE CLC

SELECT * FROM D_TipoAttivitaPianificataIncarico
WHERE Codice in (1062,1063,1064,1065)

/*
AP Scaduta: Effettuare transizione verso lo stato In Gestione - Primo Sollecito
--WHERE Codice = 1062

AP Scaduta: Contattare telefonicamente il CF
--where codice = 1063

AP Scaduta:
--where codice = 1064

AP Scaduta: Inviare ultimo sollecito (lettera scritta per BC o in copia struttura di rete sino a AD per CF)
codice 1065

AP Scaduta: Inviare comunicazione a Direzione Commercial
*/