select count(1) --REMARK, COUNT(1)
        from cmf 
       where no_bill=1
       AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
  and exists (select '+' from service where service.parent_account_no = cmf.account_no and service_inactive_dt is null)
  
  
  GROUP BY REMARK
  ORDER BY 2 DESC