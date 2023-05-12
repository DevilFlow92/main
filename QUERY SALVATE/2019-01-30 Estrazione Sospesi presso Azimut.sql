USE CLC
GO

--alter VIEW rs.v_CESAM_AZ_Sospesi_IncarichiPressoAzimut AS

SELECT ti.IdIncarico 
		,ti.DataCreazione
		,ti.DataUltimaModifica
		,ti.DataUltimaTransizione
		,ti.CodTipoIncarico
		,descrizioni.TipoIncarico
		,ti.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico
		,anagrafica.ChiaveClienteIntestatario
		,IIF(anagrafica.CognomeIntestatario IS null OR anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomeIntestatario) 
			+ ' ' + ISNULL(anagrafica.NomeIntestatario,'') Intestatario

		,anagrafica.CodicePromotore CodiceConsulente
		,IIF(anagrafica.CognomePromotore IS NULL OR anagrafica.CognomePromotore = '', anagrafica.RagioneSocialePromotore, anagrafica.CognomePromotore) 
			+ ' ' + ISNULL(anagrafica.NomePromotore, '') Consulente

		,sospesi.IdSospeso
		,sospesi.ProgressivoSospeso
		,sospesi.CodTipoOperazione
		,sospesi.CodTipoProdotto
		,sospesi.TipoOperazione
		,sospesi.TipoProdotto
		,sospesi.CodStatoSospesoAttuale
		,sospesi.StatoSospesoAttuale
		,sospesi.CodTipoDoppioSospeso
		,sospesi.TipoDoppioSospeso
		,sospesi.Progressivomotivazione
		,sospesi.Motivazione
		,sospesi.SottoMotivazione
		,sospesi.Modalita
		,sospesi.NotaMotivazione
	
FROM T_Incarico ti 
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON ti.IdIncarico = anagrafica.IdIncarico
AND anagrafica.ProgressivoPersona = 1

JOIN rs.v_CESAM_AZ_SOSP_DoppiSospesiProgressivo--_noFilter
sospesi ON ti.IdIncarico = sospesi.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodStatoWorkflowIncarico IN (6555	--In attesa approvazione deroga
									,6597	--In Assistenza AZIMUT
									,14325	--In Ufficio Legale
									)


GO


--SELECT 	IdIncarico
--		,DataCreazione
--		,DataUltimaModifica
--		,DataUltimaTransizione
--		,CodTipoIncarico
--		,TipoIncarico
--		,CodStatoWorkflowIncarico
--		,StatoWorkflowIncarico
--		,ChiaveClienteIntestatario
--		,Intestatario
--		,CodiceConsulente
--		,Consulente
--		,IdSospeso
--		,ProgressivoSospeso
--		,CodTipoOperazione
--		,CodTipoProdotto
--		,TipoOperazione
--		,TipoProdotto
--		,CodStatoSospesoAttuale
--		,StatoSospesoAttuale
--		,CodTipoDoppioSospeso
--		,TipoDoppioSospeso
--		,Progressivomotivazione
--		,Motivazione
--		,SottoMotivazione
--		,Modalita
--		,NotaMotivazione 

--FROM rs.v_CESAM_AZ_Sospesi_IncarichiPressoAzimut