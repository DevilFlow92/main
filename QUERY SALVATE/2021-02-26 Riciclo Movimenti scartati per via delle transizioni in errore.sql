USE CLC_Cesam
GO

DECLARE @Cur_IdMovimento INT
, @Cur_Nota VARCHAR(50)

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR

SELECT IdMovimentoContoBancario, 'Paperless_PAC'
FROM T_MovimentoContoBancario
WHERE IdMovimentoContoBancario IN (
0
)
AND NotaAggiuntiva NOT LIKE '%{paperless_pac}%'

UNION
SELECT IdMovimentoContoBancario, 'Paperless'
FROM T_MovimentoContoBancario
WHERE IdMovimentoContoBancario IN (
2041361


)
AND NotaAggiuntiva NOT LIKE '%{paperless}%'

OPEN cur

FETCH NEXT FROM cur INTO @Cur_IdMovimento,@Cur_Nota

WHILE @@FETCH_STATUS = 0 BEGIN

	EXEC orga.Salva_Riconciliazione_MovimentoContoBancario @InserisciTR = 0
														  ,@IdIncarico = 0
														  ,@IdMovimentoContoBancario = @Cur_IdMovimento
														  ,@FlagRiconciliato = 1
														  ,@FlagConfermato = 1
														  ,@NotaAggiuntiva = @Cur_Nota
														  ,@TipoRiconciliazione = 0
														  ,@EliminaDaTR = 0

	FETCH NEXT FROM cur INTO @Cur_IdMovimento,@Cur_Nota

END

CLOSE cur
DEALLOCATE cur


