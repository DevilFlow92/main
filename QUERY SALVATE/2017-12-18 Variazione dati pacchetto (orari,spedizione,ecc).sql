use ScanDB_MI

if object_id(N'tempdb.#tmpPack',N'U') is not null
drop TABLE #tmpPack

SELECT tp.IdPacchetto
into #tmpPack

FROM dbo.T_Pacchetto tp INNER JOIN dbo.QTask_R_Pacchetto_Dati qrpd ON tp.IdPacchetto = qrpd.IdPacchetto

where IdIncarico IN (9464948
,9464884
,9464885
,9464886
,9464887
,9464888
,9464889
,9464890
,9464891 
,9464892
)

update T_Pacchetto
set DataRicezione= '2017-12-18 10:00:00.000'

from #tmpPack inner join T_Pacchetto on #tmpPack.IdPacchetto = T_Pacchetto.IdPacchetto

drop TABLE #tmpPack