  Select /*+ full(adj) parallel(adj 8) */
         cdr.*
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
     and ( ( grc.status  in ('F' ,'A', 'R', 'F2', 'F9')   and  adj.request_status = 1 ) or
           ( grc.status  in ('RI','RA','RP')  and  adj.request_status = 4 ) )
     and Not Exists ( -- Não pode haver um lançamento de contestação no mesmo dia
                     Select 1
                       From GVT_CONTESTADOS_COBILLING gcc
                      Where gcc.adj_tracking_id      = adj.tracking_id
                        and gcc.adj_tracking_id_serv = adj.tracking_id_serv
                        and gcc.request_status       = adj.request_status
                        and data_entrada             = adj.transact_date
                     )
     and rownum < 200
     
     
     select * from usage_points where point like '511%' and country_code is not nul
     
     select * from bill_invoice_detail where bill_ref_no = 231921369
     
     select * from cdr_billed where bill_ref_no = 231921369 and point_target = '51141'
     
     select * from grc_parceiros