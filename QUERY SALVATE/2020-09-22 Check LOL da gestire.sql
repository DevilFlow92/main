USE clc

GO

WITH DaGestire AS (
SELECT ti.IdIncarico
FROM T_Incarico ti

OUTER APPLY (
				SELECT TOP 1 tc.IdComunicazione 
                FROM dbo.T_Comunicazione tc
				JOIN Y_SpoolerInvioPostev2 s ON tc.IdComunicazione = s.IdComunicazione
				JOIN S_Operatore so ON tc.IdOperatore = so.IdOperatore
				AND so.CodProfiloAccesso = 839 AND so.FlagAttivo = 1
				AND tc.DataInvio >= '20210901'
				WHERE FlagLavorato = 1
				AND tc.IdIncarico = ti.IdIncarico
				ORDER BY tc.IdComunicazione DESC

) gestitedpe

WHERE gestitedpe.IdComunicazione IS NULL AND
ti.IdIncarico IN (
18413974
,13447183
)

) SELECT DaGestire.IdIncarico, T_Comunicazione.IdComunicazione
,T_Comunicazione.IdOperatore
,Etichetta
, Y_SpoolerInvioPostev2.IdInvioPoste						
,Y_SpoolerInvioPostev2.DataInserimento
,Y_SpoolerInvioPostev2.FlagLavorato
,Y_SpoolerInvioPostev2.FlagFallito
,Y_SpoolerInvioPostev2.DataInizioElaborazione
,Y_SpoolerInvioPostev2.DataFineElaborazione
,Y_SpoolerInvioPostev2.CodiceErrore
,Y_SpoolerInvioPostev2.DescrizioneErrore
FROM DaGestire
JOIN T_Comunicazione ON DaGestire.IdIncarico = T_Comunicazione.IdIncarico
AND CodTipoInvioPoste IS NOT NULL 
JOIN Y_SpoolerInvioPostev2 ON T_Comunicazione.IdComunicazione = Y_SpoolerInvioPostev2.IdComunicazione
JOIN S_Operatore ON T_Comunicazione.IdOperatore = S_Operatore.IdOperatore
--AND codiceerrore = 1121

--SELECT IdIncarico, Documento_id, CAST(idincarico AS VARCHAR(20)) + '_' + CAST(Documento_id AS VARCHAR(50)) +'.pdf'
--FROM T_Documento
--WHERE IdIncarico = 18389468  AND NOTE = 'inviare'

