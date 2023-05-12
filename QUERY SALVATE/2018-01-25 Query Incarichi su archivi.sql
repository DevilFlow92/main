
/* dato un codice archivio da acquisizione, trovare l'incarico associato a quella posizione archivio

AZ P 3-1-3 [8]
*/
USE CLC

select * from D_Scaffale

where Descrizione LIKE 'Az P%'

--codscaffale 44

SELECT * from S_PosizioneArchivio 
where CodScaffale = 44 and CodiceSezione = 3 AND CodicePiano = 1 AND CodiceScatola = 3
and CodColore = 8

--idposizione archivio 44003001003008

SELECT IdIncarico, * from T_Documento where IdPosizioneArchivio = 44003001003008

