use clc

/*
Cerchiamo il profilo accesso di chi effettua la richiesta
*/
SELECT * FROM S_Operatore where Cognome like '%bruni%' and Nome LIKE '%angela%'

--937

--verifichiamo che abbia la possibilità di gestire la telefonata (ha il bottone "Gestisci Telefonata" su QTask)
SELECT
	*
FROM D_Privilegio
WHERE Codice = 10441
--10441	Esegui telefonata

SELECT * FROM R_ProfiloAccesso_Privilegio where CodProfiloAccesso = 937 AND CodPrivilegio = 10441
--se non ha il privilegio si fa la insert (in questo caso non occorre)

--C'è il setup per il tipo incarico in questione?
SELECT CodTipoIncarico from T_Incarico where IdIncarico = 9680548
--325

select * FROM R_Cliente_TipoIncarico_MotivoTelefonata where CodTipoIncarico = 325

--se righe vuote, occorre fare le insert (preproduzione)

USE CLC

insert INTO R_Cliente_TipoIncarico_MotivoTelefonata (CodCliente,CodTipoIncarico,CodMotivoTelefonata)
SELECT CodCliente,325,CodMotivoTelefonata
from R_Cliente_TipoIncarico_MotivoTelefonata
where CodTipoIncarico = 343  --incarico esempio (incremento/decremento) per il quale è stato fatto il medesimo setup per gestire questo tipo di richieste

--trasferimento tabella:
SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'R_Cliente_TipoIncarico_MotivoTelefonata'

--TELEFONATA

