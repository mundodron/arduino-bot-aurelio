      SELECT external_id
        --INTO v_count_external_id
        FROM customer_id_acct_map
       WHERE external_id in (SELECT   external_id
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S')
         group by external_id
         HAVING count(external_id) > 1;
         
               SELECT *
        --INTO v_count_external_id
        FROM customer_id_acct_map
       WHERE external_id ='999989333672'
       
       
       select * from gvt_dacc_gerencia_fila_eventos WHERE external_id ='999989333672'
       
      SELECT *
        --INTO v_count_external_id
        FROM customer_id_acct_map
       WHERE external_id in (SELECT   external_id
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S')
         
         
 select * from gvt_dacc_gerencia_met_pgto where external_id ='999989333672'
 
 
 
 
 SELECT *
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S'
         
         
delete from gvt_dacc_gerencia_met_pgto
where external_id = '999989333672'
and cod_agente_arrecadador = 237;

commit; 

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 1,
   aguarda_retorno = 'N'
where dt_evento >= to_date ('08/08/2011 00:00:00','dd/mm/yyyy hh24:mi:ss');
commit;    

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 0,
   aguarda_retorno = 'S'
where dt_evento >= to_date ('08/08/2012 00:00:00','dd/mm/yyyy hh24:mi:ss');
commit;

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 1,
   aguarda_retorno = 'N'
where external_id = '999989333672';

commit;


select * from bank_seqs where bank_id = 409