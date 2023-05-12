USE CLC
IF OBJECT_ID('tempdb.dbo.#contatti') IS NOT NULL
DROP TABLE #contatti

--20 righe
SELECT  IdPromotore
		,T_Persona.IdPersona
		,RagioneSociale
		,Cognome
		,Nome
		,IdContatto, FlagAttivo,
		CodRuoloContatto
		,D_RuoloContatto.Descrizione RuoloContatto
		,Email
		,'bancassicurazione@treviglio.bcc.it' ContattoAlternativoBCCTreviglio
		,'Bo.Titoli@sinergia.bcc.it' ContattoPrincipaleSinergia

INTO #contatti
FROM T_Promotore

JOIN T_Persona ON T_Promotore.IdPersona = T_Persona.IdPersona

JOIN T_Contatto ON T_Persona.IdPersona = T_Contatto.IdPersona

JOIN D_RuoloContatto on D_RuoloContatto.Codice = CodRuoloContatto

WHERE (RagioneSociale like '%treviglio%' OR Cognome LIKE '%treviglio%' OR Nome LIKE '%treviglio%')

AND FlagAttivo = 1
AND CodRuoloContatto = 7
AND Email <> 'bo.titoli@sinergia.bcc.it'


--20 righe
UPDATE T_Contatto
SET FlagAttivo = 0
FROM T_Contatto 

JOIN #contatti ON T_Contatto.IdContatto = #contatti.IdContatto

--32 righe
INSERT INTO T_Contatto (IdPersona, IdSedeAtc, Referente, Telefono, Fax, Email, Descrizione, Cellulare, EmailPec, FlagAttivo, CodRuoloContatto, CodTipoContatto, EmailAlternativa)
SELECT DISTINCT
	c.IdPersona
	,NULL
	,NULL
	,NULL
	,NULL
	,ContattoPrincipaleSinergia [Email]
	,NULL
	,NULL
	,NULL
	,1 [FlagAttivo]
	,7 --Sospesi Contatto Principale
	,NULL
	,NULL
FROM  #contatti c
UNION ALL

SELECT DISTINCT
	c.IdPersona
	,NULL
	,NULL
	,NULL
	,NULL
	,ContattoAlternativoBCCTreviglio [Email]
	,null
	,null
	,null
	,1 [FlagAttivo]
	,8 --Sospesi Contatto Alternativo
	,null
	,null
FROM #contatti c 

DROP TABLE #contatti

