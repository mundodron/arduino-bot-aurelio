select * from gvt_no_bill_audit


select  ciclo,
        periodo,
        sum(qtd) qtd
from    (
select  bill_period                 ciclo,
        to_char(created, 'mm/yyyy') periodo, 
        count(*)                    qtd
from    gvt_no_bill_audit
where   new_no_bill = 1
and     created > sysdate - 90
group by
        bill_period,
        created
order by
        to_char(created, 'mm/yyyy')        
        )
group by
        ciclo,
        periodo 
order by
        periodo asc               
        

select  *
from    gvt_no_bill_audit
where   new_no_bill = 1
and     to_char(created, 'mm/yyyy') = '09/2013'
and     bill_period = 'M10'
        