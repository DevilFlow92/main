USE CLC
GO

--ALTER VIEW rs.v_CESAM_AZ_FatturazioneIncarichi_DettaglioDocumenti AS 

/* Author: Lorenzo Fiori
	Utilizzata nel report: AZ - Fatturazione Mensile
*/

SELECT 
T_Incarico.IdIncarico
,T_Incarico.CodTipoIncarico
,D_TipoIncarico.Descrizione TipoIncarico
,DataCreazione DataCreazioneIncarico
,Documento_id
,Tipo_Documento CodTipoDocumento
,D_Documento.Descrizione TipoDocumento
,DataInserimento DataInserimento
,anagrafica.CodicePromotore + ' '
 + IIF(anagrafica.CognomePromotore IS NULL or anagrafica.CognomePromotore = '',anagrafica.RagioneSocialePromotore,anagrafica.CognomePromotore) + ' '
  + IIF(anagrafica.NomePromotore is NULL OR anagrafica.NomePromotore = '','',anagrafica.NomePromotore) Promotore
,anagrafica.ChiaveClienteIntestatario ChiaveCliente
,IIF(anagrafica.CognomeIntestatario is NULL or anagrafica.CognomeIntestatario = '',anagrafica.RagioneSocialeIntestatario,anagrafica.CognomeIntestatario) + ' ' 
+ IIF(anagrafica.NomeIntestatario is NULL or anagrafica.NomeIntestatario = '','',anagrafica.NomeIntestatario) Cliente 
 

FROM T_Incarico
JOIN D_TipoIncarico ON T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
JOIN T_Documento on T_Incarico.IdIncarico = T_Documento.IdIncarico
JOIN D_Documento ON T_Documento.Tipo_Documento = D_Documento.Codice
LEFT JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica ON T_Incarico.IdIncarico = anagrafica.IdIncarico

WHERE T_Incarico.CodArea = 8
AND T_Incarico.CodCliente = 23

AND T_Incarico.CodTipoIncarico in (
						253	--Bonifica Anagrafica - ADV in scadenza
						,91	 --MIFID - Contratti consulenza/collocamento
						,288 --Censimento Cliente
						,350 --Pregresso Augustum
						,396 --OnBoarding Digitale
						)


--AND DataInserimento >= '2018-09-01' AND DataInserimento < '2018-10-01'

GO


