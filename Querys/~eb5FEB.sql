        select  /*+ full(t1) parallel(t1 3)*/
                distinct 
                t1.account_no,
                t1.orig_bill_ref_no,
                t1.orig_bill_ref_resets,
                t3.subscr_no,
                t3.subscr_no_resets,
                t1.
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
        and     t1.account_no = 9315244
        -- and     t1.bmf_trans_type in (-224, -223, -262, -261, -260, -259, -258, -257, -256, -255, -278, -277, -276, -275, -274)
        and     t1.bmf_trans_type in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO)