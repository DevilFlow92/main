USE clc
GO

/*


IF OBJECT_ID('tempdb..#tables') IS NOT NULL
	DROP TABLE #tables
CREATE TABLE #tables (
	idrelazione INT IDENTITY (1, 1) NOT NULL
	,Colonna VARCHAR(200)
	,tabella VARCHAR(200)
)


DECLARE	@tablename VARCHAR(200)
		,@columname VARCHAR(200)

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR SELECT
	c.name AS 'ColumnName'
	,t.name AS 'TableName'
FROM sys.columns c
JOIN sys.tables t
	ON c.object_id = t.object_id
WHERE c.name LIKE '%profiloaccesso%'
--AND (t.name NOT LIKE 't_%' OR t.name NOT LIKE 'l_%' )
AND t.schema_id = 1

ORDER BY TableName
, ColumnName;

OPEN cur

FETCH NEXT FROM cur INTO @columname, @tablename

WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC ('insert into #tables select distinct ' + @columname + ' ,''' + @tablename + '''as tabella from ' + @tablename + ' where ' + @columname + ' = 839')


	FETCH NEXT FROM cur INTO @columname, @tablename

END

CLOSE cur
DEALLOCATE cur



SELECT
	*
FROM #tables
*/

/*
R_ProfiloAccesso_Abilitazione
R_ProfiloAccesso_AbilitazioneIncarico
R_ProfiloAccesso_Ambiente_UrlAccesso
R_ProfiloAccesso_Area
R_ProfiloAccesso_Area_Espansione
R_ProfiloAccesso_BloccoDocumenti
R_ProfiloAccesso_CategoriaComunicazione
R_ProfiloAccesso_CategoriaNotaIncarichi
R_ProfiloAccesso_LimiteRigheRicerche
R_ProfiloAccesso_Privilegio
R_ProfiloAccesso_Privilegio_Espansione
R_ProfiloAccesso_PrivilegioEsterno
R_ProfiloAccesso_PrivilegioEsterno_Espansione
R_ProfiloAccesso_Report
R_ProfiloAccesso_StatoWorkflowIncarico
R_ProfiloAccesso_TemplateComunicazione
R_ProfiloAccesso_TipoDocumento
R_ProfiloAccesso_TipoNota
R_ProfiloAccesso_TipoNotaIncarichi
R_ProfiloAccesso_UrlSistemaCollegato
R_ProfiloAccesso_VisualizzazioneMailbox

*/

--DEPLOY Extranet3.0 - profili & Operatori - Privilegi !!


--INSERT into D_ProfiloAccesso (Codice, Descrizione, CodProfiloAccessoRiferimento, FlagEsterno)
--	VALUES (2279, 'Azimut ESTERNO ALI', null, 0);

USE CLC
GO

--INSERT INTO R_ProfiloAccesso_Abilitazione (CodProfiloAccesso, CodCliente, CodProduttore, FlagVisualizza)
SELECT 2279, CodCliente, CodProduttore, FlagVisualizza
 FROM R_ProfiloAccesso_Abilitazione
WHERE CodProfiloAccesso = 1137

--INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore)
SELECT  2279, CodCliente, D_TipoIncarico.Codice, CodStatoWorkflowIncarico, FlagAbilita, CodProduttore 
FROM R_ProfiloAccesso_AbilitazioneIncarico JOIN D_TipoIncarico on IdRelazione = 8455
WHERE CodProfiloAccesso = 1137
AND D_TipoIncarico.Codice IN (387,512)

--INSERT INTO R_ProfiloAccesso_Ambiente_UrlAccesso (CodProfiloAccesso, CodAmbiente, IdUrlAccesso)
SELECT 2279, CodAmbiente, IdUrlAccesso 
FROM R_ProfiloAccesso_Ambiente_UrlAccesso
WHERE CodProfiloAccesso = 1137

--INSERT INTO R_ProfiloAccesso_Area (CodProfiloAccesso, CodArea, FlagInserimento, FlagAbilita, FlagMultilivello, FlagAssegnamentoMultilivello)
SELECT 2279, CodArea, FlagInserimento, FlagAbilita, FlagMultilivello, FlagAssegnamentoMultilivello 
FROM R_ProfiloAccesso_Area
WHERE CodProfiloAccesso = 1137


--INSERT into R_ProfiloAccesso_Area_Espansione (IdRelazione, CodProfiloAccesso, CodArea, FlagInserimento, FlagMultilivello, FlagAssegnamentoMultilivello, FlagEspansione)
SELECT (SELECT MAX(IdRelazione) + 1 FROM R_ProfiloAccesso_Area_Espansione), 2279, CodArea, FlagInserimento, FlagMultilivello, FlagAssegnamentoMultilivello, FlagEspansione FROM R_ProfiloAccesso_Area_Espansione
WHERE CodProfiloAccesso = 1137



/*
--INSERT INTO R_ProfiloAccesso_BloccoDocumenti (CodDocumento, CodProfiloAccesso, FlagSblocco, CodCliente, CodTipoDocumentoAssociabileEstinzione)
SELECT CodDocumento, 2279, FlagSblocco, CodCliente, CodTipoDocumentoAssociabileEstinzione FROM R_ProfiloAccesso_BloccoDocumenti
WHERE CodProfiloAccesso = 1137
*/

--INSERT into R_ProfiloAccesso_CategoriaComunicazione (CodProfiloAccesso, CodCliente, CodTipoIncarico, CodCategoriaComunicazione, FlagVisualizza)
SELECT  2279, CodCliente, CodTipoIncarico, CodCategoriaComunicazione, 1 
FROM R_ProfiloAccesso_CategoriaComunicazione
WHERE CodProfiloAccesso = 1137

--INSERT INTO R_ProfiloAccesso_CategoriaNotaIncarichi (CodProfiloAccesso, CodCategoriaNotaIncarichi)
SELECT 2279, CodCategoriaNotaIncarichi FROM R_ProfiloAccesso_CategoriaNotaIncarichi
WHERE CodProfiloAccesso = 1137

--INSERT into R_ProfiloAccesso_LimiteRigheRicerche (CodProfiloAccesso, CodTipoRicerca, LimiteRighe)
SELECT 2279, CodTipoRicerca, LimiteRighe FROM R_ProfiloAccesso_LimiteRigheRicerche
WHERE CodProfiloAccesso = 1137



--INSERT into R_ProfiloAccesso_StatoWorkflowIncarico (CodProfiloAccesso, CodStatoWorkflowIncarico, CodTipoWorkflow, FlagAbilita)
SELECT 2279, null, NULL, FlagAbilita FROM R_ProfiloAccesso_StatoWorkflowIncarico
WHERE CodProfiloAccesso = 1137 and IdRelazione = 1470

--INSERT INTO R_ProfiloAccesso_TemplateComunicazione (CodProfiloAccesso, IdTemplateComunicazione, FlagAbilita)
SELECT 2279, IdTemplateComunicazione, FlagAbilita FROM R_ProfiloAccesso_TemplateComunicazione
WHERE CodProfiloAccesso = 1137


--INSERT INTO R_ProfiloAccesso_TipoDocumento (CodProfiloAccesso, CodTipoDocumento, Ordinamento, FlagAbilitaImbarco, FlagAbilitaVisualizzazione)
SELECT 2279, CodTipoDocumento, Ordinamento, FlagAbilitaImbarco, FlagAbilitaVisualizzazione FROM R_ProfiloAccesso_TipoDocumento
WHERE CodProfiloAccesso = 1137

--INSERT into R_ProfiloAccesso_TipoNota (CodTipoNota, CodProfiloAccesso, FlagInserimento, FlagVisualizzazione)
SELECT CodTipoNota, 2279, FlagInserimento, FlagVisualizzazione FROM R_ProfiloAccesso_TipoNota 
WHERE CodProfiloAccesso = 1137

--INSERT into R_ProfiloAccesso_TipoNotaIncarichi (CodProfiloAccesso, CodTipoNotaIncarichi)
SELECT 2279,CodTipoNotaIncarichi FROM R_ProfiloAccesso_TipoNotaIncarichi
WHERE CodProfiloAccesso = 1137


--INSERT INTO R_ProfiloAccesso_UrlSistemaCollegato (CodProfiloAccesso, CodSistema, CodAmbiente, IdUrlAccesso)
SELECT 2279, CodSistema, CodAmbiente, IdUrlAccesso FROM R_ProfiloAccesso_UrlSistemaCollegato
WHERE CodProfiloAccesso = 1137

--INSERT into R_ProfiloAccesso_VisualizzazioneMailbox (CodProfiloAccesso, CodProfiloAccessoVisualizzabile)
SELECT 2279, CodProfiloAccessoVisualizzabile FROM R_ProfiloAccesso_VisualizzazioneMailbox
WHERE CodProfiloAccesso = 1137


--INSERT INTO R_ProfiloAccesso_Privilegio (CodProfiloAccesso, CodPrivilegio, FlagDisabilita)
SELECT 2279, CodPrivilegio, FlagDisabilita FROM R_ProfiloAccesso_Privilegio
WHERE CodProfiloAccesso = 1137
--AND CodPrivilegio NOT IN ()

/*
--INSERT into R_ProfiloAccesso_Privilegio_Espansione (CodProfiloAccesso, CodPrivilegio)
SELECT 2279, CodPrivilegio 
FROM R_ProfiloAccesso_Privilegio_Espansione
WHERE CodProfiloAccesso = 1137
--AND CodPrivilegio NOT IN ()
*/

--INSERT INTO R_ProfiloAccesso_PrivilegioEsterno (CodProfiloAccesso, CodPrivilegioEsterno, FlagDisabilita)
SELECT 2279, CodPrivilegioEsterno, FlagDisabilita  
--,D_PrivilegioEsterno.Descrizione
FROM R_ProfiloAccesso_PrivilegioEsterno 
--JOIN D_PrivilegioEsterno ON Codice = CodPrivilegioEsterno
WHERE CodProfiloAccesso = 1137
--AND CodPrivilegioEsterno NOT IN ()

/*
--INSERT into R_ProfiloAccesso_PrivilegioEsterno_Espansione (CodProfiloAccesso, CodPrivilegioEsterno)
SELECT 2279,CodPrivilegioEsterno FROM R_ProfiloAccesso_PrivilegioEsterno
WHERE CodProfiloAccesso = 1137
--AND CodPrivilegioEsterno NOT IN ()

*/


SELECT * FROM R_ProfiloAccesso_TipoNotaIncarichi 
JOIN D_TipoNotaIncarichi ON Codice = CodTipoNotaIncarichi
where CodProfiloAccesso = 839


SELECT * FROM R_ProfiloAccesso_TipoNotaIncarichi
WHERE CodProfiloAccesso = 2279 AND CodTipoNotaIncarichi in (22,63)


SELECT * FROM R_Cliente_TipoIncarico_TipoNotaIncarichi
WHERE CodTipoIncarico IN (387,512)

SELECT * FROM D_Privilegio where Descrizione like '%note%'

/*
(
,408		--Visualizza note interne
,4		--Visualizzazione note
,8		--Inserimento note
,46		--Mostra nota amministrazione
,69		--Visualizza note pratica
,70		--Visualizza note per agente
,71		--Visualizza note per assicurazione
,72		--Visualizza note liquidazione
,73		--Visualizza note cliente
,74		--Visualizza note storiche
,75		--Visualizza note problematicità
,92		--Visualizza note su tutti i tab
,114		--Visualizza note segnalazione
,129		--Visualizza note amministrazione per delibera
,131		--Modifica note amministrazione per notifica
,172		--Visualizza note produttore
,198		--Visualizza note approvazione
,201		--Visualizza note polizza
,202		--Visualizza note notifica
,203		--Modifica note polizza
,204		--Modifica note notifica
,218		--Visualizza note lista plichi
,283		--Visualizza note attivazione
,284		--Modifica note attivazione
,286		--Modifica Note per Sospetta Frode
,289		--Visualizza note amministrazione per notifica
,290		--Visualizza note amministrazione per sospetta frode
,408		--Visualizza note interne
,409		--Modifica note interne
,604		--Visualizza filtro note
,10012	--Visualizza tab note
,10024	--Inserisci nota
,10067	--Cerca per tipo nota incarico
)
*/


SELECT
	D_Privilegio.Codice
		,D_Privilegio.Descrizione

FROM R_ProfiloAccesso_Privilegio
JOIN D_Privilegio
	ON CodPrivilegio = D_Privilegio.Codice
	AND Codice IN (
	408		--Visualizza note interne
	, 4		--Visualizzazione note
	, 8		--Inserimento note
	, 46		--Mostra nota amministrazione
	, 69		--Visualizza note pratica
	, 70		--Visualizza note per agente
	, 71		--Visualizza note per assicurazione
	, 72		--Visualizza note liquidazione
	, 73		--Visualizza note cliente
	, 74		--Visualizza note storiche
	, 75		--Visualizza note problematicità
	, 92		--Visualizza note su tutti i tab
	, 114		--Visualizza note segnalazione
	, 129		--Visualizza note amministrazione per delibera
	, 131		--Modifica note amministrazione per notifica
	, 172		--Visualizza note produttore
	, 198		--Visualizza note approvazione
	, 201		--Visualizza note polizza
	, 202		--Visualizza note notifica
	, 203		--Modifica note polizza
	, 204		--Modifica note notifica
	, 218		--Visualizza note lista plichi
	, 283		--Visualizza note attivazione
	, 284		--Modifica note attivazione
	, 286		--Modifica Note per Sospetta Frode
	, 289		--Visualizza note amministrazione per notifica
	, 290		--Visualizza note amministrazione per sospetta frode
	, 408		--Visualizza note interne
	, 409		--Modifica note interne
	, 604		--Visualizza filtro note
	, 10012	--Visualizza tab note
	, 10024	--Inserisci nota
	, 10067	--Cerca per tipo nota incarico
	)
WHERE CodProfiloAccesso = 839
EXCEPT
SELECT 	D_Privilegio.Codice
		,D_Privilegio.Descrizione

		 FROM R_ProfiloAccesso_Privilegio
JOIN D_Privilegio on CodPrivilegio = D_Privilegio.Codice
AND Codice in (
408		--Visualizza note interne
,4		--Visualizzazione note
,8		--Inserimento note
,46		--Mostra nota amministrazione
,69		--Visualizza note pratica
,70		--Visualizza note per agente
,71		--Visualizza note per assicurazione
,72		--Visualizza note liquidazione
,73		--Visualizza note cliente
,74		--Visualizza note storiche
,75		--Visualizza note problematicità
,92		--Visualizza note su tutti i tab
,114		--Visualizza note segnalazione
,129		--Visualizza note amministrazione per delibera
,131		--Modifica note amministrazione per notifica
,172		--Visualizza note produttore
,198		--Visualizza note approvazione
,201		--Visualizza note polizza
,202		--Visualizza note notifica
,203		--Modifica note polizza
,204		--Modifica note notifica
,218		--Visualizza note lista plichi
,283		--Visualizza note attivazione
,284		--Modifica note attivazione
,286		--Modifica Note per Sospetta Frode
,289		--Visualizza note amministrazione per notifica
,290		--Visualizza note amministrazione per sospetta frode
,408		--Visualizza note interne
,409		--Modifica note interne
,604		--Visualizza filtro note
,10012	--Visualizza tab note
,10024	--Inserisci nota
,10067	--Cerca per tipo nota incarico
)
WHERE CodProfiloAccesso = 2279


SELECT
	*
FROM R_ProfiloAccesso_TipoNotaIncarichi rpatni
JOIN D_TipoNotaIncarichi dtni
	ON rpatni.CodTipoNotaIncarichi = dtni.Codice
WHERE rpatni.CodProfiloAccesso = 1137

--INSERT into R_ProfiloAccesso_Privilegio (CodProfiloAccesso, CodPrivilegio, FlagDisabilita)
--	VALUES (2279, 408, 0)
--	,(2279,409,0);


SELECT * FROM R_ProfiloAccesso_TipoNotaIncarichi
LEFT JOIN R_Cliente_TipoIncarico_TipoNotaIncarichi ON R_ProfiloAccesso_TipoNotaIncarichi.CodTipoNotaIncarichi = R_Cliente_TipoIncarico_TipoNotaIncarichi.CodTipoNotaIncarichi
AND CodTipoIncarico IN (387,512) AND R_ProfiloAccesso_TipoNotaIncarichi.CodTipoNotaIncarichi = 22
LEFT JOIN D_TipoNotaIncarichi on Codice = R_Cliente_TipoIncarico_TipoNotaIncarichi.CodTipoNotaIncarichi
WHERE CodProfiloAccesso = 2279

AND R_Cliente_TipoIncarico_TipoNotaIncarichi.IdRelazione is NULL



