USE CLC
GO

;WITH doppiRuoli33 AS 
(
SELECT
	T_Incarico.IdIncarico
	,T_Dossier.IdDossier
	--,COUNT(T_R_Dossier_Persona.CodRuoloRichiedente)
FROM T_Incarico
JOIN T_R_Incarico_Mandato
	ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
	AND T_Incarico.CodCliente = 23
	AND CodArea = 8
	
	AND T_R_Incarico_Mandato.Progressivo = 1
JOIN T_Mandato
	ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
JOIN T_Dossier
	ON T_Dossier.IdDossier = T_Mandato.IdDossier
JOIN T_R_Dossier_Persona
	ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
JOIN T_Persona
	ON T_Persona.IdPersona = T_R_Dossier_Persona.IdPersona
WHERE CodRuoloRichiedente = 33

--AND T_Incarico.IdIncarico = 10687957 

GROUP BY	
T_Incarico.IdIncarico
,T_Dossier.IdDossier

HAVING COUNT(CodRuoloRichiedente) >= 2 
)

SELECT   
MAX(T_Incarico.IdIncarico) IdIncarico
--,CodTipoIncarico
--,D_TipoIncarico.Descrizione TipoIncarico
,T_R_Dossier_Persona.IdDossier
,NumeroDossier
,T_Persona.ChiaveCliente
,T_R_Dossier_Persona.Progressivo
,T_R_Dossier_Persona.CodRuoloRichiedente
,IIF(RagioneSociale = '' OR RagioneSociale = ' ' OR RagioneSociale IS NULL,Cognome + SPACE(1) + Nome,RagioneSociale) Nominativo

FROM T_Incarico
JOIN D_TipoIncarico on CodTipoIncarico = D_TipoIncarico.Codice
JOIN doppiRuoli33 ON T_Incarico.IdIncarico = doppiRuoli33.IdIncarico
JOIN T_Dossier ON doppiRuoli33.IdDossier = T_Dossier.IdDossier
JOIN T_R_Dossier_Persona on T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
JOIN T_Persona ON T_R_Dossier_Persona.IdPersona = T_Persona.IdPersona

WHERE T_R_Dossier_Persona.CodRuoloRichiedente = 33

AND T_Incarico.DataCreazione >= '20170101'

--AND T_Incarico.IdIncarico in (9130177,9130178)

GROUP BY
T_R_Dossier_Persona.IdDossier
,NumeroDossier
,T_Persona.ChiaveCliente
,T_R_Dossier_Persona.Progressivo
,T_R_Dossier_Persona.CodRuoloRichiedente
,IIF(RagioneSociale = '' OR RagioneSociale = ' ' OR RagioneSociale IS NULL,Cognome + SPACE(1) + Nome,RagioneSociale)