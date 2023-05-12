
--CREARE UN NUOVO INCARICO: 'Apertura Carta di Credito FEA'
--CLONE DI: Apertura Dossier Titoli SOLO FEA (334)

USE CLC
SELECT
	*
FROM D_TipoIncarico
WHERE codice = 334
--334	Apertura Dossier Titoli SOLO FEA

--Pre-produzone
--================================================================================================
--1) Insert nella D_TIPOINCARICO

USE CLC
SELECT
	*
FROM D_TipoIncarico
ORDER BY codice DESC
--l'ultimo è 331

USE CLC
SELECT
	*
FROM D_TipoIncarico
WHERE Codice = 378
--(non è associato a nessuno)

--INSERT INTO [dbo].[D_TipoIncarico]([Codice],[Descrizione]) VALUES (378, 'Apertura Carta di Credito FEA')
--================================================================================================

--2)R_Cliente_ProfiloAccesso_InserimentoIncarico

SELECT
	*
FROM R_Cliente_ProfiloAccesso_InserimentoIncarico
WHERE CodCliente = 48
AND CodTipoIncarico = 334
SELECT
	*
FROM R_Cliente_ProfiloAccesso_InserimentoIncarico
WHERE CodCliente = 48
AND CodTipoIncarico = 378
---NESSUN OUTPUT

--================================================================================================
--3) R_Cliente_TipoIncarico_Area
USE clc
SELECT
	*
FROM R_Cliente_TipoIncarico_Area
WHERE CodCliente = 48
AND CodTipoIncarico = 334
--(2 rows)

--INSERT INTO [dbo].[R_Cliente_TipoIncarico_Area]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodArea])
--     SELECT 
--            [CodCliente]
--           ,378 as [CodTipoIncarico] 
--           ,[CodArea]
--from R_Cliente_TipoIncarico_Area
--where CodCliente = 48
--and CodTipoIncarico = 334


SELECT
	*
FROM R_Cliente_TipoIncarico_Area
WHERE CodCliente = 48
AND CodTipoIncarico = 378

--==================================================================================
--4)[R_Cliente_TipoIncarico_DatoAssociabile]
USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_DatoAssociabile
JOIN D_DatoAssociabile
	ON D_DatoAssociabile.CODICE = R_Cliente_TipoIncarico_DatoAssociabile.CodDatoAssociabile
WHERE CodTipoIncarico = 334


--INSERT INTO [dbo].[R_Cliente_TipoIncarico_DatoAssociabile] 
--                  ( [CodCliente]
--                  ,[CodTipoIncarico]
--                  ,[CodDatoAssociabile]
--                  ,[Cardinalita]
--                  ,[FlagMostraInRicerca]
--                  ,[ElementiSubincarichiVisualizzabili])
-- SELECT
--			      [CodCliente]
--				  ,378 as [CodTipoIncarico] 
--				  ,[CodDatoAssociabile]
--				  ,[Cardinalita]
--				  ,[FlagMostraInRicerca]
--				  ,[ElementiSubincarichiVisualizzabili]
--FROM R_Cliente_TipoIncarico_DatoAssociabile			
--WHERE CodCliente = 48 
--AND CodTipoIncarico = 334



SELECT
	*
FROM R_Cliente_TipoIncarico_DatoAssociabile
WHERE CodTipoIncarico = 378


--=================================================================================================================
--5) R_Cliente_TipoIncarico
USE CLC
SELECT
	*
FROM dbo.R_Cliente_TipoIncarico
WHERE CodTipoIncarico = 334
--(1 row)

--INSERT INTO [dbo].[R_Cliente_TipoIncarico]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodTipoWorkflow]
--           ,[FlagMostraElementiSubincarichi]
--           ,[CodTabIncaricoDefault]
--           ,[FlagMostraElementiIncarichiMaster])
--     SELECT
--            [CodCliente]
--           ,378 AS [CodTipoIncarico]
--           ,[CodTipoWorkflow]
--           ,[FlagMostraElementiSubincarichi]
--           ,[CodTabIncaricoDefault]
--           ,[FlagMostraElementiIncarichiMaster]
--	 FROM R_Cliente_TipoIncarico
--	 WHERE CodCliente = 48
--	 AND CodTipoIncarico = 334

SELECT
	*
FROM dbo.R_Cliente_TipoIncarico
WHERE CodTipoIncarico = 378
USE CLC
SELECT
	*
FROM dbo.R_Cliente_TipoIncarico
WHERE CodTipoIncarico = 334


--INSERT INTO [dbo].[R_Cliente_TipoIncarico]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodTipoWorkflow]
--           ,[FlagMostraElementiSubincarichi]
--           ,[CodTabIncaricoDefault]
--           ,[FlagMostraElementiIncarichiMaster])
--     VALUES
--           (48,378,5,1,NULL,0)


--=========================================================================================
--7) 	R_Cliente_ProfiloAccesso_InserimentoIncarico
SELECT
	*
FROM R_Cliente_ProfiloAccesso_InserimentoIncarico
WHERE CodCliente = 48
AND CodTipoIncarico = 334
--(nessun output)


--===========================================================================================
--8) R_profiloaccesso_abilitazioneincarico: solo orga

USE clc
SELECT
	*
FROM R_profiloaccesso_abilitazioneincarico
WHERE CodCliente = 48
AND CodTipoIncarico = 378
--(32 row)


--INSERT INTO [dbo].[R_ProfiloAccesso_AbilitazioneIncarico]
           ([CodProfiloAccesso]
           ,[CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflowIncarico]
           ,[FlagAbilita]
           ,[CodProduttore])
     VALUES
           (839, 48, 378, null, 1, null)



use clc
SELECT
	*
FROM R_profiloaccesso_abilitazioneincarico
WHERE CodCliente = 48
AND CodTipoIncarico = 378


--===========================================================================================
--9) R_Cliente_TipoIncaricoAssociabile  
USE CLC
SELECT
	*
FROM R_Cliente_TipoIncaricoAssociabile
WHERE CodTipoIncarico = 334
--(61 rows)

--per il momento niente setup

--INSERT INTO [dbo].[R_Cliente_TipoIncaricoAssociabile]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodTipoIncaricoAssociabile])
--     SELECT
--           [CodCliente]
--           ,332 as [CodTipoIncarico]
--           ,[CodTipoIncaricoAssociabile]
--from R_Cliente_TipoIncaricoAssociabile 
--where CodCliente = 23 
--and CodTipoIncarico = 91


SELECT
	*
FROM R_Cliente_TipoIncaricoAssociabile
WHERE CodTipoIncarico = 378

--========================================================================================
--10) R_Cliente_TipoIncarico_TipoNotaIncarichi
USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
WHERE CodTipoIncarico = 334
--(1 rows: nota generica)

--use CLC
--INSERT INTO [dbo].[R_Cliente_TipoIncarico_TipoNotaIncarichi]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodTipoNotaIncarichi])
--     VALUES (48,378,22)



USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
WHERE CodTipoIncarico = 378

--========================================================================================

--11) R_Cliente_TipoIncarico_RuoloRichiedente: INTESTATARIO E COINTESTATARIO
USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_RuoloRichiedente
WHERE CodTipoIncarico = 334


--INSERT INTO [dbo].[R_Cliente_TipoIncarico_RuoloRichiedente]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodRuoloRichiedente])
--     VALUES (48,378,33),
--	        (48,378,26)


SELECT
	*
FROM R_Cliente_TipoIncarico_RuoloRichiedente
WHERE CodTipoIncarico = 378

--===============================================================================================
--12) R_Cliente_Attributo
USE CLC
SELECT
	*
FROM R_Cliente_Attributo
WHERE CODCLIENTE = 48
AND CodTipoIncarico = 334
--(0 ROW)


SELECT
	*
FROM R_Cliente_Attributo
WHERE CodTipoIncarico = 378

--========================================================================================
--13) R_TemplateComunicazione_StatoWorkflowIncarico
USE CLC
SELECT
	*
FROM R_TemplateComunicazione_StatoWorkflowIncarico
WHERE CodTipoIncarico = 334
--(6 ROWS)

--INSERT INTO [dbo].[R_TemplateComunicazione_StatoWorkflowIncarico]
--         ([IdTemplateComunicazione]
--         ,[CodCliente]
--         ,[CodTipoIncarico]
--         ,[CodStatoWorkflow]
--         ,[FlagUrgente]
--         ,[CodAttributo]
--         ,[IdAtc]
--         ,[IdSedeAtc]
--         ,[CodProdottoPratica]
--         ,[CodAmministrazioneEsterna]
--         ,[CodSedeAmministrazioneEsterna]
--         ,[CodTipoSinistro]
--         ,[CodAssicurazioneSinistro]
--         ,[IdFondoPensioneSinistro]
--         ,[IdSedeAssicurazioneSinistro]
--         ,[CodiceConvenzioneSinistro]
--         ,[CodAttributoAtcInternalizzazione]
--         ,[CodModalitaRintraccioAtcInternalizzazione]
--         ,[CodEsitoRintraccioAtcInternalizzazione]
--         ,[FlagRichiestaVariazioneAnagraficaAtcInternalizzazione]
--         ,[CodCausaleRichiestaFondo]
--         ,[CodEsitoValutazioneFondo]
--         ,[FlagDocumentazioneCompletaFondo]
--         ,[FlagRateInsoluteDataRichiestaFondo]
--         ,[FlagInvioConsapFondo]
--         ,[FlagEsitoConsapFondo]
--         ,[CodCausaleRichiestaMoratoria]
--         ,[CodEsitoValutazioneMoratoria]
--         ,[FlagDocumentazioneCompletaMoratoria]
--         ,[FlagRateInsoluteDataRichiestaMoratoria]
--         ,[CodiceFilialePraticaMutuo]
--         ,[CodTipoTassoPraticaMutuo]
--         ,[CodValutaPraticaMutuo]
--         ,[CodProdottoPraticaMutuo]
--         ,[CodFinalitaPraticaMutuo]
--         ,[CodiceAssicurazioneVitaPraticaMutuo]
--         ,[CodiceAssicurazioneImpiegoPraticaMutuo]
--         ,[CodiceAssicurazioneImmobilePraticaMutuo]
--         ,[CodiceAssicurazioneCPIPraticaMutuo]
--         ,[CodProduttorePratica]
--         ,[CodCategoriaTicket]
--         ,[CodMacroCategoriaTicket]
--         ,[CodTipoProduttorePratica])
--   SELECT
--       [IdTemplateComunicazione]
--         ,[CodCliente]
--         ,378 as [CodTipoIncarico]
--         ,[CodStatoWorkflow]
--         ,[FlagUrgente]
--         ,[CodAttributo]
--         ,[IdAtc]
--         ,[IdSedeAtc]
--         ,[CodProdottoPratica]
--         ,[CodAmministrazioneEsterna]
--         ,[CodSedeAmministrazioneEsterna]
--         ,[CodTipoSinistro]
--         ,[CodAssicurazioneSinistro]
--         ,[IdFondoPensioneSinistro]
--         ,[IdSedeAssicurazioneSinistro]
--         ,[CodiceConvenzioneSinistro]
--         ,[CodAttributoAtcInternalizzazione]
--         ,[CodModalitaRintraccioAtcInternalizzazione]
--         ,[CodEsitoRintraccioAtcInternalizzazione]
--         ,[FlagRichiestaVariazioneAnagraficaAtcInternalizzazione]
--         ,[CodCausaleRichiestaFondo]
--         ,[CodEsitoValutazioneFondo]
--         ,[FlagDocumentazioneCompletaFondo]
--         ,[FlagRateInsoluteDataRichiestaFondo]
--         ,[FlagInvioConsapFondo]
--         ,[FlagEsitoConsapFondo]
--         ,[CodCausaleRichiestaMoratoria]
--         ,[CodEsitoValutazioneMoratoria]
--         ,[FlagDocumentazioneCompletaMoratoria]
--         ,[FlagRateInsoluteDataRichiestaMoratoria]
--         ,[CodiceFilialePraticaMutuo]
--         ,[CodTipoTassoPraticaMutuo]
--         ,[CodValutaPraticaMutuo]
--         ,[CodProdottoPraticaMutuo]
--         ,[CodFinalitaPraticaMutuo]
--         ,[CodiceAssicurazioneVitaPraticaMutuo]
--         ,[CodiceAssicurazioneImpiegoPraticaMutuo]
--         ,[CodiceAssicurazioneImmobilePraticaMutuo]
--         ,[CodiceAssicurazioneCPIPraticaMutuo]
--         ,[CodProduttorePratica]
--         ,[CodCategoriaTicket]
--         ,[CodMacroCategoriaTicket]
--         ,[CodTipoProduttorePratica]
--   from [R_TemplateComunicazione_StatoWorkflowIncarico]
--   where CodCliente = 48
--   and CodTipoIncarico = 334

SELECT
	*
FROM R_TemplateComunicazione_StatoWorkflowIncarico
WHERE CodTipoIncarico = 378

--DA RIPULIRE

--======================================================================================================
--14) R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
SELECT
	*
FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
WHERE CodTipoIncarico = 334
--(10 rows)

--INSERT INTO [dbo].[R_Cliente_TipoIncarico_AzioneSalvataggioIncarico] 
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[CodAttributoIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[FlagAttesaPartenza]
--           ,[FlagArchiviatoPartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[CodAttributoIncaricoDestinazione]
--           ,[FlagUrgenteDestinazione]
--           ,[FlagAttesaDestinazione]
--           ,[FlagArchiviatoDestinazione]
--           ,[CodAzioneSalvataggioIncarico]
--)
--     SELECT 
--            [CodCliente]
--           ,378 AS [CodTipoIncarico] 
--           ,[CodStatoWorkflowIncaricoPartenza]
--           ,[CodAttributoIncaricoPartenza]
--           ,[FlagUrgentePartenza]
--           ,[FlagAttesaPartenza]
--           ,[FlagArchiviatoPartenza]
--           ,[CodStatoWorkflowIncaricoDestinazione]
--           ,[CodAttributoIncaricoDestinazione]
--           ,[FlagUrgenteDestinazione]
--           ,[FlagAttesaDestinazione]
--           ,[FlagArchiviatoDestinazione]
--           ,[CodAzioneSalvataggioIncarico]
--FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
--WHERE CodTipoIncarico = 334
--and codcliente=48 

SELECT
	*
FROM R_Cliente_TipoIncarico_AzioneSalvataggioIncarico
WHERE CodTipoIncarico = 378

--=================================================================================
--15) R_Cliente_TipoIncarico_TipoAttivitaPianificata
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
WHERE CodTipoIncarico = 334
--(16 rows)

--per il momento non inserisco attività pianificate

--INSERT INTO [dbo].[R_Cliente_TipoIncarico_TipoAttivitaPianificata]
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
           ,332 as [CodTipoIncarico]
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
		and CodTipoIncarico = 91


--DA VERIFICARE
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
WHERE CodTipoIncarico = 378
--(0 row)
--====================================================================================
--16) R_Transizione_AttivitaPianificata
SELECT
	*
FROM R_Transizione_AttivitaPianificata
WHERE CodTipoIncarico = 334
--(1 row)

--INSERT INTO [dbo].[R_Transizione_AttivitaPianificata]
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
           ,378 as [CodTipoIncarico]
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
		where  CodCliente = 48
		and CodTipoIncarico = 334


USE CLC
SELECT
	*
FROM R_Transizione_AttivitaPianificata
WHERE CodTipoIncarico = 378

--============================================================================================
--17) DOCUMENTI
-- Associare il documento all'incarico

USE clc
SELECT
	*
FROM D_OggettoControlli
WHERE codice = 58

--58	Che Banca - Carta di credito

USE CLC
SELECT
	*
FROM D_Documento
WHERE CodOggettoControlli = 58

--20062	Modulo di apertura Carta di Credito
--20063	Richiesta Estinzione Carta Di Credito
--20093	Condizioni Generali Carta di Credito
--20094	DDS Carta di Credito


USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoDocumento
JOIN D_Documento
	ON d_documento.Codice = R_Cliente_TipoIncarico_TipoDocumento.CodDocumento
WHERE codcliente = 48
AND CodTipoIncarico = 334


USE CLC
SELECT
	*
FROM D_Documento
WHERE codice = 20091


--INSERT INTO [dbo].[R_Cliente_TipoIncarico_TipoDocumento]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodDocumento]
--           ,[FlagVisualizza]
--           ,[CodiceRiferimento]
--           ,[CodOggettoControlli])
--     VALUES
--(48,378,20062,1,null, null),
--(48,378,20063,1,null, null),
--(48,378,20093,1,null, null),
--(48,378,20094,1,null, null),
--(48,378,102,1,null, null),
--(48,378,5589,1,null, null),
--(48,378,9,1,null, null)


USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoDocumento
JOIN D_Documento
	ON d_documento.Codice = R_Cliente_TipoIncarico_TipoDocumento.CodDocumento
WHERE codcliente = 48
AND CodTipoIncarico = 378


USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CODCLIENTE = 48

--CI SONO TANTI A NULL


--============================================================================

--CONTROLLI

--da associare








--===============================================================================
--7) workflow:
--R_Cliente_TipoIncarico_MacroStatoWorkFlow


USE CLC
SELECT
	*
FROM D_StatoWorkflowincarico
ORDER BY codice DESC


--INSERT INTO [dbo].[D_StatoWorkflowIncarico]
--           ([Codice]
--           ,[Descrizione])
--     VALUES
--           (14440, 'Carta di Credito attivata')


USE CLC
SELECT
	*
FROM D_StatoWorkflowincarico
WHERE codice = 14440
--14440	Carta di Credito attivata


USE CLC
SELECT
	*
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
JOIN D_StatoWorkflowIncarico
	ON D_StatoWorkflowIncarico.Codice = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
WHERE CodTipoIncarico = 378
AND CodMacroStatoWorkflowIncarico = 9

--use CLC
--INSERT INTO [dbo].[R_Cliente_TipoIncarico_MacroStatoWorkFlow]
--           ([CodCliente]
--           ,[CodTipoIncarico]
--           ,[CodStatoWorkflowIncarico]
--           ,[CodMacroStatoWorkflowIncarico]
--           ,[Ordinamento])
--     VALUES
------(48, 378, 14305, 13,  null), --Gestita CB
------(48, 378, 440,   13,  null),  --Caricamento Errato
------(48, 378, 6500,  12,  null),  --Creata
------(48, 378, 8570,   9,  null),   --Acquisita
------(48, 378, 14332,  2,  null),  --Documentale
------(48, 378, 14333,  2,  null),  --Attesa attivazione accordo
------(48, 378, 14334,  2,  null),  --Errore tecnico
------(48, 378, 8611,   2,  null),   --In attesa di riscontro banca
------(48, 378, 6560,   2,  null),   --Regolarizzata
------(48, 378, 14275, 14,  null),   --Lavorazioni effettuate
--(48, 378, 14440,  9,  null)   --Carta di Credito attivata


--==============================================================================
--8) S_workflowincarico

USE CLC
SELECT
	*
FROM S_WorkflowIncarico
JOIN D_StatoWorkflowIncarico
	ON D_StatoWorkflowIncarico.codice = S_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione
WHERE CodTipoWorkflow = 5
AND CodStatoWorkflowIncaricoPartenza = 14440 --Creata

USE CLC
SELECT
	*
FROM D_StatoWorkflowIncarico
WHERE codice = 14440
--8570	Acquisita
--14440	Carta di Credito attivata
--14275	Lavorazioni effettuate

USE CLC
--INSERT INTO [dbo].[S_WorkflowIncarico]
           ([CodTipoWorkflow]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[FlagCreazione]
           ,[FlagAttesaPartenza])
     VALUES

--(5, 8570, null, 14440, 0, null)  --da in Gestione Acquisita a Carta di Credito attivata
--(5, 14440, null, 14275, 0, null)  --da Carta di Credito attivata a lavorazioni effettuate
--(5, 14440, null, 8611, 0, null),  --da Carta di Credito attivata a in attesa riscontro banca
--(5, 14440, null, 14332, 0, null),  --da Carta di Credito attivata a documentale
--(5, 14440, null, 14333, 0, null) , --da Carta di Credito attivata a attesa attivazione accordo
--(5, 14440, null, 14334, 0, null)  --da Carta di Credito attivata a errore tecnico

--==============================================================================

--==================================================================================================
---TABELLE TRASFERIMENTO MULTIUTILITY---Da pre-prod a prod
use clc
SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'R_profiloaccesso_abilitazioneincarico'

--1) Generale incarichi
--2) Workflow incarichi
--3) Note incarichi
--4) Documenti
--5) Mailer
--6) Attività pianificate incarichi
--7) Archivio Qtask
--8) Profili accesso
--9) Controlli