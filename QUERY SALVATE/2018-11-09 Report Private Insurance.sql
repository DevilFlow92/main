USE CLC
GO

--CREATE view rs.v_CESAM_AZ_PrivateInsurance_ReportLavorazioni AS 

/* Author: Silvia Montis
   Review: Lorenzo Fiori
   Utilizzata nel report: AZ - PrivateInsurance_ReportLavorazioni
*/

SELECT DISTINCT
	T_Incarico.DataCreazione
	,T_Incarico.IdIncarico
	,descrizioni.TipoIncarico 
	,descrizioni.DescrizioneMacroStatoWorkFlowIncarico AS MacroStatoWorkflowIncarico
	,descrizioni.DescrizioneStatoWorkflowIncarico AS  StatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico AS STATO
	,IIF(FlagAttesa =  1,'SI','NO') AS Attesa
	,IIF(descrizioni.CodMacroStatoWFIncarico IN (12,9),descrizioni.AttributoIncarico,'') as [Motivo Sospensione]
	,IIF(T_Incarico.CodAttributoIncarico = 238,Nota,'') AS [Nota Sospensione]

	/* ANAGRAFICA CLIENTE PROMOTORE */
	,anagrafica.DescrizioneCentroRaccolta AS CentroRaccolta
	,anagrafica.DescrizioneAreaCentroRaccolta AS Area
	,UPPER(anagrafica.CodicePromotore + ' ' + IIF(anagrafica.CognomePromotore is NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore) + ' ' 
		+ IIF(anagrafica.NomePromotore is NULL or anagrafica.NomePromotore = '','',anagrafica.NomePromotore)) AS Promotore
	,UPPER(LTRIM(RTRIM(ISNULL(personapolizza.ChiaveCliente,'')))) + ' ' + IIF(personapolizza.Cognome IS null OR personapolizza.Cognome = '',personapolizza.RagioneSociale,personapolizza.Cognome) + ' ' 
		+ IIF(personapolizza.Nome is NULL or personapolizza.Nome = '','',personapolizza.Nome) AS Cliente
	
	/* CAMPI ADESIONE POLIZZA */
	,T_AdesionePolizza.ImportoPremio
	,T_AdesionePolizza.NumeroPolizza
	,S_Polizza.Descrizione AS 'Polizza'
	,E_Assicurazione.RagioneSociale1 AS 'Assicurazione'
	,T_DatoAggiuntivo.Testo
	,T_Incarico.DataUltimaTransizione
	
FROM T_Incarico
LEFT OUTER JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni WITH(NOLOCK) on T_Incarico.IdIncarico = descrizioni.IdIncarico

LEFT OUTER JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica WITH(NOLOCK) ON T_Incarico.IdIncarico = anagrafica.IdIncarico

LEFT OUTER JOIN T_SinistroPolizza
	ON T_Incarico.IdIncarico = T_SinistroPolizza.IdIncarico
LEFT OUTER JOIN T_AdesionePolizza
	ON T_AdesionePolizza.IdAdesionePolizza = T_SinistroPolizza.IdAdesionePolizza
LEFT OUTER JOIN T_R_AdesionePolizza_Persona
	ON T_AdesionePolizza.IdAdesionePolizza = T_R_AdesionePolizza_Persona.IdAdesionePolizza
	AND T_R_AdesionePolizza_Persona.Progressivo = 1
LEFT OUTER JOIN T_Persona personapolizza ON T_R_AdesionePolizza_Persona.idpersona = personapolizza.IdPersona
	
LEFT OUTER JOIN E_Assicurazione
	ON T_AdesionePolizza.CodAssicurazione = E_Assicurazione.Codice
	AND E_Assicurazione.CodCliente = 23
LEFT OUTER JOIN S_Polizza
	ON S_Polizza.IdPolizza = T_AdesionePolizza.IdPolizza

LEFT OUTER JOIN T_Sospeso
	ON T_Sospeso.IdIncarico = T_Incarico.IdIncarico
LEFT OUTER JOIN T_R_Sospeso_MotivazioneSottoMotivazioneModalita
	ON T_Sospeso.IdSospeso = T_R_Sospeso_MotivazioneSottoMotivazioneModalita.IdSospeso

INNER JOIN T_DatoAggiuntivo
	ON T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico
	AND T_DatoAggiuntivo.CodTipoDatoAggiuntivo = 876


WHERE T_Incarico.CodCliente = 23
AND T_Incarico.CodArea = 8
AND T_Incarico.CodStatoWorkflowIncarico NOT IN (440)
AND T_Incarico.CodTipoIncarico = 296


--AND DataCreazione >= '2018-07-01' 
--AND DataCreazione < '2018-10-31'

--10578779



--SELECT 	DataCreazione
--		,IdIncarico
--		,TipoIncarico
--		,MacroStatoWorkflowIncarico
--		,StatoWorkflowIncarico
--		,STATO
--		,Attesa
--		,[Motivo Sospensione]
--		,[Nota Sospensione]
--		,CentroRaccolta
--		,Area
--		,Promotore
--		,Cliente
--		,ImportoPremio
--		,NumeroPolizza
--		,Polizza
--		,Assicurazione
--		,Testo
--		,DataUltimaTransizione

--FROM rs.v_CESAM_AZ_PrivateInsurance_ReportLavorazioni

--WHERE DataCreazione >= @DataDal
--AND DataCreazione < @DataAl

