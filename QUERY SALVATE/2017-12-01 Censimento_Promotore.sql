use CLC
select* from T_Persona
where ChiaveCliente='402211959'
--se non è presente la chiave cliente, allora:

select* from T_Promotore
where codice='L282582'
--se non è presente il codice promotore nemmeno su sql, allora:

select* from T_Persona
where cognome like '%CALVA%' and nome like '%FEDERICO%'
--salvare l'id persona

--a questo punto verificare se esiste tra i promotori del database:
select* from T_Promotore
where IdPersona=3479824

--salvare l'id promotore. A questo punto cerchiamo quali incarichi sono associati:
select * from T_R_Incarico_Promotore
where IdPromotore=5296

--copia uno degli incarichi a caso. Ora puoi andare su Qtask e censire il promotore!
