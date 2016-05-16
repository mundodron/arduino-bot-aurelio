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
from bss_sincronismo_sk 
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

select * from bss_sincronismo_sk where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5);

select * from sincronismo_siebel_kenan_view where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 15) and status_ordem_integracao = 'Concluída'

select STATUS_CONTA, STATUS_PROCESSAMENTO, count(1)
  from sincronismo_siebel_kenan_view
 where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5)
 group by STATUS_CONTA, STATUS_PROCESSAMENTO
 order by 3
 
 
 select conta_cobranca
  from sincronismo_siebel_kenan_view
 where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5)
 and status_conta = 'Conta em no_bill no período de faturamento atual'
 