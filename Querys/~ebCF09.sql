select count(*) from cdr_billed where bill_ref_no = 168529902 

select count(*) from cdr_data where bill_ref_no = 168529902 

select d.*
  from cdr_data d,
       cdr_billed b
 where B.BILL_REF_NO = 168529902
   and B.BILL_REF_RESETS = 0
   and B.MSG_ID = D.MSG_ID
   and B.MSG_ID2 = D.MSG_ID2
   and B.MSG_ID_SERV = D.MSG_ID_SERV

select * from cdr_billed where bill_ref_no = 130475958  
