SELECT *
 FROM bill_invoice_tax bit, tax_pkg_inst_id_values tpi 
 WHERE 1=1 --bit.bill_ref_no IN (173903103) 
 AND bit.tax_pkg_inst_id = tpi.tax_pkg_inst_id 
 AND bit.tax_rate NOT IN ('50000', '-50000') 
 AND UPPER (tpi.display_value) LIKE '%ISS%' 
 AND tpi.language_code = 2 
