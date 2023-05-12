USE CLC
GO

;
WITH listaincarichi AS (
SELECT IdIncarico FROM T_Incarico
WHERE IdIncarico IN (

/* inserire qui gli incarichi segnalati da acquisizione su sos */ 
18445352
,16429931
,19020086
,17889821



/****************************************************************/
)


), lol AS (

SELECT orga.ap_GetStringBetween2Chars(NomeFileOriginale,'_','.')	Docid, tdoc.IdIncarico FROM T_Documento tdoc
JOIN listaincarichi ON tdoc.IdIncarico = listaincarichi.IdIncarico
WHERE tdoc.FlagPresenzaInFileSystem = 1
AND tdoc.FlagScaduto = 0
AND note = '144dpi'
AND tdoc.Tipo_Documento = 102
)

SELECT T_Documento.IdIncarico, T_Documento.Documento_id IdDocumento, CAST(T_Documento.IdIncarico as VARCHAR(29))+'_'+CAST(T_documento.Documento_id as VARCHAR(29))+'.pdf' NomeFile 
,Note
--,nome_file
FROM T_Documento
JOIN listaincarichi ON T_Documento.IdIncarico = listaincarichi.IdIncarico
LEFT JOIN lol ON CAST(T_Documento.Documento_id AS VARCHAR(50)) = lol.Docid
AND lol.IdIncarico = T_Documento.IdIncarico

WHERE 
T_Documento.Tipo_Documento = 102  
and ( T_Documento.note IS NULL OR t_Documento.note <> '144DPI')
AND lol.Docid IS NULL

ORDER BY T_Documento.IdIncarico, T_Documento.Documento_id



