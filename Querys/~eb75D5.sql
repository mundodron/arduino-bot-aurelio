select G.external_ID, B.BILL_REF_NO, f.ACCOUNT_NO, f.TRACKING_ID, f.TRACKING_ID_SERV, f.TRANS_AMOUNT,  B.NEW_CHARGES, F.GL_AMOUNT, f.PAY_METHOD, f.TRANS_SUBMITTER
  from cmf_balance B,
       gvt_rajadas_bill G,
       bmf f
 where b.account_no = G.account_no
   and b.bill_ref_no = g.bill_ref_no
   and B.ACCOUNT_NO = F.ACCOUNT_NO
   and B.BILL_REF_NO = F.orig_BILL_REF_NO
   and B.BILL_REF_RESETS = F.orig_BILL_REF_RESETS
   and F.DISTRIBUTED_AMOUNT = 0
   and g.status = 777
   and g.account_no is not null
   and new_charges not in (select total_paid*-1 from cmf_balance D where d.account_no = B.account_no and bill_ref_no = 0)
