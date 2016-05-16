select template_code, sum(amount), count(*) from teste group by template_code

select * from teste


select bid.*
  from bill_invoice b,
       bill_invoice_detail bid
 where 1 = 1
   and b.bill_ref_no = bid.bill_ref_no
   and b.bill_ref_resets = bid.bill_ref_resets
   and b.bill_ref_no = 130475958
   and type_code = 7
   and subtype_code = 360  ;