USE ScanDB
GO

SELECT * FROM T_Pacchetto where IdPacchetto = 'bt07050424'

SELECT * FROM D_StatoPacchetto
/*
1	Da scansionare
2	Da classificare
3	Classificato
4	Imbarcato
5	Annullato
*/

--milano/scansione
use ScanDB_MI
SELECT	* FROM T_Pacchetto
WHERE IdPacchetto = 'bt07050424'

--ephesoft/classificazione
use ScanDB_EPH
SELECT	* FROM T_Pacchetto
WHERE IdPacchetto = 'bt07050424'


--se il pacchetto è stato scansionato (stato 2 da classificare su scanDB_MI
									 --, stato 3 su scandb_eph
									 --, stato 4 - imbarcato su scanDB)
--controlla dove sono


USE ScanDB_MI --uso questo perché è più veloce, ma va bene uguale ScanDB

select * FROM QTask_R_Pacchetto_Dati where IdPacchetto = 'bt07050424'

--verifica quanti documenti ci devono essere dentro il pacchetto (quelli che non iniziano con mi)
SELECT * FROM T_Documento WHERE IdPacchetto = 'bt07050424'


--verifica che i documenti sullo scanDB siano presenti su qtask
use CLC
SELECT * FROM T_Documento where Nome_file IN ('ep09346458.pdf','ep09346459.pdf')