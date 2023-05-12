USE CLC
GO

ALTER FUNCTION rs.CheckOnboardingAzimut(
@IdIncarico INT
)
RETURNS BIT 
AS
BEGIN
DECLARE @Esito BIT

DECLARE @Check TABLE (IdIncarico INT 
							,AnagraficaIntestatario VARCHAR(100)
									,IdIncaricoOnBoarding    INT  
								
									,CodTipoIncaricoOnBoarding INT
									,CodStatoWorkflowIncaricoOnboarding INT
									,ChiaveClienteOnboarding VARCHAR(50)
								)

INSERT INTO @Check (IdIncarico, AnagraficaIntestatario, IdIncaricoOnBoarding, CodTipoIncaricoOnBoarding, CodStatoWorkflowIncaricoOnboarding, ChiaveClienteOnboarding)
SELECT ti.IdIncarico
,CASE WHEN v.CognomeIntestatario IS NULL OR v.CognomeIntestatario = ''
	THEN v.RagioneSocialeIntestatario
	ELSE v.CognomeIntestatario + ISNULL(' ' + v.NomeIntestatario,'')
	END AnagraficaIntestatario
,   Onboarding.IdIncaricoOnBoarding
   ,Onboarding.CodTipoIncaricoOnboarding
   ,Onboarding.CodStatoWorkflowIncaricoOnboarding
   ,Onboarding.ChiaveClienteOnboarding

FROM [BTSQLCL05\BTSQLCL05].CLC.dbo.T_Incarico ti 
JOIN [BTSQLCL05\BTSQLCL05].CLC.rs.v_CESAM_Anagrafica_Cliente_Promotore v ON ti.IdIncarico = v.IdIncarico
OUTER  APPLY (
			SELECT tix.IdIncarico IdIncaricoOnBoarding, tix.CodTipoIncarico CodTipoIncaricoOnboarding
			, tix.CodStatoWorkflowIncarico CodStatoWorkflowIncaricoOnboarding
			,tpx.ChiaveCliente ChiaveClienteOnboarding

			FROM [BTSQLCL05\BTSQLCL05].CLC.dbo.T_Incarico tix
			JOIN [BTSQLCL05\BTSQLCL05].CLC.dbo.T_R_Incarico_Persona tripx ON tix.IdIncarico = tripx.IdIncarico
			AND tix.CodArea = 8 AND tix.CodCliente = 23 AND tix.CodTipoIncarico IN (288,396)
			JOIN [BTSQLCL05\BTSQLCL05].CLC.dbo.T_Persona tpx ON tripx.IdPersona = tpx.IdPersona
			WHERE tpx.IdPersona = v.idpersona

) Onboarding

WHERE ti.IdIncarico = 
@IdIncarico 
--16729658

IF EXISTS (SELECT * FROM @Check 
WHERE (CodTipoIncaricoOnboarding IN (288,396) AND ISNUMERIC(ChiaveClienteOnboarding) = 0 ) --LIKE 'p%' 
OR (CodTipoIncaricoOnboarding = 396 AND CodStatoWorkflowIncaricoOnboarding !=12180)
)
BEGIN
	SET @Esito = 0
END
ELSE 
BEGIN
	SET @Esito = 1
END

--SELECT * 
--FROM @Check
--SELECT @Esito

RETURN @Esito




END

GO