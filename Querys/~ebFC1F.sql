select R.external_ID, R.BILL_REF_NO, f.ACCOUNT_NO, f.TRACKING_ID, f.TRACKING_ID_SERV, f.TRANS_AMOUNT, R.VL_BAIXA , F.GL_AMOUNT, f.PAY_METHOD, f.TRANS_SUBMITTER
  from bmf f,
       G0023421SQL.GVT_RAJADAS_bill R
  where R.BILL_REF_NO = F.orig_BILL_REF_NO
    and R.ACCOUNT_NO = F.ACCOUNT_NO
    -- and F.DISTRIBUTED_AMOUNT = 0
    -- and F.BILL_REF_NO = 0
    and R.VL_BAIXA > 0
    and R.status = 99;
