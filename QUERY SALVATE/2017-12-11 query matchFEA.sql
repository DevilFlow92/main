use CLC

DROP TABLE #feacc, #feadt

select T_Incarico.IdIncarico
		,D_TipoIncarico.Codice
		,D_TipoIncarico.Descrizione [TipoIncarico]
		,pp1.IdPersona [IDIntestatario1]
		,pp1.ChiaveCliente ChiaveCliente1
		,pp1.Cognome + '-' + pp1.Nome AnagraficaIntestatario
		,pp2.IdPersona [IDIntestatario2]
		,pp2.ChiaveCliente ChiaveCliente2
		,pp2.Cognome + '-' + pp2.Nome AnagraficaIntestatario2
		,pp3.IdPersona [IDIntestatario3]
		,pp3.ChiaveCliente ChiaveCliente3
		,pp3.Cognome + '-' + pp3.Nome [AnagraficaIntestatario3]
		,pp4.IdPersona [IDIntestatario4]
		,pp4.ChiaveCliente ChiaveCliente4
		,pp4.Cognome + '-' + pp4.Nome [AnagraficaIntestatario4]
		,T_Promotore.IdPromotore [IdPromotore]
		,pprom.cognome + '-' + '-' + pprom.Nome AnagraficaPromotore
		,isnull(pp1.ChiaveCliente + '-','') + isnull(pp2.ChiaveCliente + '-','')
			+ isnull(pp3.ChiaveCliente + '-','')  + isnull(pp4.ChiaveCliente,'') 
				+ cast(T_Promotore.IdPromotore as varchar(5)) as ChiaveMatch
into #feacc
	FROM T_Incarico
		left join D_TipoIncarico on T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
		LEFT JOIN T_R_Incarico_Persona p1 ON p1.IdIncarico = T_Incarico.IdIncarico AND p1.Progressivo = 1
		LEFT JOIN T_R_Incarico_Persona p2 ON p2.IdIncarico = T_Incarico.IdIncarico AND p2.Progressivo = 2
		LEFT JOIN T_R_Incarico_Persona p3 ON p3.IdIncarico = T_Incarico.IdIncarico AND p3.Progressivo = 3
		LEFT JOIN T_R_Incarico_Persona p4 ON p4.IdIncarico = T_Incarico.IdIncarico AND p4.Progressivo = 4
		LEFT JOIN T_Persona pp1 ON pp1.IdPersona = p1.IdPersona
		LEFT JOIN T_Persona pp2 ON pp2.IdPersona = p2.IdPersona
		LEFT JOIN T_Persona pp3 ON pp1.IdPersona = p3.IdPersona
		LEFT JOIN T_Persona pp4 ON pp2.IdPersona = p4.IdPersona
		join T_R_Incarico_Promotore on p1.IdIncarico = T_R_Incarico_Promotore.IdIncarico
		left join T_Promotore on T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
		left join T_Persona pprom on T_Promotore.IdPersona = pprom.IdPersona

	where T_Incarico.CodCliente = 48 and T_Incarico.CodTipoIncarico = 335 --cc FEA
	and T_Incarico.CodArea = 8
	--and datacreazione >= '2017-12-11'
	--where T_Incarico.IdIncarico = 4423945 ES CC FEA

select T_Incarico.IdIncarico
		,D_TipoIncarico.Codice
		,D_TipoIncarico.Descrizione [TipoIncarico]
		,pp1.IdPersona [IDIntestatario1]
		,pp1.ChiaveCliente ChiaveCliente1
		,pp1.Cognome + '-' + pp1.Nome AnagraficaIntestatario
		,pp2.IdPersona [IDIntestatario2]
		,pp2.ChiaveCliente ChiaveCliente2
		,pp2.Cognome + '-' + pp2.Nome AnagraficaIntestatario2
		,pp3.IdPersona [IDIntestatario3]
		,pp3.ChiaveCliente ChiaveCliente3
		,pp3.Cognome + '-' + pp3.Nome [AnagraficaIntestatario3]
		,pp4.IdPersona [IDIntestatario4]
		,pp4.ChiaveCliente ChiaveCliente4
		,pp4.Cognome + '-' + pp4.Nome [AnagraficaIntestatario4]
		,T_Promotore.IdPromotore [IdPromotore]
		,pprom.cognome + '-' + '-' + pprom.Nome AnagraficaPromotore
		,isnull(pp1.ChiaveCliente + '-','') + isnull(pp2.ChiaveCliente + '-','')
			+ isnull(pp3.ChiaveCliente + '-','')  + isnull(pp4.ChiaveCliente,'') 
				+ cast(T_Promotore.IdPromotore as varchar(5)) as ChiaveMatch
into #feadt

	FROM T_Incarico
		left join D_TipoIncarico on T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
		LEFT JOIN T_R_Incarico_Persona p1 ON p1.IdIncarico = T_Incarico.IdIncarico AND p1.Progressivo = 1
		LEFT JOIN T_R_Incarico_Persona p2 ON p2.IdIncarico = T_Incarico.IdIncarico AND p2.Progressivo = 2
		LEFT JOIN T_R_Incarico_Persona p3 ON p3.IdIncarico = T_Incarico.IdIncarico AND p3.Progressivo = 3
		LEFT JOIN T_R_Incarico_Persona p4 ON p4.IdIncarico = T_Incarico.IdIncarico AND p4.Progressivo = 4
		LEFT JOIN T_Persona pp1 ON pp1.IdPersona = p1.IdPersona
		LEFT JOIN T_Persona pp2 ON pp2.IdPersona = p2.IdPersona
		LEFT JOIN T_Persona pp3 ON pp1.IdPersona = p3.IdPersona
		LEFT JOIN T_Persona pp4 ON pp2.IdPersona = p4.IdPersona
		join T_R_Incarico_Promotore on p1.IdIncarico = T_R_Incarico_Promotore.IdIncarico
		left join T_Promotore on T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
		left join T_Persona pprom on T_Promotore.IdPersona = pprom.IdPersona

	where T_Incarico.CodCliente = 48 and T_Incarico.CodTipoIncarico = 334 -- DT FEA
	and T_Incarico.CodArea = 8
	--and datacreazione >= '2017-12-11'
	--where T_Incarico.IdIncarico = 4423946 ES DT FEA


select   #feacc.*
		,#feadt.Codice
		,#feadt.TipoIncarico Incarico_Associabile
from #feacc join #feadt on #feacc.ChiaveMatch = #feadt.ChiaveMatch
