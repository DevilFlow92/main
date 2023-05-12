
/* connetti a vt-btsql04 */

USE CLC
GO

--INSERT INTO [VP-BTSQL02].CLC.dbo.R_TransizioneIncarico_ModificaDatiAssociati (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, NomeStoredProcedure)
SELECT
	CodCliente
	,408
	,CodStatoWorkflowIncaricoPartenza
	,CodAttributoIncaricoPartenza
	,FlagUrgentePartenza
	,FlagAttesaPartenza
	,CodStatoWorkflowIncaricoDestinazione
	,CodAttributoIncaricoDestinazione
	,FlagUrgenteDestinazione
	,FlagAttesaDestinazione
	,NomeStoredProcedure
FROM R_TransizioneIncarico_ModificaDatiAssociati
WHERE IdRelazione = 11


/* connetti a vp-btsql02 */

USE CLC
GO

--Mancavano setup nei workflow per il tipo incarico 408, li ho inseriti

SELECT 	CodCliente
		--,CodTipoIncarico
		,CodStatoWorkflowIncarico
		,CodMacroStatoWorkflowIncarico
		,Ordinamento 
		
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow where CodTipoIncarico = 331 AND CodMacroStatoWorkflowIncarico = 12
EXCEPT
SELECT
	CodCliente
	--,CodTipoIncarico
	,CodStatoWorkflowIncarico
	,CodMacroStatoWorkflowIncarico
	,Ordinamento

FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
WHERE CodTipoIncarico = 408
AND CodMacroStatoWorkflowIncarico = 12


--INSERT into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
--	VALUES (48, 408, 14299, 12, NULL)
--			,(48, 408, 14555, 12, NULL);



/* setup nel 331 */
--Abilitazione dato aggiuntivo 1208

--INSERT INTO R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo)
SELECT
	CodCliente
	,331
	,CodTipoDatoAggiuntivo
FROM R_Cliente_TipoIncarico_TipoDatoAggiuntivo
WHERE IdRelazione = 2594


--abilitazione automatismo 

--INSERT INTO R_TransizioneIncarico_ModificaDatiAssociati (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, NomeStoredProcedure)
SELECT
	CodCliente
	,331
	,CodStatoWorkflowIncaricoPartenza
	,CodAttributoIncaricoPartenza
	,FlagUrgentePartenza
	,FlagAttesaPartenza
	,CodStatoWorkflowIncaricoDestinazione
	,CodAttributoIncaricoDestinazione
	,FlagUrgenteDestinazione
	,FlagAttesaDestinazione
	,NomeStoredProcedure
FROM R_TransizioneIncarico_ModificaDatiAssociati
WHERE IdRelazione = 37


