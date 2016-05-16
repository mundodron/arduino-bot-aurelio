select * FROM COBILLING.REMESSA_RECEBIDOS WHERE SUBSTR(DSNAME,1,24) IN ('TCOE.T001102.S01.D161214')

select * from grc_interfaces where nome_arquivo like '%TCOE.T231102.S01.D100415%'

select * from grc_mensagens_aplicacoes where arquivo = 'REM.TCOE.T231102.S01.D100415.H101211.NC.TLM.eynuiqa.GN'

select * from grc_servicos_prestados where telefone_origem = '2126202809' and telefone_destino = '3136573102' and data_servico = '06/04/2015' and hora_inicio = '120156'

select * from grc_servicos_prestados where telefone_origem = '2126211720' and telefone_destino = '2422332310'

select * from grc_historicos_serv_prestados where servico_prestado = '2015040821134304411267' order by 4 desc

select * from grc_historicos_serv_prestados where servico_prestado = '2015040821134304411282' order by 4 desc

TCOR.T231141.S00.D230415.H181615.NC.REP
TCOR.T231141.S00.D070515.H120927.NC

TCOR.T231141.S00.D050515.H172014.NC.REP
TCOR.T231141.S00.D300415.H204517.NC.REP

select * from grc_servicos_prestados where lote = 'TCOE.T001100.S01.D010113'

update grc_servicos_prestados set tote = 'TCOE.T001100.S01.D010113.H015858.NC' where lote = 'TCOE.T001100.S01.D010113'

update grc_servicos_prestados set tote = (RTRIM('TCOE.T001100.S01.D010113.H015858.NC', '.NC')),where lote = ('TCOE.T001100.S01.D010113');

update GRCOWN.grc_servicos_prestados set lote = rtrim('TCOE.T001100.S01.D010113.H015858.NC','.NC') where lote =  'TCOE.T001100.S01.D010113';

select rtrim('TCOE.T001100.S01.D010113.H015858.NC','.NC') from dual

select * from grc_servicos_prestados where data_insercao > sysdate -10

select * from cobilling.retorno_enviados where dsname like '%TCOR.T231141.S00.D050515.H172014.NC%'

grc_erros_bmp

select * FROM COBILLING.REMESSA_RECEBIDOS WHERE SUBSTR(DSNAME,1,24) IN (
'TCOE.T001102.S01.D161214',
'TCOE.T211141.S01.D060115',
'TCOE.T231101.S01.D080115',
'TCOE.T231102.S01.D080115')


select * from bill_invoice where bill_ref_no = 25254597

ARBORGVT_BILLING.PKG_VAL_CONTAS_PROFORMA

select * from all_tables where table_name like '%COBILLING%'

select * from CONTROLE_EXEC_COBILLING_GCC

select * from CONTROLE_EXECUCAO_COBILLING

select * from gvt_chamadas_cb