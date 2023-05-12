USE CLC
GO

ALTER PROCEDURE orga.ResetPassword24Ore
(@IdOperatore INT
	,@Forza bit
	
)

AS



/* Parametri input: decommentare tra le due linee per testare la SP */
--============================================
--DECLARE @IdOperatore INT 
--		,@Forza BIT

--SET @IdOperatore =  --12701 --Fiori L.
				    --12798 Spanu
					--10220 Pedro
--SET @Forza = 1

--============================================


/* Parametri intermedi - Non Modificare */
--=================================================================================
DECLARE @Username VARCHAR(50)
		,@Reset VARCHAR(MAX)

SET @Username = (SELECT UserName FROM S_Operatore where IdOperatore = @IdOperatore)

SET @Reset = (
			  SELECT 'Reset effettuato'	+ CHAR(13) 
					+ 'L''utente può ora accedere con:' + CHAR(13)
					+ CHAR(8) + 'Username: ' + UserName + CHAR(10)
					+ CHAR(8) + 'Password: ' + PasswordDefault 

			  FROM S_Operatore 
			  WHERE IdOperatore = @IdOperatore
			  )
--=================================================================================


IF @Forza = 0
	IF NOT EXISTS (SELECT * FROM L_Password 
					WHERE IdOperatore = @IdOperatore 
					AND DataInserimento >= DATEADD(HOUR,-24,GETDATE())
				  )
	BEGIN
		PRINT 'Ultima password inserita più di 24 ore fa.' + CHAR(10) 
			+ 'Eseguire prima il reset attraverso gli altri canali (reset password in autonomia o reset password da setup operatori)' + CHAR(10) 
			+ 'Se il problema persiste impostare nella SP @Forza = 1'
	END
	
	ELSE
	BEGIN

		PRINT 'Pulizia ultima password in corso'

    	DELETE FROM L_Password
		WHERE IdOperatore = @IdOperatore
		AND DataInserimento >= DATEADD(HOUR,-24,GETDATE())

		DELETE FROM L_CambioPassword
		WHERE Username = @Username
		AND DataTentativo >= DATEADD(HOUR,-24,GETDATE())

		DELETE FROM T_AccessoOperatore WHERE IdOperatore = @IdOperatore

		PRINT @Reset

    END
else
BEGIN
	PRINT 'Pulizia Storico Password in corso'
	
	DELETE FROM L_Password where IdOperatore = @IdOperatore
	DELETE FROM L_CambioPassword WHERE Username = @Username
	DELETE FROM T_AccessoOperatore where IdOperatore = @IdOperatore
	
	PRINT @Reset

END

GO

