USE clc
GO

--ALTER PROCEDURE supporto.CESAM_CB_Inserimento_TipoProdotto

--( 
--@idincarico INT
--)
--AS


--DECLARE @idincarico INT
--SET @idincarico = 8713005

BEGIN TRY

       --===========================================================================================================
       DECLARE @TipoProdotto VARCHAR(50)
				
				,@CodStatoWorkflowIncarico INT


	SET @CodStatoWorkflowIncarico = (SELECT CodStatoWorkflowIncaricoDestinazione 
	FROM L_WorkflowIncarico
	JOIN (SELECT MAX(IdTransizione) IdTransizione
											,IdIncarico
									 FROM L_WorkflowIncarico
									 WHERE CodStatoWorkflowIncaricoDestinazione in (14298
									 											,14314
																				,14315
																				,14551
																				,14553
																				,14554
																				)
									--AND CodStatoWorkflowIncaricoDestinazione = 14555
									AND IdIncarico = @IdIncarico
									GROUP BY IdIncarico		) wf on wf.IdTransizione = L_WorkflowIncarico.IdTransizione					
									 )

/*
14298	Predisposizione Conto Yellow
14314	Predisposizione Conto Digital
14315	Predisposizione Conto Deposito
14551	Predisposizione Conto Tascabile
14553	Predisposizione Conto Yellow Plurintestato
14554	Predisposizione Conto Digital Plurintestato
*/

BEGIN

             IF @CodStatoWorkflowIncarico  IN (14298,14553)
            
			 	SET @TipoProdotto = 'Conto Yellow'
         
		     ELSE if  @CodStatoWorkflowIncarico  IN (14314,14554)

				 SET @TipoProdotto = 'Conto Digital'
           
			 ELSE IF @CodStatoWorkflowIncarico = 14315
            
                   SET @TipoProdotto = 'Conto Deposito'
             
             ELSE IF @CodStatoWorkflowIncarico = 14551
            
                SET @TipoProdotto = 'Conto Tascabile'
             ELSE
			 SET @TipoProdotto = NULL
         

		 IF @TipoProdotto is NULL
		 BEGIN
         	PRINT 'Nessun Dato aggiuntivo da inserire'
         END
		ELSE
		IF EXISTS (SELECT * FROM T_DatoAggiuntivo where IdIncarico = @IdIncarico and FlagAttivo = 1)
		BEGIN
			PRINT 'update'
        	UPDATE T_DatoAggiuntivo
			SET Testo = @TipoProdotto
			WHERE CodTipoDatoAggiuntivo = 1208 AND IdIncarico = @IdIncarico and FlagAttivo = 1
        END
		ELSE 
		BEGIN
			PRINT 'insersico'
			INSERT INTO T_DatoAggiuntivo (IdIncarico, CodTipoDatoAggiuntivo, FlagAttivo, Testo)
			VALUES (@IdIncarico, 1208, 1, @TipoProdotto)
        END         
			 
       END
       
END TRY

BEGIN CATCH
  
	 SELECT @@error

END CATCH

GO