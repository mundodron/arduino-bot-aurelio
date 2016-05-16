Relatório de estado: 
Mostra o estado atual dos clientes que estão ou não em no_bill no momento recebendo parâmetros de data e estado.

Select count(*),
       trunc(CREATED) 
  from gvt_no_bill_audit
  where new_no_bill = 1 and created between trunc(sysdate - 30, 'mm') and last_day(sysdate)
group by trunc(CREATED)

Select count(*),
       trunc(CREATED) 
  from gvt_no_bill_audit
  where new_no_bill = 0 and created between trunc(sysdate - 30, 'mm') and last_day(sysdate)
group by trunc(CREATED)

Relatório por período:
Mostra a quantidade de clientes que entraram em no_bill com filtros por período, que podem ser mensal, semanal ou diário.


Select count(*),
       trunc(CREATED) 
  from gvt_no_bill_audit
  where new_no_bill = 1 and created between trunc(sysdate - 30, 'mm') and last_day(sysdate)
group by trunc(CREATED)

Relatório por ciclo:
Mostra a quantidade de clientes que entraram e saíram de no_bill filtrados por ciclo.

select  ciclo,
        periodo,
        sum(qtd) qtd
from    (select  bill_period                 ciclo,
        to_char(created, 'mm/yyyy') periodo, 
        count(*)                    qtd
           from    gvt_no_bill_audit
          where   new_no_bill = 1
            and     created > sysdate - 90
       group by bill_period, created
       order by to_char(created, 'mm/yyyy')        
        )
group by
        ciclo,
        periodo 
order by
        periodo asc