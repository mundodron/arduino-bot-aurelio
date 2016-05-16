select * from customer_id_acct_map where external_id = '899996287819'

select no_bill,
       account_status,
       account_category,
       contact1_phone,
       cust_zip,
       next_bill_date,
       prev_cutoff_date,
       date_active, 
       trunc(sysdate)
  from cmf
 where account_no = 10229294;
 
 select SERVICE.SERVICE_ACTIVE_DT,
        service.service_inactive_dt, 
       (service.service_inactive_dt + 7)
   from service where parent_account_no = 10229294;
   
   
   select * from bill_invoice where account_no = 10229294
 
   -- and (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(a.prev_cutoff_date,a. date_active) )