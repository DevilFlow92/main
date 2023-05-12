USE CLC
GO

--CREATE VIEW rs.CESAM_AZ_OnBoardingDigital_EstrazioneIncarichi AS

SELECT 	DISTINCT T_Incarico.IdIncarico
		,T_Incarico.CodTipoIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		--,T_Incarico.CodStatoWorkflowIncarico
		,D_MacroStatoWorkflowIncarico.Descrizione + ' - ' + D_StatoWorkflowIncarico.Descrizione StatoWorkFlowIncaricoQTask
		,DataCreazione
		,DataUltimaModifica
		,DataUltimaTransizione

	/* PERSONA */
		--,	T_Persona.IdPersona
			,T_Persona.ChiaveCliente
			,T_Persona.Cognome
			,T_Persona.Nome
			,T_Persona.CodiceFiscale
			--,T_Persona.CodSesso
			,T_Persona.DataNascita

			/* D_Comune - D_Provincia - D_Stato - D_Nazionalita */
			,T_Persona.CodComuneNascita
			,D_Comune.Descrizione ComuneNascita
			,T_Persona.ComuneNascitaEstero
			,T_Persona.CodProvinciaNascita
			,D_Provincia.Descrizione ProvinciaNascita
			,T_Persona.CodStatoNascita
			,D_Stato.Descrizione StatoNascita
			--,T_Persona.CodNazionalita
			--,T_Persona.DataInizioResidenzaItaliana
			--,T_Persona.DataDecesso
		
			--,T_Persona.RagioneSociale
			,T_Persona.CodiceFiscaleEstero
			
			/* D_Cittadinanza */
			,T_Persona.CodCittadinanza
			,D_Cittadinanza.Descrizione PrimaCittadinanza
			,T_Persona.CodAltraCittadinanza
			,altracittadinanza.Descrizione SecondaCittadinanza

			,T_Persona.FlagPresenteDocumentazioneFatca
			,T_Persona.FlagPresenteDocumentazioneCrs
			,T_Persona.FlagCancellato

		/* INDIRIZZO */
			--,T_Indirizzo.IdIndirizzo
			,T_Indirizzo.CodTipoIndirizzo
			,D_TipoIndirizzo.Descrizione TipoIndirizzo
			,T_Indirizzo.PrimaRiga
			,T_Indirizzo.SecondaRiga
			,T_Indirizzo.Cap
			,T_Indirizzo.Localita
			,T_Indirizzo.SiglaProvincia
			,T_Indirizzo.CodStato
			,StatoIndirizzo.Descrizione StatoIndirizzo
			,T_Indirizzo.CognomeReferente
			,T_Indirizzo.NomeReferente

	/* CONTATTI */
		,Email
		,Cellulare

	/* DOCUMENTO IDENTITA */
		,CodTipoDocumentoIdentita
		,D_TipoDocumentoIdentita.Descrizione TipoDocumentoIdentita
		,Numero NumeroDocumentoIdentita
		,DataEmissione DataRilascio
		,T_DocumentoIdentita.CodStatoEnteEmissioneDocumenti CodNazioneRilascio
		,StatoEmissioneCI.Descrizione NazioneRilascio
		,T_DocumentoIdentita.CodProvinciaEnteEmissioneDocumenti
		,T_DocumentoIdentita.CodEnteEmissioneDocumenti
		,D_EnteEmissioneDocumenti.Descrizione EnteRilascio
		,T_DocumentoIdentita.LocalitaEnteEmissioneDocumenti
		,T_DocumentoIdentita.CodComuneEnteEmissioneDocumenti
		,T_DocumentoIdentita.ComuneEnteEmissioneDocumentiEstero
		,T_DocumentoIdentita.DataScadenza

	/*D_TitoloStudio */
		,CodTitoloStudio
		,D_TitoloStudio.Descrizione TitoloStudio

	/*D_ContrattoConsulenza*/
		,CodContrattoConsulenza
		,D_ContrattoConsulenza.Descrizione ContrattoConsulenza

	/* ANTIRICICLAGGIO */
		,CodNaturaRapporto
		,D_NaturaRapporto.Descrizione DNaturaRapporto
		,DescrizioneNaturaRapporto
		,CodProfessione
		,D_Professione.Descrizione DProfessione
		,FlagPensionato
		,CodAteco
		,CodSettoreOccupazione
		,D_SettoreOccupazione.Descrizione DSettoreOccupazione
		,CodAltroSettoreOccupazione
		,D_AltroSettoreOccupazione.Descrizione DAltroSettoreOccupazione
		,CodStatoAttivita
		,StatoAttivita.Descrizione StatoAttivita
		,CodProvinciaAttivita
		,ProvinciaAttivita.Descrizione ProvinciaAttivita
		,DataInizioAttivita
		,FonteReddito

	/* RESIDENZA FISCALE */
		,T_ResidenzaFiscale.IdResidenzaFiscale
		,T_ResidenzaFiscale.CodStatoResidenzaFiscale
		,StatoResidenzaFiscale.Descrizione StatoResidenzaFiscale 
		,T_ResidenzaFiscale.CodiceFiscale CodiceFiscaleResidenza
				
	/* DATI AGGIUNTIVI PERSONA AZIMUT */
		--,CodVincoloPersona
		--,FlagExArt25
		--,CodSae
		--,CodSottoGruppoAttEcon
		--,CodResidenzaFiscale
		--,CodCalcolo
		--,CodAssegnamento
		--,CodDiGruppo
		--,CodRelazioneClienteTitolareEffettivo
		--,AbiRubrica
		--,CodPropensioneRischioConsAzInv
		--,CodPropensioneRischioConsApogeo
		--,CodPropensioneRischioCons
		--,DataAdeguataVerifica
		--,DataScadenzaAdeguataVerifica
		--,IndiceAnomalia
		
		,FlagAttivitaExtraUE
		,DescrizioneAttivitaExtraUE
		,FlagTitolareEffettivo

	 --PEP
		,CaricaRicoperta
		,DataInizioCarica
		,FlagPepNazionale
		,FlagPepEstero
		,FlagRapportoPepEsteroNazionale
		--,FlagInAmbitoSocietarioAssociazioniFondazioniExtraUE
		--,FlagInAmbitoPoliticoIstituzionale
		,FlagNonProfitOnlus
		,FlagPubblicaAmministrazione
		,FlagFondiPubblici

	
	/* DATI INVESTIMENTO DIGITALE */
	 --Mandato
		,T_Mandato.IdMandato
		,T_Mandato.NumeroMandato
		,T_Mandato.CodTipoServizioInvestimento
		,D_TipoServizioInvestimento.Descrizione ServizioInvestimento
		--,T_Mandato.CodCommissioneInvestimento
		--,T_Mandato.PercentualeCommissioneInvestimento
		,T_Mandato.CodCommissioneInvestimento1
		,Commissione1.Descrizione CommissioneInvestimento1
		,T_Mandato.PercentualeCommissioneInvestimento1
		,T_Mandato.CodCommissioneInvestimento2
		,Commissione2.Descrizione CommissioneInvestimento2
		,T_Mandato.PercentualeCommissioneInvestimento

	 --PagamentoInvestimento
		,IdPagamento
		,T_PagamentoInvestimento.DataOperazione
		,T_PagamentoInvestimento.DataValuta
		,T_PagamentoInvestimento.Importo
		,T_PagamentoInvestimento.CodValuta
		,T_PagamentoInvestimento.Banca
		,T_PagamentoInvestimento.CodModalitaPagamento
		,T_PagamentoInvestimento.CodiceOperazione
		,T_PagamentoInvestimento.AbiAssegno
		,T_PagamentoInvestimento.CabAssegno
		,T_PagamentoInvestimento.NumeroAssegno
		,T_PagamentoInvestimento.NumeroContoCorrenteAssegno
		,T_PagamentoInvestimento.IbanPartenza
		,T_PagamentoInvestimento.CinDestinazione
		,T_PagamentoInvestimento.NumeroContoCorrenteDestinazione
		,T_PagamentoInvestimento.IbanDestinazione
		,T_PagamentoInvestimento.CodTipoAssegno
		,T_PagamentoInvestimento.CodTipoPagamento
		,T_PagamentoInvestimento.FlagEffettuato
		,T_PagamentoInvestimento.FlagAttivo
		,T_PagamentoInvestimento.Abi
		,T_PagamentoInvestimento.Cab
		,T_PagamentoInvestimento.IdMovimentoContoBancario
		,T_PagamentoInvestimento.IdMandato
		,T_PagamentoInvestimento.CodProvenienzaDenaro
		
		

		/* ADEGUATA VERIFICA */
		--,AnniAnzianitaConoscenza
		--,FlagClasseBeneficiari
		--,FlagProvenienzaFondi
		--,NumeroComponenti
		--,CodModalitaConoscenza
		--,ContFamiliare
		--,CodTenoreVita
		--,FlagCambioSoci
		--,FlagConoscenzaSoci
		--,CodComportamentoTenuto
		--,AndamentoEconomico
		--,CodRagioneRapportoAttivita
		--,FlagSospettoRicFin
		--,FlagPresenzaSoggettiTerzi
		--,FlagAttendibilitaInformazioni
		--,CodRischioPromotoreFinanziario
		--,CodRiduzione
		--,FlagPepNazionaleVerificato
		--,FlagPepEsteroVerificato
		--,FlagPepCollegatiVerificato
		--,FlagSmarritoRubato
		--,FlagScaduto
		--,FlagCollegamentiPersoneNonFisiche
		--,EventualiVincoli 
		
FROM T_Incarico
JOIN D_TipoIncarico ON T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice

/* WORKFLOW */
left JOIN D_StatoWorkflowIncarico ON T_Incarico.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice
left JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow ON D_StatoWorkflowIncarico.Codice = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico
																					AND R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente = 23
																					AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
left JOIN D_MacroStatoWorkflowIncarico ON R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodMacroStatoWorkflowIncarico = D_MacroStatoWorkflowIncarico.Codice

/* PERSONA */
LEFT JOIN (SELECT T_Incarico.IdIncarico
					,ISNULL(T_R_Incarico_Persona.IdPersona,T_R_Dossier_Persona.IdPersona) IdPersona
					,ISNULL(T_R_Incarico_Promotore.IdPromotore,T_R_Incarico_Promotore.IdPromotore) IdPromotore
					
			FROM T_Incarico
				LEFT JOIN T_R_Incarico_Mandato ON T_Incarico.IdIncarico = T_R_Incarico_Mandato.IdIncarico
				LEFT JOIN T_Mandato ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
				LEFT JOIN T_Dossier ON T_Mandato.IdDossier = T_Dossier.IdDossier
				LEFT JOIN T_R_Dossier_Persona ON T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier

				LEFT JOIN T_R_Incarico_Persona ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico
				LEFT JOIN T_R_Incarico_Promotore ON T_Incarico.IdIncarico = T_R_Incarico_Promotore.IdIncarico
			) anagrafica ON anagrafica.IdIncarico = T_Incarico.IdIncarico

left JOIN T_Persona ON anagrafica.IdPersona = T_Persona.IdPersona

/* INDIRIZZO */
LEFT JOIN T_R_Persona_Indirizzo ON T_Persona.IdPersona = T_R_Persona_Indirizzo.IdPersona
LEFT JOIN T_Indirizzo ON T_R_Persona_Indirizzo.IdIndirizzo = T_Indirizzo.IdIndirizzo
LEFT JOIN D_TipoIndirizzo ON T_Indirizzo.CodTipoIndirizzo = D_TipoIndirizzo.Codice
LEFT JOIN D_Stato StatoIndirizzo ON T_Indirizzo.CodStato = StatoIndirizzo.Codice

/* CONTATTI */
LEFT JOIN T_Contatto ON T_Persona.IdPersona = T_Contatto.IdPersona

/* DOC IDENTITA' */
LEFT JOIN T_DocumentoIdentita ON T_Persona.IdPersona = T_DocumentoIdentita.IdPersona
LEFT JOIN D_TipoDocumentoIdentita ON T_DocumentoIdentita.CodTipoDocumentoIdentita = D_TipoDocumentoIdentita.Codice
LEFT JOIN D_Stato StatoEmissioneCI ON StatoEmissioneCI.Codice = T_DocumentoIdentita.CodStatoEnteEmissioneDocumenti
LEFT JOIN D_EnteEmissioneDocumenti ON T_DocumentoIdentita.CodEnteEmissioneDocumenti = D_EnteEmissioneDocumenti.Codice


/* DATI AGGIUNTIVI ONBOARDING DIGITALE */
left JOIN T_DatiAggiuntiviPersona ON T_Persona.IdPersona = T_DatiAggiuntiviPersona.IdPersona
LEFT JOIN T_ResidenzaFiscale ON T_Persona.IdPersona = T_ResidenzaFiscale.IdPersona

/* TABELLE DESCRITTIVE */
left JOIN D_TitoloStudio on CodTitoloStudio = D_TitoloStudio.Codice

left JOIN D_ContrattoConsulenza on CodContrattoConsulenza = D_ContrattoConsulenza.Codice

LEFT JOIN D_Cittadinanza ON T_Persona.CodCittadinanza = D_Cittadinanza.Codice
LEFT JOIN D_Cittadinanza altracittadinanza ON T_Persona.CodAltraCittadinanza = altracittadinanza.Codice

--LEFT JOIN D_TipoPersona ON T_Persona.CodTipoPersona = D_TipoPersona.Codice
--LEFT JOIN D_NaturaGiuridica ON T_Persona.CodNaturaGiuridica = D_NaturaGiuridica.Codice

LEFT JOIN D_Comune ON T_Persona.CodComuneNascita = D_Comune.Codice
LEFT JOIN D_Provincia ON D_Comune.CodProvincia = D_Provincia.Codice
LEFT JOIN D_Stato on T_Persona.CodStatoNascita = D_Stato.Codice
LEFT JOIN D_Stato StatoResidenzaFiscale ON T_ResidenzaFiscale.CodStatoResidenzaFiscale = StatoResidenzaFiscale.Codice

LEFT JOIN D_NaturaRapporto ON T_DatiAggiuntiviPersona.CodNaturaRapporto = D_NaturaRapporto.Codice
LEFT JOIN D_Professione ON T_DatiAggiuntiviPersona.CodProfessione = D_Professione.Codice
LEFT JOIN D_SettoreOccupazione ON T_DatiAggiuntiviPersona.CodSettoreOccupazione = D_SettoreOccupazione.Codice
LEFT JOIN D_AltroSettoreOccupazione ON T_DatiAggiuntiviPersona.CodAltroSettoreOccupazione = D_AltroSettoreOccupazione.Codice 

LEFT JOIN D_Stato StatoAttivita ON StatoAttivita.Codice = T_DatiAggiuntiviPersona.CodStatoAttivita
LEFT JOIN D_Provincia ProvinciaAttivita ON ProvinciaAttivita.Codice = T_DatiAggiuntiviPersona.CodProvinciaAttivita


/* DATI SERVIZI INVESTIMENTO DIGITALE */
LEFT JOIN T_PagamentoInvestimento ON T_Incarico.IdIncarico = T_PagamentoInvestimento.IdIncarico
LEFT JOIN T_Mandato ON T_PagamentoInvestimento.IdMandato = T_Mandato.IdMandato
LEFT JOIN T_Dossier ON T_Mandato.IdDossier = T_Dossier.IdDossier
LEFT JOIN D_TipoServizioInvestimento ON T_Mandato.CodTipoServizioInvestimento = D_TipoServizioInvestimento.Codice
LEFT JOIN D_CommissioneInvestimento Commissione1 ON T_Mandato.CodCommissioneInvestimento1 = Commissione1.Codice
LEFT JOIN D_CommissioneInvestimento Commissione2 ON T_Mandato.CodCommissioneInvestimento2 = Commissione2.Codice

WHERE CodArea = 8
AND T_Incarico.CodCliente = 23

AND T_Incarico.CodStatoWorkflowIncarico <> 440

AND T_Incarico.CodTipoIncarico = 397

--AND T_Incarico.IdIncarico = 5161134

--and T_Incarico.IdIncarico IN (5162053
--								,5162059
--								,5162063
--								,5162065
--								,5162066
--								,5162111
--								,5162091
--								,5162085
--								,5162086
--								,5162092
--								,5162096
--								)

--AND T_Incarico.IdIncarico IN (5162091,5162066)


--ORDER BY T_Incarico.IdIncarico

GO
