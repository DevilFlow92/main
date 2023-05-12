USE CLC_Cesam
GO
/*
SELECT * FROM dbo.T_Contatto
JOIN dbo.T_Promotore ON T_Contatto.IdPersona = T_Promotore.IdPersona
WHERE FlagAttivo = 1
AND codice = '0335'

SELECT * FROM scratch.L_CESAM_AZ_Import_AnagraficaConsulenti_Segreteria
WHERE CodicePF = 'A359'


--INSERT INTO scratch.L_CESAM_AZ_Import_AnagraficaConsulenti_Segreteria (CodicePF, EmailSegreteria, Ordine)
--	VALUES ('B753', 'grazia.bruno@azimut.it', 1)
--	,('B753','martina.moccia@azimut.it',2);


SELECT MAX(IdIncarico)
FROM dbo.T_R_Incarico_Promotore
JOIN dbo.T_Promotore ON T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
WHERE codice = 'A359'


--INSERT INTO scratch.L_CESAM_AZ_Import_AnagraficaConsulenti_RelazioneTeam_Consulente (CodiceTeam, CodiceComponente, Ordine)
--SELECT 'b887', Cod_PF, ROW_NUMBER() OVER (ORDER BY Cod_PF)
--FROM scratch.L_CESAM_AZ_Import_AnagraficaConsulenti
--WHERE Cod_PF IN ('6574','5432','4522','B375'
--)


--EXEC scratch.Consolida_CESAM_AZ_ConsulentiFinanziari_Contatti

--EXEC orga.CESAM_AZ_ReteCF_Contatti_EsegueAggiornamento

*/

DELETE FROM scratch.L_CESAM_AZ_Import_AnagraficaConsulenti_Segreteria
WHERE CodicePF IN (
'3602'
,'5663'
,'A440'
,'0359'
,'7674'
,'3294'
,'3589'
,'7249'
,'0063'
,'6481'
,'0679'
,'A327'
,'0313'
,'1798'
,'B044'
,'A464'
,'4078'
,'2377'
,'4973'
,'6232'
,'6732'
,'B326'
,'B588'
,'A030'
,'C121'

)

;WITH target_deactivate AS (
	SELECT IdContatto, T_Contatto.IdPersona 
	FROM dbo.T_Contatto
	JOIN dbo.T_Promotore ON T_Contatto.IdPersona = T_Promotore.IdPersona
	WHERE FlagAttivo = 1 
	AND CodRuoloContatto = 13
	AND codice IN (
	'3602'
,'5663'
,'A440'
,'0359'
,'7674'
,'3294'
,'3589'
,'7249'
,'0063'
,'6481'
,'0679'
,'A327'
,'0313'
,'1798'
,'B044'
,'A464'
,'4078'
,'2377'
,'4973'
,'6232'
,'6732'
,'B326'
,'B588'
,'A030'
,'C121'
	)

) UPDATE dbo.T_Contatto
SET FlagAttivo = 0
FROM dbo.T_Contatto 
JOIN target_deactivate ON T_Contatto.IdContatto = target_deactivate.IdContatto
AND T_Contatto.IdPersona = target_deactivate.IdPersona

;
WITH 
segretarie AS (
	SELECT 'grazia.bruno@azimut.it' Email UNION
	SELECT 'martina.moccia@azimut.it' Email
)
,target_insert_setup AS (
	SELECT dbo.T_Promotore.codice, dbo.T_Promotore.IdPersona
	FROM dbo.T_Promotore

	WHERE Codice in (
'3602'
,'5663'
,'A440'
,'0359'
,'7674'
,'3294'
,'3589'
,'7249'
,'0063'
,'6481'
,'0679'
,'A327'
,'0313'
,'1798'
,'B044'
,'A464'
,'4078'
,'2377'
,'4973'
,'6232'
,'6732'
,'B326'
,'B588'
,'A030'
,'C121'
	)
) 
INSERT INTO scratch.L_CESAM_AZ_Import_AnagraficaConsulenti_Segreteria (CodicePF, EmailSegreteria, Ordine)
SELECT target_insert_setup.Codice, segretarie.Email, ROW_NUMBER() OVER (PARTITION BY Codice ORDER BY codice, Email)
FROM target_insert_setup
JOIN segretarie ON 1=1


;WITH segretarie AS (
SELECT 'alessia.berettini@azimut.it' Email UNION
SELECT 'barbara.scotti@azimut.it' Email		
)
,target_insert AS (
	SELECT Codice, IdPersona, 13 CodRuoloContatto, 'segreteria' note 
	FROM dbo.T_Promotore
	WHERE Codice IN (
'3602'
,'5663'
,'A440'
,'0359'
,'7674'
,'3294'
,'3589'
,'7249'
,'0063'
,'6481'
,'0679'
,'A327'
,'0313'
,'1798'
,'B044'
,'A464'
,'4078'
,'2377'
,'4973'
,'6232'
,'6732'
,'B326'
,'B588'
,'A030'
,'C121'
	)
) 
INSERT INTO dbo.T_Contatto (IdPersona, Email, Descrizione, FlagAttivo, CodRuoloContatto)
SELECT IdPersona, Email, note, 1, CodRuoloContatto
FROM target_insert
JOIN segretarie on 1=1


