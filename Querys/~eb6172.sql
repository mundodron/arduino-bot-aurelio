select * from all_tables where table_name like '%DACC%' 

select * from all_tables where table_name like '%GERENCIA%' 

-- GVT_DACC_GERENCIA_FILA_EVENTOS
-- GVT_DACC_GERENCIA_MET_PGTO

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999983106612'

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = '999983106612'

select * from gvt_exec_arg where  upper(nome_programa) = 'PL0300' order by NUM_EXECUCAO desc


update gvt_exec_arg set DESC_PARAMETRO '2012071911551620120720092800' where NUM_EXECUCAO = 41559 and nome_programa = 'PL0300'

update gvt_exec_arg set DESC_PARAMETRO '20120724101305' where NUM_EXECUCAO = 41302

select * from gvt_exec_arg where  upper(nome_programa) = 'PL0300' order by NUM_EXECUCAO desc

select * from gvt_exec_arg where NUM_EXECUCAO = 41302 and nome_programa = 'PL0300'

select * from gvt_exec_arg where NUM_EXECUCAO = 41562 and nome_programa = 'PL0300'

select * from gvt_exec_arg where nome_programa = 'PL0300' order by num_execucao desc


update gvt_exec_arg set DESC_PARAMETRO '20120724101305' where NUM_EXECUCAO = 41562 and nome_programa = 'PL0300';

update gvt_exec_arg set DESC_PARAMETRO '20120724101358' where NUM_EXECUCAO = 41302 and nome_programa = 'PL0300';

commit;


select * from gvt_exec_arg where  upper(nome_programa) = 'PL0300' order by NUM_EXECUCAO desc

update gvt_exec_arg set DESC_PARAMETRO '20120725093555' where plg_utilizado = 'N' and nome_programa = 'PL0300';
commit;

select * from gvt_exec_arg where nome_programa = 'PL0300' order by 1 desc;