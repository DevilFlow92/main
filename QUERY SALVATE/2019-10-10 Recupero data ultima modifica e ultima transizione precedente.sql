USE CLC
GO

WITH incarichi AS (
SELECT IdIncarico FROM T_Incarico WHERE T_Incarico.IdIncarico IN (11349274
,11479328
,11543074
,11543078
,11587749
,11665189
,11733086
,11743080
,11743919
,11758098
,11761218
,11802929
,11802954
,11806247
,11812014
,11812017
,11826397
,11826744
,11832357
,11832751
,11866000
,11887248
,11894053
,11894059
,11901339
,11942046
,11942050
,11953694
,11976780
,11983657
,11988385
,11992022
,12001190
,12024182
,12048959
,12048977
,12057099
,12057808
,12078080
,12091889
,12096882
,12109511
,12110524
,12110524
,12137447
,12142782
,12162431
,12168387
,12187864
,12191928
,12191981
,12211543
,12241228
,12258802
,12267388
,12311697
,12311732
,12311732
,12315566
,12320278
,12351408
,12353124
,12380457
,12394510
,12394523
,12394534
,12395727
,12426477
,12435445
,12440642
,12444603
,12455773
,12461837
,12465523
,12499279
,12499362
,12553512
,12553518
,12568634
,12582387
,12595522
,12595586
,12603525
,12611732
,12619166
,12619177
,12625976
,12625991
,12646887
,12676417
,12683956
,12700441
,12729577
,12763462
,12792514
,12808294
,12814327
,12824969
,12840011
,12840026
,12875410
,12876133
,12876163
,12890440
,12890608
,12891749
,12900024
,12900032
,12900036
,12908115
,12926880
,12926885
,12936012
,12936061
,12964294
,12964331
,12982245
,12989484
,13001507
,13011293
,13023840
,13026516
,13027574
,13027578
,13027606
,13031323
,13050010
,13072105
,13072423
,13080820
)
),transizione AS (


SELECT l.DataPrecedente, i.IdTransizione, i.IdIncarico
FROM 
(SELECT	LAG(lwi.DataTransizione, 1) OVER (PARTITION BY lwi.IdIncarico ORDER BY lwi.idtransizione) DataPrecedente
	,lwi.* FROM L_WorkflowIncarico lwi
	JOIN incarichi ON incarichi.IdIncarico = lwi.IdIncarico
) l

JOIN (SELECT MAX(IdTransizione) IdTransizione, IdIncarico
		 FROM L_WorkflowIncarico 
		 
		 GROUP BY IdIncarico
		 ) i ON i.IdTransizione = l.IdTransizione and l.IdIncarico = i.IdIncarico

), modifica as (


SELECT l.DataPrecedente, l.IdSalvataggio, l.IdIncarico FROM
(SELECT LAG(DataSalvataggio,1) OVER (PARTITION BY L_SalvataggioIncarico.IdIncarico ORDER BY IdSalvataggio) DataPrecedente, L_SalvataggioIncarico.*
	FROM L_SalvataggioIncarico 
	JOIN incarichi ON incarichi.IdIncarico = L_SalvataggioIncarico.IdIncarico
) l

JOIN ( SELECT MAX(IdSalvataggio) IdSalvataggio, IdIncarico 
	FROM L_SalvataggioIncarico
	GROUP BY IdIncarico

) i ON i.IdSalvataggio = l.IdSalvataggio AND i.IdIncarico = l.IdIncarico

)

--UPDATE T_Incarico
--SET DataUltimaModifica = modifica.DataPrecedente
--,DataUltimaTransizione = transizione.DataPrecedente

select T_Incarico.IdIncarico, modifica.DataPrecedente DataModificaPrecedente, DataUltimaModifica, transizione.DataPrecedente DataTransizionePrecedente,DataUltimaTransizione

from T_Incarico JOIN modifica on T_Incarico.IdIncarico = modifica.IdIncarico
JOIN transizione ON T_Incarico.IdIncarico = transizione.IdIncarico