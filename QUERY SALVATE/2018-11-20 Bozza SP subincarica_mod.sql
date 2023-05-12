/*
Author: A. Padricelli
Description:  subincarica automaticamente incarichi con la stessa squadra
Date: 20180206

*/
--ALTER PROCEDURE controlli.CESAM_CB_Subincarica_CC_Dossier

--( 
--@IdRiga INT
--)
--AS

DECLARE @idriga INT 
SET @idriga = --9940447  --dossier

11314548 --11314704 --9940414    --cc
    
       

BEGIN TRY


DECLARE 
       @RES_CodGiudizioControllo int, 
       @RED_Note as nvarchar(255),
       @RED_CodEsitoControllo varchar(5)
       
--T Dichiarazione variabili generali di controllo

DECLARE @Esito INT
DECLARE @Note VARCHAR(MAX)
SET @RES_CodGiudizioControllo=2
SET @RED_Note=''

DECLARE @IdIncarico INT
SET @IdIncarico = @IdRiga




--      IF EXISTS (SELECT *from t_incarico
--left join T_MacroControllo on T_MacroControllo.idincarico = t_incarico.idincarico
--left join t_controllo on t_controllo.IdMacroControllo = T_MacroControllo.IdMacroControllo
--where t_incarico.idincarico = @IdIncarico
--and IdTipoControllo in  (1866) --verifica documentazione anagrafica

--       )  
--TRA I DUE SEPARATORI INSERIRE I COMANDI DELLA SP
--===========================================================================================================
DECLARE @CodTipoIncarico INT
SET @CodTipoIncarico = (SELECT CodTipoIncarico FROM T_Incarico where IdIncarico = @IdIncarico)


BEGIN

       IF @CodTipoIncarico = 335
       BEGIN
             PRINT 'cc'
             --verifico che non ci sia già subincarico

             --se non c'è cerco il subincarico e lo associo
             IF EXISTS (SELECT IdRelazione FROM T_R_Incarico_SubIncarico where IdIncarico = @IdIncarico OR IdSubIncarico = @IdIncarico)
                    BEGIN
                           SET @RES_CodGiudizioControllo = 2
                           SET @RED_Note = 'Incarico Dossier - Già subincaricato'
                    END
             ELSE
                    BEGIN
                           --subincarico
                           --INSERT into T_R_Incarico_SubIncarico (IdIncarico, IdSubIncarico, FlagArchiviato)
                           SELECT DISTINCT T_Incarico.IdIncarico incaricocc
                           ,dossier.IdIncarico incaricoDossier
                           ,0
                           --,anagraficacc.idpersona
                           --,anagraficacc.idpromotore
                           FROM T_Incarico
                           LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc 
                                               on T_Incarico.IdIncarico = anagraficacc.IdIncarico and anagraficacc.ProgressivoPersona = 1
                LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc2 
                                               on T_Incarico.IdIncarico = anagraficacc2.IdIncarico and anagraficacc2.ProgressivoPersona = 2
                           LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc3 
                                               on T_Incarico.IdIncarico = anagraficacc3.IdIncarico and anagraficacc3.ProgressivoPersona = 3
                           LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc4 
                                               on T_Incarico.IdIncarico = anagraficacc4.IdIncarico and anagraficacc4.ProgressivoPersona = 4
							LEFT JOIN T_DatoAggiuntivo ON T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico
								AND CodTipoDatoAggiuntivo = 934 --ID opportunita
								 AND FlagAttivo = 1

                           JOIN (SELECT DISTINCT  anagraficadossier.idpersona
                                                        ,anagraficadossier.idpromotore
                                                        ,T_Incarico.IdIncarico,anagraficadossier.ProgressivoPersona
                                                        ,anagraficadossier.codruolorichiedente 
                                                        ,anagraficadossier2.idpersona idpersona2
                                                        ,anagraficadossier2.codruolorichiedente codruolorichiedente2
                                                        ,anagraficadossier3.idpersona idpersona3
                                                        ,anagraficadossier3.codruolorichiedente codruolorichiedente3
                                                        ,anagraficadossier4.idpersona idpersona4
                                                        ,anagraficadossier4.codruolorichiedente codruolorichiedente4
														,Testo IdOpportunitaAssociato
                                        FROM T_Incarico
                         LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier 
                                               ON T_Incarico.IdIncarico = anagraficadossier.IdIncarico AND anagraficadossier.ProgressivoPersona = 1
                                        LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier2 
                                               ON T_Incarico.IdIncarico = anagraficadossier2.IdIncarico AND anagraficadossier2.ProgressivoPersona = 2
                                        LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier3 
                                               ON T_Incarico.IdIncarico = anagraficadossier3.IdIncarico AND anagraficadossier3.ProgressivoPersona = 3
                                        LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier4
                                               ON T_Incarico.IdIncarico = anagraficadossier4.IdIncarico AND anagraficadossier4.ProgressivoPersona = 4
										LEFT JOIN T_DatoAggiuntivo on T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico
										AND CodTipoDatoAggiuntivo = 1192 --ID OPPORTUNITA CONTO ASSOCIATO
										AND FlagAttivo = 1
                                    WHERE CodTipoIncarico = 334 AND CodArea = 8 AND CodStatoWorkflowIncarico NOT IN (440
,14275
,14305)
                           ) dossier ON anagraficacc.idpersona = dossier.idpersona AND anagraficacc.idpromotore = dossier.idpromotore AND anagraficacc.ProgressivoPersona = dossier.ProgressivoPersona
                                  AND anagraficacc.codruolorichiedente = dossier.codruolorichiedente

                                                      AND ((dossier.idpersona2 is NULL AND anagraficacc2.idpersona is NULL) OR (dossier.idpersona2 IS NOT NULL and anagraficacc2.idpersona = dossier.idpersona2))
                                                      AND ((dossier.idpersona3 is NULL AND anagraficacc3.idpersona is NULL) OR (dossier.idpersona3 IS NOT NULL and anagraficacc3.idpersona = dossier.idpersona3))
                                                      AND ((dossier.idpersona4 is NULL AND anagraficacc4.idpersona is NULL) OR (dossier.idpersona4 IS NOT NULL and anagraficacc4.idpersona = dossier.idpersona4))
								  AND dossier.IdOpportunitaAssociato = Testo
                           WHERE T_Incarico.CodTipoIncarico = 335 AND T_Incarico.IdIncarico = @IdIncarico     AND CodArea = 8

                           IF EXISTS (SELECT IdRelazione FROM T_R_Incarico_SubIncarico where IdIncarico = @IdIncarico)
                           BEGIN
                                  SET @RES_CodGiudizioControllo = 2
                                  SET @RED_Note = 'Subincarico Dossier inserito'
                           END
                           ELSE
                           BEGIN
                                  SET @RES_CodGiudizioControllo = 2
                                  SET @RED_Note = 'Non esiste un Dossier corrispondente'
                           END
                    END

       END

       ELSE 
       
       BEGIN
             PRINT 'dossier'
             --verifico che non ci sia già subincarico

             --se non c'è cerco il subincarico e lo associo
             IF EXISTS (SELECT IdRelazione FROM T_R_Incarico_SubIncarico where IdIncarico = @IdIncarico OR IdSubIncarico = @IdIncarico)
                    BEGIN
                           SET @RES_CodGiudizioControllo = 2
                           SET @RED_Note = 'Incarico CC - Già subincaricato'
                    END
             ELSE
                    BEGIN
                           --subincarico
                           INSERT into T_R_Incarico_SubIncarico (IdIncarico, IdSubIncarico, FlagArchiviato)
                           SELECT DISTINCT cc.IdIncarico incaricocc
                           ,T_Incarico.IdIncarico incaricodossier
                           ,0
       --                    ,anagraficacc.idpersona
       --                    ,anagraficacc.idpromotore
                                        --  ,cc.idpersona2
                                        --  ,anagraficacc2.idpersona p2

                                        --  ,cc.idpersona3
                                               --,anagraficacc3.idpersona p3
                                        --  ,cc.idpersona4
                                        --  ,anagraficacc4.idpersona p4
                                           
                 FROM T_Incarico
                              LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc on T_Incarico.IdIncarico = anagraficacc.IdIncarico and anagraficacc.ProgressivoPersona = 1
                   LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc2 on T_Incarico.IdIncarico = anagraficacc2.IdIncarico and anagraficacc2.ProgressivoPersona = 2
                              LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc3 on T_Incarico.IdIncarico = anagraficacc3.IdIncarico and anagraficacc3.ProgressivoPersona = 3
                              LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficacc4 on T_Incarico.IdIncarico = anagraficacc4.IdIncarico and anagraficacc4.ProgressivoPersona = 4                                
                          
                              JOIN (SELECT DISTINCT anagraficadossier.idpersona
                                                                     ,anagraficadossier.idpromotore
                                                                     ,T_Incarico.IdIncarico,anagraficadossier.ProgressivoPersona
                                                                     ,anagraficadossier.codruolorichiedente 

                                                                     ,anagraficadossier2.idpersona idpersona2
                                                                     ,anagraficadossier2.codruolorichiedente codruolorichiedente2
                                                                     ,anagraficadossier3.idpersona idpersona3
                                                                     ,anagraficadossier3.codruolorichiedente codruolorichiedente3
                                                                      ,anagraficadossier4.idpersona idpersona4
                                                                     ,anagraficadossier4.codruolorichiedente codruolorichiedente4

                                               FROM T_Incarico
                             LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier ON T_Incarico.IdIncarico = anagraficadossier.IdIncarico AND anagraficadossier.ProgressivoPersona = 1
                                               LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier2 ON T_Incarico.IdIncarico = anagraficadossier2.IdIncarico AND anagraficadossier2.ProgressivoPersona = 2
                                               LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier3 ON T_Incarico.IdIncarico = anagraficadossier3.IdIncarico AND anagraficadossier3.ProgressivoPersona = 3
                                               LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagraficadossier4 ON T_Incarico.IdIncarico = anagraficadossier4.IdIncarico AND anagraficadossier4.ProgressivoPersona = 4


                                                      -- JOIN T_Documento on T_Incarico.IdIncarico = T_Documento.IdIncarico
                                                            --AND Tipo_Documento = 8275       --Modulo di apertura Conto Yellow 
                                                            --AND FlagPresenzaInFileSystem = 1 AND FlagScaduto = 0
                                            
                                            WHERE CodTipoIncarico = 335 AND CodArea = 8 AND CodStatoWorkflowIncarico NOT IN (440
,14275
,14305)

                           ) cc ON anagraficacc.idpersona = cc.idpersona AND anagraficacc.idpromotore = cc.idpromotore AND anagraficacc.ProgressivoPersona = cc.ProgressivoPersona
                                  AND anagraficacc.codruolorichiedente = cc.codruolorichiedente

                                                      AND ((cc.idpersona2 is NULL AND anagraficacc2.idpersona is NULL) OR (cc.idpersona2 IS NOT NULL and anagraficacc2.idpersona = cc.idpersona2))
                                                      AND ((cc.idpersona3 is NULL AND anagraficacc3.idpersona is NULL) OR (cc.idpersona3 IS NOT NULL and anagraficacc3.idpersona = cc.idpersona3))
                                                      AND ((cc.idpersona4 is NULL AND anagraficacc4.idpersona is NULL) OR (cc.idpersona4 IS NOT NULL and anagraficacc4.idpersona = cc.idpersona4))

                           WHERE T_Incarico.CodTipoIncarico = 334 and T_Incarico.IdIncarico = @IdIncarico AND CodArea = 8 

                           IF EXISTS (SELECT IdRelazione FROM T_R_Incarico_SubIncarico where IdIncarico = @IdIncarico)
                           BEGIN
                                  SET @RES_CodGiudizioControllo = 2
                                  SET @RED_Note = 'Subincarico CC inserito'
                           END
                           ELSE
                           BEGIN
                                  SET @RES_CodGiudizioControllo = 2
                                  SET @RED_Note = 'Non esiste un CC corrispondente'
                           END
                    END
       END
       
       --SELECT @CodTipoIncarico tipoincarico
END       
--===========================================================================================================



select       @RES_CodGiudizioControllo as CodGiudizioControllo,
             @RED_CodEsitoControllo  as CodEsitoControllo ,
                    @RED_Note as Note

       

End Try

Begin Catch
PRINT 'Errore: inviare ad ORGA una segnalazione'
End Catch

GO