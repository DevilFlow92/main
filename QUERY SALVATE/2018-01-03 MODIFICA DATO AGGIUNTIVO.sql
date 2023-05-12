use clc

SELECT * FROM D_TipoDatoAggiuntivo where Descrizione like '%salesforce%'
--codice 1023

SELECT * FROM D_FormatoDatoAggiuntivo
--varchar(max) codice 1

--PREPRODUZIONE

update D_TipoDatoAggiuntivo
SET CodFormatoDatoAggiuntivo = 1
where Codice = 1023


--poi trasferisci