USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_NuoviIncarichiConDocumentoInserito
--AS

--/*
--	Author: G. Piga
--	Date: 05/03/2015
--	Description: utilizzata nel Report:
--	- AZ - Incarichi pronti per Data Entry
--	- AZ - Monitoring incarichi in attesa per Data Entry
--*/

WITH prova AS (SELECT
	T_Incarico.IdIncarico,
	T_Incarico.CodTipoIncarico,
	T_Incarico.CodAttributoIncarico,
	D_TipoIncarico.Descrizione AS [Tipo Incarico],
	CASE
		WHEN Documento_id IS NULL THEN 0
		ELSE 1
	END AS FlagPresenzaDocumento,
	CASE
		WHEN Documento_id IS NULL THEN 'NO'
		ELSE 'SI'
	END AS PresenzaDocumento,
	FlagAttesa,
	CASE
		WHEN FlagAttesa = 0 THEN 'NO'
		WHEN FlagAttesa = 1 THEN 'SI'
	END AS Attesa
	--, T_Documento.DataInserimento
	,
	CAST(CAST(T_Documento.DataInserimento AS VARCHAR(20)) AS DATETIME) DataInserimento,
	T_Incarico.DataCreazione,
	T_Incarico.DataUltimaTransizione,
	T_Incarico.DataUltimaModifica,
	S_Operatore.CodSede AS SedeOperatore,
	Generica.DataInserimento AS DataInserimentoNOTA,
	ISNULL(Generica.Testo, '') AS NotaGenerica,
	ISNULL(OpGen.Etichetta, '') AS Operatore,
	S_Data.ChiaveData AS ChiaveDataInseriemntoDocumento,
	S_Ora.EtichettaMezzora AS OraInserimentoDocumento

	--, REPLACE (REPLACE((ISNULL((OpGen.Etichetta + ' / '  +Generica.Testo)   ,'Nota non Inserita')),CHAR(10),'') ,CHAR(13),'') AS NotaGenerica

	--------------------------------------------------------------------------------
	,
	CASE
		WHEN T_Documento.FlagFax = 1	-- Fax 
			AND CodTipoIncarico = 84	-- Switch FONDI Investimento
		THEN '1'
	END AS codTipoSwitch,
	CASE
		WHEN T_Documento.FlagFax = 1	-- Fax 
			AND CodTipoIncarico = 84	-- Switch FONDI Investimento
		THEN 'SI'
	END AS TipoSwitch,
	CASE
		WHEN T_Documento.FlagFax = 1	-- Fax 
			AND CodTipoIncarico = 84	-- Switch FONDI Investimento
		THEN T_Documento.DataRicezione
	END AS DataRicezioneFAX,

	--------------------------------------------------------------------------------
	GestoreIncarico.IdOperatore,
	GestoreIncarico.Etichetta,
	CASE
		WHEN dbo.T_R_Incarico_Persona.IdPersona IS NULL THEN 0
		ELSE 1
	END AS Censito,
	CodStatoWorkflowIncarico wf





FROM T_Incarico WITH (NOLOCK)


LEFT JOIN T_Documento WITH (NOLOCK)
	ON T_Documento.IdIncarico = T_Incarico.IdIncarico

INNER JOIN D_TipoIncarico WITH (NOLOCK)
	ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico
LEFT JOIN L_WorkflowIncarico WITH (NOLOCK)
	ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
	AND (CodStatoWorkflowIncaricoPartenza IS NULL
	AND CodStatoWorkflowIncaricoDestinazione = 6500) -- Nuova Creata

LEFT JOIN S_Operatore WITH (NOLOCK)
	ON L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore
	AND S_Operatore.CodSede = 3 -- MI

LEFT JOIN T_R_Incarico_Persona WITH (NOLOCK)
	ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico
	AND T_R_Incarico_Persona.Progressivo = 1

LEFT JOIN T_R_Incarico_Mandato WITH (NOLOCK)
	ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico

LEFT JOIN T_R_Incarico_Nota WITH (NOLOCK)
	ON T_Incarico.IdIncarico = T_R_Incarico_Nota.IdIncarico
LEFT JOIN T_NotaIncarichi AS Generica WITH (NOLOCK)
	ON T_R_Incarico_Nota.IdNota = Generica.IdNotaIncarichi
	AND Generica.CodTipoNotaIncarichi = 22 -- Generica
LEFT JOIN S_Operatore AS OpGen WITH (NOLOCK)
	ON OpGen.IdOperatore = Generica.IdOperatore
LEFT JOIN S_Data
	ON CONVERT(CHAR(8), T_Documento.DataInserimento, 112) = S_Data.ChiaveData
LEFT JOIN S_Ora
	ON CONVERT(CHAR(5), T_Documento.DataInserimento, 108) = S_Ora.ChiaveOra
LEFT JOIN T_R_Incarico_Operatore
	ON T_Incarico.IdIncarico = T_R_Incarico_Operatore.IdIncarico
LEFT JOIN S_Operatore AS GestoreIncarico
	ON T_R_Incarico_Operatore.IdOperatore = GestoreIncarico.IdOperatore


WHERE (T_Incarico.CodCliente = 23						-- AZIMUT
AND T_Incarico.CodArea = 8								-- Gestione SIM
AND (T_Incarico.CodTipoWorkflow IN (

78				-- fatca 
, 54				-- Successioni
, 79				-- Gestione schede anagrafiche BP
, 53				-- Workflow Finanziamenti e Affidamenti
, 2344				-- variazione anagrafica
--, 2384				--Workflow Switch FONDI Investimento
, 23197                 --- workflow finanziamenti new
, 23159				--Switch [FAX] anticipati via fax – Fondi Azimut
, 23160				--Switch [ORIG] anticipati via fax – Fondi Azimut
, 2393
, 23288 --workflow incarico cliente da censire
, 23296 --private
, 23161 --conti ubs
, 23253 --ADV
, 2323 --generico azimut
--,23306 --AFB
, 2390					--Posta Disguidata Asset Management		LF 11/06/2018
, 23173 --WF Disinvestimenti Previdenza		LS 08/01/2019
)

OR CodTipoIncarico IN (463 --Private Debt - Sottoscrizioni		LF 06/07/2018
)
OR (

T_Incarico.CodTipoWorkflow = 2384
AND CodTipoIncarico <> 84				-- Cesam Operazione Generica (escludo switch fondi investimento)

)
OR (

T_Incarico.CodTipoWorkflow = 2384
AND CodTipoIncarico = 84
AND Tipo_Documento IN (5958,
10050,
10051,
3363) -- includo switch fondi investimento solo se ci sono sottoscrizioni
)
)
AND S_Operatore.CodSede = 3
AND (T_Incarico.CodStatoWorkflowIncarico NOT IN (440)
OR (FlagAttesa = 1
AND T_Incarico.CodStatoWorkflowIncarico = 6500))

AND (
--	T_R_Incarico_Persona.IdIncarico IS NULL
--and  
T_R_Incarico_Mandato.IdIncarico IS NULL
)
))

SELECT DISTINCT
	IdIncarico,
	CodTipoIncarico,
	CodAttributoIncarico,
	[Tipo Incarico],
	FlagPresenzaDocumento,
	PresenzaDocumento,
	FlagAttesa,
	Attesa,
	DataInserimento,
	DataCreazione,
	DataUltimaTransizione,
	DataUltimaModifica,
	SedeOperatore,
	DataInserimentoNOTA,
	NotaGenerica,
	Operatore,
	ChiaveDataInseriemntoDocumento,
	OraInserimentoDocumento,
	codTipoSwitch,
	TipoSwitch,
	DataRicezioneFAX,
	IdOperatore,
	Etichetta,
	Censito,
	wf
FROM prova
--WHERE DataCreazione >= '20180701'
--AND CodTipoIncarico IN (405,463)

GO