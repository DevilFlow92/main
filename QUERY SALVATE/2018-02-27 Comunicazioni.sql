--Errori Invio Raccomandate Rol

USE clc
SELECT	*
FROM t_comunicazione
WHERE idincarico = 9706933
AND idcomunicazione = 24767020

select * FROM S_TemplateComunicazione where IdTemplate = 5664


SELECT	*
FROM y_spoolerinviopostev2
WHERE idcomunicazione IN (
24637772,
24655766,
24684060,
24701311,
24765272,
24767020)

--Possibili Esiti:
--Lavorato 0 Fallito 1 --> Fallito davvero
--Lavorato 1 Fallito 0 --> In coda di lavorazione (anche mezz'ora in coda)
--Lavorato 1 fallito 1 --> Caso Jolly


--verificare se esiste il Comune nella D_comune

SELECT	*
FROM D_Comune
WHERE descrizione LIKE '%Ronco%'



--Percorso dei log
--\\btwebin01\CLC_Log\ServiziQTask
--nel file di oggi SpoolerInvioPoste-20180212
--Cerca per idcomunicazione

--per l'invio corretto copia sempre il campo dalla D_comune (ctrl +c _V)
--============================================
--Blocco di una Raccomandata On Line [ROL]

USE CLC -- BTSQLCL05\BTSQLCL05

-- [1] Cerco idComunicazione della raccomandata (l’operatore deve dirci incarico e orario di invio)

SELECT	*
FROM T_Comunicazione
WHERE IdIncarico = 3468866

-- [2] Vedo se nello spooler il flag è 1 = lavorato. 
SELECT
	*
FROM [dbo].[Y_SpoolerInvioPostev2]
WHERE IdComunicazione = 14081228


-- [3] Se è 0 possiamo ancora bloccarla con update (flagfallito = 1, flagLavorato = 1)


-- [Test] Vedo se siamo riuscita ad bloccare non ci sarà riga nella [L_CostoInvioPoste]

SELECT
	*
FROM [dbo].[L_CostoInvioPoste]
WHERE IdComunicazione = 14081228

--==================================================================================================
--ricerca codice spedizione ROL

USE clc
SELECT
	*
FROM t_spedizionenotifica
WHERE idincarico = 9527978 



