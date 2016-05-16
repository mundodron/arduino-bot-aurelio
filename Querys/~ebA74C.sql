update gvt_exec_arg set FLG_UTILIZADO = 'S' where nome_programa = 'PL0300';

update gvt_exec_arg set FLG_UTILIZADO = 'N' where NUM_EXECUCAO in (41260,41490);
commit; 


select * from payment_trans order by CHG_DATE desc]


select * from gvt_exec_arg where nome_programa = 'PL0300' and FLG_UTILIZADO = 'N'
