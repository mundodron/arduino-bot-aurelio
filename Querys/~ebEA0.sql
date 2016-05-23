select M.EXTERNAL_ID, 
       P.CUST_BANK_ACC_NUM,
       P.ACCOUNT_NO,
       M.DT_CADASTRO, 
       M.STATUS_CADASTRAMENTO, 
       M.PAY_METHOD PAY_METHOD_DACC, 
       P.PAY_METHOD PAY_METHOD_PAYMENT, 
       b.BANK_NAME,
       M.COD_AGENTE_ARRECADADOR, 
       P.CLEARING_HOUSE_ID COD_AGENTE_ARRECADADOR_PAYMENT,
       M.COD_AGENCIA COD_AGENCIA_DACC,
       P.CUST_BANK_SORT_CODE COD_AGENCIA_PAYMENT,
       M.NUM_CC_CARTAO NUM_CC_CARTAO_DACC, 
       P.OWNR_LNAME NUM_CC_CARTAO_PAYMENT,
       M.TIPO_ERRO
 from GVT_DACC_GERENCIA_MET_PGTO M,
      PAYMENT_PROFILE P,
      CUSTOMER_ID_ACCT_MAP A,
      bank_names b
 where M.EXTERNAL_ID = A.EXTERNAL_ID
  and A.ACCOUNT_NO = P.ACCOUNT_NO
  and M.PAY_METHOD <> P.PAY_METHOD
  and B.BANK_CODE = M.COD_AGENTE_ARRECADADOR
  and M.OLD_PAY_METHOD = 1
  and A.INACTIVE_DATE is null
  and A.EXTERNAL_ID_TYPE = 1
  and P.CUST_BANK_ACC_NUM is not null
  and trunc(M.DT_CADASTRO) > to_date ('01/01/2012', 'DD/MM/YYYY')
  --and P.account_no = 3515302
  and M.STATUS_CADASTRAMENTO = 3
  and P.PAY_METHOD <> 2
  -- and M.TIPO_ERRO is not null
  and M.COD_AGENCIA = P.CUST_BANK_SORT_CODE
  order by 6 desc