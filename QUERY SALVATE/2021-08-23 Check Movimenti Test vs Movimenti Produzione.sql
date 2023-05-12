USE clc


DECLARE @ABI VARCHAR(10) = '05034'
--'03479'
,@CAB VARCHAR(10) = '11701'
--'01600'
,@NumeroConto VARCHAR(50) = '70040'

,@DataImportProd DATETIME = '2021-09-14'
,@DataImportTest DATETIME = '2021-09-14'

-- connettiti a server testinterno: db-clc-testint
--movimenti in produzione
SELECT NumeroConto, Abi, Cab, Testo,  DataValuta, DataOperazione, ImportoMovimento_62--, 'PROD' AMBIENTE

FROM [DB-CLC-PRODBT].clc.dbo.T_MovimentoContoBancario tmcb
JOIN [DB-CLC-PRODBT].clc.dbo.T_ContoBancarioPerAnno tcbpa ON tmcb.IdContoBancarioPerAnno = tcbpa.IdContoBancarioPerAnno
AND tcbpa.anno = 2021
AND tmcb.IdMovimentoContoBancarioMaster IS NULL
--AND tmcb.FlagAttivo = 1
JOIN [DB-CLC-PRODBT].clc.dbo.T_Incarico ti ON tcbpa.IdIncarico = ti.IdIncarico
AND ti.CodCliente = 23 AND ti.CodArea = 8 AND ti.CodTipoIncarico = 337
JOIN [DB-CLC-PRODBT].clc.dbo.T_ContoBancario tcb ON tcbpa.IdContoBancario = tcb.IdContoBancario
--AND tcb.abi = '03479' AND tcb.cab = '01600' --AND tcb.NumeroConto = '802258100'
AND tcb.Abi = @ABI AND tcb.Cab = @CAB AND tcb.NumeroConto = @NumeroConto
JOIN [DB-CLC-PRODBT].CLC.dbo.T_NotaIncarichi tni ON tmcb.IdNotaIncarichi = tni.IdNotaIncarichi
JOIN [DB-CLC-PRODBT].CLC.scratch.T_R_ImportRendicontazione_Movimento trimportmovimento ON tmcb.IdMovimentoContoBancario = trimportmovimento.IdMovimentoContoBancario
JOIN [DB-CLC-PRODBT].CLC.scratch.L_Import_Rendicontazione_FlussoCBI cbi ON cbi.IdImport_RendicontazioneBP = trimportmovimento.IdImport_Rendicontazione

WHERE tmcb.DataImport >= @DataImportProd AND tmcb.DataImport < DATEADD(DAY,1,@DataImportProd)


EXCEPT
--movimenti in test interno
SELECT NumeroConto, Abi, Cab, Testo,  DataValuta, DataOperazione, ImportoMovimento_62--, 'TEST' AMBIENTE
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND anno = 2021
AND IdMovimentoContoBancarioMaster IS NULL 
--AND FlagAttivo = 1
JOIN T_Incarico ON T_ContoBancarioPerAnno.IdIncarico = T_Incarico.IdIncarico
AND CodCliente = 23
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND Abi = @ABI AND Cab = @CAB AND NumeroConto = @NumeroConto
JOIN T_NotaIncarichi ON T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi
JOIN scratch.T_R_ImportRendicontazione_Movimento ON T_MovimentoContoBancario.IdMovimentoContoBancario = T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario
JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
WHERE 
T_MovimentoContoBancario.DataImport >= @DataImportTest AND T_MovimentoContoBancario.DataImport < DATEADD(DAY,1,@DataImportTest)
--DataImport >= '2021-08-16' AND DataImport < '2021-08-17'


--movimenti in test interno
SELECT NumeroConto, Abi, Cab, Testo,  DataValuta, DataOperazione, ImportoMovimento_62--, 'TEST' AMBIENTE
FROM T_MovimentoContoBancario
JOIN T_ContoBancarioPerAnno ON T_MovimentoContoBancario.IdContoBancarioPerAnno = T_ContoBancarioPerAnno.IdContoBancarioPerAnno
AND anno = 2021
AND IdMovimentoContoBancarioMaster IS NULL 
AND FlagAttivo = 1
JOIN T_Incarico ON T_ContoBancarioPerAnno.IdIncarico = T_Incarico.IdIncarico
AND CodCliente = 23
JOIN T_ContoBancario ON T_ContoBancarioPerAnno.IdContoBancario = T_ContoBancario.IdContoBancario
AND Abi = @ABI AND Cab = @CAB AND NumeroConto = @NumeroConto
JOIN T_NotaIncarichi ON T_MovimentoContoBancario.IdNotaIncarichi = T_NotaIncarichi.IdNotaIncarichi
JOIN scratch.T_R_ImportRendicontazione_Movimento ON T_MovimentoContoBancario.IdMovimentoContoBancario = T_R_ImportRendicontazione_Movimento.IdMovimentoContoBancario
JOIN scratch.L_Import_Rendicontazione_FlussoCBI ON IdImport_RendicontazioneBP = IdImport_Rendicontazione
WHERE
T_MovimentoContoBancario.DataImport >= @DataImportTest AND T_MovimentoContoBancario.DataImport < DATEADD(DAY,1,@DataImportTest)

EXCEPT

--MOVIMENTI PRODUZIONE
SELECT NumeroConto, Abi, Cab, Testo,  DataValuta, DataOperazione, ImportoMovimento_62--, 'PROD' AMBIENTE

FROM [DB-CLC-PRODBT].clc.dbo.T_MovimentoContoBancario tmcb
JOIN [DB-CLC-PRODBT].clc.dbo.T_ContoBancarioPerAnno tcbpa ON tmcb.IdContoBancarioPerAnno = tcbpa.IdContoBancarioPerAnno
AND tcbpa.anno = 2021
AND tmcb.IdMovimentoContoBancarioMaster IS NULL
AND tmcb.FlagAttivo = 1
JOIN [DB-CLC-PRODBT].clc.dbo.T_Incarico ti ON tcbpa.IdIncarico = ti.IdIncarico
AND ti.CodCliente = 23 AND ti.CodArea = 8 AND ti.CodTipoIncarico = 337
JOIN [DB-CLC-PRODBT].clc.dbo.T_ContoBancario tcb ON tcbpa.IdContoBancario = tcb.IdContoBancario
AND tcb.Abi = @ABI AND tcb.Cab = @CAB AND tcb.NumeroConto = @NumeroConto
JOIN [DB-CLC-PRODBT].CLC.dbo.T_NotaIncarichi tni ON tmcb.IdNotaIncarichi = tni.IdNotaIncarichi
JOIN [DB-CLC-PRODBT].CLC.scratch.T_R_ImportRendicontazione_Movimento trimportmovimento ON tmcb.IdMovimentoContoBancario = trimportmovimento.IdMovimentoContoBancario
JOIN [DB-CLC-PRODBT].CLC.scratch.L_Import_Rendicontazione_FlussoCBI cbi ON cbi.IdImport_RendicontazioneBP = trimportmovimento.IdImport_Rendicontazione

WHERE tmcb.DataImport >= @DataImportProd AND tmcb.DataImport < DATEADD(DAY,1,@DataImportProd)



