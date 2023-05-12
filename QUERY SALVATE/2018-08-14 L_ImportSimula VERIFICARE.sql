USE CLC
SELECT * FROM D_Cliente WHERE Descrizione LIKE '%ing%'

SELECT * FROM T_Persona WHERE Cognome = 'fiori' AND Nome LIKE 'lore%'--AND CodCliente = 111


SELECT * FROM rs.v_CESAM_Anagrafica_Cliente_Promotore where idpersona in (3522306
,3612549)


SELECT * FROM T_R_Incarico_Mandato
JOIN T_Mandato on T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
JOIN T_R_Dossier_Persona on T_Mandato.IdDossier = T_R_Dossier_Persona.IdDossier where  idpersona in (3522306
,3612549)


SELECT * FROM T_Contatto where IdPersona in (3522306
,3612549)


SELECT * FROM scratch.InfinityData WHERE Cognome = 'secci'

USE CLC_DatawareHouse
SELECT * FROM T_Mandato --ON T_R_Incarico_Mandato.IdMandato = T_Mandato.IdMandato
WHERE NumeroSimula = '1097668'

USE clc

SELECT * FROM L_ImportSimula 
JOIN L_ImportSimulaAnagrafica ON L_ImportSimula.IdImportSimula = L_ImportSimulaAnagrafica.IdImportSimula
JOIN L_ImportSimulaOperazione on L_ImportSimula.IdImportSimula = L_ImportSimulaOperazione.IdImportSimula
where CodiceSimula = 1097688


--UPDATE L_ImportSimulaOperazione
--SET FlagAssociato = 0
--WHERE IdImportSimulaOperazione in (1040854
--,1040855
--,1040856
--,1040857
--,1040858
--,1040859)