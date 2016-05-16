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
                WHERE t1.orig_bill_ref_no = 132160366
                --WHERE t1.account_no = t3.parent_account_no
                  AND t1.adj_trans_code = t2.adj_trans_code
                  --AND t1.transact_date >= trunc(c_data_ini) -- RFC 272848
                  --AND t1.transact_date < trunc(c_data_fim) -- RFC 272848
                  AND t1.adj_reason_code >= 900 -- c_reason_code_ini
                  AND t1.adj_reason_code <= 999 -- c_reason_code_fim
                  AND t1.request_status = 1
                  AND t2.billing_category = 2
                  AND NOT EXISTS (
                         SELECT 'X'
                           FROM gvt_liberacao_boleto bol
                          WHERE bol.bill_ref_no = t1.orig_bill_ref_no
                            AND bol.bill_ref_resets = t1.orig_bill_ref_resets
                            AND bol.status_ativo = 'S'
                            AND bol.status_boleto = 'N')
                            
                            
                            
            select  /*+ full(t1) parallel(t1 3)*/
                distinct 
                t1.account_no,
                t1.orig_bill_ref_no,
                t1.orig_bill_ref_resets,
                t3.subscr_no,
                t3.subscr_no_resets,
                DECODE(t4.open_item_id,1,0,2,0,3,0,91,90,92,90,t1.open_item_id) open_item_id,
                t1.bmf_trans_type
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
        --and     t1.bmf_trans_type in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO WHERE UPPER(DESCRIPTION_PGTO) LIKE 'BOLETO%')
               and     t1.bill_ref_no in (131709874,130336240,130652270,130674767,130857868,130913907,131146408,131207692,131244564,131309204,131358981,131573542,131574046,131593902,131655535,131752102,131786978,131786978,131825757,131844114,131896651,132018819,132499548,132772615,132805540,133299090,133305530)
                         
                         
                         select * from cmf_balance where bill_ref_no = 131821735
                         
                         select * from adj where bill_ref_no in (131709874,130336240,130652270,130674767,130857868,130913907,131146408,131207692,131244564,131309204,131358981,131573542,131574046,131593902,131655535,131752102,131786978,131786978,131825757,131844114,131896651,132018819,132499548,132772615,132805540,133299090,133305530)
                         
                         select * from GVT_DEPARA_AJUSTE_MASSIVO where BMF_TRANS_TYPE_PGTO = (-132)
                         
    select * from gvt_bankslip where bill_ref_no = 132160366
                         
    select * from all_tables where table_name like '%FEBRABAN%'
                         
    select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (131362693,133293192,133305955,133307213,133314576,133316761,133362986,133363245,133368704) 
    
    select * from gvt_exec_arg where nome_programa = 'PL0201' order by 1 desc
    
    select * from GVT_FEBRABAN_CATEGORIA where DESCRIPTION_FEBRABAN like '%00%'
    
    select * from descriptions where description_code = 16850
    
    select * from descriptions where description_text like '%Chamada 0300%' and LANGUAGE_CODE = 2                     