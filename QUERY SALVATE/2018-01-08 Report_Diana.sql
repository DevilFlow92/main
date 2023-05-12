USE [CLC]

/*
**** INCARICHI
93	MIFID - Schede Finanziarie
159	Switch [FAX] anticipati via fax – Fondi Azimut
55	Anagrafiche Antiriciclaggio
253	Bonifica Anagrafica - ADV in scadenza
44	Variazione Anagrafica

--modifiche su richiesta di diana il 05/01/2018
91	MIFID - Contratti consulenza/collocamento
288	Censimento Cliente
160	Switch [ORIG] anticipati via fax/pec – Fondi Az

**** WORKFLOW
--8500 Da Verificare

*/

SELECT
	T_Incarico.IdIncarico
   ,CodTipoIncarico
   ,CodStatoWorkflowIncarico
   ,CodStato StatoSospeso
   ,DataCreazione
   ,DataUltimaTransizione
   ,D_StatoWorkflowIncarico.Descrizione StatoWFAttuale
   ,D_TipoIncarico.Descrizione DTipoIncarico
   ,D_StatoSospeso.Descrizione DStatoSospeso
FROM T_Incarico
JOIN T_Sospeso
	ON T_Incarico.IdIncarico = T_Sospeso.IdIncarico
LEFT JOIN D_StatoWorkflowIncarico
	ON D_StatoWorkflowIncarico.Codice = CodStatoWorkflowIncarico
LEFT JOIN D_TipoIncarico
	ON D_TipoIncarico.Codice = CodTipoIncarico
LEFT JOIN D_StatoSospeso
	ON CodStato = D_StatoSospeso.Codice
LEFT JOIN (SELECT
		T_Incarico.IdIncarico
	   ,CodStatoWorkflowIncaricoDestinazione
	FROM L_WorkflowIncarico
	JOIN T_Incarico
		ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
		AND CodTipoIncarico IN (93
		, 159
		, 55
		, 253
		, 44
		, 91	   --LF su richiesta sopra
		, 288	   --|
		, 160) 	   --|
		AND CodArea = 8
		AND CodCliente = 23

	WHERE CodStatoWorkflowIncaricoDestinazione = 8500 --da verificare
	GROUP BY T_Incarico.IdIncarico
			,CodStatoWorkflowIncaricoDestinazione) WFSospesa
	ON WFSospesa.IdIncarico = T_Incarico.IdIncarico

WHERE CodTipoIncarico IN (93
, 159
, 55
, 253
, 44
, 91   	   --LF su richiesta sopra
, 288  	   --|
, 160)     --|
AND CodArea = 8
AND CodCliente = 23
AND WFSospesa.IdIncarico IS NULL

/*
--FOGLIO 1 -- 
Deve estrare gli incarichi che sono stati transitati nello stato “Sospesa – da verificare”,
ma non hanno il tab “Sospeso” compilato. 

Modifiche su richiesta di diana il 05/01/2018
Che abbia anche i seguenti tipi incarico:
	91	MIFID - Contratti consulenza/collocamento
	288	Censimento Cliente
	160	Switch [ORIG] anticipati via fax/pec – Fondi Az

*/


SELECT DISTINCT
	T_Incarico.IdIncarico
   ,T_Incarico.CodTipoIncarico
   ,D_TipoIncarico.Descrizione [Tipo Incarico]
   ,T_Incarico.DataCreazione
   ,T_Incarico.DataUltimaTransizione
   ,T_Incarico.CodStatoWorkflowIncarico
   ,D_StatoWorkflowIncarico.Descrizione
   ,T_Sospeso.CodStato

FROM T_Incarico
JOIN D_TipoIncarico
	ON D_TipoIncarico.codice = T_Incarico.CodTipoIncarico
LEFT JOIN T_Sospeso
	ON t_sospeso.IdIncarico = T_Incarico.IdIncarico
JOIN D_StatoWorkflowIncarico
	ON D_StatoWorkflowIncarico.Codice = T_Incarico.CodStatoWorkflowIncarico

JOIN (SELECT
		IdIncarico
	FROM L_WorkflowIncarico
	WHERE CodStatoWorkflowIncaricoDestinazione = 8500) WF
	ON WF.idincarico = T_incarico.IdIncarico

WHERE codcliente = 23
AND CodTipoIncarico IN (44, 55, 93, 159, 253, 91, 288, 160) --LF su richiesta sopra
AND CodArea = 8
AND T_Sospeso.IdSospeso IS NULL

--order by DataCreazione


/*
--FOGLIO 2--
Deve estrare gli incarichi che si trovano nello stato WF “Sospesa da verificare” 
e per cui lo stato sospeso non è selezionato (null)

Modifiche su richiesta di diana il 05/01/2018

Che abbia anche i tipi incarico:
	91	MIFID - Contratti consulenza/collocamento
	288	Censimento Cliente
	160	Switch [ORIG] anticipati via fax/pec – Fondi Az

Il foglio stato sospeso null deve estrarre anche gli incarichi che hanno un sospeso parzialmente compilato
quindi che Manca almeno UNO DEI SEGUENTI:
	Tipo operazione
	Tipo prodotto
	Motivazione
	Sotto motivazione
	Modalità
 */

SELECT
	T_Incarico.IdIncarico
   ,T_Incarico.CodTipoIncarico
   ,D_TipoIncarico.Descrizione [Tipo Incarico]
   ,T_Incarico.DataCreazione
   ,T_Incarico.DataUltimaTransizione
   ,T_Incarico.CodStatoWorkflowIncarico
   ,D_StatoWorkflowIncarico.Descrizione
   ,T_Sospeso.CodStato
   ,D_StatoSospeso.Descrizione [Stato Sospeso]

FROM T_Incarico
JOIN D_TipoIncarico
	ON D_TipoIncarico.codice = T_Incarico.CodTipoIncarico

JOIN D_StatoWorkflowIncarico ON D_StatoWorkflowIncarico.Codice = T_Incarico.CodStatoWorkflowIncarico

JOIN T_Sospeso ON T_Sospeso.IdIncarico = T_Incarico.IdIncarico
left join T_R_Sospeso_MotivazioneSottoMotivazioneModalita t_sorg ON T_sospeso.IdSospeso = t_sorg.IdSospeso
left JOIN R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso sorg ON t_sorg.IdMotivazioneSottoMotivazioneModalita = sorg.IdRelazione
left JOIN D_MotivazioneSospeso ON D_MotivazioneSospeso.Codice = sorg.CodMotivazioneSospeso
left JOIN D_SottoMotivazioneSospeso ON D_SottoMotivazioneSospeso.Codice = sorg.CodSottoMotivazioneSospeso
left JOIN D_ModalitaSospeso ON D_ModalitaSospeso.Codice = sorg.CodModalitaSospeso

left join D_StatoSospeso on D_StatoSospeso.Codice = T_Sospeso.CodTipoSospeso

WHERE 
--CodArea = 8 AND
codcliente = 23
AND CodTipoIncarico IN
(44, --Variazione Anagrafica
55, --Anagrafiche Antiriciclaggio
93, --MIFID - Schede Finanziarie
159,--Switch [FAX-PEC] anticipati – Fondi Az
253,--Bonifica Anagrafica - ADV in scadenza

91,	--MIFID - Contratti consulenza/collocamento				 LF su richiesta sopra
288,--Censimento Cliente									|
160) --Switch [ORIG] anticipati via fax/pec – Fondi Az		|

AND T_Incarico.CodStatoWorkflowIncarico = 8500 --sospesa da verificare

AND (T_Sospeso.CodStato IS NULL OR 
		sorg.CodMotivazioneSospeso IS NULL OR sorg.CodSottoMotivazioneSospeso IS NULL OR sorg.CodModalitaSospeso IS NULL)

order by DataCreazione


/*
Estrae gli incarichi secondo i seguenti criteri:

o	Tutti gli incarichi che hanno l’ultima transizione “Sospesa – Da Verificare”;
o	Che le transizioni siano state effettuate dagli operatori di Arad;
o	Le tipologie di incarico sono diverse da:
		MIFID – Schede Finanziarie
		Switch [FAX] anticipati via fax –Fondi Azimut
		Anagrafiche Antiriciclaggio
		Bonifica Anagrafica – ADV in scadenza
		Variazione Anagrafica
		“MIFID - Contratti consulenza/collocamento”
		“Censimento Cliente”
		“Switch [ORIG] anticipati via fax/pec – Fondi Az”

*/

SELECT DISTINCT
	T_Incarico.IdIncarico
   ,T_Incarico.CodTipoIncarico
   ,D_TipoIncarico.Descrizione [Tipo Incarico]
   ,T_Incarico.DataCreazione
   ,T_Incarico.DataUltimaTransizione
   ,T_Incarico.CodStatoWorkflowIncarico
   ,macrostatoWF.Descrizione + ' - ' + statoWF.Descrizione as [Stato WF]
   ,S_Operatore.IdOperatore
   ,Cognome + ' ' + Nome as Operatore
   
FROM T_Incarico 
JOIN D_TipoIncarico	ON D_TipoIncarico.codice = T_Incarico.CodTipoIncarico

JOIN D_StatoWorkflowIncarico statoWF ON statoWF.Codice = T_Incarico.CodStatoWorkflowIncarico

LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow r_cli_inc_macroWF on statoWF.Codice = r_cli_inc_macroWF.CodStatoWorkflowIncarico
                    and T_Incarico.CodCliente = r_cli_inc_macroWF.CodCliente AND T_Incarico.CodTipoIncarico = r_cli_inc_macroWF.CodTipoIncarico
LEFT JOIN D_MacroStatoWorkflowIncarico macrostatoWF on CodMacroStatoWorkflowIncarico = macrostatoWF.Codice  --risalire alla descrizione del macrostatoWF



join L_workflowIncarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico and CodStatoWorkflowIncaricoDestinazione = 8500
join S_Operatore on L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore

WHERE 
CodArea = 8 and
T_Incarico.CodCliente = 23
and T_incarico.CodStatoWorkflowIncarico = 8500 --(sospesa) da verificare
AND CodProfiloAccesso IN (845,867)  --operatori di arad
and T_incarico.CodTipoIncarico NOT IN (44, 55, 93, 159, 253,91,288,160) --diversi da quelli indicati sopra

--and S_Operatore.IdOperatore = 12701 






