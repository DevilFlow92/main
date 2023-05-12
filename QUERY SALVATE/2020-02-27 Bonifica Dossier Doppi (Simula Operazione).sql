USE CLC_Cesam
GO

BEGIN


--SELECT NumeroDossier, IdDossier, * FROM app.V_ImportSimulaOperazione_DatiProduzione
--JOIN L_ImportSimula ON V_ImportSimulaOperazione_DatiProduzione.IdImportSimula = L_ImportSimula.IdImportSimula
--JOIN L_ImportSimulaOperazione ON L_ImportSimula.IdImportSimula = L_ImportSimulaOperazione.IdImportSimula
--WHERE CodiceSimula = 1964233

DECLARE @IdImportsimulaOperazione INT
,@TARGET VARCHAR(20)

DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR

SELECT DISTINCT T_Dossier.NumeroDossier
--TOP 1000
--*
FROM app.V_ImportSimulaOperazione_DatiProduzione
JOIN T_Dossier on app.V_ImportSimulaOperazione_DatiProduzione.IdDossier = T_Dossier.IdDossier
--JOIN L_ImportSimula on app.V_ImportSimulaOperazione_DatiProduzione.IdImportSimula = L_ImportSimula.IdImportSimula
WHERE IdImportSimulaOperazione = 3822833

GROUP BY IdImportSimulaOperazione, T_Dossier.NumeroDossier
HAVING COUNT(T_Dossier.IdDossier) > 1

ORDER BY NumeroDossier DESC

OPEN cur

FETCH NEXT FROM cur INTO @TARGET

WHILE @@FETCH_STATUS = 0 
BEGIN


	EXEC orga.CESAM_AZ_BonificaDossierDoppi	@NumeroMandato = ''
										,@NumeroDossier = @target

	FETCH NEXT FROM cur INTO @TARGET
	
END

CLOSE cur
DEALLOCATE cur

END

--SELECT * FROM E_SocietaProdottoAzimut
--JOIN E_MacroProdottoAzimut ON E_SocietaProdottoAzimut.IdSocietaProdottoAzimut = E_MacroProdottoAzimut.IdSocietaProdottoAzimut
--JOIN E_R_MacroProdottoAzimut_ProdottoAzimut ON E_MacroProdottoAzimut.IdMacroProdottoAzimut = E_R_MacroProdottoAzimut_ProdottoAzimut.IdMacroProdottoAzimut
--JOIN E_ProdottoAzimut ON E_R_MacroProdottoAzimut_ProdottoAzimut.IdProdottoAzimut = E_ProdottoAzimut.IdProdottoAzimut

--WHERE --E_SocietaProdottoAzimut.Descrizione = 'JPMORGAN AM'
----AND E_ProdottoAzimut.Descrizione LIKE 'jpm%tot%emergin%mark%d%'
--Isin = 'LU0432979614'

