use clc

/*

SELECT * from D_Documento   order BY Codice DESC
--ultimo codice 20045

INSERT INTO D_Documento (Codice, Descrizione, Etichetta, CodOggettoControlli, FlagDocumentoBase,Ordinamento,FlagScanCEI)
VALUES (20046,'DocumentoPredisposizioneContoDigital_dinamico','DocumentoPredisposizioneContoDigital_dinamico',50,0,1,0) 


INSERT INTO S_TemplateDocumento (CodOggettoGenerazione, CodTipoDocumento, PercorsoFile, FlagDocx, FlagCopia)
	VALUES (1, 20046, 'CESAM\CheBanca\PredisposizioneContratto\DocumentoPredisposizioneContoDigital_dinamico.dot', 0, 0)

SELECT * FROM S_TemplateDocumento order BY IdTemplate DESC
--id template 4001

insert into R_Cliente_TipoIncarico_TipoDocumento (CodCliente,CodTipoIncarico,CodDocumento,FlagVisualizza)
VALUES (48,331,20046,1)


insert INTO R_Cliente_TemplateDocumento (IdTemplateDocumento, CodCliente,CodTipoIncarico,Priorita)
VALUES (4001,48,331,3)

*/

SELECT * FROM D_TipoDatoAggiuntivo where 


Codice >= 1103

/*
1112	Persona 3 - Privacy 1
1113	Persona 3 - Privacy 2
1114	Persona 3 - Privacy 3
1115	Persona 3 - Privacy 4
*/

/*
1116	Persona 3 - Carta Debito terzo titolare
1117	Persona 3 - Carta Credito terzo titolare
*/

/*
1143	Persona 4 - Privacy 1
1144	Persona 4 - Privacy 2
1145	Persona 4 - Privacy 3
1148	Persona 4 - Privacy 4
*/

/*
1149	Persona 4 - Carta Debito quarto titolare
1150	Persona 4 - Carta Credito quarto titolare
*/
