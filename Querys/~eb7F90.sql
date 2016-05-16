select C.ACCOUNT_NO,
       cb.total_paid*-1 amount, 
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