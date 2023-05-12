USE clc
GO

SELECT DISTINCT ti.IdIncarico
,ti.DataCreazione
,ti.DataUltimaTransizione
,LagTransizione.DataPenultimaTransizione
,tdoc.IdPosizioneArchivio IdPosizioneArchivioDocumento
,T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio IdPosizioneArchivioAssegnata
,van.ChiaveClienteIntestatario [NDG Decuius]
,van.CognomeIntestatario [Cognome Decuius]
,van.NomeIntestatario [Nome Decuius]
,D_Scaffale.Descrizione+'-'+(SUBSTRING(CAST(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio AS VARCHAR(50)),3,3))+'-'+
	(SUBSTRING(CAST(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio AS VARCHAR(50)),6,3))+'-'+
	(SUBSTRING(CAST(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio AS VARCHAR(50)),9,3))+'-'+
	(SUBSTRING(CAST(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio AS VARCHAR(50)),12,3))
	 PosizioneReale

FROM T_Incarico ti
JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico 
AND tdoc.IdPosizioneArchivio IS NOT NULL

JOIN T_PeriodoPosizioneArchivioUtilizzata ON ti.IdIncarico = T_PeriodoPosizioneArchivioUtilizzata.IdIncarico

JOIN D_Scaffale ON LEFT(T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio,2) = Codice

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico
AND van.codruolorichiedente = 4 --Decuius

CROSS APPLY (
				SELECT TOP 1 lwix.IdTransizione, lwix.DataTransizione DataPenultimaTransizione
                FROM L_WorkflowIncarico lwix
				WHERE lwix.IdIncarico = ti.IdIncarico
				AND lwix.DataTransizione <> ti.DataUltimaTransizione
				ORDER BY lwix.DataTransizione DESC

) LagTransizione

OUTER APPLY ( SELECT TOP 1 * 
				FROM orga.Y_PuliziaArchivio_Qtask ypx
				WHERE ypx.idIncarico = ti.IdIncarico

) PuliziaArchivio

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 54
AND ti.CodStatoWorkflowIncarico = 820
AND PuliziaArchivio.idIncarico IS NULL
AND (
		ti.DataUltimaTransizione < '20210101'
		OR (ti.DataUltimaTransizione >= '20210610' AND ti.DataUltimaTransizione < '20210611' AND LagTransizione.DataPenultimaTransizione < '20210101')

)
--AND LagTransizione.DataPenultimaTransizione < '20210101'



