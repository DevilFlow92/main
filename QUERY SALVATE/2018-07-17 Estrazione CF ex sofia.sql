USE clc

SELECT T_Incarico.IdIncarico
		,DataCreazione
		,D_TipoIncarico.Descrizione TipoIncarico
		,cliente.ChiaveCliente CodiceCliente
		,ISNULL(cliente.Cognome,cliente.RagioneSociale) + SPACE(1) + ISNULL(cliente.Nome,'') Cliente
		,T_Promotore.Codice CodicePromotore
		,ISNULL(CF.Cognome,CF.RagioneSociale) + SPACE(1) + ISNULL(CF.Nome,'') AnagraficaPromotore
		--,T_CentroRaccolta.Codice CodiceCentroRaccolta
		,T_CentroRaccolta.Descrizione CentroRaccolta
		,T_AreaCentroRaccolta.Codice CodiceAreaCentroRaccolta
		,T_AreaCentroRaccolta.Descrizione AreaCentroRaccolta
		,T_Sim.Codice CodiceSim
		,T_Sim.Descrizione SIM

		              
FROM T_Incarico
JOIN T_R_Incarico_Promotore ON T_Incarico.IdIncarico = T_R_Incarico_Promotore.IdIncarico
JOIN T_Promotore ON T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore

JOIN T_CentroRaccolta ON T_Promotore.IdCentroRaccolta = T_CentroRaccolta.IdCentroRaccolta
JOIN T_AreaCentroRaccolta ON T_CentroRaccolta.IdAreaCentroRaccolta = T_AreaCentroRaccolta.IdAreaCentroRaccolta
JOIN T_Sim ON T_AreaCentroRaccolta.IdSim = T_Sim.IdSim

JOIN T_Persona CF ON T_Promotore.IdPersona = CF.IdPersona
JOIN D_TipoIncarico ON T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice

JOIN T_R_Incarico_Persona ON T_Incarico.IdIncarico = T_R_Incarico_Persona.IdIncarico
JOIN T_Persona cliente ON T_R_Incarico_Persona.IdPersona = cliente.IdPersona

WHERE CodArea = 8

AND T_Incarico.CodCliente = 23

AND T_Incarico.CodTipoIncarico = 288

AND T_Sim.Codice = '80573' --AREA 7 SOFIA

AND T_Incarico.DataCreazione >= '20180601'

ORDER BY T_Incarico.DataCreazione

