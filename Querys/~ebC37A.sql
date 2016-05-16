select * from customer_id_acct_map where external_id = '899998841081'

select * from payment_trans where account_no = 8299374

select to_char(a.payment_due_date, 'yyyymmdd'),
       to_char(a.payment_due_date,'yymmdd'),
       lpad(b.file_group_id,3,'0') 
  from payment_trans a, file_status b
 where a.tracking_id = 13175652
   and a.tracking_id_serv = 4
   and a.file_id = b.file_id
   
       select p.* --trunc(CHG_DATE)
   from payment_trans p,
        cmf_balance c
  where p.trans_status = 0
    and to_char(p.payment_due_date,'yymmdd') in ('140102')
    and C.ACCOUNT_NO = P.ACCOUNT_NO
    and C.BILL_REF_NO = P.BILL_REF_NO
    and C.CLOSED_DATE is null