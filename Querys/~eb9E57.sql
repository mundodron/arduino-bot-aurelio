update gvt_bankslip set status= 'T', PPDD_DATE = (sysdate + 15) where bill_ref_no in (select bill_ref_no from g0013798sql.DQ_BOLETO_NAO_GERADO where status = 0);

commit;


select * from gvt_bankslip where bill_ref_no = 114699309

update gvt_bankslip set status= 'T', PPDD_DATE = (sysdate + 15) where bill_ref_no = 114699309


select * from gvt_exec_arg where nome_programa = 'PL0201'