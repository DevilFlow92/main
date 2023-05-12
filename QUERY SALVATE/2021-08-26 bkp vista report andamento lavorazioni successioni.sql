USE clc

GO


ALTER VIEW rs.v_CESAM_AZ_SuccessioniAndamentoDelleLavorazioni AS


/*
	Author: G.L. Rusu
	Date: 02/06/2016
	Description: utilizzata nel Report AZ - Successioni Andamento Delle Lavorazioni

*/

--DECLARE @idincarico INT 

--SET @idincarico = 6582230


with IncarichiLavorati as (


SELECT DISTINCT
		case WHEN IncaricoAlle20.IdIncarico IS NOT NULL and IncaricoAlle8.IdIncarico is NULL THEN  '2'--IncaricoAlle20
		WHEN IncaricoAlle8.IdIncarico IS NOT NULL AND IncaricoAlle20.IdIncarico is NULL THEN  '1'--IncaricoAlle8
		when  IncaricoAlle20.IdIncarico IS NOT NULL and IncaricoAlle8.IdIncarico IS NOT NULL THEN  '3'--IncaricoAlle8 & IncaricoAlle20
		ELSE ''--IncarichiTransitatiInGiornata
		END AS Progressivo,
	T_Incarico.IdIncarico,
	DataCreazione,
	T_Incarico.DataUltimaTransizione,
	DestStato.MacroStatoWorkflowIncarico,
	DestStato.StatoWorkflowIncarico,
	IncaricoAlle8.IdIncarico as IncaricoAlle8,
	IncaricoAlle20.IdIncarico as IncaricoAlle20,
	NULL as IncaricoGestito,
	ultimaintegrazione.transizione UltimaIntegrazione --#AP 20180426
	
from T_Incarico

/* Incarichi che si trovano nello stato  Nuova - Da lavorare alle 08.00 in giorno odierno*/
left join (
			SELECT *
			FROM [rs].[f_T_Incarico_AllaData]  (DATETIMEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()),08,00,00,000))
			where CodStatoWorkflowIncarico = 6550 -- -- Nuova - Da lavorare

) as IncaricoAlle8 on T_Incarico.IdIncarico = IncaricoAlle8.IdIncarico

/*Incarichi che si trovano nello stato  Nuova - Da lavorare alle 20.00 in giorno odierno*/

left join (
		SELECT * 
		FROM [rs].[f_T_Incarico_AllaData]  (DATETIMEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()),20,00,00,000))
		where CodStatoWorkflowIncarico = 6550 -- Nuova - Da lavorare


) as IncaricoAlle20 on T_Incarico.IdIncarico = IncaricoAlle20.IdIncarico


LEFT JOIN rs.v_StatoWorkflowIncarico AS DestStato ON DestStato.CodStatoWorkflowIncarico =T_Incarico.CodStatoWorkflowIncarico
				AND T_Incarico.CodTipoIncarico = DestStato.CodTipoIncarico
				and DestStato.CodCliente = 23


LEFT JOIN (SELECT T_Incarico.IdIncarico, MAX(DataTransizione) transizione FROM L_WorkflowIncarico
	JOIN T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico AND CodArea = 8 AND CodCliente = 23 AND CodTipoIncarico = 54
	WHERE CodAttributoIncaricoDestinazione = 239
	GROUP by T_Incarico.IdIncarico
	) ultimaintegrazione ON ultimaintegrazione.IdIncarico = T_Incarico.IdIncarico --#AP 20180426
				
where T_Incarico.CodCliente = 23
and T_Incarico.CodTipoIncarico = 54--Successioni
and T_Incarico.CodArea = 8 
--AND T_Incarico.IdIncarico = @idincarico
--AND IncaricoAlle20.IdIncarico is not NULL

-----LE WF

UNION ALL

SELECT DISTINCT 
 4  AS Progressivo,
	T_Incarico.IdIncarico,
	DataCreazione,
	T_Incarico.DataUltimaTransizione,
	DestStato.MacroStatoWorkflowIncarico,
	DestStato.StatoWorkflowIncarico,
	NULL as IncaricoAlle8,
	NULL as IncaricoAlle20,
	IncarichiTransitatiInGiornata.IdIncarico as IncaricoGestito
	,ultimaintegrazione.transizione UltimaIntegrazione --#AP 20180426
	
from T_Incarico

/* Incarichi transitati in giornata*/

left join (

	SELECT  IdTransizione as IdUltimaTransizione, 
			T_Incarico.IdIncarico,
			DataUltimaTransizione,
			CodStatoWorkflowIncaricoPartenza,
			CodStatoWorkflowIncaricoDestinazione,
			ChiaveData
	from T_Incarico
left join L_WorkflowIncarico on T_Incarico.IdIncarico = L_WorkflowIncarico.IdIncarico
and L_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione--excludo le messe in attesa
left join S_Data on convert (char(8), L_WorkflowIncarico.DataTransizione,112) = S_Data.ChiaveData
left JOIN S_Ora ON CONVERT(CHAR(5),L_WorkflowIncarico.DataTransizione,108) = S_Ora.ChiaveOra
	where L_WorkflowIncarico.CodStatoWorkflowIncaricoPartenza =  6550 --  -- Nuova - Da lavorare
	group BY T_Incarico.IdIncarico,DataUltimaTransizione, CodStatoWorkflowIncaricoPartenza,IdTransizione,
	CodStatoWorkflowIncaricoDestinazione,ChiaveData

			) as IncarichiTransitatiInGiornata on T_Incarico.IdIncarico = IncarichiTransitatiInGiornata.IdIncarico

LEFT JOIN rs.v_StatoWorkflowIncarico AS DestStato ON DestStato.CodStatoWorkflowIncarico =T_Incarico.CodStatoWorkflowIncarico
				AND T_Incarico.CodTipoIncarico = DestStato.CodTipoIncarico
				and DestStato.CodCliente = 23
LEFT JOIN (SELECT T_Incarico.IdIncarico, MAX(DataTransizione) transizione FROM L_WorkflowIncarico
	JOIN T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico AND CodArea = 8 AND CodCliente = 23 AND CodTipoIncarico = 54
	WHERE CodAttributoIncaricoDestinazione = 239
	GROUP by T_Incarico.IdIncarico
	) ultimaintegrazione ON ultimaintegrazione.IdIncarico = T_Incarico.IdIncarico --#AP 20180426
					
where T_Incarico.CodCliente = 23
and T_Incarico.CodTipoIncarico = 54--Successioni
and T_Incarico.CodArea = 8 
and IncarichiTransitatiInGiornata.ChiaveData >= convert(char(8),GETDATE() ,112) 
--AND T_Incarico.IdIncarico = @idincarico
), Attributo as

(

SELECT DISTINCT 
	case when IntegrazioneAlle20.IdIncarico is not NULL and IntegrazioneAlle8.IdIncarico  is NULL THEN 6 
	WHEN IntegrazioneAlle8.IdIncarico is not NULL AND IntegrazioneAlle20.IdIncarico  is null then 5
	WHEN IntegrazioneAlle20.IdIncarico is not NULL and IntegrazioneAlle8.IdIncarico is not NULL then 7 --8 &9
	else ''
	end as Progressivo,
T_Incarico.IdIncarico,
DataCreazione,
T_Incarico.DataUltimaTransizione,
DestStato.MacroStatoWorkflowIncarico AS MacroStatoWorkflowIncarico,
DestStato.StatoWorkflowIncarico AS StatoWorkflowIncarico,
IntegrazioneAlle8.IdIncarico AS IntegrazioneAlle8,
IntegrazioneAlle20.IdIncarico AS IntegrazioneAlle20,
NULL as EliminaAttributo
,ultimaintegrazione.transizione UltimaIntegrazione

from T_Incarico

/* Incarichi che hanno l'attributo aperto  alle 08.00 in giorno odierno*/

left JOIN (
			SELECT * 
			from [rs].[f_T_Incarico_AllaData] (DATETIMEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()),08,00,00,000))
			where CodCliente = 23
			and CodTipoIncarico = 54
			and CodAttributoIncarico = 239---INTEGRAZIONI RICEVUTE
			and CodStatoWorkflowIncarico <> 6550 --  -- Nuova - Da lavorare
) as IntegrazioneAlle8 on T_Incarico.IdIncarico = IntegrazioneAlle8.IdIncarico

/* Incarichi che hanno l'attributo aperto  alle 20.00 in giorno odierno*/
left JOIN (
			SELECT * 
			from [rs].[f_T_Incarico_AllaData] (DATETIMEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),DAY(GETDATE()),20,00,00,000))
			where CodCliente = 23
			and CodTipoIncarico = 54
			and CodAttributoIncarico = 239---INTEGRAZIONI RICEVUTE
			and CodStatoWorkflowIncarico <> 6550 --  -- Nuova - Da lavorare
) as IntegrazioneAlle20 on T_Incarico.IdIncarico = IntegrazioneAlle20.IdIncarico


LEFT JOIN rs.v_StatoWorkflowIncarico AS DestStato ON DestStato.CodStatoWorkflowIncarico = T_Incarico.CodStatoWorkflowIncarico
				AND T_Incarico.CodTipoIncarico = DestStato.CodTipoIncarico
				and DestStato.CodCliente = 23
LEFT JOIN (SELECT T_Incarico.IdIncarico, MAX(DataTransizione) transizione FROM L_WorkflowIncarico
	JOIN T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico AND CodArea = 8 AND CodCliente = 23 AND CodTipoIncarico = 54
	WHERE CodAttributoIncaricoDestinazione = 239
	GROUP by T_Incarico.IdIncarico
	) ultimaintegrazione ON ultimaintegrazione.IdIncarico = T_Incarico.IdIncarico --#AP 20180426
where T_Incarico.CodCliente = 23
AND T_Incarico.CodArea = 8
and T_Incarico.CodTipoIncarico = 54--Successioni
--AND T_Incarico.IdIncarico = @idincarico
--AND IntegrazioneAlle8.IdIncarico IS NOT NULL


UNION ALL



SELECT DISTINCT 
8 as  Progressivo,
T_Incarico.IdIncarico,
DataCreazione,
T_Incarico.DataUltimaTransizione,
DestStato.MacroStatoWorkflowIncarico AS MacroStatoWorkflowIncarico,
DestStato.StatoWorkflowIncarico AS StatoWorkflowIncarico,
null AS IntegrazioneAlle8,
NULL AS IntegrazioneAlle20,
EliminaAttributo.IdIncarico
,ultimaintegrazione.transizione UltimaIntegrazione --#AP 20180426
from T_Incarico

/* Incarichi dove è stato eliminato l'attributo*/
left join (

		SELECT L_WorkflowIncarico.*,S_Data.ChiaveData
		from L_WorkflowIncarico
		left join S_Data on convert (char(8), L_WorkflowIncarico.DataTransizione,112) = S_Data.ChiaveData
		where CodAttributoIncaricoPartenza =  239 -- INTEGRAZIONI RICEVUTE
		and CodAttributoIncaricoDestinazione is NULL
		and CodStatoWorkflowIncaricoDestinazione <> 6550 --  -- Nuova - Da lavorare
) as  EliminaAttributo on T_Incarico.IdIncarico = EliminaAttributo.IdIncarico

LEFT JOIN rs.v_StatoWorkflowIncarico AS DestStato ON DestStato.CodStatoWorkflowIncarico = T_Incarico.CodStatoWorkflowIncarico
				AND T_Incarico.CodTipoIncarico = DestStato.CodTipoIncarico
				and DestStato.CodCliente = 23
LEFT JOIN (SELECT T_Incarico.IdIncarico, MAX(DataTransizione) transizione FROM L_WorkflowIncarico
	JOIN T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico AND CodArea = 8 AND CodCliente = 23 AND CodTipoIncarico = 54
	WHERE CodAttributoIncaricoDestinazione = 239
	GROUP by T_Incarico.IdIncarico
	) ultimaintegrazione ON ultimaintegrazione.IdIncarico = T_Incarico.IdIncarico --#AP 20180426
where T_Incarico.CodCliente = 23
AND T_Incarico.CodArea = 8
and T_Incarico.CodTipoIncarico = 54--Successioni
and EliminaAttributo.ChiaveData >= convert(char(8),GETDATE() ,112) 

--AND T_Incarico.IdIncarico = @idincarico

)

select IncarichiLavorati.*
from IncarichiLavorati

union all

SELECT Attributo.*
from Attributo

GO