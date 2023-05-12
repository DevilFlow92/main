--PREPRODUZIONE
USE CLC
SELECT
	*
FROM S_DestinatarioComunicazione
WHERE DestinatarioSpecifico LIKE 'vera.verdiglione%'



UPDATE S_DestinatarioComunicazione
SET DestinatarioSpecifico = 'vera.verdiglione@onewelf.it'
WHERE IdDestinatarioComunicazione = 3482


--DEPLOY

SELECT
	*
FROM D_GruppoTabelleSetup
JOIN R_GruppoTabelleSetup_TabellaSetup
	ON D_GruppoTabelleSetup.Codice = R_GruppoTabelleSetup_TabellaSetup.CodGruppoTabelleSetup
JOIN D_TabellaSetup
	ON R_GruppoTabelleSetup_TabellaSetup.CodTabellaSetup = D_TabellaSetup.Codice
WHERE D_TabellaSetup.Descrizione = 'S_DestinatarioComunicazione'
