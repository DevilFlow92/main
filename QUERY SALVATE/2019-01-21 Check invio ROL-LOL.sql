USE CLC
GO

--CHECK ERRORE

--SELECT *		
-- FROM T_Comunicazione 
 
--WHERE IdIncarico = 16107657                     
--AND CodTipoInvioPoste IS NOT NULL --ROL/LOL



SELECT
	T_Comunicazione.IdIncarico
	,Y_SpoolerInvioPostev2.*

FROM T_Comunicazione
LEFT JOIN Y_SpoolerInvioPostev2
	ON T_Comunicazione.IdComunicazione = Y_SpoolerInvioPostev2.IdComunicazione

WHERE T_Comunicazione.IdIncarico  IN (
18288531
,18389412
,18389376
,18389376
,18389381
,18389373
,18389466
,18389468
,18389434
,18389476
,18389391
,18389399
,18389515
,18389523
,18389411
,18413971

)

AND CodTipoInvioPoste IS NOT NULL --ROL/LOL
--AND IdOperatore = 12701 --Fiori L.

AND IdOperatore IN (12798, 12701, 12266, 10220,13383)
--Fiori L.
 
--AND DataInvio >= '2019-07-12 18:00'
----AND IdInvioPoste IS NULL

AND (
 (FlagFallito = 1 and FlagLavorato = 0)
 OR
 (DataFineElaborazione IS NULL)
 )
 
 --AND DataInserimento >= CONVERT(DATE,getdate())

