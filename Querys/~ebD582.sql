select c.account_no, c.contact1_phone, c.bill_lname, e.service_city, e.service_state 
  from cmf c, Service e
 where e.account_no = c.account_no
 and e.service_end is null 
 and c.no_bill = 0
 and e.equip_status = 0   
 and c.pay_method = 1
 and e.bill_period = 'M15'
 and e.
 and e.no_bill = 0
 and c.date_inactive is null 
 
 
 select 'I' ||
     rpad(eiam.external_id,25,' ') || 
     (case when length (trim(contact1_phone)) >= 14 then '1'
     else  '2' end) ||
     lpad(trim(t.contact1_phone),14,0) || 
     rpad(trim(t.bill_lname) ,40,' ') ||
     rpad(trim(t.service_city),30,' ') || 
     rpad(trim(t.service_state), 39,' ')
from g0023421sql.tmp_eve_relatorio_dacc t, customer_id_acct_map eiam
where eiam.account_no = t.account_no
and eiam.external_id_type = 1