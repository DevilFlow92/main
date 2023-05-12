USE CLC_Cesam
GO

DECLARE @flaginserisci INT = 1 --flag per inserire sulla tabella di spooling y_puliziaincarichi

IF OBJECT_ID('tempdb..#temp_incarichiposarchi') IS NOT NULL
	DROP TABLE #temp_incarichiposarchi
CREATE TABLE #temp_incarichiposarchi (
	idincarico INT
	,idposizione BIGINT
	,codicescatola VARCHAR(50)
)
 
 BEGIN TRAN

--SELECT * FROM #temp_incarichiposarchi


INSERT INTO #temp_incarichiposarchi (idincarico, idposizione,codicescatola)
select 9692200, 30001005007004, '116' UNION ALL
select 13174962, 30001005007008, '116' UNION ALL
select 11033579, 30001005007009, '116' UNION ALL
select 12927108, 30001005008001, '116' UNION ALL
select 12856496, 30001005008005, '116' UNION ALL
select 13197653, 30001005008008, '116' UNION ALL
select 13208545, 30001005009007, '116' UNION ALL
select 11986483, 30001006001001, '116' UNION ALL
select 13028119, 30001006001008, '116' UNION ALL
select 11055254, 30001006001009, '116' UNION ALL
select 9705222, 30001006002002, '116' UNION ALL
select 11059398, 30001006002005, '116' UNION ALL
select 13078064, 30001006002006, '116' UNION ALL
select 9452017, 30001006002008, '116' UNION ALL
select 9705926, 30001006002010, '116' UNION ALL
select 13019710, 30001006003005, '116' UNION ALL
select 11059489, 30001006003006, '116' UNION ALL
select 11059496, 30001006003007, '116' UNION ALL
select 11059676, 30001006003008, '116' UNION ALL
select 11063634, 30001006003010, '116' UNION ALL
select 11063904, 30001006004001, '116' UNION ALL
select 12895217, 30001006004002, '116' UNION ALL
select 13068776, 30001006004006, '116' UNION ALL
select 12660144, 30001006004009, '116' UNION ALL
select 9714266, 30001006005001, '116' UNION ALL
select 11064988, 30001006005002, '116' UNION ALL
select 11065050, 30001006005003, '116' UNION ALL
select 13247785, 30001006005006, '116' UNION ALL
select 13250618, 30001006005009, '116' UNION ALL
select 13133253, 30001006006002, '116' UNION ALL
select 11986636, 30001006006008, '116' UNION ALL
select 12904688, 30001006007001, '116' UNION ALL
select 13268029, 30001006007002, '116' UNION ALL
select 12408785, 30001006007006, '116' UNION ALL
select 13280183, 30001006007009, '116' UNION ALL
select 11073834, 30001006008005, '116' UNION ALL
select 11073950, 30001006008010, '116' UNION ALL
select 13250699, 30002001001002, '116' UNION ALL
select 13290419, 30002001001004, '116' UNION ALL
select 13316729, 30002001001006, '116' UNION ALL
select 11160681, 30002001001008, '116' UNION ALL
select 11161124, 30002001001009, '116' UNION ALL
select 13268070, 30002001002003, '116' UNION ALL
select 10970629, 30002001002005, '116' UNION ALL
select 13318252, 30002001002007, '116' UNION ALL
select 13339103, 30002001003004, '116' UNION ALL
select 13284199, 30002001003006, '116' UNION ALL
select 16231985, 30002001003009, '116' UNION ALL
select 13196943, 30002001004004, '116' UNION ALL
select 15530622, 30002001004005, '116' UNION ALL
select 13348380, 30002001004006, '116' UNION ALL
select 13257541, 30002001004010, '116' UNION ALL
select 13349645, 30002001005002, '116' UNION ALL
select 15768060, 30002001005006, '116' UNION ALL
select 11166566, 30002001005009, '116' UNION ALL
select 11166916, 30002001005010, '116' UNION ALL
select 11167526, 30002001006003, '116' UNION ALL
select 13347395, 30002001006006, '116' UNION ALL
select 13197555, 30002001006010, '116'



IF @flaginserisci = 1


BEGIN
	INSERT INTO orga.Y_PuliziaArchivio_Qtask 
		(idIncarico, CodCliente, CodTipoIncarico, PosizioneArchivioCaldo, periodo, progressivo, FlagEtichettaStampata, FlagMacero, Scatola)
	/*script di inserimento*/
	SELECT DISTINCT T_Incarico.IdIncarico
	,T_Incarico.CodCliente
	,T_Incarico.CodTipoIncarico
	, T_Documento.IdPosizioneArchivio 
	,NULL AS Periodo
	,NULL AS Progressivo
	,1 AS FlagEtichettaStampata
	,NULL AS Temporaneo
	,codicescatola AS Scatola
 
	FROM T_Incarico 
	--JOIN T_Incarico ON T_R_Incarico_SubIncarico.IdIncarico = T_Incarico.IdIncarico
	JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
	JOIN #temp_incarichiposarchi ON #temp_incarichiposarchi.idincarico = T_Incarico.IdIncarico
	AND T_Documento.IdPosizioneArchivio = #temp_incarichiposarchi.idposizione
	LEFT JOIN orga.Y_PuliziaArchivio_Qtask ON T_Incarico.IdIncarico = orga.Y_PuliziaArchivio_Qtask.idIncarico 
	WHERE orga.Y_PuliziaArchivio_Qtask.idIncarico IS NULL AND T_Documento.IdPosizioneArchivio IS NOT NULL

 
	UNION 
 
	SELECT DISTINCT T_R_Incarico_SubIncarico.IdSubIncarico AS IdIncarico
	,T_Incarico.CodCliente
	,T_Incarico.CodTipoIncarico
 	
	, T_Documento.IdPosizioneArchivio 
	,NULL AS Periodo
	,NULL AS Progressivo
	,1 AS FlagEtichettaStampata
	,NULL AS Temporaneo
	,codicescatola AS Scatola
	--,T_R_Incarico_SubIncarico.IdIncarico SCATOLA
	FROM T_R_Incarico_SubIncarico 
	JOIN T_Incarico ON T_R_Incarico_SubIncarico.IdSubIncarico = T_Incarico.IdIncarico
	JOIN T_Documento ON T_R_Incarico_SubIncarico.IdSubIncarico = T_Documento.IdIncarico
	JOIN #temp_incarichiposarchi ON #temp_incarichiposarchi.idincarico = T_R_Incarico_SubIncarico.IdIncarico
	AND T_Documento.IdPosizioneArchivio = #temp_incarichiposarchi.idposizione
	
	LEFT JOIN orga.Y_PuliziaArchivio_Qtask ON T_R_Incarico_SubIncarico.IdSubIncarico = orga.Y_PuliziaArchivio_Qtask.idIncarico 
	WHERE orga.Y_PuliziaArchivio_Qtask.idIncarico IS NULL AND T_Documento.IdPosizioneArchivio IS NOT NULL
	
END
ELSE
BEGIN
--SELECT DISTINCT idincarico FROM #temp_incarichiposarchi
--EXCEPT
	/*script di inserimento*/
	SELECT DISTINCT T_Incarico.IdIncarico
	,T_Incarico.CodCliente
	,T_Incarico.CodTipoIncarico
	, T_Documento.IdPosizioneArchivio 
	,NULL AS Periodo
	,NULL AS Progressivo
	,1 AS FlagEtichettaStampata
	,NULL AS Temporaneo
	,codicescatola AS Scatola
 
	FROM T_Incarico 
	--JOIN T_Incarico ON T_R_Incarico_SubIncarico.IdIncarico = T_Incarico.IdIncarico
	JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
	JOIN #temp_incarichiposarchi ON #temp_incarichiposarchi.idincarico = T_Incarico.IdIncarico
	AND T_Documento.IdPosizioneArchivio = #temp_incarichiposarchi.idposizione
	LEFT JOIN orga.Y_PuliziaArchivio_Qtask ON T_Incarico.IdIncarico = orga.Y_PuliziaArchivio_Qtask.idIncarico 
	WHERE orga.Y_PuliziaArchivio_Qtask.idIncarico IS NULL AND T_Documento.IdPosizioneArchivio IS NOT NULL
	 
	UNION 
 
	SELECT DISTINCT T_R_Incarico_SubIncarico.IdSubIncarico AS IdIncarico
	,T_Incarico.CodCliente
	,T_Incarico.CodTipoIncarico
 	
	, T_Documento.IdPosizioneArchivio 
	,NULL AS Periodo
	,NULL AS Progressivo
	,1 AS FlagEtichettaStampata
	,NULL AS Temporaneo
	,codicescatola AS Scatola
	--,T_R_Incarico_SubIncarico.IdIncarico SCATOLA
	FROM T_R_Incarico_SubIncarico 
	JOIN T_Incarico ON T_R_Incarico_SubIncarico.IdSubIncarico = T_Incarico.IdIncarico
	JOIN T_Documento ON T_R_Incarico_SubIncarico.IdSubIncarico = T_Documento.IdIncarico
	JOIN #temp_incarichiposarchi ON #temp_incarichiposarchi.idincarico = T_R_Incarico_SubIncarico.IdIncarico
	AND T_Documento.IdPosizioneArchivio = #temp_incarichiposarchi.idposizione
	
	LEFT JOIN orga.Y_PuliziaArchivio_Qtask ON T_R_Incarico_SubIncarico.IdSubIncarico = orga.Y_PuliziaArchivio_Qtask.idIncarico 
	WHERE orga.Y_PuliziaArchivio_Qtask.idIncarico IS NULL AND T_Documento.IdPosizioneArchivio IS NOT NULL
	
 
END




COMMIT TRAN


/***** come è stata effettuata l'insert, eseguite questa SP *************/

--EXEC orga.PuliziaArchivio_Qtask @CodiceArchivioFreddo = 35
--							   ,@CodCliente = 23

/************************************************************************/


/* verifica quali e quante posizioni archivio sono libere */
SELECT DISTINCT Descrizione 
+ '-' + RIGHT('000'+convert(VARCHAR(3),CodiceSezione),3) 
+ '-' + RIGHT('000'+CONVERT(VARCHAR(3),CodicePiano),3) 
+ '-' + RIGHT('000'+CONVERT(VARCHAR(3),CodiceScatola),3)
+ '-' + right('000'+CONVERT(VARCHAR(3),CodColore),3)
FROM S_PosizioneArchivio
JOIN D_Scaffale ON S_PosizioneArchivio.CodScaffale = D_Scaffale.Codice
LEFT JOIN T_PeriodoPosizioneArchivioUtilizzata ON S_PosizioneArchivio.IdPosizioneArchivio = T_PeriodoPosizioneArchivioUtilizzata.IdPosizioneArchivio
LEFT JOIN T_Documento ON S_PosizioneArchivio.IdPosizioneArchivio = T_Documento.IdPosizioneArchivio
WHERE (CodScaffale = 30 OR (CodScaffale = 44 AND CodiceSezione IN (1,2,3,4,5,6,7)))
AND CodCliente = 23
AND CodTipoIncarico = 54
AND IdPeriodoPosizioneArchivioUtilizzata IS NULL
AND Documento_id IS NULL






