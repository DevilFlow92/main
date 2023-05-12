SELECT * FROM rs.v_Mikono_Vontobel_KPI_Storico
WHERE datareport = '20220913'

USE clc

SELECT * FROM pycc.E_VontobelKPI vtb
JOIN pycc.E_Meta ON meta_id = E_Meta.id
WHERE pycc.E_Meta.file_date = '20220913'


SELECT * FROM scratch.L_CESAM_AZ_Import_AnagraficaConsulenti
WHERE scratch.L_CESAM_AZ_Import_AnagraficaConsulenti.Cod_PF = 'C149'

USE clc

SELECT TOP 1000 * FROM pycc.E_Links
ORDER BY 1 DESC

WHERE msgs_table = 'E_VontobelKPI'

SELECT * FROM rs.L_Import_Mikono_SaldiQuote_SaldiLiquidi_Antana

