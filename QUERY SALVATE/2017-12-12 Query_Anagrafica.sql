use clc

SELECT 
		isnull(pincarico.ChiaveCliente, isnull(pdossier.ChiaveCliente, ' ')) ChiaveClienteIntestatario
		,isnull(pincarico.Cognome, isnull(pdossier.Cognome, ' ')) CognomeIntestatario
		,isnull(pincarico.Nome, isnull(pdossier.Nome, ' ')) NomeIntestatario
		,isnull(pincarico.RagioneSociale, isnull(pdossier.RagioneSociale, ' ')) RagioneSocialeIntestatario
		,isnull(T_Promotore.codice, ' ') CodicePromotore
		,isnull(perspromotore.Cognome, ' ') + ' ' + isnull(perspromotore.Nome, ' ') + ' ' + isnull(perspromotore.RagioneSociale, ' ') AnagraficaPromotore

FROM T_Incarico
	left JOIN T_R_Incarico_Persona on T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico
	JOIN T_Persona pincarico ON T_R_Incarico_Persona.IdPersona = pincarico.IdPersona

	LEFT JOIN T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
	JOIN T_Mandato on T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
	JOIN T_Dossier on T_Mandato.IdDossier = T_Dossier.IdDossier
	JOIN T_R_Dossier_Persona on T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
	JOIN T_Persona pdossier on T_R_Dossier_Persona.IdPersona = pdossier.IdPersona

	--left JOIN T_Promotore on T_Dossier.IdPromotore = T_Promotore.IdPromotore
	--JOIN T_Persona perspromotore ON T_Promotore.IdPersona = perspromotore.IdPersona

	LEFT JOIN T_R_Incarico_Promotore on T_Incarico.IdIncarico = T_R_Incarico_Promotore.IdIncarico
	JOIN T_Promotore on T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
	JOIN T_Persona perspromotore ON T_Promotore.IdPersona = perspromotore.IdPersona