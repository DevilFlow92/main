USE CLC
GO



SELECT * FROM D_TipoIncarico
ORDER BY Codice DESC


--522	--Verifiche Rafforzate Test

--EXEC orga.AP_ClonaSetupIncarichi	@CodCliente = 23
--									,@CodTipoIncarico = 522
--									,@Server = 'vp-btsql02'
--									,@Database = 'clc'
--									,@Schema = 'dbo'
--									,@NuovoCliente = 23
--									,@NuovoTipoIncarico = 524



/*gruppo tabelle setup
	Workflow incarichi
	Attributi QT
*/
--------------------------------R_Cliente_Attributo--------------------------------
Insert into R_Cliente_Attributo (CodCliente, CodTipoIncarico, CodAttributo)
select 23, 524, CodAttributo
 from [vp-btsql02].clc.dbo.R_Cliente_Attributo where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Generatore documenti
*/
--------------------------------R_Cliente_TemplateDocumento--------------------------------
Insert into R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
select IdTemplateDocumento, 23, 524, Priorita
 from [vp-btsql02].clc.dbo.R_Cliente_TemplateDocumento where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico--------------------------------
Insert into R_Cliente_TipoIncarico (CodCliente, CodTipoIncarico, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore)
select 23, 524, CodTipoWorkflow, FlagMostraElementiSubincarichi, CodTabIncaricoDefault, FlagMostraElementiIncarichiMaster, CodAssegnaAutomaticamenteRuoloOperatoreIncarico, FlagAssegnaAutomaticamenteAreaDaOperatore
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_AltroEnteSegnalante--------------------------------
Insert into R_Cliente_TipoIncarico_AltroEnteSegnalante (CodCliente, CodTipoIncarico, CodAltroEnteSegnalante)
select 23, 524, CodAltroEnteSegnalante
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_AltroEnteSegnalante where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
	Aree incarichi QTask
*/
--------------------------------R_Cliente_TipoIncarico_Area--------------------------------
Insert into R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
select 23, 524, CodArea
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_Area where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
*/
--------------------------------R_Cliente_TipoIncarico_ControllaDuplicati--------------------------------
Insert into R_Cliente_TipoIncarico_ControllaDuplicati (CodCliente, CodTipoIncarico, FlagBloccante, FlagAbilita)
select 23, 524, FlagBloccante, FlagAbilita
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_ControllaDuplicati where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_DatoAssociabile--------------------------------
Insert into R_Cliente_TipoIncarico_DatoAssociabile (CodCliente, CodTipoIncarico, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili)
select 23, 524, CodDatoAssociabile, Cardinalita, FlagMostraInRicerca, ElementiSubincarichiVisualizzabili
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_DatoAssociabile where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_EsitoTelefonata--------------------------------
Insert into R_Cliente_TipoIncarico_EsitoTelefonata (CodCliente, CodTipoIncarico, CodEsitoTelefonata)
select 23, 524, CodEsitoTelefonata
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_EsitoTelefonata where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Generale incarichi
*/
--------------------------------R_Cliente_TipoIncarico_IncaricoCollegabile--------------------------------
Insert into R_Cliente_TipoIncarico_IncaricoCollegabile (CodCliente, CodTipoIncarico, CodTipoIncaricoCollegabile, CodDatoAssociabileCollegabile, FlagAbilita)
select 23, 524, CodTipoIncaricoCollegabile, CodDatoAssociabileCollegabile, FlagAbilita
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_IncaricoCollegabile where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Workflow incarichi
	Extranet 3.0 - Richieste – Workflow/Transizioni
*/
--------------------------------R_Cliente_TipoIncarico_MacroStatoWorkFlow--------------------------------
Insert into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
select 23, 524, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_MacroStatoWorkFlow where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	
*/
--------------------------------R_Cliente_TipoIncarico_MandatoDossier--------------------------------
Insert into R_Cliente_TipoIncarico_MandatoDossier (CodCliente, CodTipoIncarico, FlagMandatoDossierPresenti, FlagMandatoDossierObbligatori)
select 23, 524, FlagMandatoDossierPresenti, FlagMandatoDossierObbligatori
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_MandatoDossier where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Telefonata
*/
--------------------------------R_Cliente_TipoIncarico_MotivoTelefonata--------------------------------
Insert into R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente, CodTipoIncarico, CodMotivoTelefonata)
select 23, 524, CodMotivoTelefonata
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_MotivoTelefonata where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Tabelle Antiriciclaggio
*/
--------------------------------R_Cliente_TipoIncarico_RuoloRichiedente--------------------------------
Insert into R_Cliente_TipoIncarico_RuoloRichiedente (CodCliente, CodTipoIncarico, CodRuoloRichiedente)
select 23, 524, CodRuoloRichiedente
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_RuoloRichiedente where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Attività pianificate incarichi
*/
--------------------------------R_Cliente_TipoIncarico_TipoAttivitaPianificata--------------------------------
Insert into R_Cliente_TipoIncarico_TipoAttivitaPianificata (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza)
select 23, 524, CodStatoWorkflowIncarico, CodTipoAttivitaPianificata, CodStatoWorkflowDeadline, MinutiDeadline, NomeStoredProcedureMatch, FlagUrgente, FlagNotaObbligatoria, CodAttributo, FlagIntervalloLavorativo, NomeStoredProcedureAggiornamentoDataScadenza
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_TipoAttivitaPianificata where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Dati Aggiuntivi
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_TipoDatoAggiuntivo--------------------------------
Insert into R_Cliente_TipoIncarico_TipoDatoAggiuntivo (CodCliente, CodTipoIncarico, CodTipoDatoAggiuntivo)
select 23, 524, CodTipoDatoAggiuntivo
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_TipoDatoAggiuntivo where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Documenti
	Documenti Q-Task
	Extranet 3.0 - Richieste
*/
--------------------------------R_Cliente_TipoIncarico_TipoDocumento--------------------------------
Insert into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
select 23, 524, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_TipoDocumento where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Note incarichi
*/
--------------------------------R_Cliente_TipoIncarico_TipoNotaIncarichi--------------------------------
Insert into R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente, CodTipoIncarico, CodTipoNotaIncarichi)
select 23, 524, CodTipoNotaIncarichi
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_TipoNotaIncarichi where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Documenti Q-Task
	Extranet 3.0 - Richieste
	Documenti ScanMOL QT
*/
--------------------------------R_Documento_Cliente_TipoIncarico--------------------------------
Insert into R_Documento_Cliente_TipoIncarico (CodDocumento, CodCliente, CodTipoIncarico, CodiceSede)
select CodDocumento, 23, 524, CodiceSede
 from [vp-btsql02].clc.dbo.R_Documento_Cliente_TipoIncarico where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Abilitazioni operatori Q_Task
	Profili accesso
	Extranet 3.0 - profili
*/
--------------------------------R_ProfiloAccesso_AbilitazioneIncarico--------------------------------
Insert into R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
select CodProfiloAccesso, 23, 524, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore
 from [vp-btsql02].clc.dbo.R_ProfiloAccesso_AbilitazioneIncarico where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Extranet 3.0 - profili
	Attributi QT
*/
--------------------------------R_ProfiloAccesso_AttributoIncarico--------------------------------
Insert into R_ProfiloAccesso_AttributoIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodAttributoIncarico, FlagAbilita)
select CodProfiloAccesso, 23, 524, CodAttributoIncarico, FlagAbilita
 from [vp-btsql02].clc.dbo.R_ProfiloAccesso_AttributoIncarico where codtipoincarico = 522 and codcliente = 23



/*gruppo tabelle setup
	Operatori CEI Qtask
	Operatori QTask
	Extranet 3.0 - profili
*/
--------------------------------R_ProfiloAccesso_TipoIncarico_Privilegio--------------------------------
Insert into R_ProfiloAccesso_TipoIncarico_Privilegio (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodPrivilegio, FlagAbilita, CodStatoWorkflowIncarico)
select CodProfiloAccesso, 23, 524, CodPrivilegio, FlagAbilita, CodStatoWorkflowIncarico
 from [vp-btsql02].clc.dbo.R_ProfiloAccesso_TipoIncarico_Privilegio where codtipoincarico = 522 and codcliente = 23

