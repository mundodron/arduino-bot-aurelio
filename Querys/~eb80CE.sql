    select * from payment_trans where to_char(payment_due_date,'yymmdd') in ('140102') and TRANS_STATUS in (2,0)
    
    
        select * --P.TRACKING_ID
      from payment_trans p
     where 1= 1 --to_char(p.payment_due_date,'yymmdd') in ('140102')
       and p.TRANS_STATUS in (0)
       and P.PAYMENT_DUE_DATE < sysdate
       
       and EXISTS (SELECT 1
                     FROM cmf_balance b
                    WHERE P.ACCOUNT_NO = B.ACCOUNT_NO
                      AND P.BILL_REF_NO = B.BILL_REF_NO
                      AND B.CLOSED_DATE is not null)
    
    select * from cmf_balance where bill_ref_no = 166957061
    
    select * from customer_id_acct_map where external_id = '899998841081'
    
    select * from payment_trans where account_no = 8299374
    
    select * from bmf where orig_bill_ref_no = 166957061 and account_no = 8299374 
    
    
    