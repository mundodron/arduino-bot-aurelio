    SELECT DISTINCT t1.account_no,
                      t1.orig_bill_ref_no,
                      t1.orig_bill_ref_resets,
                      t3.subscr_no,
                      t3.subscr_no_resets,
                      /* by Festa:29/06/2011
                       * Adicionado a coluna open_item_id para ser utilizado em uma consulta na tabela SIN_SEQ_NO,
                       * por isso colocado o decode.
                       */
                      DECODE(t1.open_item_id,1,0,2,0,3,0,91,90,92,90,t1.open_item_id) open_item_id
                 FROM service t3,
                      adj_trans_descr t2,
                      adj t1
                --WHERE t1.account_no IN ('1784921')
                WHERE t1.account_no = t3.parent_account_no
                  AND t1.adj_trans_code = t2.adj_trans_code
                  --AND t1.transact_date >= trunc(c_data_ini) -- RFC 272848
                  --AND t1.transact_date < trunc(c_data_fim) -- RFC 272848
                  AND t1.adj_reason_code >= c_reason_code_ini
                  AND t1.adj_reason_code <= c_reason_code_fim
                  AND t1.request_status = 1
                  AND t2.billing_category = 2
                  AND NOT EXISTS (
                         SELECT 'X'
                           FROM gvt_liberacao_boleto bol
                          WHERE bol.bill_ref_no = t1.orig_bill_ref_no
                            AND bol.bill_ref_resets = t1.orig_bill_ref_resets
                            AND bol.status_ativo = 'S'
                            AND bol.status_boleto = 'N')
        UNION   /* Adicionado para verificar pagamentos, de acordo com a alteração da RFC_366331 */
        select  /*+ full(t1) parallel(t1 3)*/
                distinct 
                t1.account_no,
                t1.orig_bill_ref_no,
                t1.orig_bill_ref_resets,
                t3.subscr_no,
                t3.subscr_no_resets,
                DECODE(t4.open_item_id,1,0,2,0,3,0,91,90,92,90,t1.open_item_id) open_item_id
        from    bmf t1,
                bmf_distribution t4,
                service t3
        where   t1.account_no = t3.parent_account_no
        and     t1.account_no = t4.account_no
        and     t1.orig_bill_ref_no = t4.orig_bill_ref_no
        and     t1.bill_ref_resets = t4.bill_ref_resets
        and        t1.tracking_id = t4.bmf_tracking_id
        and        t1.tracking_id_serv = t4.bmf_tracking_id_serv
        --and     t1.post_date >= trunc(c_data_ini) 
        --and     t1.post_date < trunc(c_data_fim)  
        --and     t1.bmf_trans_type in (-224, -223, -262, -261, -260, -259, -258, -257, -256, -255, -278, -277, -276, -275, -274)
        and     t1.bmf_trans_type in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO WHERE UPPER(DESCRIPTION_PGTO) LIKE 'BOLETO%')
        and not exists ( select 'X'
                         from   gvt_liberacao_boleto bol
                         where  bol.bill_ref_no = t1.orig_bill_ref_no
                         and    bol.bill_ref_resets = t1.orig_bill_ref_resets
                         and    bol.status_ativo = 'S'
                         and    bol.status_boleto = 'N')
        order by account_no,
                 orig_bill_ref_no,
                 orig_bill_ref_resets;