USE clc
GO

--SELECT * FROM D_TipoIncarico WHERE Descrizione LIKE '%disguidata%'

SELECT
	MIN(T_Incarico.IdIncarico) IdIncarico
	,CodTipoIncarico
FROM T_Incarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore
	ON T_Incarico.IdIncarico = rs.v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico
LEFT JOIN T_Documento
	ON T_Incarico.IdIncarico = T_Documento.IdIncarico

WHERE CodArea = 2
AND Documento_id IS NULL
AND v_CESAM_Anagrafica_Cliente_Promotore.idpersona IS NULL
AND idpromotore IS NULL
--AND CodStatoWorkflowIncarico = 6500

AND CodCliente = 23

AND CodTipoIncarico = 90

--AND T_Incarico.IdIncarico = 11052342 

GROUP BY CodTipoIncarico
