
update gvt_bankslip set status= 'T', PPDD_DATE = (sysdate + 15) where bill_ref_no in (select bill_ref_no from g0013798sql.DQ_BOLETO_NAO_GERADO where status = 0);

commit;

select count(*) from g0013798sql.DQ_BOLETO_NAO_GERADO where status = 0 and DATA_MOVIMENTO > trunc(sysdate- 9) 


select * from gvt_bankslip where bill_ref_no = 132866933

select * from gvt_exec_arg where nome_programa = 'PLCON_0001' and FLG_UTILIZADO = 'N'