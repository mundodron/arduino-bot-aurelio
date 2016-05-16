select -- (SUBSTR (descript, INSTR (descript, 'Rpon: ') + 6, 8)) AS rPON,
       -- (SUBSTR (descript, INSTR (descript, 'Documento:') + 11, 14)) AS documento,
       -- (SUBSTR (descript, INSTR (descript, 'Conta:') + 7, 12)) AS Conta ,
       -- (SUBSTR (descript, INSTR (descript, 'Cobrança: ') + 10, 12)) AS Conta,
       -- (SUBSTR (descript, INSTR (descript, 'atura: ') + 7, 10)) AS Fatura1,
       -- (SUBSTR (descript, INSTR (descript, 'atura ') + 7, 10)) AS Fatura2,
       trim((SUBSTR (descript, INSTR (descript, 'Nº da Fatura no Arbor:') + 22,11))) AS Fatura,
       --,(SUBSTR (descript, INSTR (descript, 'Usuário:') + 16,30)) AS Usuário
       --,curranal
       request
       --,descript
  from request
 where 1 = 1
   -- and problem = 'Cenário Não Mapeado'
   and curranal = 'IT Suporte Arrecadação' 
   --and curranal = 'Aurelio Monteiro'
   --and DESCRIPT like '%Fatura com problema (EIF)%'
   and closed = 0
   