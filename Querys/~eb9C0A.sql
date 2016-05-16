select telefone_origem, csp, sysdate ACTIVE_DT, NULL INACTIVE_DT, NULL descricao
 from GRC_SERVICOS_PRESTADOS
 where status in ('RI','RA','RP')
   and motivo = 218 and data_insercao > sysdate - 40