select -- (SUBSTR (descript, INSTR (descript, 'Rpon: ') + 6, 8)) AS rPON,
       -- (SUBSTR (descript, INSTR (descript, 'Documento:') + 11, 14)) AS documento,
       -- (SUBSTR (descript, INSTR (descript, 'Conta:') + 7, 12)) AS Conta ,
       -- (SUBSTR (descript, INSTR (descript, 'Cobran�a: ') + 10, 12)) AS Conta,
       -- (SUBSTR (descript, INSTR (descript, 'atura: ') + 7, 10)) AS Fatura1,
       -- (SUBSTR (descript, INSTR (descript, 'atura ') + 7, 10)) AS Fatura2,
       trim((SUBSTR (descript, INSTR (descript, 'N�mero da Fatura:') + 17,11))) AS Fatura
       --,(SUBSTR (descript, INSTR (descript, 'Usu�rio:') + 16,30)) AS Usu�rio
       --,curranal
       --,request
       --,descript
  from request
 where 1 = 1
   -- and problem = 'Cen�rio N�o Mapeado'
   -- and curranal = 'IT Suporte Arrecada��o' 
   -- and curranal = 'Aurelio Monteiro'
   and DESCRIPT like '%Boleto N�o Gerado%'
   and closed = 0
   order by Fatura