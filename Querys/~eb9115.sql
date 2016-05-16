delete from gvt_dacc_gerencia_met_pgto
where external_id = '999990267831'
and cod_agente_arrecadador = 341;

commit; 

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 0,
   aguarda_retorno = 'S'
where dt_evento >= to_date ('31/08/2011 00:00:00','dd/mm/yyyy hh24:mi:ss');
commit;    


select count(external_id) from gvt_dacc_gerencia_met_pgto
group by external_id 
HAVING count(external_id) > 1;


select count(external_id) from gvt_dacc_gerencia_fila_eventos
group by external_id 
HAVING count(external_id) > 1;


select * from gvt_dacc_gerencia_met_pgto

select * from gvt_dacc_gerencia_fila_eventos 

         group by external_id
         HAVING count(external_id) > 1;
         
         
select * from gvt_dacc_gerencia_met_pgto where external_id = '999989333672'

select * from gvt_dacc_gerencia_fila_eventos where external_id = '999989333672' 

update gvt_dacc_gerencia_fila_eventos 
set status_evento = 1,
   aguarda_retorno = 'N'
where external_id = '999989333672';

select * from gvt_dacc_gerencia_met_pgto where external_id = '999989333672';
