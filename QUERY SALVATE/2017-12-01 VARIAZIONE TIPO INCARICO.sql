USE CLC


SELECT * FROM D_TipoIncarico 
left JOIN R_Cliente_TipoIncarico on D_TipoIncarico.Codice = R_Cliente_TipoIncarico.CodTipoIncarico
where CodCliente = 23
and D_TipoIncarico.Descrizione LIKE '%rid%'


EXEC [orga].[CESAM_AZ_VariazioneIncarichi]




