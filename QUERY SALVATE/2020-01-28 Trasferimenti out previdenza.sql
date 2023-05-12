;WITH trasferimenti AS (
select 224375 IdAutorizzazione, 14009656 IdRichiesta union all
select 221509 IdAutorizzazione, 13878594 IdRichiesta union all
select 221508 IdAutorizzazione, 13818624 IdRichiesta union all
select 221518 IdAutorizzazione, 13721096 IdRichiesta union all
select 198657 IdAutorizzazione, 13713544 IdRichiesta union all
select 206515 IdAutorizzazione, 13878593 IdRichiesta union all
select 206532 IdAutorizzazione, 13721091 IdRichiesta union all
select 121875 IdAutorizzazione, 13416209 IdRichiesta union all
select 198645 IdAutorizzazione, 13707362 IdRichiesta union all
select 200288 IdAutorizzazione, 13721286 IdRichiesta union all
select 192305 IdAutorizzazione, 13855270 IdRichiesta union all
select 192301 IdAutorizzazione, 13767551 IdRichiesta union all
select 192306 IdAutorizzazione, 13696297 IdRichiesta union all
select 192299 IdAutorizzazione, 13705738 IdRichiesta union all
select 191654 IdAutorizzazione, 13908347 IdRichiesta union all
select 191650 IdAutorizzazione, 13721280 IdRichiesta union all
select 193962 IdAutorizzazione, 13758005 IdRichiesta union ALL
select 193325 IdAutorizzazione, 14065244 IdRichiesta union all
select 193961 IdAutorizzazione, 13730893 IdRichiesta 
--select 13246211 IdAutorizzazione, IdRichiesta 
)
SELECT ti.IdIncarico IdRichiesta, ti2.IdIncarico IdAutorizzazione, trisc.IdSeparatoreCheckin, tdoc.Documento_id,tdoc.Tipo_Documento CodTipoDocumento1, ddoc.Descrizione
,tdoc2.Documento_id IdDocumento2, tdoc2.Tipo_Documento CodTipoDocumento2, ddoc2.Descrizione Descrizione2
FROM trasferimenti
JOIN T_Incarico ti ON ti.IdIncarico = trasferimenti.IdRichiesta
JOIN T_R_Incarico_SeparatoreCheckin trisc ON trisc.IdSeparatoreCheckin = IdAutorizzazione
JOIN T_Incarico ti2 ON trisc.IdIncarico = ti2.IdIncarico

JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico
AND tdoc.FlagPresenzaInFileSystem = 1 AND tdoc.FlagScaduto = 0
AND tdoc.Tipo_Documento = 6047

JOIN T_Documento tdoc2 ON ti2.IdIncarico = tdoc2.IdIncarico
AND tdoc2.FlagPresenzaInFileSystem = 1 and tdoc2.FlagScaduto = 0

JOIN D_Documento ddoc ON ddoc.Codice = tdoc.Tipo_Documento
JOIN D_Documento ddoc2 ON ddoc2.Codice = tdoc2.Tipo_Documento


WHERE ti2.IdIncarico in (13963918
,14077067
,13246211
)

UNION ALL
SELECT ti.IdIncarico IdRichiesta, ti2.IdIncarico IdAutorizzazione, NULL IdSeparatoreCheckin, tdoc.Documento_id,tdoc.Tipo_Documento CodTipoDocumento1, ddoc.Descrizione
,tdoc2.Documento_id IdDocumento2, tdoc2.Tipo_Documento CodTipoDocumento2, ddoc2.Descrizione Descrizione2
 
FROM 
T_Incarico ti 
JOIN T_Documento tdoc ON ti.IdIncarico = tdoc.IdIncarico
AND tdoc.FlagPresenzaInFileSystem = 1 AND tdoc.FlagScaduto = 0
AND tdoc.Tipo_Documento = 6047

JOIN T_Incarico ti2 ON ti2.IdIncarico = 13246211
JOIN T_Documento tdoc2 ON ti2.IdIncarico = tdoc2.IdIncarico
AND tdoc2.FlagPresenzaInFileSystem = 1 and tdoc2.FlagScaduto = 0

JOIN D_Documento ddoc ON ddoc.Codice = tdoc.Tipo_Documento
JOIN D_Documento ddoc2 ON ddoc2.Codice = tdoc2.Tipo_Documento

WHERE ti.IdIncarico = 14079020  



