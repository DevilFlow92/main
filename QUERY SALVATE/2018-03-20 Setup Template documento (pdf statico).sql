USE clc

GO

select * FROM D_Documento order BY Codice DESC 
--ultimo codice documento 20130

--INSERT INTO [dbo].[D_Documento]
--           ([Codice]
--           ,[Descrizione]
--           ,[Etichetta]
--           ,[CodOggettoControlli]
--           ,[FlagDocumentoBase]
--           ,[CodiceRiferimentoKtesios]
--           ,[Ordinamento]
--           ,[TestoHelp]
--           ,[FlagScanCEI]
--           ,[NumeroPagine])

--SELECT
--	20131
--   ,'CB-Strong Authentication'
--   ,'CB-Strong Authentication'
--   ,[CodOggettoControlli]
--   ,[FlagDocumentoBase]
--   ,[CodiceRiferimentoKtesios]
--   ,[Ordinamento]
--   ,[TestoHelp]
--   ,[FlagScanCEI]
--   ,[NumeroPagine]
--FROM D_Documento
--WHERE Codice = 8301

SELECT
	*
FROM S_TemplateDocumento
WHERE CodTipoDocumento = 8301
--idtemplate 3920

--INSERT INTO S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)
--SELECT
--	CodOggettoGenerazione
--   ,20131
--   ,'CESAM\CheBanca\PredisposizioneContratto\DocumentoPredisposizioneStrongAuthentication.pdf'
--   ,FlagDocx
--   ,1		--quando si vuole generare un pdf statico porre il flag copia = 1
--   ,NomeMacro
--   ,FlagGeneratoreLegacy
--FROM S_TemplateDocumento
--WHERE IdTemplate = 3920

SELECT
	*
FROM S_TemplateDocumento
ORDER BY IdTemplate DESC
--idtemplate strong 4499

--INSERT INTO R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza,CodiceRiferimento,CodOggettoControlli)
--SELECT
--	CodCliente
--   ,CodTipoIncarico
--   ,20131
--   ,FlagVisualizza
--   ,CodiceRiferimento
--   ,CodOggettoControlli
--FROM R_Cliente_TipoIncarico_TipoDocumento
--WHERE CodDocumento = 8301 and CodTipoIncarico = 331


--INSERT INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
SELECT
	4499
   ,CodCliente
   ,CodTipoIncarico
   ,Priorita
FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento = 4314

select * FROM S_TemplateDocumento order BY IdTemplate desc

select * FROM D_Documento order BY Codice DESC 

select * FROM R_Cliente_TemplateDocumento order BY IdRelazione DESC 

select * FROM R_Cliente_TipoIncarico_TipoDocumento order BY IdRelazione DESC 

select * FROM D_GruppoTabelleSetup
join R_GruppoTabelleSetup_TabellaSetup on D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup on D_TabellaSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup
where D_TabellaSetup.descrizione = 'R_Cliente_TipoIncarico_TipoDocumento'

--generatore documenti




USE CLC

--allegati disponibili template comunicazione
SELECT
	r.*
   ,D_Documento.descrizione
FROM R_TemplateComunicazione_Documento r
JOIN D_Documento
	ON r.CodDocumento = D_Documento.Codice
WHERE IdTemplateComunicazione = 8512 --questa è la tabella dove mettere i documenti

--quando si apre il template?
select * FROM R_TemplateComunicazione_TransizioneIncarico where IdTemplateComunicazione = 8512
--transizione in nuova - invio contratto 14299

--come si differenziano gli allegati?
--digital
select * FROM D_StatoWorkflowIncarico where Descrizione LIKE '%yellow'
--14298	Predisposizione Conto Yellow

SELECT * FROM D_StatoWorkflowIncarico where Descrizione like '%digital'
--14314	Predisposizione Conto Digital


--allegati del yellow
select * FROM R_TransizioneIncarico_GenerazioneDocumento where CodTipoIncarico = 331 and CodStatoWorkflowIncaricoDestinazione = 14298
--4159
--4183
--4184
--4185
--4186
--4187
--4188


--allegati del digital
select * FROM R_TransizioneIncarico_GenerazioneDocumento where CodTipoIncarico = 331 and CodStatoWorkflowIncaricoDestinazione = 14314
--4313
--4188
--4499


