USE DataExchangeAzimut_QTask
GO

DECLARE @messaggio INT
SET @messaggio = 49138


--INSERT INTO [dbo].[IN_MessageQueue]
--           ([MsgId]
--           ,[MsgBody]
--           ,[MsgIdPartner]
--           ,[DataFlowType]
--           ,[MsgType]
--           ,[MsgStatus]
--           ,[NumOfAttachments]
--           ,[QueuedDate]
--           ,[ReceivedDate])
--SELECT 
--            [MsgId]
--           ,[MsgBody]
--           ,[MsgIdPartner]
--           ,[DataFlowType]
--           ,[MsgType]
--           ,[MsgStatus] 
--           ,[NumOfAttachments]
--           ,[QueuedDate]
--           ,[ReceivedDate]
 
--FROM IN_Elab_MessageQueue WHERE MsgId = @messaggio



--DELETE FROM IN_Elab_MessageQueue
--WHERE IN_Elab_MessageQueue.MsgId = @messaggio



--uPDATE IN_MessageQueue
--SET MsgStatus = 0 WHERE MsgId = @messaggio









