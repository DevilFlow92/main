WITH dataset AS (
SELECT ti.IdIncarico
,movimenti.Importo SommaImportoMovimentiAssociati
,SUM(ISNULL(T_OperazioneAzimut.Importo,0)) SommaImportoFondi
,COUNT(IdOperazioneAzimut) NumerositaFondi
,IIF(CodTipoRaccomandazione IN (1,2,3) ,1,0) FlagMax
--,CodTipoRaccomandazione
--,D_TipoRaccomandazione.Descrizione
FROM T_Incarico ti
JOIN T_OperazioneAzimut ON ti.IdIncarico = T_OperazioneAzimut.IdIncarico
AND FlagAttivo = 1
JOIN T_DatiAggiuntiviIncaricoAzimut ON ti.IdIncarico = T_DatiAggiuntiviIncaricoAzimut.IdIncarico

CROSS APPLY (
			SELECT SUM(T_MovimentoContoBancario.Importo) Importo, T_R_Incarico_MovimentoContoBancario.IdIncarico
			FROM T_R_Incarico_MovimentoContoBancario
			JOIN T_MovimentoContoBancario ON T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
			WHERE T_R_Incarico_MovimentoContoBancario.IdIncarico = ti.IdIncarico
			GROUP BY T_R_Incarico_MovimentoContoBancario.IdIncarico
) movimenti

WHERE ti.CodCliente = 23
AND ti.CodTipoIncarico IN (83,540,553)
AND ti.DataCreazione >= '20201126'
--AND ti.IdIncarico = 16464772 
GROUP BY ti.IdIncarico, movimenti.Importo, IIF(CodTipoRaccomandazione IN (1,2,3) ,1,0) 

) 
SELECT IdIncarico
		,CAST(format(SommaImportoMovimentiAssociati,'N','de-de') AS VARCHAR(100)) ImportoMovimentiAssociati
		,CAST(FORMAT(SommaImportoFondi,'N','de-de') AS VARCHAR(100)) SommaImportoFondi
		,NumerositaFondi
		,FlagMax
		,CASE WHEN SommaImportoFondi != SommaImportoMovimentiAssociati THEN 1 ELSE 0 END FlagDifferenzaImporti
		,CASE WHEN SommaImportoFondi = 0 THEN 'Importo fondi a zero'
			WHEN FlagMax = 1 then 'Max Fund / Max / Max Omnibus (stesso bonifico di importo consistente associato a n incarichi'
			WHEN SommaImportoMovimentiAssociati = SommaImportoFondi THEN ''
			ELSE 'Differenza di: ' + CAST(FORMAT(SommaImportoFondi - SommaImportoMovimentiAssociati,'N','de-de') AS VARCHAR(100))
			END AS NoteDifferenza
		FROM dataset


