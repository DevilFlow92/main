/*
Author: Andrea Padricelli
Date: 20171128
Description: La vista estrae tutti gli incarichi con almeno un sospeso aperto
       che non hanno mai subito una transizione in sospesa da verificare

*/
ALTER VIEW rs.v_CESAM_AZ_Sospesi_NoTransizioneSospesa AS 
/*
**** INCARICHI
93     MIFID - Schede Finanziarie
159    Switch [FAX] anticipati via fax – Fondi Azimut
55     Anagrafiche Antiriciclaggio
253    Bonifica Anagrafica - ADV in scadenza
44     Variazione Anagrafica

**** WORKFLOW
--8500 Da Verificare

*/


SELECT T_Incarico.IdIncarico
,CodTipoIncarico
,CodStatoWorkflowIncarico
,CodStato StatoSospeso
,DataCreazione
,DataUltimaTransizione 
,D_StatoWorkflowIncarico.Descrizione StatoWFAttuale
,D_TipoIncarico.Descrizione DTipoIncarico
,D_StatoSospeso.Descrizione DStatoSospeso
FROM T_Incarico 
JOIN T_Sospeso ON T_Incarico.IdIncarico = T_Sospeso.IdIncarico
LEFT JOIN D_StatoWorkflowIncarico ON D_StatoWorkflowIncarico.Codice = CodStatoWorkflowIncarico
LEFT JOIN D_TipoIncarico ON D_TipoIncarico.Codice = CodTipoIncarico
LEFT JOIN D_StatoSospeso ON CodStato = D_StatoSospeso.Codice
LEFT JOIN (
       SELECT T_Incarico.IdIncarico,CodStatoWorkflowIncaricoDestinazione FROM L_WorkflowIncarico 
       JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico AND CodTipoIncarico IN (93       
                                                                                    ,159      
                                                                                    ,55 
                                                                                    ,253      
                                                                                    ,44 ) 
                                                                                    AND CodArea = 8 AND CodCliente = 23
                                                                                   
       WHERE CodStatoWorkflowIncaricoDestinazione = 8500 --da verificare
       GROUP BY T_Incarico.IdIncarico,CodStatoWorkflowIncaricoDestinazione
) WFSospesa ON WFSospesa.IdIncarico = T_Incarico.IdIncarico

where CodTipoIncarico IN (93      
                                        ,159   
                                        ,55    
                                        ,253   
                                        ,44    )
AND CodArea = 8
AND CodCliente = 23
AND WFSospesa.IdIncarico IS NULL

GO

