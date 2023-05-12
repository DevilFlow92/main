/*
ASSEGNAZIONE PROFILO QTASK (COD PROFILO ACCESSO) DI UN OPERATORE (ES TL) AD UN ALTRO
*/
--PREPRODUZIONE
use CLC
--PROFILO ACCESSO TL - MARICA MAESTRELLO
select * from S_Operatore
where cognome like '%maestrello%'
--cod profilo accesso 1267

--PROFILO OPERATORE DESTINATARIO - DANIELE LEROSE
select * from S_Operatore
where cognome like '%lerose%'
--idOperatore 5113
--CodProfiloAccesso 934; nuovo cod:1267

--assegnazione
update S_Operatore
set CodProfiloAccesso = 1267 where IdOperatore = 5113


--TRASFERIMENTO TABELLE


