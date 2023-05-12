USE CLC_Cesam

GO

SELECT ti.IdIncarico
,ISNULL(nrapporto.Leading_refCode,'06')
	+RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(T_DatoAggiuntivo.Testo,' ',''),CHAR(13),''),char(10),''),CHAR(9),''),12) as NumeroRapporto
,T_Persona.ChiaveCliente [NDG Intestatario]
,CASE WHEN Cognome IS NULL OR Cognome = ''
	THEN RagioneSociale
	ELSE Cognome + ISNULL(' ' + Nome,'') 
	END Intestatario
,d.TipoIncarico
,NomeScatola [Nome Scatola]
,d.StatoWorkflowIncarico [Stato Workflow Incarico QTask]

, FORMAT(ti.DataCreazione,'dd/MM/yyyy HH:mm') [Data Creazione], FORMAT(ti.DataUltimaTransizione,'dd/MM/yyyy HH:mm') [Data Ultima Transizione]
--,IdPosizioneArchivio
FROM rs.v_CESAM_Scatole_NON_Archiviabili_IncarichiSospesi v
JOIN T_Incarico ti ON v.IdIncarico = ti.IdIncarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.idincarico = d.IdIncarico
JOIN dbo.T_PeriodoPosizioneArchivioUtilizzata ON ti.IdIncarico = T_PeriodoPosizioneArchivioUtilizzata.IdIncarico
LEFT JOIN T_R_Incarico_Persona ON ti.IdIncarico = T_R_Incarico_Persona.IdIncarico
AND T_R_Incarico_Persona.Progressivo = 1
LEFT JOIN T_Persona ON T_R_Incarico_Persona.IdPersona = T_Persona.IdPersona
LEFT JOIN T_DatoAggiuntivo ON T_DatoAggiuntivo.IdIncarico = ti.IdIncarico 
AND CodTipoDatoAggiuntivo = 643 and FlagAttivo = 1
--643	IBAN
		LEFT JOIN (
		SELECT MAX(DocNRapporto.documento_id) Documento_id, T_Incarico.IdIncarico,CASE Testo when 'Conto Tascabile' THEN '32' ELSE '06' END  Leading_refCode 
		FROM  T_Documento DocNRapporto 
		JOIN T_Incarico on DocNRapporto.IdIncarico = T_Incarico.IdIncarico
		JOIN T_DatoAggiuntivo ON T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico
		AND FlagAttivo = 1
		AND CodTipoDatoAggiuntivo = 1208
		GROUP BY T_Incarico.IdIncarico,CASE Testo when 'Conto Tascabile' THEN '32' ELSE '06' END 
				) nrapporto ON nrapporto.IdIncarico = ti.IdIncarico

--WHERE v.isarchiviata != 1
--AND v.NomeScatola IS NULL

--/*
WHERE NomeScatola IN (
/**** inserire dettaglio scatole ******/
'CESAM-CB!NEW-1-1-18'		
,'CESAM-CB!NEW-1-1-27'		
,'CESAM-CB!NEW-1-1-51'		
,'CESAM-CB!NEW-1-1-53'		
,'CESAM-CB!NEW-1-1-29'		
,'CESAM-CB!NEW-1-1-37'		
,'CESAM-CB!NEW-1-1-17'		
,'CESAM-CB!NEW-1-1-20'		
,'CESAM-CB!NEW-1-1-28'		
,'CESAM-CB!NEW-1-1-24'		
,'CESAM-CB!NEW-1-1-35'		
,'CESAM-CB!NEW-1-1-26'		
,'CESAM-CB!NEW-1-1-25'		
,'CESAM-CB!NEW-1-1-36'		
,'CESAM-CB!NEW-1-1-21'		
,'CESAM-CB!NEW-1-1-19'		
,'CESAM-CB!NEW-1-1-8'		
,'CESAM-CB!NEW-1-1-54'		
,'CESAM-CB!NEW-1-1-55'		
,'CESAM-CB!NEW-1-1-56'		
,'CESAM-CB!NEW-1-1-57'		
,'CESAM-CB!-CONSULENZA-1-1-12'
/**************************/
)
--*/
ORDER BY [Nome Scatola]