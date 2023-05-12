USE CLC
GO

--alter VIEW rs.CESAM_AZ_SospesiOnBoarding AS 

WITH entranti
AS (SELECT
	T_Incarico.IdIncarico
	,IdTransizione IdAperturaSospeso
	,DataTransizione AperturaSospeso
	,DENSE_RANK() OVER (PARTITION BY L_WorkflowIncarico.IdIncarico ORDER BY IdTransizione) ProgressivoApertura
FROM T_Incarico
JOIN L_WorkflowIncarico
	ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rPartenza
	ON L_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza = rPartenza.CodStatoWorkflowIncarico
	AND T_Incarico.CodCliente = rPartenza.CodCliente
	AND T_Incarico.CodTipoIncarico = rPartenza.CodTipoIncarico
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rDestinazione
	ON CodStatoWorkflowIncaricoDestinazione = rDestinazione.CodStatoWorkflowIncarico
	AND T_Incarico.CodCliente = rDestinazione.CodCliente
	AND T_Incarico.CodTipoIncarico = rDestinazione.CodTipoIncarico
WHERE CodArea = 8

AND T_Incarico.CodCliente = 23
AND rDestinazione.CodTipoIncarico = 288
AND rPartenza.CodMacroStatoWorkflowIncarico != 2
AND rDestinazione.CodMacroStatoWorkflowIncarico = 2

--and T_Incarico.IdIncarico = 10752537
),
uscenti
AS (SELECT
	T_Incarico.IdIncarico
	,DataTransizione ChiusuraSospeso
	,DENSE_RANK() OVER (PARTITION BY L_WorkflowIncarico.IdIncarico ORDER BY IdTransizione) ProgressivoChiusura
FROM T_Incarico
JOIN L_WorkflowIncarico
	ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rPartenza
	ON L_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza = rPartenza.CodStatoWorkflowIncarico
	AND T_Incarico.CodCliente = rPartenza.CodCliente
	AND T_Incarico.CodTipoIncarico = rPartenza.CodTipoIncarico
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rDestinazione
	ON CodStatoWorkflowIncaricoDestinazione = rDestinazione.CodStatoWorkflowIncarico
	AND T_Incarico.CodCliente = rDestinazione.CodCliente
	AND T_Incarico.CodTipoIncarico = rDestinazione.CodTipoIncarico
WHERE  T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico = 288
AND rPartenza.CodMacroStatoWorkflowIncarico = 2
AND rDestinazione.CodMacroStatoWorkflowIncarico != 2
)

SELECT
	T_Incarico.IdIncarico
	,RowNum = ROW_NUMBER() OVER (PARTITION BY T_Incarico.IdIncarico ORDER BY T_Incarico.IdIncarico)
	,RowNumSospesi = ROW_NUMBER() OVER (PARTITION BY IdAperturaSospeso ORDER BY ProgressivoApertura )
	,DataCreazione
	,DataUltimaTransizione DataChiusuraIncarico
	,T_Incarico.CodTipoIncarico
	,descrizioni.TipoIncarico
	,T_Incarico.CodStatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico

	,IIF(anagrafica.CodTipoPersona = 2, 'OnBoarding Persone Giuridiche','Onboarding Persone Fisiche') TipoCensimento

	,anagrafica.idpersona
	,anagrafica.ChiaveClienteIntestatario
	,IIF(anagrafica.CognomeIntestatario is NULL OR anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomeIntestatario,'') Cliente
	,anagrafica.CodicePromotore CodiceConsulente
	,IIF(anagrafica.CognomePromotore is NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomePromotore,'') Consulente
	,AperturaSospeso
	,ChiusuraSospeso
	,IIF(entranti.IdIncarico IS NOT NULL AND ROW_NUMBER() OVER (PARTITION BY T_Incarico.IdIncarico ORDER BY T_Incarico.IdIncarico) = 1,DATEDIFF(DAY,DataCreazione,DataUltimaTransizione),0) DurataIncarico
	,IIF(entranti.IdIncarico IS NOT NULL AND ROW_NUMBER() OVER (PARTITION BY IdAperturaSospeso ORDER BY ProgressivoApertura ) = 1,DATEDIFF(DAY,AperturaSospeso,ChiusuraSospeso),0) DurataSospeso
	,IIF(entranti.IdIncarico IS NOT NULL AND ROW_NUMBER() OVER (PARTITION BY T_Incarico.IdIncarico ORDER BY T_Incarico.IdIncarico) = 1, COUNT(IdComunicazione), 0) AS RimbalziPerIncarico

	,IIF(entranti.IdIncarico IS NOT NULL and ROW_NUMBER() OVER (PARTITION BY IdAperturaSospeso ORDER BY ProgressivoApertura ) = 1, 1, 0) IsSospeso
	,IIF(entranti.IdIncarico is NOT NULL AND ROW_NUMBER() OVER (PARTITION BY T_Incarico.IdIncarico ORDER BY T_Incarico.IdIncarico) = 1,1,0) IsIncaricoSospeso
	,ISNULL(entranti.IdIncarico,0) Sospesi

FROM T_Incarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON T_Incarico.IdIncarico = descrizioni.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
	ON T_Incarico.IdIncarico = anagrafica.IdIncarico
	
	AND anagrafica.ProgressivoPersona = 1

LEFT JOIN entranti
	ON T_Incarico.IdIncarico = entranti.IdIncarico
LEFT JOIN uscenti
	ON T_Incarico.IdIncarico = uscenti.IdIncarico

LEFT JOIN T_Comunicazione
	ON T_Incarico.IdIncarico = T_Comunicazione.IdIncarico
	AND CodCategoriaComunicazione = 15 --Promotore
	AND CodOrigineComunicazione = 1 --Inviata

WHERE CodArea = 8
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodTipoIncarico = 288
AND (
		ProgressivoApertura = ProgressivoChiusura 
		OR (ProgressivoApertura is NULL AND ProgressivoChiusura is NULL)
	  )

	  --AND entranti.IdIncarico IS NOT NULL
	  --AND anagrafica.CodTipoPersona = 2

--AND T_Incarico.IdIncarico = 11078471 --10752537

--AND DataCreazione >= '2018-10-01'
--AND DataCreazione < '2018-11-01'

GROUP BY	T_Incarico.IdIncarico
			,DataCreazione
			,DataUltimaTransizione
			,T_Incarico.CodTipoIncarico
			,descrizioni.TipoIncarico
			,T_Incarico.CodStatoWorkflowIncarico
			,descrizioni.StatoWorkflowIncarico
			,IIF(anagrafica.CodTipoPersona = 2, 'OnBoarding Persone Giuridiche', 'Onboarding Persone Fisiche')
			,anagrafica.idpersona
			,anagrafica.idpersona
			,anagrafica.ChiaveClienteIntestatario
			,IIF(anagrafica.CognomeIntestatario is NULL OR anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomeIntestatario,'') 
			,anagrafica.CodicePromotore
			,IIF(anagrafica.CognomePromotore is NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore) + ' ' + ISNULL(anagrafica.NomePromotore,'') 
			,entranti.IdIncarico
			,IdAperturaSospeso
			,ProgressivoApertura
			,AperturaSospeso
			,ChiusuraSospeso

GO





