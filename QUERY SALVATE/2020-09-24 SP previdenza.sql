USE clc

GO



ALTER PROCEDURE export.CESAM_AZ_Documenti_PREVINET_AZISF AS

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
select  v.idincarico
      ,v.idpersona
      ,v.chiavecliente
      ,v.codtipoincarico
      ,v.descrizioneincarico
      ,v.documento_id
      ,v.tipo_documento
      ,v.nomefile_input
      ,v.idrepository
      ,v.percorsocompleto
	  
      ,v.NamingCartellaZip
      ,v.nomedocumentopdf
      ,v.StringaCSV
	  , CASE WHEN nomedocumentopdf like 'ko_%' THEN 4 --documentazione da non inviare
			 WHEN nomedocumentopdf LIKE 'ac_%' THEN 3 --documenti aggiuntivi presenti all'interno dell'incarico e accorpati al documento principale
			 ELSE 1 END								  --documento principale
FROM [CLC].[rs].v_CESAM_AZ_FlussoGiornaliero_Documenti_AZISF v
where Stato = 1 --in stato 1 presentano una chiavecliente definitiva e il codicefiscale
--AND v.idincarico = 15773959
;


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
SET @zipNumber=(SELECT COALESCE(MAX(progressivoZip),0) FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture)+1
---------------------------------------
--##############################
--### Gestione errori flusso
--##############################


BEGIN
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona 
WHERE codtipoincarico in (657	--Sottoscrizioni Previdenza - AZISF
						  ,661	--Sottoscrizioni Previdenza - Zenith - AZISF
						  )
) --SOTT/VER PREVID --#adesione previdenza
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico,tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico in (657	--Sottoscrizioni Previdenza - AZISF
										,661	--Sottoscrizioni Previdenza - Zenith - AZISF
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
		T_Documento.Documento_id,
		T_Documento.Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto
		
FROM	
		T_Incarico 
		INNER JOIN	D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico 
		
		left JOIN T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico 
		AND T_R_Incarico_Mandato.Progressivo = 1 
		LEFT OUTER JOIN	T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
		LEFT OUTER JOIN	T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier 
		LEFT OUTER JOIN T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico 
		AND T_R_Incarico_Persona.Progressivo = 1 --cliente
		 LEFT OUTER JOIN T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona 
		 LEFT OUTER JOIN T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier 
		 AND T_R_Dossier_Persona.Progressivo = 1 
		 LEFT OUTER JOIN T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona 
		 
		 JOIN	T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico 
		 AND FlagPresenzaInFileSystem = 1
		 AND FlagScaduto = 0
		  JOIN	D_Documento WITH (nolock) on D_Documento.Codice=T_Documento.Tipo_Documento 
		  LEFT JOIN S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository  
		  JOIN (SELECT documento_id FROM ##tempcurpersona WHERE tiporecord = 3 AND idpersona = @idpersona AND idincarico = @idincarico
				UNION 
				SELECT	MAX(Documento_id) Documento_id 
				FROM rs.v_CESAM_AZ_Documento_SchermataFend 
				WHERE IdPersona = @idpersona			
				UNION 
				SELECT MAX(Documento_id) Documento_id
				FROM rs.v_CESAM_AZ_Documento_Identita_Recente
				WHERE IdPersona = @idpersona
			
				) doctemp ON T_Documento.Documento_id = doctemp.documento_id
	WHERE Cliente.IdPersona = @idpersona OR ClienteD.IdPersona = @idpersona
	)
-------------------------------------------------------------------------------------------------------

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

	  --SELECT * FROM ##tempcurpersona 
	  
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

INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
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
		left join export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t on ##tempcurpersona.nomedocumentopdf = t.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = t.documento_id
		WHERE 
		( LEFT(##tempcurpersona.nomedocumentopdf,2) IN (SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (657	--Sottoscrizioni Previdenza - AZISF
		,661	--Sottoscrizioni Previdenza - Zenith - AZISF
		))
		OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		
		AND 
		##tempcurpersona.codtipoincarico IN (44,253,288,396 --Incarichi Anagrafica (per allegare i doc di identità)
		,657	--Sottoscrizioni Previdenza - AZISF
		,661	--Sottoscrizioni Previdenza - Zenith - AZISF
		) and
		 t.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		

END
END


-----------------------------------------------------------------------------------------------------------------------------------------------

--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 659	) --Successioni - Previdenza - AZISF

BEGIN
INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture --#insertexport
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
		left join export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t on ##tempcurpersona.nomedocumentopdf = t.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = t.documento_id
		where (LEFT(##tempcurpersona.nomedocumentopdf,2) IN (SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico =659)
		OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		and ##tempcurpersona.codtipoincarico = 659	--Successioni - Previdenza - AZISF
		and t.nomedocumentopdf is NULL
		order by ##tempcurpersona.chiavecliente

END

--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 656) --Switch Previdenza - AZISF
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico,tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico = 656 --Switch Previdenza - AZISF
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
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico 
		
		left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico AND T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona 
		
		JOIN T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico LEFT JOIN
		D_Documento WITH (nolock) on D_Documento.Codice=Tipo_Documento LEFT JOIN 
		S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository    
		JOIN (SELECT MAX(documento_id) Docid FROM ##tempcurpersona 
				WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
			tempdoc ON T_Documento.Documento_id = tempdoc.Docid
-------------------------------------------------------------------------------------------------------
WHERE ( Cliente.IdPersona = @idpersona OR ClienteD.IdPersona = @idpersona )
AND T_Incarico.IdIncarico = @idincarico

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
INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture --#insertexport
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
		left join export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t on ##tempcurpersona.nomedocumentopdf = t.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = t.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (656))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (656)
		and t.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 655) --Gestione SEPA - AZISF
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico,tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico = 655	--Gestione SEPA - AZISF
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
		T_documento.Documento_id,
		T_documento.Tipo_Documento,
		D_documento.Descrizione as DescrizioneDocumento,
		Nome_file as NomeFile_Input,
		T_Documento.IdRepository,
		S_RepositoryDocumenti.PercorsoBase as PercorsoCompleto


FROM	
		T_Incarico INNER JOIN
		D_TipoIncarico ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico 
		
		left JOIN
		T_R_Incarico_Mandato WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico and T_R_Incarico_Mandato.Progressivo = 1 LEFT OUTER JOIN
		T_Mandato WITH (nolock) ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato LEFT OUTER JOIN
		T_Dossier WITH (nolock) ON T_Dossier.IdDossier = T_Mandato.IdDossier LEFT OUTER JOIN                                           
		T_R_Incarico_Persona WITH (nolock) ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico AND T_R_Incarico_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS Cliente WITH (nolock) ON Cliente.IdPersona = T_R_Incarico_Persona.IdPersona  LEFT OUTER JOIN
		T_R_Dossier_Persona WITH (nolock) ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier AND T_R_Dossier_Persona.Progressivo = 1 LEFT OUTER JOIN
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona 

		JOIN T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico  
		AND FlagPresenzaInFileSystem = 1
		AND FlagScaduto = 0
		
		JOIN D_Documento WITH (nolock) on D_Documento.Codice= T_Documento.tipo_documento  
		JOIN S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository  
		
		JOIN (SELECT MAX(documento_id) Docid FROM ##tempcurpersona 
				WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
			tempdoc ON T_Documento.Documento_id = tempdoc.Docid			
WHERE (Cliente.IdPersona = @idpersona OR ClienteD.IdPersona = @idpersona)
AND T_Incarico.IdIncarico = @idincarico
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
INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
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
		left join export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t on ##tempcurpersona.nomedocumentopdf = t.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = t.documento_id
		where (LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (655))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (655)
		and t.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico IN( 658 --Disinvestimenti Previdenza - AZISF
) 
) 
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico, tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico IN ( 658	--Disinvestimenti Previdenza - AZISF
)
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
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona 
		JOIN T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico  
		AND FlagPresenzaInFileSystem = 1
		AND FlagScaduto = 0
		
		JOIN D_Documento WITH (nolock) on D_Documento.Codice= T_Documento.tipo_documento  
		JOIN S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository  
		
		JOIN (SELECT MAX(documento_id) Docid FROM ##tempcurpersona 
				WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
			
			tempdoc ON T_Documento.Documento_id = tempdoc.Docid		
			
			-------------------------------------------------------------------------------------------------------

WHERE (Cliente.IdPersona = @idpersona OR ClienteD.IdPersona = @idpersona)
AND T_Incarico.IdIncarico = @idincarico             

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
INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
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
		left join export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t on ##tempcurpersona.nomedocumentopdf = t.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = t.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (658))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (658	--Disinvestimenti Previdenza - AZISF
		)
		and t.nomedocumentopdf is NULL
		AND tiporecord IN (1,2)
		ORDER BY ##tempcurpersona.chiavecliente
		
END
END
--###########################################################################################################################################################################################
if EXISTS (select distinct codtipoincarico from ##tempcurpersona WHERE codtipoincarico = 660) --Varie Previdenza - AZISF
BEGIN
BEGIN
DECLARE cur CURSOR STATIC FOR
--select del cursore
select idpersona, idincarico, tipo_documento
from ##tempcurpersona
JOIN export.Z_Cliente_TipoIncarico_TipoDocumento ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = ##tempcurpersona.codtipoincarico AND CodTipoDocumento = tipo_documento
where tiporecord = 1
AND ##tempcurpersona.codtipoincarico= 660	--Varie Previdenza - AZISF
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
		T_Persona AS ClienteD WITH (nolock) ON ClienteD.IdPersona = T_R_Dossier_Persona.IdPersona 
JOIN T_Documento WITH (nolock) on T_Documento.IdIncarico=T_Incarico.IdIncarico  
		AND FlagPresenzaInFileSystem = 1
		AND FlagScaduto = 0
		
		JOIN D_Documento WITH (nolock) on D_Documento.Codice= T_Documento.tipo_documento  
		JOIN S_RepositoryDocumenti WITH (nolock) on S_RepositoryDocumenti.IdRepository = T_Documento.IdRepository  
		
		JOIN (SELECT MAX(documento_id) Docid FROM ##tempcurpersona 
				WHERE tiporecord = 3 AND idpersona = @idpersona and ##tempcurpersona.idincarico = @idincarico GROUP BY idpersona,tipo_documento)
			
			tempdoc ON T_Documento.Documento_id = tempdoc.Docid		
			
			-------------------------------------------------------------------------------------------------------

WHERE (Cliente.IdPersona = @idpersona OR ClienteD.IdPersona = @idpersona)
AND T_Incarico.IdIncarico = @idincarico   		
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
INSERT INTO export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture --#insertexport
(documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, 
NamingCartellaZip, progressivoZip, nomedocumentopdf, StringaCSV
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
		left join export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t on ##tempcurpersona.nomedocumentopdf = t.nomedocumentopdf 
		AND ##tempcurpersona.documento_id = t.documento_id
		WHERE ( LEFT(##tempcurpersona.nomedocumentopdf,2) IN 
			(SELECT CodiceTipoDocumentoCliente FROM export.Z_Cliente_TipoIncarico_TipoDocumento WHERE CodTipoIncarico IN (660))
			OR LEFT(##tempcurpersona.nomedocumentopdf,3) = 'INT')
		AND ##tempcurpersona.codtipoincarico IN (660) --Varie Previdenza - AZISF
		and t.nomedocumentopdf is NULL
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

	
	SELECT t.idincarico stringacsvnull 
	FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t 
	WHERE t.StringaCSV is NULL 

	SELECT idincarico idincarico,t.chiavecliente chiaveclienteCFnocensito 
	FROM export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t 
	WHERE t.FlagUpload = 0
				AND t.StringaCSV LIKE '%NDNDNDND%'
	
    DELETE export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture 
	WHERE FlagUpload = 0
	
	--PRINT 'SP In errore. Verificare'
	--RAISERROR (@incaricoerrore, 15,1)
	
	RAISERROR('SP In errore. Verificare',15,1)


	END


END 



drop table ##tempcurpersona

	END

	END

GO