-- Query per sapere quante pagine hanno i documenti associati ad una pratica 
drop table #tmppaginedoc
use CLC
select NomeFileOriginale from T_Documento

where IdIncarico = 7342149

--requisito: contare il numero di pagine per documento

select NumeroPagine, Nomefile 
from ScanDB_MI.dbo.QTask_R_Pacchetto_Dati
	join ScanDB_MI.dbo.T_Documento on QTask_R_Pacchetto_Dati.IdPacchetto = T_Documento.IdPacchetto

where IdIncarico = 7342149 --pratica scelta

group by NumeroPagine, NomeFile

/*
E va bene se nella pratica sono associati doc di univoca versione.

Ma se sono associati più doc? Come fare per avere solo il più recente?

*/
select documento.NumeroPagine, documento.Nomefile, documento.CodTipoDocumento
into #tmppaginedoc
from ScanDB_MI.dbo.QTask_R_Pacchetto_Dati
	join ScanDB_MI.dbo.T_Documento documento on QTask_R_Pacchetto_Dati.IdPacchetto = documento.IdPacchetto

where IdIncarico = 7272660 --pratica scelta

group by NumeroPagine, NomeFile, documento.CodTipoDocumento

select * from #tmppaginedoc
	join (select max(Nomefile) UltimoFile from #tmppaginedoc
			group by CodTipoDocumento) filerecente on filerecente.UltimoFile = #tmppaginedoc.Nomefile

/*
NB: Per avere una tabella in cui sia presente qual è il file più recente, serve che la tabella temporanea 
generata sia associata alla tabella stessa interrogata per ottenere quella info
*/