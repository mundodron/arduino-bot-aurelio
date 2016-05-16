select * from all_tables where table_name like '%DACC%' 

select * from all_tables where table_name like '%GERENCIA%' 

-- GVT_DACC_GERENCIA_FILA_EVENTOS
-- GVT_DACC_GERENCIA_MET_PGTO

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = '999983106612'

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999983106612'

select * from gvt_exec_arg where NOME_PROGRAMA = 'PL0300' order by NUM_EXECUCAO desc

select * from gvt_exec_arg where NOME_PROGRAMA = 'PL0300' order by 1 desc

select * from GVT_DACC_GERENCIA_MET_PGTO where external_id = '999983106612'

select * from GVT_DACC_GERENCIA_FILA_EVENTOS where external_id = '999983106612'

update gvt_exec_arg set FLG_UTILIZADO

update gvt_exec_arg set DESC_PARAMETRO '2012071911560820120720111727' where NUM_EXECUCAO = 41302 and nome_programa = 'PL0300';

update gvt_exec_arg set DESC_PARAMETRO '2012071911551620120720092800' where NUM_EXECUCAO = 41559 and nome_programa = 'PL0300';

commit;

update gvt_exec_arg set DESC_PARAMETRO '20120724101358' where NUM_EXECUCAO = 41302

select * from gvt_exec_arg where  upper(nome_programa) = 'PL0300' order by NUM_EXECUCAO desc

select * from gvt_exec_arg where NUM_EXECUCAO = 41302 and nome_programa = 'PL0300'

select * from gvt_exec_arg where NUM_EXECUCAO = 41559 and nome_programa = 'PL0300'

select * from gvt_exec_arg where nome_programa = 'PL0300' order by num_execucao desc

select * from gvt_exec_arg where nome_programa = 'PL0300' order by 1 desc;

update gvt_exec_arg set DESC_PARAMETRO '20120724101358' where NUM_EXECUCAO = 41302


update gvt_exec_arg set DESC_PARAMETRO '2012071911560820120720111727' where NUM_EXECUCAO = 41316 and nome_programa = 'PL0300';

update gvt_exec_arg set DESC_PARAMETRO '20120725093648' where FLG_UTILIZADO = 'N' and nome_programa = 'PL0300';




Favor executar os passos abaixo para gerar um arquivo de arrecadação avulso.

1) Executar o update abaixo:  
update gvt_exec_arg set DESC_PARAMETRO = '2012071911560820120720111727' where NUM_EXECUCAO = 41316 and nome_programa = 'PL0300';

commit;

2) Rodar a PL0300

3) Rodar a PL0310

4) Após o termino das PLs executar o update abaixo:

update gvt_exec_arg set DESC_PARAMETRO = '20120725093648' where FLG_UTILIZADO = 'N' and nome_programa = 'PL0300';
commit;

Em seguida me enviar os arquivos e logs gerados.

Obrigado!

update gvt_exec_arg set DESC_PARAMETRO '20120725093648' where FLG_UTILIZADO = 'N' and nome_programa = 'PL0300';

20120725093648

20120725093648

