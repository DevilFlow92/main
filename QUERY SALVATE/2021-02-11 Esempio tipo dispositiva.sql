ALTER VIEW rs.v_CESAM_AZ_Operazioni_Caricamento_FONDI
AS

/*

Autore: Lorenzo Spanu
Data: 08/02/2019

Utilizzata per il caricamento automatico delle operazioni di Fondi Investimento Azimut

Report: AZ - Fondi Azimut - Caricamento Operazioni Sottoscrizioni con Assegni su FEND

*/

WITH IncarichiAssegno
AS (SELECT
	dbo.T_Incarico.IdIncarico,
	dbo.T_Incarico.CodTipoIncarico,
	dbo.T_Incarico.DataCreazione,
	dbo.T_Incarico.CodStatoWorkflowIncarico,
	dbo.T_Incarico.DataUltimaTransizione
FROM dbo.T_Incarico
LEFT JOIN (SELECT
	dbo.T_Documento.IdIncarico,
	1 AS IsPresente
FROM dbo.T_Documento
WHERE dbo.T_Documento.Tipo_Documento = 1713 --Copia Assegno
AND dbo.T_Documento.FlagPresenzaInFileSystem = 1
AND dbo.T_Documento.FlagScaduto = 0
GROUP BY dbo.T_Documento.IdIncarico) AS AssegnoDoc
	ON AssegnoDoc.IdIncarico = dbo.T_Incarico.IdIncarico
LEFT JOIN (SELECT
	dbo.L_WorkflowIncarico.IdIncarico,
	1 AS IsPresente,
	MAX(dbo.L_WorkflowIncarico.DataTransizione) AS DataTransizione
FROM dbo.L_WorkflowIncarico
WHERE (dbo.L_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione = 6604 --In Attesa Versamento Assegno
AND dbo.L_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza != 6604)
GROUP BY dbo.L_WorkflowIncarico.IdIncarico) AS AssegnoTrans
	ON AssegnoTrans.IdIncarico = dbo.T_Incarico.IdIncarico
WHERE dbo.T_Incarico.CodCliente = 23
AND dbo.T_Incarico.CodTipoIncarico IN (83	--Sottoscrizioni/Versamenti FONDI Investimento
,540	--Sottoscrizioni Lux - Zenith
,553	--Versamenti Aggiuntivi Lux - Zenith
,580	--Sottoscrizioni Fondi - Zenith
,581	--Versamenti Aggiuntivi Fondi - Zenith
)
AND dbo.T_Incarico.CodArea = 8
AND dbo.T_Incarico.FlagArchiviato = 0
AND dbo.T_Incarico.DataUltimaTransizione >= DATEADD(MONTH, -1, GETDATE())
AND (dbo.T_Incarico.CodStatoWorkflowIncarico = 6604
OR (dbo.T_Incarico.CodStatoWorkflowIncarico = 8570
AND AssegnoDoc.IsPresente = 1))),

DatiPersona
AS (SELECT
	T_Persona.IdPersona,
	T_Persona.ChiaveCliente,
	T_Persona.Cognome,
	T_Persona.Nome,
	T_Persona.CodiceFiscale,
	T_Persona.RagioneSociale
FROM T_Persona
WHERE T_Persona.CodCliente = 23),

Anagrafiche
AS (SELECT DISTINCT
	IncarichiAssegno.IdIncarico,
	ISNULL(T_R_Incarico_Persona.Progressivo, T_R_Dossier_Persona.Progressivo) ProgressivoPersona,
	ISNULL(T_R_Dossier_Persona.codruolorichiedente, T_R_Incarico_Persona.codruolorichiedente) codruolorichiedente,
	ISNULL(ClienteDossier.IdPersona, ClientePersona.IdPersona) IdPersonaCliente,
	ISNULL(ClienteDossier.ChiaveCliente, ClientePersona.ChiaveCliente) ChiaveClienteIntestatario,
	ISNULL(ClienteDossier.Cognome, ClientePersona.Cognome) CognomeIntestatario,
	ISNULL(ClienteDossier.Nome, ClientePersona.Nome) NomeIntestatario,
	ISNULL(ClienteDossier.CodiceFiscale, ClientePersona.CodiceFiscale) CodiceFiscaleIntestatario,
	ISNULL(ClienteDossier.RagioneSociale, ClientePersona.RagioneSociale) RagioneSocialeIntestatario,
	ISNULL(PromotoreDossier.IdPersona, PromotorePersona.IdPersona) IdPersonaPromotore,
	ISNULL(T_Promotore_Dossier.Codice, T_Promotore.Codice) CodicePromotore,
	ISNULL(PromotoreDossier.Cognome, PromotorePersona.Cognome) CognomePromotore,
	ISNULL(PromotoreDossier.Nome, PromotorePersona.Nome) NomePromotore,
	ISNULL(PromotorePersona.RagioneSociale, PromotoreDossier.RagioneSociale) RagioneSocialePromotore
FROM IncarichiAssegno
LEFT JOIN T_R_Incarico_Persona
	ON IncarichiAssegno.IdIncarico = T_R_Incarico_Persona.IdIncarico
LEFT JOIN DatiPersona ClientePersona
	ON T_R_Incarico_Persona.IdPersona = ClientePersona.IdPersona
LEFT JOIN T_R_Incarico_Promotore
	ON IncarichiAssegno.IdIncarico = T_R_Incarico_Promotore.IdIncarico
LEFT JOIN T_Promotore
	ON T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
LEFT JOIN DatiPersona PromotorePersona
	ON PromotorePersona.IdPersona = T_Promotore.IdPersona
LEFT JOIN T_R_Incarico_Mandato
	ON IncarichiAssegno.IdIncarico = T_R_Incarico_Mandato.IdIncarico
LEFT JOIN T_Mandato
	ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
LEFT JOIN T_Dossier
	ON T_Mandato.IdDossier = T_Dossier.IdDossier
LEFT JOIN T_R_Dossier_Persona
	ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
LEFT JOIN T_Promotore T_Promotore_Dossier
	ON T_Dossier.IdPromotore = T_Promotore_Dossier.IdPromotore
LEFT JOIN DatiPersona PromotoreDossier
	ON PromotoreDossier.IdPersona = T_Promotore_Dossier.IdPersona
LEFT JOIN DatiPersona ClienteDossier
	ON ClienteDossier.IdPersona = T_R_Dossier_Persona.IdPersona),

TipoOperazioneAzimut
AS (SELECT DISTINCT

	IncarichiAssegno.IdIncarico,

	--Codice	Descrizione
	--1			Vers.iniziale Pac
	--2			Versamento iniziale
	--3			Versamento successivo
	--32		Versamento succ. PAC

	--1			Versamento Iniziale MultiPAC
	--2			Versamento Successivo MultiPAC
	--3			Versamento Iniziale PAC
	--4			Versamento Successivo PAC
	--5			Versamento Iniziale PIC
	--6			Versamento Successivo PIC

	CASE

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) <= 5 THEN 1 --'Versamento Iniziale MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) <= 5 THEN 2 --'Versamento Successivo MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 5 THEN 5 --'Versamento Iniziale PIC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 5 THEN 6 --'Versamento Successivo PIC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 3 --'Versamento Iniziale PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 4 --'Versamento Successivo PAC'

		WHEN CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo >= '500.000' THEN 3 --'Versamento Iniziale PAC'

		WHEN CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo >= '500.000' THEN 4 --'Versamento Successivo PAC'		

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 3 --'Versamento Iniziale PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			Importo < '500.000' THEN 2 --'Versamento Iniziale MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 4 --'Versamento Successivo PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			Importo < '500.000' THEN 2 --'Versamento Successivo MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 THEN 6

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 THEN 5


	END CodTipoOperazione,

	CASE

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) <= 5 THEN 'Versamento Iniziale MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) <= 5 THEN 'Versamento Successivo MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 5 THEN 'Versamento Iniziale PIC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 5 THEN 'Versamento Successivo PIC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 'Versamento Iniziale PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 'Versamento Successivo PAC'

		WHEN CodTipoOperazioneAzimut = 1 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo >= '500.000' THEN 'Versamento Iniziale PAC'

		WHEN CodTipoOperazioneAzimut = 32 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo >= '500.000' THEN 'Versamento Successivo PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 'Versamento Iniziale PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			Importo < '500.000' THEN 'Versamento Iniziale MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 AND
			COUNT(T_OperazioneAzimut.IdIncarico) = 1 AND
			Importo < '500.000' THEN 'Versamento Successivo PAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 AND
			COUNT(T_OperazioneAzimut.IdIncarico) > 1 AND
			Importo < '500.000' THEN 'Versamento Successivo MultiPAC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 3 THEN 'Versamento Successivo PIC'

		WHEN T_OperazioneAzimut.CodTipoOperazioneAzimut = 2 THEN 'Versamento Iniziale PIC'

	END TipoOperazione

FROM IncarichiAssegno
JOIN T_OperazioneAzimut
	ON IncarichiAssegno.IdIncarico = T_OperazioneAzimut.IdIncarico
	AND T_OperazioneAzimut.FlagAttivo = 1
GROUP BY	IncarichiAssegno.IdIncarico,
			T_OperazioneAzimut.CodTipoOperazioneAzimut,
			Importo),

Vista
AS (SELECT DISTINCT

	ISNULL(tpi.IdPagamento, 0) IdAssegno,
	ISNULL(tpi.NumeroAssegno, 0) NumeroAssegno,
	ISNULL(tpi.Importo, 0) ImportoAssegno,
	ISNULL(tpi.ChiaveClienteOrdinante, Ordinante.ChiaveCliente) ChiaveClienteOrdinante,
	ISNULL(tpi.ChiaveClienteOrdinanteCF, IIF(Ordinante.ChiaveCliente = Ordinante.CodiceFiscale,1,0)) IsChiaveOrdinanteCF,
	IncarichiAssegno.DataCreazione,
	IncarichiAssegno.IdIncarico,
	IncarichiAssegno.CodTipoIncarico,
	IncarichiAssegno.CodStatoWorkflowIncarico,
	WFIncarico.StatoWorkflowIncarico,
	Rego.DataTransizione DataRegolamentoSospeso,
	Acquisita.DataTransizione DataUltimaTransizione,
	IdPersonaCliente,
	ChiaveClienteIntestatario,
	CASE
		WHEN Anagrafiche.CognomeIntestatario = '' OR
			Anagrafiche.NomeIntestatario = '' OR
			Anagrafiche.CognomeIntestatario IS NULL OR
			Anagrafiche.NomeIntestatario IS NULL THEN Anagrafiche.RagioneSocialeIntestatario
		ELSE Anagrafiche.CognomeIntestatario + SPACE(1) + Anagrafiche.NomeIntestatario
	END AS Intestatario,
	Anagrafiche.CodiceFiscaleIntestatario,
	'2' Funzione_MandatiMovimenti,
	'21' Funzione,

	CASE

		--PIC / MULTIPAC AZFUND 1
		WHEN CodTipoOperazione IN (1, 2, 5, 6) AND
			caifa.TipoProdotto = 'AZFUND 1' THEN '77'

		--PAC AZFUND 1
		WHEN CodTipoOperazione IN (3, 4) AND
			caifa.TipoProdotto = 'AZFUND 1' THEN '74'

		--PIC MULTIASSET
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'MULTIASSET' THEN '87'

		--PIC ITALIA
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'ITALIA' AND
			caifa.ID NOT IN (386, 387) THEN '17'

		--PAC ITALIA
		WHEN CodTipoOperazione IN (3, 4) AND
			caifa.TipoProdotto = 'ITALIA' AND
			caifa.ID NOT IN (386, 387) THEN '14'

		--FORMULA ITALIA
		WHEN caifa.ID IN (386, 387) THEN '17'

	END SPr,

	CASE
		--PIC AZFUND 1
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'AZFUND 1' AND
			caifa.Classe = 'LOAD' THEN '00B'
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'AZFUND 1' AND
			caifa.Classe = 'NO LOAD' THEN '00A'

		--PAC AZFUND 1
		WHEN CodTipoOperazione IN (3, 4) AND
			caifa.TipoProdotto = 'AZFUND 1' THEN caifa.CodiceFend + 'E'

		--MULTIPAC
		WHEN CodTipoOperazione IN (1, 2) THEN '00S'

		--MULTIASSET
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'MULTIASSET' AND
			caifa.Classe = 'LOAD' THEN '87B'
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'MULTIASSET' AND
			caifa.Classe = 'NO LOAD' THEN '87A'

		--PAC ITALIA
		WHEN CodTipoOperazione IN (3, 4) AND
			caifa.TipoProdotto = 'ITALIA' AND
			caifa.ID NOT IN (386, 387) THEN caifa.CodiceFend + 'E'

		--PIC ITALIA
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'ITALIA' AND
			caifa.ID NOT IN (386, 387) THEN '00B'

		--FORMULA ITALIA
		WHEN caifa.ID IN (386, 387) THEN '00F'

	END CPr,

	CASE

		--PREGRESSO PIC AZFUND 1
		WHEN CodTipoOperazione = 6 AND
			caifa.TipoProdotto = 'AZFUND 1' AND
			caifa.Classe = 'LOAD' THEN '01B'
		WHEN CodTipoOperazione = 6 AND
			caifa.TipoProdotto = 'AZFUND 1' AND
			caifa.Classe = 'NO LOAD' THEN '01A'

		--PREGRESSO PAC AZFUND 1
		WHEN CodTipoOperazione = 4 AND
			caifa.TipoProdotto = 'AZFUND 1' THEN caifa.CodiceFend + 'G'

		--PREGRESSO MULTIPAC
		WHEN CodTipoOperazione = 2 THEN '00F'

		--PREGRESSO MULTIASSET
		WHEN CodTipoOperazione = 6 AND
			caifa.TipoProdotto = 'MULTIASSET' THEN caifa.CodiceProdottoPregresso

		--PREGRESSO PAC ITALIA
		WHEN CodTipoOperazione = 4 AND
			caifa.TipoProdotto = 'ITALIA' AND
			caifa.ID NOT IN (386, 387) THEN caifa.CodiceFend + 'G'

		--PIC ITALIA SECONDO TENTATIVO
		WHEN CodTipoOperazione IN (5, 6) AND
			caifa.TipoProdotto = 'ITALIA' AND
			caifa.ID NOT IN (386, 387) THEN '00A'

	END CPr1,

	CASE

		--PREGRESSO MULTIPAC
		WHEN CodTipoOperazione = 2 AND
			caifa.TipoProdotto = 'AZFUND 1' THEN '01S'

		--PREGRESSO MULTIASSET
		WHEN CodTipoOperazione = 6 AND
			caifa.TipoProdotto = 'MULTIASSET' THEN caifa.CodiceProdottoPregresso1

	END CPr2,

	CASE

		--PREGRESSO MULTIPAC
		WHEN CodTipoOperazione = 2 AND
			caifa.TipoProdotto = 'AZFUND 1' THEN '01F'

	END CPr3,

	T_Mandato.NumeroMandato,
	IIF(ISNULL(DataSottoscrizione, 0) = 0, NULL, REPLACE(CONVERT(VARCHAR, CONVERT(DATE, T_Mandato.DataSottoscrizione, 101), 103), '/', ' ')) DataSottoscrizione,
	LEFT(D_ProvenienzaDenaro.Descrizione, 3) ProvenienzaDenaro,

	/* DOVESSERO PARTIRE I PAC MULTIASSET OCCHIO AGLI SCONTI!! */

	CASE 
		WHEN TranscodificaSconti.ScontoFEND IS NOT NULL THEN
		CASE WHEN (CodTipoOperazione IN (1, 3) OR
			caifa.TipoProdotto = 'MULTIASSET') AND
			TranscodificaSconti.ScontoFEND = '1' THEN '7'
			WHEN (CodTipoOperazione IN (1, 3) OR
			caifa.TipoProdotto = 'MULTIASSET') AND
			TranscodificaSconti.ScontoFEND = '2' THEN '5'
			WHEN (CodTipoOperazione IN (1, 3) OR
			caifa.TipoProdotto = 'MULTIASSET') AND
			TranscodificaSconti.ScontoFEND = 'G' THEN 'F'
			ELSE TranscodificaSconti.ScontoFEND END
		ELSE Z_Cliente_RiduzioneScontoCommissionale.CodiceRiduzioneScontoCommissionale
	END ScontisticaFEND,
	CAST(T_OperazioneAzimut.Importo AS MONEY) Importo,
	ISNULL(tpi.Ordinante,
	CASE
		WHEN Ordinante.Cognome = '' OR
			Ordinante.Nome = '' OR
			Ordinante.Cognome IS NULL OR
			Ordinante.Nome IS NULL THEN Ordinante.RagioneSociale
		ELSE Ordinante.Cognome + SPACE(1) + Ordinante.Nome
	END) AS Ordinante,
	'N' Sospensione,
	CodTipoOperazione,
	TipoOperazioneAzimut.TipoOperazione,
	IdOperazioneAzimut,
	E_ProdottoAzimut.Isin,
	caifa.TipoProdotto,
	caifa.DenominazioneFend NomeFondo,
	caifa.CodiceFend CodiceFondo,
	Esecutore.ChiaveCliente ChiaveClienteEsecutore,
	CASE
		WHEN Esecutore.Cognome = '' OR
			Esecutore.Nome = '' OR
			Esecutore.Cognome IS NULL OR
			Esecutore.Nome IS NULL THEN Esecutore.RagioneSociale
		ELSE Esecutore.Cognome + SPACE(1) + Esecutore.Nome
	END AS Esecutore,
	IIF(Esecutore.ChiaveCliente = Esecutore.CodiceFiscale, 1, 0) IsChiaveEsecutoreCF,
	ISNULL(SubMaster.IsMasterSospeso, 0) IsMasterSospeso,
	SubMaster.DataTransizione DataRegoMaster,
	ISNULL(dbo.T_DatiAggiuntiviIncaricoAzimut.NumeroRaccomandazione, ISNULL(dbo.T_Mandato.NumeroSimula, MetaSimula.CodiceSimula)) AS NRacc_NSimula,
	tpi.IsAssegnoEstero


FROM IncarichiAssegno

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico WFIncarico
	ON IncarichiAssegno.IdIncarico = WFIncarico.IdIncarico

LEFT JOIN Anagrafiche
	ON IncarichiAssegno.IdIncarico = Anagrafiche.IdIncarico
	AND ProgressivoPersona = 1

LEFT JOIN (SELECT
	IncarichiAssegno.IdIncarico,
	dbo.T_PagamentoInvestimento.IdPagamento,
	dbo.T_PagamentoInvestimento.NumeroAssegno,
	dbo.T_PagamentoInvestimento.Importo,
	Ordinante.ChiaveCliente ChiaveClienteOrdinante,
	CASE
		WHEN Ordinante.Cognome = '' OR
			Ordinante.Nome = '' OR
			Ordinante.Cognome IS NULL OR
			Ordinante.Nome IS NULL THEN Ordinante.RagioneSociale
		ELSE Ordinante.Cognome + SPACE(1) + Ordinante.Nome
	END AS Ordinante,
	IIF(Ordinante.ChiaveCliente = Ordinante.CodiceFiscale, 1, 0) ChiaveClienteOrdinanteCF,
	IIF(dbo.T_PagamentoInvestimento.CodTipoAssegno = 5,1,0) IsAssegnoEstero
FROM IncarichiAssegno
JOIN dbo.T_PagamentoInvestimento
	ON IncarichiAssegno.IdIncarico = dbo.T_PagamentoInvestimento.IdIncarico
	AND dbo.T_PagamentoInvestimento.CodModalitaPagamento = 19
	AND dbo.T_PagamentoInvestimento.FlagAttivo = 1
LEFT JOIN dbo.T_Persona Ordinante
	ON dbo.T_PagamentoInvestimento.IdPersonaOrdinante = Ordinante.IdPersona) tpi ON IncarichiAssegno.IdIncarico = tpi.IdIncarico

LEFT JOIN T_R_Incarico_Mandato
	ON IncarichiAssegno.IdIncarico = T_R_Incarico_Mandato.IdIncarico
	AND Progressivo = 1 --Primo Mandato

LEFT JOIN T_Mandato
	ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato

LEFT JOIN T_DatiAggiuntiviIncaricoAzimut
	ON IncarichiAssegno.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico

LEFT JOIN T_DatoAggiuntivo
	ON IncarichiAssegno.IdIncarico = T_DatoAggiuntivo.IdIncarico
	AND T_DatoAggiuntivo.CodTipoDatoAggiuntivo = 1371 --Codice Sconto Documentazione
	AND T_DatoAggiuntivo.FlagAttivo = 1

LEFT JOIN scratch.CESAM_AZ_TranscodificaSconti_QTask_FEND TranscodificaSconti
	ON TranscodificaSconti.ScontoQTask = T_DatoAggiuntivo.Testo

LEFT JOIN dbo.Z_Cliente_RiduzioneScontoCommissionale
	ON dbo.T_Mandato.CodRiduzioneScontoCommissionale = dbo.Z_Cliente_RiduzioneScontoCommissionale.CodRiduzioneScontoCommissionale

LEFT JOIN D_ProvenienzaDenaro
	ON D_ProvenienzaDenaro.Codice = T_DatiAggiuntiviIncaricoAzimut.CodProvenienzaDenaro

LEFT JOIN (SELECT
	TipoOperazioneAzimut.IdIncarico,
	CASE
		WHEN TipoOperazioneAzimut.CodTipoOperazione = 3 AND
			IdRobot.ID IS NOT NULL THEN 5
		WHEN TipoOperazioneAzimut.CodTipoOperazione = 4 AND
			IdRobot.ID IS NOT NULL THEN 6
		WHEN TipoOperazioneAzimut.CodTipoOperazione = 5 AND
			IdRobot.ContaOperazioni = 1 AND
			IdRobot.ID IS NOT NULL THEN 3
		WHEN TipoOperazioneAzimut.CodTipoOperazione = 6 AND
			IdRobot.ContaOperazioni = 1 AND
			IdRobot.ID IS NOT NULL THEN 4
		WHEN TipoOperazioneAzimut.CodTipoOperazione = 5 AND
			IdRobot.ContaOperazioni > 1 AND
			IdRobot.ID IS NOT NULL THEN 1
		WHEN TipoOperazioneAzimut.CodTipoOperazione = 6 AND
			IdRobot.ContaOperazioni > 1 AND
			IdRobot.ID IS NOT NULL THEN 2
		ELSE TipoOperazioneAzimut.CodTipoOperazione
	END CodTipoOperazione,
	CASE
		WHEN TipoOperazioneAzimut.TipoOperazione = 'Versamento Iniziale PAC' AND
			IdRobot.ID IS NOT NULL THEN 'Versamento Iniziale PIC'
		WHEN TipoOperazioneAzimut.TipoOperazione = 'Versamento Successivo PAC' AND
			IdRobot.ID IS NOT NULL THEN 'Versamento Successivo PIC'
		WHEN TipoOperazioneAzimut.TipoOperazione = 'Versamento Iniziale PIC' AND
			IdRobot.ContaOperazioni = 1 AND
			IdRobot.ID IS NOT NULL THEN 'Versamento Iniziale PAC'
		WHEN TipoOperazioneAzimut.TipoOperazione = 'Versamento Successivo PIC' AND
			IdRobot.ContaOperazioni = 1 AND
			IdRobot.ID IS NOT NULL THEN 'Versamento Successivo PAC'
		WHEN TipoOperazioneAzimut.TipoOperazione = 'Versamento Iniziale PIC' AND
			IdRobot.ContaOperazioni > 1 AND
			IdRobot.ID IS NOT NULL THEN 'Versamento Iniziale MultiPAC'
		WHEN TipoOperazioneAzimut.TipoOperazione = 'Versamento Successivo PIC' AND
			IdRobot.ContaOperazioni > 1 AND
			IdRobot.ID IS NOT NULL THEN 'Versamento Successivo MultiPAC'
		ELSE TipoOperazioneAzimut.TipoOperazione
	END TipoOperazione
FROM TipoOperazioneAzimut
LEFT JOIN (SELECT
	tafocr.IdIncarico ID,
	COUNT(DISTINCT tafocr.IdOperazioneAzimut) ContaOperazioni
FROM rpa.T_Azimut_Fend_OperazioniCaricamentoRobot tafocr
WHERE tafocr.DettaglioEsitoLavorazione = '0774: MANDATO INESISTENTE'
GROUP BY tafocr.IdIncarico) IdRobot
	ON TipoOperazioneAzimut.IdIncarico = IdRobot.ID) TipoOperazioneAzimut
	ON IncarichiAssegno.IdIncarico = TipoOperazioneAzimut.IdIncarico

LEFT JOIN T_OperazioneAzimut
	ON TipoOperazioneAzimut.IdIncarico = T_OperazioneAzimut.IdIncarico

LEFT JOIN E_ProdottoAzimut
	ON T_OperazioneAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut

LEFT JOIN T_Persona Ordinante
	ON T_DatiAggiuntiviIncaricoAzimut.IdPersonaOrdinante = Ordinante.IdPersona

LEFT JOIN T_Persona Esecutore
	ON T_DatiAggiuntiviIncaricoAzimut.IdPersonaEsecutore = Esecutore.IdPersona

LEFT JOIN scratch.CESAM_AZ_Import_FondiAzimut caifa
	ON E_ProdottoAzimut.Isin = caifa.Isin

LEFT JOIN (SELECT
	lwi.IdIncarico,
	MAX(lwi.DataTransizione) DataTransizione
FROM L_WorkflowIncarico lwi
WHERE (lwi.CodStatoWorkflowIncaricoDestinazione = 6560
AND lwi.CodStatoWorkflowIncaricoPartenza != 6560)
OR (lwi.CodStatoWorkflowIncaricoDestinazione = 15524
AND lwi.CodStatoWorkflowIncaricoPartenza != 15524)
GROUP BY lwi.IdIncarico) Rego
	ON IncarichiAssegno.IdIncarico = Rego.IdIncarico

LEFT JOIN (SELECT
	lwi.IdIncarico,
	MAX(lwi.DataTransizione) DataTransizione
FROM L_WorkflowIncarico lwi
WHERE (lwi.CodStatoWorkflowIncaricoDestinazione = 8570
AND lwi.CodStatoWorkflowIncaricoPartenza != 8570)
OR (lwi.CodStatoWorkflowIncaricoDestinazione = 6604
AND lwi.CodStatoWorkflowIncaricoPartenza != 6604)
GROUP BY lwi.IdIncarico) Acquisita
	ON IncarichiAssegno.IdIncarico = Acquisita.IdIncarico

/*LS 01/07/2019 GESTIONE DEI SUBINCARICHI SOSPESI*/
LEFT JOIN (SELECT
	IdSubIncarico,
	T_R_Incarico_SubIncarico.IdIncarico,
	1 AS IsMasterSospeso,
	MAX(DataTransizione) DataTransizione
FROM T_R_Incarico_SubIncarico
JOIN T_Incarico
	ON T_R_Incarico_SubIncarico.IdIncarico = T_Incarico.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico
	ON T_Incarico.IdIncarico = rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico.IdIncarico
LEFT JOIN L_WorkflowIncarico
	ON T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow
	ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
	AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
	AND CodStatoWorkflowIncaricoDestinazione = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
WHERE CodMacroStatoWorkflowIncarico = 2
OR CodMacroStatoWFIncarico = 2
GROUP BY	IdSubIncarico,
			T_R_Incarico_SubIncarico.IdIncarico) SubMaster
	ON IncarichiAssegno.IdIncarico = SubMaster.IdSubIncarico

LEFT JOIN rs.v_CESAM_AZ_Metadati_ImportSimula AS MetaSimula
	ON IncarichiAssegno.IdIncarico = MetaSimula.IdIncarico)

SELECT
	CASE
		WHEN
			DataRegolamentoSospeso IS NULL AND
			((ChiaveClienteOrdinante IS NULL OR
			ChiaveClienteOrdinante LIKE 'P%' OR
			Vista.ChiaveClienteOrdinante LIKE 'PDOB%' OR
			IsChiaveOrdinanteCF = 1) OR
			SPr IS NULL OR
			CPr IS NULL OR
			(NumeroMandato IS NULL OR
			NumeroMandato LIKE 'PROV%') OR
			DataSottoscrizione IS NULL OR
			ProvenienzaDenaro IS NULL OR
			ScontisticaFEND IS NULL OR
			Importo IS NULL OR
			CodTipoOperazione IS NULL OR
			CodiceFondo IS NULL OR
			(ChiaveClienteEsecutore IS NULL OR
			ChiaveClienteEsecutore LIKE 'P%' OR
			Vista.ChiaveClienteEsecutore LIKE 'PDOB%' OR
			IsChiaveEsecutoreCF = 1) OR
			Vista.IsAssegnoEstero = 1) THEN 0
		ELSE 1
	END IsLavorabile,
	IsMasterSospeso,
	IdAssegno,
	NumeroAssegno,
	ImportoAssegno,
	ChiaveClienteOrdinante,
	DataCreazione,
	IdIncarico,
	CodTipoIncarico,
	CodStatoWorkflowIncarico,
	StatoWorkflowIncarico,
	DataRegolamentoSospeso,
	DataUltimaTransizione,
	IdPersonaCliente,
	ChiaveClienteIntestatario,
	Intestatario,
	CodiceFiscaleIntestatario,
	Funzione_MandatiMovimenti,
	Funzione,
	SPr,
	CPr,
	CPr1,
	CPr2,
	CPr3,
	NumeroMandato,
	DataSottoscrizione,
	ProvenienzaDenaro,
	ScontisticaFEND,
	Importo,
	Ordinante,
	Sospensione,
	ISNULL(CodTipoOperazione, 0) CodTipoOperazione,
	ISNULL(TipoOperazione, 'Operazione non presente') TipoOperazione,
	IdOperazioneAzimut,
	Isin,
	TipoProdotto,
	NomeFondo,
	CodiceFondo,
	ChiaveClienteEsecutore,
	Esecutore,
	NRacc_NSimula,
	Vista.IsAssegnoEstero

FROM Vista

GO