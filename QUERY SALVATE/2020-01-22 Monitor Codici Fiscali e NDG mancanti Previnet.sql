USE CLC
GO

SELECT DISTINCT
	v.idincarico
	,v.codtipoincarico
	,dti.Descrizione TipoIncarico
	,v.idpersona
	,T_Persona.ChiaveCliente
	,RagioneSociale
	,Cognome
	,Nome
	--,onbo.IdIncarico IncaricoCensimento
	,v.CodiceFiscale

FROM rs.v_CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI v
JOIN D_TipoIncarico dti
	ON dti.Codice = codtipoincarico
--LEFT JOIN (
--	SELECT trip.IdPersona, ti.IdIncarico
--	 FROM  T_R_Incarico_Persona trip
--	  JOIN T_Incarico ti ON trip.IdIncarico = ti.IdIncarico
--	 AND ti.CodCliente = 23
--	 AND ti.CodArea = 8
--	 AND ti.CodTipoIncarico in (288,396,44)
--) onbo ON onbo.IdPersona = v.idpersona

LEFT JOIN T_Persona ON v.idpersona = T_Persona.IdPersona

WHERE stato = 2 or v.CodiceFiscale LIKE '%NDNDNDND%'
--se da risultati vai su fend o guarda i documenti di identità sull'incarico di censimento per copiare il codice fiscale


SELECT * FROM rs.v_CESAM_AZ_AnagraficaClienti_Aggiornamento
--se da risultati fai girare lo script dell'import anagrafica 


--SELECT  ti.IdIncarico, ti.DataCreazione, ti.DataUltimaTransizione,ti.DataUltimaModifica, d.CodTipoIncarico, d.TipoIncarico, ti.CodStatoWorkflowIncarico,d.StatoWorkflowIncarico FROM T_Incarico ti
--JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
--WHERE ti.CodArea = 8
--AND ti.CodCliente = 23
--AND ti.CodTipoIncarico  IN (173	--Disinvestimenti Previdenza
--,572	--Sottoscrizioni Previdenza - Zenith
--,175	--Successioni - Previdenza
--,178	--Varie Previdenza
--,57	--Gestione SEPA
--,167	--Sottoscrizioni Previdenza
--,102	--Switch Previdenza
--)
--AND ti.CodStatoWorkflowIncarico <> 440
--AND d.CodMacroStatoWFIncarico NOT IN (14,13)
--AND YEAR(ti.DataCreazione) >= 2019


