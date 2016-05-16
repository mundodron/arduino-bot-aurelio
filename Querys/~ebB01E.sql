
select * from GVT_FBB_BILL_INVOICE where account_no = 2235931

select * from GVT_FEBRABAN_BILL_INVOICE where account_no = 2235931


      SELECT C.ACCOUNT_NO, C.BILL_REF_NO, C.PAYMENT_DUE_DATE
      FROM   CDC_PROCESSAR_BACKLOG C
      WHERE  C.account_category not in (9,10,11)
       and   C.processo = 1;