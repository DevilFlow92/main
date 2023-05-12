USE CLC
GO

SELECT DISTINCT 
		anagrafica.IdPromotore
		,anagrafica.CodicePromotore
		,ISNULL(anagrafica.CognomePromotore,anagrafica.RagioneSocialePromotore) + SPACE(1) + ISNULL(anagrafica.NomePromotore,'') Promotore
		
FROM T_Incarico

JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica with (nolock) ON T_Incarico.IdIncarico = anagrafica.IdIncarico

LEFT JOIN T_CentroRaccolta WITH (NOLOCK) ON anagrafica.idcentroraccolta = T_CentroRaccolta.IdCentroRaccolta

--LEFT JOIN  (SELECT 	IdCentroRaccolta
--					,T_CentroRaccolta.IdAreaCentroRaccolta
--					,T_CentroRaccolta.Codice CodCentroRaccolta
--					,T_CentroRaccolta.Descrizione CentroRaccolta
--					,T_AreaCentroRaccolta.IdSim
--					,T_AreaCentroRaccolta.Codice CodAreaCentroRaccolta
--					,T_AreaCentroRaccolta.Descrizione AreaCentroRaccolta
--					,T_Sim.Codice CodiceSim
--					,T_Sim.Descrizione Sim
--					FROM T_CentroRaccolta
--					JOIN T_AreaCentroRaccolta on T_CentroRaccolta.IdAreaCentroRaccolta = T_AreaCentroRaccolta.IdAreaCentroRaccolta
--					JOIN T_Sim on T_AreaCentroRaccolta.IdSim = T_Sim.IdSim
			
--			)  cdr  ON cdr.IdCentroRaccolta = anagrafica.idcentroraccolta
			
WHERE --T_Incarico.CodArea = 8

T_Incarico.CodCliente = 23

AND T_CentroRaccolta.IdCentroRaccolta IS NULL

--AND (cdr.IdCentroRaccolta IS NULL
--		OR cdr.IdAreaCentroRaccolta IS NULL
--		OR cdr.IdSim IS NULL
--		--OR cdr.CentroRaccolta = ''
--		--OR cdr.AreaCentroRaccolta = ''
--		--OR cdr.Sim = ''
--	)

AND anagrafica.idpromotore is NOT NULL

--AND T_Incarico.IdIncarico = 10537732

--AND anagrafica.CodicePromotore IS NULL

-- GROUP BY 
--anagrafica.IdPromotore
--,anagrafica.CodicePromotore
--,ISNULL(anagrafica.CognomePromotore,anagrafica.RagioneSocialePromotore) + SPACE(1) + ISNULL(anagrafica.NomePromotore,'') 


--SELECT * FROM T_R_Incarico_Promotore where IdPromotore = 4689