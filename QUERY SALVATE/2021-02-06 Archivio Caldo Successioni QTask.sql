USE clc

GO


SELECT 
ti.IdIncarico
,ti.CodArea
,format(ti.DataCreazione		,'dd/MM/yyyy HH:mm') DataCreazione
,format(ti.DataUltimaTransizione,'dd/MM/yyyy HH:mm') DataUltimaTransizione
,d.StatoWorkflowIncarico
,v.ChiaveClienteIntestatario
,v.CognomeIntestatario + ' ' + v.NomeIntestatario Intestatario
,tdoc.IdPosizioneArchivio
,D_Scaffale.Descrizione+'-'+(SUBSTRING(CAST(tdoc.IdPosizioneArchivio AS VARCHAR(50)),3,3))+'-'+
	(SUBSTRING(CAST(tdoc.IdPosizioneArchivio AS VARCHAR(50)),6,3))+'-'+
	(SUBSTRING(CAST(tdoc.IdPosizioneArchivio AS VARCHAR(50)),9,3))+'-'+
	(SUBSTRING(CAST(tdoc.IdPosizioneArchivio AS VARCHAR(50)),12,3))
	 PosizioneArchivio
FROM T_Incarico ti
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore v ON ti.IdIncarico = v.IdIncarico
AND v.ProgressivoPersona = 1
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
CROSS apply (
				SELECT MIN(Documento_id) DocId, IdPosizioneArchivio, IdIncarico
                FROM T_Documento
				WHERE T_Documento.IdIncarico = ti.IdIncarico
				GROUP BY IdPosizioneArchivio, IdIncarico
) tdoc

JOIN S_PosizioneArchivio ON tdoc.IdPosizioneArchivio = S_PosizioneArchivio.IdPosizioneArchivio
AND (CodScaffale = 30 OR (CodScaffale = 44 AND CodiceSezione IN (1,2)))
 JOIN D_Scaffale ON S_PosizioneArchivio.CodScaffale = D_Scaffale.Codice

WHERE ti.CodCliente = 23
AND ti.CodTipoIncarico = 54
--AND ti.CodArea = 2
ORDER BY ti.DataUltimaTransizione, tdoc.IdPosizioneArchivio, ti.IdIncarico