-- Queries-exemplo da tabela de carga de contas para gera��o de ordem do processo
-- Base: DGEN

-- Inser��o de uma conta para tratamento na tabela de carga
insert into sincronismo_siebel_kenan_carga 
(conta_cobranca, responsavel) 
values 
('999999999999', 'Aurelio Avanzi - Ativa��o de Conta');


-- Queries-exemplo da tabela de LOG do processo
-- Base: DGEN

-- Capturar contas tratadas na data atual da tabela de LOG
select * 
from bss_sincronismo_sk 
where result = 1 
and created > trunc(sysdate);

select * from sincronismo_siebel_kenan_carga where conta_cobranca in ('899998913679','899998913679','899998913679','899998913679','999988567520','899998886616','999989390119','999989390119','899998913679','899998913679','999987107112','999987582262','999987582262','999989390119','999989390119','999987582262','999987582262')

-- Capturar contas de um respons�vel espec�fico
select * 
from sincronismo_siebel_kenan_view
 where conta_cobranca in ('899998913679','899998913679','899998913679','899998913679','999988567520','899998886616','999989390119','999989390119','899998913679','899998913679','999987107112','999987582262','999987582262','999989390119','999989390119','999987582262','999987582262')
and CREATED > trunc(sysdate - 4)

where responsavel like 'Aurelio';

select * 
from bss_sincronismo_sk
where responsavel like '%Rhuan Krum%';


-- Capturar contas inseridas por um login espec�fico
select *
from bss_sincronismo_sk
where user_insert = 'G0030353SQL';

select * from sincronismo_siebel_kenan_carga