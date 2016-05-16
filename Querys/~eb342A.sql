update cmf set BILL_DISP_METH = 2 where account_no in (  
  select D.ACCOUNT_NO
   from cmf C,
        bill_disp_meth_values b,
        ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD a,
        customer_id_acct_map d
 where c.BILL_DISP_METH = B.BILL_DISP_METH
   and A.EXTERNAL_ID = D.EXTERNAL_ID
   and C.ACCOUNT_NO = D.ACCOUNT_NO
   and B.LANGUAGE_CODE = 2
   and D.INACTIVE_DATE is null);
   
   commit;
   
   
        select D.ACCOUNT_NO
   from ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD a,
        customer_id_acct_map d
 where A.EXTERNAL_ID = D.EXTERNAL_ID
   and D.INACTIVE_DATE is null