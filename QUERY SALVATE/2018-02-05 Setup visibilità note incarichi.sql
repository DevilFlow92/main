use CLC

--SELECT * FROM D_TipoNotaIncarichi order BY Codice desc

--insert into D_TipoNotaIncarichi (Codice,Descrizione, CodCategoriaNotaIncarichi)

--VALUES (308,'Nota del Tester',1)

SELECT
	*
FROM R_ProfiloAccesso_CategoriaNotaIncarichi
WHERE CodProfiloAccesso = 839


--INSERT INTO R_Cliente_TipoIncarico_TipoNotaIncarichi (CodCliente,CodTipoIncarico,CodTipoNotaIncarichi)
--VALUES (48,331,308)

--INSERT into R_ProfiloAccesso_TipoNotaIncarichi (CodProfiloAccesso,CodTipoNotaIncarichi)
--VALUES (839,308)





