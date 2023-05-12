use CLC

--SELECT * FROM D_SottoMotivazioneSospeso order BY Codice DESC
--ultimo codice 523

insert into D_SottoMotivazioneSospeso (Codice,Descrizione)
VALUES (524, 'manca la scheda di approfondimento PEP')

insert INTO R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso (CodMotivazioneSospeso,CodSottoMotivazioneSospeso,CodModalitaSospeso, CodModalitaSospeso)
select CodMotivazioneSospeso
		,524
		,CodModalitaSospeso
		,FlagAttivo
FROM R_MotivazioneSospeso_SottoMotivazioneSospeso_ModalitaSospeso
where CodMotivazioneSospeso = 523



