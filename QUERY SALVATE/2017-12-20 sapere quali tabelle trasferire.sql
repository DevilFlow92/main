use CLC_Cesam
GO

WITH cte
AS
(SELECT
		COUNT(*) AS NumeroTabelle
	   ,r.CodGruppoTabelleSetup
	FROM [DB-CLC-SETUPBT].CLC_Cesam.dbo.R_GruppoTabelleSetup_TabellaSetup r
	GROUP BY r.CodGruppoTabelleSetup)

SELECT
	dtab.Descrizione AS Tabella
   ,dgruppo.Codice AS CodGruppoTabelle
   ,dgruppo.Descrizione AS GruppoTabelleSetup
   ,cte.NumeroTabelle
FROM [DB-CLC-SETUPBT].CLC_Cesam.dbo.D_TabellaSetup dtab
JOIN [DB-CLC-SETUPBT].CLC_Cesam.dbo.R_GruppoTabelleSetup_TabellaSetup r
	ON dtab.Codice = r.CodTabellaSetup
JOIN cte
	ON r.CodGruppoTabelleSetup = cte.CodGruppoTabelleSetup
JOIN [DB-CLC-SETUPBT].CLC_Cesam.dbo.D_GruppoTabelleSetup dgruppo
	ON cte.CodGruppoTabelleSetup = dgruppo.Codice

WHERE dtab.Descrizione like '%R_ProfiloAccesso_RuoloOperatoreIncarico%'
ORDER BY cte.NumeroTabelle

SELECT
	CASE
		WHEN MAX(DataEsecuzione) > dateadd(MINUTE, -5, GETDATE())  THEN 'Devi attendere altri ' + CAST(5 - DATEDIFF(MINUTE, MAX(DataEsecuzione), GETDATE()) AS VARCHAR(1)) + ' minuti prima di procedere al trasferimento.'
		ELSE 'Puoi procedere al trasferimento.' 
	END	
FROM dbo.L_DeploySetup


SELECT --TOP 10
	IdDeploySetup
   ,DataEsecuzione
   ,Utente
   ,CodGruppoTabelleSetup
   ,TempoEsecuzione
   ,NumeroTabelle
   ,Hostname Hostname
   ,FlagSuccesso
   ,Codice
   ,Descrizione FROM L_DeploySetup
JOIN D_GruppoTabelleSetup ON L_DeploySetup.CodGruppoTabelleSetup = D_GruppoTabelleSetup.Codice
WHERE dataesecuzione >= CONVERT(DATE,getdate())

ORDER BY IdDeploySetup DESC

