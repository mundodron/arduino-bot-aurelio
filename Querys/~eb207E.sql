   SELECT ATIVO
     FROM grc_motivos_de_para gr 
    WHERE gr.motivo_grc = '361'
      and rownum = 1
      and parceiro = 2
      and status_grc = 'Rj'
      


select * from grc_servicos_prestados where motivo = '361' and data_insercao > sysdate -10


Select telefone_origem, telefone_destino, sequencial_chave, status, data_servico, hora_inicio, to_char(to_date('2000','yyyy') + ((duracao*60)/86400),'hh24:mi:ss') duracao, 
substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_real, data_insercao, tcoe
from grc_servicos_prestados 
where data_insercao > sysdate-15 
  and motivo = '361'
  and duracao_real > 9999
  and lote = 'TCOE.T211141.S01.D130215.H110110'
  
  
  select * from gvt_cobilling_operadora where cod_eot = '211'


GRC_ERROS_BMP