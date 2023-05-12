USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_SospesiApertiAntiriciclaggio AS 

--DECLARE @DataDal DATETIME
--		,@DataAl DATETIME

--SET @DataDal = '2018-01-01'
--SET @DataAl = '2018-12-31'

SELECT ti.IdIncarico
		,ti.DataCreazione
		,ti.DataUltimaModifica
		,ti.CodTipoIncarico
		,descrizioni.TipoIncarico
		
		,anagrafica.CodicePromotore CodiceConsulente
		,IIF(anagrafica.CognomePromotore is NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore)
			+ ' ' + ISNULL(anagrafica.NomePromotore,'') Consulente
		--,anagrafica.DescrizioneCentroRaccolta CentroRaccolta
		--,anagrafica.DescrizioneAreaCentroRaccolta AreaCentroRaccolta
		--,anagrafica.DescrizioneSim  MacroAreaCentroRaccolta

		,anagrafica.ChiaveClienteIntestatario
		,IIF(anagrafica.CognomeIntestatario is NULL or anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomeIntestatario) 
			+ ' ' + ISNULL(anagrafica.NomeIntestatario,'') Intestatario
		,IIF(anagrafica.CodTipoPersona = 2,'Persona Giuridica','Persona Fisica') TipoPersona

		,descrizioni.DescrizioneMacroStatoWorkFlowIncarico MacroStatoWorkflow
		,descrizioni.DescrizioneStatoWorkflowIncarico StatoWorkflow
	
	
		,sospesi.ProgressivoSospeso
		,sospesi.CodTipoOperazione
		,sospesi.TipoOperazione
		,sospesi.CodTipoProdotto
		,sospesi.TipoProdotto
		,sospesi.CodStatoSospesoAttuale
		,sospesi.StatoSospesoAttuale
		,sospesi.IdSospeso
		--,sospesi.RelazioneMotivazioneSottomotivazioneModalita
		--,sospesi.CodTipoDoppioSospeso
		--,sospesi.TipoDoppioSospeso
		,sospesi.DataAperturaSospeso
		,sospesi.Progressivomotivazione
		,sospesi.Motivazione
		,sospesi.SottoMotivazione
		,sospesi.Modalita
		,sospesi.NotaMotivazione
		--,sospesi.IdOperatoreDoppioSospesoProgressivo

FROM T_Incarico ti 

JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico descrizioni ON ti.IdIncarico = descrizioni.IdIncarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON ti.IdIncarico = anagrafica.IdIncarico AND anagrafica.ProgressivoPersona = 1

JOIN rs.v_CESAM_AZ_SOSP_DoppiSospesiProgressivo_noFilter sospesi ON ti.IdIncarico = sospesi.IdIncarico


WHERE ti.CodArea = 8
AND ti.CodCliente = 23
AND (
	  sospesi.TipoOperazione LIKE '%antiriciclaggio%'
	  OR sospesi.TipoProdotto LIKE '%antiriciclaggio%'
	  OR sospesi.Motivazione LIKE '%antiriciclaggio%'
	  OR sospesi.SottoMotivazione LIKE '%antiriciclaggio%'
	  OR sospesi.NotaMotivazione LIKE '%antiriciclaggio%' OR sospesi.NotaMotivazione LIKE '%titolare effettivo%'
	  )

--AND ti.DataCreazione >= @DataDal AND ti.DataCreazione < DATEADD(DAY,1,@DataAl)

GO

SELECT
	IdIncarico
	,DataCreazione
	,DataUltimaModifica
	,CodTipoIncarico
	,TipoIncarico
	,CodiceConsulente
	,Consulente
	,ChiaveClienteIntestatario
	,Intestatario
	,TipoPersona
	,MacroStatoWorkflow
	,StatoWorkflow
	,ProgressivoSospeso
	,CodTipoOperazione
	,TipoOperazione
	,CodTipoProdotto
	,TipoProdotto
	,CodStatoSospesoAttuale
	,StatoSospesoAttuale
	,IdSospeso
	,DataAperturaSospeso
	,Progressivomotivazione
	,Motivazione
	,SottoMotivazione
	,Modalita
	,NotaMotivazione

FROM rs.v_CESAM_AZ_SospesiApertiAntiriciclaggio
WHERE DataCreazione >= '2019-01-01'
AND DataCreazione < '2020-01-01' --GETDATE(DAY,1,'2018-12-31')