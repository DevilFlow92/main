SELECT
	*
FROM T_CentroRaccolta
JOIN T_AreaCentroRaccolta
	ON T_CentroRaccolta.IdAreaCentroRaccolta = T_AreaCentroRaccolta.IdAreaCentroRaccolta

JOIN T_Sim
	ON T_AreaCentroRaccolta.IdSim = T_Sim.IdSim

WHERE T_CentroRaccolta.Codice = '00110'


SELECT
	*
FROM T_R_Incarico_Promotore
WHERE IdIncarico = 10555345


--UPDATE T_Promotore
--SET IdCentroRaccolta = 1075
--WHERE IdPromotore = 5660


--si segue il file da winscp, non FEND. A tendere ci sarà una SP che popola in base ai match con questo file.
--per ora lanciamo la SP a mano oppure apriamo i ticket via mail
--se invece il CDR non esiste, dobbiamo capire come censirlo da SP, per ora non si fa nulla, si manda un report per i promotori senza CDR non censito a DB




