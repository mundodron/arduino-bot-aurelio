SELECT  count(1)
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  A.new_no_bill = 1
            AND  A.OLD_NO_BILL = 0
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            --AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            AND trunc(created) = trunc(sysdate) -- between trunc(sysdate - 30) and trunc(sysdate)
            --AND exists (select 1 from service where service.parent_account_no = c.account_no and service_inactive_dt is null)
          GROUP BY  to_char(created, 'mm/dd')
        
select count(1)
       FROM cmf c,
            gvt_log_cmf l 
       WHERE c.no_bill=1
         AND c.ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
         AND trunc(c.CHG_DATE) = trunc(sysdate)
         AND trunc(L.quando) = trunc(c.CHG_DATE)
         AND C.ACCOUNT_NO = L.ACCOUNT_NO
         AND L.OLD_NO_BILL = 0 
         AND exists (select 1 from service where service.parent_account_no = c.account_no and service_inactive_dt is null)
         --AND l.account_no = 1704178;
  
  
  order by 1
  
  
select * from gvt_no_bill_audit where account_no = 8005174

select * from gvt_log_cmf where account_no = 8005174 order by 2

