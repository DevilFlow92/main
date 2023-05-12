USE CLC
GO

;
WITH cuboAnagrafica AS (

SELECT 
tp.IdPersona
,IIF(tp.IdPersona IS NULL,1,0) IdPersonaNULL
,tp.Cognome CognomeQTask
,tp.Nome NomeQTask
,cliente
,desc_cliente
,cod_natgiu
,natura_giuridica
,codice_fiscale
,partita_iva

,CASE 
	WHEN cognome_corrisp !='' AND ((cognome_corrisp + ' ' + nome_corrisp) != desc_cliente)
		THEN 'C/O ' + cognome_corrisp + ISNULL(' ' + nome_corrisp,'')
	WHEN cognome_corrisp != ''  AND indirizzo_corrisp = 'Via Cusani 4' AND localita_corrisp = 'MILANO'
		THEN 'C/O ' + cognome_corrisp + ISNULL(' ' + nome_corrisp,'')
	WHEN cognome_corrisp != '' 
		THEN indirizzo_corrisp
	ELSE indirizzo_res
END PrimaRigaNuova

,CASE  
	WHEN ( cognome_corrisp !='' AND ((cognome_corrisp + ' ' + nome_corrisp) != desc_cliente) )
			OR (cognome_corrisp != ''  AND indirizzo_corrisp = 'Via Cusani 4' AND localita_corrisp = 'MILANO')
		THEN indirizzo_corrisp
    END AS SecondaRigaNuova

,CASE WHEN localita_corrisp IS NULL OR localita_corrisp = ''
    THEN loc_res
    ELSE localita_corrisp
    END AS LocalitaNuova
,CASE WHEN prov_corrisp IS NULL OR prov_corrisp = ''
    THEN prov_res
    ELSE prov_corrisp
    END AS SiglaProvinciaNuova
,CASE WHEN cap_corrisp IS NULL OR cap_corrisp = '00000'
    THEN cap_residenza
    ELSE cap_corrisp
    END AS CapNuovo
,IIF(IndirizziQTask.IdIndirizzo IS NULL,1,0) IdIndirizzoNULL
,   IndirizziQTask.IdRelazione
   ,IndirizziQTask.IdIndirizzo
   ,IndirizziQTask.primariga
   ,IndirizziQTask.secondariga
   ,IndirizziQTask.Cap
   ,IndirizziQTask.Localita
   ,IndirizziQTask.SiglaProvincia
,mandato
FROM scratch.L_CESAM_AZ_FIA_ImportAnagrafica
LEFT JOIN T_Persona tp ON tp.ChiaveCliente = cliente
AND tp.CodCliente = 23
OUTER APPLY (
                SELECT TOP 1 trpindx.IdRelazione, trpindx.IdPersona, tindx.IdIndirizzo, tindx.PrimaRiga, tindx.SecondaRiga, tindx.Cap, tindx.Localita, tindx.SiglaProvincia
                FROM T_R_Persona_Indirizzo trpindx
                JOIN T_Indirizzo tindx ON trpindx.IdIndirizzo = tindx.IdIndirizzo
                WHERE trpindx.IdPersona = tp.IdPersona
                AND tindx.CodTipoIndirizzo = 7
				AND trpindx.DataFine IS NULL
                ORDER BY trpindx.IdRelazione DESC

) IndirizziQTask 
WHERE IdFondoFIAAzimut = 11

)
            
SELECT 
  mandato
	,IdPersona
      ,IdPersonaNULL
      ,CognomeQTask
      ,NomeQTask
      ,cliente
      ,desc_cliente
      ,IIF(cod_natgiu <> 1,2,1) CodTipoPersona	 
      ,iif(cod_natgiu <> 1,partita_iva,codice_fiscale) CodiceFiscale
      ,PrimaRigaNuova
	  ,SecondaRigaNuova
      ,LocalitaNuova
      ,SiglaProvinciaNuova
      ,Codice CodProvincia
      ,CapNuovo
      ,IdIndirizzoNULL
      ,IdRelazione
      ,IdPersona
      ,IdIndirizzo 
      ,primariga
	  ,secondariga
      ,Cap
      ,Localita
      ,SiglaProvincia
    
FROM cuboAnagrafica
JOIN D_Provincia ON SiglaProvinciaNuova = Sigla

WHERE 
--cliente = '000002874' 

(
IdPersonaNULL = 1
OR IdIndirizzoNULL = 1
OR (
	(PrimaRiga IS NULL AND PrimaRigaNuova IS NOT NULL AND PrimaRigaNuova!= SecondaRiga)
    OR (PrimaRiga IS NOT NULL AND PrimaRigaNuova IS NULL AND SecondaRigaNuova!=PrimaRiga)
	OR (SecondaRigaNuova IS NOT NULL AND SecondaRiga IS NULL AND SecondaRigaNuova!=PrimaRiga )
	OR (SecondaRiga IS NOT NULL AND SecondaRigaNuova IS NULL AND SecondaRigaNuova !=Primariga)
	OR cuboAnagrafica.PrimaRigaNuova != PrimaRiga
	OR SecondaRigaNuova != SecondaRiga
    OR LocalitaNuova != Localita
    OR SiglaProvinciaNuova != SiglaProvincia
    OR CapNuovo != Cap
) 
)