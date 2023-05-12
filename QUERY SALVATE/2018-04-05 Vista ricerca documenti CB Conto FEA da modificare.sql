USE [CLC]
GO

/****** Object:  View [rs].[v_CESAM_CB_PresenzaDocumenti]    Script Date: 04/04/2018 11:59:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--ALTER VIEW [rs].[v_CESAM_CB_PresenzaDocumenti] AS

/*
Controllo sulla presenza dei seguenti documenti per gli incarichi di CB:

 - 8258		Dichiarazione primo contatto
 - 10001	HBRETAIL
 - 8257		Informativa regole di comportamento del consulente

NB: HBRETAIL è firmato da OGNI intestatario della squadra --> l'informazione è tracciabile con la T_DocumentoDataEntry

	Gli altri 2 sono unici per tutta la squadra 

*/


select anagrafica.IdPersona
              ,MAX(T_Incarico.IdIncarico) IdIncarico
			 ,Tipo_Documento
             ,max(Documento_id) Documento_id
             --,CodTipoIncarico
             --,1 as Presenza_Documento
			 --,IdDocumentoDataEntry
			 
                    FROM T_Documento
                                  --JOIN dbo.T_R_Incarico_Mandato  ON dbo.T_R_Incarico_Mandato.IdIncarico = dbo.T_Documento.IdIncarico 
                                  --JOIN dbo.T_Mandato  on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
                                  --JOIN dbo.T_Dossier on dbo.T_Mandato.IdDossier = dbo.T_Dossier.IdDossier
                                  --JOIN dbo.T_R_Dossier_Persona on dbo.T_Dossier.IdDossier = dbo.T_R_Dossier_Persona.IdDossier AND dbo.T_R_Dossier_Persona.Progressivo = 1 --primo intestatario
								  
								  join rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON anagrafica.IdIncarico = T_Documento.IdIncarico 
								  
				                  join T_Incarico  on anagrafica.IdIncarico = T_Incarico.IdIncarico

								  LEFT JOIN T_DocumentoDataEntry on anagrafica.idpersona = T_DocumentoDataEntry.IdPersona AND Documento_id = T_DocumentoDataEntry.IdDocumento

								  
                    WHERE 
                           FlagScaduto = 0 AND FlagPresenzaInFileSystem = 1 and 
                           T_Documento.Nome_file LIKE '%.pdf' 
                           AND (
								 (Tipo_Documento = 10001	--HBRETAIL
									and IdDocumentoDataEntry IS NOT NULL
								  )

								 OR Tipo_Documento  IN (8258		--Dichiarazione primo contatto
														,8257		--Informativa regole di comportamento del consulente
														)
								)
				    GROUP BY anagrafica.IdPersona
							 ,Tipo_Documento
							 --,Documento_id
							 --,IdDocumentoDataEntry

					--ORDER BY anagrafica.idpersona
		

GO

