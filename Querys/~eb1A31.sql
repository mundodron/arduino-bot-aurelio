  Select /*+ full(adj) parallel(adj 8) */
         adj.orig_bill_ref_no,
         adj.orig_bill_ref_resets,
         adj.tracking_id,
         adj.tracking_id_serv,
         adj.transact_date,
         adj.request_status,
         adj.adj_reason_code,
         cdr.msg_id,
         cdr.msg_id2,
         cdr.msg_id_serv,
         grc.status,
         grc.data_recebimento,
         grc.sequencial_chave,
         grc.data_cobranca_inad,
         grc.valor_faturado
    From GRC_SERVICOS_PRESTADOS grc,
         ARBOR.CDR_DATA     cdr,
         ARBOR.ADJ      adj
   Where adj.open_item_id between 4 and 89
     and adj.request_status   in ( 1, 4 )
     and cdr.msg_id            = adj.orig_msg_id
     and cdr.msg_id2           = adj.orig_msg_id2
     and cdr.msg_id_serv       = adj.orig_msg_id_serv
     and cdr.split_row_num     = adj.orig_split_row_num
     and grc.sequencial_chave  = cdr.ext_tracking_id
     and ( ( grc.status  in ('F' ,'A', 'R')   and  adj.request_status = 1 ) or
           ( grc.status  in ('RI','RA','RP')  and  adj.request_status = 4 ) )
     and Not Exists ( -- Nao pode haver um lançamento de contestaçao no mesmo dia
                     Select 1
                       From GVT_CONTESTADOS_COBILLING gcc
                      Where gcc.adj_tracking_id      = adj.tracking_id
                        and gcc.adj_tracking_id_serv = adj.tracking_id_serv
                        and gcc.request_status       = adj.request_status
                        and data_entrada             = adj.transact_date
                     )