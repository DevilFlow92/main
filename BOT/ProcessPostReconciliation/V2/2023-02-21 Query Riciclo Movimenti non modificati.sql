USE CLC_Cesam
GO

--Inserire gli idmovimento dove indicato e premere f5 su tutto lo script

DECLARE @Cur_IdMovimento INT
, @Cur_Nota VARCHAR(50)

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
SELECT IdMovimentoContoBancario, 'Paperless_PAC'
FROM T_MovimentoContoBancario
WHERE IdMovimentoContoBancario IN (
/* 
INSERIRE QUI TUTTI GLI IDMOVIMENTO DENTRO IL REPORT RICONCILIATO MOVIMENTO
CHE HANNO I SEGUENTI VALORI
Transizioni = 1
Modifica DB = 0
Gruppo = PAC
(se non ce ne sono, lasciare solo 0 )
*/

0


)
AND NotaAggiuntiva NOT LIKE '%{paperless_pac}%'

UNION
SELECT IdMovimentoContoBancario, 'Paperless'
FROM T_MovimentoContoBancario
WHERE IdMovimentoContoBancario IN (
/* 
INSERIRE QUI TUTTI GLI IDMOVIMENTO DENTRO IL REPORT RICONCILIATO MOVIMENTO
CHE HANNO I SEGUENTI VALORI
Transizioni = 1
Modifica DB = 0
Gruppo != PAC
(se non ce ne sono, lasciare solo 0 )
*/

0

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


