--Come rendere disponibile un REPORT SU Q-TASK

use CLC
select* from D_GruppoTabelleSetup
--32	Report

--==con questa query individuo tutte le tabelle da setuppare============
select * from D_TabellaSetup where Codice in (
select CodTabellaSetup from R_GruppoTabelleSetup_TabellaSetup
where CodGruppoTabelleSetup=32)

--TABELLE IMPATTATE
--D_CategoriaReport --no set up
--D_ConsegnaReport -- no set up
--D_FormatoReport -- no set up
--R_ProfiloAccesso_Report --set up OK
--R_Report_FormatoReport --set up ok
--S_Report --set up OK
--R_Cliente_TipoIncarico_ReportImbarcabile --no set up

--==============================================================================================
--1) S_Report
--CONTROLLA UN REPORT GIà PUBBLICATO
--FAI LA INSERT DOPO AVER VERIFICATO CHE IL REPORT NON è GIà STATO PUBBLICATO SU Q-TASK
use clc
select* from S_Report where nome like'%Via fax%' --già esistente
--idreport 407

use clc
select* from S_Report where nome like'%Via fax%' --già esistente

INSERT INTO [dbo].[S_Report]
           ([Nome]
           ,[CodCliente]
           ,[CodTipoIncarico]
           ,[CodCategoriaReport]
           ,[CodConsegnaReport]
           ,[FlagExtranetCLC]
           ,[FlagQTask]
           ,[Percorso]
           ,[FlagAttivo]
           ,[CodFormatoReport]
           ,[FlagImbarcabile]
           ,[FlagTabReport])
     VALUES ('AZ - Monitoring - Apertura Conti - UBS', 23,null,9,2,0,1,
	 '/Reportistica Esterna/CESAM/AZIMUT/AZ - Monitoring - Apertura Conti - UBS',1,null,0,0)


Use CLC select* from D_CategoriaReport where codice =9 --Gestino SIM
Use CLC select* from D_ConsegnaReport where codice =2 --Embedded report


--copy full path
--C:\GruppoMOL-2012\CESAM\QTask Reports\Azimut\AZ - Monitoring - Apertura Conti - UBS .rdl
 
--update s_report set Percorso ='/Reportistica Esterna/CESAM/Azimut/AZ - Monitoring - Apertura Conti - UBS'
--where idreport=2107

select* from S_Report where IdReport in (407,2107)

--==============================================================================
--2)R_ProfiloAccesso_Report
use CLC select* from R_ProfiloAccesso_Report
where CodCategoriaReport=9
and IdReport=2107
and CodProfiloAccesso= 839

--a quale profilo accesso abilitare il report--
USE CLC select* from S_Operatore where cognome like'%bresciani%' and nome like'%raffaella%'
--1137 - AZIMUT Esterno CESAM Assistenza
use CLC select* from D_ProfiloAccesso where codice=1137


USE [CLC]
INSERT INTO [dbo].[R_ProfiloAccesso_Report]
           ([CodProfiloAccesso]
           ,[CodCategoriaReport]
           ,[IdReport]
           ,[FlagAbilita])
     VALUES (839,9,2107,1)

--VERIFICA
select* from R_ProfiloAccesso_Report where IdReport=2107

--=====================================================
--3)R_Report_FormatoReport

select* from R_Report_FormatoReport where idreport =407 --AZ - Code di Lavorazione Sospesi


--INSERT INTO [dbo].[R_Report_FormatoReport]
           ([IdReport]
           ,[CodFormatoReport])
     VALUES (2107,5)



select* from D_FormatoReport where codice= 5 --Excel 2003

select* from R_Report_FormatoReport where idreport =2107

--=====================================
--4)R_Cliente_TipoIncarico_ReportImbarcabile

-- No set up

use CLC
select* from R_Cliente_TipoIncarico_ReportImbarcabile
where codcliente=23

--================================
--trasferimento tabelle multiutility

use clc
SELECT *
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione like '%R_ProfiloAccesso_Report%'

--Report





















