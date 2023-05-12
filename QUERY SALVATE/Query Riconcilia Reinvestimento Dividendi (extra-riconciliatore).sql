USE CLC_Cesam
GO


DECLARE @Cur_IdMovimento INT
,@Nota VARCHAR(255)

IF OBJECT_ID('tempdb.dbo.#tmpElenco') IS NOT NULL
begin	
	DROP TABLE #tmpElenco
end

SELECT IdMovimentoContoBancario, 'AUTO_'+Gruppo_Automatismo Nota
INTO #tmpElenco
FROM rs.v_CESAM_Rendicontazione_BNP_ElencoMovimenti
WHERE DataImport >= '20221101' --CONVERT(DATE,GETDATE())
AND Gruppo_Automatismo = 'REINV.DIVIDENDI'



DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
SELECT IdMovimentoContoBancario
	  ,Nota FROM #tmpElenco


OPEN cur

FETCH NEXT FROM cur INTO @Cur_IdMovimento,@Nota

WHILE @@FETCH_STATUS = 0 BEGIN

	EXEC orga.Salva_Riconciliazione_MovimentoContoBancario @InserisciTR = 0
														  ,@IdIncarico = 0
														  ,@IdMovimentoContoBancario = @Cur_IdMovimento
														  ,@FlagRiconciliato = 1
														  ,@FlagConfermato = 1
														  ,@NotaAggiuntiva = @Nota
														  ,@TipoRiconciliazione = 0
														  ,@EliminaDaTR = 0

	FETCH NEXT FROM cur INTO @Cur_IdMovimento, @Nota

END

CLOSE cur
DEALLOCATE cur


DROP TABLE #tmpElenco