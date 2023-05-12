USE clc

GO

SELECT * FROM D_ProfiloAccesso
WHERE Descrizione LIKE '%esterno%cesam%'

--1137	AZIMUT Esterno CESAM Assistenza

--Azimut esterno ALI Libera Impresa



SELECT
	*
FROM D_TipoIncarico
WHERE Codice IN (
512, 387)


SELECT CodProfiloAccesso, D_ProfiloAccesso.Descrizione ProfiloAccesso
	,CodPrivilegio, D_Privilegio.Descrizione Privilegio FROM R_ProfiloAccesso_Privilegio
JOIN D_Privilegio on CodPrivilegio = D_Privilegio.Codice
JOIN D_ProfiloAccesso on CodProfiloAccesso = D_ProfiloAccesso.Codice

WHERE CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT CodProfiloAccesso, D_ProfiloAccesso.Descrizione ProfiloAccesso
,codcliente,CodTipoIncarico, D_TipoIncarico.Descrizione TipoIncarico
 FROM R_ProfiloAccesso_AbilitazioneIncarico
JOIN D_TipoIncarico on Codice = CodTipoIncarico
JOIN D_ProfiloAccesso on CodProfiloAccesso = D_ProfiloAccesso.Codice
WHERE CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)



SELECT CodProfiloAccesso, D_ProfiloAccesso.Descrizione ProfiloAccesso
,CodCliente
,CodCategoriaComunicazione, D_CategoriaComunicazione.Descrizione CategoriaComunicazione

FROM R_ProfiloAccesso_CategoriaComunicazione
left JOIN D_ProfiloAccesso ON Codice = CodProfiloAccesso
left JOIN D_CategoriaComunicazione on CodCategoriaComunicazione = D_CategoriaComunicazione.Codice

WHERE 

CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT CodProfiloAccesso,D_ProfiloAccesso.Descrizione ProfiloAccesso
,CodCategoriaNotaIncarichi,D_CategoriaNotaIncarichi.Descrizione CategoriaNotaIncarichi
 FROM R_ProfiloAccesso_CategoriaNotaIncarichi 
JOIN D_ProfiloAccesso on CodProfiloAccesso = D_ProfiloAccesso.Codice
JOIN D_CategoriaNotaIncarichi on CodCategoriaNotaIncarichi = D_CategoriaNotaIncarichi.Codice
WHERE CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT * FROM R_Cliente_ProfiloAccesso_InserimentoIncarico
JOIN D_ProfiloAccesso on Codice = CodProfiloAccesso
WHERE CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT CodProfiloAccesso,D_ProfiloAccesso.Descrizione ProfiloAccesso
,CodProfiloAccessoVisualizzabile
--,v.Descrizione
FROM R_ProfiloAccesso_VisualizzazioneMailbox 
JOIN D_ProfiloAccesso on CodProfiloAccesso = Codice
--JOIN D_ProfiloAccesso v ON CodProfiloAccessoVisualizzabile = v.Codice
where CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT * FROM R_ProfiloAccesso_UfficioAttivitaPianificata 
JOIN D_ProfiloAccesso on Codice = CodProfiloAccesso
JOIN D_UfficioAttivitaPianificata on CodUfficioAttivitaPianificata = D_UfficioAttivitaPianificata.Codice
where CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT r.CodProfiloAccesso, D_ProfiloAccesso.Descrizione ProfiloAccesso
,r.CodStatoWorkflowIncarico, D_StatoWorkflowIncarico.Descrizione StatoWorkflowIncarico
,r.CodTipoWorkflow,D_TipoWorkflow.Descrizione TipoWorkflow, r.FlagAbilita


 FROM R_ProfiloAccesso_StatoWorkflowIncarico r
JOIN D_ProfiloAccesso on Codice = CodProfiloAccesso
LEFT JOIN D_TipoWorkflow ON CodTipoWorkflow = D_TipoWorkflow.Codice
LEFT JOIN D_StatoWorkflowIncarico ON r.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice

where CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
) AND r.CodStatoWorkflowIncarico IS NOT NULL

SELECT CodProfiloAccesso, D_ProfiloAccesso.Descrizione ProfiloAccesso
,CodAmbiente, D_Ambiente.Descrizione Ambiente, R_ProfiloAccesso_Ambiente_UrlAccesso.IdUrlAccesso, S_UrlAccesso.Descrizione, Url, NomeDns 

 FROM R_ProfiloAccesso_Ambiente_UrlAccesso 
JOIN D_ProfiloAccesso ON D_ProfiloAccesso.Codice = CodProfiloAccesso
JOIN D_Ambiente ON D_Ambiente.Codice = CodAmbiente
JOIN S_UrlAccesso on R_ProfiloAccesso_Ambiente_UrlAccesso.IdUrlAccesso = S_UrlAccesso.IdUrlAccesso
WHERE  CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


SELECT 	CodProfiloAccesso
,Descrizione ProfiloAccesso
		,IdTemplateComunicazione
		,FlagAbilita
 FROM R_ProfiloAccesso_TemplateComunicazione 
JOIN D_ProfiloAccesso ON Codice = CodProfiloAccesso
WHERE CodProfiloAccesso IN (822	--AZIMUT Esterno CESAM Visualizza Report
,842	--AZIMUT Esterno CESAM Antiriciclaggio
,1137	--AZIMUT Esterno CESAM Assistenza
,1232	--AZIMUT Esterno CESAM Audit
,1432	--Eurovita Esterno CESAM Antiriciclaggio
,1843	--AZIMUT Esterno CESAM Deroganti
,2069	--AZIMUT Esterno CESAM Augustum
)


