select to_char(a.payment_due_date, 'yyyymmdd'), 
       to_char(a.payment_due_date,'yymmdd'), 
       lpad(b.file_group_id,3,'0') 
  from payment_trans a, file_status b
 where a.tracking_id = ?
   and a.tracking_id_serv = ?
   and a.file_id = b.file_id
 
 
   
 select C.EXTERNAL_ID,
        c.account_no,
        to_char(a.payment_due_date, 'yyyymmdd'), 
        to_char(a.payment_due_date,'yymmdd'), 
        lpad(b.file_group_id,3,'0')
   from payment_trans a,
        file_status b,
        customer_id_acct_map c
  where a.file_id = b.file_id
    and A.ACCOUNT_NO = C.ACCOUNT_NO
    and C.INACTIVE_DATE is null
    and C.EXTERNAL_ID_TYPE = 1
    and C.EXTERNAL_ID = '899998988332'
    
 select * from payment_trans where account_no = 7946137
    
     select * from customer_id_acct_map where EXTERNAL_ID = 'select to_char(a.payment_due_date, 'yyyymmdd'), 
       to_char(a.payment_due_date,'yymmdd'), 
       lpad(b.file_group_id,3,'0') 
  from payment_trans a, file_status b
 where a.tracking_id = ?
   and a.tracking_id_serv = ?
   and a.file_id = b.file_id
 
 
   
 select C.EXTERNAL_ID,
        c.account_no,
        to_char(a.payment_due_date, 'yyyymmdd'), 
        to_char(a.payment_due_date,'yymmdd'), 
        lpad(b.file_group_id,3,'0')
   from payment_trans a,
        file_status b,
        customer_id_acct_map c
  where a.file_id = b.file_id
    and A.ACCOUNT_NO = C.ACCOUNT_NO
    and C.INACTIVE_DATE is null
    and C.EXTERNAL_ID_TYPE = 1
    and C.EXTERNAL_ID = '899998988332'
    
 select * from payment_trans where account_no = 7946137
    
     select * from customer_id_acct_map where EXTERNAL_ID = '899999281677'