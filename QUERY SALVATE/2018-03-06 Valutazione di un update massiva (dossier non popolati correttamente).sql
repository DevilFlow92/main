use CLC
GO

--CREATE procedure rs.CESAM_AZ_AggiornaRuoloDossier as
if object_id(N'tempdb.#intestatari',N'U') is not null
begin
drop TABLE #intestatari
end


select TOP 50 T_R_Dossier_Persona.IdRelazione
		--,T_R_Dossier_Persona.IdDossier
		--,T_R_Dossier_Persona.IdPersona
		--,CodRuoloRichiedente as CodRuoloRichiedenteVecchio
		--,33 as CodRuoloRichiedenteAggiornato
INTO #intestatari
FROM T_R_Dossier_Persona
INNER JOIN (SELECT distinct IdDossier
							,IdPersona
				FROM rs.v_CESAM_AZ_Incarichi_AFB_Dossier_NON_PopolatiCorrettamente) verificadossier ON verificadossier.IdDossier = T_R_Dossier_Persona.IdDossier
																										AND verificadossier.IdPersona = T_R_Dossier_Persona.IdPersona
																										and Progressivo = 1

ORDER BY verificadossier.IdDossier																		


UPDATE  T_R_Dossier_Persona
SET CodRuoloRichiedente = 33
FROM T_R_Dossier_Persona
INNER JOIN #intestatari on #intestatari.IdRelazione = T_R_Dossier_Persona.IdRelazione


UPDATE T_R_Dossier_Persona
set CodRuoloRichiedente = 26
FROM T_R_Dossier_Persona
INNER JOIN (SELECT max(IdIncarico) IdIncarico
				,IdDossier
				,IdPersona
			FROM rs.v_CESAM_AZ_Incarichi_AFB_Dossier_NON_PopolatiCorrettamente
			group BY IdDossier
					,IdPersona) verificadossier
			ON verificadossier.IdDossier = T_R_Dossier_Persona.IdDossier
				AND verificadossier.IdPersona = T_R_Dossier_Persona.IdPersona
				AND Progressivo > 1


drop TABLE #intestatari

SELECT * FROM rs.v_CESAM_AZ_Incarichi_AFB_Dossier_NON_PopolatiCorrettamente


GO

