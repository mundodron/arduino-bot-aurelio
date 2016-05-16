select R.external_ID, B.BILL_REF_NO, f.ACCOUNT_NO, f.TRACKING_ID, f.TRACKING_ID_SERV, f.TRANS_AMOUNT,  B.NEW_CHARGES, F.GL_AMOUNT, f.PAY_METHOD, f.TRANS_SUBMITTER
  from cmf_balance b,
       bmf f,
       G0023421SQL.GVT_RAJADAS R
  where b.ACCOUNT_NO = R.ACCOUNT_NO
    and B.BILL_REF_NO = R.BILL_REF_NO
    and B.ACCOUNT_NO = F.ACCOUNT_NO
    and B.BILL_REF_NO = F.orig_BILL_REF_NO
    and B.BILL_REF_RESETS = F.orig_BILL_REF_RESETS
    and F.DISTRIBUTED_AMOUNT = 0
    and R.VALOR = F.TRANS_AMOUNT
    and R.status = 99;
    
    select * from bmf where ACTION_CODE = 'API'
    
    
    
    select * from gvt_rajadas where status = 99 and account_no is not null and external_id = '777777768435'
    
    
    select count(*) from gvt_rajadas where status = 2
    
           select * from gvt_rajadas where status = 77 and account_no is not null
           
           
                             select  from gvt_rajadas where status in (99,77) and account_no is not null