select A.conta, A.VALOR, A.FATURA, C.BILL_PERIOD CICLO, C.ACCOUNT_CATEGORY 
  from GVT_ERRO_CEF A,
       cmf c
  where A.status = C.ACCOUNT_NO
  
  group by conta HAVING COUNT(1) >1
  
  select * from GVT_ERRO_CEF
  
  select * from customer_id_acct_map where external_id = '999987706210'
  
  select Conta, Valor, fatura, ciclo, account_category from GVT_ERRO_CEF where status is not null order by account_category, ciclo


