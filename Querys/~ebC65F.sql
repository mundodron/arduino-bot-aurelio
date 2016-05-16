      SELECT DISTINCT t1.account_no,
                      t1.orig_bill_ref_no,
                      t1.orig_bill_ref_resets,
                      t3.subscr_no,
                      t3.subscr_no_resets,
                      /* by Festa:29/06/2011
                       * Adicionado a coluna open_item_id para ser utilizado em uma consulta na tabela SIN_SEQ_NO,
                       * por isso colocado o decode.
                       */
                      DECODE(t1.open_item_id,1,0,2,0,3,0,91,90,92,90,t1.open_item_id) open_item_id,
                      t1.transact_date
                 FROM service t3,
                      adj_trans_descr t2,
                      adj t1
                WHERE t1.orig_bill_ref_no in (125730912,129727410,130294185,130403531,130465559,130790855,130853066,131005297,131131083,131132088,131134667,131147143,131149643,131164391,131175789,131224781,131229176,131279542,131352979,131402042,131408004,131441258,131563233,131607303,131614625,131620988,131704038,131814558,131818728,131818784,131855435,132053491,132056305,132148691,132201012,132233249,132236506,132268971,132359467,132374956,132569269,132579504,132590938,132649373,132702272,132779430,132866933,133044408,133171084,133196329,133237897,133291598,133682765,133734212)
                and t1.account_no = t3.parent_account_no
                  AND t1.adj_trans_code = t2.adj_trans_code
                  AND t1.transact_date >= trunc(sysdate -90) -- RFC 272848
                  AND t1.transact_date < trunc(sysdate) -- RFC 272848
                  AND t1.adj_reason_code >= 900
                  AND t1.adj_reason_code <= 999
                  AND t1.request_status = 1
                  AND t2.billing_category = 2
        UNION   /* Adicionado para verificar pagamentos, de acordo com a altera��o da RFC_366331 */
        select  /*+ full(t1) parallel(t1 3)*/
                distinct 
                t1.account_no,
                t1.orig_bill_ref_no,
                t1.orig_bill_ref_resets,
                t3.subscr_no,
                t3.subscr_no_resets,
                DECODE(t4.open_item_id,1,0,2,0,3,0,91,90,92,90,t1.open_item_id) open_item_id,
                post_date
        from    bmf t1,
                bmf_distribution t4,
                service t3
        where   t1.account_no = t3.parent_account_no
        and     t1.account_no = t4.account_no
        and     t1.orig_bill_ref_no = t4.orig_bill_ref_no
        and     t1.bill_ref_resets = t4.bill_ref_resets
        and        t1.tracking_id = t4.bmf_tracking_id
        and        t1.tracking_id_serv = t4.bmf_tracking_id_serv
        and     t1.post_date >= trunc(sysdate -90) 
        and     t1.post_date < trunc(sysdate)  
        and     t1.bmf_trans_type in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO WHERE UPPER(DESCRIPTION_PGTO) LIKE 'BOLETO%')
        and     t4.orig_bill_ref_no in (125730912,129727410,130294185,130403531,130465559,130790855,130853066,131005297,131131083,131132088,131134667,131147143,131149643,131164391,131175789,131224781,131229176,131279542,131352979,131402042,131408004,131441258,131563233,131607303,131614625,131620988,131704038,131814558,131818728,131818784,131855435,132053491,132056305,132148691,132201012,132233249,132236506,132268971,132359467,132374956,132569269,132579504,132590938,132649373,132702272,132779430,132866933,133044408,133171084,133196329,133237897,133291598,133682765,133734212)
        order by 7
        
        
        select * from gvt_exec_arg where nome_programa = 'PL0201' order by 1 desc