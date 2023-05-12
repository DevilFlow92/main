USE CLC
GO

WITH base AS (

SELECT * FROM rs.v_CESAM_AZ_Antiriciclaggio_ReportAtteseSchede

),calcolo AS ( 

SELECT 	base.*
,primarichiesta.DataTransizione PrimaRichiestaScheda

,DATEDIFF(DAY, base.DataTransizionePrecedente, base.DataTransizione) gg1
,IIF(base.IdTransizione = base.ultimaTransizione, DATEDIFF(DAY, base.DataTransizione, @Data), 0) gg2
FROM base
JOIN (SELECT
	MIN(IdTransizione) IdTransizione
	,IdIncarico
FROM L_WorkflowIncarico
WHERE CodAttributoIncaricoDestinazione = 285	--PRIMA RICHIESTA SCHEDA PF
OR CodStatoWorkflowIncaricoDestinazione = 15540	--Invio richiesta approfondimenti al CF
GROUP BY IdIncarico) inputprimarichiesta
	ON base.IdIncarico = inputprimarichiesta.IdIncarico
JOIN L_WorkflowIncarico primarichiesta
	ON inputprimarichiesta.IdTransizione = primarichiesta.IdTransizione
)

SELECT 	IdIncarico
		,ChiaveCliente
		,FlagUrgente
		,StatoWorkflowIncarico
		,AttributoIncarico
		,Anagrafica
		,IdAntiriciclaggio
		,CodMotivoVerifica
		,MotivoVerifica
		,CodSanatoriaFiscale
		,SanatoriaFiscale
		,Promotore
		,DataCreazione
		,GestoreIncarico
		,PrimaRichiestaScheda
		,DATEDIFF(DAY,PrimaRichiestaScheda,@Data) NGiorni
		,SUM(gg1+gg2) GiorniEffettivi
FROM calcolo 

WHERE TipoTransizione > 0
AND DataUltimaTransizione < CONVERT(DATE,DATEADD(DAY,1,@Data))

GROUP BY IdIncarico
		,ChiaveCliente
		,FlagUrgente
		,StatoWorkflowIncarico
		,AttributoIncarico
		,Anagrafica
		,IdAntiriciclaggio
		,CodMotivoVerifica
		,MotivoVerifica
		,CodSanatoriaFiscale
		,SanatoriaFiscale
		,Promotore
		,DataCreazione
		,GestoreIncarico
		,PrimaRichiestaScheda