select *
from view_cdr_em_erro
where cenario = 'Planos descontinuados no Siebel'
and tipo_erro = 440
group by quote_designador
order by valor desc nulls last