--fatturazione 
--per aprile (1/30) 

--dettaglio
--per ogni riga: idincarico, datacreazione, categoria, tipoincarico, intestatario, promotore, area

;
WITH Categorie AS (
SELECT 1 CodCategoria, 'Case Terze'         EtichettaCategoria  union all
SELECT 2 CodCategoria, 'Fondi Azimut' 		EtichettaCategoria	union all
SELECT 3 CodCategoria, 'Finanziamenti' 		EtichettaCategoria	union all
SELECT 4 CodCategoria, 'Successioni' 		EtichettaCategoria	union all
SELECT 5 CodCategoria, 'Onboarding Clienti' EtichettaCategoria	union all
SELECT 6 CodCategoria, 'AZ Libera Impresa'	EtichettaCategoria

)
,SottoCategorie AS (
SELECT  1 CodSottoCategoria, 'Sottoscrizioni'           EtichettaCategoria union all
select  2 CodSottoCategoria, 'Switch'					EtichettaCategoria union all
select  3 CodSottoCategoria, 'Rimborsi'					EtichettaCategoria union all
SELECT  4 CodSottoCategoria, 'Incremento/Decremento'	EtichettaCategoria

)

,dataset AS (
SELECT 	t.IdIncarico
		,DataCreazione
		,CodTipoIncarico
		,TipoIncarico	
		,Categoria
		,Categorie.EtichettaCategoria				
		,SottoCategoria
		,CAST(ISNULL(SottoCategorie.EtichettaCategoria,'Tipo Incarico') AS VARCHAR(250)) EtichettaSottoCategoria
		,van.ChiaveClienteIntestatario
		,CASE WHEN van.CognomeIntestatario IS NULL OR van.CognomeIntestatario = ''
			THEN van.RagioneSocialeIntestatario
			ELSE van.CognomeIntestatario + ' ' + ISNULL(van.NomeIntestatario,'') 
			END Intestatario
		,van.CodicePromotore CodiceConsulente
		,CASE WHEN van.CognomePromotore IS NULL or van.CognomePromotore = ''
			THEN van.RagioneSocialePromotore
			WHEN van.AnagraficaCF is NOT NULL THEN van.AnagraficaCF
			ELSE van.CognomePromotore + ' ' + ISNULL(van.NomePromotore,'')
			END Consulente
		,van.DescrizioneSim MacroArea
		,van.DescrizioneAreaCentroRaccolta Area
		,van.DescrizioneCentroRaccolta CentroRaccolta

FROM rs.v_CESAM_AZ_FatturazioneIncarichi_v2 t
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON t.IdIncarico = van.IdIncarico
AND van.ProgressivoPersona = 1
JOIN Categorie on CodCategoria = t.Categoria
LEFT JOIN SottoCategorie ON CodSottoCategoria = t.SottoCategoria
WHERE 
 t.DataCreazione >= '20200101' AND t.DataCreazione < '20200501'
 --AND van.idpersona IS NULL
 --AND t.Categoria IS NOT NULL
 --ORDER BY t.Categoria,t.SottoCategoria, t.IdIncarico

 ) SELECT  	IdIncarico
			,DataCreazione
			--,CodTipoIncarico
			,TipoIncarico
			,Categoria
			,EtichettaCategoria
			,SottoCategoria
			,EtichettaSottoCategoria
			,ChiaveClienteIntestatario
			,Intestatario
			,CodiceConsulente
			,Consulente
			,MacroArea
			,Area
			,CentroRaccolta 

FROM dataset

 --JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore ON dataset.IdIncarico = rs.v_CESAM_Anagrafica_Cliente_Promotore.IdIncarico
 --AND rs.v_CESAM_Anagrafica_Cliente_Promotore.idpersona is NOT NULL

 --group BY IdIncarico
 -- HAVING COUNT(dataset.ChiaveClienteIntestatario) >= 2

  ORDER BY Categoria,SottoCategoria,IdIncarico


 