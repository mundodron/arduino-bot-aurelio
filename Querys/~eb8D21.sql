select * from gvt_detalhamento_ciclo where data_processo > sysdate - 1 and ANOTATION like '%BIP%'

select * from grc_interfaces where data_inclusao > sysdate -1

Select * from GRC_INTERFACES where processo = 'ERR' order by data_fim_exec desc

select * from GRC_ERROS_BMP where DATA_LOTE > sysdate -10

select * from CONTROLE_EXECUCAO_COBILLING where data_inicio > sysdate -1 and upper(rotina) = 'PROC_CARGA_ERROS_BMP' order by data_inicio

Select * from grc_mensagens_aplicacoes where data_criacao > sysdate -1 order by data_criacao desc 

Select * from grc_mensagens_aplicacoes where arquivo = 'REM.TCOE.T401147.S01.D180315.H042453.NC.TIM.euapvxq.GN'

select * from GRC_ERROS_BMP

select * from GRCOWN.GRC_ARQS_BMP where nome_arquivo = 'REM.TCOE.T401147.S01.D180315.H042453.NC.TIM.euapvxq.GN'

GRCOWN.ARQ_BMP_PK

select * from GRCOWN.GRC_ARQS_BMP

PROC_CARGA_ERROS_BMP_REM.TCOE.T401147.S01.D180315.H042453.NC.TIM.euapvxq.GN.log