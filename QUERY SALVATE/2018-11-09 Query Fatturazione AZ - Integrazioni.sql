USE clc
GO

--ALTER VIEW rs.v_CESAM_AZ_FatturazioneIncarichi_Integrazioni AS

/* Author: Lorenzo Fiori
	Utilizzata nel report: AZ - Fatturazione Mensile

*/


/*
DECLARE	@DataDal DATETIME
		,@DataAl DATETIME

SET @DataDal = '2018-09-01'
SET @DataAl = '2018-10-01'
;
*/

WITH integrazioni As
(
	SELECT T_Incarico.IdIncarico
	,IdTransizione IdTransizioneIntegrazione
	,DataTransizione DataIntegrazioneDocumento
	,D_AttributoIncarico.Descrizione Attributo
	
	FROM T_Incarico
	LEFT JOIN L_WorkflowIncarico ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
	LEFT JOIN D_AttributoIncarico ON D_AttributoIncarico.Codice = CodAttributoIncaricoDestinazione

	WHERE CodArea = 8
	AND CodCliente = 23
	AND CodTipoIncarico = 54
	AND (CodAttributoIncaricoPartenza <> 239 or CodAttributoIncaricoPartenza is NULL)		
	AND CodAttributoIncaricoDestinazione = 239	--INTEGRAZIONI RICEVUTE
	--AND T_Incarico.IdIncarico = 3269973
	AND IdOperatore = 21
)
, riaperture AS 
(
SELECT T_Incarico.IdIncarico
,IdTransizione IdTransizioneRiapertura
,DataTransizione DataRiaperturaIncarico

 FROM T_Incarico
LEFT JOIN L_WorkflowIncarico on T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
WHERE CodArea = 8
AND CodCliente = 23
AND CodStatoWorkflowIncaricoPartenza in (8570 --Acquisita
										,820  --Lavorazione Conclusa	
										)
AND CodStatoWorkflowIncaricoDestinazione = 6551	--Da RiLavorare

)
, OriginaliRientrati AS 
(
SELECT
	T_Incarico.IdIncarico
	,IdTransizione IdTransizioneOriginale
	,DataTransizione DataRicezioneOriginale
	,D_AttributoIncarico.Descrizione Attributo


FROM T_Incarico
LEFT JOIN L_WorkflowIncarico
	ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
LEFT JOIN D_AttributoIncarico
	ON D_AttributoIncarico.Codice = CodAttributoIncaricoDestinazione


WHERE CodArea = 8
AND CodCliente = 23
AND (CodAttributoIncaricoPartenza <> 540 or CodAttributoIncaricoPartenza is NULL)
AND CodAttributoIncaricoDestinazione = 540	--ORIGINALE RIENTRATO
AND IdOperatore = 21
--AND T_Incarico.IdIncarico = 10901554 
)

SELECT DISTINCT
	 ti.IdIncarico
	,ti.DataCreazione
	,ti.CodTipoIncarico
	,D_TipoIncarico.Descrizione TipoIncarico
	--,DataTransizione
	
	,integrazioni.IdTransizioneIntegrazione
	,DataIntegrazioneDocumento
	,integrazioni.Attributo AttributoIntegrazione

	,riaperture.IdTransizioneRiapertura
	,DataRiaperturaIncarico
	,OriginaliRientrati.IdTransizioneOriginale
	,DataRicezioneOriginale
	,OriginaliRientrati.Attributo AttributoRientroOriginale

FROM T_Incarico ti
JOIN D_TipoIncarico on ti.CodTipoIncarico = D_TipoIncarico.Codice
LEFT JOIN L_WorkflowIncarico on ti.IdIncarico = L_WorkflowIncarico.IdIncarico
LEFT JOIN integrazioni on ti.IdIncarico = integrazioni.IdIncarico
LEFT JOIN riaperture on ti.IdIncarico = riaperture.IdIncarico
LEFT JOIN OriginaliRientrati ON ti.IdIncarico = OriginaliRientrati.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND (IdTransizioneIntegrazione IS NOT NULL
		OR IdTransizioneOriginale IS NOT NULL
		OR IdTransizioneRiapertura IS NOT NULL
	)

--AND ti.IdIncarico = 3520322
--AND IdTransizioneIntegrazione is NOT NULL

--AND (
--		(DataIntegrazioneDocumento >= @DataDal AND DataIntegrazioneDocumento < @DataAl)
--	OR (DataRiaperturaIncarico >= @DataDal and DataRiaperturaIncarico < @DataAl)
--	OR (DataRicezioneOriginale >= @DataDal and DataRicezioneOriginale < @DataAl)
--	)

GO