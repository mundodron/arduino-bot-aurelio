select -- (SUBSTR (descript, INSTR (descript, 'Rpon: ') + 6, 8)) AS rPON,
       -- (SUBSTR (descript, INSTR (descript, 'Documento:') + 11, 14)) AS documento,
       -- (SUBSTR (descript, INSTR (descript, 'Conta:') + 7, 12)) AS Conta ,
       -- (SUBSTR (descript, INSTR (descript, 'Cobrança: ') + 10, 12)) AS Conta,
       -- (SUBSTR (descript, INSTR (descript, 'atura: ') + 7, 10)) AS Fatura1,
       -- (SUBSTR (descript, INSTR (descript, 'atura ') + 7, 10)) AS Fatura2,
       ltrim(SUBSTR (descript, INSTR (descript, 'Número da Fatura:') + 17,11)) AS Fatura
       --(SUBSTR (descript, INSTR (descript, 'Usuário:') + 16,30)) AS Usuário,
       --descript  , curranal
       -- to_number( )
  from request
 where problem = 'Cenário Não Mapeado'
   -- and curranal = 'IT Suporte Arrecadação' 
   and DESCRIPT like '%Verificar Boleto Não Gerado%'
   and closed = 0
   order by Fatura
   
   select replace('000213344003', '0') from dual