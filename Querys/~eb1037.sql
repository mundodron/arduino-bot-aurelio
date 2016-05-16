select (SUBSTR (descript, INSTR (descript, 'no Arbor:') + 10,10)) AS Fatura, count(*)
from request
where curranal = 'IT Suporte Arrecadação'
and closed = 0
group by 2

