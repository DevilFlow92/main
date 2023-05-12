USE CLC
GO

--alter VIEW rs.v_CESAM_AZ_FatturazioneIncarichi_v2 AS

/*
Author: Lorenzo Fiori
Utilizzata nel report: AZ - Fatturazione Incarichi
*/


SELECT

	ti.IdIncarico
	,ti.DataCreazione
	,ti.CodTipoIncarico
	,descrizioni.TipoIncarico
	,ti.CodStatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico
	,ti.CodAttributoIncarico
	,descrizioni.AttributoIncarico
	,CASE WHEN ti.CodTipoIncarico IN (83	--Sottoscrizioni/Versamenti FONDI Investimento
										,84	--Switch FONDI Investimento
										,85	--Rimborso FONDI Investimento
										,94	--Rimborsi SICAV
										,96	--Riscatto Assicurazioni
										,98	--Sottoscrizioni/Versamenti Assicurazioni
										,100	--Sottoscrizioni/Versamenti SICAV
										,101	--Switch Assicurazioni
										,103	--Switch SICAV
										,153	--Rimborsi Programmati
										,159	--Switch [FAX-PEC] anticipati – Fondi Az
										,160	--Switch [ORIG] anticipati via fax/pec – Fondi Az
										,236	--Sottoscrizioni Assicurazioni AzLife
										,237	--Switch Assicurazioni AzLife
										,238	--Riscatto Assicurazioni AzLife
										,321	--Sottoscrizioni AFB
										,322	--Versamenti Aggiuntivi AFB
										,323	--Rimborsi AFB
										,324	--Switch AFB
										,343	--Incremento/Decremento
										)
						THEN 1 --'Trade'

		 WHEN ti.CodTipoIncarico in (53	 --Finanziamenti e Affidamenti
										,197 --Finanziamenti e Affidamenti-BP
										,205 --Variazioni - Finanziamenti e Affidamenti-BP
										)
						then 2 --'Finanziamenti Affidamenti'

		 WHEN ti.CodTipoIncarico  IN (54	--Successioni
									  )
						THEN 3 --'Successioni'

		 WHEN ti.CodTipoIncarico IN (87	--Cambio Collocatore
									 ,288	--Censimento Cliente
									 ,396	--OnBoarding Digitale
									 )
						THEN 4 --'OnBoarding'
		ELSE NULL END AS Categoria

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
AND CodAttributoIncarico = 1507	--Attesa contratto Cartaceo 

) afb
	ON afb.IdIncarico = ti.IdIncarico --escludo gli afb creati senza carta perché si tratta di creazioni da MYDESK e fin quando non arriva la carta
--non è corretto fatturarli in quanto non ancora lavorati

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodStatoWorkflowIncarico != 440

AND afb.IdIncarico IS NULL

--AND ti.DataCreazione >= '2018-11-01'
--AND ti.DataCreazione < '2018-12-01'

GO


--EXEC orga.CESAM_AZ_VariazioneIncarichi