USE CLC
GO

SELECT DISTINCT  T_Incarico.IdIncarico
		,T_Incarico.CodTipoIncarico CodTipoIncaricoAttuale
		,storico_i.CodTipoIncarico CodTipoIncaricoPrecedente
		
FROM storico.V_Log_T_Incarico storico_i

JOIN T_AttivitaPianificataIncarico variazioni on storico_i.IdIncarico = variazioni.IdIncarico 
													and variazioni.CodTipoAttivitaPianificata = 552	--Variazione tipo Incarico
													AND variazioni.CodStatoAttivita in (1,2) --aperta/chiusa
JOIN T_Incarico on storico_i.IdIncarico = T_Incarico.IdIncarico

WHERE 
CodArea = 8
AND storico_i.CodTipoIncarico IN (83	--Sottoscrizioni/Versamenti FONDI Investimento
								  ,84	--Switch FONDI Investimento
								  ,85	--Rimborso FONDI Investimento
								  )

AND T_Incarico.CodTipoIncarico in (321   --Sottoscrizioni AFB
									,322 --Versamenti Aggiuntivi AFB
									,323 --Rimborsi AFB
									,324 --Switch AFB
									,94	 --Rimborsi SICAV
									,100 --Sottoscrizioni/Versamenti SICAV
									,103 --Switch SICAV
									)

AND T_Incarico.DataCreazione >= '2018-06-01'
--AND T_Incarico.IdIncarico = 10559725 

