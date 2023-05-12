USE CLC
GO

SELECT * FROM D_Documento ORDER BY Codice DESC

--20323	CB - Modulo di Apertura Conto Digital
--20322	CB - Condizioni Generali Conto Digital
--20321	CB - Documento di Sintesi Conto Digital
--20319	CB - Foglio Informativo Conto Digital

--INSERT into [VP-BTSQL02].CLC.dbo.R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza, CodiceRiferimento, CodOggettoControlli)
SELECT
	CodCliente,
	CodTipoIncarico,
	CodDocumento,
	FlagVisualizza,
	CodiceRiferimento,
	CodOggettoControlli
FROM R_Cliente_TipoIncarico_TipoDocumento
WHERE CodDocumento IN (20323
, 20322
, 20321
, 20319)



--INSERT into [VP-BTSQL02].CLC.dbo.S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia, NomeMacro, FlagGeneratoreLegacy)

SELECT --IdTemplate,
	CodOggettoGenerazione,
	CodTipoDocumento,
	'CESAM\CheBanca\PredisposizioneContratto\ContoDigital\ModuloAperturaContoDigital.dot',
	FlagDocx,
	FlagCopia,
	NomeMacro,
	FlagGeneratoreLegacy
FROM S_TemplateDocumento
WHERE IdTemplate = --4089
--4090
--4091
4092


--preprod

SELECT * FROM S_TemplateDocumento 
where CodTipoDocumento IN (20323
, 20322
, 20321
, 20319)

--INSERT into R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente, CodTipoIncarico, Priorita)
	--VALUES (4641, 48, 331, 3)
	--		,(4642, 48, 331, 3)
	--		,(4643, 48, 331, 3)
	--		,(4644, 48, 331, 3);



/* fai girare come operation/arad sa di queste robe nuove

UPDATE R_Cliente_TipoIncarico_TipoDocumento
SET FlagVisualizza = 1
WHERE CodTipoDocumento IN (20323
, 20322
, 20321
, 20319)



INSERT INTO R_TransizioneIncarico_GenerazioneDocumento (CodCliente, CodTipoIncarico, FlagCreazione, CodStatoWorkflowIncaricoPartenza, CodAttributoIncaricoPartenza, FlagUrgentePartenza, FlagAttesaPartenza, FlagArchiviatoPartenza, CodStatoWorkflowIncaricoDestinazione, CodAttributoIncaricoDestinazione, FlagUrgenteDestinazione, FlagAttesaDestinazione, FlagArchiviatoDestinazione, IdTemplateDocumento, FlagXml, FlagPdf, Priorita)

SELECT 	
		CodCliente,
		CodTipoIncarico,
		FlagCreazione,
		CodStatoWorkflowIncaricoPartenza,
		CodAttributoIncaricoPartenza,
		FlagUrgentePartenza,
		FlagAttesaPartenza,
		FlagArchiviatoPartenza,
		CodStatoWorkflowIncaricoDestinazione,
		CodAttributoIncaricoDestinazione,
		FlagUrgenteDestinazione,
		FlagAttesaDestinazione,
		FlagArchiviatoDestinazione,
		4641,--4642 --4643 --4644
		FlagXml,
		FlagPdf,
		Priorita 
		
		FROM R_TransizioneIncarico_GenerazioneDocumento where IdTemplateDocumento = 4313


--INSERT into R_TemplateComunicazione_Documento	 (IdTemplateComunicazione, CodDocumento, Ordinamento, DescrizioneAllegato)
--	VALUES (8512, 20323, null, null)
--		   ,(8512, 20322, null, NULL)
--		   ,(8512, 20321, null, null)
--		   ,(8512, 20319, null, null)

--delete
SELECT * FROM R_TemplateComunicazione_Documento where CodDocumento = 8395

*/

SELECT r.*, ddoc.Descrizione FROM R_TemplateComunicazione_Documento r
JOIN D_Documento ddoc on ddoc.Codice = r.CodDocumento
where IdTemplateComunicazione = 8512

