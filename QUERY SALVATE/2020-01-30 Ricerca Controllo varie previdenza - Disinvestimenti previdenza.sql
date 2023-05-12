USE CLC
GO

SELECT
	T_Incarico.IdIncarico
	--,T_Incarico.DataCreazione
	--,T_Incarico.DataUltimaTransizione
	,ti2.IdIncarico IdIncaricoVarie
	--,ti2.DataCreazione DataCreazioneIncaricoVarie
	--,ti2.DataUltimaTransizione UltimaTransizioneIncaricoVarie
	--,tdoc.Documento_id
	--,tdoc.DataInserimento
	--,tdoc.Tipo_Documento
	--,T_Incarico.CodStatoWorkflowIncarico
	--,ti2.CodStatoWorkflowIncarico CodStato2
	--,ddoc.Descrizione
--, export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.*
,trip.IdPersona
FROM T_Incarico
--JOIN export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI ON T_Incarico.IdIncarico = export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI.idincarico

JOIN T_R_Incarico_Persona trip
	ON T_Incarico.IdIncarico = trip.IdIncarico AND trip.CodRuoloRichiedente = 11 

 JOIN T_R_Incarico_Persona trip2
	ON trip.IdPersona = trip2.IdPersona
	--AND trip.CodRuoloRichiedente = trip2.CodRuoloRichiedente

 JOIN T_Incarico ti2
	ON trip2.IdIncarico = ti2.IdIncarico
	AND ti2.CodCliente = 23
	AND ti2.CodArea = 8
	AND ti2.CodTipoIncarico IN (178) --Varie Previdenza
	AND T_Incarico.IdIncarico <> ti2.IdIncarico

--LEFT JOIN T_DatoAggiuntivo tda1 ON T_Incarico.IdIncarico = tda1.IdIncarico
--AND tda1.FlagAttivo = 1
--AND tda1.CodTipoDatoAggiuntivo = 1352
--AND tda1.Testo = 'Trasferimento vs altro Fondo'

--LEFT JOIN T_DatoAggiuntivo tda2 ON ti2.IdIncarico = tda2.IdIncarico
--AND tda1.CodTipoDatoAggiuntivo = tda2.CodTipoDatoAggiuntivo
--AND tda1.Testo = tda2.Testo
--AND ti2.IdIncarico <> T_Incarico.IdIncarico

--JOIN T_Documento tdoc
--	ON ti2.IdIncarico = tdoc.IdIncarico
--	AND tdoc.FlagPresenzaInFileSystem = 1
--	AND tdoc.FlagScaduto = 0
--	AND tdoc.Tipo_Documento IN ( 256880,6047,102)

--JOIN D_Documento ddoc
--	ON ddoc.Codice = tdoc.Tipo_Documento

WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 23
--AND T_Incarico.CodTipoIncarico = 173 --Disinvestimenti Previdenza
--AND T_Incarico.IdIncarico = 13012453 
--AND ti2.IdIncarico IN (13963918  )
--AND T_Incarico.IdIncarico = 10077229 
--fare la delete
--10077229
AND T_Incarico.IdIncarico in (
13319010
,12984773
,13302015
,13590151
,13920552
,13208396
,12894586
,13081439
,13249557
,13104152
,13081431
,13081442
,14307959
,13081462
,13249614
,13215559
,13208388
,13201842
,13201850
,13249580
,13257471
,13237625
,13291668
,13237549
,13257451
)


