SELECT
	IdIncarico
   ,CodiceIncarico
   ,TipoIncarico
   ,AnagraficaCliente
   ,AnagraficaPromotore
FROM rs.v_CESAM_AZ_Sospesi_AperturaPaperless_GestioneCarta


/*

VIEW	rs.v_CESAM_AZ_Sospesi_AperturaPaperless_GestioneCarta

SELECT T_Incarico.IdIncarico
		,T_incarico.CodTipoIncarico CodiceIncarico
		,D_TipoIncarico.Descrizione TipoIncarico
		,ChiaveClienteIntestatario + ' ' + CognomeIntestatario + ' ' +  NomeIntestatario + ' ' +  RagioneSocialeIntestatario AnagraficaCliente
		,CodicePromotore + ' ' +  NomePromotore + ' ' +  CognomePromotore + ' ' +  RagioneSocialePromotore AnagraficaPromotore

from T_Incarico
	join rs.v_CESAM_AZ_CodeLavorazioneSospesi code_lav_sospesi on T_Incarico.IdIncarico = code_lav_sospesi.IdIncarico
	JOIN  D_TipoIncarico on T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
	JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore anagrafica on T_Incarico.IdIncarico = anagrafica.IdIncarico
	left JOIN rs.v_CESAM_AZ_OpCagliari_SwitchFondiInvestimento cagliari_switchfondi 
			on code_lav_sospesi.IdIncarico = cagliari_switchfondi.IdIncarico

WHERE code_lav_sospesi.CodTipoIncarico = 343 --incremento/decremento

OR cagliari_switchfondi.IdIncarico IS not NULL

*/


