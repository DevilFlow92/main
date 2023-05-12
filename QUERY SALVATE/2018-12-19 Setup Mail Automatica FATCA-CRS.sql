USE clc
GO

SELECT * FROM T_R_Incarico_Persona
JOIN T_Persona on T_R_Incarico_Persona.IdPersona = T_Persona.IdPersona

WHERE IdIncarico = 5180209

--ComuneNascitaEstero


SELECT * FROM D_TipoIncarico WHERE Descrizione LIKE '%fatca%'

--198	Procedura CRS/FATCA




SELECT * FROM D_StatoWorkflowIncarico ORDER BY Codice DESC

--INSERT INTO D_StatoWorkflowIncarico (Codice, Descrizione)
--	VALUES (15472, 'Comunicazione Recupero Informazioni FATCA inviata')
--			,(15473,'Comunicazione Recupero Informazioni CRS inviata')


SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow 
WHERE CodCliente = 23 and CodTipoIncarico = 198

--INSERT into R_Cliente_TipoIncarico_MacroStatoWorkFlow (CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, CodMacroStatoWorkflowIncarico, Ordinamento)
SELECT
	CodCliente
	,CodTipoIncarico
	,D_StatoWorkflowIncarico.Codice
	,CodMacroStatoWorkflowIncarico
	,Ordinamento
FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
JOIN D_StatoWorkflowIncarico
	ON IdRelazione = 4849

WHERE D_StatoWorkflowIncarico.Codice IN (15472, 15473)


SELECT * FROM rs.v_CESAM_AZ_@p_TipoINCARICO_TipoWORKFLOW where CodTipoIncarico = 198

SELECT * FROM S_WorkflowIncarico where CodTipoWorkflow = 78


--INSERT into S_WorkflowIncarico (CodTipoWorkflow, CodStatoWorkflowIncaricoPartenza, FlagUrgentePartenza, CodStatoWorkflowIncaricoDestinazione, FlagCreazione, FlagAttesaPartenza)
SELECT
	CodTipoWorkflow
	,CodStatoWorkflowIncaricoPartenza
	,FlagUrgentePartenza
	,D_StatoWorkflowIncarico.Codice
	,FlagCreazione
	,FlagAttesaPartenza
FROM S_WorkflowIncarico
JOIN D_StatoWorkflowIncarico
	ON IdRelazione = 21516
WHERE D_StatoWorkflowIncarico.Codice IN (15472, 15473)
UNION ALL
SELECT
	CodTipoWorkflow
	,D_StatoWorkflowIncarico.Codice
	,FlagUrgentePartenza
	,CodStatoWorkflowIncaricoDestinazione
	,FlagCreazione
	,FlagAttesaPartenza
FROM S_WorkflowIncarico
JOIN D_StatoWorkflowIncarico
	ON CodTipoWorkflow = 78
	AND CodStatoWorkflowIncaricoPartenza = 8570
	AND CodStatoWorkflowIncaricoDestinazione NOT IN (15472, 15473)
WHERE D_StatoWorkflowIncarico.Codice IN (15472, 15473)




--INSERT into D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, CodiceRiferimentoKtesios, Ordinamento, TestoHelp, FlagScanCEI, NumeroPagine)
SELECT
	251005
	,'Recupero FATCA'
	,'Recupero FATCA'
	,CodOggettoControlli
	,FlagDocumentoBase
	,CodiceRiferimentoKtesios
	,Ordinamento
	,TestoHelp
	,FlagScanCEI
	,NumeroPagine
FROM D_Documento
WHERE Codice = 5769

--INSERT into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
SELECT
	CodCliente
	,CodTipoIncarico
	,251005
	,FlagVisualizza
	,CodiceRiferimento
	,CodOggettoControlli
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodCliente = 23
AND CodTipoIncarico = 198
AND CodDocumento = 5769


SELECT * FROM S_TemplateDocumento
JOIN D_Documento on Codice = CodTipoDocumento

WHERE IdTemplate = 3380

--INSERT INTO S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)
SELECT
	CodOggettoGenerazione
	,251005
	,'CESAM\Azimut\Sospeso\AutocertificazioneFATCA.pdf'
	,FlagDocx
	,FlagCopia
	,NomeMacro
	,FlagGeneratoreLegacy
FROM S_TemplateDocumento
WHERE IdTemplate = 3380

--INSERT into R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
SELECT
	5119
	,CodCliente
	,CodTipoIncarico
	,Priorita
FROM R_Cliente_TemplateDocumento
WHERE IdTemplateDocumento = 3380


--INSERT INTO R_TransizioneIncarico_GenerazioneDocumento (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, IdTemplateDocumento, FlagXml, FlagPdf, Priorita)
SELECT
	CodCliente
	,CodTipoIncarico
	,FlagCreazione
	,CodStatoWorkflowIncaricoPartenza
	,CodAttributoIncaricoPartenza
	,FlagUrgentePartenza
	,FlagAttesaPartenza
	,FlagArchiviatoPartenza
	,CodStatoWorkflowIncaricoDestinazione
	,CodAttributoIncaricoDestinazione
	,FlagUrgenteDestinazione
	,FlagAttesaDestinazione
	,FlagArchiviatoDestinazione
	,5119--IdTemplateNuovo
	,FlagXml
	,FlagPdf
	,Priorita
FROM R_TransizioneIncarico_GenerazioneDocumento
WHERE IdTemplateDocumento = 3380




--IdTemplateComunicazione 13405

SELECT
	*
FROM S_TemplateComunicazione
JOIN D_TipoComunicazione
	ON S_TemplateComunicazione.CodTipoComunicazione = D_TipoComunicazione.Codice
WHERE IdTemplate = 13405

SELECT Descrizione, * 
FROM R_TemplateComunicazione_StatoWorkflowIncarico r
JOIN S_TemplateComunicazione s ON r.IdTemplateComunicazione = s.IdTemplate
JOIN D_TipoComunicazione ON s.CodTipoComunicazione = Codice
WHERE CodTipoIncarico = 331

SELECT * FROM R_TemplateComunicazione_Documento 
JOIN D_Documento on CodDocumento = D_Documento.Codice
where --IdTemplateComunicazione = 8512
IdTemplateComunicazione IN (
6828
, 7443
, 13405
)

--INSERT into R_TemplateComunicazione_Documento (IdTemplateComunicazione, CodDocumento, Ordinamento, DescrizioneAllegato, IdTipoDocumentoNecessario, FlagObbligatorio)
SELECT
	13405
	,251005
	,Ordinamento
	,DescrizioneAllegato
	,IdTipoDocumentoNecessario
	,1
FROM R_TemplateComunicazione_Documento
WHERE IdRelazione = 6650



--INSERT into R_TemplateComunicazione_TransizioneIncarico (IdTemplateComunicazione, CodStatoWorkflowPartenza, FlagUrgentePartenza, CodAttributoPartenza, CodStatoWorkflowDestinazione, FlagUrgenteDestinazione, CodAttributoDestinazione, CodCliente, CodTipoIncarico, FlagCreazione)
SELECT 
	13405
	,8570
	,FlagUrgentePartenza
	,455
	,15472
	,FlagUrgenteDestinazione
	,CodAttributoDestinazione
	,23
	,198
	,FlagCreazione
FROM R_TemplateComunicazione_TransizioneIncarico
WHERE IdTemplateComunicazione = 8473
UNION ALL
SELECT
	7443
	,8570
	,FlagUrgentePartenza
	,455
	,15473
	,FlagUrgenteDestinazione
	,CodAttributoDestinazione
	,23
	,198
	,FlagCreazione
FROM R_TemplateComunicazione_TransizioneIncarico
WHERE IdTemplateComunicazione = 8473


SELECT * FROM R_TemplateComunicazione_TransizioneIncarico WHERE IdTemplateComunicazione = 13405
 


 SELECT * FROM R_TemplateComunicazione_ValutazioneDatiIncarico where IdTemplateComunicazione = 13405

 SELECT * FROM S_ValutazioneDatiIncarico where CodTipoIncarico = 198


 
-- UPDATE R_TemplateComunicazione_TransizioneIncarico 
-- SET CodAttributoPartenza = null
--,CodStatoWorkflowPartenza = 8570
-- WHERE IdTemplateComunicazione in (13405,7443)

