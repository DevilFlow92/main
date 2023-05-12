--CREATE view [rs].[v_CESAM_CB_IncarichiRispediti] as 

SELECT
	ti.IdIncarico
   ,ti.CodTipoIncarico
   ,D_TipoIncarico.Descrizione TipoIncarico
   --,descrizioni.CodMacroStatoWFIncarico
   --,ti.CodStatoWorkflowIncarico [CodStatoWF]
   --,descrizioni.StatoWorkflowIncarico
   --,ti.CodAttributoIncarico
   --,ISNULL(descrizioni.AttributoIncarico,'') [AttributoIncarico]
   ,ti.DataCreazione

   ,convert(date,isnull(wf.datatransizione, ti.DataUltimaTransizione)) DataRestituzioneDocumenti

   ,anagrafica.ChiaveClienteIntestatario NDGPrimoIntestatario
   ,case when anagrafica.CognomeIntestatario = ' ' OR anagrafica.CognomeIntestatario = ''
				OR anagrafica.CognomeIntestatario IS NULL
				OR anagrafica.NomeIntestatario = ' ' OR anagrafica.NomeIntestatario = ''
				OR anagrafica.NomeIntestatario is NULL 
		THEN anagrafica.RagioneSocialeIntestatario 
		ELSE anagrafica.CognomeIntestatario + space(1) + anagrafica.NomeIntestatario END as  NominativoPrimoIntestatario

   ,anagrafica.CodicePromotore CodiceConsulenteFinanziario
   ,case when anagrafica.CognomePromotore = ' ' OR anagrafica.CognomePromotore = ''
				OR anagrafica.CognomePromotore IS NULL
				OR anagrafica.NomePromotore = ' ' OR anagrafica.NomePromotore = ''
				OR anagrafica.NomePromotore is NULL 
		THEN anagrafica.RagioneSocialePromotore
		ELSE anagrafica.CognomePromotore+ space(1) + anagrafica.NomePromotore END as  NominativoConsulenteFinanziario
   
   ,case WHEN wf.IdIncarico is NULL THEN 1 ELSE 0 END as Archiviato

FROM T_Incarico ti

JOIN D_TipoIncarico on ti.CodTipoIncarico = D_TipoIncarico.Codice

JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica on anagrafica.IdIncarico = ti.IdIncarico AND anagrafica.ProgressivoPersona = 1

left JOIN  (select T_Incarico.IdIncarico, max(IdTransizione) IdTransizione, max(DataTransizione) DataTransizione
			from L_WorkflowIncarico
			join T_Incarico on L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
			where T_Incarico.CodArea = 8
			and CodCliente = 48
			and CodAttributoIncaricoPartenza = 1556	--Documenti da Restituire a CheBanca! 
			AND CodAttributoIncaricoDestinazione IS NULL
			group BY T_Incarico.IdIncarico)	wf ON wf.IdIncarico = ti.IdIncarico


WHERE ti.CodArea = 8
AND ti.CodCliente = 48 --CheBanca
and (ti.CodStatoWorkflowIncarico = 14372 --Gestita CB! - Cartaceo Inviato
		or wf.IdIncarico is NOT NULL )

and ti.DataCreazione >= '2017-12-01'

--and ti.IdIncarico = 9598727 

GO
