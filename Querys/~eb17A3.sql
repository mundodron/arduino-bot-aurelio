select B.*
  from g0023421sql.VERIPARCELAMENTO A,
       bmf B
 where A.ACCOUNT_NO = B.ACCOUNT_NO
   and A.BILL_REF_NO = B.BILL_REF_NO
   and B.PAY_METHOD = 1

select B.DESCRIPTION_TEXT,
       A.* 
  from bill_invoice_detail A,
       descriptions B
 where bill_ref_no = 143998304
   and A.DESCRIPTION_CODE = B.DESCRIPTION_CODE
   and B.LANGUAGE_CODE = 2
