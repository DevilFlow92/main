USE CLC
GO

--ALTER PROCEDURE rs.CESAM_AZ_GestioneDossierNONPopolatiCorrettamente 
--(@DataFiltro DATETIME
--,@DataFiltroPrioritario datetime
--)
--AS

/*
Author: L. Fiori
Varia i ruoli richiedente non corretti per gli incarichi AFB
Attualmente agisce in automatico:
Sulle Sottoscrizioni AFB, se i ruoli sono 
	- 28	Contraente
	- 29	Contraente Assicurato
	- 30	Contraente Beneficiario
	- 37	Secondo Contraente
	- 38	Secondo Contraente Assicurato
	- 39	Secondo Contraente Beneficiario

I versamenti aggiuntivi, rimborsi e switch AFB se la squadra ha SOLO 1 intestatario

Questi sono i casi automatizzabili, il resto si gestisce manualmente raffrontando cartaceo e posizioni su FEND, per i dossier segnalati 
nel secondo sheet del report AZ - Incarichi con dossier NON popolati correttamente
Decommentare sotto in caso di test della SP
*/

--DECLARE @DataFiltro DATETIME
--		,@DataFiltroPrioritario DATETIME

--SET @DataFiltro = '2018-01-01'
--SET @DataFiltroPrioritario = '2018-04-27'


BEGIN

if object_id(N'tempdb.#updatemassivo',N'U') is not null
    BEGIN
    drop TABLE #updatemassivo
    END

;WITH cte AS 
(
	SELECT COUNT(*) N_persone, IdDossier
			FROM T_R_Dossier_Persona
			GROUP BY IdDossier
			HAVING COUNT(*) > 1
			
)

SELECT T_R_Dossier_Persona.IdRelazione
		,vista.ProgressivoPersona
		,T_R_Dossier_Persona.IdPersona
		,vista.IdDossier
		--,T_R_Dossier_Persona.CodRuoloRichiedente AS CodRuoloVecchio
		--,CodTipoIncarico
		,vista.IdIncarico
		INTO #updatemassivo
		 FROM T_Incarico
JOIN rs.v_CESAM_AZ_Incarichi_AFB_Dossier_NON_PopolatiCorrettamente vista ON T_Incarico.IdIncarico = vista.IdIncarico
JOIN T_R_Dossier_Persona ON vista.IdDossier = T_R_Dossier_Persona.IdDossier
								AND vista.IdPersona = T_R_Dossier_Persona.IdPersona
								AND vista.CodRuoloRichiedente = T_R_Dossier_Persona.CodRuoloRichiedente
								AND vista.ProgressivoPersona = Progressivo
LEFT JOIN cte ON T_R_Dossier_Persona.IdDossier = cte.IdDossier

WHERE
 ((CodTipoIncarico = 321 AND vista.CodRuoloRichiedente IN (28,29,30,37,38,39))

OR (CodTipoIncarico <> 321 AND cte.IdDossier is NULL )

)


ORDER BY T_R_Dossier_Persona.IdDossier


UPDATE T_R_Dossier_Persona
SET CodRuoloRichiedente = 33
FROM T_R_Dossier_Persona
INNER JOIN #updatemassivo
	ON #updatemassivo.IdRelazione = T_R_Dossier_Persona.IdRelazione AND #updatemassivo.ProgressivoPersona = 1

UPDATE T_R_Dossier_Persona
SET CodRuoloRichiedente = 26
FROM T_R_Dossier_Persona
INNER JOIN #updatemassivo ON T_R_Dossier_Persona.IdRelazione = #updatemassivo.IdRelazione AND #updatemassivo.ProgressivoPersona > 1


--SELECT * FROM #updatemassivo

DROP TABLE #updatemassivo

SELECT
		IdIncarico,
		IdDossier,
		NumeroDossier,
		DataCreazione,
		CodRuoloRichiedente,
		RuoloRichiedente,
		ProgressivoPersona,
		IdPersona,
		ChiaveCliente,
		AnagraficaIntestatari,
		ModificaSuggerita
		,CASE WHEN DataCreazione >= @DataFiltroPrioritario --'2018-04-27'
		THEN 1 ELSE 0 END Prioritario
FROM rs.v_CESAM_AZ_Incarichi_AFB_Dossier_NON_PopolatiCorrettamente
WHERE DataCreazione >= @DataFiltro

--DataCreazione >= '2018-01-01' --decommentare in caso di test della SP

END
GO



