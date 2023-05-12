--ALTER PROCEDURE orga.CESAM_AZ_BPM_Cancella_ImportRendicontazione (@DataImport DATETIME, @DoDelete BIT,@FlagBNP_AZFund BIT, @FlagBPM_AFB BIT)
--as

EXEC orga.CESAM_AZ_BPM_Cancella_ImportRendicontazione @DataImport = '2020-12-04'
													 ,@DoDelete = 0
													 ,@FlagBNP_AZFund = 0
													 ,@FlagBPM_AFB = 1


DECLARE @DataImport DATETIME
,@DoDelete BIT 
,@FlagBNP_AZFund BIT
,@FlagBPM_AFB BIT

SET @dataimport = '20201204'
SET @DoDelete = 0
SET @FlagBNP_AZFund = 1
SET @FlagBPM_AFB = 0

declare @success bit = 1

IF OBJECT_ID('tempdb.dbo.#tmpMovimenti') IS NOT NULL
	DROP TABLE #tmpMovimenti


CREATE TABLE #tmpMovimenti
(
	IdMovimentoContoBancario INT PRIMARY KEY,
	IdContoBancarioPerAnno INT,
	ABI VARCHAR(10)
)


IF @FlagBNP_AZFund = 1
BEGIN
	INSERT INTO #tmpMovimenti (IdMovimentoContoBancario, IdContoBancarioPerAnno, ABI)
	SELECT IdMovimentoContoBancario, T_ContoBancarioPerAnno.IdContoBancarioPerAnno, Abi
	FROM T_MovimentoContoBancario
	JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
	JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
	AND Abi = '03479' --AND NumeroConto = '802260103'
	WHERE DataImport >= @DataImport

END

IF @FlagBPM_AFB = 1
BEGIN
	INSERT INTO #tmpMovimenti (IdMovimentoContoBancario, IdContoBancarioPerAnno, ABI)
		SELECT IdMovimentoContoBancario, T_ContoBancarioPerAnno.IdContoBancarioPerAnno, Abi
	FROM T_MovimentoContoBancario
	JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
	JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
	AND Abi = '05034' --AND NumeroConto = '70040'
	WHERE DataImport >= @DataImport

END

IF @DoDelete = 0

BEGIN 

	--SELECT * FROM T_MovimentoContoBancario 
	--JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
	--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
	--	AND Abi = '03479' AND NumeroConto = '802260103'
	--JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
	--WHERE DataImport >= @dataimport
	
	--SELECT * FROM T_R_Incarico_MovimentoContoBancario 
	--JOIN dbo.T_MovimentoContoBancario on dbo.T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
	--JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
	--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
	--	AND Abi = '03479' AND NumeroConto = '802260103'
	--JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
	--WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport

	--	SELECT * 
	--	FROM T_R_Incarico_MovimentoContoBancario
	--	LEFT JOIN T_MovimentoContoBancario on T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
	--	WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL
	
	--SELECT * FROM T_PagamentoInvestimento 
	--JOIN dbo.T_MovimentoContoBancario on dbo.T_PagamentoInvestimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
	--JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
	--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
	--	AND T_contobancario.Abi = '03479' AND NumeroConto = '802260103'
	--JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
	--WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
	
	--SELECT * FROM scratch.T_R_ImportRendicontazione_Movimento
	--JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
	--AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in (--'05034',
	--'03479')
	--WHERE scratch.L_Import_Rendicontazione_FlussoCBI.DataImport >= @DataImport

	--	--/*
	--	SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
	--	JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62 = scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA
	--	AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in (--'05034',
	--	'03479')
	--	where L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DataImport >= @dataimport

	--	SELECT * FROM scratch.L_Import_Rendicontazione_FlussoCBI WHERE DataImport >= @dataimport AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente IN (--'05034',
	--	'03479')
	--	--*/


	SELECT * FROM T_MovimentoContoBancario
	JOIN #tmpMovimenti ON T_MovimentoContoBancario.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario
	AND T_MovimentoContoBancario.IdContoBancarioPerAnno = #tmpMovimenti.IdContoBancarioPerAnno

	SELECT * FROM T_R_Incarico_MovimentoContoBancario
	JOIN #tmpMovimenti ON T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario


	SELECT * FROM T_R_Incarico_MovimentoContoBancario
	LEFT JOIN T_MovimentoContoBancario ON T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
	WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL

	SELECT * FROM T_PagamentoInvestimento
	JOIN #tmpMovimenti ON T_PagamentoInvestimento.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

	SELECT * 
	FROM #tmpMovimenti
	JOIN scratch.T_R_ImportRendicontazione_Movimento ON #tmpMovimenti.IdMovimentoContoBancario = T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario
	AND #tmpMovimenti.IdContoBancarioPerAnno = T_R_ImportRendicontazione_Movimento.IdContoBancarioPerAnno
	JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
	JOIN scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi ON Chiave_62 = Chiave_62_DA

	where L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DataImport >= @dataimport
	--ORDER BY Id_Import_RendicontazioneBP_DatiAggiuntivi


	SELECT * FROM scratch.T_R_ImportRendicontazione_Movimento
	JOIN #tmpMovimenti ON T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

	SELECT DataImport, * FROM scratch.L_Import_Rendicontazione_FlussoCBI 
	JOIN (SELECT DISTINCT abi from #tmpMovimenti) tmp ON RH_Mittente = ABI
	AND DataImport >= @DataImport


END


ELSE IF @DoDelete = 1
BEGIN

	begin transaction
	begin try
	    --main content of script here
		--DELETE T_MovimentoContoBancario
		--FROM T_MovimentoContoBancario 
		--JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		--AND Abi = '03479' AND NumeroConto = '802260103'
		--JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		--WHERE DataImport >= @dataimport
	
		--DELETE T_R_Incarico_MovimentoContoBancario
		--FROM T_R_Incarico_MovimentoContoBancario 
		--JOIN dbo.T_MovimentoContoBancario on dbo.T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		--JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		--AND Abi = '03479' AND NumeroConto = '802260103'
		--JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		--WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		

		--DELETE T_R_Incarico_MovimentoContoBancario
		--FROM T_R_Incarico_MovimentoContoBancario
		--LEFT JOIN T_MovimentoContoBancario on T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
		--WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL
		
		--DELETE T_PagamentoInvestimento
		--FROM T_PagamentoInvestimento 
		--JOIN dbo.T_MovimentoContoBancario on dbo.T_PagamentoInvestimento.IdMovimentoContoBancario = dbo.T_MovimentoContoBancario.IdMovimentoContoBancario
		--JOIN dbo.T_ContoBancarioPerAnno on dbo.T_MovimentoContoBancario.IdContoBancarioPerAnno = dbo.T_ContoBancarioPerAnno.IdContoBancarioPerAnno
		--JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
		--AND T_ContoBancario.Abi = '03479' AND NumeroConto = '802260103'
		--JOIN dbo.T_Incarico on dbo.T_ContoBancarioPerAnno.IdIncarico = dbo.T_Incarico.IdIncarico and dbo.T_Incarico.CodCliente = 23
		--WHERE dbo.T_MovimentoContoBancario.DataImport >= @dataimport
		
		--DELETE scratch.T_R_ImportRendicontazione_Movimento
		--FROM scratch.T_R_ImportRendicontazione_Movimento
		--JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.IdImport_RendicontazioneBP = scratch.T_R_ImportRendicontazione_Movimento.IdImport_Rendicontazione
		--AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in (--'05034',
		--'03479'
		--)
		--WHERE scratch.L_Import_Rendicontazione_FlussoCBI.DataImport >= @DataImport
			
		--	--/*
		--DELETE scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
		--	--SELECT * 
		--	FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi 
		--JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62 = scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.Chiave_62_DA
		--AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente in (--'05034',
		--'03479'
		--)
		--where L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi.DataImport >= @DataImport

		--	DELETE FROM scratch.L_Import_Rendicontazione_FlussoCBI WHERE DataImport >= @dataimport AND scratch.L_Import_Rendicontazione_FlussoCBI.RH_Mittente IN (--'05034',
		--	'03479'
		--	)
		--	--*/
		
		DELETE tm
		FROM T_MovimentoContoBancario tm
		JOIN #tmpMovimenti ON tm.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

		DELETE trimcb
		FROM T_R_Incarico_MovimentoContoBancario trimcb
		JOIN #tmpMovimenti ON trimcb.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

		DELETE trimcb2
		FROM T_R_Incarico_MovimentoContoBancario trimcb2
		LEFT JOIN T_MovimentoContoBancario ON trimcb2.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
		WHERE T_MovimentoContoBancario.IdMovimentoContoBancario IS NULL

		DELETE tpi
		FROM T_PagamentoInvestimento tpi
		JOIN #tmpMovimenti ON tpi.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

		DELETE cbi
		FROM scratch.L_Import_Rendicontazione_FlussoCBI_DatiAggiuntivi cbi
		JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON scratch.L_Import_Rendicontazione_FlussoCBI.Chiave_62 = cbi.Chiave_62_DA
		JOIN scratch.T_R_ImportRendicontazione_Movimento ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
		JOIN #tmpMovimenti ON T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario
		where cbi.DataImport >= @dataimport

		DELETE tr
		FROM scratch.T_R_ImportRendicontazione_Movimento tr
		JOIN #tmpMovimenti ON tr.IdMovimentoContoBancario = #tmpMovimenti.IdMovimentoContoBancario

		DELETE cbi2
		FROM scratch.L_Import_Rendicontazione_FlussoCBI cbi2
		JOIN (SELECT DISTINCT abi from #tmpMovimenti) tmp ON RH_Mittente = ABI
		AND DataImport >= @DataImport


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