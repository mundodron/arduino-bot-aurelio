SELECT rowid, arg.* FROM  gvt_exec_arg arg where nome_programa = upper('pl0201') order by num_execucao desc

select * from gvt_bankslip where bill_ref_no in (132328170,132776934,132851860,132947730,133861957,134226056,134585563,134668854)

select * from gvt_bankslip where trunc(DATA_MOVIMENTO) = to_date('2013/01/29', 'yyyy/mm/dd') or trunc(DATA_MOVIMENTO) = to_date('2013/02/01', 'yyyy/mm/dd')

select * from gvt_bankslip where bill_ref_no in (select bill_ref_no from g0013798sql.DQ_BOLETO_NAO_GERADO where status = 0)
and bill_ref_no = 133705689