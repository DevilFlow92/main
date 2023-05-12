use CLC
GO

--CREATE  PROCEDURE [orga].[CESAM_AZ_GenerazioneControlli_IncarichiVariati] as 
BEGIN

DECLARE @IdIncarico int,
		@CodTipoIncarico int,
		@CodTipoMacrocontrollo int,
		@IdMacroControllo int,
		@CodTipoControllo int,
		@IdControllo int

declare cur cursor static for
select T_Incarico.IdIncarico
		,T_Incarico.CodTipoIncarico
		,S_MacroControllo.IdMacroControllo
		,S_MacroControllo.Descrizione
		,S_Controllo.IdControllo
		,S_Controllo.Descrizione

FROM T_Incarico

left join T_R_Incarico_Controllo on T_Incarico.IdIncarico = T_R_Incarico_Controllo.IdIncarico
JOIN T_Controllo on T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
JOIN S_Controllo on T_Controllo.IdTipoControllo = S_Controllo.IdControllo

JOIN T_MacroControllo on T_Controllo.IdMacroControllo = T_MacroControllo.IdMacroControllo
JOIN S_MacroControllo on T_MacroControllo.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo


set @CodTipoControllo = 2200
set @CodTipoIncarico = 321
set @CodTipoMacrocontrollo = 646


--id 8712241 
--update T_Incarico
--set CodTipoIncarico = 321 
--where IdIncarico = 8712241


IF OBJECT_ID(N'tempdb..#incarichiappenavariati', N'U') IS NOT NULL
DROP TABLE #incarichiappenavariati;

--controlla che l'incarico appena variato abbia ancora controlli pregressi, in tal caso li rimuoviamo
if exists (SELECT * FROM T_R_Incarico_Controllo
			where IdIncarico IN (SELECT DISTINCT T_Incarico.IdIncarico
			FROM T_Incarico
			JOIN T_MacroControllo	ON T_Incarico.IdIncarico = T_MacroControllo.IdIncarico
			JOIN S_MacroControllo	ON T_MacroControllo.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo
			WHERE T_Incarico.CodCliente = 23
			AND T_Incarico.CodTipoIncarico = 321
			AND T_MacroControllo.IdMacroControllo IS NOT NULL
			AND S_MacroControllo.CodTipoIncarico <> 321)) 
DELETE FROM T_R_Incarico_Controllo 
WHERE IdIncarico in ( 
					 SELECT DISTINCT T_Incarico.IdIncarico 
						from T_Incarico
							join T_MacroControllo on T_Incarico.IdIncarico = T_MacroControllo.IdIncarico
							JOIN S_MacroControllo on T_MacroControllo.IdTipoMacroControllo = S_MacroControllo.IdMacroControllo
						where T_Incarico.CodCliente = 23 
							and T_Incarico.CodTipoIncarico = 321
							AND T_MacroControllo.IdMacroControllo is not null 
							and S_MacroControllo.CodTipoIncarico <> 321
											   							 	)


--popoliamo la tabella temporanea con le info sui tipi di controlli che devono avere gli id variati
SELECT
	T_Incarico.IdIncarico
   ,@CodTipoIncarico [CodTipoIncarico]
   ,@CodTipoMacroControllo [CodTipoMacroControllo]
   ,@CodTipoControllo [CodTipoControllo] 
   
INTO #incarichiappenavariati

FROM T_Incarico
LEFT JOIN T_AttivitaPianificataIncarico	ON T_Incarico.IdIncarico = T_AttivitaPianificataIncarico.IdIncarico
LEFT JOIN T_R_Incarico_Controllo ON T_Incarico.IdIncarico = T_R_Incarico_Controllo.IdIncarico
LEFT JOIN T_Controllo ON T_Controllo.IdControllo = T_R_Incarico_Controllo.IdControllo
WHERE CodArea = 8
--AND T_Incarico.DataCreazione >= '2018-01-15'
AND CodTipoIncarico = @CodTipoIncarico
--AND CodTipoAttivitaPianificata = 552  and CodStatoAttivita = 2--variazionetipoincarico chiusa  (solo in produzione)
AND T_R_Incarico_Controllo.IdRelazione IS NULL

--controlliamo che ci siano effettivamente incarichi appena variati che necessitano l'implementazione del controllo
--se non è così, la stored procedure non fa nessuna insert
IF exists (SELECT * FROM #incarichiappenavariati)
BEGIN

set @IdIncarico = (
					SELECT top 1 T_Incarico.IdIncarico 
					FROM T_Incarico
					left JOIN T_AttivitaPianificataIncarico ON T_Incarico.IdIncarico = T_AttivitaPianificataIncarico.IdIncarico
					LEFT JOIN T_R_Incarico_Controllo ON T_Incarico.IdIncarico = T_R_Incarico_Controllo.IdIncarico
					LEFT JOIN T_Controllo ON T_Controllo.IdControllo = T_R_Incarico_Controllo.IdControllo
					WHERE CodArea = 8
					--AND T_Incarico.DataCreazione >= '2018-01-15'
					and CodTipoIncarico = @CodTipoIncarico
					--AND CodTipoAttivitaPianificata = 552  and CodStatoAttivita = 2--variazionetipoincarico chiusa  (solo in produzione)
					AND T_R_Incarico_Controllo.IdControllo IS NULL
																	)

INSERT INTO T_MacroControllo (IdIncarico, IdTipoMacroControllo, FlagEsito, DataModifica, FlagAnnullato)
VALUES (@IdIncarico, @CodTipoMacrocontrollo, 0, GETDATE(), 0)
--SELECT @IdIncarico, @CodTipoMacrocontrollo ,1 ,getdate(), 0


SET @IdMacroControllo = (SELECT top 1 IdMacroControllo FROM T_MacroControllo order BY idmacrocontrollo desc)

INSERT INTO [dbo].[T_Controllo] ([CodDatoAssociabile]
, [IdTipoControllo]
, [Note]
, [FlagModificaManuale]
, [DataModifica]
, [CodEsitoControllo]
, [CodGiudizioControllo]
, [DataInserimento]
, [IdMacroControllo]
, [IdOggettoCollegato]
, [Contatore]
, [FlagIntegrazione]
, [FlagPreAccettazione]
, [FlagDeroga]
, [FlagAutorizzazione]
, [CodTipoRilievoControllo])

VALUES (NULL, @CodTipoControllo, 'Documento Informativa Preliminare Non Presente', 1, GETDATE(), NULL, 4, GETDATE(), @IdMacrocontrollo, @IdIncarico, 0, NULL, NULL, NULL, NULL, NULL)
--SELECT null, @CodTipoControllo, 'Documento Informativa Preliminare Non Presente', 1, GETDATE(), NULL, 4, GETDATE(), @IdMacrocontrollo, @IdIncarico, 0, null, NULL, NULL, NULL, NULL

SET @IdControllo = (SELECT top 1 IdControllo from T_Controllo order BY IdControllo DESC )

INSERT INTO T_R_Incarico_Controllo (IdIncarico, IdControllo)
values(@IdIncarico, @IdControllo)
--SELECT @IdIncarico, @IdControllo

END 

END

GO


