select * from bill_invoice where bill_ref_no = 317284312

select * 
  from bill_invoice_detail
 where 1=1 --bill_ref_no in (Select bill_ref_no from vrc_cdr_cob_zerado_2)
   and bill_ref_no = 317284312
   and OPEN_ITEM_ID between 4 and 89
   and TYPE_CODE = 7
   and AMOUNT = 0
   
   
   order by 2 desc
   
   select * from customer_id_acct_map where account_no in (10876563,10870160)
   
   select * from bill-i 
   
   
   select BILL_REF_NO
  from bill_invoice_detail
 where 1=1 --bill_ref_no in (Select bill_ref_no from vrc_cdr_cob_zerado_2)
   and OPEN_ITEM_ID between 4 and 89
   and TYPE_CODE = 7
   AND bill_ref_no in (select bill_ref_no from bill_invoice where IMAGE_DONE = 1) order by 1 desc
   
   
   
   select file_name from bill_invoice where bill_ref_no = 293813595