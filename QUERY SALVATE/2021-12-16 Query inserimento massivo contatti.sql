USE clc
GO

/*
--query per inserimento contatti
SELECT T_Promotore.IdPersona, 'monica.morandi@azimut.it' Email, 'Manuale - Richiesto da Roberto Bolgiani (azimut)' Descrizione, 1 FlagAttivo, 6 CodRuoloContatto
,T_Promotore.Codice
,T_Promotore.RagioneSocialePromotore
,T_CentroRaccolta.Descrizione DescrizioneCentroRaccolta
, T_AreaCentroRaccolta.Descrizione DescrizioneArea
,T_Sim.Descrizione DescrizioneSim


FROM T_Promotore
JOIN T_CentroRaccolta ON T_Promotore.IdCentroRaccolta = T_CentroRaccolta.IdCentroRaccolta
JOIN T_AreaCentroRaccolta ON T_CentroRaccolta.IdAreaCentroRaccolta = T_AreaCentroRaccolta.IdAreaCentroRaccolta
JOIN T_Sim ON T_AreaCentroRaccolta.IdSim = T_Sim.IdSim
CROSS APPLY (
				SELECT TOP 1 * 
                FROM T_Contatto x
				WHERE x.FlagAttivo = 1
				AND x.CodRuoloContatto = 6	--Contatto Rimborsi Diretti
				AND x.email = 'roberto.bolgiani@azimut.it'
				AND x.IdPersona = T_Promotore.IdPersona

) rimborsidiretti

OUTER APPLY (
			SELECT TOP 1 xx.IdContatto
            FROM T_Contatto xx
			WHERE xx.FlagAttivo = 1
			AND xx.CodRuoloContatto = 6 --Rimborsi Diretti
			AND xx.Descrizione = 'Manuale - Richiesto da Roberto Bolgiani (azimut)'
			AND xx.IdPersona = T_Promotore.IdPersona
) contattoinserito

WHERE T_AreaCentroRaccolta.IdSim = 27
--AND (RagioneSocialePromotore LIKE '%clienti da riassegnare%'
--OR T_Promotore.Codice IN( '9032','3489')
--)
AND contattoinserito.IdContatto IS NULL
*/


--Query per file da condividere con angela
SELECT T_Promotore.Codice [Codice CF]
,RagioneSocialePromotore CF
,Email
,D_RuoloContatto.Descrizione [Tipo Contatto]
--,T_Contatto.Descrizione [note]
,T_CentroRaccolta.Descrizione CDR
,T_AreaCentroRaccolta.Descrizione Area
,T_Sim.Descrizione MacroArea
FROM T_Contatto
JOIN T_Promotore ON T_Contatto.IdPersona = T_Promotore.IdPersona
JOIN D_RuoloContatto ON T_Contatto.CodRuoloContatto = D_RuoloContatto.Codice
JOIN T_CentroRaccolta ON T_Promotore.IdCentroRaccolta = T_CentroRaccolta.IdCentroRaccolta
JOIN T_AreaCentroRaccolta ON T_CentroRaccolta.IdAreaCentroRaccolta = T_AreaCentroRaccolta.IdAreaCentroRaccolta
JOIN T_Sim ON T_AreaCentroRaccolta.IdSim = T_Sim.IdSim
WHERE FlagAttivo = 1
AND CodRuoloContatto IN (6,7)
AND T_Contatto.Descrizione = 'Manuale - Richiesto da Roberto Bolgiani (azimut)'


