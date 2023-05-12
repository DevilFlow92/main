USE CLC
GO

SELECT NumeroDossier, * FROM T_R_Incarico_Mandato
JOIN T_Mandato ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
JOIN T_Dossier ON T_Mandato.IdDossier = T_Dossier.IdDossier

WHERE IdIncarico = 10118423

SELECT * FROM T_Dossier where NumeroDossier = 'D000465777'


SELECT NumeroSimula, * FROM T_Mandato where IdDossier = 180321


SELECT * FROM L_ImportSimula WHERE CodiceSimula = 1028577

/*
633008
,633009
,633010
,633011
*/

USE CLC
GO

INSERT into L_ImportSimula (CodiceSimula, CodiceDisposizione, DataSimula, NumeroDossier, CodicePromotore, ChiaveClientePromotore, CognomePromotore, NomePromotore, CodiceAreaCentroRaccolta, DescrizioneAreaCentroRaccolta, IndirizzoSim, CodiceSim, DescrizioneSim, CodiceCentroRaccolta, DescrizioneCentroRaccolta, IndirizzoCentroRaccolta, DataImport, NomeFile, FlagAggiornamentoCompletato, CodiceSimulaMaxFunds)
SELECT
	CodiceSimula,
	CodiceDisposizione,
	DataSimula,
	NumeroDossier,
	CodicePromotore,
	ChiaveClientePromotore,
	CognomePromotore,
	NomePromotore,
	CodiceAreaCentroRaccolta,
	DescrizioneAreaCentroRaccolta,
	IndirizzoSim,
	CodiceSim,
	DescrizioneSim,
	CodiceCentroRaccolta,
	DescrizioneCentroRaccolta,
	IndirizzoCentroRaccolta,
	DataImport,
	NomeFile,
	FlagAggiornamentoCompletato,
	CodiceSimulaMaxFunds
FROM [BTSQLCL05\BTSQLCL05].CLC.dbo.L_ImportSimula
WHERE IdImportSimula IN (
633008
, 633009
, 633010
, 633011
)



CREATE TABLE #simule (idimportProd INT , idimportTEST INT)

INSERT INTO #simule (idimportProd, idimportTEST)

SELECT DISTINCT prod.IdImportSimula, test.IdImportSimula --, prod.CodiceSimula
FROM L_ImportSimula test 
JOIN [BTSQLCL05\BTSQLCL05].clc.dbo.L_ImportSimula prod ON test.CodiceSimula = prod.CodiceSimula 
															AND test.CodiceDisposizione = prod.CodiceDisposizione														
WHERE prod.IdImportSimula IN (
633008
, 633009
, 633010
, 633011
)


INSERT into L_ImportSimulaOperazione (IdImportSimula, NumeroMandato, CodiceOperazione, DescrizioneOperazione, SocietaProdotto, MacroProdotto, CodiceProdotto, DescrizioneProdotto, IsinProdotto, ImportoOperazione, Riga, FlagAssociato)
SELECT
	#simule.idimportTEST,
	NumeroMandato,
	CodiceOperazione,
	DescrizioneOperazione,
	SocietaProdotto,
	MacroProdotto,
	CodiceProdotto,
	DescrizioneProdotto,
	IsinProdotto,
	ImportoOperazione,
	Riga,
	FlagAssociato
FROM [BTSQLCL05\BTSQLCL05].CLC.dbo.L_ImportSimulaOperazione
JOIN #simule ON idimportProd = IdImportSimula


INSERT into L_ImportSimulaAnagrafica (IdImportSimula, ChiaveCliente, Ruolo, Cognome, Nome, CodiceFiscale, CodiceSae, CodiceAteco, DescrizioneAttivita, DataNascita, LocalitaNascita, SiglaStatoCittadinanza, DescrizioneStatoCittadinanza, Indirizzo, Cap, Localita, SiglaProvincia, Stato, CodiceDocumentoIdentita, NumeroDocumentoIdentita, DataRilascioDocumentoIdentita, LocalitaRilascioDocumentoIdentita, DataScadenzaDocumentoIdentita, Email, Riga)
SELECT
	idimportTEST,
	ChiaveCliente,
	Ruolo,
	Cognome,
	Nome,
	CodiceFiscale,
	CodiceSae,
	CodiceAteco,
	DescrizioneAttivita,
	DataNascita,
	LocalitaNascita,
	SiglaStatoCittadinanza,
	DescrizioneStatoCittadinanza,
	Indirizzo,
	Cap,
	Localita,
	SiglaProvincia,
	Stato,
	CodiceDocumentoIdentita,
	NumeroDocumentoIdentita,
	DataRilascioDocumentoIdentita,
	LocalitaRilascioDocumentoIdentita,
	DataScadenzaDocumentoIdentita,
	Email,
	Riga
FROM [BTSQLCL05\BTSQLCL05].CLC.dbo.L_ImportSimulaAnagrafica
JOIN #simule
	ON idimportProd = IdImportSimula





	SELECT L_ImportSimula.*
			
	FROM L_ImportSimula

	JOIN L_ImportSimulaAnagrafica on L_ImportSimula.IdImportSimula = L_ImportSimulaAnagrafica.IdImportSimula
	JOIN L_ImportSimulaOperazione ON L_ImportSimula.IdImportSimula = L_ImportSimulaOperazione.IdImportSimula

	WHERE CodiceSimula = 1028577


	


