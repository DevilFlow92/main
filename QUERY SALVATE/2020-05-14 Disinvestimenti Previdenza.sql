USE clc

GO

SELECT 	IdIncarico 
		,ISNULL(TipoOperazione,'Dato Assente') [Tipo Operazione]
		,convert(varchar,DataRichiesta,105) [Data Richiesta]
		,StatoRichiesta [Stato Richiesta]
		,CONVERT(varchar,DataLiquidazione,105) [Data Liquidazione]	

		,isnull(ChiaveCliente			  ,'')		[Codice Cliente FEND]
		,isnull(CodiceFiscaleIntestatario ,'')		[Codice Fiscale]
		,isnull(Cliente					  ,'')		[Anagrafica]
		,isnull(CodicePromotore			  ,'')		[Codice Consulente]
		,isnull(Promotore				  ,'')		[Anagrafica Consulente]
		,isnull(FirmaConsulente			  ,'')		[Firma Consulente]

		,CompartoCrescita [Comparto Crescita]
		,CompartoEquilibrato      [Comparto Equilibrato]
		,CompartoGarantito		  [Comparto Garantito]
		,CompartoObbligazionario  [Comparto Obbligazionario]
		,TotaleComparti		[Totale Comparti]		

		,IIF(TipoOperazione LIKE 'trasf%fondo%' and	Controparte IS NULL ,'Dato Assente', ISNULL(Controparte,'')) [Controparte]
		,IIF(TipoOperazione LIKE 'trasf%fondo%' AND NumeroCovip IS NULL ,'Dato Assente', ISNULL(CAST(NumeroCovip AS VARCHAR(10)),'')) [Numero Covip]

		,CASE WHEN TipoOperazione is NULL THEN 1
			WHEN TipoOperazione LIKE 'trasf%fondo' AND Controparte IS NULL then 1
			WHEN TipoOperazione LIKE 'trasf%fondo' AND NumeroCovip is NULL THEN 1
			END  [Check]
		
FROM rs.v_CESAM_AZ_Previdenza_Disinvestimenti
WHERE DataRichiesta >= '20200301'