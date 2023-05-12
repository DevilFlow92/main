USE clc

GO


SELECT ti.IdIncarico
,ti.CodTipoIncarico 
,D.TipoIncarico
,ti.DataCreazione
,ti.DataUltimaTransizione
,SimulaOK.Testo TestoNotaRilevataSimulaOK
,SimulaOK.DataInserimento DataSimulaOK

,InserimentoDispositiva.Testo TestoNotaRilevataTransferAgent
,InserimentoDispositiva.DataInserimento DataInserimentoDispositivaTransferAgent

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico

OUTER APPLY (
				SELECT  tni1.IdNotaIncarichi, tni1.Testo, tni1.DataInserimento
                FROM T_NotaIncarichi tni1
				JOIN T_R_Incarico_Nota trin1 ON tni1.IdNotaIncarichi = trin1.IdNota
				AND trin1.FlagAttiva = 1
				WHERE trin1.IdIncarico = ti.idincarico
				AND ( tni1.Testo LIKE '%simul%ok%'
						OR tni1.Testo LIKE '%ok%simul%'
					)


) SimulaOK

OUTER APPLY (

			SELECT tni2.IdNotaIncarichi, tni2.Testo, tni2.DataInserimento
            FROM T_NotaIncarichi tni2
			JOIN T_R_Incarico_Nota trin2 ON tni2.IdNotaIncarichi = trin2.IdNota
			AND trin2.FlagAttiva = 1
			WHERE trin2.IdIncarico = ti.idincarico
			AND (
					tni2.Testo LIKE '%eseguit%' 
					OR tni2.Testo LIKE '%switch%'
					OR tni2.Testo LIKE '%rimbors%'
					OR tni2.Testo LIKE '%quot%liber%'
			)
			AND tni2.DataInserimento > SimulaOK.DataInserimento

) InserimentoDispositiva


WHERE ti.CodCliente = 23
AND ti.CodArea = 8
AND ti.CodTipoIncarico IN ( 54,351,165)
AND ti.DataUltimaTransizione >= '20210208'
--AND SimulaOK.DataInserimento >= '20210202'
AND (SimulaOK.Testo IS NOT NULL OR InserimentoDispositiva.Testo IS NOT NULL)

--AND ti.IdIncarico = 13098537 

ORDER BY ti.IdIncarico, ti.CodTipoIncarico