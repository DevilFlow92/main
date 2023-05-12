--select* from D_TipoIncarico

/* doppione di --57	*/
use CLC
INSERT INTO [dbo].[D_TipoIncarico]
           ([Codice]
           ,[Descrizione])
     VALUES
           (359
           ,'Contratti Consulenza CheBanca')

		   SELECT * FROM dbo.D_TipoIncarico where Descrizione LIKE '%SEPA%'
		   SELECT * FROM dbo.S_Operatore WHERE Cognome = 'MAESTRELLO'
		   SELECT * FROM dbo.D_ProfiloAccesso where Codice in (839,842,876)
--------------------------------------------------


INSERT into dbo.R_Cliente_ProfiloAccesso_InserimentoIncarico (CodCliente, CodProfiloAccesso, CodTipoIncarico, FlagAbilitaInserimento)
	SELECT 23,839,319,1 UNION ALL
	SELECT 23,1267,319,1


	SELECT * FROM R_Cliente_ProfiloAccesso_InserimentoIncarico where CodCliente = 48 and CodTipoIncarico = 331


---------------------------------------------------




--select*
--from D_TipoIncarico where descrizione like '%sottoscrizio%'

select*from D_TipoIncarico WHERE Descrizione = 'rimborsi diretti'

INSERT INTO [dbo].[R_Cliente_TipoIncarico_Area]--2 rows
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodArea])
     SELECT 
            [CodCliente]
           ,359 as [CodTipoIncarico] --DA MODIFICARE
           ,[CodArea]
	 from R_Cliente_TipoIncarico_Area
where CodCliente = 23
and CodTipoIncarico = 331 --INCARICO CLONA


		    
INSERT INTO [dbo].[R_Cliente_TipoIncarico_DatoAssociabile] ( [CodCliente]--11 rows
                                                            ,[CodTipoIncarico]
                                                            ,[CodDatoAssociabile]
                                                            ,[Cardinalita]
                                                            ,[FlagMostraInRicerca]
                                                            ,[ElementiSubincarichiVisualizzabili])
														
														SELECT
														[CodCliente]
														,359 as [CodTipoIncarico] --DA MODIFICARE
														,[CodDatoAssociabile]
														,[Cardinalita]
														,[FlagMostraInRicerca]
														,[ElementiSubincarichiVisualizzabili]
															FROM R_Cliente_TipoIncarico_DatoAssociabile			
															WHERE CodCliente = 48 AND CodTipoIncarico = 331


SELECT * FROM dbo.R_Cliente_TipoIncarico WHERE CodTipoIncarico = 331

INSERT INTO [dbo].[R_Cliente_TipoIncarico]--1 ROW
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodTipoWorkflow]
           ,[FlagMostraElementiSubincarichi]
           ,[CodTabIncaricoDefault]
           ,[FlagMostraElementiIncarichiMaster])
     SELECT
            [CodCliente]
           ,359 AS [CodTipoIncarico]
           ,[CodTipoWorkflow]
           ,[FlagMostraElementiSubincarichi]
           ,[CodTabIncaricoDefault]
           ,[FlagMostraElementiIncarichiMaster]
	 FROM R_Cliente_TipoIncarico
	 WHERE CodCliente = 48
	  AND CodTipoIncarico = 331

--associare gli stati e macrostati workflow a quell'incarico 
	  		   INSERT INTO [dbo].[R_Cliente_TipoIncarico_MacroStatoWorkFlow]--17
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflowIncarico]
           ,[CodMacroStatoWorkflowIncarico]
           ,[Ordinamento])

SELECT      [CodCliente]
            ,359 as [CodTipoIncarico]
           ,[CodStatoWorkflowIncarico]
           ,[CodMacroStatoWorkflowIncarico]
           ,[Ordinamento] 		   
		   FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
		   WHERE CodCliente = 48
			AND CodTipoIncarico = 331 and CodStatoWorkflowIncarico in (6500, 
																	   8570, 
																	   14275)

/* Associazione degli incarichi*/
use CLC

INSERT INTO [dbo].[R_Cliente_TipoIncaricoAssociabile]--53 rows
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodTipoIncaricoAssociabile])
     SELECT
           [CodCliente]
           ,319 as [CodTipoIncarico]
           ,[CodTipoIncaricoAssociabile]
from R_Cliente_TipoIncaricoAssociabile 
where CodCliente = 23 and CodTipoIncarico = 57


INSERT INTO [dbo].[R_Cliente_TipoIncaricoAssociabile]--58
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodTipoIncaricoAssociabile])
     SELECT
           [CodCliente]
           ,  [CodTipoIncarico]
           ,319 as [CodTipoIncaricoAssociabile]
from R_Cliente_TipoIncaricoAssociabile 
where CodCliente = 23 and CodTipoIncaricoAssociabile = 57
 




/**************************************************************************************/		
													
select * from D_TipoNotaIncarichi where descrizione like '%generica%'
-- 22	Generica

INSERT INTO [dbo].[R_Cliente_TipoIncarico_TipoNotaIncarichi]--28 rows
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodTipoNotaIncarichi])
select
           [CodCliente]
           ,359 as [CodTipoIncarico]
           ,[CodTipoNotaIncarichi]
		   from R_Cliente_TipoIncarico_TipoNotaIncarichi
		   where CodCliente = 48
		   and CodTipoIncarico = 331
		   and CodTipoNotaIncarichi = 22

--ruoli (intestatario, cointestatario etc.)
	INSERT INTO [dbo].[R_Cliente_TipoIncarico_RuoloRichiedente]--11 ROWS
 ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodRuoloRichiedente])
		   SELECT [CodCliente]
           ,359 AS [CodTipoIncarico]----DA MODIFICARE
           ,[CodRuoloRichiedente] 
		   FROM R_Cliente_TipoIncarico_RuoloRichiedente WHERE codtipoincarico = 331

--es. in attesa etc (D_attributo)	
	INSERT INTO [dbo].[R_Cliente_Attributo]--7 ROWS
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodAttributo])
     select
            [CodCliente]
           ,319 as [CodTipoIncarico]
           ,[CodAttributo]
	from R_Cliente_Attributo
	where CodCliente = 23
	and CodTipoIncarico = 57

	/* Template Mail*/
	
		   INSERT INTO [dbo].[R_TemplateComunicazione_StatoWorkflowIncarico]--37
           ([IdTemplateComunicazione]
           ,[CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflow]
           ,[FlagUrgente]
           ,[CodAttributo]
           ,[IdAtc]
           ,[IdSedeAtc]
           ,[CodProdottoPratica]
           ,[CodAmministrazioneEsterna]
           ,[CodSedeAmministrazioneEsterna]
           ,[CodTipoSinistro]
           ,[CodAssicurazioneSinistro]
           ,[IdFondoPensioneSinistro]
           ,[IdSedeAssicurazioneSinistro]
           ,[CodiceConvenzioneSinistro]
           ,[CodAttributoAtcInternalizzazione]
           ,[CodModalitaRintraccioAtcInternalizzazione]
           ,[CodEsitoRintraccioAtcInternalizzazione]
           ,[FlagRichiestaVariazioneAnagraficaAtcInternalizzazione]
           ,[CodCausaleRichiestaFondo]
           ,[CodEsitoValutazioneFondo]
           ,[FlagDocumentazioneCompletaFondo]
           ,[FlagRateInsoluteDataRichiestaFondo]
           ,[FlagInvioConsapFondo]
           ,[FlagEsitoConsapFondo]
           ,[CodCausaleRichiestaMoratoria]
           ,[CodEsitoValutazioneMoratoria]
           ,[FlagDocumentazioneCompletaMoratoria]
           ,[FlagRateInsoluteDataRichiestaMoratoria]
           ,[CodiceFilialePraticaMutuo]
           ,[CodTipoTassoPraticaMutuo]
           ,[CodValutaPraticaMutuo]
           ,[CodProdottoPraticaMutuo]
           ,[CodFinalitaPraticaMutuo]
           ,[CodiceAssicurazioneVitaPraticaMutuo]
           ,[CodiceAssicurazioneImpiegoPraticaMutuo]
           ,[CodiceAssicurazioneImmobilePraticaMutuo]
           ,[CodiceAssicurazioneCPIPraticaMutuo]
           ,[CodProduttorePratica]
           ,[CodCategoriaTicket]
           ,[CodMacroCategoriaTicket]
           ,[CodTipoProduttorePratica])
     SELECT
         [IdTemplateComunicazione]
           ,[CodCliente]
           ,359 as [CodTipoIncarico]
           ,[CodStatoWorkflow]
           ,[FlagUrgente]
           ,[CodAttributo]
           ,[IdAtc]
           ,[IdSedeAtc]
           ,[CodProdottoPratica]
           ,[CodAmministrazioneEsterna]
           ,[CodSedeAmministrazioneEsterna]
           ,[CodTipoSinistro]
           ,[CodAssicurazioneSinistro]
           ,[IdFondoPensioneSinistro]
           ,[IdSedeAssicurazioneSinistro]
           ,[CodiceConvenzioneSinistro]
           ,[CodAttributoAtcInternalizzazione]
           ,[CodModalitaRintraccioAtcInternalizzazione]
           ,[CodEsitoRintraccioAtcInternalizzazione]
           ,[FlagRichiestaVariazioneAnagraficaAtcInternalizzazione]
           ,[CodCausaleRichiestaFondo]
           ,[CodEsitoValutazioneFondo]
           ,[FlagDocumentazioneCompletaFondo]
           ,[FlagRateInsoluteDataRichiestaFondo]
           ,[FlagInvioConsapFondo]
           ,[FlagEsitoConsapFondo]
           ,[CodCausaleRichiestaMoratoria]
           ,[CodEsitoValutazioneMoratoria]
           ,[FlagDocumentazioneCompletaMoratoria]
           ,[FlagRateInsoluteDataRichiestaMoratoria]
           ,[CodiceFilialePraticaMutuo]
           ,[CodTipoTassoPraticaMutuo]
           ,[CodValutaPraticaMutuo]
           ,[CodProdottoPraticaMutuo]
           ,[CodFinalitaPraticaMutuo]
           ,[CodiceAssicurazioneVitaPraticaMutuo]
           ,[CodiceAssicurazioneImpiegoPraticaMutuo]
           ,[CodiceAssicurazioneImmobilePraticaMutuo]
           ,[CodiceAssicurazioneCPIPraticaMutuo]
           ,[CodProduttorePratica]
           ,[CodCategoriaTicket]
           ,[CodMacroCategoriaTicket]
           ,[CodTipoProduttorePratica]
		   from [R_TemplateComunicazione_StatoWorkflowIncarico]
		   where CodCliente = 48
			and CodTipoIncarico = 331

/*PROFILLI UTENTI*/ -- ANCORA non è fatto -- non serve abilitarlo perchè sto clonando incarichi già abilitati

--SELECT * FROM dbo.R_ProfiloAccesso_AbilitazioneIncarico WHERE CodCliente = 23
--INSERT INTO [dbo].[R_ProfiloAccesso_AbilitazioneIncarico]--31
--           ([CodProfiloAccesso]
--           ,[CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodStatoWorkflowIncarico]
--           ,[FlagAbilita]
--           ,[CodProduttore])
--     SELECT
--           [CodProfiloAccesso]
--           ,[CodCliente]
--           , 298 AS [CodTipoIncarico]
--           ,[CodStatoWorkflowIncarico]
--           ,[FlagAbilita]
--           ,[CodProduttore]
--	 FROM [R_ProfiloAccesso_AbilitazioneIncarico]
--	 		   where CodCliente = 23
--			and CodTipoIncarico = 85


/*Automatismo Apertura chiusura Sospeso*/ -- Ancora NON FATTO --tab sospesi, il campo sospeso viene aperto a mano dall'operatore e lo stato viene variato automaticamente


INSERT INTO [dbo].[R_Cliente_TipoIncarico_AzioneSalvataggioIncarico] --10 row
(
            [CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodAttributoIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[FlagAttesaPartenza]
           ,[FlagArchiviatoPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaDestinazione]
           ,[FlagArchiviatoDestinazione]
           ,[CodAzioneSalvataggioIncarico]
)
     SELECT 
            [CodCliente]
           ,359 AS [CodTipoIncarico] -- INCARICO DA SETUPPARE
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodAttributoIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[FlagAttesaPartenza]
           ,[FlagArchiviatoPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaDestinazione]
           ,[FlagArchiviatoDestinazione]
           ,[CodAzioneSalvataggioIncarico]
FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
WHERE CodTipoIncarico = 331 -- DA CLONARE 

/*Attivita Pianificate*/--ancora non fatto


INSERT INTO [dbo].[R_Cliente_TipoIncarico_TipoAttivitaPianificata]--10 rows
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflowIncarico]
           ,[CodTipoAttivitaPianificata]
           ,[CodStatoWorkflowDeadline]
           ,[MinutiDeadline]
           ,[NomeStoredProcedureMatch]
           ,[FlagUrgente]
           ,[FlagNotaObbligatoria]
           ,[CodAttributo]
           ,[FlagIntervalloLavorativo])
     SELECT
            [CodCliente]
           ,319 as [CodTipoIncarico]
           ,[CodStatoWorkflowIncarico]
           ,[CodTipoAttivitaPianificata]
           ,[CodStatoWorkflowDeadline]
           ,[MinutiDeadline]
           ,[NomeStoredProcedureMatch]
           ,[FlagUrgente]
           ,[FlagNotaObbligatoria]
           ,[CodAttributo]
           ,[FlagIntervalloLavorativo]
		 from R_Cliente_TipoIncarico_TipoAttivitaPianificata
		where CodCliente = 23
		and CodTipoIncarico = 57


INSERT INTO [dbo].[R_Transizione_AttivitaPianificata]--16 rows
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[FlagCreazione]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodAttributoIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[FlagAttesaPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaDestinazione]
           ,[IdTipoAttivitaInserimento]
           ,[CodTipoAttivitaChiusura]
           ,[FlagStatoWorkflowModificato]
           ,[FlagAttributoModificato]
           ,[FlagUrgenteModificato]
           ,[FlagAttesaModificato]
           ,[FlagAbilita])
     SELECT
            [CodCliente]
           ,319 as [CodTipoIncarico]
           ,[FlagCreazione]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodAttributoIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[FlagAttesaPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaDestinazione]
           ,[IdTipoAttivitaInserimento]
           ,[CodTipoAttivitaChiusura]
           ,[FlagStatoWorkflowModificato]
           ,[FlagAttributoModificato]
           ,[FlagUrgenteModificato]
           ,[FlagAttesaModificato]
           ,[FlagAbilita]
		from R_Transizione_AttivitaPianificata
		where  CodCliente = 23
		and CodTipoIncarico = 57

/* ARCHIVIO*/--fare prima una select (R_Cliente_Archivio) per vedere dove si trova quell'incarico
--creare nuovo incarico (posizione fittizia) --aumentare il numero sezioni quando si inserisce nuovo incarico

select* from R_Cliente_Archivio where CodCliente = 48 and CodTipoIncarico = 331
select* from S_Archivio where CodScaffale = 113

select * from D_Scaffale where Codice=113
--113	CESAM-CB!

update [S_Archivio] SET [NumeroSezioni] = 2 WHERE CodScaffale = 113

use CLC
INSERT INTO [dbo].[R_Cliente_Archivio]--2 ROWS
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodTipoArchiviazione]
           ,[CodScaffaleInizio]
           ,[CodiceSezioneInizio]
           ,[CodicePianoInizio]
           ,[CodiceScatolaInizio]
           ,[CodScaffaleFine]
           ,[CodiceSezioneFine]
           ,[CodicePianoFine]
           ,[CodiceScatolaFine]
           ,[NumeroDocumenti]
           ,[FlagTemporaneo]
           ,[CodDocumento])
     SELECT
           [CodCliente]
           ,359 AS [CodTipoIncarico]
           ,[CodTipoArchiviazione]
           ,[CodScaffaleInizio]
           ,2 AS [CodiceSezioneInizio]
           ,[CodicePianoInizio]
           ,[CodiceScatolaInizio]
           ,[CodScaffaleFine]
           ,2 AS [CodiceSezioneFine]
           ,[CodicePianoFine]
           ,[CodiceScatolaFine]
           ,[NumeroDocumenti]
           ,[FlagTemporaneo]
           ,[CodDocumento]
		   from R_Cliente_Archivio 
		   where CodCliente = 48
		   and CodTipoIncarico = 331

