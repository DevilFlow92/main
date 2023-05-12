use clc


SELECT * FROM S_Report where Nome LIKE '%caricamento%switch%'
--idreport 2124

select * FROM R_ProfiloAccesso_Report where IdReport = 2124
--codici profili: 939,940

select * FROM R_Report_FormatoReport where IdReport = 2124

INSERT INTO [dbo].[S_Report]
           ([Nome]
           ,[CodCliente]
           ,[CodTipoIncarico]
           ,[CodCategoriaReport]
           ,[CodConsegnaReport]
           ,[FlagExtranetCLC]
           ,[FlagQTask]
           ,[Percorso]
           ,[FlagAttivo]
           ,[CodFormatoReport]
           ,[FlagImbarcabile]
           ,[FlagTabReport])

select 'AZ - Incarichi Switch-Rimborsi AFB in Coda di Lavorazione',
		CodCliente,CodTipoIncarico,CodCategoriaReport,CodConsegnaReport, FlagExtranetCLC,FlagQTask,
		'/Reportistica Esterna/CESAM/AZIMUT/AZ - Incarichi Switch-Rimborsi AFB in Coda di Lavorazione',
		FlagAttivo,CodFormatoReport,FlagImbarcabile,FlagTabReport

from S_Report
where IdReport = 2124 

SELECT * FROM S_Report order BY IdReport DESC
--idreport 2208

INSERT INTO [dbo].[R_ProfiloAccesso_Report]
           ([CodProfiloAccesso]
           ,[CodCategoriaReport]
           ,[IdReport]
           ,[FlagAbilita])


select CodProfiloAccesso,
		CodCategoriaReport,
		2208,
		FlagAbilita

from R_ProfiloAccesso_Report
where IdReport = 2124



INSERT INTO [dbo].[R_Report_FormatoReport]
           ([IdReport]
           ,[CodFormatoReport])

select 2208
		,CodFormatoReport

from R_Report_FormatoReport
where IdReport = 2124


--gruppo deploy: report
