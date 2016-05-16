select * -- M.EXTERNAL_ID, P.ACCOUNT_NO, M.DT_CADASTRO
  from GVT_DACC_GERENCIA_MET_PGTO M,
       payment_profile p
 where M.EXTERNAL_ID = P.CUST_BANK_ACC_NUM
   and M.PAY_METHOD <> P.PAY_METHOD
   --and p.PAY_METHOD = 3
   and M.OLD_PAY_METHOD = 1
   and trunc(M.DT_CADASTRO) > to_date ('01/01/2011', 'DD/MM/YYYY')
order by DT_cadastro desc