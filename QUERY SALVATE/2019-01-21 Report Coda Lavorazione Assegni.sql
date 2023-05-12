USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_CodaLavorazioneSottoscrizioneFONDI_Assegni AS 

SELECT ti.IdIncarico
		,ti.DataCreazione DataCreazioneIncarico
		,ti.CodStatoWorkflowIncarico
		,descrizioni.StatoWorkflowIncarico

		--,IIF(ti.FlagUrgente = 1,'SI','NO') Urgente
		--,IIF(ti.FlagAttesa = 1,'SI','NO') Attesa

		--,tdoc.Documento_id IdDocumentoAssegno
		--,tdoc.DataAcquisizione DataAcquisizioneAssegno
		--,tdoc.DataInserimento DataInserimentoAssegno

		,tpi.CodProvenienzaDenaro + ' - ' + D_ProvenienzaDenaro.Descrizione ProvenienzaDenaro

		,Sconto.Testo ScontoCommissionale
		
		,IdPersonaEsecutore
		,IIF(Esecutore.Cognome IS NULL or Esecutore.Cognome = '',Esecutore.RagioneSociale,Esecutore.Cognome) + ' ' + ISNULL(Esecutore.Nome,'') Esecutore
		,IdPersonaOrdinante
		,IIF(Ordinante.Cognome is NULL or Ordinante.Cognome = '',Ordinante.RagioneSociale,Ordinante.Cognome) + ' ' + ISNULL(Ordinante.Nome,'') Ordinante

		,DataSottoscrizione DataSottoscrizioneMandato

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico

JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico 
AND Tipo_Documento = 1713 --Copia assegno
AND FlagPresenzaInFileSystem = 1 and FlagScaduto = 0

LEFT JOIN T_PagamentoInvestimento tpi ON ti.IdIncarico = tpi.IdIncarico
LEFT JOIN D_ProvenienzaDenaro ON tpi.CodProvenienzaDenaro = D_ProvenienzaDenaro.Codice

LEFT JOIN T_DatoAggiuntivo Sconto ON ti.IdIncarico = Sconto.IdIncarico 
and CodTipoDatoAggiuntivo IN ( 1371	)--Codice Sconto Documentazione

LEFT JOIN T_DatiAggiuntiviIncaricoAzimut ON ti.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico
LEFT JOIN T_Persona Esecutore ON T_DatiAggiuntiviIncaricoAzimut.IdPersonaEsecutore = Esecutore.IdPersona
LEFT JOIN T_Persona Ordinante ON T_DatiAggiuntiviIncaricoAzimut.IdPersonaOrdinante = Ordinante.IdPersona

LEFT JOIN T_R_Incarico_Mandato ON ti.IdIncarico = T_R_Incarico_Mandato.IdIncarico
LEFT JOIN T_Mandato ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato

WHERE ti.CodArea = 8
and ti.CodCliente = 23
AND ti.CodTipoIncarico = 83 --Sottoscrizioni/Versamenti FONDI Investimento

AND  ti.CodStatoWorkflowIncarico = 6500 --Nuova - Creata

AND  (
		tpi.CodProvenienzaDenaro IS NULL
		OR IdPersonaOrdinante is NULL
		OR IdPersonaEsecutore is NULL
		OR DataSottoscrizione is NULL
     )

	
--AND ti.DataCreazione >= '2019-01-20'

GO

