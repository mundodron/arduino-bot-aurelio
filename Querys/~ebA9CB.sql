  select * from customer_id_acct_map where external_id = '999987706210'
  
    select * from GVT_ERRO_CEF where conta = '999987706210'
    
    select A.conta, A.VALOR, A.FATURA, C.BILL_PERIOD CICLO, C.ACCOUNT_CATEGORY 
  from GVT_ERRO_CEF A,
       cmf c
  where A.status = C.ACCOUNT_NO
  
    update GVT_ERRO_CEF a set a.CICLO = (select BILL_PERIOD from cmf where account_no = a.STATUS)
    
      update GVT_ERRO_CEF a set a.ACCOUNT_CATEGORY = (select ACCOUNT_CATEGORY from cmf where account_no = a.STATUS)
      
      select Conta, Valor, fatura, ciclo, account_category from GVT_ERRO_CEF where status is not null order by account_category, ciclo
      
      select Conta, Valor, fatura, ciclo, account_category from GVT_ERRO_CEF where status is not null order by account_category, ciclo