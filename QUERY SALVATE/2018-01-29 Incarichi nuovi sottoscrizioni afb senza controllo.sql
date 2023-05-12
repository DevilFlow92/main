use CLC



/* INCARICHI CHE, UNA VOLTA VARIATI IN SOTTOSCRIZIONI AFB, NON HANNO IL CONTROLLO
SULLA PRESA INFORMATIVA PRELIMINARE
*/

--SELECT * FROM S_MacroControllo where Descrizione like '%preliminare%'
----id: 646

--SELECT * FROM R_Transizione_MacroControllo where IdTipoMacroControllo = 646

SELECT

T_Incarico.IdIncarico,* FROM T_Incarico 

join T_AttivitaPianificataIncarico on T_Incarico.IdIncarico = T_AttivitaPianificataIncarico.IdIncarico
LEFT JOIN T_R_Incarico_Controllo on T_Incarico.IdIncarico = T_R_Incarico_Controllo.IdIncarico
left JOIN T_Controllo on T_Controllo.IdControllo = T_R_Incarico_Controllo.IdControllo
where 
CodArea = 8 AND
T_Incarico.DataCreazione >= '2018-01-15' AND 
CodTipoIncarico = 321
and CodTipoAttivitaPianificata = 552  --variazionetipoincarico
 --IdIncarico = 9653869 
 AND T_R_Incarico_Controllo.IdControllo is null
--AND (T_R_Incarico_Controllo.IdControllo IS NULL 
--OR T_Controllo.IdTipoControllo = 2200) --controllo presa visione informativa preliminare
