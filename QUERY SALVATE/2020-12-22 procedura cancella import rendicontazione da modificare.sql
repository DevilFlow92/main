USE CLC
GO

--ALTER PROCEDURE orga.CESAM_AZ_BPM_Cancella_ImportRendicontazione (@DataImport DATETIME, @DoDelete BIT, @FlagAZFund BIT, @FlagAFB BIT)
--as

DECLARE @DataImport DATETIME
,@DoDelete BIT 
,@FlagAZFund BIT 
,@FlagAFB BIT

SET @dataimport = '20201222'
SET @DoDelete = 0
SET @FlagAZFund = 1
SET @FlagAFB = 0

declare @success bit = 1

IF @DoDelete = 0
BEGIN 

	IF @FlagAZFund = 1 
	BEGIN
		SELECT * FROM T_MovimentoContoBancario 
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		AND abi = '03479'
		WHERE DataImport >= @DataImport
	
		SELECT * FROM T_R_Incarico_MovimentoContoBancario 
		JOIN dbo.T_MovimentoContoBancario on dbo.T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		AND abi = '03479'
		WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		
		SELECT * 
		FROM T_R_Incarico_MovimentoContoBancario
			LEFT JOIN T_MovimentoContoBancario on T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
			WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL
	
				SELECT * FROM T_PagamentoInvestimento 
		JOIN dbo.T_MovimentoContoBancario on dbo.T_PagamentoInvestimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		AND T_ContoBancario.abi = '03479'
		WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		
		SELECT * FROM scratch.T_R_ImportRendicontazione_Movimento
		JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
		AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in ('03479')
		WHERE scratch.L_Import_Rendicontazione_FlussoCBI.DataImport >= @DataImport
	
		SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
			JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62 = scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA
			AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in ('03479')
			where L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DataImport >= @dataimport
			
		SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI WHERE DataImport >= @dataimport AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente IN ('03479')
	END

	IF @FlagAFB = 1
	BEGIN
    			SELECT * FROM T_MovimentoContoBancario 
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		AND abi = '05034'
		WHERE DataImport >= @DataImport
	
		SELECT * FROM T_R_Incarico_MovimentoContoBancario 
		JOIN dbo.T_MovimentoContoBancario on dbo.T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		AND abi = '05034'
		WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		
		SELECT * 
		FROM T_R_Incarico_MovimentoContoBancario
			LEFT JOIN T_MovimentoContoBancario on T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
			WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL
	
				SELECT * FROM T_PagamentoInvestimento 
		JOIN dbo.T_MovimentoContoBancario on dbo.T_PagamentoInvestimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		AND T_ContoBancario.abi = '05034'
		WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		
		SELECT * FROM scratch.T_R_ImportRendicontazione_Movimento
		JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
		AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in ('05034')
		WHERE scratch.L_Import_Rendicontazione_FlussoCBI.DataImport >= @DataImport
	
		SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
			JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62 = scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA
			AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in ('05034')
			where L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DataImport >= @dataimport
			
		SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI WHERE DataImport >= @dataimport AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente IN ('05034')

    END
		
END


ELSE IF @DoDelete = 1
BEGIN

	begin transaction
	begin try
	    --main content of script here

		IF @FlagAZFund = 1
		BEGIN
			DELETE T_MovimentoContoBancario
			FROM T_MovimentoContoBancario 
			JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
			JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
			JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
			AND Abi = '03479'
			WHERE DataImport >= @DataImport

			DELETE T_R_Incarico_MovimentoContoBancario
			FROM T_R_Incarico_MovimentoContoBancario 
			JOIN dbo.T_MovimentoContoBancario on dbo.T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
			JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
			JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
			JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
			AND Abi = '03479'
			WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport

			DELETE T_R_Incarico_MovimentoContoBancario
			FROM T_R_Incarico_MovimentoContoBancario
			LEFT JOIN T_MovimentoContoBancario on T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
			WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL

        END
			   

		
		DELETE T_PagamentoInvestimento
		FROM T_PagamentoInvestimento 
		JOIN dbo.T_MovimentoContoBancario on dbo.T_PagamentoInvestimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		a
		WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		
		DELETE scratch.T_R_ImportRendicontazione_Movimento
		FROM scratch.T_R_ImportRendicontazione_Movimento
		JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
		AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in ('05034','03479')
		WHERE scratch.L_Import_Rendicontazione_FlussoCBI.DataImport >= @DataImport
			
			--/*
		DELETE scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
			--SELECT * 
			FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
		JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62 = scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA
		AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in ('05034','03479')
		where L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DataImport >= @DataImport

			DELETE FROM scratch.L_Import_Rendicontazione_FlussoCBI WHERE DataImport >= @dataimport AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente IN ('05034','03479')
			--*/
		
	end try
	begin catch
	    rollback transaction
	    set @success = 0
		SELECT ERROR_MESSAGE()
	end catch
	
	if(@success = 1)
	begin
	    commit transaction
	END
	
END

GO