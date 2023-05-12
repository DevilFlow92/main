USE [CLC]
GO

INSERT INTO [dbo].[L_ImportSimula]
           ([CodiceSimula]
           ,[CodiceDisposizione]
           ,[DataSimula]
           ,[NumeroDossier]
           ,[CodicePromotore]
           ,[ChiaveClientePromotore]
           ,[CognomePromotore]
           ,[NomePromotore]
           ,[CodiceAreaCentroRaccolta]
           ,[DescrizioneAreaCentroRaccolta]
           ,[IndirizzoSim]
           ,[CodiceSim]
           ,[DescrizioneSim]
           ,[CodiceCentroRaccolta]
           ,[DescrizioneCentroRaccolta]
           ,[IndirizzoCentroRaccolta]
           ,[DataImport]
           ,[NomeFile]
           ,[FlagAggiornamentoCompletato]
           ,[CodiceSimulaMaxFunds])
     SELECT
           cast(NumeroSimula as int) CodiceSimula					--<CodiceSimula, int,>
           ,cast(NumeroDisposizione as int ) CodiceDisposizione			--<CodiceDisposizione, int,>
           ,'2018-01-15 00:00:00.0000000' DataSimula				--<DataSimula, datetime2(7),>
           ,T_Dossier.NumeroDossier [NumeroDossier]						--<NumeroDossier, varchar(50),>	
		   ,T_Promotore.Codice [CodicePromotore]					--<CodicePromotore, varchar(50),>
		   ,T_Persona.ChiaveCliente [ChiaveClientePromotore]			--<ChiaveClientePromotore, varchar(50),>
           ,Cognome [CognomePromotore]					--<CognomePromotore, varchar(250),>
           ,Nome [NomePromotore]						--<NomePromotore, varchar(250),>
           ,T_AreaCentroRaccolta.Codice [CodiceAreaCentroRaccolta]			--<CodiceAreaCentroRaccolta, varchar(50),>
           ,T_AreaCentroRaccolta.Descrizione [DescrizioneAreaCentroRaccolta]		--<DescrizioneAreaCentroRaccolta, varchar(50),>
           ,'boh'[IndirizzoSim]						--<IndirizzoSim, varchar(250),>
           ,T_Sim.Codice [CodiceSim]							--<CodiceSim, varchar(50),>
           ,T_Sim.Descrizione [DescrizioneSim]					--<DescrizioneSim, varchar(50),>
           ,T_CentroRaccolta.Codice [CodiceCentroRaccolta]				--<CodiceCentroRaccolta, varchar(50),>
           ,T_CentroRaccolta.Descrizione [DescrizioneCentroRaccolta]			--<DescrizioneCentroRaccolta, varchar(50),>
           ,'boh' [IndirizzoCentroRaccolta]			--<IndirizzoCentroRaccolta, varchar(250),>
           ,getdate() [DataImport]						--<DataImport, datetime2(7),>
           ,'cippalippa.pdf' [NomeFile]							--<NomeFile, varchar(250),>
           ,1 [FlagAggiornamentoCompletato]		--<FlagAggiornamentoCompletato, bit,>
           ,'' [CodiceSimulaMaxFunds]			--<CodiceSimulaMaxFunds, int,>)

from T_R_Incarico_Mandato

left join T_Mandato on T_Mandato.IdMandato = T_R_Incarico_Mandato.IdMandato
left JOIN T_Dossier on T_Dossier.IdDossier = T_Mandato.IdDossier
left join T_Promotore on T_Dossier.IdPromotore = T_Promotore.IdPromotore
 
left JOIN T_CentroRaccolta on T_Promotore.IdCentroRaccolta = T_CentroRaccolta.IdCentroRaccolta
left JOIN T_AreaCentroRaccolta on T_AreaCentroRaccolta.IdAreaCentroRaccolta = T_CentroRaccolta.IdAreaCentroRaccolta
left JOIN T_Sim on T_AreaCentroRaccolta.IdSim = T_Sim.IdSim
 
left JOIN T_Persona on T_Promotore.IdPersona = T_Persona.IdPersona
 
WHERE IdIncarico = 4424327--4424325  

