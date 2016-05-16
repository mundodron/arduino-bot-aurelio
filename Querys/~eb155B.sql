select * from customer_id_acct_map where external_id = '999982657141'

select * from bill_invoice_detail where bill_ref_no = 133977579

select * from cmf_balance where bill_ref_no = 133977579

select * from cmf_balance where bill_ref_no in (133977579)

select * from VERIPARCELAMENTO

select B.BILL_REF_NO
  from g0023421sql.VERIPARCELAMENTO A,
       bmf B
 where A.ACCOUNT_NO = B.ACCOUNT_NO
   and A.BILL_REF_NO = B.BILL_REF_NO
   and B.PAY_METHOD = 1

   
   
select B.DESCRIPTION_TEXT,
       A.* 
  from bill_invoice_detail A,
       descriptions B
 where bill_ref_no = 146873616
   and A.DESCRIPTION_CODE = B.DESCRIPTION_CODE
   and B.LANGUAGE_CODE = 2
   and A.TYPE_CODE = 6
   
select * from bill_invoice_detail 

select B.DESCRIPTION_TEXT,
       A.* 
  from bill_invoice_detail A,
       descriptions B
 where bill_ref_no in (select X.BILL_REF_NO
  from g0023421sql.VERIPARCELAMENTO Z,
       payment_trans X
 where Z.ACCOUNT_NO = X.ACCOUNT_NO
   and Z.BILL_REF_NO = X.BILL_REF_NO
   --and B.PAY_METHOD = 1
)
   and A.DESCRIPTION_CODE = B.DESCRIPTION_CODE
   and B.LANGUAGE_CODE = 2
   and A.TYPE_CODE = 6
   and A.COMPONENT_ID = 26347
   --and A.AMOUNT > 100
   
   
   select * from bill_invoice_detail