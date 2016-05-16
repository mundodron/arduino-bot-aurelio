select        request,
           --(SUBSTR (descript, INSTR (descript, 'Rpon: ') + 6, 8)) AS rPON,
      -- (SUBSTR (descript, INSTR (descript, 'Documento:') + 11, 14)) AS documento,
--       (SUBSTR (descript, INSTR (descript, 'Conta:') + 7, 12)) AS Conta ,
     --  (SUBSTR (descript, INSTR (descript, 'Cobrança: ') + 10, 12)) AS Conta,
   --    (SUBSTR (descript, INSTR (descript, 'atura: ') + 7, 10)) AS Fatura1,
--       (SUBSTR (descript, INSTR (descript, 'atura ') + 7, 10)) AS Fatura2,
       (SUBSTR (descript, INSTR (descript, 'no Arbor:') + 10,10)) AS Fatura,
       descript,
       OPENDATE
from request
where curranal = 'IT Suporte Arrecadação'
and closed = 0
order by OPENDATE desc;

