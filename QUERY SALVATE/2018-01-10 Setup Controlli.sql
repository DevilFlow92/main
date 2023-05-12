use CLC 

SELECT * FROM D_TabellaSetup 
WHERE Codice IN (
SELECT CodTabellaSetup 
FROM R_GruppoTabelleSetup_TabellaSetup
WHERE CodGruppoTabelleSetup=35) --Controlli



SELECT * FROM D_TipoIncarico where Descrizione LIKE 'Sottoscrizioni AFB'
--321	Sottoscrizioni AFB



--PREPRODUZIONE

USE CLC
INSERT INTO [dbo].[S_MacroControllo] ([CodCliente]
, [CodTipoIncarico]
, [NomeStoredProcedure]
, [Descrizione]
, [TestoHelp]
, [FlagGenerazioneDifferita]
, [Ordinamento])
	VALUES (23, --Azimut
	321, --Sottoscrizioni AFB
	'MacroControlloAlwaysValid', 'Controllo Presa Informativa Preliminare', 'Controllo Presa Informativa Preliminare', 0, 1)


SELECT top 1 * FROM S_MacroControllo order BY IdMacroControllo DESC
--idmacrocontrollo 646

--ok

INSERT INTO [dbo].[S_Controllo]
           ([CodDatoAssociabile]
           ,[IdTipoMacroControllo]
           ,[NomeStoredProcedure]
           ,[FlagEsitoNonDefinito]
           ,[FlagEsitoPositivo]
           ,[FlagEsitoPositivoConRiserva]
           ,[FlagEsitoNegativo]
           ,[FlagNotaObbligatoria]
           ,[Descrizione]
           ,[TestoHelp]
           ,[CodEsitoControlloDefault]
           ,[NomeStoredProcedurePreparatoria]
           ,[Ordinamento]
           ,[CodTipoRilievoControlloDefault]
           ,[FlagSolaLettura])
     VALUES 
	 (NULL,
	  646, --idtipomacrocontrollo generato con insert nella S_MacroControllo
	  'CESAM_AZ_AFB_Documento_InformativaPreliminare_Recente',
	  1,
	  1,
	  0,
	  1,
	  0, 
	  'Presa Visione Informativa Preliminare', 
	  'Controllo Presenza Modulo Presa Informativa Preliminare',
	  NULL,
	  NULL,
	  1,
	  NULL,
	  0)

--ok


SELECT * from S_Controllo where IdTipoMacroControllo = 646
--id controllo 2200
 
 --ok

INSERT INTO [dbo].[R_Transizione_MacroControllo] ([CodCliente]
, [CodTipoIncarico]
, [CodStatoWorkflowIncaricoPartenza]
, [CodAttributoIncaricoPartenza]
, [FlagUrgentePartenza]
, [FlagAttesaPartenza]
, [CodStatoWorkflowIncaricoDestinazione]
, [CodAttributoIncaricoDestinazione]
, [FlagUrgenteDestinazione]
, [FlagAttesaDestinazione]
, [IdTipoMacroControllo]
, [FlagCreazione])
	VALUES (23, 321, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 646, 1)


--ok


--verifica
use CLC
select * FROM R_Transizione_MacroControllo where IdTipoMacroControllo = 646



--trasferisci in produzione
SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'S_Controllo'

--gruppo di tabelle: controlli


SELECT * FROM D_MacroStatoWorkflowIncarico where Descrizione LIKE '%in gest%'
--9	In Gestione

SELECT * FROM R_Cliente_TipoIncarico_MacroStatoWorkFlow
where CodTipoIncarico = 321 AND CodMacroStatoWorkflowIncarico = 9

SELECT * FROM D_StatoWorkflowIncarico where Codice IN (
8520
,8570
,8580
,6603
,6604
,6605
,14336
,14337
,14370
)


insert INTO R_EsitoControllo_BloccoTransizione (CodCliente, CodTipoIncarico , CodStatoWorkflowIncaricoPartenza , CodStatoWorkflowIncaricoDestinazione , CodGiudizioControllo, IdControllo, FlagAbilitaBlocco)

values (23,321,null,8520,4,2200,1)	--Da Acquisire
	,(23,321,null,8570,4,2200,1)	--Acquisita
	,(23,321,null,8580,4,2200,1)	--Verifica Conformità
	,(23,321,null,6603,4,2200,1)	--Pronta per caricamento FEND
	,(23,321,null,6604,4,2200,1)	--In Attesa Versamento Assegno
	,(23,321,null,6605,4,2200,1)	--In Attesa Ricezione Bonifico
	,(23,321,null,14336,4,2200,1)	--In Attesa di Bonifico MAX FUNDS
	,(23,321,null,14337,4,2200,1)	--Bonifico MAX FUNDS Richiesto
	,(23,321,null,14370,4,2200,1)	--Assegno Versato
		

SELECT * FROM R_EsitoControllo_BloccoTransizione 

where CodCliente = 23 AND CodTipoIncarico = 321 and CodStatoWorkflowIncaricoDestinazione = 6605




