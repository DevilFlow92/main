USE CLC

--ESEMPIO (v stefi)

SELECT * FROM S_MailboxImbarcoIncarichi
where Descrizione LIKE '%Predisposizione Contratti%'
--id mailbox 600
--CodPrivilegio 11496
--CodOrigineDocumento 1  Imbarcato
--FlagFax 0
--Flag Abilita 1


SELECT * FROM D_ProfiloAccesso join S_Operatore on CodProfiloAccesso = Codice
where Cognome LIKE '%fiori%' and Nome like '%lorenzo%'
--cod profilo accesso   839	ORGA CESAM


--preproduzione (poi deploy)+
USE CLC
SELECT * FROM D_Privilegio order BY Codice DESC
--ultimo codice 11557

INSERT INTO D_Privilegio (Codice,Descrizione)
VALUES (11558, 'Visualizzazione mailbox gestione commissioni')
		, (11559, 'Visualizzazione mailbox attesa sottoscrizioni')
		, (11560, 'Visualizzazione mailbox credenziali previdenza')

INSERT INTO R_ProfiloAccesso_Privilegio (CodProfiloAccesso, CodPrivilegio, FlagDisabilita)
	SELECT CodProfiloAccesso, 11555 as CodPrivilegio, FlagDisabilita
		FROM R_ProfiloAccesso_Privilegio
		where CodPrivilegio = 11490 


INSERT INTO R_ProfiloAccesso_Privilegio (CodProfiloAccesso, CodPrivilegio, FlagDisabilita)
	SELECT
		CodProfiloAccesso
	   ,11558 AS CodPrivilegio
	   ,FlagDisabilita
	FROM R_ProfiloAccesso_Privilegio
	WHERE CodPrivilegio = 11490


INSERT INTO R_ProfiloAccesso_Privilegio (CodProfiloAccesso, CodPrivilegio, FlagDisabilita)
	SELECT
		CodProfiloAccesso
	   ,11559 AS CodPrivilegio
	   ,FlagDisabilita
	FROM R_ProfiloAccesso_Privilegio
	WHERE CodPrivilegio = 11490

INSERT INTO R_ProfiloAccesso_Privilegio (CodProfiloAccesso, CodPrivilegio, FlagDisabilita)
	SELECT
		CodProfiloAccesso
	   ,11560 AS CodPrivilegio
	   ,FlagDisabilita
	FROM R_ProfiloAccesso_Privilegio
	WHERE CodPrivilegio = 11490

--quali tabelle trasferisco?
SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione LIKE '%R_ProfiloAccesso_Privilegio%'
--Operatori privilegi



--PARTE 2
--aprire ticket

INSERT into S_MailboxImbarcoIncarichi (Username,CodPrivilegio,Descrizione,CodOrigineDocumento,FlagFax,FlagAbilita)
VALUES ('lettere.cliente@azimut.cesamoffice.it', 11555, 'AZ Risposta alla Clientela', 1, 0, 1)
		, ('gestione.commissioni@azimut.cesamoffice.it', 11558, 'AZ Storno Commissioni di Ingresso', 1, 0, 1)
		, ('attesa.sottoscrizioni@azimut.cesamoffice.it', 11559, 'AZ Comunicazione Bonifici in Attesa di Sottoscrizione', 1, 0, 1)
		, ('credenziali.previdenza@azimut.cesamoffice.it', 11560, 'AZ Gestione Credenziali Portale Previdenza', 1, 0, 1)


INSERT INTO R_Cliente_MailboxImbarcoIncarichi (CodCliente, CodTipoIncarico, IdMailboxImbarcoIncarichi)
VALUES (23,331, 11555)
		, (23, , 11558)
		, (23, , 11559)
		, (23, , 11560)

GO
