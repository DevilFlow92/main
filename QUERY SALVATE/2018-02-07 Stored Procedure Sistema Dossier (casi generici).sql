USE [CLC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--alter PROCEDURE [rs].[CESAM_AZ_GestioneDossierNONPopolatiCorrettamente] (@DataFiltro DATETIME)

--AS

/*
Author: L. Fiori
Description: Esegue la vista [rs].[v_CESAM_AZ_PersonaRipetutaNelDossier] che segnala quali incarichi hanno dossier popolati in maniera inesatta.
			 Vengono risolti automaticamente i casi più semplici/ frequenti e reportizzati i casi da analizzare e gestire manualmente.
*/

DECLARE @DataFiltro datetime
		
declare @DataOrigine datetime
		,@Automatismo int
		,@doppioni int
		,@caso1 int
		,@caso2 int

SET @DataFiltro = '2018-01-01'

SET @DataOrigine = '2017-01-01'

set @Automatismo = 0
set @doppioni = 0
set @caso1 = 0
set @caso2 = 0

BEGIN
PRINT '--------INIZIO---------'
declare @IdIncarico int,
		@CodTipoIncarico int,
		@IdDossier int,
		@IdPersona int,
		@CodRuoloRichiedente1 int,
		@CodRuoloRichiedenteRipetuto int

declare cur cursor for 
select IdIncarico
		,CodTipoIncarico
		,IdDossier
		,IdPersonaRipetuta
		,CodRuoloRichiedente1
		,CodRuoloRichiedenteRipetuto
from [rs].[v_CESAM_AZ_PersonaRipetutaNelDossier]
where DataCreazione >= @DataOrigine

open cur
FETCH NEXT from cur into @IdIncarico, @CodTipoIncarico, @IdDossier, @IdPersona, @CodRuoloRichiedente1, @CodRuoloRichiedenteRipetuto
WHILE @@fetch_status = 0

BEGIN
--stesso dossier, stess persona, stesso codice ruolo richiedente (doppioni)
	if @CodRuoloRichiedente1 = @CodRuoloRichiedenteRipetuto
		BEGIN
		PRINT 'Dossier con doppioni ' + 'IdDossier ' + cast(@IdDossier as varchar(15)) + ' IdIncarico '+ cast(@IdIncarico as varchar(15))
		--DELETE FROM T_R_Dossier_Persona
		--where IdDossier = @IdDossier AND IdPersona = @IdPersona 
		--AND Progressivo <> 1

		set @Automatismo =  @Automatismo + 1
		set @doppioni = @doppioni + 1
		end


 --stesso dossier, stessa persona ruoli richiedente diversi (solo un ruolo è giusto)

 --Il tipo incarico presuppone che il ruolo giusto è Intestatario

	if @CodTipoIncarico in (83		--Sottoscrizioni/Versamenti FONDI Investimento
							,100	--Sottoscrizioni/Versamenti SICAV
							,352	--Versamenti FONDI Investimento
							,85		--Rimborso FONDI Investimento
							,321	--Sottoscrizioni AFB
							,322	--Versamenti Aggiuntivi AFB
							,323	--Rimborsi AFB
							,324	--Switch AFB
							
							)
		BEGIN
		IF @CodRuoloRichiedente1 = 33 --Persona censita per prima come Intestatario
			BEGIN
			PRINT 'Dossier caso 1 (rimasto primo intestatario) ' + 'IdDossier ' + cast(@IdDossier as varchar(15)) + ' IdIncarico '+ cast(@IdIncarico as varchar(15))
			--DELETE FROM T_R_Dossier_Persona
			--WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona 
			--AND Progressivo <> 1

			set @Automatismo =  @Automatismo + 1
			set @caso1 = @caso1 + 1
			end
		
		else if @CodRuoloRichiedenteRipetuto = 33 --Persona censita (non per prima) come Intestatario
			BEGIN
			PRINT 'Dossier caso 2 (rimasto l''ultimo intestatario) ' + 'IdDossier ' + cast(@IdDossier as varchar(15)) + ' IdIncarico '+ cast(@IdIncarico as varchar(15))
			--DELETE FROM T_R_Dossier_Persona
			--WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona
			--and Progressivo < (SELECT max(Progressivo) FROM T_R_Dossier_Persona 
			--					WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona)	

			--IF (SELECT	Progressivo FROM T_R_Dossier_Persona WHERE IdDossier = @IdDossier AND IdPersona = @IdPersona) > 1 
			--	begin
			--	--UPDATE T_R_Dossier_Persona
			--	--SET Progressivo = 1
			--	--where IdDossier = @IdDossier AND IdPersona = @IdPersona 

			--	PRINT 'Da spostare intestatario come primo ' + 'IdDossier ' + cast(@IdDossier as varchar(15)) + ' IdIncarico '+ cast(@IdIncarico as varchar(15))

			--	END 

			set @Automatismo =  @Automatismo + 1
			set @caso2 = @caso2 + 1
			END

		END 


FETCH NEXT from cur into  @IdIncarico, @CodTipoIncarico, @IdDossier, @IdPersona, @CodRuoloRichiedente1, @CodRuoloRichiedenteRipetuto
end 

CLOSE cur
DEALLOCATE cur


print '-----------------------'

print 'Incarichi che sarebbero coninvolti dall''automatismo: ' + cast(@automatismo as varchar(10))

PRINT '   Di cui doppioni: ' + cast(@doppioni as varchar(10))
print '   Di cui caso 1: ' + cast(@caso1 as varchar(10))
print '   Di cui caso 2: ' + cast(@caso2 as varchar(10))

print ' ' 
print '-----------------------'

end
PRINT 'Incarichi da verificare dalla data ' + cast(@DataFiltro as varchar(50))

SELECT  IdIncarico
		,IdDossier
		,NumeroDossier
		,IdPersonaRipetuta
		,ChiaveClientePersona
		,Persona
		,CodRuoloRichiedente1
		,DescrizioneRuolo1
		,CodRuoloRichiedenteRipetuto
		,DescrizioneRuoloRipetuto
		,DataCreazione

FROM [rs].[v_CESAM_AZ_PersonaRipetutaNelDossier]

where DataCreazione >= @DataFiltro

PRINT ' ' 
print '---------FINE----------'
GO


