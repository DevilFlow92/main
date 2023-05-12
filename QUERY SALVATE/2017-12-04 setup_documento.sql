USE [CLC]
GO

INSERT INTO [dbo].[D_Documento]
           ([Codice]
           ,[Descrizione]
           ,[Etichetta]
           ,[CodOggettoControlli]
           ,[FlagDocumentoBase]
           ,[Ordinamento]
           ,[FlagScanCEI])
     VALUES
           (20003
           ,'Liste di screening'
           ,'Liste di screening'
           ,1
		   ,1
		   ,1
		   ,1)
GO

select * from D_OggettoControlli
-- 1 richiedente

select * from D_Documento
--flagdocbase, ordinamento,flagscanCEI: ultima riga esistente (tutti 1)


--CERCARE IL COD TIPO INCARICO:

select * from D_TipoIncarico
where Descrizione like '%antiriciclaggio%'
-- 66	Antiriciclaggio

insert into D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase, Ordinamento, FlagScanCEI) values (20003, 'Lista in screening', 'Lista in screening', 1, 1,1,1 )	

insert into R_Cliente_TipoIncarico_TipoDocumento (CodCliente, CodTipoIncarico, CodDocumento, FlagVisualizza)values (23,66,20003, 1)

select * from D_TipoIncarico
where Descrizione like '%antiriciclaggio%'
-- 66	Antiriciclaggio


--Si procede poi al trasferimento delle tabelle




