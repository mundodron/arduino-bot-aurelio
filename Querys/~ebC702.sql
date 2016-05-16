-- ALTER TABLE gvt_no_bill_autid RENAME TO gvt_no_bill_audit;

select trunc(chg_date,'MM') from gvt_no_bill_audit

select BILL_PERIOD, 
       count(1)       
  from gvt_no_bill_audit 
 where account_no in (select account_no new_no_bill = 1
  and trunc(chg_date, 'MM') = '09' 
  group by BILL_PERIOD
  
  
 select TRUNC(sysdate,'mm') from dual 
  

