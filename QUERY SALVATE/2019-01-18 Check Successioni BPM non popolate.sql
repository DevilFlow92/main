USE CLC
GO


--5 righe
--INSERT into T_R_Incarico_Persona (IdIncarico, IdPersona, Progressivo, CodRuoloRichiedente, DataInizioRapporto)
SELECT bpm.IdIncarico, anagrafica.idpersona, 1, 4, NULL 
FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico
JOIN T_R_Incarico_SubIncarico trsub ON ti.IdIncarico = trsub.IdIncarico
JOIN rs.v_CESAM_AZ_Successioni_LavorazioniBancoPopolare bpm ON trsub.IdSubIncarico = bpm.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON ti.IdIncarico = anagrafica.IdIncarico
	AND anagrafica.codruolorichiedente = 4 --De cuius
LEFT JOIN T_R_Incarico_Persona trpersonaBPM ON bpm.IdIncarico = trpersonaBPM.IdIncarico AND trpersonaBPM.CodRuoloRichiedente = 4 --De cuius

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND bpm.StatoWorkflowIncarico = 'creata'
AND trpersonaBPM.IdPersona is NULL 

