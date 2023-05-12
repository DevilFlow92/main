--SET UP IMBARCO MAIL
--Creare una nuova cartella per Imbarco mail per CB

--=====================================================================
--Tabelle impattate:
--Da far girare in pre-prod e poi trasferire tabelle
--D_Privilegio
--R_ProfiloAccesso_Privilegio

--In produzione - Per queste bisogna aprire il ticket
--S_MAILBOXIMBARCOINCARICHI
--R_Cliente_MailboxImbarcoIncarichi

--supporto@chebanca.cesamoffice.it
--=======================================================================
--Interroga le tabelle

USE CLC
SELECT* FROM S_MAILBOXIMBARCOINCARICHI
where IdMailbox in (
598,--CB Errori Sistema
599, --CB Sospesi Documentazione
600 --CB Predisposizione Contratti
)



use CLC
select* from D_Privilegio
where codice in (
11489,--visualizzazione mailbox errorisistema CheBanca
11490, --visualizzazione mailbox Sospesi CheBanca
11496 --Visualizzazione mailbox Predisposizione contratti Che Banca
)

use clc
select* from D_OrigineDocumento
where codice=1 --Imbarcato

--==========================================================================
--FASE 1) Fai la insert nella D_PRIVILEGIO
--questa insert può essere fatta in pre-produzione
--genera il codice che poi va inserito nella S_MAILBOXIMBARCOINCARICHI

--1) creare un nuovo privilegio --fai insert

use CLC select* from D_Privilegio order by Codice desc --11497

use CLC select* from D_Privilegio where Codice= 11498 --ok libero


--INSERT INTO [dbo].[D_Privilegio]
           ([Codice]
           ,[Descrizione]
           ,[CodRuoloOperatore]
           ,[CodCategoriaPrivilegio])
     VALUES
           (11498,'Visualizzazione mailbox supporto Che Banca',null, null)
GO


--verifica ok

use CLC
select* from D_Privilegio
where codice in (
11489,--visualizzazione mailbox errorisistema CheBanca
11490,--visualizzazione mailbox Sospesi CheBanca
11496,--Visualizzazione mailbox Predisposizione contratti Che Banca
11498)
--===============================================================================

--FASE 2) Abilitare gli operatori al privilegio appena creato
--fare la insert nella R_profiloaccesso_privilegio

use CLC
select* from R_ProfiloAccesso_Privilegio
where CodPrivilegio =11498
--trovo 6 codici profili accesso
--devo assegnarli al nuovo privilegio

--insert nella select
--fai girare in preproduzione

USE [CLC]
--INSERT INTO [dbo].[R_ProfiloAccesso_Privilegio]
           ([CodProfiloAccesso]
           ,[CodPrivilegio]
           ,[FlagDisabilita])
select [CodProfiloAccesso]
           ,11498 as [CodPrivilegio]
           ,[FlagDisabilita]
		    from R_ProfiloAccesso_Privilegio
where CodPrivilegio =11490

--(6 rows)
--======================================================================
--ora trafserisci in produzione le due tabelle impattate
--- D_Privilegio
--- R_ProfiloAccesso_Privilegio

use clc
SELECT *
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione like '%R_ProfiloAccesso_Privilegio%'


--Operatori privilegi


--=========================================================================

--FASE 3: fare la insert nella tabella S_MAILBOXIMBARCOINCARICHI

--in questa tabella posso visualizzare le cartelle per l'imbarco mail
--per questa insert devi aprire un ticket perchè gira solo in produzione

USE CLC
SELECT* FROM S_MAILBOXIMBARCOINCARICHI
where IdMailbox in (
598,--CB Errori Sistema
599, --CB Sospesi Documentazione
600) --CB Predisposizione Contratti


--=====================================================

--INSERT INTO [dbo].[S_MailboxImbarcoIncarichi]
           ([Username]
           ,[CodPrivilegio]
           ,[IdOperatore]
           ,[Descrizione]
           ,[CodOrigineDocumento]
           ,[FlagFax]
           ,[FlagAbilita])
     VALUES
           ('supporto@chebanca.cesamoffice.it'
		   ,11498 --Visualizzazione mailbox supporto Che Banca
           ,null
           ,'CB Supporto'
           ,1 --Imbarcato
           ,0
           ,1)

--Trasferire gruppo: Mailer

--devi fare la insert anche qui
--ma ti serve prima l'idmailboxincarichi

USE CLC
SELECT* FROM R_Cliente_MailboxImbarcoIncarichi
WHERE CODCLIENTE=48
AND CodTipoIncarico IN (331,334,335) and IdMailboxImbarcoIncarichi = 598

--Trasferire gruppo: Operazione imbarco mail



