--ALTER VIEW rs.v_CESAM_AZ_Incarichi_AnagraficheClienti_RIC_BNP AS 

 WITH base AS (
SELECT 
0 isfromsimula
,T_Incarico.IdIncarico
,LEFT(E_ProdottoAzimut.Descrizione,iif(CHARINDEX('-',E_ProdottoAzimut.Descrizione)=0,14,CHARINDEX('-',E_ProdottoAzimut.Descrizione)-2)) Prodotto
,T_MovimentoContoBancario.IdMovimentoContoBancario
,dbo.T_MovimentoContoBancario.Importo importomovimentocontobancario
,T_MovimentoContoBancario.FlagRiconciliato
,T_Incarico.CodTipoIncarico
,T_Incarico.DataUltimaTransizione
,v_CESAM_Anagrafica_Cliente_Promotore.ProgressivoPersona
,v_CESAM_Anagrafica_Cliente_Promotore.CodTipoPersona
,CASE v_CESAM_Anagrafica_Cliente_Promotore.CodTipoPersona WHEN 1 THEN 
	v_CESAM_Anagrafica_Cliente_Promotore.CognomeIntestatario WHEN 2 THEN
	v_CESAM_Anagrafica_Cliente_Promotore.RagioneSocialeIntestatario end AS cognome
,v_CESAM_Anagrafica_Cliente_Promotore.RagioneSocialeIntestatario ragionesociale
,ISNULL(v_CESAM_Anagrafica_Cliente_Promotore.NomeIntestatario,'') nome
,SUM(ISNULL(T_OperazioneAzimut.Importo,0)) Importo
,ISNULL(dbo.T_Mandato.NumeroMandato,T_DatoAggiuntivo.Testo) NumeroMandato
,REPLACE(LTRIM(REPLACE(ISNULL(v_CESAM_Anagrafica_Cliente_Promotore.AnMand,T_DatoAggiuntivo.Testo), '0', ' ')), ' ', '0') NmandatoNoZero
,T_Incarico.CodStatoWorkflowIncarico
, CASE WHEN ( T_Incarico.CodStatoWorkflowIncarico = 6605 --attesa ricezione bonifico
	AND CAST(CAST(transizione.DataTransizione AS VARCHAR(12)) AS DATETIME) 
	<= CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME) 
	--(CASE when data.GiornoSettimana = 1 then CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME)-2 --LS 18062020 - AND transizione.DataTransizione <=
	--ELSE CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME) 
	--END)
	) THEN 1
	WHEN dbo.T_Incarico.CodStatoWorkflowIncarico = 8570 --acquisita
	THEN 1
	--WHEN CodStatoWorkflowIncarico = 820 AND DataUltimaTransizione >= CONVERT(DATE,GETDATE()) THEN 1
	ELSE 0 END AS StatusWF

,rs.CheckOnboardingAzimut(T_Incarico.IdIncarico) EsitoOnBoarding	

 FROM T_Incarico
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore ON T_Incarico.IdIncarico = rs.v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico
LEFT JOIN dbo.T_R_Incarico_Mandato ON dbo.T_Incarico.IdIncarico = dbo.T_R_Incarico_Mandato.IdIncarico and dbo.T_R_Incarico_Mandato.Progressivo = 1
LEFT JOIN dbo.T_Mandato ON dbo.T_R_Incarico_Mandato.IdMandato = dbo.T_Mandato.IdMandato
 JOIN T_OperazioneAzimut on T_Incarico.IdIncarico = T_OperazioneAzimut.IdIncarico --risalire agli importi
			--AND (T_R_Incarico_Mandato.IdMandato = T_OperazioneAzimut.IdMandato OR T_OperazioneAzimut.IdMandato is NULL)
			AND dbo.T_OperazioneAzimut.FlagAttivo = 1
LEFT JOIN E_ProdottoAzimut ON T_OperazioneAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut
LEFT JOIN T_R_Incarico_MovimentoContoBancario ON T_Incarico.IdIncarico = T_R_Incarico_MovimentoContoBancario.IdIncarico
LEFT JOIN T_MovimentoContoBancario ON T_R_Incarico_MovimentoContoBancario.IdMovimentoContoBancario = T_MovimentoContoBancario.IdMovimentoContoBancario
LEFT JOIN (

	SELECT L_WorkflowIncarico.IdIncarico, MAX(L_WorkflowIncarico.DataTransizione) DataTransizione FROM L_WorkflowIncarico
	WHERE L_WorkflowIncarico.CodStatoWorkflowIncaricoDestinazione = 6605 --in attesa ricezione bonifico
	GROUP BY L_WorkflowIncarico.IdIncarico
) transizione ON transizione.IdIncarico = T_Incarico.IdIncarico

LEFT JOIN rs.S_Data data ON data.ChiaveData = CONVERT(VARCHAR(10), GETDATE(),112)
LEFT JOIN T_DatoAggiuntivo ON T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico AND T_DatoAggiuntivo.CodTipoDatoAggiuntivo = 230 --numeromandato
AND dbo.T_DatoAggiuntivo.FlagAttivo = 1



--/*
WHERE T_Incarico.DataUltimaTransizione >= DATEADD(DAY,-50,GETDATE())
AND T_Incarico.CodCliente = 23
AND T_Incarico.CodArea = 8 
AND T_Incarico.CodTipoIncarico IN( 83,
540, --sottoscrizioni lux zenith
553 --aggiuntivi lux zenith
)
AND (ISNULL(T_MovimentoContoBancario.FlagRiconciliato,0) = 0)

AND ( T_Incarico.CodStatoWorkflowIncarico  IN (
6605		--Attesa Ricezione Bonifico
,8570		--In Gestione Acquisita
--,6560		--Sospesa Regolarizzata
,14447		--In Gestione - Verifica Operatore
,20924		--In Gestione - In Attesa Prelievo CDL
,20925		--In Gestione - Prelievo CDL Richiesto

 ) 

 --OR (CodStatoWorkflowIncarico = 820 AND DataUltimaTransizione >= CONVERT(DATE,getdate()))
 )
	
--*/
 
--where  dbo.T_Incarico.IdIncarico IN (16729658)

GROUP by T_Incarico.IdIncarico
,LEFT(E_ProdottoAzimut.Descrizione,iif(CHARINDEX('-',E_ProdottoAzimut.Descrizione)=0,14,CHARINDEX('-',E_ProdottoAzimut.Descrizione)-2)) 
,T_MovimentoContoBancario.IdMovimentoContoBancario
,dbo.T_MovimentoContoBancario.Importo
,T_MovimentoContoBancario.FlagRiconciliato
,T_Incarico.CodTipoIncarico
,T_Incarico.DataUltimaTransizione
,v_CESAM_Anagrafica_Cliente_Promotore.ProgressivoPersona
,v_CESAM_Anagrafica_Cliente_Promotore.CodTipoPersona
,CASE v_CESAM_Anagrafica_Cliente_Promotore.CodTipoPersona WHEN 1 THEN 
	v_CESAM_Anagrafica_Cliente_Promotore.CognomeIntestatario WHEN 2 THEN
	v_CESAM_Anagrafica_Cliente_Promotore.RagioneSocialeIntestatario end  
,v_CESAM_Anagrafica_Cliente_Promotore.RagioneSocialeIntestatario 
,v_CESAM_Anagrafica_Cliente_Promotore.NomeIntestatario 

,ISNULL(dbo.T_Mandato.NumeroMandato,T_DatoAggiuntivo.Testo)
,REPLACE(LTRIM(REPLACE(ISNULL(v_CESAM_Anagrafica_Cliente_Promotore.AnMand,T_DatoAggiuntivo.Testo), '0', ' ')), ' ', '0') 
,T_Incarico.CodStatoWorkflowIncarico
,  CASE WHEN ( T_Incarico.CodStatoWorkflowIncarico = 6605 --attesa ricezione bonifico
	AND CAST(CAST(transizione.DataTransizione AS VARCHAR(12)) AS DATETIME) <= 
	CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME) 
	--(CASE when data.GiornoSettimana = 1 then CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME)-2
	--ELSE CAST(CAST(GETDATE() AS VARCHAR(12)) AS DATETIME) 
	--END)
	) THEN 1
	WHEN dbo.T_Incarico.CodStatoWorkflowIncarico = 8570 --acquisita
	THEN 1
    --WHEN CodStatoWorkflowIncarico = 820 AND DataUltimaTransizione >= CONVERT(DATE,GETDATE()) THEN 1

	ELSE 0 END
	,rs.CheckOnboardingAzimut(T_Incarico.IdIncarico)
)
, base1 as (
select 	base.IdIncarico,
        base.Prodotto,
        base.IdMovimentoContoBancario,
		base.importomovimentocontobancario,
		base.CodTipoIncarico,
		base.DataUltimaTransizione,
		base.ProgressivoPersona,
		base.CodTipoPersona,
		--REPLACE(base.cognome,'''','') cognome,
		--IIF(PatIndex('%_''_%', base.cognome) != 0,REPLACE(base.cognome,SUBSTRING(base.cognome,PatIndex('%_''_%', base.cognome)+1,1),' '),REPLACE(base.cognome,'''','')) cognome,
		base.cognome,
		base.RagioneSociale,
		base.Nome,
		base.Importo,
		base.NumeroMandato,
		base.StatusWF,
		base.CodStatoWorkflowIncarico,
		base.NmandatoNoZero,
		
SUM(Importo)OVER(PARTITION BY base.cognome, base.nome,base.Prodotto) SommaPerCognomeNome
		from base 
WHERE base.ProgressivoPersona IS NOT NULL
AND EsitoOnBoarding = 1

--AND IdIncarico = 15882384
)

, base2 AS(
SELECT 	base1.IdIncarico,
		base1.Prodotto,
		base1.IdMovimentoContoBancario,
		base1.importomovimentocontobancario,
		CASE WHEN base1.importomovimentocontobancario = base1.Importo
			OR base1.importomovimentocontobancario = base1.SommaPerCognomeNome
			THEN 1 ELSE 0 END AS NonRiconciliatoMaAssociatoCorrettamente,
		base1.CodTipoIncarico,
		base1.DataUltimaTransizione,
		base1.ProgressivoPersona,
		base1.CodTipoPersona,
		base1.cognome,
		base1.ragionesociale,
		base1.nome,
		base1.Importo,
		base1.NumeroMandato,
		base1.StatusWF,
		base1.CodStatoWorkflowIncarico,
		base1.NmandatoNoZero,
		base1.SommaPerCognomeNome	
		FROM base1	
)

SELECT 	base2.IdIncarico,
		base2.Prodotto,
		base2.IdMovimentoContoBancario,
		--NULL IdMovimentoContoBancario,
		base2.importomovimentocontobancario,
		base2.NonRiconciliatoMaAssociatoCorrettamente,
		base2.CodTipoIncarico,
		base2.DataUltimaTransizione,
		base2.ProgressivoPersona,
		base2.CodTipoPersona,
		base2.cognome,
		base2.ragionesociale,
		base2.nome,
		base2.Importo,
		base2.NumeroMandato,
		base2.StatusWF,
		base2.CodStatoWorkflowIncarico,
		base2.NmandatoNoZero,
		base2.SommaPerCognomeNome 
		
	FROM base2
WHERE base2.NonRiconciliatoMaAssociatoCorrettamente = 0

UNION all

SELECT  maxfund.idincarico
, Prodotto
,  IdMovimentoContoBancario
, NULL importomovimentocontobancario
, 0 NonRiconciliatoMaAssociatoCorrettamente
, codtipoincarico
,maxfund.DataUltimaTransizione
,maxfund.progressivopersona
,maxfund.codtipopersona
,maxfund.parametririconciliazione_stringacontabile cognome
		,maxfund.parametririconciliazione_stringacontabile ragionesociale,
		maxfund.parametririconciliazione_stringacontabile nome,
		maxfund.Importo,
		maxfund.parametririconciliazione_stringacontabile NumeroMandato,
		1 StatusWF,
		maxfund.CodStatoWorkflowIncarico,
		maxfund.parametririconciliazione_stringacontabile NmandatoNoZero,
		maxfund.SommaPerCognomeNome
FROM rs.v_CESAM_AZ_FondiAzimut_MaxFund_Operazioni_DaRiconciliare maxfund
WHERE maxfund.IdMovimentoContoBancario is NULL

GO