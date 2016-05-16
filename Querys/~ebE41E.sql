select *---sum(B.DISTRIBUTED_AMOUNT)
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is null
   and B.BILL_REF_NO = 0
   and B.BMF_TRANS_TYPE <> 90
   --and B.NO_BILL = 0
   --and B.ACTION_CODE = 'APP'
   
   and S.EXTERNAL_ID = 999984786425