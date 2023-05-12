USE OTRS_DWH
GO

SELECT TOP 1000 ticket.id IdTicket
,ticket.create_time DataCreazione
,ticket.tn TicketNumber
,ticket.title Oggetto
,queue_id
,QUEUE.name Coda
,service_id
--,SERVICE.name Service
,user_id IdOwner
,Owners.first_name + ' ' + Owners.last_name Owner
,responsible_user_id IdResponsabile
,Responsabili.first_name + ' ' + Responsabili.last_name Responsabile
,customer_id SedeMittente
,customer_user_id username
,Utenti.first_name + ' ' + Utenti.last_name Utente

,ticket.*
FROM ticket
LEFT JOIN queue ON ticket.queue_id = queue.id
--LEFT JOIN service ON ticket.service_id = service.id
LEFT JOIN users Owners ON Owners.id = ticket.user_id
LEFT JOIN users Responsabili ON ticket.responsible_user_id = Responsabili.id
LEFT JOIN users Utenti ON customer_user_id = Utenti.login
WHERE queue.name LIKE '%DPE::DPE CESAM::CESAM::Supporto CESAM (*)%'
ORDER BY 1 DESC

SELECT * FROM group_customer_user
JOIN groups ON group_customer_user.group_id = groups.id
WHERE user_id LIKE '%lai%'


--SELECT * FROM 