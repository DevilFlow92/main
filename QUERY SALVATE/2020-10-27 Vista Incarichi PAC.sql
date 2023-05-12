USE CLC
GO


CREATE VIEW rs.v_CESAM_AZ_Incarichi_PAC AS 

SELECT ti.IdIncarico
,Mandato.Testo NumeroMandato

FROM T_Incarico ti
JOIN T_DatoAggiuntivo Mandato ON ti.IdIncarico = Mandato.IdIncarico
AND Mandato.FlagAttivo = 1
AND Mandato.CodTipoDatoAggiuntivo = 230

WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND ti.CodTipoIncarico = 693

GO



SELECT IdIncarico
,NumeroMandato
FROM rs.v_CESAM_AZ_Incarichi_PAC


