select * from customer_id_acct_map where external_id = '999982657141'

select * from bill_invoice_detail where bill_ref_no = 133977579

select * from cmf_balance where bill_ref_no = 133977579

select * from cmf_balance where bill_ref_no in (133977579)

select * from VERIPARCELAMENTO

select B.*
  from g0023421sql.VERIPARCELAMENTO A,
       bmf B
 where A.ACCOUNT_NO = B.ACCOUNT_NO
   and A.BILL_REF_NO = B.Orig_BILL_REF_NO
   and B.PAY_METHOD = 1
   
   
select B.DESCRIPTION_TEXT,
       A.* 
  from bill_invoice_detail A,
       descriptions B
 where bill_ref_no = 146873616
   and A.DESCRIPTION_CODE = B.DESCRIPTION_CODE
   and B.LANGUAGE_CODE = 2

