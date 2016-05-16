select B.TRACKING_ID
  from GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null