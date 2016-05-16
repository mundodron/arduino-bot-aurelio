     SELECT DISTINCT t1.account_no,
                      t1.orig_bill_ref_no,
                      t1.orig_bill_ref_resets,
                      t3.subscr_no,
                      t3.subscr_no_resets,
                      DECODE(t1.open_item_id,1,0,2,0,3,0,91,90,92,90,t1.open_item_id) open_item_id,
                      t1.transact_date
                 FROM service t3,
                      adj_trans_descr t2,
                      adj t1
                WHERE t1.orig_bill_ref_no not in (select BILL_REF_NO from gvt_bankslip)-- t1.orig_bill_ref_no in (131620988,131620988,133237897,133044408,131818784,131818728,132579504,130790855,131005297,132866933,132236506,132236506,131149643,131607303,132053491,132233249,133171084,131175789,131279542,130294185,132374956,131131083,132359467,131147143,131563233,131402042,130403531,132590938,131352979,131352979)
                and t1.account_no = t3.parent_account_no
                  AND t1.adj_trans_code = t2.adj_trans_code
                  AND t1.transact_date >= trunc(sysdate - 90) -- RFC 272848
                  AND t1.transact_date < trunc(sysdate) -- RFC 272848
                  AND t1.adj_reason_code >= 900
                  AND t1.adj_reason_code <= 999
                  AND t1.request_status = 1
                  AND t2.billing_category = 2
        UNION   /* Adicionado para verificar pagamentos, de acordo com a alteração da RFC_366331 */
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
        and     t1.post_date >= trunc(sysdate - 90) 
        and     t1.post_date < trunc(sysdate)  
        and     t1.bmf_trans_type in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO WHERE UPPER(DESCRIPTION_PGTO) LIKE 'BOLETO%')
        -- and     t4.orig_bill_ref_no in (131620988,131620988,133237897,133044408,131818784,131818728,132579504,130790855,131005297,132866933,132236506,132236506,131149643,131607303,132053491,132233249,133171084,131175789,131279542,130294185,132374956,131131083,132359467,131147143,131563233,131402042,130403531,132590938,131352979,131352979)
        and t4.orig_bill_ref_no not in (select BILL_REF_NO from gvt_bankslip)
        order by 7;
        
        select * from gvt_exec_arg where nome_programa = 'PL0201' order by 1 desc
         
        select BILL_REF_NO from gvt_bankslip