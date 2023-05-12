use CLC

SELECT DISTINCT   
	T_R_Dossier_Persona.*
	,Cognome
	,Nome
	,RagioneSociale

FROM T_R_Incarico_Mandato
join T_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
JOIN T_Dossier on T_Dossier.IdDossier = T_Mandato.IdDossier
JOIN T_R_Dossier_Persona on T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
JOIN T_Persona on T_Persona.IdPersona = T_R_Dossier_Persona.IdPersona
where IdIncarico = 9590403


/*

UPDATE T_R_Dossier_Persona
set CodRuoloRichiedente = 33
WHERE IdRelazione IN (

)

update T_R_Dossier_Persona
SET CodRuoloRichiedente = 26
WHERE IdRelazione in(

 )

*/


GO


