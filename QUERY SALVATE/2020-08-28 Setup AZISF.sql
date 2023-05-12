USE clc
GO

;WITH incarichi AS (
SELECT 57 CodTipoIncarico , 655 CodTipoIncaricoClone UNION
select 102 CodTipoIncarico, 656 CodTipoIncaricoClone union
select 167 CodTipoIncarico, 657 CodTipoIncaricoClone union
select 173 CodTipoIncarico, 658 CodTipoIncaricoClone union
select 175 CodTipoIncarico, 659 CodTipoIncaricoClone union
select 178 CodTipoIncarico, 660 CodTipoIncaricoClone union
select 572 CodTipoIncarico, 661 CodTipoIncaricoClone
)

INSERT INTO export.Z_Cliente_TipoIncarico_TipoDocumento 
SELECT CodCliente, CodTipoIncaricoClone , CodSistemaEsterno, CodiceTipoDocumentoCliente, CodTipoDocumento, CodiceAggiuntivoCliente, CodStatoWorkflowIncarico, CodAttributoIncarico, Leading_refCode, FlagDocumentoPrincipale
FROM export.Z_Cliente_TipoIncarico_TipoDocumento
JOIN incarichi ON Z_Cliente_TipoIncarico_TipoDocumento.CodTipoIncarico = incarichi.CodTipoIncarico
WHERE CodCliente = 23
AND CodSistemaEsterno = 5


/*
fatto
57 Gestione Sepa
655 Gestione Sepa - AZISF

fatto
102	Switch Previdenza
656	Switch Previdenza - AZISF

(fatto da ale)
167	Sottoscrizioni Previdenza
657	Sottoscrizioni Previdenza - AZISF

fatto
173	Disinvestimenti Previdenza
658	Disinvestimenti Previdenza - AZISF

(fatto)
175	Successioni - Previdenza
659	Successioni - Previdenza - AZISF

(lo fa ale) --> fatto da ale, check Attività pianificate e controlli
178	Varie Previdenza
660	Varie Previdenza - AZISF

fatto
572	Sottoscrizioni Previdenza - Zenith
661	Sottoscrizioni Previdenza - Zenith - AZISF
*/


--EXEC orga.AP_ClonaSetupIncarichi @CodCliente = 23
--								,@CodTipoIncarico = 572
--								,@Server = 'vp-btsql02'
--								,@Database = 'clc'
--								,@Schema = 'dbo'
--								,@NuovoCliente = 23
--								,@NuovoTipoIncarico = 661


SELECT * FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
WHERE CodCliente = 23 AND CodTipoIncarico = 178

SELECT * FROM R_Cliente_TipoIncarico_TipoAttivitaPianificata
WHERE CodCliente = 23 AND CodTipoIncarico = 660
	

SELECT * FROM R_Transizione_AttivitaPianificata
WHERE CodCliente = 23 AND CodTipoIncarico = 178


SELECT * FROM S_MacroControllo JOIN S_Controllo ON S_MacroControllo.IdMacroControllo = S_Controllo.IdTipoMacroControllo
WHERE CodCliente = 23 AND CodTipoIncarico = 178


--3106


	 /*gruppo tabelle setup Generale incarichi */ --------------------------------Z_Cliente_TipoIncarico--------------------------------

--INSERT INTO Z_Cliente_TipoIncarico (CodCliente, CodSistemaEsterno, CodiceTipoIncaricoCliente, CodTipoIncarico, CodiceClasseProdottoDispositiveCliente)
--	SELECT
--		23
--	   ,CodSistemaEsterno
--	   ,CodiceTipoIncaricoCliente
--	   ,661
--	   ,CodiceClasseProdottoDispositiveCliente
--	FROM [VP-BTSQL02].CLC.dbo.Z_Cliente_TipoIncarico
--	WHERE CodTipoIncarico = 572
--	AND CodCliente = 23




