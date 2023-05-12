USE CLC
GO

SELECT DISTINCT IdIncarico FROM T_Incarico

WHERE CodArea = 8

AND CodTipoIncarico iN (321,322, 323,324)

AND CodStatoWorkflowIncarico = 6603

AND DataCreazione >= '20180706'

EXCEPT

SELECT DISTINCT T_Incarico.IdIncarico FROM T_DatiAggiuntiviIncaricoAzimut
JOIN T_Incarico on T_DatiAggiuntiviIncaricoAzimut.IdIncarico = T_Incarico.IdIncarico
WHERE (IdPersonaEsecutore IS NOT NULL or IdPersonaBeneficiario is NOT NULL)

