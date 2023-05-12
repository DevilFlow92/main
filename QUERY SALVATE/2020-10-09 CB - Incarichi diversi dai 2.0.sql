USE CLC
GO

--Gestione invio pacchetto
SELECT IdIncarico FROM T_Incarico
WHERE CodArea = 8
AND CodCliente = 48
AND DataCreazione >= '20200901' AND DataCreazione < '20201001'
AND CodTipoIncarico = 593	--Generazione kit Persone Fisiche


--Trasferimento Servizi Pagamento
SELECT IdIncarico FROM T_Incarico
WHERE CodArea = 8
AND CodCliente = 48
AND DataCreazione >= '20200901' AND DataCreazione < '20201001'
AND CodTipoIncarico = 564	--Trasferimento servizi pagamento FEA

--Web Collaboration
SELECT IdIncarico FROM T_Incarico
WHERE CodArea = 8
AND CodCliente = 48
AND DataCreazione >= '20200901' AND DataCreazione < '20201001'
AND CodTipoIncarico = 359	


--Small Business OK
SELECT T_Incarico.IdIncarico--, T_Incarico.CodStatoWorkflowIncarico, d.StatoWorkflowIncarico
FROM T_Incarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON T_Incarico.IdIncarico = d.IdIncarico
WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 48
AND T_Incarico.CodTipoIncarico = 474
AND T_Incarico.DataCreazione >= '20200901' AND T_Incarico.DataCreazione < '20201001'
AND T_Incarico.CodStatoWorkflowIncarico NOT IN ( 15446  --Archiviata - Oggetto sociale non ammissibile
,15445	--Cerved negativa
)

--Small Business OK / KO
SELECT T_Incarico.IdIncarico--, T_Incarico.CodStatoWorkflowIncarico, d.StatoWorkflowIncarico
FROM T_Incarico
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON T_Incarico.IdIncarico = d.IdIncarico
WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 48
AND T_Incarico.CodTipoIncarico = -- 474 --Generazione kit Small Business
523 --Generazione Kit Small Business Filiali

AND T_Incarico.DataCreazione >= '20200901' AND T_Incarico.DataCreazione < '20201001'
AND T_Incarico.CodStatoWorkflowIncarico = --15446  --Archiviata - Oggetto sociale non ammissibile
15445	--Cerved negativa
--)


