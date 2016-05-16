select * -- sum(B.DISTRIBUTED_AMOUNT)
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and B.DISTRIBUTED_AMOUNT <> 0
   
   group by B.BILL_REF_NO
   
   
   and S.EXTERNAL_ID = 999984786425
   
select * from cmf_balance where 