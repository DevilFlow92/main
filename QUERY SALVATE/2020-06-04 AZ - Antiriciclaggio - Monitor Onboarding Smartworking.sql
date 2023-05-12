USE CLC
GO

--SELECT 	IdIncarico
--		,DataCreazioneQTask
--		,CodTipoIncarico
--		,TipoIncaricoQTask
--		,DataOnboarding
--		,Settimana
--		,CodiceClienteFEND
--		,TipoCanale
--		,FlagSmartworking 
--FROM rs.v_CESAM_AZ_Monitoring_Onboarding_Smartworking
--WHERE DataOnboarding >= '2020-06-01'

--ALTER VIEW rs.v_CESAM_AZ_Monitoring_Onboarding_Smartworking AS 


WITH smartworking AS (
SELECT '20200414' Data, '000708062' ndg union all
SELECT '20200414' Data, '000708078' ndg union all
SELECT '20200414' Data, '000708079' ndg union all
SELECT '20200414' Data, '000708083' ndg union all
SELECT '20200414' Data, '000708075' ndg union all
SELECT '20200415' Data, '000708113' ndg union all
SELECT '20200415' Data, '000708108' ndg union all
SELECT '20200415' Data, '000708109' ndg union all
SELECT '20200415' Data, '000708111' ndg union all
SELECT '20200415' Data, '000708112' ndg union all
SELECT '20200415' Data, '000708102' ndg union all
SELECT '20200415' Data, '000708117' ndg union all
SELECT '20200415' Data, '000708116' ndg union all
SELECT '20200415' Data, '000708115' ndg union all
SELECT '20200415' Data, '000708114' ndg union all
SELECT '20200415' Data, '000658962' ndg union all
SELECT '20200415' Data, '000708148' ndg union all
SELECT '20200415' Data, '000708142' ndg union all
SELECT '20200415' Data, '000708145' ndg union all
SELECT '20200415' Data, '000708149' ndg union all
SELECT '20200416' Data, '000708149' ndg union all
SELECT '20200416' Data, '000468386' ndg union all
SELECT '20200416' Data, '000708160' ndg union all
SELECT '20200416' Data, '000708161' ndg union all
SELECT '20200416' Data, '000708162' ndg union all
SELECT '20200416' Data, '000708164' ndg union all
SELECT '20200416' Data, '000708167' ndg union all
SELECT '20200416' Data, '000708168' ndg union all
SELECT '20200416' Data, '000708176' ndg union all
SELECT '20200416' Data, '000708180' ndg union all
SELECT '20200416' Data, '000708182' ndg union all
SELECT '20200416' Data, '000708190' ndg union all
SELECT '20200416' Data, '000708188' ndg union all
SELECT '20200416' Data, '000708183' ndg union all
SELECT '20200416' Data, '000708179' ndg union all
SELECT '20200416' Data, '000708177' ndg union all
SELECT '20200416' Data, '000708193' ndg union all
SELECT '20200416' Data, '000708191' ndg union all
SELECT '20200417' Data, '000708196' ndg union all
SELECT '20200417' Data, '000708197' ndg union all
SELECT '20200417' Data, '000708198' ndg union all
SELECT '20200417' Data, '000506802' ndg union all
SELECT '20200417' Data, '000708200' ndg union all
SELECT '20200417' Data, '000708201' ndg union all
SELECT '20200417' Data, '000708202' ndg union all
SELECT '20200417' Data, '000708203' ndg union all
SELECT '20200417' Data, '000708204' ndg union all
SELECT '20200417' Data, '000708205' ndg union all
SELECT '20200417' Data, '000708209' ndg union all
SELECT '20200417' Data, '000463882' ndg union all
SELECT '20200417' Data, '000708213' ndg union all
SELECT '20200417' Data, '000708212' ndg union all
SELECT '20200417' Data, '000708214' ndg union all
SELECT '20200417' Data, '000708215' ndg union all
SELECT '20200417' Data, '000708220' ndg union all
SELECT '20200417' Data, '000708221' ndg union all
SELECT '20200417' Data, '000708228' ndg union all
SELECT '20200417' Data, '000708222' ndg union all
SELECT '20200417' Data, '000708223' ndg union all
SELECT '20200417' Data, '000708247' ndg union all
SELECT '20200417' Data, '000708240' ndg union all
SELECT '20200417' Data, '000708225' ndg union all
SELECT '20200417' Data, '000708227' ndg union all
SELECT '20200417' Data, '000685194' ndg union all
SELECT '20200417' Data, '000708236' ndg union all
SELECT '20200417' Data, '000708238' ndg union all
SELECT '20200417' Data, '000708241' ndg union all
SELECT '20200417' Data, '000708245' ndg union all
SELECT '20200417' Data, '000708248' ndg union all
SELECT '20200417' Data, '000708230' ndg union all
SELECT '20200417' Data, '000708235' ndg union all
SELECT '20200417' Data, '000708239' ndg union all
SELECT '20200417' Data, '000708250' ndg union all
SELECT '20200417' Data, '000708253' ndg union all
SELECT '20200417' Data, '000708249' ndg union all
SELECT '20200417' Data, '000708251' ndg union all
SELECT '20200417' Data, '000708252' ndg union all
SELECT '20200417' Data, '000708254' ndg union all
SELECT '20200420' Data, '000708255' ndg union all
SELECT '20200420' Data, '000708256' ndg union all
SELECT '20200420' Data, '000708217' ndg union all
SELECT '20200420' Data, '000708318' ndg union all
SELECT '20200420' Data, '000708309' ndg union all
SELECT '20200420' Data, '000708237' ndg union all
SELECT '20200420' Data, '000708294' ndg union all
SELECT '20200420' Data, '000708284' ndg union all
SELECT '20200420' Data, '000708290' ndg union all
SELECT '20200420' Data, '000708272' ndg union all
SELECT '20200420' Data, '000224497' ndg union all
SELECT '20200420' Data, '000708265' ndg union all
SELECT '20200420' Data, '000708270' ndg union all
SELECT '20200420' Data, '000708293' ndg union all
SELECT '20200420' Data, '000708267' ndg union all
SELECT '20200420' Data, '000708268' ndg union all
SELECT '20200420' Data, '000708283' ndg union all
SELECT '20200420' Data, '000708274' ndg union all
SELECT '20200420' Data, '000708273' ndg union all
SELECT '20200420' Data, '000708295' ndg union all
SELECT '20200420' Data, '000708285' ndg union all
SELECT '20200420' Data, '000708278' ndg union all
SELECT '20200420' Data, '000708271' ndg union all
SELECT '20200420' Data, '000708292' ndg union all
SELECT '20200420' Data, '000708291' ndg union all
SELECT '20200420' Data, '000708263' ndg union all
SELECT '20200420' Data, '000708260' ndg union all
SELECT '20200421' Data, '000708327' ndg union all
SELECT '20200422' Data, '000708364' ndg union all
SELECT '20200422' Data, '000708348' ndg union all
SELECT '20200422' Data, '000708328' ndg union all
SELECT '20200422' Data, '000708374' ndg union all
SELECT '20200422' Data, '000708373' ndg union all
SELECT '20200422' Data, '000708338' ndg union all
SELECT '20200422' Data, '000708361' ndg union all
SELECT '20200422' Data, '000708336' ndg union all
SELECT '20200422' Data, '000708335' ndg union all
SELECT '20200422' Data, '000708341' ndg union all
SELECT '20200422' Data, '000708340' ndg union all
SELECT '20200422' Data, '000708354' ndg union all
SELECT '20200422' Data, '000708351' ndg union all
SELECT '20200422' Data, '000708308' ndg union all
SELECT '20200422' Data, '000708377' ndg union all
SELECT '20200422' Data, '000708379' ndg union all
SELECT '20200422' Data, '000708376' ndg union all
SELECT '20200422' Data, '000708378' ndg union all
SELECT '20200422' Data, '000708380' ndg union all
SELECT '20200422' Data, '000708381' ndg union all
SELECT '20200422' Data, '000708382' ndg union all
SELECT '20200422' Data, '000708383' ndg union all
SELECT '20200422' Data, '000708386' ndg union all
SELECT '20200422' Data, '000708387' ndg union all
SELECT '20200422' Data, '000708388' ndg union all
SELECT '20200422' Data, '000708389' ndg union all
SELECT '20200422' Data, '000708475' ndg union all
SELECT '20200422' Data, '000708493' ndg union all
SELECT '20200422' Data, '000708494' ndg union all
SELECT '20200422' Data, '000708495' ndg union all
SELECT '20200422' Data, '000708496' ndg union all
SELECT '20200422' Data, '000105437' ndg union all
SELECT '20200422' Data, '000708491' ndg union all
SELECT '20200422' Data, '000708477' ndg union all
SELECT '20200422' Data, '000708480' ndg union all
SELECT '20200422' Data, '000708483' ndg union all
SELECT '20200422' Data, '000708484' ndg union all
SELECT '20200422' Data, '000708339' ndg union all
SELECT '20200422' Data, '000708392' ndg union all
SELECT '20200422' Data, '000708310' ndg union all
SELECT '20200423' Data, '000708325' ndg union all
SELECT '20200423' Data, '000708524' ndg union all
SELECT '20200423' Data, '000708512' ndg union all
SELECT '20200423' Data, '000708513' ndg union all
SELECT '20200423' Data, '000708517' ndg union all
SELECT '20200423' Data, '000708521' ndg union all
SELECT '20200423' Data, '000708526' ndg union all
SELECT '20200423' Data, '000708519' ndg union all
SELECT '20200423' Data, '000708523' ndg union all
SELECT '20200423' Data, '000708515' ndg union all
SELECT '20200423' Data, '000708527' ndg union all
SELECT '20200423' Data, '000708303' ndg union all
SELECT '20200423' Data, '000708531' ndg union all
SELECT '20200423' Data, '000708529' ndg union all
SELECT '20200423' Data, '000708528' ndg union all
SELECT '20200423' Data, '000708525' ndg union all
SELECT '20200423' Data, '000708520' ndg union all
SELECT '20200423' Data, '000708516' ndg union all
SELECT '20200423' Data, '000708530' ndg union all
SELECT '20200423' Data, '000708533' ndg union all
SELECT '20200423' Data, '000708535' ndg union all
SELECT '20200423' Data, '000708536' ndg union all
SELECT '20200423' Data, '000708537' ndg union all
SELECT '20200423' Data, '000708541' ndg union all
SELECT '20200423' Data, '000708545' ndg union all
SELECT '20200423' Data, '000708546' ndg union all
SELECT '20200423' Data, '000708566' ndg union all
SELECT '20200423' Data, '000708571' ndg union all
SELECT '20200423' Data, '000708575' ndg union all
SELECT '20200423' Data, '000708577' ndg union all
SELECT '20200423' Data, '000708579' ndg union all
SELECT '20200423' Data, '000303559' ndg union all
SELECT '20200423' Data, '000708583' ndg union all
SELECT '20200423' Data, '000708582' ndg union all
SELECT '20200424' Data, '000708607' ndg union all
SELECT '20200424' Data, '000702366' ndg union all
SELECT '20200424' Data, '000708609' ndg union all
SELECT '20200424' Data, '000574525' ndg union all
SELECT '20200424' Data, '000481841' ndg union all
SELECT '20200424' Data, '000708619' ndg union all
SELECT '20200424' Data, '000298592' ndg union all
SELECT '20200424' Data, '000708645' ndg union all
SELECT '20200424' Data, '000285457' ndg union all
SELECT '20200424' Data, '000708626' ndg union all
SELECT '20200427' Data, '000708651' ndg union all
SELECT '20200427' Data, '000708655' ndg union all
SELECT '20200427' Data, '000708669' ndg union all
SELECT '20200427' Data, '000708605' ndg union all
SELECT '20200427' Data, '000708671' ndg union all
SELECT '20200427' Data, '000463909' ndg union all
SELECT '20200427' Data, '000024104' ndg union all
SELECT '20200427' Data, '000708682' ndg union all
SELECT '20200427' Data, '000708674' ndg union all
SELECT '20200427' Data, '000708683' ndg union all
SELECT '20200427' Data, '000521976' ndg union all
SELECT '20200427' Data, '000708678' ndg union all
SELECT '20200427' Data, '000708688' ndg union all
SELECT '20200427' Data, '000708684' ndg union all
SELECT '20200427' Data, '000708692' ndg union all
SELECT '20200427' Data, '000708689' ndg union all
SELECT '20200428' Data, '000708606' ndg union all
SELECT '20200428' Data, '000708695' ndg union all
SELECT '20200428' Data, '000708694' ndg union all
SELECT '20200428' Data, '000708696' ndg union all
SELECT '20200428' Data, '000708697' ndg union all
SELECT '20200428' Data, '000708701' ndg union all
SELECT '20200428' Data, '000708702' ndg union all
SELECT '20200428' Data, '000708704' ndg union all
SELECT '20200428' Data, '000708705' ndg union all
SELECT '20200428' Data, '000708706' ndg union all
SELECT '20200428' Data, '000708707' ndg union all
SELECT '20200428' Data, '000708709' ndg union all
SELECT '20200428' Data, '000708710' ndg union all
SELECT '20200428' Data, '000708712' ndg union all
SELECT '20200428' Data, '000708713' ndg union all
SELECT '20200428' Data, '000708714' ndg union all
SELECT '20200428' Data, '000708717' ndg union all
SELECT '20200428' Data, '000708719' ndg union all
SELECT '20200428' Data, '000240014' ndg union all
SELECT '20200428' Data, '000708735' ndg union all
SELECT '20200428' Data, '000708733' ndg union all
SELECT '20200428' Data, '000708732' ndg union all
SELECT '20200428' Data, '000708734' ndg union all
SELECT '20200428' Data, '000708737' ndg union all
SELECT '20200428' Data, '000112572' ndg union all
SELECT '20200428' Data, '000708746' ndg union all
SELECT '20200428' Data, '000708744' ndg union all
SELECT '20200428' Data, '000708742' ndg union all
SELECT '20200428' Data, '000708747' ndg union all
SELECT '20200428' Data, '000708752' ndg union all
SELECT '20200428' Data, '000708751' ndg union all
SELECT '20200428' Data, '000708756' ndg union all
SELECT '20200428' Data, '000708757' ndg union all
SELECT '20200428' Data, '000708759' ndg union all
SELECT '20200428' Data, '000708107' ndg union all
SELECT '20200428' Data, '000708390' ndg union all
SELECT '20200429' Data, '000708767' ndg union all
SELECT '20200429' Data, '000708768' ndg union all
SELECT '20200429' Data, '000708807' ndg union all
SELECT '20200429' Data, '000708788' ndg union all
SELECT '20200429' Data, '000708789' ndg union all
SELECT '20200429' Data, '000708792' ndg union all
SELECT '20200429' Data, '000708799' ndg union all
SELECT '20200429' Data, '000708812' ndg union all
SELECT '20200430' Data, '000697385' ndg union all
SELECT '20200430' Data, '000708329' ndg union all
SELECT '20200430' Data, '000708039' ndg union all
SELECT '20200430' Data, '000708827' ndg union all
SELECT '20200430' Data, '000708829' ndg union all
SELECT '20200430' Data, '000708828' ndg union all
SELECT '20200430' Data, '000708826' ndg union all
SELECT '20200430' Data, '000708835' ndg union all
SELECT '20200430' Data, '000708834' ndg union all
SELECT '20200430' Data, '000708830' ndg union all
SELECT '20200430' Data, '000708833' ndg union all
SELECT '20200430' Data, '000708670' ndg union all
SELECT '20200430' Data, '000708870' ndg union all
SELECT '20200430' Data, '000708837' ndg union all
SELECT '20200430' Data, '000708840' ndg union all
SELECT '20200430' Data, '000708841' ndg union all
SELECT '20200430' Data, '000708847' ndg union all
SELECT '20200430' Data, '000708851' ndg union all
SELECT '20200430' Data, '000708855' ndg union all
SELECT '20200430' Data, '000708858' ndg union all
SELECT '20200430' Data, '000708864' ndg union all
SELECT '20200430' Data, '000708865' ndg union all
SELECT '20200430' Data, '000708867' ndg union all
SELECT '20200430' Data, '000708869' ndg union all
SELECT '20200430' Data, '000708872' ndg union all
SELECT '20200430' Data, '000708846' ndg union all
SELECT '20200430' Data, '000708823' ndg union all
SELECT '20200430' Data, '000708880' ndg union all
SELECT '20200504' Data, '000388487' ndg union all
SELECT '20200504' Data, '000708910' ndg union all
SELECT '20200504' Data, '000708908' ndg union all
SELECT '20200504' Data, '000708907' ndg union all
SELECT '20200504' Data, '000708893' ndg union all
SELECT '20200504' Data, '000708896' ndg union all
SELECT '20200504' Data, '000708930' ndg union all
SELECT '20200504' Data, '000708941' ndg union all
SELECT '20200504' Data, '000708917' ndg union all
SELECT '20200504' Data, '000708926' ndg union all
SELECT '20200504' Data, '000708937' ndg union all
SELECT '20200504' Data, '000708913' ndg union all
SELECT '20200504' Data, '000708924' ndg union all
SELECT '20200504' Data, '000708935' ndg union all
SELECT '20200504' Data, '000708920' ndg union all
SELECT '20200504' Data, '000708942' ndg union all
SELECT '20200504' Data, '000708915' ndg union all
SELECT '20200504' Data, '000708934' ndg union all
SELECT '20200504' Data, '000708925' ndg union all
SELECT '20200504' Data, '000708943' ndg union all
SELECT '20200504' Data, '000708939' ndg union all
SELECT '20200504' Data, '000708936' ndg union all
SELECT '20200504' Data, '000708933' ndg union all
SELECT '20200504' Data, '000708931' ndg union all
SELECT '20200504' Data, '000708929' ndg union all
SELECT '20200504' Data, '000708921' ndg union all
SELECT '20200504' Data, '000708927' ndg union all
SELECT '20200504' Data, '000095607' ndg union all
SELECT '20200504' Data, '000708928' ndg union all
SELECT '20200504' Data, '000708938' ndg union all
SELECT '20200504' Data, '000437816' ndg union all
SELECT '20200505' Data, '000708959' ndg union all
SELECT '20200505' Data, '000708960' ndg union all
SELECT '20200505' Data, '000708961' ndg union all
SELECT '20200505' Data, '000708955' ndg union all
SELECT '20200505' Data, '000708964' ndg union all
SELECT '20200505' Data, '000708974' ndg union all
SELECT '20200505' Data, '000679180' ndg union all
SELECT '20200505' Data, '000708988' ndg union all
SELECT '20200505' Data, '000708975' ndg union all
SELECT '20200505' Data, '000708978' ndg union all
SELECT '20200505' Data, '000708979' ndg union all
SELECT '20200505' Data, '000708992' ndg union all
SELECT '20200505' Data, '000708994' ndg union all
SELECT '20200505' Data, '000688959' ndg union all
SELECT '20200505' Data, '000708995' ndg union all
SELECT '20200505' Data, '000708996' ndg union all
SELECT '20200505' Data, '000708997' ndg union all
SELECT '20200505' Data, '000708998' ndg union all
SELECT '20200506' Data, '000709010' ndg union all
SELECT '20200506' Data, '000709013' ndg union all
SELECT '20200506' Data, '000666718' ndg union all
SELECT '20200506' Data, '000709017' ndg union all
SELECT '20200506' Data, '000709024' ndg union all
SELECT '20200506' Data, '000317877' ndg union all
SELECT '20200506' Data, '000709001' ndg union all
SELECT '20200506' Data, '000709002' ndg union all
SELECT '20200506' Data, '000709027' ndg union all
SELECT '20200506' Data, '000709029' ndg union all
SELECT '20200506' Data, '000709030' ndg union all
SELECT '20200506' Data, '000709032' ndg union all
SELECT '20200506' Data, '000709035' ndg union all
SELECT '20200506' Data, '000709031' ndg union all
SELECT '20200506' Data, '000709037' ndg union all
SELECT '20200506' Data, '000708977' ndg union all
SELECT '20200506' Data, '000709048' ndg union all
SELECT '20200506' Data, '000709049' ndg union all
SELECT '20200506' Data, '000502979' ndg union all
SELECT '20200506' Data, '000709045' ndg union all
SELECT '20200506' Data, '000451276' ndg union all
SELECT '20200507' Data, '000709072' ndg union all
SELECT '20200507' Data, '000709075' ndg union all
SELECT '20200507' Data, '000709078' ndg union all
SELECT '20200507' Data, '000709082' ndg union all
SELECT '20200507' Data, '000709062' ndg union all
SELECT '20200507' Data, '000709064' ndg union all
SELECT '20200507' Data, '000709068' ndg union all
SELECT '20200507' Data, '000709069' ndg union all
SELECT '20200507' Data, '000709057' ndg union all
SELECT '20200507' Data, '000709056' ndg union all
SELECT '20200507' Data, '000709107' ndg union all
SELECT '20200507' Data, '000709114' ndg union all
SELECT '20200507' Data, '000709116' ndg union all
SELECT '20200507' Data, '000709106' ndg union all
SELECT '20200507' Data, '000709109' ndg union all
SELECT '20200507' Data, '000709110' ndg union all
SELECT '20200508' Data, '000709149' ndg union all
SELECT '20200508' Data, '000709137' ndg union all
SELECT '20200508' Data, '000709134' ndg union all
SELECT '20200508' Data, '000709133' ndg union all
SELECT '20200508' Data, '000709132' ndg union all
SELECT '20200508' Data, '000709131' ndg union all
SELECT '20200508' Data, '000709180' ndg union all
SELECT '20200508' Data, '000709177' ndg union all
SELECT '20200508' Data, '000709175' ndg union all
SELECT '20200508' Data, '000709172' ndg union all
SELECT '20200508' Data, '000709166' ndg union all
SELECT '20200508' Data, '000709161' ndg union all
SELECT '20200508' Data, '000709153' ndg union all
SELECT '20200508' Data, '000709151' ndg union all
SELECT '20200508' Data, '000709185' ndg union all
SELECT '20200508' Data, '000709178' ndg union all
SELECT '20200508' Data, '000709167' ndg union all
SELECT '20200511' Data, '000509944' ndg union all
SELECT '20200511' Data, '000582485' ndg union all
SELECT '20200511' Data, '000709191' ndg union all
SELECT '20200511' Data, '000709193' ndg union all
SELECT '20200511' Data, '000709194' ndg union all
SELECT '20200511' Data, '000709209' ndg union all
SELECT '20200511' Data, '000709214' ndg union all
SELECT '20200511' Data, '000562348' ndg union all
SELECT '20200511' Data, '000709223' ndg union all
SELECT '20200511' Data, '000709222' ndg union all
SELECT '20200511' Data, '000709219' ndg union all
SELECT '20200511' Data, '000124926' ndg union all
SELECT '20200511' Data, '000709199' ndg union all
SELECT '20200511' Data, '000709096' ndg union all
SELECT '20200512' Data, '000048512' ndg union all
SELECT '20200512' Data, '000709234' ndg union all
SELECT '20200512' Data, '000709236' ndg union all
SELECT '20200512' Data, '000709233' ndg union all
SELECT '20200512' Data, '000699261' ndg union all
SELECT '20200512' Data, '000709255' ndg union all
SELECT '20200512' Data, '000709260' ndg union all
SELECT '20200512' Data, '000709243' ndg union all
SELECT '20200512' Data, '000709245' ndg union all
SELECT '20200512' Data, '000709251' ndg union all
SELECT '20200512' Data, '000701940' ndg union all
SELECT '20200512' Data, '000709275' ndg union all
SELECT '20200513' Data, '000708144' ndg union all
SELECT '20200513' Data, '000708243' ndg union all
SELECT '20200513' Data, '000708304' ndg union all
SELECT '20200513' Data, '000708305' ndg union all
SELECT '20200513' Data, '000708307' ndg union all
SELECT '20200513' Data, '000708322' ndg union all
SELECT '20200513' Data, '000708572' ndg union all
SELECT '20200513' Data, '000708646' ndg union all
SELECT '20200513' Data, '000227745' ndg union all
SELECT '20200513' Data, '000227744' ndg union all
SELECT '20200513' Data, '000709242' ndg union all
SELECT '20200513' Data, '000305865' ndg union all
SELECT '20200513' Data, '000700525' ndg union all
SELECT '20200513' Data, '000709313' ndg union all
SELECT '20200513' Data, '000709316' ndg union all
SELECT '20200513' Data, '000709320' ndg union all
SELECT '20200513' Data, '000709322' ndg union all
SELECT '20200513' Data, '000709332' ndg union all
SELECT '20200513' Data, '000709335' ndg union all
SELECT '20200513' Data, '000709350' ndg union all
SELECT '20200513' Data, '000709331' ndg union all
SELECT '20200513' Data, '000709352' ndg union all
SELECT '20200513' Data, '000709348' ndg union all
SELECT '20200513' Data, '000709340' ndg union all
SELECT '20200513' Data, '000709342' ndg union all
SELECT '20200513' Data, '000709343' ndg union all
SELECT '20200513' Data, '000709321' ndg union all
SELECT '20200513' Data, '000709354' ndg union all
SELECT '20200513' Data, '000709356' ndg union all
SELECT '20200513' Data, '000709317' ndg union all
SELECT '20200514' Data, '000709391' ndg union all
SELECT '20200514' Data, '000133780' ndg union all
SELECT '20200514' Data, '000709382' ndg union all
SELECT '20200514' Data, '000709381' ndg union all
SELECT '20200514' Data, '000709379' ndg union all
SELECT '20200514' Data, '000709394' ndg union all
SELECT '20200514' Data, '000709399' ndg union all
SELECT '20200514' Data, '000709406' ndg union all
SELECT '20200514' Data, '000709402' ndg union all
SELECT '20200514' Data, '000709396' ndg union all
SELECT '20200514' Data, '000705627' ndg union all
SELECT '20200514' Data, '000516252' ndg union all
SELECT '20200514' Data, '000709388' ndg union all
SELECT '20200514' Data, '000709386' ndg union all
SELECT '20200514' Data, '000709419' ndg union all
SELECT '20200514' Data, '000709390' ndg union all
SELECT '20200515' Data, '000709454' ndg union all
SELECT '20200515' Data, '000709336' ndg union all
SELECT '20200515' Data, '000688875' ndg union all
SELECT '20200515' Data, '000709503' ndg union all
SELECT '20200515' Data, '000709502' ndg union all
SELECT '20200515' Data, '000709493' ndg union all
SELECT '20200515' Data, '000709495' ndg union all
SELECT '20200515' Data, '000709499' ndg union all
SELECT '20200515' Data, '000709500' ndg union all
SELECT '20200515' Data, '000709485' ndg union all
SELECT '20200515' Data, '000709489' ndg union all
SELECT '20200515' Data, '000709511' ndg union all
SELECT '20200515' Data, '000516823' ndg union all
SELECT '20200515' Data, '000709521' ndg union all
SELECT '20200515' Data, '000709516' ndg union all
SELECT '20200515' Data, '000709519' ndg union all
SELECT '20200515' Data, '000709525' ndg union all
SELECT '20200515' Data, '000709513' ndg union all
SELECT '20200515' Data, '000709527' ndg union all
SELECT '20200518' Data, '000709594' ndg union all
SELECT '20200518' Data, '000709593' ndg union all
SELECT '20200518' Data, '000709564' ndg union all
SELECT '20200518' Data, '000709589' ndg union all
SELECT '20200518' Data, '000709550' ndg union all
SELECT '20200518' Data, '000709544' ndg union all
SELECT '20200518' Data, '000709542' ndg union all
SELECT '20200518' Data, '000709541' ndg union all
SELECT '20200518' Data, '000709554' ndg union all
SELECT '20200520' Data, '000709627' ndg union all
SELECT '20200520' Data, '000709630' ndg union all
SELECT '20200520' Data, '000709637' ndg union all
SELECT '20200520' Data, '000518144' ndg union all
SELECT '20200520' Data, '000678119' ndg union all
SELECT '20200520' Data, '000709612' ndg union all
SELECT '20200520' Data, '000709659' ndg union all
SELECT '20200520' Data, '000709651' ndg union all
SELECT '20200520' Data, '000709676' ndg union all
SELECT '20200520' Data, '000709682' ndg union all
SELECT '20200520' Data, '000709687' ndg union all
SELECT '20200520' Data, '000053416' ndg union all
SELECT '20200520' Data, '000709734' ndg union all
SELECT '20200520' Data, '000709722' ndg union all
SELECT '20200520' Data, '000595356' ndg union all
SELECT '20200520' Data, '000709707' ndg union all
SELECT '20200520' Data, '000709701' ndg union all
SELECT '20200520' Data, '000709700' ndg union all
SELECT '20200520' Data, '000709699' ndg union all
SELECT '20200520' Data, '000709698' ndg union all
SELECT '20200520' Data, '000709697' ndg union all
SELECT '20200520' Data, '000709696' ndg union all
SELECT '20200520' Data, '000709695' ndg union all
SELECT '20200520' Data, '000709737' ndg union all
SELECT '20200520' Data, '000709735' ndg union all
SELECT '20200520' Data, '000709732' ndg union all
SELECT '20200520' Data, '000709741' ndg union all
SELECT '20200520' Data, '000709740' ndg union all
SELECT '20200520' Data, '000709745' ndg union all
SELECT '20200520' Data, '000709746' ndg union all
SELECT '20200520' Data, '000709310' ndg union all
SELECT '20200521' Data, '000709346' ndg union all
SELECT '20200521' Data, '000709813' ndg union all
SELECT '20200521' Data, '000709829' ndg union all
SELECT '20200521' Data, '000709833' ndg union all
SELECT '20200521' Data, '000709831' ndg union all
SELECT '20200521' Data, '000505889' ndg union all
SELECT '20200521' Data, '000709796' ndg union all
SELECT '20200521' Data, '000709784' ndg union all
SELECT '20200521' Data, '000709785' ndg union all
SELECT '20200521' Data, '000709788' ndg union all
SELECT '20200521' Data, '000709772' ndg union all
SELECT '20200521' Data, '000709767' ndg union all
SELECT '20200521' Data, '000709769' ndg union all
SELECT '20200522' Data, '000709842' ndg union all
SELECT '20200522' Data, '000709849' ndg union all
SELECT '20200522' Data, '000709852' ndg union all
SELECT '20200522' Data, '000709856' ndg union all
SELECT '20200522' Data, '000709844' ndg union all
SELECT '20200522' Data, '000709843' ndg union all
SELECT '20200522' Data, '000709858' ndg union all
SELECT '20200522' Data, '000709862' ndg union all
SELECT '20200522' Data, '000709865' ndg union all
SELECT '20200522' Data, '000709857' ndg union all
SELECT '20200522' Data, '000709867' ndg union all
SELECT '20200522' Data, '000709860' ndg union all
SELECT '20200522' Data, '000709898' ndg union all
SELECT '20200522' Data, '000709893' ndg union all
SELECT '20200522' Data, '000709883' ndg union all
SELECT '20200522' Data, '000709888' ndg union all
SELECT '20200522' Data, '000709869' ndg union all
SELECT '20200522' Data, '000709909' ndg union all
SELECT '20200522' Data, '000709894' ndg union all
SELECT '20200522' Data, '000709913' ndg union all
SELECT '20200522' Data, '000709914' ndg union all
SELECT '20200522' Data, '000709890' ndg union all
SELECT '20200525' Data, '000709961' ndg union all
SELECT '20200525' Data, '000709949' ndg union all
SELECT '20200525' Data, '000709945' ndg union all
SELECT '20200525' Data, '000709950' ndg union all
SELECT '20200525' Data, '000709937' ndg union all
SELECT '20200525' Data, '000709938' ndg union all
SELECT '20200525' Data, '000709996' ndg union all
SELECT '20200526' Data, '000710032' ndg union all
SELECT '20200526' Data, '000710038' ndg union all
SELECT '20200526' Data, '000710043' ndg union all
SELECT '20200526' Data, '000710048' ndg union all
SELECT '20200526' Data, '000710052' ndg union all
SELECT '20200526' Data, '000710024' ndg union all
SELECT '20200526' Data, '000522443' ndg union all
SELECT '20200526' Data, '000710012' ndg union all
SELECT '20200527' Data, '000520489' ndg union all
SELECT '20200527' Data, '000710147' ndg union all
SELECT '20200527' Data, '000710151' ndg union all
SELECT '20200527' Data, '000710046' ndg union all
SELECT '20200528' Data, '000710161' ndg union all
SELECT '20200528' Data, '000710223' ndg union all
SELECT '20200528' Data, '000710193' ndg union all
SELECT '20200528' Data, '000710189' ndg union all
SELECT '20200528' Data, '000710188' ndg union all
SELECT '20200528' Data, '000710197' ndg union all
SELECT '20200528' Data, '000710185' ndg union all
SELECT '20200529' Data, '000707552' ndg union all
SELECT '20200529' Data, '000710288' ndg union all
SELECT '20200529' Data, '000710295' ndg union all
SELECT '20200529' Data, '000710298' ndg union all
SELECT '20200529' Data, '000710296' ndg union all
SELECT '20200601' Data, '000710351' ndg union all
SELECT '20200601' Data, '000710362' ndg union all
SELECT '20200601' Data, '000695500' ndg union all
SELECT '20200601' Data, '000710332' ndg UNION ALL
select '20200603' Data, '000710448' ndg union all
select '20200603' Data, '000513352' ndg union all
select '20200603' Data, '000710437' ndg union all
select '20200603' Data, '000710422' ndg union all
select '20200603' Data, '000710519' ndg union all
select '20200603' Data, '000710516' ndg UNION all
select '20200603' Data, '000710500' ndg 

)

,QTask as (
SELECT ti.IdIncarico
,CONVERT(date,ti.DataCreazione) DataCreazioneQTask
,ti.CodTipoIncarico
,d.TipoIncarico TipoIncaricoQTask
,CONVERT(DATE,lwi.DataTransizione) DataOnboarding
,van.ChiaveClienteIntestatario CodiceClienteFEND

FROM T_Incarico ti
JOIN rs.v_CESAM_TipoIncarico_Macrostato_StatoWorkFlowIncarico d ON ti.IdIncarico = d.IdIncarico
JOIN rs.v_CESAM_Anagrafica_Cliente_Promotore van on ti.IdIncarico = van.IdIncarico
AND van.ProgressivoPersona = 1

JOIN (SELECT MAX(IdTransizione) IdTransizione ,T_Incarico.IdIncarico
		FROM L_WorkflowIncarico
		JOIN T_Incarico ON L_WorkflowIncarico.IdIncarico = T_Incarico.IdIncarico
		AND CodArea = 8 AND CodCliente = 23 AND CodTipoIncarico IN (288,396)
		WHERE CodStatoWorkflowIncaricoPartenza <> CodStatoWorkflowIncaricoDestinazione
		AND ((
				CodTipoIncarico = 396 AND CodStatoWorkflowIncaricoDestinazione = 12180 --Caricata (Onboarding Digitale)
				)
			OR (
				 CodTipoIncarico = 288 AND CodStatoWorkflowIncaricoDestinazione = 8570	-- 
				)
			)		
		GROUP BY T_Incarico.IdIncarico
) wf ON ti.IdIncarico = wf.IdIncarico
JOIN L_WorkflowIncarico lwi on wf.IdTransizione = lwi.IdTransizione

WHERE  ti.CodCliente = 23 AND ti.CodArea = 8 and ti.CodTipoIncarico in (288,396)
AND ti.DataCreazione >= '20200101'

) 
,settimane as (
SELECT CONVERT(DATE,Data) Data
,Settimana - 15 Settimana
,MIN(Data) OVER (PARTITION BY Anno,Mese,Settimana) DataInizio
,MAX(Data) OVER (PARTITION BY Anno,Mese,Settimana) DataFine
FROM rs.S_Data
WHERE Data >= '2020-04-13'
AND Anno = 2020

)
SELECT 	IdIncarico
			,DataCreazioneQTask
			,CodTipoIncarico
			,TipoIncaricoQTask
			,DataOnboarding
			,CAST(Settimana as VARCHAR(2)) + ' (' + CONVERT(VARCHAR,DataInizio,103) + ' - ' + CONVERT(VARCHAR,DataFine,103) +')' Settimana
			,CodiceClienteFEND
			,CASE CodTipoIncarico
				WHEN 288 THEN 'Tradizionale'
				WHEN 396 THEN 'FEQ'
			  END TipoCanale
			,0 FlagSmartworking
FROM QTask
LEFT JOIN smartworking on CodiceClienteFEND = ndg
JOIN settimane ON DataOnboarding = settimane.Data
WHERE ndg IS NULL
AND DataCreazioneQTask >= '2020-04-13'

UNION ALL

SELECT 	IdIncarico
		,DataCreazioneQTask
		,CodTipoIncarico
		,TipoIncaricoQTask
		,CONVERT(date,smartworking.data) DataOnboarding
		,CAST(Settimana as VARCHAR(2)) + ' (' + CONVERT(VARCHAR,DataInizio,103) + ' - ' + CONVERT(VARCHAR,DataFine,103) +')' Settimana
		,ndg CodiceClienteFEND
		,'Smartworking' TipoCanale
		,1 FlagSmartworking
FROM QTask
JOIN smartworking on CodiceClienteFEND = ndg
JOIN settimane ON CONVERT(date,smartworking.Data) = settimane.Data
WHERE IdIncarico >0

UNION ALL

SELECT 	IdIncarico
		,DataCreazioneQTask
		,CodTipoIncarico
		,TipoIncaricoQTask
		,CONVERT(date,smartworking.Data) DataOnboarding
		,CAST(Settimana as VARCHAR(2)) + ' (' + CONVERT(VARCHAR,DataInizio,103) + ' - ' + CONVERT(VARCHAR,DataFine,103) + ')' Settimana
		,ndg CodiceClienteFEND
		,'Smartworking' TipoCanale	 
		,1 FlagSmartworking
FROM smartworking
LEFT JOIN QTask on CodiceClienteFEND = ndg
JOIN settimane ON CONVERT(date,smartworking.Data) = settimane.Data
WHERE IdIncarico IS NULL

GO