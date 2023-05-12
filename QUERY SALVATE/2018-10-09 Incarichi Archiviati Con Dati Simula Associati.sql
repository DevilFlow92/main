USE CLC
GO

SELECT DISTINCT IdOperazioneAzimut FROM rs.v_CESAM_AZ_IncarichiArchiviatiConDatiSimulaAssociati

SELECT DISTINCT IdImportSimulaOperazione FROM rs.v_CESAM_AZ_IncarichiArchiviatiConDatiSimulaAssociati


/*

--536 righe
UPDATE T_OperazioneAzimut
SET FlagAttivo = 0
FROM T_OperazioneAzimut
JOIN (SELECT DISTINCT IdOperazioneAzimut FROM rs.v_CESAM_AZ_IncarichiArchiviatiConDatiSimulaAssociati ) a ON a.idoperazioneazimut = T_OperazioneAzimut.IdOperazioneAzimut

--501 righe
UPDATE L_ImportSimulaOperazione
SET FlagAssociato = 0
FROM L_ImportSimulaOperazione
JOIN (SELECT DISTINCT IdImportSimulaOperazione FROM rs.v_CESAM_AZ_IncarichiArchiviatiConDatiSimulaAssociati) a ON a.IdImportSimulaOperazione = L_ImportSimulaOperazione.IdImportSimulaOperazione

*/

