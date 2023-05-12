use CLC

select * from D_TipoIncarico

where Descrizione like '%switch%'

--159	Switch [FAX] anticipati via fax – Fondi Azimut
--160	Switch [ORIG] anticipati via fax – Fondi Azimut


UPDATE D_TipoIncarico
SET Descrizione = 'Switch [FAX-PEC] anticipati – Fondi Az'
where Codice = 159

UPDATE D_TipoIncarico
SET Descrizione = 'Switch [ORIG] anticipati via fax/pec – Fondi Az'
where Codice = 160



