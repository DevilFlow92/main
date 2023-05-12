use CLC

SELECT * FROM S_Report where Percorso LIKE '%289%'
--idreport 2129

INSERT into S_Report (Nome, CodCliente, CodTipoIncarico, CodCategoriaReport, CodConsegnaReport, FlagExtranetCLC, FlagQTask, Percorso, FlagAttivo, CodFormatoReport, 
						FlagImbarcabile, FlagTabReport)

SELECT 'AZ - AFB - Saldo Quota Fondi', 
		CodCliente, 
		CodTipoIncarico, 
		CodCategoriaReport, 
		CodConsegnaReport, 
		FlagExtranetCLC, 
		FlagQTask, 
		'/Reportistica Esterna/CESAM/Azimut/AZ - AFB - Saldo Quota Fondi', 
		FlagAttivo, 
		CodFormatoReport, 
		FlagImbarcabile, 
		FlagTabReport
FROM S_Report 
where IdReport = 2129

SELECT * FROM S_Report order BY IdReport DESC
--2189


insert INTO R_ProfiloAccesso_Report (CodProfiloAccesso, CodCategoriaReport, IdReport, FlagAbilita)

SELECT CodProfiloAccesso,
       CodCategoriaReport,
       2189,
       FlagAbilita 
	FROM dbo.R_ProfiloAccesso_Report 
WHERE IdReport = 2129

--2 righe ok


INSERT INTO R_Report_FormatoReport
VALUES (2189, 5)

--trasferisci in produzione
SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'S_Report'

--report

