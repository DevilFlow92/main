USE clc

GO

WITH dataset AS (
SELECT ti.IdIncarico
,ti.CodAttributoIncarico
,descrizioni.AttributoIncarico
,descrizioni.StatoWorkflowIncarico
,tp.ChiaveCliente CodiceCliente
,CASE WHEN tp.Cognome IS NULL OR tp.Cognome = '' THEN tp.RagioneSociale
	ELSE tp.Cognome + ISNULL(' ' + tp.Nome,'') END NominativoCliente
,tdocumento.Documento_id
,tdocumento.DataInserimento
,tdocumento.IdOperatoreInserimento
,contattopersona.Email
,CASE WHEN contattopersona.IdContatto IS NOT NULL THEN 1 ELSE 0 END FlagContattoIPOClubPersona
,CASE WHEN tdocumento.Documento_id IS NOT NULL THEN 1 ELSE 0 END FlagDocumentoImbarcato
FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico
LEFT JOIN T_R_Incarico_Promotore tripromo ON ti.IdIncarico = tripromo.IdIncarico
LEFT JOIN T_Promotore tpromo ON tripromo.IdPromotore = tpromo.idpromotore

LEFT JOIN t_r_incarico_persona trip ON ti.IdIncarico = trip.IdIncarico
LEFT JOIN T_Persona tp ON trip.IdPersona = tp.IdPersona

OUTER APPLY (
				SELECT TOP 1 IdContatto, Email
				FROM T_Contatto
				WHERE flagattivo = 1
				AND codruolocontatto = 10
				AND Email IS NOT NULL
				AND tp.IdPersona = T_Contatto.IdPersona		
				ORDER BY T_Contatto.IdContatto DESC
) contattopersona

OUTER APPLY (
				SELECT TOP 1 Documento_id, DataInserimento, IdOperatoreInserimento
				FROM T_Documento
				WHERE FlagPresenzaInFileSystem = 1
				AND FlagScaduto = 0
				AND Tipo_Documento = 259686
				AND T_Documento.IdIncarico = ti.IdIncarico


) tdocumento

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 565
AND ti.DataCreazione >= '20210527'
--AND tpromo.IdPromotore IS null

) SELECT * FROM dataset
WHERE FlagContattoIPOClubPersona = 0
