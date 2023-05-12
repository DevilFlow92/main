USE clc
GO

--ALTER VIEW rs.v_CESAM_AZ_FatturazioneIncarichi_v2 AS

/*
Author: Lorenzo Fiori
Utilizzata nel report: AZ - Fatturazione Incarichi NEW
*/

SELECT

	ti.IdIncarico,
	ti.DataCreazione,
	ti.CodTipoIncarico,
	descrizioni.TipoIncarico,
	ti.CodStatoWorkflowIncarico,
	descrizioni.StatoWorkflowIncarico,
	ti.CodAttributoIncarico,
	descrizioni.AttributoIncarico,
	CASE
		WHEN ti.CodTipoIncarico IN (321		--Sottoscrizioni AFB
			, 322	--Versamenti Aggiuntivi AFB
			, 323	--Rimborsi AFB
			, 324	--Switch AFB
			, 100	--Sottoscrizioni/Versamenti SICAV
			, 94	--Rimborsi SICAV
			, 103	--Switch SICAV
			, 556	--Sottoscrizioni AFB - Zenith
			, 557	--Versamenti Aggiuntivi AFB - Zenith
			, 558	--Rimborsi AFB - Zenith
			, 559	--Switch AFB - Zenith
			, 589	--Sottoscrizioni SICAV - Zenith
			, 590	--Versamenti Aggiuntivi SICAV - Zenith
			, 591	--Rimborsi SICAV - Zenith
			, 592	--Switch SICAV - Zenith

			) THEN 1 --Case Terze

		WHEN ti.CodTipoIncarico IN (83		--Sottoscrizioni/Versamenti FONDI Investimento
			, 84	--Switch FONDI Investimento
			, 85	--Rimborso FONDI Investimento
			, 153	--Rimborsi Programmati
			, 159	--Switch [FAX-PEC] anticipati – Fondi Az
			, 160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
			, 343	--Incremento/Decremento
			, 540	--Sottoscrizioni Lux - Zenith
			, 553	--Versamenti Aggiuntivi Lux - Zenith
			, 554	--Rimborsi Lux - Zenith
			, 555	--Switch Lux - Zenith
			, 569	--Rimborsi Fondi - Zenith
			, 570	--Switch Fondi - Zenith
			, 580	--Sottoscrizioni Fondi - Zenith
			, 581	--Versamenti Aggiuntivi Fondi - Zenith
			, 587	--Incremento/Decremento - Zenith

			) THEN 2 --Fondi Azimut

		WHEN ti.CodTipoIncarico IN (53	 --Finanziamenti e Affidamenti
			, 197 --Finanziamenti e Affidamenti-BP
			, 205 --Variazioni - Finanziamenti e Affidamenti-BP

			) THEN 3 --'Finanziamenti'

		WHEN ti.CodTipoIncarico IN (54	--Successioni
			) THEN 4 --'Successioni'

		WHEN ti.CodTipoIncarico IN (87	--Cambio Collocatore
			, 288	--Censimento Cliente
			, 396	--OnBoarding Digitale
			) THEN 5 --'OnBoarding Clienti'

			

		WHEN ti.CodTipoIncarico in (
		--164,	--Successioni - Polizze AzLife
			--204,	--Disposizioni Varie AZ Life

			236		--Sottoscrizioni Assicurazioni AzLife
			,239	--Versamenti Aggiuntivi Assicurazioni AzLife
			,560	--Sottoscrizioni AzLife - Zenith
			,561	--Versamenti Aggiuntivi AzLife - Zenith
					

			,238	--Riscatto Assicurazioni AzLife
			,562	--Riscatti AzLife - Zenith

			
			,237	--Switch Assicurazioni AzLife
			,548	--Switch Programmati AZ Life		
			,563	--Switch AzLife - Zenith

		) THEN 6 --AZ Life

		

		WHEN ti.CodTipoIncarico in (512		--Ipo Club - Sottoscrizioni
									,532	--Corporate Cash - Sottoscrizioni
									,541	--Demos1 - Sottoscrizioni
									,542	--GlobALInvest - Sottoscrizioni
									,552	--Italia 500 - Sottoscrizioni
									
		) OR (ti.CodTipoIncarico = 565	--Comunicazioni Fondi Chiusi
				AND (ti.CodAttributoIncarico is NULL or ti.CodAttributoIncarico != 17402 ) --Attributo Private Debt 
			)
		THEN 7 --AZ Libera Impresa		

		ELSE NULL
	END AS Categoria,

	CASE
		WHEN ti.CodTipoIncarico IN (83	--Sottoscrizioni/Versamenti FONDI Investimento
		, 321	--Sottoscrizioni AFB
		, 322	--Versamenti Aggiuntivi AFB
		, 100	--Sottoscrizioni/Versamenti SICAV
		, 556	--Sottoscrizioni AFB - Zenith
		, 557	--Versamenti Aggiuntivi AFB - Zenith
		, 589	--Sottoscrizioni SICAV - Zenith
		, 590	--Versamenti Aggiuntivi SICAV - Zenith
		, 540	--Sottoscrizioni Lux - Zenith
		, 553	--Versamenti Aggiuntivi Lux - Zenith
		, 580	--Sottoscrizioni Fondi - Zenith
		, 581	--Versamenti Aggiuntivi Fondi - Zenith
		,236		--Sottoscrizioni Assicurazioni AzLife
			,239	--Versamenti Aggiuntivi Assicurazioni AzLife
			,560	--Sottoscrizioni AzLife - Zenith
			,561	--Versamenti Aggiuntivi AzLife - Zenith
		) THEN 1 --Sottoscrizioni
		WHEN ti.CodTipoIncarico IN (324	--Switch AFB
		, 103	--Switch SICAV
		, 84	--Switch FONDI Investimento
		, 159	--Switch [FAX-PEC] anticipati – Fondi Az
		, 160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
		, 559	--Switch AFB - Zenith
		, 592	--Switch SICAV - Zenith
		, 555	--Switch Lux - Zenith
		, 570	--Switch Fondi - Zenith
			,237	--Switch Assicurazioni AzLife
			,548	--Switch Programmati AZ Life		
			,563	--Switch AzLife - Zenith

		) THEN 2 --Switch
		WHEN ti.CodTipoIncarico IN (323	--Rimborsi AFB
		, 94	--Rimborsi SICAV
		, 558	--Rimborsi AFB - Zenith
		, 591	--Rimborsi SICAV - Zenith
		, 85	--Rimborso FONDI Investimento
		, 153	--Rimborsi Programmati
		, 554	--Rimborsi Lux - Zenith
		, 569	--Rimborsi Fondi - Zenith
		
			,238	--Riscatto Assicurazioni AzLife
			,562	--Riscatti AzLife - Zenith
		) THEN 3 --Rimborsi
		WHEN ti.CodTipoIncarico IN (343	--Incremento/Decremento
		, 587	--Incremento/Decremento - Zenith
		) THEN 4 --Incremento/Decremento
		ELSE NULL
	END AS SottoCategoria

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON ti.IdIncarico = descrizioni.IdIncarico
LEFT JOIN (SELECT
	IdIncarico
FROM T_Incarico
WHERE CodArea = 8
AND CodCliente = 23
AND CodTipoIncarico IN (321	--Sottoscrizioni AFB
, 322	--Versamenti Aggiuntivi AFB
, 323	--Rimborsi AFB
, 324	--Switch AFB
, 351	--Successioni AFB
)
AND CodStatoWorkflowIncarico = 6500 --Nuova - Creata
AND (CodAttributoIncarico = 1507	--Attesa contratto Cartaceo 
OR CodAttributoIncarico IS NULL)) afb
	ON afb.IdIncarico = ti.IdIncarico --escludo gli afb creati senza carta perché si tratta di creazioni da MYDESK e fin quando non arriva la carta --non è corretto fatturarli in quanto non ancora lavorati
LEFT JOIN (SELECT
	dbo.T_Incarico.IdIncarico
FROM dbo.T_Incarico
WHERE dbo.T_Incarico.CodCliente = 23
AND dbo.T_Incarico.CodTipoIncarico IN (540	--Sottoscrizioni Lux - Zenith
, 553	--Versamenti Aggiuntivi Lux - Zenith
, 554	--Rimborsi Lux - Zenith
, 555	--Switch Lux - Zenith
, 556	--Sottoscrizioni AFB - Zenith
, 557	--Versamenti Aggiuntivi AFB - Zenith
, 558	--Rimborsi AFB - Zenith
, 559	--Switch AFB - Zenith
, 569	--Rimborsi Fondi - Zenith
, 570	--Switch Fondi - Zenith
, 580	--Sottoscrizioni Fondi - Zenith
, 581	--Versamenti Aggiuntivi Fondi - Zenith
, 587	--Incremento/Decremento - Zenith
, 589	--Sottoscrizioni SICAV - Zenith
, 590	--Versamenti Aggiuntivi SICAV - Zenith
, 591	--Rimborsi SICAV - Zenith
, 592	--Switch SICAV - Zenith
)
AND dbo.T_Incarico.CodArea = 8
AND dbo.T_Incarico.CodStatoWorkflowIncarico IN (6500, 15502)) Zenith
	ON Zenith.IdIncarico = ti.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodStatoWorkflowIncarico != 440

AND afb.IdIncarico IS NULL 
AND Zenith.IdIncarico IS NULL

--AND ti.DataCreazione >= '2019-09-16'
--AND ti.DataCreazione < '2019-12-05'

GO