USE CLC_Cesam
GO


WITH v AS (
	SELECT t.chiavecliente, IdPersona
	FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI t
	JOIN dbo.T_Persona ON dbo.T_Persona.ChiaveCliente = t.chiavecliente
	WHERE t.DataUpload >= '20230301'
	AND t.codtipoincarico IN (167	--Sottoscrizioni Previdenza
,572	--Sottoscrizioni Previdenza - Zenith
)
GROUP BY t.chiavecliente, IdPersona
UNION ALL
	SELECT t.chiavecliente, IdPersona
	FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t
	JOIN dbo.T_Persona ON dbo.T_Persona.ChiaveCliente = t.chiavecliente
	WHERE t.DataUpload >= '20230301'
	AND t.codtipoincarico IN (657	--AZISF - Sottoscrizioni Previdenza
,658 --AZISF - Disinvestimenti Previdenza
)
GROUP BY t.chiavecliente, IdPersona
)
,nodocsid AS (
SELECT v.IdPersona, v.chiavecliente CodiceCliente, 
CASE WHEN cognome IS NULL OR cognome = ''
	THEN RagioneSociale
	ELSE Cognome + ISNULL(' ' + nome,'') 
	END Nominativo
,CodiceFiscale
FROM v
JOIN dbo.T_Persona ON v.IdPersona = T_Persona.IdPersona
LEFT JOIN rs.v_CESAM_AZ_Documento_Identita_Recente vdoc ON v.IdPersona = vdoc.IdPersona
WHERE vdoc.IdPersona IS NULL
)
--SELECT * FROM nodocsid
--/*
SELECT CodiceCliente
,nodocsid.Nominativo
,nodocsid.CodiceFiscale
,T_Incarico.IdIncarico
,d.TipoIncarico
,d.StatoWorkflowIncarico
FROM nodocsid

CROSS APPLY (
SELECT MAX(dbo.T_Incarico.idincarico) IdIncarico 
FROM  dbo.T_R_Incarico_Persona
JOIN dbo.T_Incarico ON T_R_Incarico_Persona.IdIncarico = T_Incarico.IdIncarico
AND Progressivo = 1
and CodCliente = 23
AND CodArea = 8
AND FlagArchiviato = 0 
AND CodTipoIncarico IN (288,396)
WHERE nodocsid.IdPersona = dbo.T_R_Incarico_Persona.IdPersona
)T_Incarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON T_Incarico.IdIncarico = d.IdIncarico

ORDER BY nodocsid.IdPersona

--*/



--SELECT * FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture
--JOIN dbo.T_Persona ON CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture.chiavecliente = T_Persona.ChiaveCliente
--WHERE IdPersona = 3832345
