select 
    query_tratamento, kenan_db_id
from sincronismo_siebel_kenan_datas
where created >= trunc(sysdate-1)
and responsavel = 'Aurelio Avanzi - Ativação de Conta'