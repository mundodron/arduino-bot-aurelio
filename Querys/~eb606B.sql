select A.conta, A.VALOR, A.FATURA, C.BILL_PERIOD CICLO, C.ACCOUNT_CATEGORY 
  from GVT_ERRO_CEF A,
       customer_id_acct_map B,
       cmf c
  where A.CONTA = B.EXTERNAL_ID
  and B.ACCOUNT_NO = C.ACCOUNT_NO
  and b.external_id_type = 1
  and B.INACTIVE_DATE is null