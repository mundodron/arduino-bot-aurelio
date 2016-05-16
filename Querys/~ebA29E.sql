select  * -- M.EXTERNAL_ID, M.DT_CADASTRO, M.PAY_METHOD, P.PAY_METHOD
  from GVT_DACC_GERENCIA_MET_PGTO M,
       payment_profile p,
       customer_id_acct_map a
 where M.EXTERNAL_ID = A.EXTERNAL_ID
   and A.ACCOUNT_NO = P.ACCOUNT_NO
   and M.PAY_METHOD <> P.PAY_METHOD
   --and M.PAY_METHOD = 1
   and M.OLD_PAY_METHOD = 1
   and A.INACTIVE_DATE is null
   and A.EXTERNAL_ID_TYPE = 1
   and trunc(M.DT_CADASTRO) > to_date ('01/01/2011', 'DD/MM/YYYY')
   and p.CUST_BANK_ACC_NUM is null
   -- and P.account_no = 3515302
   -- order by 2 desc;