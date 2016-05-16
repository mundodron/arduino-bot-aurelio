select b.*
  from cmf_balance B,
       gvt_rajadas_bill G
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.BILL_REF_NO = G.BILL_REF_NO
   and G.status = 777
   and G.account_no is not null
   and G.BILL_REF_NO = 100953495
   
 -- update gvt_rajadas_bill a set a.msg = (select bill_period from cmf where account_no = A.ACCOUNT_NO) where A.STATUS = 777 
 
  select bill_period from 
  
  
  select G.EXTERNAL_ID, G.account_no, G.BILL_REF_NO, B.NEW_CHARGES VALOR, G.MSG CICLO
  from cmf_balance B,
       gvt_rajadas_bill G
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.BILL_REF_NO = G.BILL_REF_NO
   and G.status = 777
   and G.account_no is not null
   and NEW_CHARGES in (select TOTAL_PAID*-1 from cmf_balance D where d.account_no = B.ACCOUNT_NO and bill_ref_no = 0)