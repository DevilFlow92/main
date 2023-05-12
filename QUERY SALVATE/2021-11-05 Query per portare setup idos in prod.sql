--db-clc-prodbt
USE SELFID
GO

DECLARE @IdProcesso INT 
,@IdParametriAutenticazioneNamirial INT

--1 ROW
UPDATE S_Processo
SET CodTipoIncarico = 617
WHERE IdProcesso = 16 

--1 ROW
INSERT INTO S_ParametriAutenticazioneNamirial (NomeOrganizzazioneNamirial, IndirizzoMail)
	VALUES ('3whkuemxgu7b296b8us4nez4vq0g12sf', 'lorenzo.fiori@gruppomol.it');

SET @IdParametriAutenticazioneNamirial = (SELECT SCOPE_IDENTITY())

--1 ROW
INSERT INTO S_Processo ( DescrizioneProcesso, CodSistema, IdBanca, CodCliente, CodTipoIncarico, IdRegolaControllo, FunctionRecuperoCredenzialiFirma, IdParametriAutenticazioneNamirial, FlagPrecompilazioneEsclusivaOperatore, PercorsoRelativoTemplate, IdDatiAggiuntivi, IdAbilitazioneRiepilogoPratica, PercorsoImmaginiGuidaScattaFoto, FlagVisualizzaLoaderScattaFoto, FlagAbilitaLogInputCampiPrecompilazione)
SELECT DescrizioneProcesso, CodSistema, IdBanca, CodCliente, CodTipoIncarico, IdRegolaControllo, FunctionRecuperoCredenzialiFirma
,@IdParametriAutenticazioneNamirial IdParametriAutenticazioneNamirial
, FlagPrecompilazioneEsclusivaOperatore, PercorsoRelativoTemplate, IdDatiAggiuntivi, IdAbilitazioneRiepilogoPratica, PercorsoImmaginiGuidaScattaFoto, FlagVisualizzaLoaderScattaFoto, FlagAbilitaLogInputCampiPrecompilazione  
FROM [DB-CLC-SETUPBT].selfid.dbo.S_Processo
WHERE codcliente = 23
AND codtipoincarico = 776

SET @IdProcesso = (SELECT SCOPE_IDENTITY())

--1 ROW
INSERT INTO S_AbilitazioneUrlAccesso (IdProcesso, IdUrlAccesso)
	VALUES (@IdProcesso, 2);

--1 ROW
INSERT INTO S_ParametriFirmaDigitale (IdTemplateDocumento, NumeroPagina, PosizioneX, PosizioneY, Width, Height, CodiceDocumentoAtteso, FlagControfirma, CodiceRuoloFirmatario, ProgressivoFirmatario, IdProcesso, FlagFirmaVisibile)
SELECT IdTemplateDocumento, NumeroPagina, PosizioneX, PosizioneY, Width, Height, CodiceDocumentoAtteso, FlagControfirma, CodiceRuoloFirmatario, ProgressivoFirmatario
,@IdProcesso IdProcesso, FlagFirmaVisibile
FROM [DB-CLC-SETUPBT].selfid.dbo.S_ParametriFirmaDigitale
WHERE idprocesso = 20

-- 1 ROW
INSERT INTO S_Modulo (IdProcesso, Ordinamento, IdModuloPropedeutico, Descrizione, FlagEditabileBackOffice, CodPaginaDiRiferimento, TitoloBarraNavigazione, FlagAbilitaLoginOTPNamirial)
SELECT @IdProcesso, Ordinamento, IdModuloPropedeutico, Descrizione, FlagEditabileBackOffice, CodPaginaDiRiferimento, TitoloBarraNavigazione, FlagAbilitaLoginOTPNamirial 
FROM [DB-CLC-SETUPBT].selfid.dbo.S_Modulo
WHERE idprocesso = 20