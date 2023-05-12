/*
TRACCIARE I COMPORTAMENTI DELLE TRANSIZIONI DI STATO WF PER UN DATO TIPO INCARICO
DESCRIZIONE LIKE '%........%'

l'unica cosa da modificare è quindi la stringa!
*/

select tab_r.IdRelazione
,tab_r.CodCliente
,tab_r.CodTipoIncarico
,D_TipoIncarico.Descrizione [TipoIncarico]
,tab_r.CodStatoWorkflowIncaricoPartenza
,partenza.Descrizione [StatoWFPartenza]
,tab_r.CodStatoWorkflowIncaricoDestinazione
,destinazione.Descrizione [StatoWFDestinazione]
,tab_r.CodAzioneSalvataggioIncarico
,D_AzioneSalvataggioIncarico.Descrizione [AzioneSalvataggio]
 
 from R_Cliente_TipoIncarico_AzioneSalvataggioIncarico tab_r
	left join D_StatoWorkflowIncarico partenza on tab_r.CodStatoWorkflowIncaricoPartenza = partenza.Codice
	left join D_StatoWorkflowIncarico destinazione on tab_r.CodStatoWorkflowIncaricoDestinazione = destinazione.Codice
	left join D_AzioneSalvataggioIncarico on tab_r.CodAzioneSalvataggioIncarico = D_AzioneSalvataggioIncarico.Codice
	left join D_TipoIncarico on tab_r.CodTipoIncarico = D_TipoIncarico.Codice
 
  where D_TipoIncarico.Descrizione like '%rimborsi afb%'
