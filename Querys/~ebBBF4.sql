select B.*
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   and S.ACCOUNT_NO = 4483252
   
   ;
   -- 269
   
   SELECT account_no FROM BMF WHERE TRACKING_ID IN
(select B.TRACKING_ID
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null);
   -- 629
   
   
   