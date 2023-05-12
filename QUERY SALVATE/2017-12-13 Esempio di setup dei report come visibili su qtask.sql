USE clc

/*
SET-UP DEI REPORT IN MODO TALE CHE SIANO VISIBILI SU QTASK.

Si lavora in PREPRODUZIONE in quanto si devono fare delle insert.
Poi si esegue il deploy in produzione, una volta concluso con il setup.

Le tabelle oggetto di setup sono 3
*/


--1) S_Report  - inserire il report nel database

SELECT * from S_Report
--ultima riga: 2172

insert into S_Report
			(Nome        --stesso nome che trovi in reportistica
			,CodCliente  --importante se ad esempio è di azimut o di chebanca
			,CodTipoIncarico
			,CodCategoriaReport
			,CodConsegnaReport
			,FlagExtranetCLC
			,FlagQTask  --è questo che permette la visibilità su qtask
			,Percorso   --lo prendi dal sistema di reportistica 
			,FlagAttivo --importante
			,CodFormatoReport
			,FlagImbarcabile
			,FlagTabReport)
	values('AZ - AFB - Estrazione incarichi', 23, null,9,2,0,1,'/Reportistica Esterna/CESAM/AZIMUT/AZ - AFB - Estrazione incarichi',1,NULL, 0,0)

--verifica 
SELECT * FROM S_Report where Nome = 'AZ - AFB - Estrazione incarichi'
--id report 2173



--2) R_ProfiloAccesso_Report  - abilitare i profili accesso interessati

--a quale profilo accesso abilitare il report? cerchiamo il codice per cognome/nome operatore
SELECT * FROM S_Operatore where Cognome LIKE '%pizzamiglio%' 
--cod profilo accesso 940


SELECT CodProfiloAccesso
		,Nome

 FROM S_Report join R_ProfiloAccesso_Report on S_Report.IdReport= R_ProfiloAccesso_Report.IdReport
 where Nome LIKE '%AFB%' 


INSERT INTO R_ProfiloAccesso_Report
			(CodProfiloAccesso
			,CodCategoriaReport
			,IdReport
			,FlagAbilita)
	VALUES (940, 9, 2173, 1)
			,(939, 9, 2173, 1)

--verifica
SELECT * FROM R_ProfiloAccesso_Report where IdReport = 2173



--3) R_Report_FormatoReport  - setup del formato in cui si esporta

INSERT into R_Report_FormatoReport
		(IdReport
		,CodFormatoReport)
	VALUES (2173, 5) --formato excel

--verifica
SELECT * FROM R_Report_FormatoReport where IdReport = 2173

--deploy tabella:

---Gruppo Report




