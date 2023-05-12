USE CLC
GO

--EXEC export.CESAM_AZ_Documenti_PREVINET


/*Author: A. Padricelli 
	Date: 06/12/2016
	Description: utilizzata dalla tabella di spooling [export].[CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI] 
											dalla VISTA [rs].[v_CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI]
											e dal task per il trasferimento giornaliero documenti ICBPI fondi pensione (G.Salvo)

*/


--ALTER PROCEDURE export.CESAM_AZ_Documenti_PREVINET AS


BEGIN
	IF OBJECT_ID(N'tempdb..##tempcurpersona', N'U') IS NOT NULL 
    DROP TABLE ##tempcurpersona;

    CREATE TABLE ##tempcurpersona (idincarico INT 
      ,idpersona INT
      ,chiavecliente varchar(max)
      ,codtipoincarico INT
      ,descrizioneincarico varchar(max)
      ,documento_id INT
      ,tipo_documento INT
      ,nomefile_input varchar(max)
      ,idrepository INT
      ,percorsocompleto varchar(max)
      ,NamingCartellaZip varchar(max)
      ,nomedocumentopdf varchar(max)
      ,StringaCSV varchar(max)
	  ,tiporecord INT
								)

--insert sulla tabella temporanea della documentazione per icbpi (sulla quale gira il cursore)
insert into ##tempcurpersona (idincarico
      ,idpersona 
      ,chiavecliente 
      ,codtipoincarico 
      ,descrizioneincarico
      ,documento_id 
      ,tipo_documento 
      ,nomefile_input
      ,idrepository 
      ,percorsocompleto 
      ,NamingCartellaZip 
      ,nomedocumentopdf
      ,StringaCSV 
	  ,tiporecord --il tiporecord 1 identifica la documentazione base icbpi
	  )
select  idincarico
      ,idpersona
      ,chiavecliente
      ,codtipoincarico
      ,descrizioneincarico
      ,documento_id
      ,tipo_documento
      ,nomefile_input
      ,idrepository
      ,percorsocompleto
	  
      ,NamingCartellaZip
      ,nomedocumentopdf
      ,StringaCSV
	  , CASE WHEN nomedocumentopdf like 'ko_%' THEN 4 --documentazione da non inviare
			 WHEN nomedocumentopdf LIKE 'ac_%' THEN 3 --documenti aggiuntivi presenti all'interno dell'incarico e accorpati al documento principale
			 ELSE 1 END								  --documento principale
FROM [CLC].[rs].[v_CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI]
where Stato = 1 --in stato 1 presentano una chiavecliente definitiva e il codicefiscale
--AND idincarico = 13793205 

								
DECLARE 
@idpersona INT,
@zipNumber int,
@NamingCartellaZip varchar(max),
@nomedocumentopdf varchar(max),
@StringaCSV varchar(max),
@idincarico INT,
@chiavecliente VARCHAR(9),
@tipo_documento INT



----------------------------------------
SET XACT_ABORT ON; 
SET NOCOUNT ON;
----------------------------------------
SET @zipNumber=(SELECT COALESCE(MAX(progressivoZip),0) FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI)+1
---------------------------------------
--##############################
--### Gestione errori flusso
--##############################


BEGIN
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico in (99,167
,572 --Sottoscrizioni Previdenza - Zenith
--,573 --Versamenti Aggiuntivi Previdenza - Zenith

)) --SOTT/VER PREVID --#adesione previdenza
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico,tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico in (99,167
,572 --Sottoscrizioni Previdenza - Zenith
--,573 --Versamenti Aggiuntivi Previdenza - Zenith
)
group by idpersona, nomedocumentopdf, idincarico,tipo_documento --tiporecord che identifica i documenti di ICBPI, il tipo 2 identifica i documenti da associare




OPEN cur
FETCH NEXT FROM cur INTO @idpersona, @idincarico, @tipo_documento
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------

BEGIN
----------------------------------------------------------------------------------------------------

set @NamingCartellaZip = (select DISTINCT namingcartellazip from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @nomedocumentopdf = (select DISTINCT nomedocumentopdf from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @StringaCSV = (select DISTINCT StringaCSV from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
SET @chiavecliente = (select DISTINCT chiavecliente from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)

;with estrazione as (

SELECT       
		T_Incarico.IdIncarico,
		ISNULL(T_R_Incarico_Persona.idpersona, T_R_Dossier_Persona.IdPersona) IdPersona,
		UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') )))) as ChiaveCliente,
		T_Incarico.CodTipoIncarico, 
		D_TipoIncarico.Descrizione as DescrizioneIncarico,
		Documento_id,
		Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto


FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico AND T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 --cliente
		 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona LEFT JOIN
		T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository               
-------------------------------------------------------------------------------------------------------

where Documento_id IN (SELECT documento_id FROM ##tempcurpersona WHERE tiporecord = 3 AND idpersona = @idpersona AND idincarico = @idincarico --GROUP BY idpersona,tipo_documento
)
or Documento_id in (SELECT documento_id FROM rs.v_CESAM_AZ_Documento_SchermataFend WHERE idpersona = @idpersona ) --documento identita --schermata fend 20181121
OR Documento_id in (SELECT documento_id FROM rs.v_CESAM_AZ_Documento_Identita_Recente WHERE idpersona = @idpersona )				
		)
 --inserisce nella stessa tabella temporanea i documenti ricercati a db per quella persona
insert into ##tempcurpersona (idincarico
      ,idpersona 
      ,chiavecliente 
      ,codtipoincarico 
      ,descrizioneincarico
      ,documento_id 
      ,tipo_documento 
      ,nomefile_input
      ,idrepository 
      ,percorsocompleto 
      ,NamingCartellaZip 
      ,nomedocumentopdf
      ,StringaCSV
	  ,tiporecord )
select [idincarico]
      ,[idpersona]
      ,@chiavecliente
      ,[codtipoincarico]
      ,[descrizioneincarico]
      ,[documento_id]
      ,[tipo_documento]
      ,[nomefile_input]
      ,[idrepository]
      ,[percorsocompleto]
      ,@NamingCartellaZip
      ,@nomedocumentopdf
      ,@StringaCSV
	    ,2  --tipo record 2 sono i documenti che dobbiamo associare
	  from estrazione

	  

END




-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction alla persona'+ CAST(@idpersona as VARCHAR(15))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO @idpersona, @idincarico, @tipo_documento
END

CLOSE cur
DEALLOCATE cur

END


BEGIN
--SELECT * FROM ##tempcurpersona
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
--, Stato, DescrizioneKO
)
select DISTINCT	##tempcurpersona.documento_id,
		##tempcurpersona.idincarico,
		##tempcurpersona.chiavecliente,
		##tempcurpersona.codtipoincarico,
		##tempcurpersona.descrizioneincarico,
		##tempcurpersona.tipo_documento,
		--D_Documento.Descrizione,
		##tempcurpersona.nomefile_input,
		##tempcurpersona.idrepository,
		##tempcurpersona.percorsocompleto,
		##tempcurpersona.NamingCartellaZip,
		@zipNumber,
		##tempcurpersona.nomedocumentopdf,
		##tempcurpersona.StringaCSV
		from ##tempcurpersona --JOIN D_Documento ON ##tempcurpersona.tipo_documento = D_Documento.Codice
		left join export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI on ##tempcurpersona.nomedocumentopdf = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN (SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (99,167
		,572
		--,573
		))
		OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (99,167,44,253,288,572
		--,573
		)
		and CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END


-----------------------------------------------------------------------------------------------------------------------------------------------

--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 175) --#successioni fondo pensione

BEGIN
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
--, Stato, DescrizioneKO
)
		SELECT DISTINCT 	##tempcurpersona.documento_id,
		##tempcurpersona.idincarico,
		##tempcurpersona.chiavecliente,
		##tempcurpersona.codtipoincarico,
		##tempcurpersona.descrizioneincarico,
		##tempcurpersona.tipo_documento,
		##tempcurpersona.nomefile_input,
		##tempcurpersona.idrepository,
		##tempcurpersona.percorsocompleto,
		##tempcurpersona.NamingCartellaZip,
		@zipNumber,
		##tempcurpersona.nomedocumentopdf,
		##tempcurpersona.StringaCSV


		from ##tempcurpersona
		left join export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI on ##tempcurpersona.nomedocumentopdf = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
		where (LEFT(##tempcurpersona.nomedocumentopdf,2) IN (SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico =175)
		OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		and ##tempcurpersona.codtipoincarico = 175
		and CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf is NULL
		order by ##tempcurpersona.chiavecliente

END


--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 102) --#switch fondi pensione
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico,tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico = 102
group by idpersona, nomedocumentopdf, idincarico,tipo_documento --tiporecord che identifica i documenti di ICBPI, il tipo 2 identifica i documenti da associare




OPEN cur
FETCH NEXT FROM cur INTO @idpersona, @idincarico, @tipo_documento
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------

BEGIN
----------------------------------------------------------------------------------------------------

set @NamingCartellaZip = (select DISTINCT namingcartellazip from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @nomedocumentopdf = (select DISTINCT nomedocumentopdf from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @StringaCSV = (select DISTINCT StringaCSV from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
SET @chiavecliente = (select DISTINCT chiavecliente from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)

;with estrazione as (

SELECT       
		T_Incarico.IdIncarico,
		ISNULL(T_R_Incarico_Persona.idpersona, T_R_Dossier_Persona.IdPersona) IdPersona,
		UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') )))) as ChiaveCliente,
		T_Incarico.CodTipoIncarico, 
		D_TipoIncarico.Descrizione as DescrizioneIncarico,
		Documento_id,
		Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto


FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico AND T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona LEFT JOIN
		T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository               
-------------------------------------------------------------------------------------------------------

where Documento_id IN (SELECT MAX(documento_id) FROM ##tempcurpersona WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
--or Documento_id in (SELECT documento_id FROM rs.v_CESAM_AZ_Documento_Identita_Recente WHERE idpersona = @idpersona ) --documento identita
				
)
 --inserisce nella stessa tabella temporanea i documenti ricercati a db per quella persona
insert into ##tempcurpersona (idincarico
      ,idpersona 
      ,chiavecliente 
      ,codtipoincarico 
      ,descrizioneincarico
      ,documento_id 
      ,tipo_documento 
      ,nomefile_input
      ,idrepository 
      ,percorsocompleto 
      ,NamingCartellaZip 
      ,nomedocumentopdf
      ,StringaCSV
	  ,tiporecord )
select [idincarico]
      ,[idpersona]
      ,@chiavecliente
      ,[codtipoincarico]
      ,[descrizioneincarico]
      ,[documento_id]
      ,[tipo_documento]
      ,[nomefile_input]
      ,[idrepository]
      ,[percorsocompleto]
      ,@NamingCartellaZip
      ,@nomedocumentopdf
      ,@StringaCSV
	    ,2  --tipo record 2 sono i documenti che dobbiamo associare
	  from estrazione

	  

END




-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction alla persona'+ CAST(@idpersona as VARCHAR(15))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO @idpersona, @idincarico, @tipo_documento
END

CLOSE cur
DEALLOCATE cur

END


BEGIN
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
--, Stato, DescrizioneKO
)
SELECT DISTINCT 	##tempcurpersona.documento_id,
		##tempcurpersona.idincarico,
		##tempcurpersona.chiavecliente,
		##tempcurpersona.codtipoincarico,
		##tempcurpersona.descrizioneincarico,
		##tempcurpersona.tipo_documento,
		##tempcurpersona.nomefile_input,
		##tempcurpersona.idrepository,
		##tempcurpersona.percorsocompleto,
		##tempcurpersona.NamingCartellaZip,
		@zipNumber,
		##tempcurpersona.nomedocumentopdf,
		##tempcurpersona.StringaCSV
		from ##tempcurpersona
		left join export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI on ##tempcurpersona.nomedocumentopdf = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (102))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (102)
		and CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 57) --GESTIONE #SEPA
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico,tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico = 57
group by idpersona, nomedocumentopdf, idincarico,tipo_documento --tiporecord che identifica i documenti di ICBPI, il tipo 2 identifica i documenti da associare




OPEN cur
FETCH NEXT FROM cur INTO  @idpersona, @idincarico, @tipo_documento
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------

BEGIN
----------------------------------------------------------------------------------------------------

set @NamingCartellaZip = (select DISTINCT namingcartellazip from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @nomedocumentopdf = (select DISTINCT nomedocumentopdf from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @StringaCSV = (select DISTINCT StringaCSV from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
SET @chiavecliente = (select DISTINCT chiavecliente from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)

;with estrazione as (

SELECT       
		T_Incarico.IdIncarico,
		ISNULL(T_R_Incarico_Persona.idpersona, T_R_Dossier_Persona.IdPersona) IdPersona,
		UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') )))) as ChiaveCliente,
		T_Incarico.CodTipoIncarico, 
		D_TipoIncarico.Descrizione as DescrizioneIncarico,
		Documento_id,
		Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto


FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico and T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona LEFT JOIN
		T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository               
-------------------------------------------------------------------------------------------------------

where Documento_id IN (SELECT MAX(documento_id) FROM ##tempcurpersona WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
--or Documento_id in (SELECT documento_id FROM rs.v_CESAM_AZ_Documento_Identita_Recente WHERE idpersona = @idpersona ) --documento identita
				
)
 --inserisce nella stessa tabella temporanea i documenti ricercati a db per quella persona
insert into ##tempcurpersona (idincarico
      ,idpersona 
      ,chiavecliente 
      ,codtipoincarico 
      ,descrizioneincarico
      ,documento_id 
      ,tipo_documento 
      ,nomefile_input
      ,idrepository 
      ,percorsocompleto 
      ,NamingCartellaZip 
      ,nomedocumentopdf
      ,StringaCSV
	  ,tiporecord )
select [idincarico]
      ,[idpersona]
      ,@chiavecliente
      ,[codtipoincarico]
      ,[descrizioneincarico]
      ,[documento_id]
      ,[tipo_documento]
      ,[nomefile_input]
      ,[idrepository]
      ,[percorsocompleto]
      ,@NamingCartellaZip
      ,@nomedocumentopdf
      ,@StringaCSV
	    ,2  --tipo record 2 sono i documenti che dobbiamo associare
	  from estrazione

	  

END




-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction alla persona'+ CAST(@idpersona as VARCHAR(15))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO  @idpersona, @idincarico, @tipo_documento
END

CLOSE cur
DEALLOCATE cur

END


BEGIN
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
--, Stato, DescrizioneKO
)
select DISTINCT	##tempcurpersona.documento_id,
		##tempcurpersona.idincarico,
		##tempcurpersona.chiavecliente,
		##tempcurpersona.codtipoincarico,
		##tempcurpersona.descrizioneincarico,
		##tempcurpersona.tipo_documento,
		##tempcurpersona.nomefile_input,
		##tempcurpersona.idrepository,
		##tempcurpersona.percorsocompleto,
		##tempcurpersona.NamingCartellaZip,
		@zipNumber,
		##tempcurpersona.nomedocumentopdf,
		##tempcurpersona.StringaCSV
		from ##tempcurpersona
		left join export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI on ##tempcurpersona.nomedocumentopdf = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
		where (LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (57))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (57)
		and CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico IN( 95 --#RIMBORSO FONDI PENSIONE
,173) --Disinvestimenti Previdenza
) 
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico, tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico IN ( 95,173)
group by idpersona, nomedocumentopdf, idincarico, tipo_documento --tiporecord che identifica i documenti di ICBPI, il tipo 2 identifica i documenti da associare




OPEN cur
FETCH NEXT FROM cur INTO @idpersona, @idincarico, @tipo_documento
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------

BEGIN
----------------------------------------------------------------------------------------------------

set @NamingCartellaZip = (select DISTINCT namingcartellazip from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @nomedocumentopdf = (select DISTINCT nomedocumentopdf from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico  AND tipo_documento = @tipo_documento)
set @StringaCSV = (select DISTINCT StringaCSV from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
SET @chiavecliente = (select DISTINCT chiavecliente from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)

;with estrazione as (

SELECT       
		T_Incarico.IdIncarico,
		ISNULL(T_R_Incarico_Persona.idpersona, T_R_Dossier_Persona.IdPersona) IdPersona,
		UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') )))) as ChiaveCliente,
		T_Incarico.CodTipoIncarico, 
		D_TipoIncarico.Descrizione as DescrizioneIncarico,
		Documento_id,
		Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto


FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico and T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona LEFT JOIN
		T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository               
-------------------------------------------------------------------------------------------------------

where Documento_id IN (SELECT MAX(documento_id) FROM ##tempcurpersona WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
--or Documento_id in (SELECT documento_id FROM rs.v_CESAM_AZ_Documento_Identita_Recente WHERE idpersona = @idpersona ) --documento identita
				
)
 --inserisce nella stessa tabella temporanea i documenti ricercati a db per quella persona
insert into ##tempcurpersona (idincarico
      ,idpersona 
      ,chiavecliente 
      ,codtipoincarico 
      ,descrizioneincarico
      ,documento_id 
      ,tipo_documento 
      ,nomefile_input
      ,idrepository 
      ,percorsocompleto 
      ,NamingCartellaZip 
      ,nomedocumentopdf
      ,StringaCSV
	  ,tiporecord )
select [idincarico]
      ,[idpersona]
      ,@chiavecliente
      ,[codtipoincarico]
      ,[descrizioneincarico]
      ,[documento_id]
      ,[tipo_documento]
      ,[nomefile_input]
      ,[idrepository]
      ,[percorsocompleto]
      ,@NamingCartellaZip
      ,@nomedocumentopdf
      ,@StringaCSV
	    ,2  --tipo record 2 sono i documenti che dobbiamo associare
	  from estrazione

	  

END




-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction alla persona'+ CAST(@idpersona as VARCHAR(15))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO @idpersona, @idincarico, @tipo_documento
END

CLOSE cur
DEALLOCATE cur

END


BEGIN
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
--, Stato, DescrizioneKO
)
select DISTINCT	##tempcurpersona.documento_id,
		##tempcurpersona.idincarico,
		##tempcurpersona.chiavecliente,
		##tempcurpersona.codtipoincarico,
		##tempcurpersona.descrizioneincarico,
		##tempcurpersona.tipo_documento,
		##tempcurpersona.nomefile_input,
		##tempcurpersona.idrepository,
		##tempcurpersona.percorsocompleto,
		##tempcurpersona.NamingCartellaZip,
		@zipNumber,
		##tempcurpersona.nomedocumentopdf,
		##tempcurpersona.StringaCSV
		from ##tempcurpersona
		left join export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI on ##tempcurpersona.nomedocumentopdf = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (95,173))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (95,173)
		and CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 178) --#varie previdenza
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico, tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico= 178
group by idpersona, nomedocumentopdf, idincarico,tipo_documento --tiporecord che identifica i documenti di ICBPI, il tipo 2 identifica i documenti da associare




OPEN cur
FETCH NEXT FROM cur INTO @idpersona, @idincarico,@tipo_documento
			
WHILE @@fetch_status = 0
BEGIN

-----------------------------------------
BEGIN TRAN
BEGIN TRY
-----------------------------------------

BEGIN
----------------------------------------------------------------------------------------------------

set @NamingCartellaZip = (select DISTINCT  namingcartellazip from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento )
set @nomedocumentopdf = (select DISTINCT  nomedocumentopdf from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)
set @StringaCSV = (select DISTINCT  StringaCSV from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento )
SET @chiavecliente = (select DISTINCT  chiavecliente from ##tempcurpersona where idpersona = @idpersona  AND tiporecord = 1 and idincarico = @idincarico AND tipo_documento = @tipo_documento)

;with estrazione as (

SELECT       
		T_Incarico.IdIncarico,
		ISNULL(T_R_Incarico_Persona.idpersona, T_R_Dossier_Persona.IdPersona) IdPersona,
		UPPER(RTRIM(LTRIM((ISNULL(Cliente.ChiaveCliente, '') + ' ' + ISNULL(ClienteD.ChiaveCliente, '') )))) as ChiaveCliente,
		T_Incarico.CodTipoIncarico, 
		D_TipoIncarico.Descrizione as DescrizioneIncarico,
		Documento_id,
		Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto


FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico and T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona LEFT JOIN
		T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository               
-------------------------------------------------------------------------------------------------------

where Documento_id IN (SELECT MAX(documento_id) FROM ##tempcurpersona WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
--or Documento_id in (SELECT documento_id FROM rs.v_CESAM_AZ_Documento_Identita_Recente WHERE idpersona = @idpersona ) --documento identita
				
)
 --inserisce nella stessa tabella temporanea i documenti ricercati a db per quella persona
insert into ##tempcurpersona (idincarico
      ,idpersona 
      ,chiavecliente 
      ,codtipoincarico 
      ,descrizioneincarico
      ,documento_id 
      ,tipo_documento 
      ,nomefile_input
      ,idrepository 
      ,percorsocompleto 
      ,NamingCartellaZip 
      ,nomedocumentopdf
      ,StringaCSV
	  ,tiporecord )
select [idincarico]
      ,[idpersona]
      ,@chiavecliente
      ,[codtipoincarico]
      ,[descrizioneincarico]
      ,[documento_id]
      ,[tipo_documento]
      ,[nomefile_input]
      ,[idrepository]
      ,[percorsocompleto]
      ,@NamingCartellaZip
      ,@nomedocumentopdf
      ,@StringaCSV
	    ,2  --tipo record 2 sono i documenti che dobbiamo associare
	  from estrazione

	  

END




-----------------------------------------
COMMIT
END TRY
-----------------------------------------
BEGIN CATCH
SELECT ERROR_MESSAGE()
	IF @@TRANCOUNT > 0
  	BEGIN
    	print 'rolling back transaction alla persona'+ CAST(@idpersona as VARCHAR(15))
    	ROLLBACK
  	END
END CATCH


FETCH NEXT FROM cur INTO @idpersona, @idincarico,@tipo_documento
END

CLOSE cur
DEALLOCATE cur

END


BEGIN
INSERT INTO export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
--, Stato, DescrizioneKO
)
select DISTINCT	##tempcurpersona.documento_id,
		##tempcurpersona.idincarico,
		##tempcurpersona.chiavecliente,
		##tempcurpersona.codtipoincarico,
		##tempcurpersona.descrizioneincarico,
		##tempcurpersona.tipo_documento,
		##tempcurpersona.nomefile_input,
		##tempcurpersona.idrepository,
		##tempcurpersona.percorsocompleto,
		##tempcurpersona.NamingCartellaZip,
		@zipNumber,
		##tempcurpersona.nomedocumentopdf,
		##tempcurpersona.StringaCSV
		from ##tempcurpersona
		left join export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI on ##tempcurpersona.nomedocumentopdf = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (178))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (178)
		and CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END



--gestione errori invio
BEGIN 
DECLARE @incaricoerrore bit = 0
IF EXISTS
(
				SELECT TOP 1 CAST(idincarico as VARCHAR(50)) + ' - IdIncarico con StringaCSV NULL'  FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI WHERE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.StringaCSV is NULL 
				UNION
				SELECT TOP 1 CAST(idincarico as VARCHAR(50)) + ' - IdIncarico con codice fiscale non censito'  FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI WHERE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.FlagUpload = 0
				AND export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.StringaCSV LIKE '%NDNDNDND%'

				)
BEGIN
	SET @incaricoerrore = 1

END
	IF @incaricoerrore = 1
	BEGIN

	
	SELECT export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.idincarico stringacsvnull 
	FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI WHERE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.StringaCSV is NULL 

	SELECT idincarico idincarico, export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.chiavecliente chiaveclienteCFnocensito FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI WHERE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.FlagUpload = 0
				AND export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.StringaCSV LIKE '%NDNDNDND%'
	
    DELETE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI WHERE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.FlagUpload = 0
	
	--PRINT 'SP In errore. Verificare'
	--RAISERROR (@incaricoerrore, 15,1)
	
	RAISERROR('SP In errore. Verificare',15,1)


	END
	
	ELSE
BEGIN
	IF OBJECT_ID('tempdb.dbo.#Spooler') IS NOT NULL
		DROP TABLE #Spooler

	;WITH base AS (
	SELECT idincarico, nomedocumentopdf,documento_id
		,DENSE_RANK() OVER(PARTITION BY ProgressivoZip,idincarico ORDER BY nomedocumentopdf) - 1 NDoc
	FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
	WHERE --FlagUpload = 0 
	 ProgressivoZip = 1994
	--ORDER BY idincarico, nomedocumentopdf
	)
	SELECT base.idincarico
	,IIF(NDoc > 0
		--se vero
		,REPLACE(StringaCSV
			,(select CAST(Value AS VARCHAR(20)) from rs.Split(previnet.StringaCSV,';')WHERE Id = 1 )
			,(select CAST(Value AS VARCHAR(20)) from rs.Split(previnet.StringaCSV,';')WHERE Id = 1 ) 
				+ IIF((select CAST(Value AS VARCHAR(20)) from rs.Split(previnet.StringaCSV,';')WHERE Id = 1 ) NOT LIKE '%/_%' ESCAPE '/'
					,'_0_'+ CAST((base.NDoc) AS VARCHAR(20))
					,'_'+CAST((base.NDoc) AS VARCHAR(20))
				  )
		) 
		--se falso
		,StringaCSV)
	 NuovaStringaCSV
	 ,IIF(NDoc > 0
		--se vero
		,REPLACE(previnet.nomedocumentopdf
			,(select CAST(Value AS VARCHAR(20)) from rs.Split(previnet.StringaCSV,';')WHERE Id = 1 )
			,(select CAST(Value AS VARCHAR(20)) from rs.Split(previnet.StringaCSV,';')WHERE Id = 1 ) + '_'+CAST((base.NDoc) AS VARCHAR(20))
		)
		--se falso
		,previnet.nomedocumentopdf
		) NuovoNomeDocPdf
	 ,base.documento_id

	 INTO #Spooler
	 FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI previnet
	JOIN base ON previnet.idincarico = base.idincarico
	AND previnet.documento_id = base.documento_id

	UPDATE export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
	SET nomedocumentopdf = #Spooler.NuovoNomeDocPdf
	,StringaCSV = #Spooler.NuovaStringaCSV
	--SELECT 	#Spooler.idincarico
	--		,#Spooler.NuovaStringaCSV
	--		,#Spooler.NuovoNomeDocPdf
	--		,#Spooler.documento_id  
	FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
	JOIN #Spooler on export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.idincarico = #Spooler.idincarico
	AND export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.documento_id = #Spooler.documento_id

	DROP TABLE #Spooler
    END


END 



drop table ##tempcurpersona

	END

	END

GO