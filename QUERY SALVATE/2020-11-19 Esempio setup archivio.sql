--vp-btsql02

USE CLC
GO

--Esempio setup archivio per azimut successioni
SELECT * FROM R_Cliente_Archivio
WHERE CodCliente = 23 AND CodTipoIncarico = 54

--Esempio setup archivio per altro incarico azimut
SELECT * FROM R_Cliente_Archivio 
WHERE CodCliente = 23 AND CodTipoIncarico = 695

--A cosa corrisponde lo scaffale 30?
SELECT * FROM D_Scaffale WHERE Codice = 30

--Come si vede l'elenco delle posizioni archivio "prenotate" per il tipo incarico 695?
SELECT * FROM S_PosizioneArchivio
WHERE codcliente = 23 AND CodTipoIncarico = 695

--Come faccio a sapere quante sezioni / piani / scatole / cartelle può contenere uno scaffale?
SELECT * FROM S_Archivio
WHERE CodScaffale = 23

/******** ESEMPIO DI UN SETUP ARCHIVIO ***********/
/*
Setup del tipo incarico 695 su cliente 23
*/

SELECT CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodicePianoFine,*
FROM R_Cliente_Archivio
WHERE CodCliente = 23 AND CodTipoIncarico = 695

--Controllo capienza scaffale 23
SELECT * FROM S_Archivio
WHERE CodScaffale = 23
--2 sezioni, 13 piani, 4 scatole, 12 cartelle

--Proviamo a vedere quali sezioni, piani e scatole sono state già prenotate per lo scaffale 23
SELECT CodScaffaleInizio, CodiceSezioneInizio, CodiceSezioneFine, CodicePianoInizio, CodicePianoFine, CodiceScatolaInizio, CodiceScatolaFine
FROM R_Cliente_Archivio
WHERE CodScaffaleInizio = 23 OR CodScaffaleFine = 23

--quindi se scelgo sezione 1, piano 6 sono a posto

SELECT * FROM R_Cliente_Archivio
WHERE (CodScaffaleInizio = 23 OR CodScaffaleFine = 23)
AND CodiceSezioneInizio = 1 AND CodiceSezioneFine = 1
AND ( CodicePianoInizio = 6 OR CodicePianoFine = 6)
--è vuota!

--controllo se per caso la posizione archivio sulla T_PeriodoPosizioneArchivioUtilizzata in produzione risulti sia occupata
/** 
	può succedere nel caso in cui è stato rimosso il setup ma sia rimasta nello storico una posizione da eliminare 
	in questi casi hai 2 opzioni:
	(i) Fai eliminare la riga nella T_PeriodoPosizioneArchivioUtilizzata
	(ii) Scegli un'altra posizione archivio e rifai i controlli
**/
SELECT * FROM [BTSQLCL05\BTSQLCL05].clc.dbo.T_PeriodoPosizioneArchivioUtilizzata tperiodo
JOIN S_PosizioneArchivio sposizione ON sposizione.IdPosizioneArchivio = tperiodo.IdPosizioneArchivio

WHERE sposizione.CodScaffale = 23 AND sposizione.CodiceSezione = 1 AND sposizione.CodicePiano = 6
--è vuota!

/* inserimento sulla R_Cliente_Archivio */
--INSERT INTO R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
SELECT 23 CodCliente
,695 CodTipoIncarico
,2 CodTipoArchiviazione --Tipi archiviazione: 1, singola (es: per CheBanca!); 2 per periodo (il nostro caso); 3 per documento
,23 CodScaffaleInizio
,1 CodiceSezioneInizio
,6 CodicePianoInizio
,1 CodiceScatolaInizio
,23 CodScaffaleFine
,1 CodiceSezioneFine
,6 CodicePianoFine
,4 CodiceScatolaFine
,9000 NumeroDocumenti --quindi questa posizione archivio verrà usata per 9000 documenti inseriti in incarichi del tipo 695
,0 FlagTemporaneo
,NULL CodDocumento

/* esegui procedura */
--EXEC Popola_S_PosizioneArchivio



USE clc

SELECT IdPosizioneArchivio, * FROM T_Documento
WHERE IdIncarico = 3554847

SELECT * FROM [BTSQLCL05\BTSQLCL05].clc.dbo.T_PeriodoPosizioneArchivioUtilizzata
WHERE IdPosizioneArchivio = 30002005005008


--SELECT * FROM R_Cliente_Archivio
--WHERE CodScaffaleInizio = 23 AND CodScaffaleFine = 23
--AND CodiceSezioneInizio = 1 AND CodiceSezioneFine =1
--AND CodicePianoInizio = 1 AND CodicePianoFine = 1


--EXEC Popola_S_PosizioneArchivio

