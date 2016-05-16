select * from GVT_DEPARA_AJUSTE_MASSIVO

select * from gvt_exec_arg where nome_programa = 'PL0300' order by 3 desc


update gvt_exec_arg set gvt_exec_arg = 'S' where nome_programa = 'PL0300';

update gvt_exec_arg set gvt_exec_arg = 'N' where NUN_execucao in (41260,41490);
commit; 


select * from gvt_exec_arg where NOME_PROGRAMA = 'PL0300' and NUM_EXECUCAO in (41260,41490) 

select * from gvt_exec_arg where nome_programa = 'PL0300' and FLG_UTILIZADO = 'N'
