select  bill_period, to_char(sysdate -30, 'mm/yyyy') mes, count( * ) qtd
from    cmf
where   account_no in ( select account_no from gvt_no_bill_audit where new_no_bill = 1 and created between trunc(sysdate - 30, 'mm') and last_day(sysdate - 30) )        
group by bill_period
union all
select  bill_period, to_char(sysdate, 'mm/yyyy') mes, count( * ) qtd
from    cmf
where   account_no in ( select account_no from gvt_no_bill_audit where new_no_bill = 1 and created between trunc(sysdate, 'mm') and last_day(sysdate) )        
group by   
        bill_period
order by 
        2 asc,1 asc