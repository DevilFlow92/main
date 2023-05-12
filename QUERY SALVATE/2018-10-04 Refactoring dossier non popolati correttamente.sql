USE CLC
GO

ALTER view rs.v_CESAM_AZ_PersonaRipetutaNelDossier AS

WITH doppioni AS 
(
	SELECT IdDossier
			,IdPersona
			,count(IdRelazione) N_Persone
	FROM T_R_Dossier_Persona  
	--WHERE IdDossier = 112437
	group by IdDossier, IdPersona
	HAVING COUNT(IdRelazione) > 1
	

)
SELECT MAX(T_Incarico.IdIncarico) IdIncarico
--,CodTipoIncarico
,T_Mandato.IdDossier
,NumeroDossier
,doppioni.IdPersona IdPersonaRipetuta
,T_Persona.ChiaveCliente ChiaveClientePersona
,CASE WHEN T_Persona.Cognome = '' OR T_Persona.Nome = '' 
			OR T_Persona.Cognome IS NULL OR T_Persona.Nome IS NULL 
	THEN T_Persona.RagioneSociale 
	ELSE T_Persona.Cognome + ' ' + T_persona.Nome END as Persona
,perspromotore.ChiaveCliente ChiaveClientePromotore
,CASE WHEN perspromotore.Cognome='' OR perspromotore.Cognome is NULL
			OR perspromotore.Nome = '' OR perspromotore.Nome is NULL
	THEN perspromotore.RagioneSociale
	ELSE perspromotore.Cognome + ' ' + perspromotore.Nome END as Promotore

,tr1.Progressivo Progressivo1
,trN.Progressivo ProgressivoN

,tr1.CodRuoloRichiedente CodRuoloRichiedente1
,d1.Descrizione DescrizioneRuolo1
,trN.CodRuoloRichiedente CodRuoloRichiedenteRipetuto
,dN.Descrizione DescrizioneRuoloRipetuto
,MAX(DataCreazione) DataCreazione


FROM T_Incarico

JOIN T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico and Progressivo = 1
JOIN T_Mandato on T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
JOIN T_Dossier on T_Mandato.IdDossier = T_Dossier.IdDossier
JOIN doppioni on T_Dossier.IdDossier = doppioni.IdDossier
JOIN T_Persona ON doppioni.IdPersona = T_Persona.IdPersona

JOIN (SELECT MIN(IdRelazione) IdRelazione, IdDossier, T_R_Dossier_Persona.IdPersona --,CodRuoloRichiedente CodRuoloRichiedente1
		FROM T_R_Dossier_Persona
		--WHERE IdDossier = 152848
		GROUP BY IdDossier, IdPersona) trMin ON doppioni.IdDossier = trMin.IdDossier
											AND doppioni.IdPersona = trMin.IdPersona

JOIN T_R_Dossier_Persona tr1 ON tr1.IdRelazione = trMin.IdRelazione

JOIN (SELECT IdDossier, MAX(IdRelazione) IdRelazione, T_R_Dossier_Persona.IdPersona --,CodRuoloRichiedente CodRuoloRichiedenteN
		FROM T_R_Dossier_Persona
		--WHERE IdDossier = 152848
		GROUP BY IdDossier, IdPersona) trMax ON doppioni.IdDossier = trMax.IdDossier
														AND doppioni.IdPersona = trMax.IdPersona

JOIN T_R_Dossier_Persona trN ON trMax.IdRelazione = trN.IdRelazione

LEFT JOIN T_Promotore on T_Dossier.IdPromotore = T_Promotore.IdPromotore
LEFT JOIN T_Persona perspromotore ON perspromotore.IdPersona = T_Promotore.IdPersona

JOIN D_RuoloRichiedente d1 ON d1.Codice = tr1.CodRuoloRichiedente
JOIN D_RuoloRichiedente dN ON dN.Codice = trN.CodRuoloRichiedente

where T_Incarico.CodCliente = 23
AND CodArea = 8
--AND DataCreazione >= '20180701'

--AND T_Incarico.IdIncarico = 11026251

--AND T_Incarico.IdIncarico = 4424682 --preprod

--and doppioni.IdDossier = 152848

GROUP BY
--CodTipoIncarico
T_Mandato.IdDossier
,NumeroDossier
,doppioni.IdPersona 
,T_Persona.ChiaveCliente 
,CASE WHEN T_Persona.Cognome = '' OR T_Persona.Nome = '' 
			OR T_Persona.Cognome IS NULL OR T_Persona.Nome IS NULL 
	THEN T_Persona.RagioneSociale 
	ELSE T_Persona.Cognome + ' ' + T_persona.Nome END 
,perspromotore.ChiaveCliente 
,CASE WHEN perspromotore.Cognome='' OR perspromotore.Cognome is NULL
			OR perspromotore.Nome = '' OR perspromotore.Nome is NULL
	THEN perspromotore.RagioneSociale
	ELSE perspromotore.Cognome + ' ' + perspromotore.Nome END  

,tr1.Progressivo 
,trN.Progressivo 

,tr1.CodRuoloRichiedente 
,d1.Descrizione 
,trN.CodRuoloRichiedente 
,dN.Descrizione 


/*
SELECT DISTINCT
T_Incarico.IdIncarico
,CodTipoIncarico
,tr1.IdDossier
,T_Dossier.NumeroDossier
,tr1.IdPersona IdPersonaRipetuta
,T_Persona.ChiaveCliente ChiaveClientePersona
,CASE WHEN T_Persona.Cognome = '' OR T_Persona.Nome = '' 
			OR T_Persona.Cognome IS NULL OR T_Persona.Nome IS NULL 
	THEN T_Persona.RagioneSociale 
	ELSE T_Persona.Cognome + ' ' + T_persona.Nome END as Persona
,perspromotore.ChiaveCliente ChiaveClientePromotore
,CASE WHEN perspromotore.Cognome='' OR perspromotore.Cognome is NULL
			OR perspromotore.Nome = '' OR perspromotore.Nome is NULL
	THEN perspromotore.RagioneSociale
	ELSE perspromotore.Cognome + ' ' + perspromotore.Nome END as Promotore
,tr1.CodRuoloRichiedente CodRuoloRichiedente1
,d_ruolo1.Descrizione DescrizioneRuolo1
,trN.CodRuoloRichiedente CodRuoloRichiedenteRipetuto
,d_ruolo2.Descrizione DescrizioneRuoloRipetuto
,DataCreazione

from T_Incarico
	left join T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
	left join T_Mandato on T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
	left JOIN T_Dossier on T_Mandato.IdDossier = T_Dossier.IdDossier
	left join T_R_Dossier_Persona tr1 on T_Dossier.IdDossier = tr1.IdDossier and tr1.Progressivo = 1
	left JOIN T_R_Dossier_Persona trN on T_Dossier.IdDossier = trN.IdDossier AND trN.Progressivo > 1
	
	LEFT JOIN T_Persona on tr1.IdPersona = T_Persona.IdPersona
	left JOIN T_Promotore PromDossier on T_Dossier.IdPromotore = PromDossier.IdPromotore
    left JOIN T_Persona perspromotore ON PromDossier.IdPersona = perspromotore.IdPersona
	
	left JOIN D_RuoloRichiedente d_ruolo1 on tr1.CodRuoloRichiedente = d_ruolo1.Codice
	left JOIN D_RuoloRichiedente d_ruolo2 on trN.CodRuoloRichiedente = d_ruolo2.Codice

where 
	CodArea = 8
	and T_Incarico.CodCliente = 23 AND 
	tr1.IdPersona = trN.IdPersona and tr1.IdDossier = trN.IdDossier

	--AND DataCreazione >= '2018-01-01'

	AND T_Dossier.IdDossier = 152848

SELECT DISTINCT T_Incarico.IdIncarico FROM T_Incarico JOIN T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico 
JOIN T_Mandato on T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
WHERE IdDossier = 
152848

--GROUP BY
--CodTipoIncarico
--,tr1.IdDossier
--,T_Dossier.NumeroDossier
--,tr1.IdPersona 
--,T_Persona.ChiaveCliente 
--,CASE WHEN T_Persona.Cognome = '' OR T_Persona.Nome = '' 
--			OR T_Persona.Cognome IS NULL OR T_Persona.Nome IS NULL 
--	THEN T_Persona.RagioneSociale 
--	ELSE T_Persona.Cognome + ' ' + T_persona.Nome END
--,perspromotore.ChiaveCliente
--,CASE WHEN perspromotore.Cognome='' OR perspromotore.Cognome is NULL
--			OR perspromotore.Nome = '' OR perspromotore.Nome is NULL
--	THEN perspromotore.RagioneSociale
--	ELSE perspromotore.Cognome + ' ' + perspromotore.Nome END
--,tr1.CodRuoloRichiedente 
--,d_ruolo1.Descrizione 
--,trN.CodRuoloRichiedente 
--,d_ruolo2.Descrizione 
--,DataCreazione

*/

GO