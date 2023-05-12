use CLC
GO

--create procedure [controlli].[CESAM_AZ_AggiornaPosizioneDossier] 

--( 
--@IdRiga INT
--)
--AS

DECLARE @idriga INT
SET @idriga = 9987628
--10114834


BEGIN try
--T Dichiarazione variabili generali di controllo

DECLARE @IdIncarico INT,
       @RES_CodGiudizioControllo int, 
       @RED_Note as varchar(255),
       @RED_CodEsitoControllo varchar(5),
       @Esito INT

SET @IdIncarico = @IdRiga

--===========================================================================================================
IF OBJECT_ID(N'tempdb..#check', N'U') IS NOT NULL
begin
DROP TABLE #check
END	 

select IdIncarico
		,IdPersona
		,ChiaveCliente
		,IdDossier
		,NumeroDossier
		,CodRuoloRichiedente
		,CASE WHEN ProgressivoPersona = 1 THEN 33 ELSE 26 END CodRuoloVariare
into #check
FROM rs.v_CESAM_AZ_Incarichi_AFB_Dossier_NON_PopolatiCorrettamente
where IdIncarico = @IdIncarico

select * FROM #check

begin
if exists (SELECT idincarico FROM #check)
begin

/*
UPDATE T_R_Dossier_Persona
SET CodRuoloRichiedente = codruolovariare
FROM T_R_Dossier_Persona
inner JOIN #check on T_R_Dossier_Persona.IdDossier = #check.iddossier AND T_R_Dossier_Persona.IdPersona = #check.idpersona
*/
set @RED_Note = 'Ruoli richiedente dossier aggiornati'
end

else

begin
set @RED_Note = 'Aggiornamento non necessario'
end

SET @RES_CodGiudizioControllo = 2

end
--===========================================================================================================

SELECT
	@RES_CodGiudizioControllo AS CodGiudizioControllo
   ,@RED_CodEsitoControllo AS CodEsitoControllo
   ,@RED_Note AS Note

DROP TABLE #check

end try

Begin Catch
SELECT  'Errore: inviare ad ORGA una segnalazione'
End Catch

GO
