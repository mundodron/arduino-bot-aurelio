select count(*)
  from service,
       cmf a
 where service.parent_account_no = a.account_no
   and A.ACCOUNT_NO = SERVICE.PARENT_ACCOUNT_NO
   --and service.no_bill = 0 
   and (service.service_inactive_dt is null or (service.service_inactive_dt - 7) >= a.date_active and nvl(a.prev_cutoff_date,a.date_active) > (sysdate - 90))  
        
   
  select 6980874 - 6851959 from dual
  
  -- truncate table BIPP15_TESTE

  -- truncate table BIPP15_TESTE_new

 -- select * from BIPP15_TESTE
 
 -- truncate table BIPP15_TESTE

-- truncate table BIPP15_TESTE_new

select count(1) from BIPP15_TESTE
minus
select count(1) from BIPP15_TESTE_new

select * from service where parent_account_no = 1258694