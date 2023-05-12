USE [CLC]
GO

/****** Object:  StoredProcedure [controlli].[CESAM_AZ_AFB_Documento_InformativaPreliminare_Recente]    Script Date: 02/02/2018 16:32:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER  PROCEDURE [controlli].[CESAM_AZ_AFB_Documento_InformativaPreliminare_Recente]

( 
@IdRiga INT
)
AS

/*
Controllo sulla presenza del Modulo di Presa Visione Informativa Preliminare
associato ad una persona e/o ad un numero simula
(Sottoscrizioni AFB) 

*/

--DECLARE @idriga INT

--SET @idriga = 
--9687922 

BEGIN TRY


DECLARE 
       @RES_CodGiudizioControllo int, 
       @RED_Note as nvarchar(255),
       @RED_CodEsitoControllo varchar(5)
       
--T Dichiarazione variabili generali di controllo

DECLARE @Esito INT
DECLARE @Note VARCHAR(MAX)
SET @RES_CodGiudizioControllo=1
SET @RED_Note='Verifica'

DECLARE @IdIncarico INT
SET @IdIncarico = @IdRiga




      --IF EXISTS (
         
      --                            SELECT * from t_incarico
      --                            left join T_MacroControllo on T_MacroControllo.idincarico = t_incarico.idincarico
      --                            left join t_controllo on t_controllo.IdMacroControllo = T_MacroControllo.IdMacroControllo
      --                            where 
      --                            t_incarico.idincarico = @IdIncarico
      --                            --T_Incarico.IdIncarico = 4424041 
      --                            and IdTipoControllo in  (646) --verifica documentazione anagrafica

      --                  )  

                           --SELECT * FROM S_Controllo where IdTipoMacroControllo = 646

--===========================================================================================================
BEGIN
       DECLARE @idpersonaIncarico INT
       DECLARE @idpersonaDossier INT
       declare @IdIncaricoConDocumento int
       declare @NumeroSimula VARCHAR(50)
       DECLARE @tipofea INT 
	   declare @tiporaccomandazione int 
	   declare @tipoincaricoattuale int


       SET @idpersonaIncarico = (SELECT idpersona FROM dbo.T_R_Incarico_Persona WHERE IdIncarico = @IdIncarico AND Progressivo = 1)
       SET @idpersonaDossier = (SELECT IdPersona FROM dbo.T_R_Dossier_Persona WHERE IdDossier IN (
                                                                                                SELECT IdDossier FROM dbo.T_Mandato WHERE IdMandato IN (
                                                                                                            SELECT T_R_Incarico_Mandato.IdMandato FROM dbo.T_R_Incarico_Mandato where IdIncarico = @IdIncarico)) AND Progressivo = 1)

       set @NumeroSimula = (SELECT DISTINCT T_Mandato.NumeroSimula
                                                                          from T_R_Incarico_Mandato join T_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
                                                                          where IdIncarico = @IdIncarico)
                                                                                                   
       set @IdIncaricoConDocumento = (SELECT
                                                              IdIncarico
                                                  FROM rs.v_CESAM_AZ_AFB_Documento_InformativaPreliminare_Recente
                                                  WHERE 
                                                  (IdPersona = @idpersonaIncarico OR IdPersona = @idpersonaDossier)
                                                  AND NumeroSimula = @NumeroSimula)
       SET @tipofea = (SELECT CodTipoFea FROM T_DatiAggiuntiviIncaricoAzimut WHERE IdIncarico = @IdIncarico )
	   
	   set @tiporaccomandazione = (SELECT CodTipoRaccomandazione FROM T_DatiAggiuntiviIncaricoAzimut where IdIncarico = @IdIncarico)
	   set @tipoincaricoattuale = (select CodTipoIncarico from T_Incarico where IdIncarico = @IdIncarico)

       IF @tipofea <> 3 
                BEGIN 
                SET @RES_CodGiudizioControllo = 2
                SET @RED_Note = 'FEA - controllo non necessario'
                END

	   else if (@tipofea IS NULL OR @tipofea = 3) AND @IdIncaricoConDocumento IS NOT NULL
                BEGIN
                SET @RES_CodGiudizioControllo = 2
                SET @RED_Note = 'Modulo di Presa Visione Informativa Preliminare presente su Id Incarico: ' + cast(@IdIncaricoConDocumento AS VARCHAR(50))
                END

	--casistiche d'eccezione per le quali non è necessario eseguire il controllo
      ELSE IF @tiporaccomandazione in (1,2)			--sottoscrizione afb max/max fund
				 or @tipoincaricoattuale = 323	--rimborsi afb	

				begin 
				set @RES_CodGiudizioControllo = 2
				set @RED_Note = 'Documento non necessario per l''incarico corrente'
				end   

	--controllo presenza numero simula
      else if @NumeroSimula is null 
				begin
				SET @RES_CodGiudizioControllo = 4
				SET @RED_Note = 'Numero Simula non popolato'
				end 

	  else
                BEGIN
                SET @RES_CodGiudizioControllo = 4
                SET @RED_Note = 'Modulo di Presa Visione Informativa Preliminare non presente'
                END

END   
    
--===========================================================================================================

select       @RES_CodGiudizioControllo as CodGiudizioControllo,
             @RED_CodEsitoControllo  as CodEsitoControllo ,
             @RED_Note as Note

                    --SELECT @IdIncarico, @IdIncaricoConDocumento, @tipofea



End Try

Begin Catch
PRINT 'Errore: inviare ad ORGA una segnalazione'
End Catch





GO


