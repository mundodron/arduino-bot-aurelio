-- Queries-exemplo da tabela de carga de contas para geração de ordem do processo
-- Base: DGEN

-- Inserção de uma conta para tratamento na tabela de carga
insert into sincronismo_siebel_kenan_carga 
(conta_cobranca, responsavel) 
values 
('999999999999', 'Aurelio Avanzi - Ativação de Conta');


-- Queries-exemplo da tabela de LOG do processo
-- Base: DGEN

-- Capturar contas tratadas na data atual da tabela de LOG
select * 
from sincronismo_siebel_kenan_carga 
where result = 1 
and created < trunc(sysdate - 5);


-- Capturar contas de um responsável específico
select * 
from bss_sincronismo_sk 
where responsavel = 'Rhuan Krum - Ativação de Conta';

select * 
from bss_sincronismo_sk
where responsavel like '%Rhuan Krum%';


-- Capturar contas inseridas por um login específico
select *
from bss_sincronismo_sk
where user_insert = 'G0030353SQL';

select *
from bss_sincronismo_sk where upper(responsavel) like '%AURELIO%'

select *    
from bss_sincronismo_sk where CONTA_COBRANCA in ('899998913679','899998913679','899998913679','899998913679','999988567520','899998886616','999989390119','999989390119','899998913679','899998913679','999987107112','999987582262','999987582262','999989390119','999989390119','999987582262','999987582262')

select STATUS_CONTA, count(1) from sincronismo_siebel_kenan_view  where upper(responsavel) like '%AURELIO%' group by STATUS_CONTA
