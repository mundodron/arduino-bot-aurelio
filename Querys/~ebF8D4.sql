select B.*
  from g0023421SQL.GVT_ERRO_SANTANDER S,
       cmf_balance b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.BILL_REF_NO = S.BILL_REF_NO
   and B.ACCOUNT_NO = S.ACCOUNT_NO
   and B.DISPUTE_AMT <> 0

   and S.EXTERNAL_ID = 999984786425
   
select * from cmf_balance where account_no = 3997993 and bill_ref_no = 113556654
   

   select distinct(account_no) from GVT_ERRO_SANTANDER
   
   select distinct(account_no) from GVT_ERRO_SANTANDER where account_no is not null