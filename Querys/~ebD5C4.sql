    select P.TRACKING_ID
      from payment_trans p
     where p.TRANS_STATUS in (0)
       and P.NO_BILL = 0
       and P.IS_REALTIME <> 1
       and P.PAYMENT_DUE_DATE < sysdate
       
       --to_char(p.payment_due_date,'yymmdd') in ('140102')
       group by P.PAYMENT_DUE_DATE
       order by 1