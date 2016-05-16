-- drop table vrc_sobreposicao_duplicada



create table vrc_sobreposicao_duplicada as
Select sequencial_chave, status, telefone_origem, telefone_destino, data_servico, hora_inicio, duracao, 
       to_char(to_date('2000','yyyy') + ((duracao*60)/86400),'hh24:mi:ss') duracao_, 
       substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_real, 
       data_insercao,
       TCOE       
from grc_servicos_prestados c
where (data_servico, hora_inicio, duracao, telefone_origem, telefone_destino) in
(Select * --status, data_servico, hora_inicio, duracao, telefone_origem, telefone_destino
from grc_servicos_prestados  a
where data_insercao >= '01/12/2014'
  and motivo = '361'
  AND Exists (select 1 from vrc_sobreposicao_duplicada b-- grc_servicos_prestados b 
               where b.telefone_origem = a.telefone_origem
                 and B.TELEFONE_DESTINO = a.telefone_destino
                 and b.data_servico = a.data_servico 
                 and b.hora_inicio = a.hora_inicio
                 and b.duracao = a.duracao 
                 and b.data_insercao <> a.data_insercao)
                 --and a.status <> b.status)
)
Order  by telefone_origem, telefone_destino, data_servico, hora_inicio, duracao;



Select * from vrc_sobreposicao_duplicada

select * from grc_historicos_serv_prestados where servico_prestado = sequencial order by data_alteracao;

drop table VRC_ALTERA_MOTIVO

create table VRC_ALTERA_MOTIVO as 
select 
sequencial_chave, status, telefone_origem, telefone_destino, data_servico, hora_inicio, duracao, 
       to_char(to_date('2000','yyyy') + ((duracao*60)/86400),'hh24:mi:ss') duracao_, 
       substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_real, 
       data_insercao,
       TCOE 
from grc_servicos_prestados  a
where data_insercao >= '01/12/2014'
  and motivo = '361'
  
  
  AND Exists (select 1 from vrc_sobreposicao_duplicada b-- grc_servicos_prestados b 
               where b.telefone_origem = a.telefone_origem
                 and B.TELEFONE_DESTINO = a.telefone_destino
                 and b.data_servico = a.data_servico 
                 and b.hora_inicio = a.hora_inicio
                 and b.duracao = a.duracao 
                 and b.data_insercao <> a.data_insercao)      
                 
              
                 select * from VRC_ALTERA_MOTIVO where status <> 'RJ'
                 
                 
GRANT SELECT ON VRC_ALTERA_MOTIVO TO public;

delete  VRC_ALTERA_MOTIVO a where exists (select 1 from grc_servicos_prestados b 
               where b.telefone_origem = a.telefone_origem
                 and B.TELEFONE_DESTINO = a.telefone_destino
                 and b.data_servico = a.data_servico 
                 and b.hora_inicio = a.hora_inicio
                 and b.duracao = a.duracao 
                 and b.data_insercao <> a.data_insercao
                 and b.status <> 'RJ')

select * from grc_servicos_prestados where telefone_origem = '1932534479'
and telefone_destino = 1123038381
and data_servico = '24/11/2014'
and hora_inicio = '184802'

