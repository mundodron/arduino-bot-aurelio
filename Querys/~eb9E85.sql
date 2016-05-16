
SELECT distinct(bill_invoice_row), display_value
  FROM bill_invoice_tax bit, tax_pkg_inst_id_values tpi 
 WHERE bit.bill_ref_no IN (178112904) 
   AND bit.tax_pkg_inst_id = tpi.tax_pkg_inst_id 
   AND tpi.language_code = 2
 
 AND bit.tax_rate NOT IN ('50000', '-50000') 
 AND UPPER (tpi.display_value) LIKE '%ISS%' 
 
 
 select * from bill_invoice_detail
 
 
  