select M.EXTERNAL_ID, M.DT_CADASTRO, M.PAY_METHOD, P.PAY_METHOD
  from GVT_DACC_GERENCIA_MET_PGTO M,
       PAYMENT_PROFILE P,
       CUSTOMER_ID_ACCT_MAP A
 where M.EXTERNAL_ID = A.EXTERNAL_ID
   and A.ACCOUNT_NO = P.ACCOUNT_NO
   and M.PAY_METHOD <> P.PAY_METHOD
   --and M.PAY_METHOD = 1
   and M.OLD_PAY_METHOD = 1
   and A.INACTIVE_DATE is null
   and A.EXTERNAL_ID_TYPE = 1
   --and P.CUST_BANK_ACC_NUM is not null
   and trunc(M.DT_CADASTRO) > to_date ('01/01/2011', 'DD/MM/YYYY')
   --and P.account_no = 3515302
   
   
order by 2 desc;


select * from 

select * from customer_id_acct_map where external_id = '999986298364'

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999986298364'

select * from payment_profile where account_no = 3515302