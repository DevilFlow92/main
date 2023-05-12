USE CLC_Cesam
GO


DECLARE @NumeroConto VARCHAR(100) = '802626100'

DECLARE @cur_DescrizioneMovimento VARCHAR(MAX)
,@Cur_IdContoBancarioPerAnno INt
,@Cur_DataValuta DATETIME
,@Cur_DataOperazione DATETIME
,@Cur_IdOperazioneContoBancario int
,@Cur_Importo DECIMAL(20,4)
,@Cur_IdImportRendicontazione INT
,@Cur_@IbanOrdinante VARCHAR(100)

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR

SELECT DescrizioneOperazione
,IdContoBancarioPerAnno
,DataValuta
,DataOperazione
,IdOperazioneContoBancario
,ImportoMovimento
,IdImport_RendicontazioneBP
,IbanOrdinante
FROM rs.v_CESAM_AZ_Rendicontazione_BancoPopolare_Raggruppa
WHERE Conto = @NumeroConto


OPEN cur

FETCH NEXT FROM cur INTO  @cur_DescrizioneMovimento 
,@Cur_IdContoBancarioPerAnno 
,@Cur_DataValuta 
,@Cur_DataOperazione 
,@Cur_IdOperazioneContoBancario 
,@Cur_Importo 
,@Cur_IdImportRendicontazione 
,@Cur_@IbanOrdinante 

WHILE @@FETCH_STATUS = 0 BEGIN

	EXEC orga.Inserisci_MovimentoContoBancario @DescrizioneMovimento = @cur_DescrizioneMovimento
											  ,@IdContoBancarioPerAnno = @Cur_IdContoBancarioPerAnno
											  ,@DataValuta = @Cur_DataValuta
											  ,@DataOperazione = @Cur_DataOperazione
											  ,@IdOperazioneContoBancario = @Cur_IdOperazioneContoBancario
											  ,@Importo = @Cur_Importo
											  ,@IdImport_Rendicontazione = @Cur_IdImportRendicontazione
											  ,@IbanOrdinante = @Cur_@IbanOrdinante

	FETCH NEXT FROM cur INTO  @cur_DescrizioneMovimento 
,@Cur_IdContoBancarioPerAnno 
,@Cur_DataValuta 
,@Cur_DataOperazione 
,@Cur_IdOperazioneContoBancario 
,@Cur_Importo 
,@Cur_IdImportRendicontazione 
,@Cur_@IbanOrdinante 

END

CLOSE cur
DEALLOCATE cur