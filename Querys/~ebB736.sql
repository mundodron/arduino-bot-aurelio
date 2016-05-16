select sum(B.GL_AMOUNT), sum(B.DISTRIBUTED_AMOUNT), sum(replace(substr(MSG,58,6),',')) as total 
  from GVT_ERRO_SANTANDER S,
       bmf b
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and B.ORIG_BILL_REF_NO = S.BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT is not null
   --and B.BILL_REF_NO = 0
   and S.TELEFONE = 'ND'
   and B.NO_BILL = 0
   and B.DISTRIBUTED_AMOUNT <> 0
   --and S.bill_ref_no = 112144018