    select P.ACCOUNT_NO, P.BILL_REF_NO, P.TRACKING_ID
      from payment_trans p
     where to_char(p.payment_due_date,'yymmdd') in ('140102') and p.TRANS_STATUS in (2,0)
       and EXISTS (SELECT 1
                     FROM cmf_balance b
                    WHERE P.ACCOUNT_NO = B.ACCOUNT_NO
                      AND P.BILL_REF_NO = B.BILL_REF_NO
                      AND B.CLOSED_DATE is not null)
    
    select * from cmf_balance where bill_ref_no = 166974956
    
    select * from bmf where orig_bill_ref_no = 166974956 and account_no = 7675187
    
    
    