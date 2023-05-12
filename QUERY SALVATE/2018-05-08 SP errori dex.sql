USE DataExchangeAzimut_QTask
GO
BEGIN
if object_id(N'tempdb.#erroriDEX',N'U') is not null
BEGIN
drop TABLE #erroriDEX
END

SELECT 	MsgId
INTO #erroriDEX
FROM IN_Elab_MessageQueue
WHERE MsgStatus = 2
AND QueuedDate >= '20180329'

DECLARE @MsgId INT

DECLARE cur CURSOR LOCAL FOR
	SELECT MsgId
	FROM #erroriDEX

OPEN cur

FETCH NEXT FROM cur INTO @MsgId

WHILE @@FETCH_STATUS = 0 BEGIN

/* riciclo messaggi dex */

INSERT INTO [dbo].[IN_MessageQueue]
           ([MsgId]
           ,[MsgBody]
           ,[MsgIdPartner]
           ,[DataFlowType]
           ,[MsgType]
           ,[MsgStatus]
           ,[NumOfAttachments]
           ,[QueuedDate]
           ,[ReceivedDate])
SELECT 
            [MsgId]
           ,[MsgBody]
           ,[MsgIdPartner]
           ,[DataFlowType]
           ,[MsgType]
           ,[MsgStatus] 
           ,[NumOfAttachments]
           ,[QueuedDate]
           ,[ReceivedDate]

FROM IN_Elab_MessageQueue WHERE MsgId = @MsgId



DELETE FROM IN_Elab_MessageQueue
WHERE IN_Elab_MessageQueue.MsgId = @MsgId



uPDATE IN_MessageQueue
SET MsgStatus = 0 WHERE MsgId = @MsgId
	

	FETCH NEXT FROM cur INTO @MsgId

END

CLOSE cur
DEALLOCATE cur

DROP TABLE #erroriDEX
;
WITH Select1
AS (SELECT
	MsgId,
	NumOfAttachments,
	MsgStatus,
	Description,
	CAST(MsgBody AS XML) MsgBodyXML,
	QueuedDate,
	ReceivedDate,
	LastElabDate

FROM IN_Elab_MessageQueue
JOIN MessageStatus
	ON MsgStatus = MessageStatus.MessageStatus
	AND MessageStatus.DataFlowType = 1
WHERE MsgStatus <> 3)


SELECT

	MsgId,
	NumOfAttachments,
	MsgStatus,
	Description,
	Select1.MsgBodyXML.value('(/MessaggioAzimut/InserimentoOperazione/CodiceTipoOperazione)[1]', 'varchar(20)') CodiceTipoOperazione,
	Select1.MsgBodyXML.value('(/MessaggioAzimut/InserimentoOperazione/CodiceTipoFea)[1]', 'smallint') CodiceTipoFea,
	Select1.MsgBodyXML.value('(/MessaggioAzimut/InserimentoOperazione/DataCaricamento)[1]', 'varchar(50)') DataCaricamento,
	Select1.MsgBodyXML.value('(/MessaggioAzimut/InserimentoOperazione/CodiceSimula)[1]', 'varchar(20)') CodiceSimula,
	Select1.MsgBodyXML.value('(/MessaggioAzimut/InserimentoOperazione/CodiceDossier)[1]', 'varchar(20)') CodiceDossier,
	Select1.MsgBodyXML.value('(/MessaggioAzimut/InserimentoOperazione/ElencoOperazioni/Operazione/CodiceMandato)[1]', 'varchar(20)') CodiceMandato,
	QueuedDate,
	ReceivedDate,
	LastElabDate

FROM Select1

WHERE QueuedDate >= '20180329'

END
GO