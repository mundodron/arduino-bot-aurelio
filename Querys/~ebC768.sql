select * -- B.GL_AMOUNT, B.DISTRIBUTED_AMOUNT, B.EXTERNAL_AMOUNT
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and B.DISTRIBUTED_AMOUNT <> 0
   
   select * from cmf_balance where bill_ref_no = 111897959
   
   select * from cmf_balance where account_no = 4511465
   
   select * from bmf where account_no = 3818523 and bill_ref_no = 111923056
   
   select b.*
     from GVT_ERRO_SANTANDER S,
          cmf_balance b
    where S.ACCOUNT_NO = B.ACCOUNT_NO
      and B.BILL_REF_NO = 0
      and S.TELEFONE = 'ND'