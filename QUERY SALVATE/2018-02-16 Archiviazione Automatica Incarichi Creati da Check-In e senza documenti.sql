use CLC 
go

--ALTER procedure [rs].[CESAM_AZ_ArchiviazioneIncarichiCheckIn] as

DECLARE @Lastmonth datetime

		,@Lastweek datetime

set @Lastmonth = dateadd(MONTH, -1, GETDATE())
SET @Lastweek = DATEADD(WEEK, -1, getdate())

if object_id(N'tempdb.#incarichiarchiviare',N'U') is not null
begin
DROP TABLE #incarichiarchiviare
END

CREATE table #incarichiarchiviare (IdIncarico int
									,DataCreazione datetime
									,CodTipoIncarico int
									,CodStatoWorkflowIncarico int
									,CodAttributoIncarico int
																	)

INSERT INTO #incarichiarchiviare (IdIncarico
									,DataCreazione
									,CodTipoIncarico
									,CodStatoWorkflowIncarico
									,CodAttributoIncarico
																	)
SELECT T_Incarico.IdIncarico
		,DataCreazione
		,CodTipoIncarico
		,CodStatoWorkflowIncarico
		,CodAttributoIncarico
FROM T_Incarico
	left JOIN T_Documento on T_Documento.IdIncarico = T_Incarico.IdIncarico
	
	LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica on T_Incarico.IdIncarico = anagrafica.IdIncarico
	
	left JOIN T_R_Incarico_Mandato on T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
	LEFT JOIN T_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
	LEFT JOIN T_Dossier on T_Dossier.IdDossier = T_Mandato.IdDossier
	
	LEFT JOIN T_R_Dossier_Persona on anagrafica.idpersona = T_R_Dossier_Persona.IdPersona

	left JOIN (SELECT L_WorkflowIncarico.IdIncarico, L_WorkflowIncarico.IdOperatore, Etichetta, CodProfiloAccesso
				FROM L_WorkflowIncarico
				join S_Operatore on L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore
				WHERE CodStatoWorkflowIncaricoPartenza is NULL 
				AND CodStatoWorkflowIncaricoDestinazione = 6500 --nuova - creata
				and CodProfiloAccesso in(935,936,2067) --acquisizione
				) creazionecheckin ON T_Incarico.IdIncarico = creazionecheckin.IdIncarico
WHERE 
CodCliente = 23 
and CodArea = 8
and CodTipoIncarico IN (321,322,323,324,351) 
--and CodStatoWorkflowIncarico = 6500

--dossier non popolato
and T_Mandato.IdMandato is NULL
and T_Dossier.IdDossier IS NULL
--tab persone e promotore non popolati
AND anagrafica.idpersona IS NULL
and anagrafica.idpromotore IS NULL
--non ci sono documenti
AND Documento_id IS NULL 
--and CodAttributoIncarico is NULL 

--AND DataCreazione >= @Lastmonth
--and DataCreazione < @Lastweek

--AND T_Incarico.IdIncarico = 9124818

SELECT *
--#incarichiarchiviare.*, Descrizione Attributo
 FROM #incarichiarchiviare 
--join D_AttributoIncarico on Codice = CodAttributoIncarico

/*

UPDATE T_Incarico
set CodArea = 2
FROM T_Incarico inner JOIN #incarichiarchiviare on #incarichiarchiviare.IdIncarico = T_Incarico.IdIncarico

INSERT INTO [dbo].[L_WorkflowIncarico] ([IdIncarico]
										, [IdOperatore]
										, [DataTransizione]
										, [CodTipoWorkflow]
										, [CodStatoWorkflowIncaricoPartenza]
										, [FlagUrgentePartenza]
										, [CodStatoWorkflowIncaricoDestinazione]
										, [FlagUrgenteDestinazione]
										, [FlagManuale]
										, [CodAttributoIncaricoPartenza]
										, [CodAttributoIncaricoDestinazione]
										, [FlagAttesaPartenza]
										, [FlagAttesaDestinazione]
										, [CodAreaPartenza]
										, [CodAreaDestinazione])

select #incarichiarchiviare.IdIncarico						[IdIncarico]
	   ,21													[IdOperatore] --sistema
	   ,getdate()											[DataTransizione]
	   ,ultimidati.CodTipoWorkflow							[CodTipoWorkflow]
	   ,ultimidati.CodStatoWorkflowIncaricoDestinazione		[CodStatoWorkflowIncaricoPartenza]
	   ,ultimidati.FlagUrgenteDestinazione					[FlagUrgentePartenza]
	   ,ultimidati.CodStatoWorkflowIncaricoDestinazione		[CodStatoWorkflowIncaricoDestinazione]
	   ,ultimidati.FlagUrgenteDestinazione					[FlagUrgenteDestinazione]
	   ,0													[FlagManuale] 
	   ,ultimidati.CodAttributoIncaricoDestinazione			[CodAttributoIncaricoPartenza]
	   ,ultimidati.CodAttributoIncaricoDestinazione			[CodAttributoIncaricoDestinazione]
	   ,ultimidati.FlagAttesaDestinazione					[FlagAttesaPartenza]
	   ,ultimidati.FlagAttesaDestinazione					[FlagAttesaDestinazione]
	   ,ultimidati.CodAreaDestinazione						[CodAreaPartenza]
	   ,2													[CodAreaDestinazione] --area test interno
								
from  #incarichiarchiviare 

join (SELECT max(IdTransizione) IdTransizione,
								IdIncarico
	  from L_WorkflowIncarico
	  --where IdIncarico = 4424314 
	 group BY IdIncarico 				) inputultimidati on inputultimidati.IdIncarico = #incarichiarchiviare.IdIncarico

JOIN L_WorkflowIncarico ultimidati ON inputultimidati.IdTransizione = ultimidati.IdTransizione


--report incarichi archiviati

SELECT #incarichiarchiviare.IdIncarico
		,#incarichiarchiviare.DataCreazione
		,#incarichiarchiviare.CodTipoIncarico
		,descrizioni.TipoIncarico
		,creazione.IdOperatore
		,creazione.Etichetta OperatoreCreazione
		,DataTransizione DataArchiviazione
		,descrizioni.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico
				 

FROM  #incarichiarchiviare 

LEFT JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni on descrizioni.IdIncarico = #incarichiarchiviare.IdIncarico

JOIN (SELECT IdIncarico, L_WorkflowIncarico.IdOperatore, Etichetta FROM L_WorkflowIncarico
		join S_Operatore on L_WorkflowIncarico.IdOperatore = S_Operatore.IdOperatore
		where --CodAreaPartenza = 8
		 CodStatoWorkflowIncaricoPartenza IS NULL AND CodStatoWorkflowIncaricoDestinazione = 6500
		--AND IdIncarico =4424323  
		) creazione on creazione.IdIncarico = #incarichiarchiviare.IdIncarico
JOIN (SELECT max(IdTransizione) IdTransizione
								,IdIncarico
		from L_WorkflowIncarico 
		group BY IdIncarico					) inputarchiviazione ON inputarchiviazione.IdIncarico = #incarichiarchiviare.IdIncarico
JOIN L_WorkflowIncarico on inputarchiviazione.IdTransizione = L_WorkflowIncarico.IdTransizione

*/
DROP TABLE #incarichiarchiviare

GO


/*

use clc

--storico archiviazioni/rollback da automatismo 
SELECT T_incarico.IdIncarico
		,T_Incarico.CodTipoIncarico
		,descrizioni.TipoIncarico
		,CASE WHEN CodAreaPartenza = 2 THEN 'Rollback' ELSE 'Archiviazione' END as TipoAutomatismo
		,DataTransizione as DataAutomatismo
		,T_Incarico.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico
		,T_Incarico.CodAttributoIncarico
		,descrizioni.AttributoIncarico
		,CodArea as CodAreaAttuale
		,D_Area.Descrizione	as AreaAttuale

 FROM T_Incarico
 join L_WorkflowIncarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
 JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON descrizioni.IdIncarico = T_Incarico.IdIncarico
 JOIN D_Area on T_Incarico.CodArea = D_Area.Codice

where 
CodCliente = 23 AND 
IdOperatore = 21
AND ((CodAreaPartenza = 8 AND CodAreaDestinazione = 2) OR (CodAreaPartenza = 2 and CodAreaDestinazione = 8))
 
 GO

 */

