select *
  from cdr_data d,
       cdr_billed b
 where B.BILL_REF_NO = 130475958
   and B.BILL_REF_RESETS = 0
   and B.MSG_ID = D.MSG_ID
   and B.MSG_ID2 = D.MSG_ID2
   and B.MSG_ID_SERV = D.MSG_ID_SERV

select * from cdr_billed where bill_ref_no = 130475958  

select * from cdr_data where msg_id = 151097408

2646829