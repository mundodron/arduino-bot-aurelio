select B.TRACKING_ID
  from GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT <> 0
   and S.ACCOUNT_NO IS not null
   
   and S.BILL_PERIOD = 'M28'
   --and external_id = '999984786425'
   --group by B.TRACKING_ID 
  -- HAVING count(*) > 1
 
 
 select B.*
  from GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   --and B.DISTRIBUTED_AMOUNT = 0
   and external_id = '999984786425'
   and S.ACCOUNT_NO IS not null