USE CLC
GO

DECLARE @Ciao AS VARCHAR(10)
		,@CorpoTicket AS VARCHAR(MAX)
		,@CorpoMailUtenza AS VARCHAR(MAX)
		,@CorpoMailPassword1 AS VARCHAR(MAX)
		,@CorpoMailPassword2 AS VARCHAR(MAX)


SET @Ciao = 'Ciao,' 
SET @CorpoTicket = 'la presente per informarvi che abbiamo gestito il ticket creando l''utenza QTask come richiesto.' + char(13)
			+ 'Verranno inviate in privato le credenziali all''utente interessato.' + char(13) + char(10) 


SET @CorpoMailUtenza = 'di seguito l''utenza che dovrai utilizzare per accedere su QTask per la lavorazione delle pratiche CESAM.' + char(13) 
			+ 'A breve riceverai la mail separata con la password.' 
SET @CorpoMailPassword1 = 'come da intese ecco la password per accedere a QTask:' 
SET @CorpoMailPassword2 = 'Al primo accesso il sistema chiederà di sostituire la Pre-Password con la Password definitiva. Nel campo "Vecchia Password" dovrai inserire la Pre-Password specificata sopra, nei campi "Nuova Password" e "Conferma nuova Password" dovrai  specificare la nuova password di accesso da te selezionata.' + CHAR(13)
							+ 'Il criterio di scelta della nuova password d’accesso dovrà essere conforme alle seguenti regole:' + CHAR(13) 
							+ '1.      Minimo 10 caratteri;'										+ char(10)
							+ '2.      Almeno una lettera maiuscola;'								+ char(10)
							+ '3.      Almeno una lettera minuscola;'								+ char(10)
							+ '4.      Almeno un numero;'											+ char(10)
							+ '5.      Non contenere dati relativi alle tue  generalità.'			+ char(10)

							+ 'Ti ricordiamo che il sistema è case-sensitive quindi occorre rispettare la sequenza di maiuscole e minuscole.' + CHAR(10)
							+ 'A disposizione'

SELECT @Ciao + CHAR(10) + @CorpoTicket MailChiusuraTicket
	 ,'Ciao ' + Nome + ','+ char(10) + 
		@CorpoMailUtenza + CHAR(10) + 'Username: ' + UserName EmailUtenza
	 ,@Ciao + CHAR(10) + @CorpoMailPassword1 + ' ' + PasswordDefault + CHAR(13) + @CorpoMailPassword2 EmailPassword
	 ,username
	 ,PasswordDefault
	 ,EMail
	 ,'Attivazione Utenza QTask - ' + UserName SubjectUser
	 ,'Attivazione Utenza QTask - ' + UserName + ' - Comunicazione Password Primo Accesso' SubjectPassword
	 ,'Utenza QTask creata con il Profilo Accesso ' + CAST(CodProfiloAccesso AS VARCHAR(5)) + ' - ' + Descrizione Resolution
	
 FROM S_Operatore
 JOIN D_ProfiloAccesso ON S_Operatore.CodProfiloAccesso = D_ProfiloAccesso.Codice
WHERE IdOperatore IN (

/**** INSERISCI QUI GLI IDOPERATORE CREATI *****/
17001,
17000
)

/*
Grazie,

--------------------------------------------------
xxxxxxxxx xxxxx

Innovation Center
Digital Process Engineering | Financial Services

Gruppo MutuiOnline S.p.A. | BPO Division
Prolung. via Igola, sn - 09122 Cagliari - Italy 
Ph.  +39 02.83.44.2966
--------------------------------------------------

*/


