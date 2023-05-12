USE clc
SELECT DISTINCT T_Incarico.IdIncarico,
IncaricoAssociato.IdIncarico,
		incarico.DataUltimaTransizione,
		D_StatoWorkflowIncarico.Descrizione statowf,
	T_Documento.IdPosizioneArchivio,
	CodicePromotore + '-'+ISNULL(CognomePromotore,RagioneSocialePromotore) Promotore,
	ChiaveClienteIntestatario + '-'+CognomeIntestatario +'-'+NomeIntestatario Persona,
	D_Scaffale.Descrizione+'-'+(SUBSTRING(CAST(T_Documento.IdPosizioneArchivio AS VARCHAR(50)),3,3))+'-'+
	(SUBSTRING(CAST(T_Documento.IdPosizioneArchivio AS VARCHAR(50)),6,3))+'-'+
	(SUBSTRING(CAST(T_Documento.IdPosizioneArchivio AS VARCHAR(50)),9,3))+'-'+
	(SUBSTRING(CAST(T_Documento.IdPosizioneArchivio AS VARCHAR(50)),12,3))
	 PosizioneArchivio
 
	--CAST(RIGHT(IdPosizioneArchivio,12) AS VARCHAR(50)) PosizioneArchivio
FROM T_Incarico 
JOIN D_StatoWorkflowIncarico ON Codice = CodStatoWorkflowIncarico
JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
LEFT JOIN orga.Y_PuliziaArchivio_Qtask ON T_Incarico.IdIncarico = orga.Y_PuliziaArchivio_Qtask.idIncarico
LEFT JOIN D_Scaffale ON LEFT(IdPosizioneArchivio,2) = D_Scaffale.Codice
 
JOIN T_Documento IncaricoAssociato ON IncaricoAssociato.IdPosizioneArchivio = T_Documento.IdPosizioneArchivio
JOIN T_Incarico incarico ON IncaricoAssociato.IdIncarico = incarico.IdIncarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore ON incarico.IdIncarico = rs.v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico
 
WHERE T_Incarico.CodTipoIncarico = 54
AND T_Incarico.CodArea = 8
AND T_Incarico.CodStatoWorkflowIncarico = 820
AND incarico.CodStatoWorkflowIncarico = 820

AND T_Incarico.DataUltimaTransizione >= '20170101' AND  T_Incarico.DataUltimaTransizione < '20210101'
AND incarico.DataUltimaTransizione >= '20170101' AND incarico.DataUltimaTransizione  < '20210101'
AND orga.Y_PuliziaArchivio_Qtask.idIncarico IS NULL
AND T_Documento.IdPosizioneArchivio IS NOT NULL
ORDER BY T_Documento.IdPosizioneArchivio , T_Incarico.IdIncarico