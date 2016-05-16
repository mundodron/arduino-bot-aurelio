select * from gvt_bankslip where bill_ref_no = 135564977

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '777777730857'

select * from cmf_balance where bill_ref_no = 135564977

select * from customer_id_acct_map where external_id = '999983023781'

select * from cmf where account_no = 4660429

select * from bill_invoice where bill_ref_no = 135564977

select * from bill_invoice where bill_ref_no = 137807444

select * from SIN_SEQ_NO where bill_ref_no = 137807444


Update sin_seq_no set SIN_SEQ_REF_NO = 105200, SIN_SEQ_REF_RESETS = 80, FULL_SIN_SEQ = '105200-ES' where bill_ref_no = 137807444 and open_item_id = 0;
Update cmf_balance_detail set chg_date = trunc(sysdate) where bill_ref_no = 137807444;
Update cmf_balance set chg_date = trunc(sysdate) where bill_ref_no = 137807444;




select * from sin_seq_no 
 where prep_date > to_date ('01/02/2013','DD/MM/YYYY') and prep_date <= to_date ('28/02/2013','DD/MM/YYYY')
   and to_char (prep_date,'MM') = 02
   and full_sin_seq like '%ES'
 order by SIN_SEQ_REF_NO desc

select to_char(sysdate,'MM') from dual

select sysdate from dual where sysdate beetween



select * from gvt_bankslip