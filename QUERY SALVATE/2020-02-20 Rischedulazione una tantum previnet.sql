BEGIN TRANSACTION

DECLARE @max INT  = (SELECT MAX(ProgressivoZip)+1 FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI)

--INSERT into export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI (documento_id, idincarico, chiavecliente, codtipoincarico, descrizioneincarico, tipo_documento, nomefile_input, idrepository, percorsocompleto, NamingCartellaZip, ProgressivoZip, nomedocumentopdf, StringaCSV, FlagUpload)
SELECT 	documento_id
		,idincarico
		,chiavecliente
		,codtipoincarico
		,descrizioneincarico
		,tipo_documento
		,nomefile_input
		,idrepository
		,percorsocompleto
		,'AZI_20200220' NamingCartellaZip
		
		,@max ProgressivoZip

		,IIF(nomedocumentopdf LIKE '%/_1' ESCAPE '/',
		SUBSTRING(nomedocumentopdf,1,LEN(nomedocumentopdf)-2) + REPLACE(RIGHT(nomedocumentopdf,2), '_1','_2'),
		 nomedocumentopdf + '_1') nomedocumentopdf

		,IIF(StringaCSV LIKE '%/_1;%' ESCAPE '/',
			REPLACE(StringaCSV,SUBSTRING(StringaCSV,1,8)+'_1',SUBSTRING(StringaCSV,1,8)+'_2'),
			REPLACE(StringaCSV,SUBSTRING(StringaCSV,1,8),SUBSTRING(StringaCSV,1,8)+'_1')
			) StringaCSV

		,0 FlagUpload		
		 
FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI
WHERE nomedocumentopdf IN ('INT_CSTMRC59C27A984N_14131978_1'
,'RI_FCHNGL51T10G566L_14015956'
,'IT_ZCCDNR84R68L219I_13924765'
,'IT_ZCCDNR84R68L219I_13924765'
,'RR_ZCCDNR84R68L219I_13924771'
,'IT_TSOMTN86B68A859V_13968608'
,'RR_TSOMTN86B68A859V_13968613'
,'IT_SSTMTT94C18D918B_13972009'
,'II_ZRZGLI94A61F770N_13987574'
,'II_CRNFNC03M24C800U_13990944'
,'RD_CSNGRG57H02F930F_13989898'
,'II_NVNMRS80C46A859F_13994024' 
)


SELECT * FROM export.CESAM_AZ_FlussoGiornaliero_Documenti_ICBPI WHERE FlagUpload = 0

--ROLLBACK TRANSACTION
COMMIT TRANSACTION


