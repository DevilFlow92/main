use CLC 

SELECT TOP 1 
	T_Incarico.IdIncarico
   ,CASE WHEN 
	 D_Documento.Codice = 10025 --modulo apertura Conto Tascabile
		THEN '32' + RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 12)
		ELSE '06' + RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 12)
	END CodiceRapporto
   ,REPLACE(REPLACE(REPLACE(REPLACE(T_persona.CodiceFiscale, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '') CodiceFiscale
   ,REPLACE(REPLACE(REPLACE(REPLACE(T_Persona.ChiaveCliente, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '') NDG_Cliente
   ,D_Documento.Codice
   ,Descrizione

--,DataUltimaTransizione
--,GiornoSettimana
--,EtichettaGiornoSettimana
--,CodStatoWorkflowIncarico
--,CodAttributoIncarico

FROM T_Incarico
JOIN T_DatoAggiuntivo
	ON T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico
		AND CodTipoDatoAggiuntivo = 643
		AND FlagAttivo = 1
JOIN T_R_Incarico_Persona
	ON T_R_Incarico_Persona.IdIncarico = T_Incarico.IdIncarico
JOIN T_Persona
	ON T_Persona.IdPersona = T_R_Incarico_Persona.IdPersona
		AND Progressivo = 1
JOIN T_Documento
	ON T_Incarico.IdIncarico = T_Documento.IdIncarico
JOIN D_Documento
	ON T_Documento.Tipo_Documento = D_Documento.Codice
		AND CodOggettoControlli = 44 --Che Banca - Apertura CC


---- ELIMINO TUTTI GLI INCARICHI CHE HANNO L'ATTRIBUTO 1457 - DOCBANK KO Da A - considera il primo attributo
--LEFT JOIN (SELECT MIN(IdTransizione) idtransizione,MIN(DataTransizione) DataTransizione,L_WorkflowIncarico.IdIncarico FROM T_Incarico
--		JOIN L_WorkflowIncarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
--		WHERE CodTipoIncarico = 331 AND CodArea = 8 AND CodCliente = 48
--		AND CodAttributoIncaricoDestinazione = 1457
--		AND IdOperatore IN ( 21,12572)
--		--AND L_WorkflowIncarico.IdIncarico = 8792457
--		GROUP by L_WorkflowIncarico.IdIncarico	
--		HAVING min(DataTransizione) <= cast(cast(getdate() as varchar(12)) as datetime)-3 --escludo tutti gli inc che hanno timbro doc ko da più di 7 giorni
--			--OR min(DataTransizione) >= cast(cast(getdate() as varchar(12)) as datetime)-1 --escludo tutti gli inc che hanno timbro doc ko da meno di un giorno
--		) KoLoop ON KoLoop.IdIncarico = T_Incarico.IdIncarico

-- ELIMINO TUTTI GLI INCARICHI CHE HANNO L'ATTRIBUTO 1457 - DOCBANK KO - considera l'ultimo attributo
LEFT JOIN (SELECT
		MAX(IdTransizione) idtransizione
	   ,MAX(DataTransizione) DataTransizione
	   ,L_WorkflowIncarico.IdIncarico
	FROM T_Incarico
	JOIN L_WorkflowIncarico
		ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
	WHERE CodTipoIncarico = 331
	AND CodArea = 8
	AND CodCliente = 48
	AND CodAttributoIncaricoDestinazione = 1457
	AND IdOperatore IN (21, 12572, 12520)
	--AND L_WorkflowIncarico.IdIncarico = 8792457
	GROUP BY L_WorkflowIncarico.IdIncarico
	HAVING MAX(DataTransizione) >= CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME) --escludo tutti gli inc che hanno timbro doc ko da meno di un giorno
) MaxKoLoop
	ON MaxKoLoop.IdIncarico = T_Incarico.IdIncarico

LEFT JOIN (SELECT
		MAX(IdTransizione) idtransizione
	   ,MAX(DataTransizione) datatransizione
	   ,IdIncarico
	FROM L_WorkflowIncarico
	WHERE CodStatoWorkflowIncaricoDestinazione = 14275
	AND IdOperatore != 12572 --R_Sistema
	AND IdOperatore != 12520 --CB_sistema
	GROUP BY IdIncarico) transizione
	ON transizione.IdIncarico = T_Incarico.IdIncarico


LEFT JOIN S_Data
	ON CONVERT(VARCHAR(10), GETDATE(), 112) = ChiaveData


WHERE T_Incarico.IdIncarico = 9494837
--T_Incarico.CodCliente = 48 
--AND T_Incarico.CodTipoIncarico = 331
--AND CodArea = 8
--AND T_Incarico.IdIncarico = 9048273  

--AND transizione.datatransizione <= CASE WHEN GiornoSettimana IN (1,2)
--										THEN cast(cast(getdate() as varchar(12)) as datetime)-4 
--										else cast(cast(getdate() as varchar(12)) as datetime)-1 END 
--AND transizione.datatransizione >= CASE WHEN GiornoSettimana IN (1,2,3,4) 
--										THEN  cast(cast(getdate() as varchar(12)) as datetime)-(6) 
--										else  cast(cast(getdate() as varchar(12)) as datetime)-(4) END

--AND CodStatoWorkflowIncarico IN (14275 -- Documentazione DocBank Completa
--)

--AND (CodAttributoIncarico NOT IN (1462, 1465) OR CodAttributoIncarico IS NULL) --Anagrafica da verificare --Incarico in lavorazione	

----AND KoLoop.IdIncarico is NULL
--AND MaxKoLoop.IdIncarico IS NULL
--AND EXISTS (SELECT GETDATE() WHERE (datepart(HOUR,GETDATE()) IN (9,10,11,12,13,14,15,16,17,18,19)))


GROUP BY T_Incarico.IdIncarico
		,CASE WHEN D_Documento.Codice = 10025 --modulo apertura Conto Tascabile
				THEN '32' + RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 12)
				ELSE '06' + RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''), 12)
		 END 
		,REPLACE(REPLACE(REPLACE(REPLACE(T_persona.CodiceFiscale, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
		,REPLACE(REPLACE(REPLACE(REPLACE(T_Persona.ChiaveCliente, ' ', ''), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
		,DataUltimaTransizione
		,D_Documento.Codice
		,Descrizione

--,GiornoSettimana
--,EtichettaGiornoSettimana
--ORDER BY DataUltimaTransizione asc
