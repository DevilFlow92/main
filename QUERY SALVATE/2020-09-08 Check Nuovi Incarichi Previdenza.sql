SELECT * FROM T_Incarico ti
WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico IN(167
,572,
178
)
AND ti.DataCreazione >= '20200908 09:58'


SELECT * FROM T_Incarico ti
LEFT JOIN export.CESAM_AZ_Previdenza_FlussoGiornaliero_Documenti_AZSustainableFuture t 
ON ti.IdIncarico = t.idincarico
WHERE ti.CodCliente = 23
AND ti.CodArea = 8
AND ti.CodTipoIncarico IN (655
,656
,657
,658
,659
,660
,661
)
AND T.documento_id IS NULL