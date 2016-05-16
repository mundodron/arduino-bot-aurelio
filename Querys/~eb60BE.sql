-- Executar em DGRC
select v.SITUACAO, telefone, v.OPERADORA_ATUAL, cenario,v.BDR_COD_OPER, pnum_out_dt_janela, v.PNUM_OUT_STATUS, v.PNUM_OUT_OPER_IN
from VW_BSS_ANALYTICS_BDRSIEBEL v where telefone in ('4130823224');