    Select to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss') inicio_chamada,
           to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss') + ((duracao_real*60)/86400)  fim_chamada,
           substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_chamada,
           rowid,
           sequencial_chave,
           telefone_origem,
           telefone_destino,
           data_servico,
           hora_inicio,
           duracao_real,
           parceiro
      from grc_servicos_prestados
     where 1=1 --lote = substr(file_name_tcoe, instr(file_name_tcoe, 'TCOE'), 32)
       --and status = 'AF'
      Order by telefone_origem,
               telefone_destino,
               to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss');