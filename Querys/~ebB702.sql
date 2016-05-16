select * from customer_id_acct_map where external_id = '899999616581'

select * from cmf_balance where bill_ref_no = 145414262


select C.ACCOUNT_NO,
       13160*-1,--cb.total_paid*-1 amount, 
       C.BILL_LNAME,
       C.BILL_FNAME,
       C.BILL_ADDRESS1,
       C.BILL_ADDRESS2,
       C.BILL_ADDRESS3,
       C.BILL_CITY,
       C.BILL_STATE,
       C.BILL_ZIP,
       C.BILL_COUNTRY_CODE
from cmf_balance cb, cmf c 
where cb.account_no in (7662073)
and c.account_no=cb.account_no
and cb.bill_ref_no=0;