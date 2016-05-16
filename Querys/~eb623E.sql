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
                WHERE t1.orig_bill_ref_no in (131606242,131768924,131832378,132894872,133171084,128336482,130294185,130515403,130723028,130832372,130850834,130971753,131132995,131144519,131166424,131178608,131181570,131200892,131255280,131336888,131345330,131361328,131361328,131384787,131407376,131436275,131454509,131548580,131561480,131561480,131562347,131563100,131584497,131606242,131614323,131620988,131648445,131664353,131671561,131685854,131721830,131750481,131762787,131769075,131831613,131843239,131853709,131862432,131886823,131886823,131891121,132011715,132022550,132023322,132059513,132122441,132160366,132236506,132236506,132239267,132259514,132288511,132307435,132313698,132318866,132413706,132700737,132714632,132753577,132839205,132841023,132851556,132868808,132931522,132943798,133054667,133090749,133124879,133140239,133164004,133164004,133299090)
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
        and     t4.orig_bill_ref_no in (131606242,131768924,131832378,132894872,133171084,128336482,130294185,130515403,130723028,130832372,130850834,130971753,131132995,131144519,131166424,131178608,131181570,131200892,131255280,131336888,131345330,131361328,131361328,131384787,131407376,131436275,131454509,131548580,131561480,131561480,131562347,131563100,131584497,131606242,131614323,131620988,131648445,131664353,131671561,131685854,131721830,131750481,131762787,131769075,131831613,131843239,131853709,131862432,131886823,131886823,131891121,132011715,132022550,132023322,132059513,132122441,132160366,132236506,132236506,132239267,132259514,132288511,132307435,132313698,132318866,132413706,132700737,132714632,132753577,132839205,132841023,132851556,132868808,132931522,132943798,133054667,133090749,133124879,133140239,133164004,133164004,133299090)
        order by 7;
        
        
        select * from gvt_exec_arg where nome_programa = 'PL0201' order by 1 desc
     