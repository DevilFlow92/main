USE clc

GO

SELECT 
	ti.DataCreazione DataCreazioneIncarico
	,ti.IdIncarico
	,D_TipoIncarico.Descrizione TipoIncarico
	,anagrafica.CodicePromotore + ' ' + 
		CASE WHEN anagrafica.CognomePromotore IS NULL OR anagrafica.CognomePromotore = ''
			THEN anagrafica.RagioneSocialePromotore
			ELSE anagrafica.CognomePromotore + ISNULL(' ' + anagrafica.NomePromotore,'')
		END Consulente
	,CASE
		WHEN anagrafica.DescrizioneSim IS NULL OR
			anagrafica.DescrizioneSim = '' THEN '1. SENZA MACRO AREA'
		WHEN anagrafica.DescrizioneSim NOT IN (
			'AREA 0'
			, 'AREA 1'
			, 'AREA 2'
			, 'AREA 3'
			, 'AREA 4'
			, 'AREA 5'
			, 'AREA 6'
			, 'AREA 7'
			, 'AREA 7 SOFIA') THEN '2. ALTRA MACRO AREA'
		ELSE anagrafica.DescrizioneSim
	END MacroArea
	,CASE
		WHEN anagrafica.DescrizioneAreaCentroRaccolta IS NULL OR
			anagrafica.DescrizioneAreaCentroRaccolta = '' THEN '1. SENZA AREA'
		ELSE anagrafica.DescrizioneAreaCentroRaccolta
	END AS Area
	--,v.IdSospeso
	,IIF(v.IdSospeso IS NOT NULL, 1, 0) SospesoAperto
	,IIF(ti.CodTipoIncarico IN (396 --OnBoarding Digitale
							 ,397 --Servizi Investimento Digitale
							 )
		 AND wfOnboarding.IdTransizione is NULL
		 ,1,0) FlagIncaricoEscluso

	,ISNULL(ISNULL(Smartworking.Canale,ISNULL( IncMaster.TipoFea,D_TipoFea.Descrizione)),'Carta') Canale
	--,smartworking.canale
FROM T_Incarico ti
LEFT JOIN D_TipoIncarico
	ON ti.CodTipoIncarico = D_TipoIncarico.Codice
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica
	ON ti.IdIncarico = anagrafica.IdIncarico
	AND anagrafica.ProgressivoPersona = 1
OUTER APPLY (
		SELECT TOP 1 xx.IdSospeso 
        FROM rs.v_CESAM_AZ_SOSP_DoppiSospesiProgressivo_noFilter xx
		WHERE xx.IdIncarico = ti.IdIncarico
		ORDER BY xx.IdSospeso DESC
) v

OUTER APPLY (
			SELECT TOP 1 IdIncarico, 'Smartworking' Canale
            FROM T_Comunicazione
			WHERE T_Comunicazione.IdIncarico = ti.idincarico
			AND CodOrigineComunicazione = 2
			AND Destinatario LIKE '%smartworking%cesam%'
			ORDER BY IdComunicazione ASC
) Smartworking

OUTER APPLY (SELECT TOP 1
		trisx.IdIncarico
	   ,trisx.IdSubIncarico
	   ,tdaiax.CodTipoFea
	   ,dtfx.Descrizione TipoFea
	FROM dbo.T_R_Incarico_SubIncarico trisx
	JOIN dbo.T_Incarico tix
		ON trisx.IdIncarico = tix.IdIncarico
		AND tix.CodCliente = 23
		AND tix.CodTipoIncarico = 192
		AND tix.CodArea = 8
		AND tix.FlagArchiviato = 0
	JOIN dbo.T_DatiAggiuntiviIncaricoAzimut tdaiax
		ON trisx.IdIncarico = tdaiax.IdIncarico
	JOIN dbo.D_TipoFea dtfx
		ON tdaiax.CodTipoFea = dtfx.Codice
	WHERE trisx.IdSubIncarico = ti.IdIncarico) IncMaster


LEFT JOIN T_DatiAggiuntiviIncaricoAzimut ON ti.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico
LEFT JOIN D_TipoFea ON T_DatiAggiuntiviIncaricoAzimut.CodTipoFea = D_TipoFea.Codice

OUTER APPLY (
				SELECT TOP 1 IdTransizione, CodStatoWorkflowIncaricoDestinazione
                FROM L_WorkflowIncarico
				WHERE L_WorkflowIncarico.IdIncarico = ti.idincarico
				AND CodStatoWorkflowIncaricoPartenza != CodStatoWorkflowIncaricoDestinazione
				AND CodStatoWorkflowIncaricoDestinazione IN (15502 --Attesa documentazione cartacea
				, 14614 --Pronta per lavorazione Back-Office
				)
) wfOnboarding

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico NOT IN (
192 --Raccomandazione
,53		--Finanziamenti e Affidamenti
,90		--Posta Disguidata
,99		--Sottoscrizioni/Versamenti Fondo Pensione
,112	--OnBoarding Antiriciclaggio
,140	--Scheda Conoscitiva Riservata
,141	--Scheda Fiduciaria
,151	--Successioni - Sicav
,164	--Successioni - Polizze Azimut Life
,165	--Successioni - Fondi di Investimento
,166	--Successioni - Polizze Compagnie Terze
,175	--Successioni - Previdenza
,184	--Successioni - Gestioni Individuali
,185	--Successioni - Raccolta Ordini
,193	--Successioni - Banco Popolare
,210	--Accertamento e Accesso Preventivo
,212	--Pignoramento
,213	--Sequestro/Dissequestro
,291	--Lettera Antiriciclaggio
,351	--Successioni AFB
,407	--Approfondimenti Antiriciclaggio - BancoBPM
,517	--Servizio Concierge
,522	--Verifiche Rafforzate Antiriciclaggio
,524	--Approfondimenti Antiriciclaggio
,539	--Processo Generico - Zenith
,617	--Selfie Cliente 2.0
,648	--Attività non BAU
,659	--AZISF - Successioni - Previdenza
,669	--Partite Prenotate
,730	--Variazioni Anagrafiche F2B
)
--AND ti.idincarico IN(16990056,16982271 )

AND ti.DataCreazione >= @DataDal
AND ti.DataCreazione < @DataAl