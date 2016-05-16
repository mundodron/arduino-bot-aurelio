select * from gvt_exec_arg where  upper(nome_programa) = 'PL0300' and num_execucao = 2461



   SELECT to_date(substr(desc_parametro,1,14),'yyyymmddhh24miss') dt_inicial,
        substr(desc_parametro,15,14) dt_final
    FROM gvt_exec_arg
    WHERE num_execucao in (2461,2462, 2460)
    and upper(nome_programa) = 'PL0300';
    
    
    select * from gvt_exec_arg where  upper(nome_programa) = 'PL0300' order by NUM_EXECUCAO
    
    
    select * from 