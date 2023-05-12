USE CLC
GO


;
WITH setup AS (
select 'PRDCNT' CodDocumentoCliente, 119 CodFormDE union all
select 'PRDCNT_NG' CodDocumentoCliente, 119 CodFormDE union all
select 'PRDCNT_SWTCH' CodDocumentoCliente, 119 CodFormDE union all
select 'PRDCNT_INT' CodDocumentoCliente, 119 CodFormDE union all
select 'PRDCNT_INT_KK' CodDocumentoCliente, 119 CodFormDE union all
select 'Attestato' CodDocumentoCliente, 122 CodFormDE union all
select 'CFD1' CodDocumentoCliente, 122 CodFormDE union all
select 'CFD2' CodDocumentoCliente, 122 CodFormDE union all
select 'IDNCFS' CodDocumentoCliente, 121 CodFormDE union all
select 'IDNCRT' CodDocumentoCliente, 123 CodFormDE union all
select 'IDNPAT' CodDocumentoCliente, 123 CodFormDE union all
select 'IDNPAS' CodDocumentoCliente, 123 CodFormDE union all
select 'IDNFIR' CodDocumentoCliente, 123 CodFormDE 

) 
--INSERT INTO orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE (CodCliente, CodTipoIncarico, CodTipoDocumento, CodFormDE, CodOrigineDE)

SELECT z.CodCliente, 611, z.CodTipoDocumento, setup.CodFormDE,2
 FROM [BTSQLCL05\BTSQLCL05].clc.export.Z_Cliente_TipoIncarico_TipoDocumento z
LEFT JOIN orga.R_Cliente_TipoIncarico_TipoDocumento_FormDE r ON z.CodCliente = r.CodCliente 
AND r.CodCliente = 48
AND r.CodTipoIncarico = 611
AND z.CodTipoDocumento = r.CodTipoDocumento
JOIN setup ON z.CodiceTipoDocumentoCliente = CodDocumentoCliente
WHERE z.CodCliente = 48
AND z.CodTipoIncarico = 335
AND r.idRelazione IS NULL





