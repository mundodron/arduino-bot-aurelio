select * from gvt_rajadas_bill where status = 777 and account_no is not null

select * from cmf_balance where account_no = 4189141 and bill_ref_no = 101132507

select b.* -- G.EXTERNAL_ID, G.account_no, G.BILL_REF_NO, B.NEW_CHARGES, G.MSG
  from cmf_balance B,
       gvt_rajadas_bill G
 where B.ACCOUNT_NO = G.ACCOUNT_NO
   and B.BILL_REF_NO = G.BILL_REF_NO
   and G.status = 777
   and G.account_no is not null
   and NEW_CHARGES in (select TOTAL_PAID*-1 from cmf_balance D where d.account_no = B.ACCOUNT_NO and bill_ref_no = 0)
   
   
   select * from cmf_balance where account_no = 3409601 and bill_ref_no = 101132507
   
   
   


