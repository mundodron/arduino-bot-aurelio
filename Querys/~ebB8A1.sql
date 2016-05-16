select B.ACCOUNT_NO, S.EXTERNAL_ID, S.CPF, S.VALOR, S.TELEFONE
  from g0023421sql.GVT_ERRO_SANTANDER S,
       bmf B
 where S.account_no is not null
   and S.ACCOUNT_NO = B.ACCOUNT_NO
   and S.BILL_REF_NO = B.ORIG_BILL_REF_NO
   and B.DISTRIBUTED_AMOUNT = 0
   and S.ACCOUNT_NO IS not null
   and S.EXTERNAL_ID = 999982461550
   
   select * from bill_invoice_detail
   
   
   