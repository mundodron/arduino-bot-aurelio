select * from payment_trans P --set trans_status = 6 
where p.TRANS_STATUS = 0
and P.NO_BILL = 0 
and P.IS_REALTIME <> 1 
and P.PAYMENT_DUE_DATE < sysdate -1
and P.PAYMENT_DUE_DATE > sysdate -90; 