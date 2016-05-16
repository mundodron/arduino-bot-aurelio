SELECT account_no,
            bill_ref_no,
            bill_ref_resets,   /*code change done by vkamalak for CAMqa 71544 */
            orig_bill_ref_no,
            orig_bill_ref_resets,
            cr_note_bill_ref_no,
            cr_note_bill_ref_resets,
            90 d_rev_code,
            trans_date d_trans_date,
            sysdate d_date,
            currency_code,
            trans_amount,
            gl_amount,
            64810717 v_track_id,
            4 v_track_id_serv,
            orig_tracking_id,
            orig_tracking_id_serv,
            trans_source,
            source_type,
            source_id,
            source_id_serv,
            batch_id,
            batch_id_serv,
            'arbor',
             sysdate d_date,
            1,
            'REV',
            micr_bank_id,
            micr_dda_num,
            micr_check_num,
            arch_flag,
            manual_ccauth_code,
            manual_ccauth_date,
            1943500 d_distributed_amount,
            distributed_gl_amount,
            file_id,
            response_code,
            bill_order_number,
            external_amount,
            external_currency,
            open_item_id,
            discount_id,
            tax_type_code,
            annotation,
            pay_method,
            realtime_indicator,
            payment_profile_id
     FROM BMF
     WHERE tracking_id    = 64810717
     AND tracking_id_serv = 4
     AND no_bill          = 0
     
     
Error at line 1
ORA-20001: 131099, TRIG: INSERT/UPDATE Failed: Suspense account debit payment is not being made fro
m a valid refund source type.
ORA-06512: at "ARBOR.BMF_ATRIG", line 36
ORA-04088: error during execution of trigger 'ARBOR.BMF_ATRIG'
    
select * from bmf where account_no = 1202880

select * from customer_id_acct_map where account_no = 1202880

select * from all_tables where table_name like '%LOTERICA%' 

select * from GVT_PAGAMENTOS_LOTERICA

select * from cmf