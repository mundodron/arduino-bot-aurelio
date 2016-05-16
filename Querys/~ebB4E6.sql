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
and created < trunc(sysdate - 5);


-- Capturar contas de um respons�vel espec�fico
select * 
from bss_sincronismo_sk 
where responsavel = 'Rhuan Krum - Ativa��o de Conta';

select * 
from bss_sincronismo_sk
where responsavel like '%Rhuan Krum%';


-- Capturar contas inseridas por um login espec�fico
select *
from bss_sincronismo_sk
where user_insert = 'G0030353SQL';

select *
from bss_sincronismo_sk where upper(responsavel) like '%AURELIO%'

select * from bss_sincronismo_sk where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5);

select * from sincronismo_siebel_kenan_view where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 15) and status_ordem_integracao = 'Conclu�da'

select STATUS_CONTA, STATUS_PROCESSAMENTO, count(1)
  from sincronismo_siebel_kenan_view
 where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5)
 group by STATUS_CONTA, STATUS_PROCESSAMENTO
 order by 3
 
 
 select conta_cobranca
  from sincronismo_siebel_kenan_view
 where upper(responsavel) like '%AURELIO%' and created > trunc(sysdate - 5)
 and status_conta = 'Conta em no_bill no per�odo de faturamento atual'
 