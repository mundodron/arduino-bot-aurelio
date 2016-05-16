SELECT *
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       --WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         where /* gdgfe.aguarda_retorno = 'S'
         and  */ dt_evento >= to_date ('22/12/2011 00:00:00','dd/mm/yyyy hh24:mi:ss')
        --and length(num_cc_cartao) > 15
    ORDER BY cod_agente_arrecadador;
    
    
    select * from all_tables where table_name like '%DACC%' 
    
    select * from GVT_DACC_HIST_MET_PGTO where external_id = 999983288945
    

    
    update gvt_dacc_gerencia_fila_eventos set STATUS_EVENTO = 0 where dt_evento >= to_date ('22/12/2011 00:00:00','dd/mm/yyyy hh24:mi:ss')
    commit;
    
    update gvt_dacc_gerencia_fila_eventos set STATUS_EVENTO = 9 where external_id = 999983288945
    commit;
    
    select * from gvt_dacc_gerencia_fila_eventos  where dt_evento >= to_date ('22/12/2011 00:00:00','dd/mm/yyyy hh24:mi:ss')
    
    
    
     g0023421sql.gvt_rajadas_baixa
     
     grant all on g0023421sql.gvt_rajadas_baixa to public