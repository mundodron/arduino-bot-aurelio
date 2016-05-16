select * from payment_trans P --set trans_status = 6 
where p.TRANS_STATUS in (0) 
and P.NO_BILL = 0 
and P.IS_REALTIME <> 1 
and P.PAYMENT_DUE_DATE < sysdate -1; 

       
commit;
       
       --to_char(p.payment_due_date,'yymmdd') in ('140102')
       group by P.PAYMENT_DUE_DATE
       order by 1

    select P.PAYMENT_DUE_DATE, count(1)
      from payment_trans p
     where p.TRANS_STATUS in (0)
       and P.NO_BILL = 0
       and P.IS_REALTIME <> 1
       and P.PAYMENT_DUE_DATE < sysdate - 1
       --and P.PAYMENT_DUE_DATE > sysdate - 90
       --to_char(p.payment_due_date,'yymmdd') in ('140102')
       group by P.PAYMENT_DUE_DATE
       order by 1