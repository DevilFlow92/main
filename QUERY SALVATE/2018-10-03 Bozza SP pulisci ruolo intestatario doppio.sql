USE CLC
GO

--CREATE PROCEDURE rs.CESAM_AZ_GesticiIncarichiRuoloIntestatarioDoppi 
--(@DataFiltro AS DATETIME
	
--)
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
--AS


BEGIN TRY	

DECLARE @DataFiltro AS DATETIME
SET @DataFiltro = '20180701'

IF OBJECT_ID('tempdb.dbo.#update') IS NOT NULL
BEGIN
	DROP TABLE #update
END


SELECT 	T_R_Dossier_Persona.IdRelazione IdRelazioneClean
		,T_R_Dossier_Persona.IdDossier
		,vista.IdPersona
		,vista.Nominativo
		,T_R_Dossier_Persona.Progressivo
		,T_R_Dossier_Persona.CodRuoloRichiedente

INTO #update
FROM rs.v_CESAM_AZ_IncarichiConRuoloIntestatarioDoppio vista

LEFT JOIN (SELECT DISTINCT
				T_R_Dossier_Persona.IdRelazione
				,T_Dossier.IdDossier
			FROM T_Dossier
				JOIN T_R_Dossier_Persona ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
				JOIN T_Persona ON T_R_Dossier_Persona.IdPersona = T_Persona.IdPersona AND CodTipoPersona = 2

			) PG ON PG.IdDossier = vista.IdDossier

JOIN T_R_Dossier_Persona ON vista.IdDossier = T_R_Dossier_Persona.IdDossier and vista.IdPersona = T_R_Dossier_Persona.IdPersona
						AND vista.Progressivo = T_R_Dossier_Persona.Progressivo AND vista.CodRuoloRichiedente = T_R_Dossier_Persona.CodRuoloRichiedente

LEFT JOIN rs.v_CESAM_AZ_PersonaRipetutaNelDossier doppioni ON vista.IdDossier = doppioni.IdDossier

WHERE PG.IdRelazione IS NULL
AND doppioni.IdDossier is NULL
AND vista.DataCreazione >= @DataFiltro
AND vista.Progressivo > 1 

SELECT * FROM #update 


/*
UPDATE T_R_Dossier_Persona
SET CodRuoloRichiedente = 26
FROM T_R_Dossier_Persona
JOIN #update ON IdRelazioneClean = IdRelazione


SELECT 	IdIncarico
		,DataCreazione
		,IdDossier
		,NumeroDossier
		--,IdPersona
		,ChiaveCliente
		,Progressivo
		,CodRuoloRichiedente
		,Nominativo 
FROM rs.v_CESAM_AZ_IncarichiConRuoloIntestatarioDoppio
*/

END TRY

BEGIN CATCH
PRINT 'Errore'

END CATCH


GO


SELECT * FROM D_RuoloRichiedente where Descrizione LIKE 'proc%'


SELECT DISTINCT T_Incarico.IdIncarico FROM T_R_Dossier_Persona
JOIN T_Mandato on T_R_Dossier_Persona.IdDossier = T_Mandato.IdDossier
JOIN T_R_Incarico_Mandato ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
JOIN T_Incarico on T_R_Incarico_Mandato.IdIncarico = T_Incarico.IdIncarico
JOIN rs.v_CESAM_AZ_PersonaRipetutaNelDossier doppioni ON T_R_Dossier_Persona.IdDossier = doppioni.IdDossier
WHERE CodRuoloRichiedente = 22 and CodArea = 8 AND CodCliente = 23



SELECT * FROM D_Privilegio where Descrizione LIKE '%setup%'


SELECT * FROM R_ProfiloAccesso_Privilegio where CodProfiloAccesso = 839 AND CodPrivilegio = 21

SELECT * FROM S_Operatore WHERE Cognome = 'cugusi'


SELECT * FROM R_ProfiloAccesso_Privilegio where CodProfiloAccesso = 2132 AND CodPrivilegio = 21 --setup operatori

