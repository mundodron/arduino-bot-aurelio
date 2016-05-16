select * from payment_trans where TRACKING_ID in (12502188)


update payment_trans set trans_status = 9 where account_no = 4396362;


     select t.*
     from bill_invoice b,
          payment_trans t
      where prep_status <> 1
      and b.bill_ref_no = t.bill_ref_no
      and t.TRANS_STATUS = 0
      
      select * from payment_trans where bill_ref_no = 0
      
      select * from payment_trans where bill_ref_no = 0 and TRANS_STATUS = 0
      
      select * from customer_id_acct_map where external_id = '899998727518'