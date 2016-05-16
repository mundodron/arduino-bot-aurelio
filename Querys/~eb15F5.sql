select * from gvt_febraban_bill_invoice where bill_ref_no in (195259704,195260559,195259709,195258913,195259110)

select bill_period 
  from bill_invoice
 where bill_ref_no = (select max(bill_ref_no) from bill_invoice where PREP_STATUS = 4 and prep_date > trunc(sysdate -2))