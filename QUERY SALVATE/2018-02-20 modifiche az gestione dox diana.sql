use clc
GO


SELECT
	MB.IdMailbox
   ,S_MailboxImbarcoIncarichi.Descrizione AS Mailbox
   ,MB.Volume
   ,MB.DataInserimento AS Ritardo
FROM CacheCLC.rs.v_InboxMailboxCesam AS MB WITH (NOLOCK)
INNER JOIN S_MailboxImbarcoIncarichi WITH (NOLOCK)
	ON S_MailboxImbarcoIncarichi.IdMailbox = MB.IdMailbox
WHERE (MB.IdMailbox IN (54, 38, 32, 55, 75, 76))


--eliminare 55
--aggiungere az switch PEC

SELECT * FROM S_MailboxImbarcoIncarichi where Descrizione LIKE '%switch PEC%'
--id mailbox 623
--non è presente nella vista di cache clc, che serve per avere le informazioni sul volume ed il ritardo. Bisogna modificare la vista


--Classificazione documenti --> aggiungere i pacchetti da classificare da "Ephesoft" (punto aperto)


-- Gestione Incarichi QTask
--		ogni tipo di incarico ha una tabella a se ed un report a se...
--quindi per eliminare --> nascondere le tabelle  fatto

--inserimento fatca-crs --> fatto

--Variazione anagrafica eliminazione stati wf in gestione/da acquisire, sospesa/da lavorare, in gestione/da rilavorare --> fatto

SELECT DISTINCT Codice, Descrizione, CodMacroStatoWorkflowIncarico FROM D_StatoWorkflowIncarico
join R_Cliente_TipoIncarico_MacroStatoWorkFlow on Codice = CodStatoWorkflowIncarico
where CodCliente = 23 and CodStatoWorkflowIncarico IN (6500, 6550, 6551, 8520)

--6550	Da lavorare		9
--6551	Da RiLavorare	9
--8520	Da Acquisire	9
--6500	Creata			12


--inserimento Mifid - Contratti di consulenza , stati wf "nuova creata" con doc inserito, in gestione/acquisita a partire dal 01/07/2017 --> fatto

--inserimento anagrafiche antiriciclaggio, stati wf nuova creata con doc inserito, in gestione/acquisita a partire dal 01/09/2017

--inserimento bonifica anagrafica - adv in scadenza, stati wf nuova creata con attributo integrazioni ricevute + in gestione/da acquisire --> fatto

--inserimento censimento cliente, stati wf nuova creata con doc inserito + in gestione/da acquisire + attesa NO --> fatto

--inserimento MIFID - Schede Finanziarie nello stato “Nuova – creata” con documento inserito + “In gestione – da acquisire; --> fatto



--schedulazione: prima mail alle 08:00


SELECT * FROM T_Incarico
where CodTipoIncarico = 55

AND CodStatoWorkflowIncarico = 6500
AND DataUltimaModifica >= '2018-01-01'

use clc
SELECT * FROM D_AttributoIncarico where Descrizione LIKE '%integr%'
