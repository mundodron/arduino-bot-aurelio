select * from gvt_exec_arg where NOME_PROGRAMA = 'PL0300' order by DESC_PARAMETRO desc

 and NUM_EXECUCAO in (41260,41490) 


select*from gvt_config_fluxo_caixa
where BMF_TRANS_TYPE = -289


   SELECT ,'yyyymmddhh24miss') dt_inicial,
        substr(desc_parametro,15,14) dt_final
    FROM gvt_exec_arg
    WHERE num_execucao = 41254
    and upper(nome_programa) = 'PL0300';
