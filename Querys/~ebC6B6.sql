        select d.*
      from bmf_distribution d,
           bmf b
     where D.bmf_tracking_id = B.TRACKING_ID 
       and B.orig_bill_ref_no <> 0
       and D.orig_bill_ref_no <> b.orig_bill_ref_no
       --and B.ACCOUNT_NO = R.ACCOUNT_NO
       and D.ACCOUNT_NO = B.ACCOUNT_NO;