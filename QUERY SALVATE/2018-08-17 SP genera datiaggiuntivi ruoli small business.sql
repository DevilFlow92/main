USE CLC
GO

--ALTER PROCEDURE supporto.CESAM_CB_Inserimento_RuoliSmallBusiness 
--(@idincarico INT
--)

--AS
IF OBJECT_ID('tempdb.dbo.#schema') IS NOT NULL
	BEGIN
	DROP TABLE #schema
    END


BEGIN TRY
--================================

DECLARE @IdIncarico INT
SET @IdIncarico = 4425044 


--===============================
DECLARE @ListaDatiAggiuntivi TABLE 
(CodTipoDatoAggiuntivo INT
	,TipoDatoAggiuntivo VARCHAR(100)
)
--================================
INSERT into @ListaDatiAggiuntivi (CodTipoDatoAggiuntivo, TipoDatoAggiuntivo)
	SELECT Codice, Descrizione FROM D_TipoDatoAggiuntivo
	WHERE Codice IN (1248	--7° Delegato
					 ,1247	--6° Delegato
					 ,1246	--5° Delegato
					 ,1245	--4° Delegato
					 ,1244	--3° Delegato
					 ,1243	--2° Delegato
					 ,1242	--1° Delegato
					 ,1241	--6° Titolare Effettivo
					 ,1240	--5° Titolare Effettivo
					 ,1239	--4° Titolare Effettivo
					 ,1238	--3° Titolare Effettivo
					 ,1237	--2° Titolare Effettivo
					 ,1236	--1° Titolare Effettivo
					 ,1249	--1° Intestatario
					 ,1250  --1° Rappresentante Legale
					);

;WITH cte AS (

SELECT 	--tr.IdRelazione,
		--tr.IdIncarico
		--,tr.IdPersona
		DENSE_RANK() OVER (PARTITION BY CodRuoloRichiedente ORDER BY Progressivo) NTitolareEffettivo
		,tr.Progressivo
		,tr.CodRuoloRichiedente
		,D_RuoloRichiedente.Descrizione Ruolo
		,T_Persona.ChiaveCliente
		,T_Persona.Nome
		,T_Persona.Cognome
		,T_Persona.RagioneSociale

FROM T_R_Incarico_Persona tr
JOIN D_RuoloRichiedente ON Codice = tr.CodRuoloRichiedente
JOIN T_Persona ON tr.IdPersona = T_Persona.IdPersona
WHERE tr.IdIncarico = @IdIncarico  
GROUP BY tr.Progressivo
		,tr.CodRuoloRichiedente
		,D_RuoloRichiedente.Descrizione 
		,T_Persona.ChiaveCliente
		,T_Persona.Nome
		,T_Persona.Cognome
		,T_Persona.RagioneSociale
)

SELECT CAST(NTitolareEffettivo as VARCHAR(3)) + '°' + SPACE(1) + Ruolo AS RuoloDatoAggiuntivo
		,Progressivo
		,CodRuoloRichiedente
		,ChiaveCliente
		,Nome
		,Cognome
		,[@ListaDatiAggiuntivi].CodTipoDatoAggiuntivo
		--,RagioneSociale
INTO #schema
 FROM cte JOIN @ListaDatiAggiuntivi ON (CAST(NTitolareEffettivo as VARCHAR(3)) + '°' + SPACE(1) + Ruolo) = [@ListaDatiAggiuntivi].TipoDatoAggiuntivo

 --WHERE CodRuoloRichiedente in (32,58)

 IF EXISTS (SELECT * FROM T_DatoAggiuntivo 
				JOIN #schema ON T_DatoAggiuntivo.CodTipoDatoAggiuntivo = #schema.CodTipoDatoAggiuntivo
				where IdIncarico = @IdIncarico AND FlagAttivo = 1)
	BEGIN
		IF EXISTS (SELECT CodTipoDatoAggiuntivo FROM #schema
						EXCEPT
						SELECT T_DatoAggiuntivo.CodTipoDatoAggiuntivo FROM T_DatoAggiuntivo join @ListaDatiAggiuntivi ON T_DatoAggiuntivo.CodTipoDatoAggiuntivo = [@ListaDatiAggiuntivi].CodTipoDatoAggiuntivo 
						WHERE IdIncarico = @IdIncarico AND FlagAttivo = 1
							)
		BEGIN
		PRINT 'Zappo e riscrivo per inserirne nuovi'
			DELETE td
			FROM T_DatoAggiuntivo td
			JOIN @ListaDatiAggiuntivi ON td.CodTipoDatoAggiuntivo = [@ListaDatiAggiuntivi].CodTipoDatoAggiuntivo
			WHERE IdIncarico = @IdIncarico and td.FlagAttivo = 1
		
			INSERT into T_DatoAggiuntivo (IdIncarico, CodTipoDatoAggiuntivo, Testo, FlagAttivo)
			SELECT @IdIncarico, CodTipoDatoAggiuntivo,Progressivo,1
			from #schema
					
		END
		 
		ELSE IF EXISTS (SELECT T_DatoAggiuntivo.CodTipoDatoAggiuntivo FROM T_DatoAggiuntivo	JOIN @ListaDatiAggiuntivi on T_DatoAggiuntivo.CodTipoDatoAggiuntivo = [@ListaDatiAggiuntivi].CodTipoDatoAggiuntivo
						WHERE IdIncarico = @IdIncarico	AND FlagAttivo = 1
						
							EXCEPT
						SELECT CodTipoDatoAggiuntivo FROM #schema)
			BEGIN
			PRINT 'Zappo e riscrivo perchè devo togliere'
				DELETE td
				FROM T_DatoAggiuntivo td
				JOIN @ListaDatiAggiuntivi oN td.CodTipoDatoAggiuntivo = [@ListaDatiAggiuntivi].CodTipoDatoAggiuntivo
				WHERE IdIncarico = @IdIncarico	AND td.FlagAttivo = 1

				INSERT INTO T_DatoAggiuntivo (IdIncarico, CodTipoDatoAggiuntivo, Testo, FlagAttivo)
				SELECT	@IdIncarico	,CodTipoDatoAggiuntivo	,Progressivo ,1
				FROM #schema
			END
		ELSE
			BEGIN
			PRINT 'update'
					UPDATE T_DatoAggiuntivo
					SET Testo = Progressivo
					FROM T_DatoAggiuntivo
					JOIN #schema ON T_DatoAggiuntivo.CodTipoDatoAggiuntivo = #schema.CodTipoDatoAggiuntivo
			END
	END
	
	ELSE
	BEGIN
	PRINT 'Inserisco'
		INSERT into T_DatoAggiuntivo (IdIncarico, CodTipoDatoAggiuntivo, Testo, FlagAttivo)
			SELECT
				@IdIncarico
				,CodTipoDatoAggiuntivo
				,Progressivo
				,1
			FROM #schema
			
	END
	
	

 DROP TABLE #schema
  
 END TRY

 BEGIN CATCH
 PRINT 'OrgaHELP'
 END CATCH


 GO



