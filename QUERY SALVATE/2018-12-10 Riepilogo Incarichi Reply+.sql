USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_RiepilogoIncarichiReply AS 

/*
Tipi Incarico Target
OnBoarding
(
288		--Censimento Cliente
,396	--OnBoarding Digitale
)

Operatività 1
(
83		--Sottoscrizioni/Versamenti FONDI Investimento
,85		--Rimborso FONDI Investimento
,84		--Switch FONDI Investimento
,159	--Switch [FAX-PEC] anticipati – Fondi Az
,160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
,321	--Sottoscrizioni AFB
,322	--Versamenti Aggiuntivi AFB 
,323	--Rimborsi AFB
,324	--Switch AFB
,98		--Sottoscrizioni/Versamenti Assicurazioni
,96		--Riscatto Assicurazioni
,101	--Switch Assicurazioni
,236	--Sottoscrizioni Assicurazioni AzLife
,237	--Switch Assicurazioni AzLife
,238	--Riscatto Assicurazioni AzLife
,239	--Versamenti Aggiuntivi Assicurazioni AzLife
)

Altre Operatività gestite da CESAM
(
54		--Successioni
,197	--Finanziamenti e Affidamenti-BP
,205	--Variazioni - Finanziamenti e Affidamenti-BP
,399	--Estinzioni Fin-Aff Bpm
,86	--Gestione Conto Corrente
,87	--Cambio Collocatore
,80	--Raccolta Ordini
,97	--Sottoscrizioni/versamenti gestioni
,147	--Rimborsi Gestioni
,153	--Rimborsi Programmati
,473	--Attivazione Servizi di Investimento
)
*/



SELECT ti.IdIncarico
		,ti.DataCreazione DataCreazioneIncarico
		,ti.DataUltimaModifica
		,ti.CodTipoIncarico
		,descrizioni.TipoIncarico DescrizioneIncarico
		,anagrafica.CodicePromotore
		--,anagrafica.RagioneSocialePromotore
		,anagrafica.CognomePromotore
		,anagrafica.NomePromotore
		,anagrafica.ChiaveClienteIntestatario
		,anagrafica.RagioneSocialeIntestatario
		,anagrafica.CognomeIntestatario
		,anagrafica.NomeIntestatario
		,descrizioni.StatoWorkflowIncarico
		,sospesi.IdSospeso
			,sospesi.ProgressivoSospeso
			,sospesi.CodTipoOperazione
			,sospesi.CodTipoProdotto
			,sospesi.TipoOperazione
			,sospesi.TipoProdotto TipoProdottoSospeso
			,sospesi.CodStatoSospesoAttuale
			,sospesi.StatoSospesoAttuale
			,sospesi.CodTipoDoppioSospeso
			,sospesi.TipoDoppioSospeso
			,sospesi.DataAperturaSospeso
			,sospesi.Progressivomotivazione
			,sospesi.Motivazione
			,sospesi.SottoMotivazione
			,sospesi.Modalita
			,sospesi.NotaMotivazione

			,CASE when ti.CodTipoIncarico IN (288		--Censimento Cliente
											  ,396	--OnBoarding Digitale
													) 
					THEN 'OnBoarding'
			  WHEN ti.CodTipoIncarico IN (83		--Sottoscrizioni/Versamenti FONDI Investimento
										  ,85		--Rimborso FONDI Investimento
										  ,84		--Switch FONDI Investimento
										  ,159	--Switch [FAX-PEC] anticipati – Fondi Az
										  ,160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
										  ,321	--Sottoscrizioni AFB
										  ,322	--Versamenti Aggiuntivi AFB 
										  ,323	--Rimborsi AFB
										  ,324	--Switch AFB
										  ,98		--Sottoscrizioni/Versamenti Assicurazioni
										  ,96		--Riscatto Assicurazioni
										  ,101	--Switch Assicurazioni
										  ,236	--Sottoscrizioni Assicurazioni AzLife
										  ,237	--Switch Assicurazioni AzLife
										  ,238	--Riscatto Assicurazioni AzLife
										  ,239	--Versamenti Aggiuntivi Assicurazioni AzLife
										  )
						THEN 'Operatività Fondi Investimento e Assicurazioni'
			ELSE 'Altre Operatività CESAM'

			END AS TipoOperatività
		
			,CASE WHEN ti.CodTipoIncarico IN (83		--Sottoscrizioni/Versamenti FONDI Investimento
										  ,85		--Rimborso FONDI Investimento
										  ,84		--Switch FONDI Investimento
										  ,159	--Switch [FAX-PEC] anticipati – Fondi Az
										  ,160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
										  ) THEN 'Fondi AZ'
					WHEN ti.CodTipoIncarico IN (321	--Sottoscrizioni AFB
										  ,322	--Versamenti Aggiuntivi AFB 
										  ,323	--Rimborsi AFB
										  ,324	--Switch AFB
										  ) THEN 'Fondi Case Terze'

					WHEN ti.CodTipoIncarico IN (236	--Sottoscrizioni Assicurazioni AzLife
										  ,237	--Switch Assicurazioni AzLife
										  ,238	--Riscatto Assicurazioni AzLife
										  ,239	--Versamenti Aggiuntivi Assicurazioni AzLife
										  ) THEN 'Assicurazioni AZ'

					WHEN ti.CodTipoIncarico IN (98		--Sottoscrizioni/Versamenti Assicurazioni
										  ,96		--Riscatto Assicurazioni
										  ,101	--Switch Assicurazioni
										  ) THEN 'Assicurazioni Case Terze'
							WHEN ti.CodTipoIncarico IN (288		--Censimento Cliente
											  ,396	--OnBoarding Digitale
											  )
							THEN IIF(anagrafica.CodTipoPersona = 2,'OnBoarding Persone Giuridiche','OnBoarding Persone Fisiche')
				ELSE 'Altre Attività CESAM Rilevanti'
				END AS TipoProdotto

FROM T_Incarico ti

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico  descrizioni  ON ti.IdIncarico = descrizioni.IdIncarico

LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica  ON ti.IdIncarico = anagrafica.IdIncarico
AND anagrafica.ProgressivoPersona = 1

LEFT JOIN rs.v_CESAM_AZ_SOSP_DoppiSospesiProgressivo sospesi  ON ti.IdIncarico = sospesi.IdIncarico

WHERE ti.CodCliente = 23
AND ti.CodArea = 8

AND ti.CodTipoIncarico IN (
288		--Censimento Cliente
,396	--OnBoarding Digitale
,83		--Sottoscrizioni/Versamenti FONDI Investimento
,85		--Rimborso FONDI Investimento
,84		--Switch FONDI Investimento
,159	--Switch [FAX-PEC] anticipati – Fondi Az
,160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
,321	--Sottoscrizioni AFB
,322	--Versamenti Aggiuntivi AFB 
,323	--Rimborsi AFB
,324	--Switch AFB
,98		--Sottoscrizioni/Versamenti Assicurazioni
,96		--Riscatto Assicurazioni
,101	--Switch Assicurazioni
,236	--Sottoscrizioni Assicurazioni AzLife
,237	--Switch Assicurazioni AzLife
,238	--Riscatto Assicurazioni AzLife
,239	--Versamenti Aggiuntivi Assicurazioni AzLife
,54		--Successioni
,197	--Finanziamenti e Affidamenti-BP
,205	--Variazioni - Finanziamenti e Affidamenti-BP
,399	--Estinzioni Fin-Aff Bpm
,86		--Gestione Conto Corrente
,87		--Cambio Collocatore
,80		--Raccolta Ordini
,97		--Sottoscrizioni/versamenti gestioni
,147	--Rimborsi Gestioni
,153	--Rimborsi Programmati
,473	--Attivazione Servizi di Investimento
)

--AND ti.DataCreazione >= '2018-10-01' AND ti.DataCreazione < '2018-12-01'

GO