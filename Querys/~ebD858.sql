select *
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   and B.BILL_REF_NO = 0
   and B.BMF_TRANS_TYPE = -300
   and S.BILL_PERIOD = 'M28'
   
   and S.EXTERNAL_ID = 999984786425
   
   
    select bill_period, Count(*)
   from GVT_ERRO_SANTANDER
   where account_no is not null
  group by bill_period