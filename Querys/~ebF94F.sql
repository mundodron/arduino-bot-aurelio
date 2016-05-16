select * from gvt_exec_arg where nome_programa = 'PL0201'

update gvt_exec_arg set FLG_UTILIZADO = 'S' where nome_programa = 'PL0201';

update gvt_exec_arg set FLG_UTILIZADO = 'N' where nome_programa = 'PL0201' and NUM_EXECUCAO = 35702
