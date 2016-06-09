select sum(valor/100), cenario from view_cdr_em_erro where tipo_erro = 440 group by cenario order by 1 desc

--Não existe no Kenan - RETAIL


