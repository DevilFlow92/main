DECLARE @CUR_DescrizioneMovimento VARCHAR(max)
, @CUR_IdContoBancarioPerAnno INT
, @CUR_DataValuta DATETIME
, @CUR_DataOperazione DATETIME
, @CUR_IdOperazioneContoBancario INT
, @CUR_Importo DECIMAL(18,4)
, @CUR_IdImport_Rendicontazione INT

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
	
	SELECT IdImport_RendicontazioneBP, IdContoBancarioPerAnno, DataValuta, DataOperazione, IdOperazioneContoBancario, ImportoMovimento, DescrizioneOperazione
	FROM rs.v_CESAM_AZ_Rendicontazione_BancoPopolare_Raggruppa

	SELECT * FROM rs.v_CESAM_AZ_Rendicontazione_BNP

OPEN cur

FETCH NEXT FROM cur INTO @cur_IdImport_Rendicontazione, @CUR_IdContoBancarioPerAnno, @CUR_DataValuta, @CUR_DataOperazione, @CUR_IdOperazioneContoBancario, @CUR_Importo, @CUR_DescrizioneMovimento

WHILE @@FETCH_STATUS = 0 BEGIN

	EXEC orga.Inserisci_MovimentoContoBancario @DescrizioneMovimento = @CUR_DescrizioneMovimento
											  ,@IdContoBancarioPerAnno = @CUR_IdContoBancarioPerAnno
											  ,@DataValuta = @CUR_DataValuta
											  ,@DataOperazione = @CUR_DataOperazione
											  ,@IdOperazioneContoBancario = @CUR_IdOperazioneContoBancario
											  ,@Importo = @CUR_Importo
											  ,@IdImport_Rendicontazione = @CUR_IdImport_Rendicontazione

	FETCH NEXT FROM cur INTO  @cur_IdImport_Rendicontazione, @CUR_IdContoBancarioPerAnno, @CUR_DataValuta, @CUR_DataOperazione, @CUR_IdOperazioneContoBancario, @CUR_Importo, @CUR_DescrizioneMovimento

END

CLOSE cur
DEALLOCATE cur