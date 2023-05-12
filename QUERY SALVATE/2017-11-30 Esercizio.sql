/*
Estrarre le pratiche che hanno imbarcato il doc "Modulo Apertra Conto Yellow"
Che hanno lo stato wf gestita - docbank caricata su qtask
create dal 19-11-2017

*/


select * from D_StatoWorkflowIncarico where Descrizione like '%docbank%'

-- 14300	DocBank Caricata su Qtask-Inviata Mail Consulente

select * from D_Documento where Descrizione like '%yellow%'

--8275	Modulo di apertura Conto Yellow


select top 10 * from T_Documento
select DescrizioneCEI from T_Documento
where Tipo_Documento = 8275

select
t_incarico.IdIncarico, 
DataCreazione [Data Creazione], 
CodStatoWorkflowIncarico [Codice Stato WF],
D_StatoWorkflowIncarico.Descrizione [Stato WF],
t_documento.Tipo_Documento [Codice Documento], 
d_documento.Descrizione [Tipo Documento]

from t_incarico 
	join D_StatoWorkflowIncarico on t_incarico.CodStatoWorkflowIncarico = D_StatoWorkflowIncarico.Codice
	join t_documento on t_incarico.IdIncarico = t_documento.IdIncarico
	join d_documento on d_documento.codice = t_documento.Tipo_Documento

where CodStatoWorkflowIncarico=14300 
and DataCreazione>='2017-11-19' 
and t_documento.Tipo_Documento= 8275

