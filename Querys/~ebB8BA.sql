select M.EXTERNAL_ID, M.DT_CADASTRO, M.PAY_METHOD, P.PAY_METHOD
  from GVT_DACC_GERENCIA_MET_PGTO M,
       payment_profile p
 where M.EXTERNAL_ID = P.CUST_BANK_ACC_NUM
   and M.PAY_METHOD <> P.PAY_METHOD
   --and M.PAY_METHOD = 1
   and M.OLD_PAY_METHOD = 1
   and trunc(M.DT_CADASTRO) > to_date ('01/01/2011', 'DD/MM/YYYY')
order by 2 desc;