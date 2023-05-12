USE CLC
GO

DECLARE @DataDAL DATETIME = '20211027'
DECLARE @DataALEscluso DATETIME = '20211028'

;WITH v AS (

SELECT IdIncaricoMaster
	  ,DataCreazioneIncaricoMaster
	  ,DataUltimaTransizioneIncaricoMaster
	  ,CodStatoWorkflowIncaricoMaster
	  ,StatoWorkflowIncaricoMaster
	  ,CodiceClienteDeCuius
	  ,DeCuius
	  ,CodiceCF
	  ,CF 
FROM rs.v_CESAM_AZ_Successioni_SLA
--WHERE IdIncaricoMaster IN ( 13058935
--)
)

SELECT v.IdIncaricoMaster
	  ,v.DataCreazioneIncaricoMaster
	  ,v.DataUltimaTransizioneIncaricoMaster
	  ,v.CodStatoWorkflowIncaricoMaster
	  ,v.StatoWorkflowIncaricoMaster
	  ,v.CodiceClienteDeCuius
	  ,v.DeCuius
	  ,v.CodiceCF
	  ,v.CF

		,SLA_Incarico.IdIncaricoFase
		,SLA_Incarico.CodTipoIncaricoFase
		,SLA_Incarico.DataCreazioneIncaricoFase
		,SLA_Incarico.DataUltimaTransizioneIncaricoFase
		,SLA_Incarico.CodStatoWorkflowIncaricoFase
		,SLA_Incarico.TipoIncaricoFase
		,SLA_Incarico.StatoWorkflowIncaricoFase
		,SLA_Incarico.Fase
		,SLA_Incarico.DataInizioLavorazione
		,SLA_Incarico.DataFineLavorazione
		,SLA_Incarico.ISFaseTerminata
		
	   ,SLA_Incarico.GiorniLavorativiSoglia AS      GiorniFaseSoglia
	   ,SLA_Incarico.GiorniLavorativiTrascorsi AS    GiorniFaseTrascorsi

	   ,SLA_Incarico.EsitoSLA
	   ,SLA_Incarico.EsitoSLAIncaricoMaster


FROM   v

CROSS APPLY rs.f_CESAM_AZ_Successioni_RilevaSLA_Incarico(v.IdIncaricoMaster, '20210920', @DataALEscluso,NULL) SLA_Incarico

WHERE DataFineLavorazione >= @DataDAL AND DataFineLavorazione < @DataALEscluso


