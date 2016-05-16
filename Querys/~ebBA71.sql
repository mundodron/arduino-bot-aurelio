select * from all_tables where table_name like '%FEBRABAN%'

select account_no from GVT_FEBRABAN_ACCOUNTS

select * from gvt_exec_arg where nome_programa = 'PL0300' order by 3 desc


select * from gvt_exec_arg where NOME_PROGRAMA = 'PL0300' and NUM_EXECUCAO in (41260,41490) 