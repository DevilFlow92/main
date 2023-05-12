
----- COME attivare la PEC su QTASK

--1) creo mail di imbarco QTASK (ticket Tuveri) e eseguo setup standard di imbarco mail


use clc
---creare privilegio

selecT*
from D_Privilegio

INSERT INTO [dbo].[D_Privilegio]
([Codice]
,[Descrizione]
,[CodRuoloOperatore]
,[CodCategoriaPrivilegio])
VALUES
(11541
,'Visualizza mail AZ Switch PEC'
,NULL
,null)

-- associare privilegio (privilegio extranet) a profili 

use clc
select*
from R_ProfiloAccesso_Privilegio
where CodPrivilegio=11541


USE [CLC]
GO

------------INSERT INTO [dbo].[R_ProfiloAccesso_Privilegio]
------------           ([CodProfiloAccesso]
------------           ,[CodPrivilegio]
------------           ,[FlagDisabilita])


------------select 
------------[CodProfiloAccesso]
------------           , 11541 as [CodPrivilegio]
------------           ,[FlagDisabilita]
------------		   from  R_ProfiloAccesso_Privilegio where CodPrivilegio=10911




-- SOLO in produzione

selecT*
from S_MailboxImbarcoIncarichi

--INSERT INTO [dbo].[S_MailboxImbarcoIncarichi]
--           ([Username]
--           ,[CodPrivilegio]
--           ,[IdOperatore]
--           ,[Descrizione]
--           ,[CodOrigineDocumento]
--           ,[FlagFax]
--,[FlagAbilita])
--     VALUES
--           ('caricamentoswitchpec@azimut.cesamoffice.it'
--           , 11541
--           , NULL
--           ,'AZ Switch PEC'
--           , 1
--           , 0
--		   ,1)
 

  ----------------------------------------------------------------------

selecT*
from D_TipoIncarico
where Descrizione like '%fax%'


INSERT INTO [dbo].[R_Cliente_MailboxImbarcoIncarichi]
([CodCliente]
,[CodTipoIncarico]
,[IdMailboxImbarcoIncarichi])
VALUES
(23
, 159
, @IdMailboxImbarcoIncarichi) ---> una volta creato l'id dalla s_mailboxincarichi



------------


INSERT INTO [dbo].[R_MailboxImbarcoIncarichi_Mittente]
           ([IdMailbox]
           ,[Mittente]
           ,[Firma])
     VALUES
           (xxxx
           ,'caricamentoswitchpec@azimut.cesamoffice.it'
           ,'Ufficio Acquisizione
c/o CESAM Centro Servizi Asset Management Srl
Via Desenzano, 2 - 20146 Milano - Italy
E-mail: pignoramentiaccertamenti@azimut.backofficesim.it')




INSERT INTO [dbo].[S_MittenteMailIncarichi]
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodRuoloOperatoreIncarico]
           ,[Email]
           ,[Firma]
           ,[CodClientePratica]
           ,[CodProdottoPratica]
           ,[CodProduttorePratica]
           ,[CodMacroCategoriaTicket])
     VALUES
           (23
           ,159
           ,null
           ,'caricamentoswitchpec@azimut.cesamoffice.it'
           ,'Ufficio Acquisizione
c/o CESAM Centro Servizi Asset Management Srl
Via Desenzano, 2 - 20146 Milano - Italy
E-mail: pignoramentiaccertamenti@azimut.backofficesim.it'
           ,NULL
           ,NULL
           ,NULL
           ,NULL)



		   	   

--•	S_GestorePec -> serve per indicare i server del fornitore della casella PEC. Per adesso sono setuppati LegalMail, Acatlis, Namirial e Aruba; quando si aggiunge un nuovo gestore potrebbe essere necessario fare delle aperture firewall.
--•	S_CredenzialiPec -> serve per specificare le informazioni di accesso e gestione della casella (username, password, indirizzo di inoltro dell’imbarco mail)
--•	S_ConfigurazionePec -> serve per abilitare le caselle sui vari clienti e tipi incarico. Una stessa casella può essere anche utilizzata da clienti diversi, ma dato che abbiamo 2 imbarchi mail diversi, per adesso non è possibile setuppare la stessa casella sia per ExtranetCLC che Q-Task.

use clc
selecT*
from S_GestorePec--- 5	Aruba	smtps.pec.aruba.it	465	imaps.pec.aruba.it	993

--username: centroservizi@pec.azscan.it 
--password: 


--I seguenti servers sono tutti in connessione cifrata SSL: 
--POP3S: pop3s.pec.aruba.it                porta tcp: 995 
--IMAPS: imaps.pec.aruba.it                porta tcp: 993 
--SMTPS: smtps.pec.aruba.it                porta tcp: 465 


select*
from S_CredenzialiPec


USE [CLC]
GO

------------INSERT INTO [dbo].[S_CredenzialiPec]
------------           ([IdGestorePec]
------------           ,[IndirizzoPec]
------------           ,[Username]
------------           ,[Password]
------------           ,[FlagInvio]
------------           ,[FlagRicezione]
------------           ,[IndirizzoInoltro]
------------           ,[FlagAttivo]
------------           ,[FlagCancellaMailElaborate])
------------     VALUES
------------           (5
------------           ,'centroservizi@pec.azscan.it'
------------           ,'centroservizi@pec.azscan.it'
------------           ,'Centr053rv1ziAZ5can'
------------           ,1
------------           ,1
------------           ,'caricamentoswitchpec@azimut.cesamoffice.it'
------------           ,1
------------           ,0)
------------GO



selecT*
from S_ConfigurazionePec

---caricamentoswitchpec@azimut.cesamoffice.it

select*
from D_Sistema--3	QTask


--------INSERT INTO [dbo].[S_ConfigurazionePec]
--------           ([CodSistema]
--------           ,[CodCliente]
--------           ,[CodTipoIncarico]
--------           ,[CodProdotto]
--------           ,[IdCredenzialiPec]
--------           ,[FlagAbilita])
--------     VALUES
--------           (3
--------           ,23
--------           ,159
--------           ,null
--------           ,59
--------           ,1)
--------GO




