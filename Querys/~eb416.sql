SELECT *
  FROM gvt_dacc_gerencia_fila_eventos gdgfe
 WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
   AND gdgfe.aguarda_retorno = 'S'
   
   update gvt_dacc_gerencia_fila_eventos 
set status_evento = 1,
   aguarda_retorno = 'N'
where dt_evento >= to_date ('08/08/2011 00:00:00','dd/mm/yyyy hh24:mi:ss');
commit;    

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 1,
   aguarda_retorno = 'N'
where dt_evento >= to_date ('08/08/2012 00:00:00','dd/mm/yyyy hh24:mi:ss');
commit;

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 1,
   aguarda_retorno = 'N'
where external_id = '999989333672';

commit;


