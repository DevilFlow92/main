/*
ERRORE IMPORT SIMULA: cercare nei log.
Path: \\\btwebincl07n0x\CLC\Log\BackEndServizi\gestoreimbarcosimuleazimut-yyyyMMdd
con x (il nodo) che può andare da 1 a 6
con yyyymmdd che corrisponde alla data di import dove sono stati dati errori

Se come errore si presenta un'eccezione del tipo:
	Eccezione:	System.Data.SqlClient.SqlException
	Messaggio:	Cannot insert duplicate key row in object 'dbo.T_Persona' with unique index 'IX_ChiaveCliente_Azimut'. The duplicate key value is (000627488)

Allora si tratta di un caso in cui la persona è censita nei sistemi Azimut, sia come cliente, sia come promotore e molto probabilmente non è stata fatta la bonifica.
Per questo motivo, lo script di import non riesce a cambiare la chiave cliente all'idpersona associata come promotore.
*/

--VERIFICA DELL'IPOTESI DI SOPRA

--cerca l'idpersona per la chiave cliente rilasciata come duplicata dalla log

SELECT * FROM T_Persona where ChiaveCliente = '000628775'
--3356566	questo è l'idpersona - versione cliente

--verifica che nome e cognome della persona censita con quella chiave cliente, siano gli stessi di quelli censiti con l'idpersona dato nella log

select * FROM T_Persona where IdPersona = 3370779 --questo è l'idpersona - versione promotore, che ha la chiave cliente da aggiornare con quella di cui sopra


--cerca un incarico dove è associata la persona come promotore e un incarico dove la persona è censita come cliente

SELECT TOP 1 IdIncarico, *  FROM T_R_Incarico_Promotore 
join T_Promotore on T_Promotore.IdPromotore = T_R_Incarico_Promotore.IdPromotore
where IdPersona = 3370779

SELECT TOP 1 IdIncarico, * FROM T_R_Incarico_Persona
WHERE IdPersona = 3356566

--Vai su QTask
--	"sporca" la chiave cliente della persona censita come cliente, aggiungendo una A alla fine
--	modifica la chiave cliente della persona censita come promotore, togliendo la p alla fine

--fai la bonifica come sotto

insert into orga.Y_BonificaPersone_Qtask (ChiaveClienteDelete, ChiaveClienteSurvive)
select '000628775A', '000628775'

exec orga.BonificaPersone_Qtask @CodCliente= 23

SELECT * FROM orga.Y_BonificaPersone_Qtask order BY idBonifica DESC 

--alla prossima schedulazione dell'import simula non dovrebbe più stopparsi


