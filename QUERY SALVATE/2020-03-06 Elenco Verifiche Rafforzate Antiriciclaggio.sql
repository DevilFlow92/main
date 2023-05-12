USE CLC
GO


ALTER VIEW rs.v_CESAM_AZ_Antiriciclaggio_ElencoVerificheRafforzate_Completo AS 

SELECT
	TI.IdIncarico
	,TI.DataCreazione
	,TI.DataUltimaModifica
	,TI.DataUltimaTransizione

	,IIF(TI.FlagUrgente = 1, 'Sì', 'No') Urgente
	,IIF(TI.FlagAttesa = 1, 'Sì', 'No') Attesa

	,TI.CodStatoWorkflowIncarico
	,d.DescrizioneMacroStatoWorkFlowIncarico
	,d.DescrizioneStatoWorkflowIncarico
	,d.StatoWorkflowIncarico

	,VAN.ChiaveClienteIntestatario
	,CASE
		WHEN VAN.CognomeIntestatario IS NULL OR
			VAN.CognomeIntestatario = '' THEN VAN.RagioneSocialeIntestatario
		ELSE VAN.CognomeIntestatario + ' ' + ISNULL(VAN.NomeIntestatario, '')
	END
	+ CHAR(10)+ ISNULL(VAN.CodiceFiscaleIntestatario, '') Anagrafica

	,T_Antiriciclaggio.CodMotivoVerifica
	,D_MotivoVerifica.Descrizione MotivoVerifica

	,(SELECT
		CASE
			WHEN traia.CodIndicatoreAntiriciclaggio IS NOT NULL THEN traia.CodIndicatoreAntiriciclaggio + CHAR(10)
			ELSE ''
		END
	FROM T_Incarico tix
	LEFT JOIN T_Antiriciclaggio ta
		ON tix.IdIncarico = ta.IdIncarico
	LEFT JOIN T_R_Antiriciclaggio_IndicatoreAntiriciclaggio traia
		ON ta.IdAntiriciclaggio = traia.IdAntiriciclaggio

	WHERE tix.CodArea = 8
	AND tix.CodCliente = 23
	AND tix.CodTipoIncarico = 522
	AND tix.IdIncarico = TI.IdIncarico

	GROUP BY CASE
		WHEN traia.CodIndicatoreAntiriciclaggio IS NOT NULL THEN traia.CodIndicatoreAntiriciclaggio + CHAR(10)
		ELSE ''
	END
	ORDER BY (CASE
		WHEN traia.CodIndicatoreAntiriciclaggio IS NOT NULL THEN traia.CodIndicatoreAntiriciclaggio + CHAR(10)
		ELSE ''
	END) DESC
	FOR XML PATH (''))
	CodIndicatoreAntiriciclaggio

	,CodSanatoriaFiscale
	,D_SanatoriaFiscale.Descrizione SanatoriaFiscale

	,CASE FlagScudoFiscale
		WHEN 1 THEN 'Sì'
		WHEN 0 THEN 'No'
	END ScudoFiscale
	,NumeroScudoFiscale

	,T_Antiriciclaggio.CodEnteSegnalante
	,D_EnteSegnalante.Descrizione EnteSegnalante
	,T_Antiriciclaggio.CodAltroEnteSegnalante
	,D_AltroEnteSegnalante.Descrizione AltroEnteSegnalante


	,CASE FlagPrecedentiSos
		WHEN 1 THEN 'Sì'
		WHEN 0 THEN 'No'
	END PrecedentiSOS
	,CASE FlagPropostaSos
		WHEN 1 THEN 'Sì'
		WHEN 0 THEN 'No'
	END PropostaSOS
	,CASE FlagProcedereConSos
		WHEN 1 THEN 'Sì'
		WHEN 0 THEN 'No'
	END ProcedereConSOS

	,VAN.CodicePromotore
	,VAN.ChiaveClientePromotore
	,CASE
		WHEN VAN.CognomePromotore IS NULL OR
			VAN.CognomePromotore = '' THEN VAN.RagioneSocialePromotore
		ELSE VAN.CognomePromotore + ' ' + ISNULL(VAN.NomePromotore, '')
	END

	AS Promotore

	,VAN.DescrizioneSim
	,VAN.DescrizioneAreaCentroRaccolta
	,VAN.DescrizioneCentroRaccolta

	,OperatoreGestore.Etichetta GestoreIncarico

	,NotaConclusivaCompilatore
	,NotaDisposizioniOperative
	,NotaMotivoAstensione
	,NotaOperativitaSospetta
	,NotaMotiviSospetto

FROM T_Incarico TI
JOIN T_Antiriciclaggio
	ON TI.IdIncarico = T_Antiriciclaggio.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore VAN
	ON TI.IdIncarico = VAN.IdIncarico
	AND VAN.ProgressivoPersona = 1

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d
	ON TI.IdIncarico = d.IdIncarico

LEFT JOIN (SELECT
	T_DatoAggiuntivo.*
FROM T_DatoAggiuntivo
JOIN T_Incarico tix
	ON T_DatoAggiuntivo.IdIncarico = tix.IdIncarico
WHERE tix.CodArea = 8
AND tix.CodCliente = 23
AND tix.CodTipoIncarico = 522
AND T_DatoAggiuntivo.CodTipoDatoAggiuntivo = 1625
AND T_DatoAggiuntivo.Testo = 'Ex Antiriciclaggio Storico') tda
	ON TI.IdIncarico = tda.IdIncarico

LEFT JOIN D_MotivoVerifica
	ON CodMotivoVerifica = D_MotivoVerifica.Codice
LEFT JOIN D_EnteSegnalante
	ON CodEnteSegnalante = D_EnteSegnalante.Codice
LEFT JOIN D_AltroEnteSegnalante
	ON CodAltroEnteSegnalante = D_AltroEnteSegnalante.Codice
LEFT JOIN D_SanatoriaFiscale
	ON CodSanatoriaFiscale = D_SanatoriaFiscale.Codice

LEFT JOIN T_R_Incarico_Operatore triop
	ON TI.IdIncarico = triop.IdIncarico
	AND triop.CodRuoloOperatoreIncarico = 1
LEFT JOIN S_Operatore OperatoreGestore
	ON triop.IdOperatore = OperatoreGestore.IdOperatore

LEFT JOIN T_DatiAggiuntiviPersona
	ON VAN.idpersona = T_DatiAggiuntiviPersona.IdPersona

WHERE TI.CodArea = 8
AND TI.CodCliente = 23
AND TI.CodTipoIncarico = 522
AND tda.IdDatoAggiuntivo IS NULL
GO

--AND YEAR(TI.DataCreazione) IN (@Anno)
