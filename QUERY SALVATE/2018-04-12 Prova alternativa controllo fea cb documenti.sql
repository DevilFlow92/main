USE CLC
GO

DECLARE @idincarico int,
@codtipoincarico int

set @idincarico = 9999241

SET @codtipoincarico = (SELECT ti.CodTipoIncarico FROM T_Incarico ti where ti.IdIncarico = @idincarico)

SELECT @codtipoincarico

;
WITH a
AS
(SELECT
		anagrafica.idpersona
	   ,CodTipoIncarico
	   ,documenti.Tipo_Documento
	   ,checklist.tipodocumento
	   ,Descrizione descrizdocumento

	FROM T_Incarico

	JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
		ON anagrafica.IdIncarico = T_Incarico.IdIncarico


	LEFT JOIN (SELECT
			8258 [tipodocumento]
		   ,@codtipoincarico[tipoincarico] UNION ALL       --     Dichiarazione primo contatto
		SELECT
			10001 [tipodocumento]
		   ,@codtipoincarico [tipoincarico] UNION ALL--HBRETAIL
		SELECT
			8257 [tipodocumento]
		   ,@codtipoincarico [tipoincarico]--   Informativa regole di comportamento del consulente
	) checklist
		ON checklist.tipoincarico = T_Incarico.CodTipoIncarico

	LEFT JOIN rs.v_CESAM_CB_PresenzaDocumenti documenti
		ON documenti.IdPersona = anagrafica.idpersona
		AND checklist.tipodocumento = documenti.Tipo_Documento
	LEFT JOIN D_Documento
		ON D_Documento.Codice = checklist.tipodocumento
		AND documenti.Tipo_Documento IS NULL
	WHERE anagrafica.IdIncarico = @idincarico)


SELECT
	descrizdocumento
FROM a
FOR XML PATH



