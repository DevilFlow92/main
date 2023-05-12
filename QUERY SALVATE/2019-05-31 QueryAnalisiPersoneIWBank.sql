USE CLC
GO
WITH bonifica AS (
SELECT ti.IdIncarico, van.idpersona IdPersonaIWConto,
van.CognomeIntestatario + ' ' +  van.NomeIntestatario AS ClienteIWConto
,van.ChiaveClienteIntestatario ChiaveClienteContoIW
,van.CodiceFiscaleIntestatario CodiceFiscaleIWConto
,T_Persona.IdPersona IdPersona2
,Cognome + ' ' + Nome AS Cliente2
,T_Persona.ChiaveCliente ChiaveCliente2
,CodiceFiscale CodiceFiscale2
,CASE WHEN 
(van.ChiaveClienteIntestatario IS NULL OR ISNUMERIC(van.ChiaveClienteIntestatario) = 0) 
	AND (T_Persona.ChiaveCliente IS NULL OR ISNUMERIC(T_Persona.ChiaveCliente) =0 ) THEN 'Entrambi'
	WHEN van.ChiaveClienteIntestatario IS NULL OR ISNUMERIC(van.ChiaveClienteIntestatario) = 0 THEN 'Primo'
	WHEN T_Persona.ChiaveCliente IS NULL OR ISNUMERIC(T_Persona.ChiaveCliente) = 0 THEN 'Secondo'
	ELSE 'nessuno' END AS ChiaveClienteMissing

,CASE WHEN (van.CodiceFiscaleIntestatario is NULL OR van.CodiceFiscaleIntestatario = '')
	AND (CodiceFiscale IS null OR CodiceFiscale = '') THEN 'Entrambi'
	WHEN van.CodiceFiscaleIntestatario is NULL OR van.CodiceFiscaleIntestatario = '' THEN 'Primo'
	WHEN CodiceFiscale IS null OR CodiceFiscale = '' THEN 'Secondo'
	else 'Nessuno' END AS CodiceFiscaleMissing
,IIF(ISNUMERIC(van.ChiaveClienteIntestatario) != 0 AND ISNUMERIC(T_Persona.ChiaveCliente) != 0 and van.ChiaveClienteIntestatario <> T_Persona.ChiaveCliente,1,0) Verifica
FROM T_Incarico ti

JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico

JOIN T_Persona ON van.idpersona <> T_Persona.IdPersona
AND ti.CodCliente = T_Persona.CodCliente
AND (van.CodiceFiscaleIntestatario = CodiceFiscale OR (van.CognomeIntestatario = Cognome AND van.NomeIntestatario = Nome))

WHERE ti.CodArea = 8
AND ti.CodCliente = 73
AND ti.CodTipoIncarico = 507


) SELECT 	IdPersonaIWConto
			,ClienteIWConto
			,ChiaveClienteContoIW
			,CodiceFiscaleIWConto
			,IdPersona2
			,Cliente2
			,ChiaveCliente2
			,CodiceFiscale2
			,ChiaveClienteMissing
			,CodiceFiscaleMissing
			,Verifica 

FROM bonifica
WHERE Verifica = 0
AND ChiaveClienteMissing = 'secondo'
AND CodiceFiscaleMissing = 'secondo'


