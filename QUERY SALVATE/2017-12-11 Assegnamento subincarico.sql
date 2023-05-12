use CLC
SELECT
	*
FROM D_TipoIncarico
WHERE Descrizione LIKE '%succ%'

--54	Successioni

SELECT * FROM D_TipoIncarico where Descrizione LIKE '%incr%'
--343 Incremento/Decremento

--si può subincaricare un incremento/decremento a successioni?
SELECT
	*
FROM R_Cliente_TipoIncaricoAssociabile
WHERE CodTipoIncarico = 54 --master
AND CodTipoIncaricoAssociabile = 343  --tipoincarico associabile come sub

--se non ci sono righe, connettersi al server VP-BTSQL02 per fare il setup

USE CLC

INSERT INTO R_Cliente_TipoIncaricoAssociabile (CodCliente, CodTipoIncarico, CodTipoIncaricoAssociabile)
VALUES (23, 54, 343)

--fare la prova in preproduzione
--loggarsi con nome.cognome  psw: test


--prendere un incarico successioni (azimut) a caso
--vai su subincarichi --> associa --> inserisci un idincarico che sia incremento/decremento

select * FROM T_Incarico where CodTipoIncarico = 343
--4411565


--se funziona, trasferisci il gruppo di tabelle Generale Incarichi
