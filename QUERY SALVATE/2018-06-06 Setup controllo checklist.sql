USE clc
GO



/*

--SELECT * FROM S_Controllo ORDER BY IdControllo DESC

--2722
--2721
--2720
--2719



SELECT * FROM D_TipoIncarico where Descrizione LIKE '%credito%fea%'
--378	Apertura Carta di Credito FEA

SELECT * FROM D_StatoWorkflowIncarico
JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow ON Codice = CodStatoWorkflowIncarico
													AND CodCliente = 48
													 WHERE Descrizione LIKE '%attivata'



--INSERT into S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita, Ordinamento)
SELECT
	CodCliente,
	378,
	NomeStoredProcedure,
	Descrizione,
	TestoHelp,
	FlagGenerazioneDifferita,
	Ordinamento
FROM S_MacroControllo
WHERE IdMacroControllo = 511

SELECT SCOPE_IDENTITY()

--idmacrocontrolo KK FEA  797
--idcontrollo KK FEA	  2722


SELECT * FROM S_MacroControllo where CodTipoIncarico = 378
--cartaceo		511
--dossier fea	538
--conto fea		539
--KK FEA		797

SELECT D_StatoWorkflowIncarico.Descrizione StatoDestinazione,r.* FROM R_Transizione_MacroControllo r
JOIN D_StatoWorkflowIncarico on Codice = CodStatoWorkflowIncaricoDestinazione
where IdTipoMacroControllo = 538
*/

--INSERT into R_Transizione_MacroControllo (CodCliente, CodTipoIncarico, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, IdTipoMacroControllo, FlagCreazione)
SELECT
	CodCliente,
	334,
	CodStatoWorkflowIncaricoPartenza,
	CodAttributoIncaricoPartenza,
	FlagUrgentePartenza,
	FlagAttesaPartenza,
	CodStatoWorkflowIncaricoDestinazione,
	CodAttributoIncaricoDestinazione,
	FlagUrgenteDestinazione,
	FlagAttesaDestinazione,
	538,
	FlagCreazione
FROM R_Transizione_MacroControllo

WHERE IdRelazione IN (913
,914
,915
,916
)
UNION ALL
SELECT
	CodCliente,
	378,
	CodStatoWorkflowIncaricoPartenza,
	CodAttributoIncaricoPartenza,
	FlagUrgentePartenza,
	FlagAttesaPartenza,
	CodStatoWorkflowIncaricoDestinazione,
	CodAttributoIncaricoDestinazione,
	FlagUrgenteDestinazione,
	FlagAttesaDestinazione,
	797,
	FlagCreazione
FROM R_Transizione_MacroControllo

WHERE IdRelazione IN (913
, 914
, 915
, 916
, 778
)


/* controlli da bloccare
2719	511 --cart		331
2720	539	--cc fea	335
2721	538 --doss fea	334
2722	797 --KK FEA	378
*/


--INSERT into R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
SELECT
	CodCliente,
	331,
	CodAttributoIncaricoPartenza,
	CodAttributoIncaricoDestinazione,
	CodStatoWorkflowIncaricoPartenza,
	CodStatoWorkflowIncaricoDestinazione,
	FlagUrgentePartenza,
	FlagUrgenteDestinazione,
	FlagAttesaPartenza,
	FlagAttesaDestinazione,
	CodGiudizioControllo,
	CodEsitoControllo,
	2719,
	IdMacroControllo,
	FlagAbilitaBlocco
FROM R_EsitoControllo_BloccoTransizione
WHERE IdControllo = 1944


--INSERT into R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico, CodAttributoIncaricoPartenza, CodAttributoIncaricoDestinazione, CodStatoWorkflowIncaricoPartenza, CodStatoWorkflowIncaricoDestinazione, FlagUrgentePartenza, FlagUrgenteDestinazione, FlagAttesaPartenza, FlagAttesaDestinazione, CodGiudizioControllo, CodEsitoControllo, IdControllo, IdMacroControllo, FlagAbilitaBlocco)
--	VALUES (48, 331, null, null, null, 14276, null, null, null, null, 4, null, 2719, null, 1)
--			,(48, 331, null, null, null, 14274, null, null, null, null, 4, null, 2719, null, 1)
--			,(48, 331, null, null, null, 14440, null, null, null, null, 4, null, 2719, null, 1)
			
--			,(48, 335, null, null, null, 14275, null, null, null, null, 4, null, 2720, null, 1)
--			,(48, 335, null, null, null, 14276, null, null, null, null, 4, null, 2720, null, 1)

--			,(48, 334, null, null, null, 14275, null, null, null, null, 4, null, 2721, null, 1)
--			,(48, 334, null, null, null, 14274, null, null, null, null, 4, null, 2721, null, 1)
			
--			,(48, 378, null, null, null, 14275, null, null, null, null, 4, null, 2722, null, 1)
--			,(48, 378, null, null, null, 14440, null, null, null, null, 4, null, 2722, null, 1);




/* INCARICHI TEST */

--4424824 CARTACEO			ok
--4424826 CONTO FEA
--4424827 KK FEA
--4424828 DOSSIER FEA

--DELETE FROM R_EsitoControllo_BloccoTransizione where CodTipoIncarico = 378

--DELETE FROM S_Controllo where IdControllo = 2722


SELECT * FROM R_EsitoControllo_BloccoTransizione ORDER BY IdRelazione DESC


DELETE FROM R_EsitoControllo_BloccoTransizione where IdRelazione = 1758