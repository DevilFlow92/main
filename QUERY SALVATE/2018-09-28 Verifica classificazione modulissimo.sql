USE CLC
GO

;
WITH ContrattoQuadro
AS (SELECT DISTINCT
	IdIncarico
FROM T_Documento
WHERE Tipo_Documento = 7238 -- 20669 --Contratto quadro persone fisiche
AND FlagScaduto = 0
AND FlagPresenzaInFileSystem = 1),
Afi
AS (SELECT DISTINCT
	IdIncarico
FROM T_Documento
WHERE Tipo_Documento = 5954 --Contratto persona fisica AFI
OR Tipo_Documento = 7237	--Contratto persona GIURIDICA AFI
AND FlagScaduto = 0
AND FlagPresenzaInFileSystem = 1)

SELECT
	ContrattoQuadro.IdIncarico Quadro
	,Afi.IdIncarico AFI
	,CAST(DataCreazione AS DATE) DataCreazione
FROM T_Incarico
JOIN ContrattoQuadro
	ON T_Incarico.IdIncarico = ContrattoQuadro.IdIncarico
LEFT JOIN Afi
	ON ContrattoQuadro.IdIncarico = Afi.IdIncarico
WHERE CodCliente = 23
AND CodTipoIncarico = 288
AND CodArea = 8
AND FlagArchiviato = 0
AND Afi.IdIncarico IS NOT NULL 
--AND T_Incarico.IdIncarico = 10784858


/* DUE O PIU' MODULISSIMI

(SELECT IdIncarico, COUNT(IdIncarico) NumeroContratti  FROM T_Documento
WHERE Tipo_Documento = 20669
AND FlagScaduto = 0
AND FlagPresenzaInFileSystem = 1
GROUP BY IdIncarico
HAVING COUNT(IdIncarico) > 1)


*/

USE ScanDB_MI
SELECT * FROM QTask_R_Pacchetto_Dati where IdIncarico = 10999101


USE ScanDB_EPH

--SELECT * FROM T_Documento where IdPacchetto = 'bt07796746'

SELECT * FROM L_DOCUMENTOAUTOSEDE
WHERE IdPacchetto = 'bt07796746'

AND CodModulo = 3 --Document Assembler

AND Id_Page IN ('pg0','pg1','pg2','pg3','pg4')

SELECT * FROM D_MODULOAUTOSEDE


USE CLC

SELECT * FROM D_Documento where Codice = 7238


SELECT * FROM D_Documento
JOIN D_OggettoControlli on D_Documento.CodOggettoControlli = D_OggettoControlli.Codice
 where D_Documento.Descrizione LIKE '%tutelare'
