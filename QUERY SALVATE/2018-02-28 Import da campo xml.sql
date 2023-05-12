USE DataExchangeAzimut_QTask

;
WITH estraz
AS
(SELECT
	MsgId
	,CAST(MsgBody AS XML) msgxml
	 ,QueuedDate
	 ,ReceivedDate
	 ,LastElabDate
	FROM IN_Elab_MessageQueue
	WHERE MsgStatus = 5
	)


SELECT
	MsgId
   ,estraz.msgxml.value('(/MessaggioAzimut/InserimentoOperazione/CodiceTipoOperazione)[1]', 'varchar(20)') CodiceTipoOperazione
   ,estraz.msgxml.value('(/MessaggioAzimut/InserimentoOperazione/DataCaricamento)[1]', 'varchar(50)') DataCaricamento
	--,doc.col.value('CodiceCliente[1]'  , 'varchar(20)') CodiceCliente
   ,estraz.msgxml.value('(/MessaggioAzimut/InserimentoOperazione/CodiceSimula)[1]', 'varchar(20)') CodiceSimula
   ,estraz.msgxml.value('(/MessaggioAzimut/InserimentoOperazione/CodiceDossier)[1]', 'varchar(20)') CodiceDossier
   ,estraz.msgxml.value('(/MessaggioAzimut/InserimentoOperazione/ElencoOperazioni/Operazione/CodiceMandato)[1]', 'varchar(20)') CodiceMandato
   --,msgxml
   ,QueuedDate
   ,ReceivedDate
   ,LastElabDate
FROM estraz



