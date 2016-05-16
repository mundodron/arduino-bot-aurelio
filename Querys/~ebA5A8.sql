select SUBSTR (descript, INSTR (descript, 'no Arbor:') + 10,10) AS Fatura, count(1)
from request
where curranal = 'IT Suporte Arrecadação'
and closed = 0
group by SUBSTR (descript, INSTR (descript, 'no Arbor:') + 10,10)
order by 2 desc