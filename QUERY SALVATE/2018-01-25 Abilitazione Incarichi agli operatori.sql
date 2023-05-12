--Perché un operatore non vede gli incarichi?
--cercare il suo profilo accesso
use CLC

SELECT
	*
FROM S_Operatore
WHERE Cognome LIKE '%timpano%'
AND Nome LIKE '%fede%'
--935

--poi cercare quali tipi di incarico può vedere
SELECT
	*
FROM R_ProfiloAccesso_AbilitazioneIncarico
WHERE CodProfiloAccesso = 935

--oppure verificare direttamente se, inserito il tipo di incarico che non riesce a vedere, compaiono righe
SELECT
	*
FROM R_ProfiloAccesso_AbilitazioneIncarico
WHERE CodProfiloAccesso = 935
AND CodTipoIncarico = 193

--se non compaiono righe, significa che non ha i privilegi abilitati, se compaiono righe, c'è un problema di qtask.



--ABILITAZIONE VISIONE DI UN INCARICO

--preproduzione (vp-btsql02)
USE clc

INSERT INTO R_ProfiloAccesso_AbilitazioneIncarico (CodProfiloAccesso, CodCliente, CodTipoIncarico)
	VALUES (935, 23, 193)

--quali tabelle trasferire?
SELECT
	*
FROM D_GruppoTabelleSetup
LEFT JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice

WHERE D_TabellaSetup.Descrizione = 'R_ProfiloAccesso_AbilitazioneIncarico'

--abilitazioni operatori q_task