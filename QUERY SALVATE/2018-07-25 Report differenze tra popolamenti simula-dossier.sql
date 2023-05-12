USE CLC
GO

DECLARE @ImportDA DATETIME
		,@ImportA DATETIME
SET @ImportDA = '20180720'
SET @ImportA = GETDATE()


;WITH eccezioni AS (
SELECT DISTINCT L_ImportSimula.IdImportSimula, 
IIF(isnumeric(ChiaveCliente) = 1 ,format(CAST(ChiaveCliente as INT),'000000000'),ChiaveCliente) + SPACE(1) +
CASE when Ruolo = 'contraente assicurato' THEN 'intestatario' ELSE Ruolo end  + SPACE(1) + Cognome + SPACE(1) + ISNULL(Nome,'') Anagrafica, 
NumeroDossier
FROM L_ImportSimulaAnagrafica
JOIN L_ImportSimula on L_ImportSimulaAnagrafica.IdImportSimula = L_ImportSimula.IdImportSimula
JOIN L_ImportSimulaOperazione ON L_ImportSimula.IdImportSimula = L_ImportSimulaOperazione.IdImportSimula
WHERE NumeroDossier is NOT NULL AND FlagAssociato = 1

AND DataImport >= @ImportDA --'20180725'
AND DataImport < @ImportA 
--getdate()
--AND NumeroDossier = 'D000319791'

EXCEPT

SELECT DISTINCT
IdImportSimula, 
ChiaveCliente + SPACE(1) + 

CASE when D_RuoloRichiedente.Descrizione  = 'contraente assicurato' THEN 'intestatario' ELSE D_RuoloRichiedente.Descrizione  end

+ SPACE(1) +
IIF(CodTipoPersona = 2,RagioneSociale,ISNULL(Cognome,RagioneSociale)) + SPACE(1) + ISNULL(Nome,'') Anagrafica
,T_Dossier.NumeroDossier
FROM L_ImportSimula
JOIN T_Mandato ON CAST(CodiceSimula as VARCHAR(20)) = T_Mandato.NumeroSimula
JOIN T_Dossier on T_Mandato.IdDossier = T_Dossier.IdDossier
JOIN T_R_Dossier_Persona on T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
JOIN T_Persona on T_R_Dossier_Persona.IdPersona = T_Persona.IdPersona
JOIN D_RuoloRichiedente on Codice = CodRuoloRichiedente

WHERE L_ImportSimula.NumeroDossier IS NOT NULL
AND DataImport >= @ImportDA --'20180725'
AND DataImport < @ImportA --getdate()

--AND L_ImportSimula.NumeroDossier = 'D000319791'

)

SELECT   MAX(T_R_Incarico_Mandato.IdIncarico) IdIncarico
			,T_Dossier.IdDossier
			,T_Dossier.IdPromotore
			,eccezioni.NumeroDossier
			,L_ImportSimulaAnagrafica.ChiaveCliente + ' - ' + L_ImportSimulaAnagrafica.Cognome + SPACE(1) + ISNULL(L_ImportSimulaAnagrafica.Nome,'') + ' [' + L_ImportSimulaAnagrafica.Ruolo + ']' AS PopolamentoSimula
			,T_Persona.ChiaveCliente + ' - ' + IIF(T_Persona.CodTipoPersona = 2,RagioneSociale, ISNULL(T_Persona.Cognome,RagioneSociale)) + SPACE(1) + ISNULL(T_Persona.Nome,'') + ' [' + D_RuoloRichiedente.Descrizione + ']' AS PopolamentoQTask

FROM eccezioni
JOIN T_Dossier on eccezioni.NumeroDossier = T_Dossier.NumeroDossier
JOIN T_Mandato on T_Dossier.IdDossier = T_Mandato.IdDossier
JOIN T_R_Incarico_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato --and Progressivo = 1
JOIN T_Incarico ON T_R_Incarico_Mandato.IdIncarico = T_Incarico.IdIncarico
JOIN T_R_Dossier_Persona on T_Dossier.IdDossier = T_R_Dossier_Persona.IdDossier
JOIN T_Persona ON T_R_Dossier_Persona.IdPersona = T_Persona.IdPersona
JOIN D_RuoloRichiedente on D_RuoloRichiedente.Codice = T_R_Dossier_Persona.codruolorichiedente

JOIN L_ImportSimula ON eccezioni.IdImportSimula = L_ImportSimula.IdImportSimula
JOIN L_ImportSimulaAnagrafica on L_ImportSimula.IdImportSimula = L_ImportSimulaAnagrafica.IdImportSimula

--JOIN (SELECT L_ImportSimula.IdImportSimula, ChiaveCliente --,COUNT(IdImportSimulaAnagrafica)
--		 FROM L_ImportSimula
--		 join L_ImportSimulaAnagrafica on L_ImportSimula.IdImportSimula = L_ImportSimulaAnagrafica.IdImportSimula
--		 JOIN L_ImportSimulaOperazione ON L_ImportSimula.IdImportSimula = L_ImportSimulaOperazione.IdImportSimula
--		 WHERE 
--		 --CodiceSimula IN (1086119,1088893) AND
--		 CodiceOperazione NOT IN ('SWOUTPA','SWOUTTOT')

--			GROUP BY L_ImportSimula.IdImportSimula, ChiaveCliente,CodiceOperazione
--			HAVING COUNT(IdImportSimulaAnagrafica) < (IIF(CodiceOperazione IN ('swinsuc','swoutpa','swouttot'),4,2))
--			) a ON eccezioni.IdImportSimula = a.IdImportSimula

WHERE CodArea = 8
AND T_Incarico.CodCliente = 23

--AND T_Incarico.IdIncarico IN ( 10679898 ,10701314,10701785,10701810,10702129)

--AND T_Incarico.IdIncarico in ( 10702129,10673281,10728651)

GROUP BY T_Dossier.IdDossier
			,IdPromotore
			,eccezioni.NumeroDossier
			,L_ImportSimulaAnagrafica.ChiaveCliente + ' - ' + L_ImportSimulaAnagrafica.Cognome + SPACE(1) + ISNULL(L_ImportSimulaAnagrafica.Nome,'') + ' [' + L_ImportSimulaAnagrafica.Ruolo + ']'
			,T_Persona.ChiaveCliente + ' - ' + IIF(T_Persona.CodTipoPersona = 2,RagioneSociale, ISNULL(T_Persona.Cognome,RagioneSociale)) + SPACE(1) + ISNULL(T_Persona.Nome,'') + ' [' + D_RuoloRichiedente.Descrizione + ']'


ORDER BY IdIncarico

GO

--SELECT * FROM L_ImportSimula WHERE NumeroDossier IN ('D000343616',
--'D000319791') AND DataImport >= '20180720'

