USE CLC
GO

/*
author: A. Padricelli

20180405
*/

ALTER VIEW rs.v_CESAM_CheBanca_Monitor_Lavorazioni AS



SELECT 
--CodTipoSLALavorazione, TempoSLALavorazione
--,
dbo.T_Incarico.IdIncarico
,IIF(IntervalloLavorativo = 0, IntervalloLavorativo, IntervalloLavorativo/60) IntervalloLavorativoH
,CodMacroStatoWorkflowIncarico
,MIN(Documento_id) mindocid
,dbo.T_Incarico.DataCreazione
,DataUltimaTransizione
,T_Incarico.CodTipoIncarico
,D_TipoIncarico.Descrizione DescrizioneIncarico
,T_Incarico.CodStatoWorkflowIncarico
,D_MacroStatoWorkflowIncarico.Descrizione +' - '+D_StatoWorkflowIncarico.Descrizione  + ' - ' +ISNULL(D_AttributoIncarico.Descrizione,'') DescrizioneStatoWF
,T_Incarico.CodAttributoIncarico
,D_AttributoIncarico.Descrizione DescrizioneAttributo
,T_DatoAggiuntivo.Testo IBAN--iban
,ISNULL(S_Operatore.IdOperatore, 1) IdOperatore
,ISNULL(S_Operatore.Etichetta, 'NessunOperatore') EtichettaOperatore
,S_Operatore.CodSede
,ISNULL(D_SedeOperatore.Descrizione, 'NessunaSede') DescrizioneSede
,ISNULL(ComunicApertura.IdTemplate,1) MailAperturaRapporto
,ISNULL(D_TipoAttivitaPianificataIncarico.Descrizione,'NS') APScaduta
,ISNULL(CategoriaDocumenti.Descrizione1,'Altro') DescrizioneCategoriaDocumenti
,MAX(CASE SlaLavorazione.codtiposlalavorazione
	WHEN 1 THEN DATEADD(HOUR,SlaLavorazione.TempoSlaLavorazione,DataUltimaTransizione)
	WHEN 2 THEN DATEADD(DAY,SlaLavorazione.TempoSlaLavorazione,DataUltimaTransizione)
	ELSE 0
	END) AS DataFineSLALavorazione

/* LF 31/05/2018 */
,ko.IdIncarico IdIncaricoKO
,ko.TipoIncaricoKO
,ko.NomeControllo
,ko.GiudizioControllo
,ko.NoteControllo

--,'Dossier' AS TipoOperazione

FROM dbo.T_Incarico WITH (NOLOCK)
LEFT JOIN dbo.T_Documento WITH (NOLOCK) ON T_Documento.IdIncarico = T_Incarico.IdIncarico AND FlagPresenzaInFileSystem = 1 and FlagScaduto = 0
LEFT JOIN D_Documento WITH (NOLOCK) on D_Documento.Codice = T_Documento.Tipo_Documento
LEFT JOIN dbo.D_TipoIncarico WITH (NOLOCK) ON dbo.D_TipoIncarico.Codice = CodTipoIncarico
LEFT JOIN dbo.T_DatoAggiuntivo WITH (NOLOCK) on T_DatoAggiuntivo.IdIncarico = T_Incarico.IdIncarico AND CodTipoDatoAggiuntivo = 643 AND T_DatoAggiuntivo.FlagAttivo = 1--iban 
LEFT JOIN T_R_Incarico_Operatore WITH (NOLOCK) on T_R_Incarico_Operatore.IdIncarico = T_Incarico.IdIncarico
LEFT JOIN dbo.S_Operatore WITH (NOLOCK) on S_Operatore.IdOperatore = T_R_Incarico_Operatore.IdOperatore AND S_Operatore.FlagAttivo = 1
LEFT JOIN dbo.D_SedeOperatore WITH (NOLOCK) ON CodSede = D_SedeOperatore.Codice
LEFT JOIN dbo.D_AttributoIncarico WITH (NOLOCK) ON D_AttributoIncarico.Codice = CodAttributoIncarico
LEFT JOIN R_Cliente_TipoIncarico_MacroStatoWorkFlow WITH (NOLOCK)
ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodCliente
AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodTipoIncarico
AND T_Incarico.CodStatoWorkflowIncarico = R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico

LEFT JOIN D_MacroStatoWorkflowIncarico WITH (NOLOCK)
ON D_MacroStatoWorkflowIncarico.Codice=CodMacroStatoWorkflowIncarico

LEFT JOIN D_StatoWorkflowIncarico WITH (NOLOCK)
ON D_StatoWorkflowIncarico.Codice=R_Cliente_TipoIncarico_MacroStatoWorkFlow.CodStatoWorkflowIncarico

--comunicazione finale della documentazione
LEFT JOIN T_Comunicazione ComunicApertura WITH (NOLOCK) ON ComunicApertura.IdIncarico = T_Incarico.IdIncarico AND IdTemplate IN (8714,8473,8835) --Avvenuta apertura del rapporto Cliente
LEFT JOIN T_AttivitaPianificataIncarico WITH (NOLOCK) ON T_AttivitaPianificataIncarico.IdIncarico = T_Incarico.IdIncarico AND T_AttivitaPianificataIncarico.FlagScadenzaNotificata = 1 AND CodStatoAttivita = 1 --aperta
LEFT JOIN D_TipoAttivitaPianificataIncarico WITH (NOLOCK) ON CodTipoAttivitaPianificata = D_TipoAttivitaPianificataIncarico.Codice

LEFT JOIN rs.R_Cliente_TipoIncarico_StatoWorkFlow_SLALavorazione SlaLavorazione WITH (NOLOCK) ON 
	SlaLavorazione.codcliente = T_Incarico.CodCliente 
	AND (SlaLavorazione.codtipoincarico  = T_Incarico.CodTipoIncarico OR SlaLavorazione.CodTipoIncarico is NULL)
	AND (SlaLavorazione.codstatoworkflow = T_Incarico.CodStatoWorkflowIncarico OR  SlaLavorazione.codstatoworkflow is NULL)
	AND (SlaLavorazione.codattributoincarico = T_Incarico.CodAttributoIncarico OR  SlaLavorazione.codattributoincarico is NULL)
	AND (SlaLavorazione.CodOggettoControlliDeterminante = D_documento.CodOggettoControlli OR  SlaLavorazione.CodOggettoControlliDeterminante is NULL)
	AND (SlaLavorazione.CodTipoDocumentoDeterminante = T_Documento.Tipo_Documento OR  SlaLavorazione.CodTipoDocumentoDeterminante is NULL)


LEFT JOIN (SELECT T_Documento.IdIncarico,D_OggettoControlli.Descrizione, D_OggettoControlli.Codice
,CASE WHEN CodOggettoControlli = 45 THEN D_Documento.Descrizione else D_OggettoControlli.Descrizione END AS Descrizione1
			FROM T_Documento WITH (NOLOCK)
			JOIN T_Incarico WITH (NOLOCK) ON T_Documento.IdIncarico = T_Incarico.IdIncarico
			JOIN R_Cliente_TipoIncarico_Area WITH (NOLOCK) on T_Incarico.CodCliente = R_Cliente_TipoIncarico_Area.CodCliente
			AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_Area.CodTipoIncarico
			AND T_Incarico.CodArea = R_Cliente_TipoIncarico_Area.CodArea
			AND R_Cliente_TipoIncarico_Area.CodArea = 8 
			AND R_Cliente_TipoIncarico_Area.CodCliente = 48
			JOIN D_Documento WITH (NOLOCK) on D_Documento.Codice = Tipo_Documento
			JOIN D_OggettoControlli WITH (NOLOCK) ON D_OggettoControlli.Codice = CodOggettoControlli
			WHERE CodOggettoControlli IN (
											44	--Che Banca - Apertura CC
											,45	--Che Banca - Trasferimento Titoli
											,46	--Che Banca - Portabilità
											,48	--Che Banca - Apertura Dossier
											,50	--Che Banca - Predisposizione Contratto
											,58	--Che Banca - Carta di credito
											)
			AND FlagPresenzaInFileSystem = 1 AND FlagScaduto = 0
			GROUP BY T_Documento.IdIncarico,D_OggettoControlli.Descrizione, D_OggettoControlli.Codice, CASE WHEN CodOggettoControlli = 45 THEN D_Documento.Descrizione else D_OggettoControlli.Descrizione END
			) CategoriaDocumenti ON CategoriaDocumenti.IdIncarico = T_Incarico.IdIncarico	

JOIN R_Cliente_TipoIncarico_Area WITH (NOLOCK) on T_Incarico.CodCliente = R_Cliente_TipoIncarico_Area.CodCliente
	AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_Area.CodTipoIncarico
	AND R_Cliente_TipoIncarico_Area.CodArea = 8 
	AND R_Cliente_TipoIncarico_Area.CodCliente = 48
CROSS APPLY rs.IntervalloLavorativoPerCliente_CLC_day(48,T_incarico.datacreazione,GETDATE())

/* LF 31/05/2018 */
LEFT JOIN (SELECT
	T_Incarico.IdIncarico,
	T_Incarico.CodTipoIncarico,
	D_TipoIncarico.Descrizione TipoIncaricoKO,
	D_GiudizioControllo.Descrizione GiudizioControllo,
	S_Controllo.Descrizione NomeControllo,
	Note NoteControllo
FROM T_Incarico
JOIN T_R_Incarico_Controllo
	ON T_Incarico.IdIncarico = T_R_Incarico_Controllo.IdIncarico
JOIN T_Controllo
	ON T_R_Incarico_Controllo.IdControllo = T_Controllo.IdControllo
LEFT JOIN S_Controllo
	ON S_Controllo.IdControllo = IdTipoControllo
JOIN R_Cliente_TipoIncarico_Area
	ON T_Incarico.CodCliente = R_Cliente_TipoIncarico_Area.CodCliente
	AND T_Incarico.CodTipoIncarico = R_Cliente_TipoIncarico_Area.CodTipoIncarico
	AND T_Incarico.CodArea = R_Cliente_TipoIncarico_Area.CodArea
	AND R_Cliente_TipoIncarico_Area.CodArea = 8
JOIN D_GiudizioControllo
	ON D_GiudizioControllo.Codice = CodGiudizioControllo
JOIN D_TipoIncarico
	ON D_TipoIncarico.Codice = T_Incarico.CodTipoIncarico
WHERE T_Incarico.CodCliente = 48
AND CodStatoWorkflowIncarico IN ( 14275,14300)

AND NomeStoredProcedure IS NOT NULL
AND CodGiudizioControllo = 4
AND T_Incarico.CodArea = 8
--AND DataUltimaTransizione >= '20180501'
										) ko ON T_Incarico.IdIncarico = ko.IdIncarico
/*	  */

WHERE FlagArchiviato = 0
AND T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 48

--AND S_Operatore.IdOperatore = 12502

--AND T_Incarico.CodStatoWorkflowIncarico = 14531
--AND T_Incarico.DataCreazione >= DATEADD(MONTH,-4,GETDATE())
--AND T_Incarico.IdIncarico = 9265065

--AND CodStatoWorkflowIncarico = 14275
--in (14274 --conto titoli aperto
--)

--AND T_Incarico.DataCreazione >= cast(cast(getdate() as varchar(12)) as datetime)-1
--AND T_Incarico.IdIncarico = 10007881

--and T_incarico.idincarico in (10018294
--,10018295
--,10018296
--,10018298
--,10018299
--,10018300
--,10018301
--,10018302
--,10018303)


--AND T_Incarico.IdIncarico = 10396459

GROUP BY dbo.T_Incarico.IdIncarico
,CodMacroStatoWorkflowIncarico
,T_Incarico.CodTipoIncarico
,dbo.D_TipoIncarico.Descrizione
,T_Incarico.CodStatoWorkflowIncarico
,D_StatoWorkflowIncarico.Descrizione
,T_DatoAggiuntivo.Testo --iban
,ISNULL(S_Operatore.IdOperatore, 1)
,ISNULL(S_Operatore.Etichetta, 'NessunOperatore')
,CodSede
,ISNULL(D_SedeOperatore.Descrizione, 'NessunaSede')
,T_Incarico.CodAttributoIncarico
,D_AttributoIncarico.Descrizione
,dbo.T_Incarico.DataCreazione
,DataUltimaTransizione
,D_MacroStatoWorkflowIncarico.Descrizione +' - '+D_StatoWorkflowIncarico.Descrizione  + ' - ' +ISNULL(D_AttributoIncarico.Descrizione,'')
,ISNULL(ComunicApertura.IdTemplate,1)
,ISNULL(D_TipoAttivitaPianificataIncarico.Descrizione,'NS')
--,CASE SlaLavorazione.codtiposlalavorazione
--	WHEN 1 THEN DATEADD(HOUR,SlaLavorazione.TempoSlaLavorazione,DataUltimaTransizione)
--	WHEN 2 THEN DATEADD(DAY,SlaLavorazione.TempoSlaLavorazione,DataUltimaTransizione)
--	ELSE 0
--	END

	,ISNULL(CategoriaDocumenti.Descrizione1,'Altro') 
	,IIF(IntervalloLavorativo = 0, IntervalloLavorativo, IntervalloLavorativo/60)

/* LF 31/05/2018 */
,ko.IdIncarico
,ko.TipoIncaricoKO
,ko.NomeControllo
,ko.GiudizioControllo
,ko.NoteControllo
/*	  */

	--SELECT * FROM [VP-BTSQL02].clc.rs.R_Cliente_TipoIncarico_StatoWorkFlow_SLALavorazione


	--UNION ALL


--	SELECT 10018999,	14,	61392717,	'2018-03-30 16:27:52.897'	,'2018-04-03 16:02:10.890',	331,	'Apertura Conto e Dossier (Se presente) - Cartaceo',	14275,	'Gestita - Lavorazioni effettuate - ' ,	NULL	,NULL	,'IT 48 O 03058 01604 100571837509',	'Lodo V.'	,1,	'Ca',	1,	'NS',	'Che Banca - Apertura CC',	'2018-04-02 16:02:10.890'

GO


