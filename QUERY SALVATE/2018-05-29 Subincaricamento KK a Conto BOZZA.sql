/*
Possibili coppie master / subincarico
- Conto FEA - KK FEA
- Conto Cartaceo - KK FEA
- Conto FEA - KK Cartacea
- Conto Cartaceo - KK Cartacea


Criteri di subincaricamento (match):
Stesso Conto
Stesso IBAN --> il conto è già dentro l'IBAN...

Id Opportunità Conto = Id Opportunità Conto dentro l'incarico KK --> bisogna creare un dato aggiuntivo nuovo?

*/

--Benchmark case: Master 335, sub 378
--Incarichi di esempio 
--8804896 9909069 --prod

USE CLC
--INSERT into T_R_Incarico_SubIncarico (IdIncarico, IdSubIncarico, FlagArchiviato)

SELECT DISTINCT
	cc.IdIncarico	AS Idincarico
	,kk.idincarico	AS IdSubincarico
	,0				AS FlagArchiviato

FROM T_Incarico cc
JOIN (SELECT IdIncarico
			,CodTipoDatoAggiuntivo
			,SUBSTRING(REPLACE(REPLACE(T_DatoAggiuntivo.Testo,' ',''),CHAR(9),''),16,12) NumeroContoCC
			 from T_DatoAggiuntivo 
			 WHERE CodTipoDatoAggiuntivo IN (643
											 --,934
											 )
	  ) datocc ON datocc.IdIncarico = cc.IdIncarico

JOIN (SELECT T_Incarico.IdIncarico,
			 SUBSTRING(REPLACE(REPLACE(DatoAggiuntivoKK.Testo,' ',''),CHAR(9),''),16,12) AS NumeroConto
FROM T_Incarico
JOIN T_DatoAggiuntivo DatoAggiuntivoKK
	ON DatoAggiuntivoKK.IdIncarico = T_Incarico.IdIncarico

WHERE CodTipoIncarico = 378 --Carta di credito Fea 
AND CodArea = 8
AND DatoAggiuntivoKK.CodTipoDatoAggiuntivo IN
(643 --Iban
--,934	  --Id opportunità
)

) kk ON datocc.NumeroContoCC = kk.NumeroConto


WHERE cc.CodCliente = 48
AND cc.CodTipoIncarico = 335 --Conto Fea
AND cc.CodArea = 8

AND datocc.CodTipoDatoAggiuntivo IN
(643 --Iban
--,934 --Id opportunità
)
--AND T_Incarico.IdIncarico = 8804896


--Caso Master Conto Cartaceo, sub Carta di Credito
SELECT DISTINCT 
	CC.IdIncarico
	--CodTipoIncarico
	--,CodOggettoControlli
	,kk.IdIncarico IdSubincarico
	,0 AS FlagArchiviato
FROM T_Incarico CC
JOIN (SELECT IdIncarico
			,CodTipoDatoAggiuntivo
			,SUBSTRING(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(9), ''), 16, 12) NumeroContoCC  
		from T_DatoAggiuntivo
		WHERE CodTipoDatoAggiuntivo IN ( 643 
										--,934
										)
		) datoCC ON CC.IdIncarico = datoCC.IdIncarico

JOIN T_Documento tdocCC	ON CC.IdIncarico = tdocCC.IdIncarico
JOIN D_Documento ddocCC	ON ddocCC.Codice = tdocCC.Tipo_Documento

JOIN (SELECT DISTINCT  	T_Incarico.IdIncarico
						,SUBSTRING(REPLACE(REPLACE(T_DatoAggiuntivo.Testo, ' ', ''), CHAR(9), ''), 16, 12) NumeroContoKK
						 FROM T_Incarico 
				JOIN T_DatoAggiuntivo ON T_Incarico.IdIncarico = T_DatoAggiuntivo.IdIncarico
				JOIN T_Documento ON T_Incarico.IdIncarico = T_Documento.IdIncarico
				JOIN D_Documento on Codice = Tipo_Documento
				WHERE T_Incarico.CodArea = 8
				--riconoscere il subincarico carta di credito cartaceo
				AND T_Incarico.CodTipoIncarico = 331
				AND CodOggettoControlli = 58
				
				AND FlagPresenzaInFileSystem = 1
				AND FlagScaduto = 0
				--criteri di matching
				AND CodTipoDatoAggiuntivo IN ( 643
											--,934
											)
				) kk ON kk.NumeroContoKK = datoCC.NumeroContoCC

WHERE CC.CodArea = 8
--riconoscere il master conto cartaceo
AND CC.CodTipoIncarico = 331
AND ddocCC.CodOggettoControlli = 44
AND tdocCC.FlagPresenzaInFileSystem = 1 
AND tdocCC.FlagScaduto = 0
--criteri matching
AND datoCC.CodTipoDatoAggiuntivo = 643
AND CC.IdIncarico <> kk.IdIncarico

--AND SUBSTRING(REPLACE(REPLACE(datoCC.Testo, ' ', ''), CHAR(9), ''), 16, 12) = '100571780598'
