Select to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss') inicio_chamada,
           to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss') + 
              NUMTODSINTERVAL(substr(duracao_real,1,2), 'HOUR') +
              NUMTODSINTERVAL(substr(duracao_real,3,2), 'MINUTE') + 
              NUMTODSINTERVAL(substr(duracao_real,5,2), 'SECOND')  fim_chamada,
           substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_chamada,
           rowid,
           sequencial_chave,
           telefone_origem,
           telefone_destino,
           data_servico,
           hora_inicio,
           duracao,
           duracao_real,
           parceiro
      from grc_servicos_prestados
     where sequencial_chave = '201502231805584889762'
     --  and status = 'AF'
      Order by telefone_origem,
               telefone_destino,
               to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss');
               
               
               
   select * from grc_motivos_de_para where motivo_grc = '361' and ativo = 'S'

select * from vrc_sobreposicao_duplicada;

drop table vrc_sobreposicao_duplicada


create table vrc_sobreposicao_duplicada as
Select sequencial_chave, status, telefone_origem, telefone_destino, data_servico, hora_inicio, duracao, 
       to_char(to_date('2000','yyyy') + ((duracao*60)/86400),'hh24:mi:ss') duracao_, 
       substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_real, 
       data_insercao,
       TCOE       
from grc_servicos_prestados c
where (data_servico, hora_inicio, duracao, telefone_origem, telefone_destino) in
(Select data_servico, hora_inicio, duracao, telefone_origem, telefone_destino
from grc_servicos_prestados  a
where data_insercao >= '01/01/2015'
  and motivo = '361'
  AND Exists (select 1 from grc_servicos_prestados b 
               where b.telefone_origem = a.telefone_origem
                 and B.TELEFONE_DESTINO = a.telefone_destino
                 and b.data_servico = a.data_servico 
                 and b.hora_inicio = a.hora_inicio
                 and b.duracao = a.duracao 
                 and b.data_insercao <> a.data_insercao)
                 --and a.status <> b.status)
)
Order  by telefone_origem, telefone_destino, data_servico, hora_inicio, duracao;




Select data_servico, hora_inicio, duracao, telefone_origem, telefone_destino
from grc_servicos_prestados  a
where data_insercao >= '01/01/2015'
  and motivo = '361'
  AND not Exists (select 1 from grc_servicos_prestados b 
               where b.telefone_origem = a.telefone_origem
                 and B.TELEFONE_DESTINO = a.telefone_destino
                 and b.data_servico = a.data_servico 
                 and b.hora_inicio = a.hora_inicio
                 and b.duracao = a.duracao 
                 and b.data_insercao <> a.data_insercao)
                 --and a.status <> b.status)
)