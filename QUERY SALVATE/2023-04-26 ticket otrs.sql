USE OTRS_DWH
GO

  
-- Riepilogo ticket chiusi
SELECT dbo.users.login, COUNT(dbo.ticket.id) 
FROM dbo.ticket
JOIN dbo.users ON dbo.ticket.user_id = dbo.users.id
WHERE dbo.ticket.queue_id IN (
149 --DPE::DPE CESAM::CESAM::Supporto CESAM (*)
,150 --DPE::DPE CESAM::COBLENZA::Supporto COBLENZA (*)
,151) --DPE::DPE CESAM::MIKONO::Supporto MIKONO (*)
AND dbo.ticket.ticket_state_id = 2
AND dbo.ticket.customer_user_id <> 'test_coblenza'
GROUP BY dbo.users.login

