USE [CLC]
GO

/****** Object:  StoredProcedure [rs].[CESAM_AutomatismoTransizioneSimulaScaduta]    Script Date: 02/03/2018 09:34:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--ALTER procedure [rs].[CESAM_AutomatismoTransizioneSimulaScaduta] as 

/*
L'incarico è da considerarsi irregolare (e da transitare in Archiviata - Decorrenza Termini)
nei seguenti casi:
	- Pratica perfezionata prima che venga staccata la simula --> Data Sottoscrizione (Operazione) < Data Simula
	- Pratica perfezionata quando la simula è scaduta --> Data Sottoscrizione (Operazione) > Data Decorrenza (15gg lavorativi dopo la data di simula)
*/

--select * from D_StatoWorkflowIncarico where Descrizione LIKE '%decorr%'
--10210      Decorrenza dei termini

declare @CreazioneFiltro datetime

set @CreazioneFiltro = '2018-01-01'

if object_id(N'tempdb.##decorrenzaincarichi',N'U') is not null
drop TABLE ##decorrenzaincarichi

CREATE table ##decorrenzaincarichi (IdIncarico int
									,CodTipoIncarico int
									,DataCreazione datetime
									,DataSottoscrizione datetime
									,NumeroSimula int
									,DataSimula datetime
									--,DataImport datetime
															)
BEGIN
--estraggo gli incarichi con simula scaduta
insert INTO ##decorrenzaincarichi (IdIncarico 
									,CodTipoIncarico 
									,DataCreazione 
									,DataSottoscrizione
									,NumeroSimula
									,DataSimula 
									--,DataImport
												)
select DISTINCT T_Incarico.IdIncarico
			,CodTipoIncarico
			,DataCreazione
			,DataOperazione as DataSottoscrizione
			,NUMERO_SIMULA as NumeroSimula
			,DATA_SALVATAGGIO as DataSimula
			--,DataImport
FROM T_Incarico
	left JOIN  T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico

	JOIN (SELECT min(IdPagamento) IdPagamento

						,T_PagamentoInvestimento.IdIncarico FROM T_PagamentoInvestimento 
						where CodTipoPagamento = 36
						GROUP BY T_PagamentoInvestimento.IdIncarico) inputpagamento ON inputpagamento.IdIncarico = T_Incarico.IdIncarico
	JOIN T_PagamentoInvestimento on inputpagamento.IdPagamento = T_PagamentoInvestimento.IdPagamento

	left JOIN T_DatiAggiuntiviIncaricoAzimut on T_DatiAggiuntiviIncaricoAzimut.IdIncarico = T_Incarico.IdIncarico

	left join T_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato

	JOIN scratch.L_ImportSimula_Operativo on (cast(NUMERO_SIMULA as varchar(20)) = NumeroSimula AND CodTipoRaccomandazione IS null)

WHERE 
	CodArea = 8 and
	CodCliente = 23
	AND CodTipoIncarico in (321,322,324)
	and DataCreazione >= @CreazioneFiltro

	and (dateadd(hour,23,DataOperazione) < DATA_SALVATAGGIO OR
			datediff(DAY,rs.DateAdd_GiorniLavorativi(23,DATA_SALVATAGGIO,15),DataOperazione) > 0 )

	and CodStatoWorkflowIncarico NOT in(10210,820) --escludo quelli che sono già in decorrenza di termini e le lavorazioni concluse

UNION ALL 
SELECT DISTINCT
	T_Incarico.IdIncarico
   ,CodTipoIncarico
   ,DataCreazione
   ,DataOperazione AS DataSottoscrizione
   ,NUMERO_SIMULA_MAX as NumeroSimula
   ,DATA_SALVATAGGIO AS DataSimula
   --,DataImport
FROM T_Incarico
LEFT JOIN T_R_Incarico_Mandato
	ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico

JOIN (SELECT
		MIN(IdPagamento) IdPagamento
	   ,T_PagamentoInvestimento.IdIncarico
	  FROM T_PagamentoInvestimento
	  WHERE CodTipoPagamento = 36
	  GROUP BY T_PagamentoInvestimento.IdIncarico) inputpagamento  ON inputpagamento.IdIncarico = T_Incarico.IdIncarico
JOIN T_PagamentoInvestimento ON inputpagamento.IdPagamento = T_PagamentoInvestimento.IdPagamento

LEFT JOIN T_DatiAggiuntiviIncaricoAzimut ON T_DatiAggiuntiviIncaricoAzimut.IdIncarico = T_Incarico.IdIncarico

LEFT JOIN T_Mandato	ON T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato

JOIN scratch.L_ImportSimula_Operativo ON (CAST(NUMERO_SIMULA_MAX AS VARCHAR(20)) = NumeroSimula	AND CodTipoRaccomandazione IN(1,2))

WHERE CodArea = 8
AND CodCliente = 23
AND CodTipoIncarico IN (321, 322, 324)
AND DataCreazione >= @CreazioneFiltro

AND (dateadd(hour,23,DataOperazione) < DATA_SALVATAGGIO
OR DATEDIFF(DAY, rs.DateAdd_GiorniLavorativi(23, DATA_SALVATAGGIO, 15), DataOperazione) > 0)

AND CodStatoWorkflowIncarico NOT IN (10210, 820) --escludo quelli che sono già in decorrenza di termini e le lavorazioni concluse


select * FROM ##decorrenzaincarichi

/*
--aggiorno lo stato wf

UPDATE T_Incarico
set CodStatoWorkflowIncarico = 10210
FROM T_Incarico inner join #decorrenzaincarichi on T_Incarico.IdIncarico = #decorrenzaincarichi.IdIncarico


--faccio la insert nella L_WorkflowIncarico per tracciare la transizione su QTask

INSERT INTO [dbo].[L_WorkflowIncarico]
           ([IdIncarico]
           ,[IdOperatore]
           ,[DataTransizione]
           ,[CodTipoWorkflow]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagManuale]
           ,[CodAttributoIncaricoPartenza]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagAttesaPartenza]
           ,[FlagAttesaDestinazione]
           ,[CodAreaPartenza]
           ,[CodAreaDestinazione])

SELECT ultimidati.IdIncarico										[IdIncarico]
	   ,21															[IdOperatore] --sistema
	   ,getdate()													[DataTransizione]
	   ,ultimidati.CodTipoWorkflow									[CodTipoWorkflow]
	   ,ultimidati.CodStatoWorkflowIncaricoDestinazione				[CodStatoWorkflowIncaricoPartenza]
	   ,ultimidati.FlagUrgenteDestinazione							[FlagUrgentePartenza]
	   ,10210														[CodStatoWorkflowIncaricoDestinazione]
	   ,ultimidati.FlagUrgenteDestinazione							[FlagUrgenteDestinazione]
	   ,0															[FlagManuale] 
	   ,ultimidati.CodAttributoIncaricoDestinazione					[CodAttributoIncaricoPartenza]
	   ,ultimidati.CodAttributoIncaricoDestinazione					[CodAttributoIncaricoDestinazione]
	   ,ultimidati.FlagAttesaDestinazione							[FlagAttesaPartenza]
	   ,ultimidati.FlagAttesaDestinazione							[FlagAttesaDestinazione]
	   ,ultimidati.CodAreaDestinazione								[CodAreaPartenza]
	   ,ultimidati.CodAreaDestinazione								[CodAreaDestinazione]
								
from  ##decorrenzaincarichi 

join (SELECT max(IdTransizione) IdTransizione,
								IdIncarico
	  from L_WorkflowIncarico
	  --where IdIncarico = 4424314 
	 group BY IdIncarico 				) inputultimidati on inputultimidati.IdIncarico = ##decorrenzaincarichi.IdIncarico

JOIN L_WorkflowIncarico ultimidati ON inputultimidati.IdTransizione = ultimidati.IdTransizione


--Report: Incarichi transitati automaticamente in decorrenza dei termini

SELECT	##decorrenzaincarichi.IdIncarico
		,##decorrenzaincarichi.CodTipoIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		,##decorrenzaincarichi.DataCreazione
		,wf.DataTransizione
		,anagrafica.ChiaveClienteIntestatario + ' ' + 
			case WHEN anagrafica.CognomeIntestatario IS NULL or anagrafica.NomeIntestatario IS NULL 
					OR anagrafica.CognomeIntestatario = '' OR anagrafica.NomeIntestatario = '' THEN anagrafica.RagioneSocialeIntestatario 
					
			ELSE anagrafica.CognomeIntestatario + ' ' + anagrafica.NomeIntestatario END Anagrafica
		,anagrafica.CodicePromotore + ' ' + 
			CASE WHEN anagrafica.CognomePromotore IS NULL or anagrafica.NomePromotore IS NULL
					or anagrafica.CognomePromotore = '' OR anagrafica.NomePromotore = '' THEN anagrafica.RagioneSocialePromotore
			ELSE anagrafica.CognomePromotore + ' ' + anagrafica.NomePromotore END Promotore
		,DataSimula
		,DataDecorrenza
		,wf.CodStatoWorkflowIncaricoPartenza
		,dmacropartenza.Descrizione + '-' + WFPartenza.Descrizione StatoWorkflowPartenza
		,wf.CodAttributoIncaricoPartenza
		,attributopartenza.Descrizione AttributoIncaricoPartenza
		,wf.CodStatoWorkflowIncaricoDestinazione
		,dmacrodestinazione.Descrizione + '-' + WFDestinazione.Descrizione StatoWorkflowDestinazione
		,wf.CodAttributoIncaricoDestinazione
		,attributodestinazione.Descrizione AttributoIncaricoDestinazione

FROM  ##decorrenzaincarichi

JOIN D_TipoIncarico on ##decorrenzaincarichi.CodTipoIncarico = D_TipoIncarico.Codice
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica on ##decorrenzaincarichi.IdIncarico = anagrafica.IdIncarico 

join (SELECT max(IdTransizione) IdTransizione,
								IdIncarico
	  from L_WorkflowIncarico
	  --where IdIncarico = 4424314 
	 group BY IdIncarico 				) inputultimidati on inputultimidati.IdIncarico = ##decorrenzaincarichi.IdIncarico

JOIN L_WorkflowIncarico wf ON inputultimidati.IdTransizione = wf.IdTransizione

JOIN D_StatoWorkflowIncarico WFPartenza ON wf.CodStatoWorkflowIncaricoPartenza = WFPartenza.Codice
LEFT JOIN D_AttributoIncarico attributopartenza ON attributopartenza.Codice = wf.CodAttributoIncaricoPartenza

JOIN D_StatoWorkflowIncarico WFDestinazione on WFDestinazione.Codice = wf.CodStatoWorkflowIncaricoDestinazione
left JOIN D_AttributoIncarico attributodestinazione on attributodestinazione.Codice = wf.CodAttributoIncaricoDestinazione


LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rclientemacro1 ON rclientemacro1.CodTipoIncarico = ##decorrenzaincarichi.CodTipoIncarico
																		AND rclientemacro1.CodStatoWorkflowIncarico = WFPartenza.Codice
																		and rclientemacro1.CodCliente = 23
JOIN D_MacroStatoWorkflowIncarico dmacropartenza on rclientemacro1.CodMacroStatoWorkflowIncarico = dmacropartenza.Codice


left JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow rclientemacro2 ON rclientemacro2.CodTipoIncarico = ##decorrenzaincarichi.CodTipoIncarico
																		AND rclientemacro2.CodStatoWorkflowIncarico = WFDestinazione.Codice
																		and rclientemacro2.CodCliente = 23
JOIN D_MacroStatoWorkflowIncarico dmacrodestinazione on rclientemacro2.CodMacroStatoWorkflowIncarico = dmacrodestinazione.Codice

*/


drop table ##decorrenzaincarichi


END



GO

--ma tutte le simule max vengono popolate con numero_simula_max? non credo...

SELECT DISTINCT NUMERO_SIMULA 

INTO #MAX				 
 FROM scratch.L_ImportSimula_Operativo --where NUMERO_SIMULA = 998024 
 where TIPO_SIMULA = 'MAX' --AND NUMERO_SIMULA_MAX <> 0



 SELECT  T_DatiAggiuntiviIncaricoAzimut.IdIncarico, CodTipoRaccomandazione, * FROM T_R_Incarico_Mandato
 join T_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
 JOIN T_DatiAggiuntiviIncaricoAzimut on T_R_Incarico_Mandato.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico
 where NumeroSimula in (SELECT cast(NUMERO_SIMULA as varchar(9)) FROM #MAX)