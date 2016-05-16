 select bill_period,
               to_char(sysdate - 30, 'mm/yyyy') mes,
               count(1) qtd
          from    cmf
         where   account_no in (select account_no from gvt_no_bill_audit where new_no_bill = 1 and created between trunc(sysdate - 30, 'mm') and last_day(sysdate) )
group by bill_period
order by BILL_PERIOD;         
         
         
select bill_period,
       to_char(sysdate - 30, 'mm/yyyy') dia,
       count(1) qtd
  from gvt_no_bill_audit
 where new_no_bill = 1
   and created between trunc(sysdate - 30) and last_day(sysdate)
group by bill_period
order by bill_period;


    SELECT rowid, a.* FROM gvt_no_bill_audit a