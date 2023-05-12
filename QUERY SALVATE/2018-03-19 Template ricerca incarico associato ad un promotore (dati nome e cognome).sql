use CLC

SELECT max(ti.IdIncarico) IdIncarico
		,van.idpromotore
		,van.CodicePromotore
		,van.RagioneSocialePromotore
		,van.CognomePromotore
		,van.NomePromotore

FROM T_Incarico ti
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van ON ti.IdIncarico = van.IdIncarico
AND ti.CodArea = 8
AND ti.CodCliente = 23 --48 

WHERE  van.CodicePromotore
 in ('7908' --RONCARATI LUCA
,'7967' --TRAVAGLIO VILMA
)


GROUP BY 
van.idpromotore
		,van.CodicePromotore
		,van.RagioneSocialePromotore
		,van.CognomePromotore
		,van.NomePromotore


