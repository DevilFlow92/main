use CLC

--Set up per INOLTRA – RISPONDI – RISPONDI A TUTTI
USE clc
--1)	CERCO I PRIVILEGI

select* from D_Privilegio
where codice in (10058,10059,10060)

--10059      Inoltra comunicazione
--10058      Rispondi a comunicazione
--10060      Rispondi a tutti comunicazione

--2)	ASSOCIO I PRIVILEGI AL CODICE PROFILO ACCESSO

select* from r_profiloaccesso_privilegio
where codprofiloaccesso=945
and codprivilegio in (10058,10059,10060)

--3)	I PRIVILEGI DEVONO ESSERE DISPONIBILI SOLO PER UN DET. TIPO INCARICO

select* from R_ProfiloAccesso_TipoIncarico_Privilegio
where CodProfiloAccesso=945 -- TA
and CodCliente=23 -- Azimut
and CodTipoIncarico=351 --Successioni AFB


--4)	 TRASFERIMENTO TABELLE

SELECT *
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'R_ProfiloAccesso_TipoIncarico_Privilegio'

--OPERATORI Q-TASK


--SETUP DEI MITTENTI E DESTINATARI 

--cerchiamo il tipo incarico
SELECT * from D_TipoIncarico where Descrizione LIKE '%sottoscrizioni%afb%'
--351	Successioni AFB

--tabella dove vengono inseriti i mittenti: S_MittenteMailIncarichi

INSERT INTO S_MittenteMailIncarichi (CodCliente, CodTipoIncarico, Email)

VALUES (23,351, 'successioni@azimut.cesamoffice.it')
		,(23,351, 'successionicaseterze@azimut.cesamoffice.it')


--Tabella dei destinatari: R_Cliente_TipoIncarico_DestinatarioMailIncarichi

--tipi di destinatario mail (to, cc, bccn)
SELECT * FROM D_TipoDestinatarioMail


--setup dei destinatari
INSERT INTO [dbo].[R_Cliente_TipoIncarico_DestinatarioMailIncarichi]
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodTipoDestinatarioMail]
           ,[Email])
     VALUES
--to
	    (23,351,1,'clientservicesitaly@allfundsbank.com'),
		(23,351,1,'gabriele.bassi@azimut.cesamoffice.it')
		,(23,351,1,'case.terze@azimut.cesamoffice.it')
		,(23,351,1,'marcello.caleca@azimut.it')
		,(23,351,1,'raffaella.bresciani@azimut.it')
		,(23,351,1,'assistenza@azimut.it')
		,(23,351,1,'assistenza.wm@azimut.it')
		,(23,351,1,'luisa.mezza@azimut.it')
--cc
		,(23,351,2,'3S_Staff@gruppomol.it')
		,(23,351,2,'gabriele.bassi@azimut.cesamoffice.it')
		,(23,351,2,'case.terze@azimut.cesamoffice.it')
		,(23,351,2,'marcello.caleca@azimut.it')
		,(23,351,2,'assistenza@azimut.it')
		,(23,351,2,'raffaella.bresciani@azimut.it')
		,(23,351,2,'assistenza.wm@azimut.it')
		,(23,351,2,'luisa.mezza@azimut.it')


--trasferimento gruppo di tabelle: quale?
SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'R_Cliente_TipoIncarico_DestinatarioMailIncarichi'

--MAILER



