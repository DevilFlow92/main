USE CLC

GO
WITH missing AS (
SELECT  IdPromotore,l.Cod_PF, l.Des_PF, l.Qualifica
FROM T_Promotore
JOIN T_Persona ON T_Promotore.IdPersona = T_Persona.IdPersona
AND CodCliente = 23 --azimut
JOIN scratch.L_CESAM_AZ_Import_AnagraficaConsulenti l ON l.Cod_PF= Codice
LEFT JOIN T_Contatto ON T_Promotore.IdPersona = T_Contatto.IdPersona
AND CodTipoContatto IN (7,1)

WHERE IdContatto is NULL and l.Qualifica = 'codice di servizio'
)

SELECT DISTINCT 
missing.* 
FROM missing
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON missing.IdPromotore = van.idpromotore
JOIN T_Incarico ON van.IdIncarico = T_Incarico.IdIncarico
JOIN T_R_Incarico_Controllo ON T_Incarico.IdIncarico = T_R_Incarico_Controllo.IdIncarico
JOIN T_Controllo on T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
AND IdTipoControllo IN (6086
,7144
,7145
,7146
)
WHERE CodArea = 8
AND CodCliente = 23
AND CodTipoIncarico IN (90	--Posta Disguidata
,404	--Posta Disguidata AFB
,405	--Posta Disguidata BancoBPM
)

AND Cod_PF <> '9999'