use CLC

select * from T_Documento
			join T_Incarico on T_Documento.IdIncarico = T_Incarico.IdIncarico
 where DescrizioneCEI like '%sottoscrizione iniziale%' and T_Incarico.CodTipoIncarico = 84

select * from D_TipoIncarico where Descrizione like '%switch fondi%'
--84	Switch FONDI Investimento