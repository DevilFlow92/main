USE CLC
GO

IF OBJECT_ID('tempdb.dbo.#checkTabControlli') IS NOT NULL
	DROP TABLE #checkTabControlli
GO


/* Check presenza controlli su tipo incarico ma non il tab controlli */
SELECT
	S_MacroControllo.CodCliente
	,S_MacroControllo.CodTipoIncarico
	,D_TipoIncarico.Descrizione TipoIncarico
	,32 as CodDatoAssociabile
	,NULL AS Cardinalita
	,1 AS FlagMostraInRicerca
	,0 AS ElementiSubincarichiVisualizzabili
INTO #checkTabControlli
FROM S_MacroControllo
LEFT JOIN R_Cliente_TipoIncarico_DatoAssociabile
	ON S_MacroControllo.CodCliente = R_Cliente_TipoIncarico_DatoAssociabile.CodCliente
	AND S_MacroControllo.CodTipoIncarico = R_Cliente_TipoIncarico_DatoAssociabile.CodTipoIncarico
	AND CodDatoAssociabile = 32

JOIN D_TipoIncarico
	ON Codice = S_MacroControllo.CodTipoIncarico

WHERE S_MacroControllo.CodCliente = 23

AND IdRelazione IS NULL

SELECT * FROM #checkTabControlli

/* Insert del tab controlli nei tipi incarico dove manca e serve */

--INSERT INTO R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
--SELECT
--	CodCliente
--	,CodTipoIncarico
--	,CodDatoAssociabile
--	,Cardinalita
--	,FlagMostraInRicerca
--	,ElementiSubincarichiVisualizzabili
--FROM #checkTabControlli


/* ************************************************************* */

DROP TABLE #checkTabControlli