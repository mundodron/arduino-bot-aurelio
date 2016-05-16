select count(1)
        from cmf 
       where no_bill=1
       AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
  and exists (select '+' from service where service.parent_account_no = cmf.account_no and service_inactive_dt is null)

71781


SELECT  -- to_char(A.created, 'mm/dd') periodo, 
        count(1) qt_in
           FROM  gvt_no_bill_audit A, cmf C
          WHERE  c.no_bill = 1
            --AND  A.OLD_NO_BILL = 0
            AND  A.ACCOUNT_NO = C.ACCOUNT_NO
            AND ACCOUNT_CATEGORY IN (9,10,11,12,13,14,15,21,22)
            -- AND  trunc(created) between trunc(sysdate - 30, 'month') and last_day(sysdate - 30)
            -- AND trunc(created) between trunc(sysdate - 30) and trunc(sysdate)
        
        
        GROUP BY  to_char(created, 'mm/dd')
        
        select * from cmf
        
        select * from gvt_no_bill_audit