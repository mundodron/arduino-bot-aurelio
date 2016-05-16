create table gvt_faturas_marco as
select account_no,bill_ref_no,bill_ref_resets 
from bill_invoice
where prep_Date between to_date('01/03/2014 00:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('31/03/2014 23:59:59','dd/mm/yyyy hh24:mi:ss')
  and prep_status=1
  and prep_error_code is null;  
  