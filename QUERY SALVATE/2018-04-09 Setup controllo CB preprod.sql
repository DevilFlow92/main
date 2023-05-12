use CLC


--INSERT into [VP-BTSQL02].CLC.dbo.S_MacroControllo (CodCliente, CodTipoIncarico, NomeStoredProcedure, Descrizione, TestoHelp, FlagGenerazioneDifferita , Ordinamento )
SELECT CodCliente
		,CodTipoIncarico
		,NomeStoredProcedure
		,Descrizione
		,TestoHelp
		,FlagGenerazioneDifferita
		,Ordinamento
		
from S_MacroControllo
where IdMacroControllo = 453

SELECT * FROM  [VP-BTSQL02].CLC.dbo.S_MacroControllo order BY IdMacrocontrollo DESC 
--idmacrocontrollo 702

--INSERT INTO [vp-btsql02].clc.[dbo].[S_Controllo]
           ([CodDatoAssociabile]
           ,[IdTipoMacroControllo]
           ,[NomeStoredProcedure]
           ,[FlagEsitoNonDefinito]
           ,[FlagEsitoPositivo]
           ,[FlagEsitoPositivoConRiserva]
           ,[FlagEsitoNegativo]
           ,[FlagNotaObbligatoria]
           ,[Descrizione]
           ,[TestoHelp]
           ,[CodEsitoControlloDefault]
           ,[NomeStoredProcedurePreparatoria]
           ,[Ordinamento]
           ,[CodTipoRilievoControlloDefault]
           ,[FlagSolaLettura])

select [CodDatoAssociabile]
           ,[IdTipoMacroControllo]
           ,[NomeStoredProcedure]
           ,[FlagEsitoNonDefinito]
           ,[FlagEsitoPositivo]
           ,[FlagEsitoPositivoConRiserva]
           ,[FlagEsitoNegativo]
           ,[FlagNotaObbligatoria]
           ,[Descrizione]
           ,[TestoHelp]
           ,[CodEsitoControlloDefault]
           ,[NomeStoredProcedurePreparatoria]
           ,[Ordinamento]
           ,[CodTipoRilievoControlloDefault]
           ,[FlagSolaLettura]
FROM S_Controllo WHERE IdControllo = 1775

SELECT * FROM [vp-btsql02].clc.[dbo].[S_Controllo] order BY idcontrollo DESC 
--2309

--INSERT INTO [vp-btsql02].clc.[dbo].[R_Transizione_MacroControllo]
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodAttributoIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[FlagAttesaPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaDestinazione]
           ,[IdTipoMacroControllo]
           ,[FlagCreazione])
SELECT 	
[CodCliente]
           ,[CodTipoIncarico]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodAttributoIncaricoPartenza]
           ,[FlagUrgentePartenza]
           ,[FlagAttesaPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[CodAttributoIncaricoDestinazione]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaDestinazione]
           ,702
           ,[FlagCreazione]
 FROM R_Transizione_MacroControllo WHERE IdTipoMacroControllo = 453


SELECT * FROM [vp-btsql02].clc.[dbo].[R_Transizione_MacroControllo] where idtipomacrocontrollo = 702

--INSERT INTO [vp-btsql02].clc.[dbo].[R_EsitoControllo_BloccoTransizione]
           ([CodCliente]
           ,[CodTipoIncarico]
           ,[CodAttributoIncaricoPartenza]
           ,[CodAttributoIncaricoDestinazione]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[FlagUrgentePartenza]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaPartenza]
           ,[FlagAttesaDestinazione]
           ,[CodGiudizioControllo]
           ,[CodEsitoControllo]
           ,[IdControllo]
           ,[IdMacroControllo]
           ,[FlagAbilitaBlocco])

SELECT 	
[CodCliente]
           ,[CodTipoIncarico]
           ,[CodAttributoIncaricoPartenza]
           ,[CodAttributoIncaricoDestinazione]
           ,[CodStatoWorkflowIncaricoPartenza]
           ,[CodStatoWorkflowIncaricoDestinazione]
           ,[FlagUrgentePartenza]
           ,[FlagUrgenteDestinazione]
           ,[FlagAttesaPartenza]
           ,[FlagAttesaDestinazione]
           ,[CodGiudizioControllo]
           ,[CodEsitoControllo]
           ,2309
           ,[IdMacroControllo]
           ,[FlagAbilitaBlocco]
 FROM R_EsitoControllo_BloccoTransizione WHERE IdControllo = 1775

