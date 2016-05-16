--BAIXA SEM DÉBITO AUTOMATICO LIU pagamento manual

SET VERIFY                     OFF;
SET SERVEROUT                  ON SIZE 1000000;
SET FEED                       OFF;
SET SPACE                      0;
SET PAGESIZE                   0;
SET LINE                       500;
SET WRAP                       ON;
SET HEADING                    OFF;

DECLARE
      v_acct            NUMBER(10);
      v_bill_ref_no     number(10);
      v_BILL_REF_RESETS number(10);
      v_TRANS_TYPE      number(10);
      v_total             NUMBER(18);
      v_sqlerr             VARCHAR2(512);
      v_dt_fechamento   date;
      bmf_scrn_insert_cv cv_types.customer_tp;
      v_errcode         NUMBER(10);
      V_ERRMSG          varchar2(100);
      v_value           number(10);

   BEGIN
      v_errcode := 0;
      v_errmsg := NULL;
      v_value := 0;
       FOR tmp_ARQ_PROC IN (select * from cmf_balance where bill_ref_no in (145414262))
       loop                                     
          v_errcode := 0;
          v_errmsg := NULL;
          begin                    
              select  account_no, closed_date, bill_ref_no, BILL_REF_RESETS
                 into v_acct,  v_dt_fechamento, v_bill_ref_no, v_BILL_REF_RESETS
                 from cmf_balance 
                where bill_ref_no = tmp_ARQ_PROC.bill_ref_no
                  and NOT EXISTS
                         (SELECT * 
                            FROM bmf
                           WHERE account_no = tmp_ARQ_PROC.account_no
                             and orig_bill_ref_no = tmp_ARQ_PROC.bill_ref_no
                             and trunc(chg_date) = trunc(sysdate));
          EXCEPTION
            WHEN OTHERS
            THEN
              DBMS_OUTPUT.put_line (  'Não encontrou fatura ou Baixa duplicada' || tmp_ARQ_PROC.bill_ref_no || ' conta = ' || tmp_ARQ_PROC.account_no  ); 
          end;         


          if  v_errcode = 0 then
              BEGIN
              -- exemplo: tmp_arq_proc.bill_ref_no, .depende da tabela
                 bmf_scrn_insert(v_acct_external_id=>tmp_ARQ_PROC.account_no,
                                 v_external_id_type=>1,
                                 v_orig_inv=>tmp_arq_proc.bill_ref_no,
                                 v_orig_inv_resets=>v_BILL_REF_RESETS,
                                 v_amount=>tmp_arq_proc.NEW_CHARGES,
                                 v_trans_date=>tmp_arq_proc.PPDD_DATE,
                                 v_trans_type=> '-1' ,--tipo de pagamento 1 para debito (-1 para pagamento manual)
                                 v_chg_who=>'ARBORGVT_BILLING',
                                 v_orig_trackid=>NULL,
                                 v_micr_check_num=> to_char( sysdate, 'yyyymmdd') ,
                                 v_micr_bank_id=>'',
                                 v_micr_dda_num=>'',
                                 v_input_currency=>1,
                                 v_batch_id=>NULL,
                                 v_batch_id_serv=>NULL,
                                 v_datefmt=>1,
                                 v_action_code=>'APP',
                                 v_acct_seg_flag=>1,
                                 v_manual_ccauth_code=>NULL,
                                 v_manual_ccauth_date=>NULL,
                                 v_passed_account_no=>tmp_arq_proc.account_no,
                                 v_gl_amount=>tmp_arq_proc.NEW_CHARGES,
                                 v_external_amount=>tmp_arq_proc.NEW_CHARGES,
                                 v_external_currency=>1,
                                 v_external_amount_filled=>1,
                                 v_open_item_id=>1,
                                  bmf_scrn_insert_cv=>bmf_scrn_insert_cv);
                    
              -- update g0023421sql.arq_umreal set msg = 'OK' where bil_ref_no = tmp_arq_proc.fatura;
                   DBMS_OUTPUT.put_line ('FATURA OK  - ' || tmp_arq_proc.bill_ref_no  );
               EXCEPTION
               WHEN OTHERS THEN
              --  update g0023421sql.arq_umreal set msg = SQLERRM where bil_ref_no = tmp_arq_proc.fatura;
                DBMS_OUTPUT.put_line ('ERRO NA FATURA ' || tmp_arq_proc.bill_ref_no || '-' || SQLERRM  );
              END;
          end if;
       END LOOP;
 
 EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line ('** ERRO **   ERRO DESCONHECIDO ' || SQLERRM  );
      ROLLBACK;
 END;
 commit;
 
 
 -- delete from lbx_error where bill_ref_no = 137639378;
 
 -- commit;