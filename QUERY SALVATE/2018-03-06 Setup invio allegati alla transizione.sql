use CLC
GO

SELECT D_Documento.Descrizione, T_Documento.Dimensione, * 

FROM T_Documento 
join D_Documento on Codice = Tipo_Documento
where IdIncarico = 9506319 --9825870

--9527314
--9693580
--9813053



SELECT * FROM R_TemplateComunicazione_TransizioneIncarico
where CodCliente = 48 
and CodTipoIncarico = 331 
and CodStatoWorkflowDestinazione = 14300

--quali sono i documenti che dovrebbero essere inviati mancanti?

select * FROM D_Documento where Descrizione LIKE 'Attestato avvenuta consegna informativa pre%'
--8274	Attestato avvenuta consegna informativa pre-contrattuale Conto Yellow
--10048	Attestato avvenuta consegna informativa pre-contrattuale Conto Digital
--20015	Attestato avvenuta consegna informativa pre-contrattuale Conto Tascabile

--verifica che ci sia il setup:
SELECT
	*
FROM R_TemplateComunicazione_Documento
JOIN D_Documento
	ON Codice = CodDocumento
WHERE IdTemplateComunicazione = 8835
AND CodDocumento IN (8274	
					 ,10048
					 ,20015)

--manca il 20015 --> Tascabile


--fare il setup in preproduzione
use CLC

--insert into R_TemplateComunicazione_Documento (IdTemplateComunicazione,CodDocumento, Ordinamento, DescrizioneAllegato)
--VALUES (8835,20015,null,null)


