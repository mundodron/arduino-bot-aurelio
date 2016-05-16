select count(1)
  from customer_id_acct_map b,    
       cmf a
   where a.account_category in (&1)    
   and a.account_type = 1 
   and a.bill_period IN (select bill_period from GVT_PROCESSAMENTO_CICLO where upper(processamento) = upper('P02'))
   and a.no_bill = 0    
   and a.account_status != -2     
   and a.account_no in     
             (select parent_account_no
               from service
              where service.parent_account_no = a.account_no 
                and (service.service_inactive_dt is null or service.service_inactive_dt > a.prev_cutoff_date ))
               -- and (service.service_inactive_dt is null or (service.service_inactive_dt + 7) > nvl(a.prev_cutoff_date,a. date_active) ) ) --2814
                                                                                                                                               2235
                                                                                                                                                 
   and a.account_no = b.account_no    
   and b.external_id_type = 1   
   and exists ( select 1 
   from   SIN_GROUP_REF sin
   where  sin.group_id = a.mkt_code 
   and    sin.inactive_date is null
   );