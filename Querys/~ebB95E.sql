select count(*) from no_bill_23 where new_no_bill = 1
and created BETWEEN to_date('23102013 00:00:00','ddmmyyyy HH24:MI:SS') AND to_date('23102013 23:59:59','ddmmyyyy HH24:MI:SS');

select count(*) 
        from cmf 
       where no_bill=1
  and exists (select '+' from service where service.parent_account_no = cmf.account_no and service_inactive_dt is null) 
  
  
  select count(*) from cmf where no_bill = 1
 

  select COUNT(1)
        from cmf 
       where no_bill=1
       AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
  and exists (select '+' from service where service.parent_account_no = cmf.account_no and service_inactive_dt is null)