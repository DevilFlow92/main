USE CLC
GO

--ALTER PROCEDURE controlli.CESAM_CB_CheckListDocumentale (@IdRiga int ) AS 

--SELECT Codice,Descrizione,* FROM export.Z_Cliente_TipoIncarico_TipoDocumento 
--JOIN D_Documento on export.Z_Cliente_TipoIncarico_TipoDocumento.CodTipoDocumento = D_Documento.Codice
--WHERE CodCliente = 48 
--and CodTipoIncarico = 331

BEGIN TRY


       DECLARE      @RES_CodGiudizioControllo INT,
                    @RED_Note AS NVARCHAR(2000),
                    @RED_CodEsitoControllo VARCHAR(5)


       -- Dichiarazione variabili generali di controllo

       DECLARE @Esito INT
       DECLARE @Note VARCHAR(MAX)
       SET @RES_CodGiudizioControllo = 4
       SET @RED_Note = ''


       DECLARE @idincarico INT
       --SET @idincarico = --10435421 --cartaceo (conto digital)
						 --10437336 --conto FEA
						 --10437354 --dossier FEA


       SET @idincarico = @IdRiga

       DECLARE @checklist AS TABLE (
             documentochecklist INT,
             documentoincarico INT
             ,idpersonacheck INT
             ,idpersonaincarico int
             ,FlagPersona INT 
       )

       DECLARE @CodTipoIncarico INT
       SET @CodTipoIncarico = (SELECT CodTipoIncarico FROM T_Incarico WHERE IdIncarico = @idincarico)

       BEGIN

             WITH checklist
             AS (SELECT DISTINCT
                    T_Incarico.IdIncarico,
                    DocPrincipale.Tipo_Documento,
                    orga.CheckListDocumentale_CheBanca_Asset.tipodocumento
                    ,idpersona
                    ,FlagPersona
             FROM T_Incarico
             JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
                                                      AND T_Documento.FlagPresenzaInFileSystem = 1
                                                      AND T_Documento.FlagScaduto = 0

             LEFT JOIN (SELECT DISTINCT
                                        docprincipale.IdIncarico,
                                        docprincipale.Tipo_documento
             FROM T_Documento DocPrincipale
             WHERE DocPrincipale.FlagPresenzaInFileSystem = 1
                    AND DocPrincipale.FlagScaduto = 0
             ) DocPrincipale     ON DocPrincipale.IdIncarico = T_Incarico.IdIncarico
                                               AND T_Documento.Tipo_Documento = DocPrincipale.Tipo_Documento
             CROSS APPLY  orga.CheckListDocumentale_CheBanca_Asset(docprincipale.tipo_documento,@CodTipoIncarico,@idincarico)

             WHERE T_Incarico.IdIncarico = @idincarico)

             INSERT INTO @checklist (documentochecklist, documentoincarico, idpersonacheck, idpersonaincarico, FlagPersona)
                    SELECT DISTINCT
                           checklist.tipodocumento AS documentochecklist,
                           DocIncarico.Tipo_Documento AS documentoincarico
                           ,checklist.idpersona
                           ,DocIncarico.IdPersona
                           ,FlagPersona
                    FROM checklist

                                  LEFT JOIN (SELECT IdIncarico, Tipo_Documento, IdPersona FROM T_Documento
                                        LEFT JOIN T_DocumentoDataEntry on Documento_id = IdDocumento
                                        WHERE IdIncarico = @idincarico
                                        AND FlagPresenzaInFileSystem = 1 AND FlagScaduto = 0
                                        ) DocIncarico ON DocIncarico.IdIncarico = checklist.IdIncarico
                                               AND (
                                               
                                                      (FlagPersona = 0 AND DocIncarico.Tipo_Documento = checklist.tipodocumento)
                                               OR (FlagPersona = 1 AND DocIncarico.Tipo_Documento = checklist.tipodocumento and DocIncarico.IdPersona = checklist.idpersona)
                                               
                                               )
                    
       
       --SELECT * FROM   @checklist

       END

       BEGIN

             IF NOT EXISTS (SELECT
                           *
                    FROM @checklist
                    WHERE ((documentoincarico IS NULL
                                  OR ((idpersonaincarico IS NULL OR idpersonacheck <> idpersonaincarico) AND FlagPersona = 1)
                             ))                              
                                  )
                    AND EXISTS (SELECT
                                               *
                                        FROM @checklist)
             BEGIN
                    SET @RES_CodGiudizioControllo = 2
                    SET @RED_Note = 'Checklist completa'
             END

             ELSE
             
             IF NOT EXISTS (SELECT * FROM T_Documento where IdIncarico = @idincarico AND FlagPresenzaInFileSystem = 1 and FlagScaduto = 0)
             BEGIN
             SET @RES_CodGiudizioControllo = 2 --4
                    SET @RED_Note = 'Nessun Documento Presente'
             END
             ELSE
             BEGIN 
                    SET @RES_CodGiudizioControllo = 4
                    SET @RED_Note = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT
                           CAST((SELECT  
                                  D_OggettoControlli.Descrizione OggettoControllo,
                                  --doc.Descrizione + SPACE(1) + ISNULL('da associare a' + SPACE(1) + Cognome + SPACE(1) + Nome,'') d
                                  (SELECT DISTINCT
                                        doc1.Descrizione + SPACE(1) + ISNULL('da associare a' + SPACE(1) + Cognome + SPACE(1) + Nome,'') d
                                  FROM @checklist
                                  JOIN D_Documento doc1
                                        ON doc1.Codice = documentochecklist
                                  JOIN D_OggettoControlli
                                        ON doc1.CodOggettoControlli = D_OggettoControlli.Codice
                                  left JOIN T_Persona ON [@checklist].idpersonacheck = T_Persona.IdPersona
                                  WHERE doc1.CodOggettoControlli = doc.CodOggettoControlli
                                  AND (documentoincarico IS NULL
                                               OR ((idpersonaincarico IS NULL OR idpersonacheck <> idpersonaincarico) AND FlagPersona = 1)
                                        )
                                  FOR XML PATH, TYPE) 
                           FROM @checklist
                           JOIN D_Documento doc
                                  ON doc.Codice = documentochecklist
                           JOIN D_OggettoControlli
                                  ON doc.CodOggettoControlli = D_OggettoControlli.Codice
                           --LEFT JOIN T_Persona ON [@checklist].idpersonacheck = T_Persona.IdPersona
                           WHERE  ((documentoincarico IS NULL
                                        OR ((idpersonaincarico IS NULL OR idpersonacheck <> idpersonaincarico) AND FlagPersona = 1)
                                     ))
                           GROUP BY     
                           doc.CodOggettoControlli,
                           D_OggettoControlli.Descrizione
                                               --doc.Descrizione + SPACE(1) + ISNULL('da associare a' + SPACE(1) + Cognome + SPACE(1) + Nome,''),
                                               --doc.descrizione,
                                               
                           FOR XML PATH, TYPE)
                           AS VARCHAR(MAX)) 
                           Descrizione), '<row>', ''),'<OggettoControllo>',CHAR(10) + '['), '<d>', CHAR(13) + ' -'), '</OggettoControllo>', ']'), '</d>', ''), '</row>', '')



             --SELECT D_OggettoControlli.Descrizione OggettoControllo 
             --, (SELECT DISTINCT doc1.Descrizione d FROM @checklist
             --     JOIN D_Documento doc1 ON doc1.Codice = documentochecklist
             --     JOIN D_OggettoControlli ON doc1.CodOggettoControlli = D_OggettoControlli.Codice
             --     WHERE doc1.CodOggettoControlli = doc.CodOggettoControlli
             --     FOR XML PATH, TYPE 
             --     )       
             --FROM @checklist
             --JOIN D_Documento doc ON doc.Codice = documentochecklist
             --JOIN D_OggettoControlli ON doc.CodOggettoControlli = D_OggettoControlli.Codice
             --GROUP by D_OggettoControlli.Descrizione, doc.CodOggettoControlli
             --FOR XML PATH 


             END


       END




       SELECT
             @RES_CodGiudizioControllo AS CodGiudizioControllo,
             @RED_CodEsitoControllo AS CodEsitoControllo,
             ISNULL(LEFT(@RED_Note, 1000),'') AS note


END TRY

BEGIN CATCH
       PRINT 'Errore: inviare ad ORGA una segnalazione'
END CATCH

GO



