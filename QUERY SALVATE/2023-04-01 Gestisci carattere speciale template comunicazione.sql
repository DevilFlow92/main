USE CLC_Cesam
GO

--SELECT CodTipoIncarico, D_TipoIncarico.Descrizione TipoIncarico
--,CodStatoWorkflowIncaricoPartenza, partenza.Descrizione StatoPartenza
--,CodStatoWorkflowIncaricoDestinazione, destinazione.Descrizione StatoDestinazione
--,R_EsitoControllo_BloccoTransizione.IdControllo
--,S_Controllo.Descrizione TipoControllo
--FROM R_EsitoControllo_BloccoTransizione
--JOIN D_TipoIncarico ON R_EsitoControllo_BloccoTransizione.CodTipoIncarico = D_TipoIncarico.Codice
--JOIN S_Controllo ON R_EsitoControllo_BloccoTransizione.IdControllo = S_Controllo.IdControllo
--LEFT JOIN D_StatoWorkflowIncarico partenza ON R_EsitoControllo_BloccoTransizione.CodStatoWorkflowIncaricoPartenza = partenza.Codice
--LEFT JOIN D_StatoWorkflowIncarico destinazione ON R_EsitoControllo_BloccoTransizione.CodStatoWorkflowIncaricoDestinazione = destinazione.Codice
--WHERE CodCliente = 23 AND CodTipoIncarico IN (1033,1034)

--SELECT CodTipoIncarico, S_Controllo.*
--FROM S_MacroControllo
--JOIN S_Controllo ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo
--WHERE CodCliente = 23 AND CodTipoIncarico IN (1033,1034)

DECLARE @IdTemplate INT

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
	SELECT DISTINCT IdTemplate
	FROM S_TemplateComunicazione
	JOIN R_TemplateComunicazione_StatoWorkflowIncarico ON S_TemplateComunicazione.IdTemplate = R_TemplateComunicazione_StatoWorkflowIncarico.IdTemplateComunicazione
	WHERE CodCliente = 23
	AND CodTipoIncarico IN (595,1033,571,1034)
	AND idtemplate = 18492

OPEN cur

FETCH NEXT FROM cur INTO @IdTemplate

WHILE @@FETCH_STATUS = 0 BEGIN



UPDATE dbo.S_TemplateComunicazione
SET oggetto = REPLACE(Oggetto,'&lt;','<')
,testo = REPLACE(Testo,'&lt;','<')

FROM S_TemplateComunicazione
WHERE IdTemplate = @IdTemplate


	FETCH NEXT FROM cur INTO @IdTemplate

END

CLOSE cur
DEALLOCATE cur



