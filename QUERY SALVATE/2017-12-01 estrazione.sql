--Estrazione del 28 novembre 2017

--Richiesta: estrazione di tutti gli incarichi Conti UBS
--che si trovano nello stato WF In lavorazione CESAM - Iban Comunicato

--=================================================================

USE CLC

select * from D_Cliente
where codice=23
--23	Azimut

use CLC
select* from D_TipoIncarico
where descrizione like'%UBS%'
--320	Conti UBS

use CLC
select* from R_Cliente_TipoIncarico
where codtipoincarico=320

use CLC
select* from D_MacroStatoWorkflowIncarico
where descrizione like'%in gestione%'
--9	In Gestione

use CLC
select* from D_StatoWorkflowIncarico
where descrizione like'%iban comuni%'
--14264	In lavorazione CESAM - Iban Comunicato

use CLC
select* from d_area
--8 Gestione SIM


--==========================================

--Estrazione

use CLC
select
IdIncarico,
D_TipoIncarico.Descrizione [Tipo incarico],
DataCreazione as [Data Creazione],
DataUltimaTransizione [Data Ultima Transizione],
D_StatoWorkflowIncarico.Descrizione [Stato WorkFlow],
D_AttributoIncarico.Descrizione [Attributo]

from T_Incarico

join D_Cliente on D_Cliente.Codice = t_incarico.CodCliente
 left join D_TipoIncarico on D_TipoIncarico.Codice= T_Incarico.CodTipoIncarico
 left join D_StatoWorkflowIncarico on D_StatoWorkflowIncarico.Codice = T_Incarico.CodStatoWorkflowIncarico
 left join D_AttributoIncarico on D_AttributoIncarico.Codice =T_Incarico.CodAttributoIncarico
where codcliente=23 --azimut
and CodArea=8 --gestione SIM
and CodTipoIncarico=320 --Conti UBS
and CodStatoWorkflowIncarico=14264 --In lavorazione CESAM - Iban Comunicato











