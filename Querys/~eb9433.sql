select B.BILL_REF_NO, f.ACCOUNT_NO, f.TRACKING_ID, f.TRACKING_ID_SERV, f.TRANS_AMOUNT,  B.NEW_CHARGES, F.GL_AMOUNT, f.PAY_METHOD, f.TRANS_SUBMITTER
  from cmf_balance B,
       bmf f
 where B.ACCOUNT_NO = F.ACCOUNT_NO
   and B.BILL_REF_NO = F.orig_BILL_REF_NO
   and B.BILL_REF_RESETS = F.orig_BILL_REF_RESETS
   and F.DISTRIBUTED_AMOUNT = 0
   and f.account_no in (1845411,1258681)
   and f.tracking_id in (64993044,66417256)
   
   