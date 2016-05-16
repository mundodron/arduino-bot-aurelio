select count(*) 
  from bill_invoice_detail
 where bill_ref_no in (Select bill_ref_no from g0010388sql.vrc_cdr_cob_zerado_2)
   and OPEN_ITEM_ID between 4 and 89
   and TYPE_CODE = 7
   and AMOUNT = 0
