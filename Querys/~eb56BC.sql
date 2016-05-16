Select --+ index (grc sp_pk)
         hca.bill_ref_no  orig_bill_ref_no,
         0  orig_bill_ref_resets,
         0  tracking_id,
         0  tracking_id_serv,
         hca.dt_ajuste transact_date,
         hca.request_status,
         hca.adj_reason_code,
         cdr.msg_id,
         cdr.msg_id2,
         cdr.msg_id_serv,
         grc.status,
         grc.data_recebimento,
         grc.sequencial_chave,
         grc.data_cobranca_inad,
         grc.valor_faturado
from gvt_historico_cdrs_ajustados hca,
     cdr_data cdr,
         grc_servicos_prestados grc
where hca.dt_ajuste > sysdate - 30-- iULTIMA_EXECUCAO
  and CDR.ACCOUNT_NO = 9315244
  and cdr.msg_id = hca.msg_id
  and cdr.msg_id2 = hca.msg_id2
    and cdr.msg_id_serv = hca.msg_id_serv
    and grc.sequencial_chave = cdr.ext_tracking_id
    and grc.status  in ('F','A','R', 'F2', 'F9');