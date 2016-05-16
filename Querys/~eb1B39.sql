select * from cmf_balance_detail where bill_ref_no in (136561074,139366046,142216576);

select * from bill_invoice where bill_ref_no = 135564977;

select * from sin_seq_no where bill_ref_no in (135564977);

select * from cmf_balance where bill_ref_no in (141213493)

select *
  from GVT_INVOICE_CONTROL_DETAIL
 where GVT_ACCOUNT_TYPE = 'BOLETO'
 and bill_ref_no = 141641550
 
 select * from SIN_SEQ_NO where bill_ref_no = 135564977
 
 select * from sin_seq_no 
 where prep_date > to_date ('01/02/2013','DD/MM/YYYY') and prep_date <= to_date ('10/03/2013','DD/MM/YYYY')
   and to_char (prep_date,'MM') = 02
   and full_sin_seq like '%GO'
 order by SIN_SEQ_REF_NO desc
 
 select * from sin_seq_no where full_sin_seq = '119343-GO'
    and to_char (prep_date,'MM') = 02
    and prep_date > to_date ('01/02/2013','DD/MM/YYYY')
 
 
Update sin_seq_no set SIN_SEQ_REF_NO = 119343, SIN_SEQ_REF_RESETS = 80, FULL_SIN_SEQ = '119343-GO' where bill_ref_no = 136561074 and open_item_id = 0;
Update cmf_balance_detail set chg_date = trunc(sysdate) where bill_ref_no = 136561074;
Update cmf_balance set chg_date = trunc(sysdate) where bill_ref_no = 136561074;


select * from cmf_balance_detail where bill_ref_no = 136561074;


select *
  from GVT_INVOICE_CONTROL_DETAIL
 where gvt_date > '010113'
   and GVT_MODE = 'BOLETO'
   and bill_ref_no in (select bill_ref_no from gvt_bankslip where DATA_MOVIMENTO > to_date('01/01/2013','DD/MM/YYYY'))
   
   
   select rpad('teste', 7) from dual
   
   