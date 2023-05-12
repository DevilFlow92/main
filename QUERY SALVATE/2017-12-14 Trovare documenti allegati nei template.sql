/*
In Qtask sono visibili gli allegati delle mail che vengono scambiate nel corso di un incarico.
Per vederli in SQL, si esegue questa query

Ricevuta da: Stefi il 14/12/2017

*/

USE clc
SELECT
	t_comunicazione.idincarico
   ,t_comunicazione.idcomunicazione
   ,t_comunicazione.oggetto
   ,flagallegati
   ,t_documento.Documento_id
   ,tipo_documento
   ,DataInserimento
   ,Descrizione

FROM t_comunicazione
JOIN T_R_Comunicazione_Documento
	ON T_R_Comunicazione_Documento.IdComunicazione = t_comunicazione.IdComunicazione
JOIN T_Documento
	ON T_Documento.Documento_id = T_R_Comunicazione_Documento.IdDocumento
JOIN D_Documento
	ON D_Documento.Codice = T_Documento.Tipo_Documento
WHERE t_documento.idincarico = 9334681
AND T_R_Comunicazione_Documento.IdComunicazione = 23877493

