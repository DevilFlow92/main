USE CLC
GO

/*
Gruppi da trasferire:

Operatori - Privilegi
Operazione Imbarco Mail
Generatore documenti
Dati Aggiuntivi
Note incarichi

*/

/* Gruppi Trasferiti

Workflowincarichi
Operatori QTask
Generale incarichi
Sospesi
Mailer
Abilitazioni operatori Q_Task
Controlli
Attività pianificate incarichi

*/



/*gruppo tabelle setup
	Archivio Qtask
*/
--------------------------------R_Cliente_Archivio--------------------------------
--Insert into R_Cliente_Archivio (CodCliente, CodTipoIncarico, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento)
select 48, 613, CodTipoArchiviazione, CodScaffaleInizio, CodiceSezioneInizio, CodicePianoInizio, CodiceScatolaInizio, CodScaffaleFine, CodiceSezioneFine, CodicePianoFine, CodiceScatolaFine, NumeroDocumenti, FlagTemporaneo, CodDocumento
 from [vp-btsql02].clc.dbo.R_Cliente_Archivio where codtipoincarico = 331 and codcliente = 48


 
 
/*gruppo tabelle setup
	Generale incarichi
	Extranet 3.0 - Richieste
	Aree incarichi QTask
*/
--------------------------------R_Cliente_TipoIncarico_Area--------------------------------
Insert into R_Cliente_TipoIncarico_Area (CodCliente, CodTipoIncarico, CodArea)
select 48, 613, CodArea
 from [vp-btsql02].clc.dbo.R_Cliente_TipoIncarico_Area where codtipoincarico = 331 and codcliente = 48
AND codarea = 8



--SELECT * FROM R_Cliente_Archivio

--WHERE CodCliente = 48
--AND CodTipoIncarico = 331