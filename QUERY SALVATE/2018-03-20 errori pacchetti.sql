--ERRORE PACCHETTI
--in un incarico non ci sono i documenti
--Che controlli fare?

--1)Se ho il numero incarico
--Prima di tutto controllo se qul tipoincarico passa per eph

use CLC select CodTipoIncarico 
from t_incarico where IdIncarico=9939142  

USE ScanDB_EPH 
SELECT * FROM R_Sistema_Processo_Imbarca_ClassificaOCR
where CodTipoIncarico=288

--ok passa per eph
--=================================================================
--2)Cerco il bacth associato all'incarico
--sia su scandb che su scandb_mi

--===QTask_R_Pacchetto_Dati===in questa tabella c'è sia il pacchetto che l'incarico
use scandb
SELECT * FROM QTask_R_Pacchetto_Dati 
where IdIncarico=9939142

--dal pacchetto recupero l'incarico o viceversa


--3) prendo il pacchetto e cerco nella t_pacchetto: anche su scandbeph
bt06886600
bt06909641

use ScanDB_eph
SELECT * FROM T_Pacchetto
where idpacchetto in (
'bt06909641')

use ScanDB
SELECT * FROM T_Pacchetto
where idpacchetto in (
'bt06459464')

use ScanDB_mi
SELECT * FROM T_Pacchetto
where idpacchetto in (
'bt06643217')


use scandb_mi
select* from D_StatoPacchetto
--1	Da scansionare
--2	Da classificare
--3	Classificato
--4	Imbarcato
--5	Annullato

--verifica se effettivamente il documento non è sull'incarico
--se non c'è nessuna riga non è mai salito
--a meno che non sia stato spostato

use CLC
select* from T_Documento where IdIncarico=9466104


use scandb_eph select*from T_documento where idpacchetto = 'bt06459209'

--con questa trovo il nome file esempio: ep07325822.pdf 
--prendi quelli con epdavanti perchè vengono così rinominati quando passano per eph

use clc
select*from T_documento where Nome_file = 'ep07332012.pdf'

--vedo che è stato riclassificato come esempio 102
--sulla destra c'è l'incarico sul quale è salito vedi se corrisponde
--ora cerco il batch corrispondente all'incarico


use scandb_eph
select* from QTask_R_Pacchetto_Dati where idincarico = 9427538

'bt06423600'



--=====ulteriore ricerca=========
--verifica se il documento scansionato su quale incarico è salito
--come fare?
--cerca su

use CLC
select* from T_Documento
where Nome_file like'%%'


--il nome lo prendi dalla misna 01
--tasto destro proprietà documento
--cerca il nome  e vedi su quale incarico

--verifica se il file xml è corretto a livello di indicazioni incarico.


USE CLC_Storico
SELECT *
FROM storico.V_Log_T_Documento
WHERE Documento_id = 59202288




--========================================
--Se ci arriva una mail di errore indicando solo il batch generato dal kodak

--troviamo i singoli pacchetti nel modo seguente

USE ScanDB_MI
SELECT * FROM L_KodakBatch 
JOIN L_KodakBatchPacchetto ON L_KodakBatch.IdElaborazione = L_KodakBatchPacchetto.IdElaborazioneKodak
where KodakBatch = 'MIPC115_Batch134471'


--MIPC115_Batch134471 questo è il batch generato dal kodak

--===============================================================

--dai un'occhiata alla colonna data scansione
--se è null vuol dire che non è mai stato scansionato

--se non è stato mai scansionato ma solo fatto il check inn
--allora cerca nele cartelle misna 01 che sono legate alla scansione
--cartella package out LOG(Doc scansionati: batch + PDF)

--puoi cercare anche su ephesoft per verificare che non sia in review
--================================================
--se vogliamo essere proprio sicuri che non è mai stato scansionato

--su scandb mI
use ScanDB_MI
SELECT * 
FROM L_KodakBatchPacchetto where IdPacchetto='bt06459464'


use ScanDB_MI
select* from T_Job
where idpacchetto='bt06643217'

use ScanDB_MI
select* from d_statojob
--1	Creato (significa che ancora non è stato scansionato)
--2	In lavorazione
--3	Chiuso
--4	Annullato
--5	Errato


use scandb_mi
select* from L_KodakBatch
join L_KodakBatchPacchetto on L_KodakBatchPacchetto.IdElaborazioneKodak=L_KodakBatch.IdElaborazione
where IdElaborazioneKodak =10375
and IdPacchetto= 'bt06459464'

--======
--per capire a che ora è stato imbarcato un doc
--vai sulla t_documento cerchi per idpacchetto

use CLC
select* from T_Incarico
where IdIncarico=8908310

use CLC
select* from T_Documento
where idincarico=9466314 


--controlla anche L_DOCUMENTOAUTOSEDE
--traccia quello che ha fatto eph
use ScanDB_EPH

select*from T_job where idpacchetto = 'bt06459464'


SELECT * FROM L_DOCUMENTOAUTOSEDE where IdPacchetto = 'bt05692833'
--colonna codmodulo

use ScanDB_EPH
select* from D_MODULOAUTOSEDE
--3	Document Assembler (fase precedente a validation)
--5	Extraction
--7	Validate Document


select* from D_statoJob


use CLC
SELECT * FROM dbo.T_OperazioneAzimut
WHERE CodiceStampa = '23566'

--==========================================================
--verificare quali sono gli operatori che hanno classificato i pacchhetti

--se verifico da questa tabella l'operatore potrebbe non corrispondere a quello che effettivamente ha classificato

use ScanDB_eph
SELECT * FROM T_Pacchetto where idpacchetto in ('bt06909641')

--mentre verifichiamo in questa tabella

SELECT * FROM L_DOCUMENTOAUTOSEDE WHERE IdPacchetto IN ('bt06909641' , 'bt06886600') AND CodModulo = 5 --Review

--3 Classificazione Sistema 1° Parte
--5 Review
--7 Validation


SELECT * FROM S_OperatoreAutosede --Operatori Fittizi che vengono censiti quando il pacchetto passa automaticamente in Validation
