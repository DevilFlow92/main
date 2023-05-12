/****** Object:  StoredProcedure [controlli].[CESAM_CB_CheckPresenzaDocumenti]    Script Date: 03/05/2018 12:54:42 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

USE CLC
GO


--ALTER  procedure controlli.CESAM_CB_CheckPresenzaDocumenti 

--( 
--@IdRiga INT
--)
--AS

/*
Controllo sulla presenza dei seguenti documenti per gli incarichi di CB conto FEA:
 - 8258		Dichiarazione primo contatto
 - 10001	HBRETAIL
 - 8257		Informativa regole di comportamento del consulente

E per gli incarichi CB Cartacei:
 - 8258		Dichiarazione primo contatto
 - 8257		Informativa regole di comportamento del consulente

*/

--DECLARE @idriga INT

--FEA
--SET @idriga =
 --10051349 
--9999241 --prod

--4424536 --preprod
--8714736 --test interno 

--Cartaceo  
--set @idriga = 8715412  --test interno


BEGIN TRY
--T Dichiarazione variabili generali di controllo

DECLARE 
       @RES_CodGiudizioControllo int, 
       @RED_Note as varchar(max),
       @RED_CodEsitoControllo varchar(5)
       
DECLARE @Esito INT
SET @RES_CodGiudizioControllo=1
SET @RED_Note='Verifica'

-- Dichiarazione parametri della SP
DECLARE @IdIncarico INT
SET @IdIncarico = @IdRiga

declare @CodTipoIncarico int

 
--===========================================================================================================

BEGIN
    
declare @numerointestatari smallint

SET @CodTipoIncarico = (SELECT ti.CodTipoIncarico FROM T_Incarico ti WHERE ti.IdIncarico = @IdIncarico)

IF OBJECT_ID(N'tempdb..#documenti', N'U') IS NOT NULL
begin
DROP TABLE #documenti
END	 

CREATE TABLE #documenti (Codice INT, Descrizione VARCHAR(200))

IF @CodTipoIncarico = 331
BEGIN
INSERT INTO #documenti (Codice, Descrizione)
SELECT
	codice
   ,Descrizione
--into #documenti
FROM D_Documento
--inserire nella WHERE i codici che si devono ricercare
WHERE Codice IN 
(8258		--Dichiarazione primo contatto
--, 10001		--HBRETAIL
, 8257		--Informativa regole di comportamento del consulente
)
END

ELSE
BEGIN
INSERT INTO #documenti (Codice, Descrizione)
SELECT
	codice,
	Descrizione 
--INTO #documenti
FROM D_Documento
--inserire nella WHERE i codici che si devono ricercare
WHERE Codice IN
(8258		--Dichiarazione primo contatto
, 10001		--HBRETAIL
, 8257		--Informativa regole di comportamento del consulente
)
END

IF NOT EXISTS (SELECT * FROM T_Documento
				JOIN D_Documento ON Codice = Tipo_Documento
				WHERE FlagScaduto = 0 and FlagPresenzaInFileSystem = 1 AND  CodOggettoControlli = 44 and IdIncarico = @IdIncarico) 
	AND @CodTipoIncarico = 331
BEGIN
	SET @RES_CodGiudizioControllo = 2
	SET @RED_Note = 'Cartaceo senza apertura Conto Corrente - Controllo non necessario'
END
ELSE
BEGIN
PRINT 'Si fa il controllo'

IF OBJECT_ID(N'tempdb..#squadra', N'U') IS NOT NULL
begin
DROP TABLE #squadra
END	 

SELECT idpersona 
		,'['+ ChiaveClienteIntestatario +']'  + space(1) + CognomeIntestatario + space(1) + NomeIntestatario 
			as anagrafica
		,ProgressivoPersona
into #squadra
FROM rs.v_CESAM_Anagrafica_Cliente_Promotore where IdIncarico = @IdIncarico

--SELECT * FROM #squadra	

set @numerointestatari = (select count(IdPersona) FROM #squadra)


IF OBJECT_ID(N'tempdb..#checkdocs', N'U') IS NOT NULL
begin
DROP TABLE #checkdocs
end	  


create TABLE #checkdocs (IdPersona INT	
							,Anagrafica varchar(100)
							--,ProgressivoPersona SMALLINT
							,Idincarico INT
							,CodDocumento INT
							,DescrizioneDocumento varchar(200)
						 )

IF  @numerointestatari = 1
BEGIN

INSERT INTO #checkdocs (IdPersona
, Anagrafica
--, ProgressivoPersona
, Idincarico
, CodDocumento
, DescrizioneDocumento)
	SELECT
		(SELECT idpersona FROM #squadra where progressivopersona = 1)
	   ,(SELECT Anagrafica from #squadra where progressivopersona = 1)
	   --,#squadra.ProgressivoPersona
	   ,isnull(vista.IdIncarico,1) IdIncarico
	   ,Codice CodDocumento
	   ,Descrizione DescrizioneDocumento

	FROM rs.v_CESAM_CB_PresenzaDocumenti vista

	JOIN #squadra
		ON vista.IdPersona = #squadra.IdPersona and #squadra.ProgressivoPersona = 1

	RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
END

ELSE IF @numerointestatari = 2 
BEGIN			 
INSERT INTO #checkdocs (IdPersona
, Anagrafica
--, ProgressivoPersona
, Idincarico
, CodDocumento
, DescrizioneDocumento)
	SELECT
		(SELECT idpersona FROM #squadra where progressivopersona = 1)
	   ,(SELECT Anagrafica from #squadra where progressivopersona = 1)
	   --,#squadra.ProgressivoPersona
	  ,isnull(vista.IdIncarico,1) IdIncarico
	   ,Codice CodDocumento
	   ,Descrizione DescrizioneDocumento

	FROM rs.v_CESAM_CB_PresenzaDocumenti vista
	JOIN #squadra
		ON vista.IdPersona = #squadra.IdPersona and #squadra.ProgressivoPersona = 1

		RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
	UNION ALL
		SELECT
			(SELECT	idpersona FROM #squadra	WHERE progressivopersona = 2)
		   ,(SELECT	Anagrafica	FROM #squadra	WHERE progressivopersona = 2)
		   --,#squadra.ProgressivoPersona
		  ,isnull(vista.IdIncarico,1) IdIncarico
		   ,Codice CodDocumento
		   ,Descrizione DescrizioneDocumento

		FROM rs.v_CESAM_CB_PresenzaDocumenti vista

		JOIN #squadra
			ON vista.IdPersona = #squadra.IdPersona	AND #squadra.ProgressivoPersona = 2

			RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
end

ELSE IF @numerointestatari = 3
BEGIN
INSERT INTO #checkdocs (IdPersona
, Anagrafica
--, ProgressivoPersona
, Idincarico
, CodDocumento
, DescrizioneDocumento)
	SELECT
		(SELECT idpersona FROM #squadra where progressivopersona = 1)
	   ,(SELECT Anagrafica from #squadra where progressivopersona = 1)
	   --,#squadra.ProgressivoPersona
	   ,isnull(vista.IdIncarico,1) IdIncarico
	   ,Codice CodDocumento
	   ,Descrizione DescrizioneDocumento

	FROM rs.v_CESAM_CB_PresenzaDocumenti vista
	JOIN #squadra
		ON vista.IdPersona = #squadra.IdPersona and #squadra.ProgressivoPersona = 1

		RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
	UNION ALL
		SELECT
			(SELECT
					idpersona
				FROM #squadra
				WHERE progressivopersona = 2)
		   ,(SELECT
					Anagrafica
				FROM #squadra
				WHERE progressivopersona = 2)
		   --,#squadra.ProgressivoPersona
		   ,isnull(vista.IdIncarico,1) IdIncarico
		   ,Codice CodDocumento
		   ,Descrizione DescrizioneDocumento

		FROM rs.v_CESAM_CB_PresenzaDocumenti vista

		JOIN #squadra
			ON vista.IdPersona = #squadra.IdPersona
				AND #squadra.ProgressivoPersona = 2

			RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
UNION ALL
		SELECT
			(SELECT	idpersona	FROM #squadra	WHERE progressivopersona = 3)
		   ,(SELECT	Anagrafica	FROM #squadra	WHERE progressivopersona = 3)
		   --,#squadra.ProgressivoPersona
		  ,isnull(vista.IdIncarico,1) IdIncarico
		   ,Codice CodDocumento
		   ,Descrizione DescrizioneDocumento

		FROM rs.v_CESAM_CB_PresenzaDocumenti vista

		JOIN #squadra	ON vista.IdPersona = #squadra.IdPersona	AND #squadra.ProgressivoPersona = 3

			RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
END

else
begin
INSERT INTO #checkdocs (IdPersona
, Anagrafica
--, ProgressivoPersona
, Idincarico
, CodDocumento
, DescrizioneDocumento)
	SELECT
		(SELECT idpersona FROM #squadra where progressivopersona = 1)
	   ,(SELECT Anagrafica from #squadra where progressivopersona = 1)
	   --,#squadra.ProgressivoPersona
	   ,isnull(vista.IdIncarico,1) IdIncarico
	   ,Codice CodDocumento
	   ,Descrizione DescrizioneDocumento

	FROM rs.v_CESAM_CB_PresenzaDocumenti vista
	JOIN #squadra
		ON vista.IdPersona = #squadra.IdPersona and #squadra.ProgressivoPersona = 1

	RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
UNION ALL
		SELECT
			(SELECT	idpersona FROM #squadra	WHERE progressivopersona = 2)
		   ,(SELECT	Anagrafica	FROM #squadra WHERE progressivopersona = 2)
		   --,#squadra.ProgressivoPersona
		   ,isnull(vista.IdIncarico,1) IdIncarico
		   ,Codice CodDocumento
		   ,Descrizione DescrizioneDocumento

		FROM rs.v_CESAM_CB_PresenzaDocumenti vista

		JOIN #squadra
			ON vista.IdPersona = #squadra.IdPersona	AND #squadra.ProgressivoPersona = 2

		RIGHT JOIN (SELECT Codice, Descrizione from #documenti) documenti
			ON vista.Tipo_Documento = documenti.Codice
UNION ALL
		SELECT
			(SELECT	idpersona	FROM #squadra	WHERE progressivopersona = 3)
		   ,(SELECT	Anagrafica	FROM #squadra	WHERE progressivopersona = 3)
		   --,#squadra.ProgressivoPersona
		   ,isnull(vista.IdIncarico,1) IdIncarico
		   ,Codice CodDocumento
		   ,Descrizione DescrizioneDocumento

		FROM rs.v_CESAM_CB_PresenzaDocumenti vista

		JOIN #squadra	ON vista.IdPersona = #squadra.IdPersona	AND #squadra.ProgressivoPersona = 3

			RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
UNION ALL
		SELECT
			(SELECT	idpersona	FROM #squadra	WHERE progressivopersona = 4)
		   ,(SELECT	Anagrafica	FROM #squadra	WHERE progressivopersona = 4)
		   --,#squadra.ProgressivoPersona
		   ,isnull(vista.IdIncarico,1) IdIncarico
		   ,Codice CodDocumento
		   ,Descrizione DescrizioneDocumento

		FROM rs.v_CESAM_CB_PresenzaDocumenti vista

		JOIN #squadra	ON vista.IdPersona = #squadra.IdPersona	AND #squadra.ProgressivoPersona = 4

			RIGHT JOIN  #documenti 
		ON vista.Tipo_Documento = #documenti.Codice
END

--SELECT * FROM #checkdocs

 if EXISTS (SELECT * from #checkdocs where IdIncarico = 1)
BEGIN
SET @RES_CodGiudizioControllo = 4
END
else
begin
set @RES_CodGiudizioControllo = 2
end


set @RED_Note = 
replace(replace(replace(replace(replace(replace(cast((
select Anagrafica a,

(select 
	DescrizioneDocumento + space(1) +  (CASE Idincarico
										when @IdIncarico THEN 'presente nell''incarico corrente'  
											when 1 THEN 'non presente'  
											 else 'presente su IdIncarico' + space(1) + CAST(Idincarico as varchar(50)) end) as stringa 
	from #checkdocs 
	where #checkdocs.anagrafica = #squadra.anagrafica
	for XML AUTO, TYPE
	)
from #squadra 
for XML PATH ('persona')) as varchar(max)),'<persona>',''),'</persona>', char(10) + char(10)),'<a>',''),'</a>',char(13)),'<_x0023_checkdocs stringa="',char(9)),'"/>',char(13))

print @RED_Note

DROP TABLE #squadra
DROP TABLE #checkdocs
DROP TABLE #documenti

END

END   
    
--===========================================================================================================

select       @RES_CodGiudizioControllo as CodGiudizioControllo,
             @RED_CodEsitoControllo  as CodEsitoControllo ,
             @RED_Note as Note





End Try

Begin Catch
SELECT  'Errore: inviare ad ORGA una segnalazione'
End Catch

GO