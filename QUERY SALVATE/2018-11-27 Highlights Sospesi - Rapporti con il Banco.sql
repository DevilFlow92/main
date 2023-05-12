USE CLC
GO

--CREATE VIEW rs.v_CESAM_AZ_Sospesi_BP AS


/*
197    Finanziamenti e Affidamenti-BP
205    Variazioni - Finanziamenti e Affidamenti-BP
*/

/* LOGICHE SOSPESO:
Apertura (Chiusura) Sospeso:
       - Attributo IN ATTESA INTEGRAZIONI (Attributo INTEGRAZIONI RICEVUTE)
                           238    IN ATTESA DI INTEGRAZIONI
                           239    INTEGRAZIONI RICEVUTE
       
       - WF In Gestione - Attesa risontro CF Pre Delibera (In Gestione - Attesa Delibera)
                           14528  Attesa riscontro CF Pre Delibera
                           7653   Attesa delibera
                           
       - WF In Gestione - Attesa riscontro CF Post Delibera (Gestita - Deliberata)
                           14529  Attesa riscontro CF Post Delibera
                           6519   Deliberata

Rimbalzi - Comunicazioni inviate al promotore:
       - Template mail:
			6406	Integrazioni per Finanziamenti_Affidamenti
			6603	Mail generica Consulente per Finanziamenti
*/


;
WITH entranti AS (SELECT
	ti.IdIncarico
	,lwi.IdTransizione
	,lwi.DataTransizione DataAperturaSospeso
	,ROW_NUMBER() OVER (PARTITION BY lwi.IdIncarico ORDER BY lwi.IdTransizione) AS ProgressivoAperturaSospeso

FROM T_Incarico ti

JOIN L_WorkflowIncarico lwi
	ON ti.IdIncarico = lwi.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico IN (197    --Finanziamenti e Affidamenti-BP
, 205)  --Variazioni - Finanziamenti e Affidamenti-BP
AND ((
(lwi.CodAttributoIncaricoPartenza != 238 --IN ATTESA DI INTEGRAZIONI
OR lwi.CodAttributoIncaricoPartenza IS NULL)
AND lwi.CodAttributoIncaricoDestinazione = 238
)
OR (lwi.CodStatoWorkflowIncaricoPartenza NOT IN (14528      --Attesa riscontro CF Pre Delibera
, 14529 --Attesa riscontro CF Post Delibera
)
AND lwi.CodStatoWorkflowIncaricoDestinazione IN (14528      --Attesa riscontro CF Pre Delibera
, 14529 --Attesa riscontro CF Post Delibera
)
)
)
--AND ti.IdIncarico = 10866729
),
uscenti AS (SELECT
	ti.IdIncarico
	,lwi.IdTransizione
	,lwi.DataTransizione DataChiusuraSospeso
	,ROW_NUMBER() OVER (PARTITION BY lwi.IdIncarico ORDER BY lwi.IdTransizione) AS ProgressivoChiusuraSospeso

FROM T_Incarico ti

JOIN L_WorkflowIncarico lwi
	ON ti.IdIncarico = lwi.IdIncarico
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico IN (197    --Finanziamenti e Affidamenti-BP
, 205) --Variazioni - Finanziamenti e Affidamenti-BP
AND (
(lwi.CodAttributoIncaricoPartenza = 238       --IN ATTESA DI INTEGRAZIONI 
AND lwi.CodAttributoIncaricoDestinazione = 239 --INTEGRAZIONI RICEVUTE
)
OR (lwi.CodStatoWorkflowIncaricoPartenza = 14528      --Attesa riscontro CF Pre Delibera
AND lwi.CodStatoWorkflowIncaricoDestinazione = 7653   --Attesa delibera
)
OR (lwi.CodStatoWorkflowIncaricoPartenza = 14529      --Attesa riscontro CF Post Delibera
AND lwi.CodStatoWorkflowIncaricoDestinazione = 6519   --Deliberata
)
)
--AND lwi.IdIncarico = 10866729
)


--SELECT
--     *
--FROM entranti
--WHERE IdIncarico = 10866729

--SELECT
--     *
--FROM uscenti
--WHERE IdIncarico = 10866729

SELECT
	ti.IdIncarico
	,ti.CodTipoIncarico
	,descrizioni.TipoIncarico
	,ti.CodStatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico
	,ti.DataCreazione DataCreazioneIncarico
	,YEAR(DataCreazione) Anno
	,CASE  MONTH(DataCreazione) 
		WHEN 1 THEN 'Gennaio'
		WHEN 2 THEN 'Febbraio'
		WHEN 3 THEN 'Marzo'
		WHEN 4 THEN 'Aprile'
		WHEN 5 THEN 'Maggio'
		WHEN 6 THEN 'Giugno'
		WHEN 7 THEN 'Luglio'
		WHEN 8 THEN 'Agosto'
		WHEN 9 THEN 'Settembre'
		WHEN 10 THEN 'Ottobre'
		WHEN 11 THEN 'Novembre'
		WHEN 12 THEN 'Dicembre'
		END EtichettaMese
	,ti.DataUltimaTransizione DataChiusuraIncarico
	,ti.CodAttributoIncarico
	,descrizioni.AttributoIncarico

	,van.idpersona
	,van.ChiaveClienteIntestatario
	,IIF(van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = '', van.RagioneSocialeIntestatario, van.CognomePromotore) + ' ' + ISNULL(van.NomeIntestatario, '') Cliente
	,van.CodicePromotore CodiceConsulente
	,IIF(van.CognomePromotore IS NULL OR van.CognomePromotore = '', van.RagioneSocialePromotore, van.CognomePromotore) + ' ' + ISNULL(van.NomePromotore, '') Consulente
	,van.CodCentroraccolta
	,van.DescrizioneCentroRaccolta
	,van.CodAreaCentroRaccolta
	,van.DescrizioneAreaCentroRaccolta
	,van.CodSim
	,van.DescrizioneSim

	,entranti.DataAperturaSospeso
	,uscenti.DataChiusuraSospeso
	,IIF(entranti.IdIncarico IS NOT NULL AND ROW_NUMBER() OVER (PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico) = 1,DATEDIFF(DAY,DataCreazione,DataUltimaTransizione),0) DurataIncarico
	,IIF(entranti.IdIncarico IS NOT NULL AND ROW_NUMBER() OVER (PARTITION BY entranti.IdTransizione ORDER BY ProgressivoAperturaSospeso ) = 1,DATEDIFF(DAY,DataAperturaSospeso,DataChiusuraSospeso),0) DurataSospeso

	,IIF(entranti.IdIncarico IS NOT NULL AND ROW_NUMBER() OVER (PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico) = 1, COUNT(IdComunicazione), 0) AS RimbalziPerIncarico

	,IIF(entranti.IdIncarico IS NOT NULL and ROW_NUMBER() OVER (PARTITION BY entranti.IdTransizione ORDER BY ProgressivoAperturaSospeso ) = 1, 1, 0) IsSospeso
	,IIF(entranti.IdIncarico is NOT NULL AND ROW_NUMBER() OVER (PARTITION BY ti.IdIncarico ORDER BY ti.IdIncarico) = 1,1,0) IsIncaricoSospeso
	,ISNULL(entranti.IdIncarico, 0) Sospeso

	,sospesi.IdSospeso
		,sospesi.ProgressivoSospeso
		,sospesi.CodTipoOperazione
		,sospesi.CodTipoProdotto
		,sospesi.TipoOperazione
		,sospesi.TipoProdotto
		,sospesi.CodStatoSospesoAttuale
		,sospesi.StatoSospesoAttuale
		,sospesi.CodTipoDoppioSospeso
		,sospesi.TipoDoppioSospeso
		,sospesi.Progressivomotivazione
		,sospesi.Motivazione
		,sospesi.SottoMotivazione
		,sospesi.Modalita
		,sospesi.NotaMotivazione
	
FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni
	ON ti.IdIncarico = descrizioni.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van
	ON ti.IdIncarico = van.IdIncarico
	AND van.ProgressivoPersona = 1
LEFT JOIN entranti
	ON ti.IdIncarico = entranti.IdIncarico

LEFT JOIN uscenti
	ON ti.IdIncarico = uscenti.IdIncarico

LEFT JOIN R_TemplateComunicazione_StatoWorkflowIncarico r ON ti.CodCliente = r.CodCliente
																AND ti.CodTipoIncarico = r.CodTipoIncarico
																AND r.IdTemplateComunicazione IN (6406	--Integrazioni per Finanziamenti_Affidamenti
																								  ,6603	--Mail generica Consulente per Finanziamenti
																								  )
LEFT JOIN T_Comunicazione tc ON ti.IdIncarico = tc.IdIncarico 
								AND tc.IdTemplate = r.IdTemplateComunicazione


LEFT JOIN rs.v_CESAM_AZ_SOSP_DoppiSospesiProgressivo sospesi ON ti.IdIncarico = sospesi.IdIncarico

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico IN (197    --Finanziamenti e Affidamenti-BP
, 205) --Variazioni - Finanziamenti e Affidamenti-BP

AND (ProgressivoAperturaSospeso = ProgressivoChiusuraSospeso
OR (ProgressivoAperturaSospeso IS NULL
AND ProgressivoChiusuraSospeso IS NULL)
)


AND ti.IdIncarico = 10866729

GROUP BY 
ti.IdIncarico
	,ti.CodTipoIncarico
	,descrizioni.TipoIncarico
	,ti.CodStatoWorkflowIncarico
	,descrizioni.StatoWorkflowIncarico
	,ti.DataCreazione 
	,YEAR(DataCreazione) 
	,CASE  MONTH(DataCreazione) 
		WHEN 1 THEN 'Gennaio'
		WHEN 2 THEN 'Febbraio'
		WHEN 3 THEN 'Marzo'
		WHEN 4 THEN 'Aprile'
		WHEN 5 THEN 'Maggio'
		WHEN 6 THEN 'Giugno'
		WHEN 7 THEN 'Luglio'
		WHEN 8 THEN 'Agosto'
		WHEN 9 THEN 'Settembre'
		WHEN 10 THEN 'Ottobre'
		WHEN 11 THEN 'Novembre'
		WHEN 12 THEN 'Dicembre'
		END 
	,ti.DataUltimaTransizione 
	,ti.CodAttributoIncarico
	,descrizioni.AttributoIncarico

	,van.idpersona
	,van.ChiaveClienteIntestatario
	,IIF(van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = '', van.RagioneSocialeIntestatario, van.CognomePromotore) + ' ' + ISNULL(van.NomeIntestatario, '') 
	,van.CodicePromotore 
	,IIF(van.CognomePromotore IS NULL OR van.CognomePromotore = '', van.RagioneSocialePromotore, van.CognomePromotore) + ' ' + ISNULL(van.NomePromotore, '') 
	
	,entranti.IdIncarico
	,entranti.DataAperturaSospeso
	,uscenti.DataChiusuraSospeso
	,entranti.IdTransizione
	,ProgressivoAperturaSospeso
	,ProgressivoChiusuraSospeso
GO

SELECT * FROM T_Comunicazione
WHERE IdIncarico = 10866729

AND Destinatario = 'pietro.marciano@azimut.it'
EXCEPT

SELECT * FROM T_Comunicazione
WHERE IdIncarico = 10866729

AND IdTemplate  IN (6406	--Integrazioni per Finanziamenti_Affidamenti
					,6603	--Mail generica Consulente per Finanziamenti
					)