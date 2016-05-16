        select bill_period,
               to_char(sysdate - 0, 'mm/yyyy') mes,
               count(1) qtd
          from    cmf
         where   account_no in (select account_no from gvt_no_bill_audit where new_no_bill = 1 and created between trunc(sysdate, 'mm') and last_day(sysdate) )      
group by bill_period
order by BILL_PERIOD;

select bill_period,
       to_char(max(created),'mm') MES,
       count(1) TOTAL
  from gvt_no_bill_audit
  where new_no_bill = 1 and created between trunc(sysdate, 'mm') and last_day(sysdate)
  group by bill_period
  order by BILL_PERIOD;
  
  
select bill_period,
       to_char(max(created),'mm') MES,
       count(1) TOTAL
  from gvt_no_bill_audit
  where new_no_bill = 1 and created between trunc(sysdate - 30 , 'mm') and last_day(sysdate - 30)
  group by bill_period
  order by BILL_PERIOD;