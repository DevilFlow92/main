
drop table #feacc
drop table #feadt

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
--		,pprom.ChiaveCliente [ChiavePromotore]
		,pprom.cognome + '-' + '-' + pprom.Nome AnagraficaPromotore

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

--where T_Incarico.CodCliente = 48 and T_Incarico.CodTipoIncarico = 334
--	and codarea = 8
--	--and T_Incarico.IdIncarico = 8712597
--	and datacreazione >= '2017-12-01'

where T_Incarico.IdIncarico = 932962

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
		--,pp5.IdPersona [IDIntestatario1]
		--,pp5.ChiaveCliente [ChiaveCliente5]
		--,pp5.Cognome + '-' + pp5.Nome [AnagraficaIntestatario5]
		,T_Promotore.IdPromotore [IdPromotore]
--		,pprom.ChiaveCliente [ChiavePromotore]
		,pprom.cognome + '-' + '-' + pprom.Nome AnagraficaPromotore

into #feadt

FROM T_Incarico
left join D_TipoIncarico on T_Incarico.CodTipoIncarico = D_TipoIncarico.Codice
LEFT JOIN T_R_Incarico_Persona p1 ON p1.IdIncarico = T_Incarico.IdIncarico AND p1.Progressivo = 1
LEFT JOIN T_R_Incarico_Persona p2 ON p2.IdIncarico = T_Incarico.IdIncarico AND p2.Progressivo = 2
LEFT JOIN T_R_Incarico_Persona p3 ON p3.IdIncarico = T_Incarico.IdIncarico AND p3.Progressivo = 3
LEFT JOIN T_R_Incarico_Persona p4 ON p4.IdIncarico = T_Incarico.IdIncarico AND p4.Progressivo = 4
--LEFT JOIN T_R_Incarico_Persona p5 ON p5.IdIncarico = T_Incarico.IdIncarico AND p1.Progressivo = 5

LEFT JOIN T_Persona pp1 ON pp1.IdPersona = p1.IdPersona
LEFT JOIN T_Persona pp2 ON pp2.IdPersona = p2.IdPersona
LEFT JOIN T_Persona pp3 ON pp1.IdPersona = p3.IdPersona
LEFT JOIN T_Persona pp4 ON pp2.IdPersona = p4.IdPersona
--LEFT JOIN T_Persona pp5 ON pp2.IdPersona = p5.IdPersona

join T_R_Incarico_Promotore on p1.IdIncarico = T_R_Incarico_Promotore.IdIncarico
left join T_Promotore on T_R_Incarico_Promotore.IdPromotore = T_Promotore.IdPromotore
left join T_Persona pprom on T_Promotore.IdPersona = pprom.IdPersona

--where T_Incarico.CodCliente = 48 and T_Incarico.CodTipoIncarico = 335
--	and codarea = 8
--	--and T_Incarico.IdIncarico = 8712597
--	and datacreazione >= '2017-12-01'

where T_Incarico.IdIncarico = 932963

select *

from #feacc join #feadt on #feacc.ChiaveCliente1 = #feadt.ChiaveCliente1 and #feacc.ChiaveCliente2 = #feadt.ChiaveCliente2
								and #feacc.ChiaveCliente3 = #feadt.ChiaveCliente3 and #feacc.ChiaveCliente4 = #feadt.ChiaveCliente4
								and #feacc.IdPromotore=#feadt.IdPromotore




--  932963 dtfea
--  932962 ccfea

select * from T_Incarico where T_Incarico.IdIncarico = 932962