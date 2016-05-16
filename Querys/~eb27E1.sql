DECLARE
   wdirspool_in                  VARCHAR2 (60) := '&1';
   warqspool_in                  VARCHAR2 (60) := '&2';
   harqspool_in                  UTL_FILE.file_type;   -- handle do arq. de spool
--*
   wdirspool_out                 VARCHAR2 (60) := NULL;   --'2';
   warqspool_out                 VARCHAR2 (60) := 'BILL_PAGTO_DIARIO_YYYYMMDDHH24MISSSS.txt';
   harqspool_out                 UTL_FILE.file_type;   -- handle do arq. de spool
--*
   v_mensagem                    VARCHAR2 (32000);
   e_geral                       EXCEPTION;
   aux_arquivo                   VARCHAR2 (32000);   -- Arquivo que conterá as informações de cada linha lida os arquivos da PL0802.
   v_cd_banco                    VARCHAR2 (3);
   v_ds_banco                    VARCHAR2 (20);
   v_ds_bancoaux                 VARCHAR2 (20);
   v_cd_tipopagto1               VARCHAR2 (1);
   v_ds_tipopagto1               VARCHAR2 (60);
   v_banco                       VARCHAR2 (10);
   v_base                        VARCHAR2 (10);
   v_ds_tipopagto1aux            VARCHAR2 (60);
   v_cd_tipopagto2               VARCHAR2 (1);
   v_ds_tipopagto2               VARCHAR2 (60);
   v_ds_tipopagto2aux            VARCHAR2 (60);
   v_ident_cliente               NUMBER (12);
   v_ident_fatura                NUMBER (10);
   v_ident_baixa                 NUMBER (10);
   v_vl_debito                   VARCHAR2 (60);
   v_vl_pagto                    VARCHAR2 (60);
   v_dt_pagto                    VARCHAR2 (10);
   v_dt_pagtoaux                 VARCHAR2 (10);
   v_dt_credito                  VARCHAR2 (10);
   v_dt_creditoaux               VARCHAR2 (10);
   v_ds_mensagem                 VARCHAR2 (60);
   v_seq_nsa                     NUMBER (5);
   v_seq_reg                     VARCHAR2 (10);
   v_nr_reg                      NUMBER := 0;
   v_nr_regtotal                 NUMBER := 0;
   o_trans_status                payment_trans.trans_status%TYPE;
   o_tracking_id                 payment_trans.tracking_id%TYPE;
   o_bill_ref_no                 payment_trans.bill_ref_no%TYPE;
   o_amount                      payment_trans.amount%TYPE;
   o_display_value               eft_response_code_values.display_value%TYPE;
   o_dt_vcto                     VARCHAR2 (10);
   o_external_id                 customer_id_acct_map.external_id%TYPE;
   o_account_no                  bmf.account_no%TYPE;
   o_mensagem                    VARCHAR2 (32000);
   v_cd_bancoaux                 VARCHAR2 (3);
   v_cd_tipopagto1aux            VARCHAR2 (1);
   v_cd_tipopagto2aux            VARCHAR2 (1);
   v_tot_debito                  NUMBER := 0;
   v_tot_pagto                   NUMBER := 0;
   v_tot_debitogeral             NUMBER := 0;
   v_tot_pagtogeral              NUMBER := 0;
/* */
   v_ds_cabecalho                VARCHAR2 (32000);
   v_ds_cabecalho1               VARCHAR2 (32000);
   v_ds_cabecalho2               VARCHAR2 (32000);
   v_ds_titulo                   VARCHAR2 (32000);

/* */
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   FUNCTION fun_ret_descricao_pagto (
      i_cd_banco IN VARCHAR2,
      i_cd_formapagto IN VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_ds_tipopagamento            VARCHAR2 (2000);
   BEGIN
      BEGIN
         SELECT UPPER (des.description_text)
           INTO v_ds_tipopagamento
           FROM lbx_payment_types pt,
                bmf_trans_descr btd,
                descriptions des
          WHERE pt.source_id LIKE i_cd_banco || '%'
            AND pt.ext_category LIKE i_cd_formapagto || '%'
            AND btd.bmf_trans_type = pt.bmf_trans_type
            AND des.description_code = btd.description_code
            AND des.language_code = 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ds_tipopagamento         := 'DESCRIÇÃO NÃO ENCONTRADA';
         WHEN TOO_MANY_ROWS
         THEN
            v_ds_tipopagamento         := 'DESCRIÇÃO ENCONTRADA VÁRIAS VEZES';
         WHEN OTHERS
         THEN
            v_ds_tipopagamento         := 'ERRO AO ENCONTRAR DESCRIÇÃO';
      END;

      RETURN v_ds_tipopagamento;
   END;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
/* PROCEDIMENTO CRIADO PARA PULAR UMA LINHA (CRIA UMA LINHA EM BRANCO) */
   PROCEDURE sub_pula_linha
   IS
   BEGIN
      UTL_FILE.put_line (harqspool_out, NULL);
   END sub_pula_linha;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_grava_cabecalho (
      i_cb_banco IN VARCHAR2,
      i_cb_banco2 IN VARCHAR2,
      i_cb_tipopagto1 IN VARCHAR2,
      i_cb_tipopagto2 IN VARCHAR2,
      i_cb_dt_pagto IN VARCHAR2
   )
   IS
      v_banco                       VARCHAR2 (040);
      v_cb_tipopagto1               VARCHAR2 (60);
      v_cb_tipopagto2               VARCHAR2 (60);
      v_cb_data_pgto                VARCHAR2 (60);
      v_seq_reg                     VARCHAR2 (020);
   BEGIN
      v_ds_cabecalho2            :=
            LPAD (' ', 12, ' ')
         || ';'
         || LPAD (' ', 10, ' ')
         || ';'
         || LPAD (' ', 10, ' ')
         || ';'
         || LPAD (' ', 15, ' ')
         || ';'
         || RPAD (' ', 15, ' ')
         || ';'
         || RPAD (' ', 10, ' ')
         || ';'
         || RPAD (' ', 50, ' ')
         || ';'
         || LPAD (' ', 6, ' ')
         || ';'
         || LPAD (' ', 24, ' ');

/* */
      IF (i_cb_tipopagto2 = 'G')
      THEN
         v_seq_reg                  := 'SEQ-REG';
      ELSE
         v_seq_reg                  := ' ';
      END IF;

      v_ds_cabecalho             :=
            LPAD ('IDENT CLIENT', 12, ' ')
         || ';'
         || LPAD ('IDENT FATURA', 12, ' ')
         || ';'
         || LPAD ('IDENT BAIXA', 11, ' ')
         || ';'
         || LPAD ('VALOR DEBITO', 15, ' ')
         || ';'
         || LPAD ('VALOR PAGO', 15, ' ')
         || ';'
         || RPAD ('DT PAGTO', 10, ' ')
         || ';'
         || RPAD ('MENSAGEM', 50, ' ')
         || ';'
         || LPAD ('SEQ-NSA', 10, ' ')
         || ';'
         || LPAD (v_seq_reg, 17, ' ');

/*
      DBMS_OUTPUT.put_line ('--******************************************************** ');
      DBMS_OUTPUT.put_line ('--ENTROU CABECALHO VARIAVEIS:');
      DBMS_OUTPUT.put_line ('-- - i_cb_banco      = ' || CHR (39) || i_cb_banco || CHR (39));
      DBMS_OUTPUT.put_line ('-- - i_cb_banco2 = ' || CHR (39) || i_cb_banco2 || CHR (39));
      DBMS_OUTPUT.put_line ('-- - i_cb_tipopagto1 = ' || CHR (39) || i_cb_tipopagto1 || CHR (39));
      DBMS_OUTPUT.put_line ('-- - i_cb_tipopagto2 = ' || CHR (39) || i_cb_tipopagto2 || CHR (39));
*/
      IF (i_cb_tipopagto2 = 'F')
      THEN
         v_cb_tipopagto2            := 'DEBITO AUTOMATICO';
      ELSIF (i_cb_tipopagto2 = 'G')
      THEN
         v_cb_tipopagto2            := 'CODIGO DE BARRAS';
      ELSE
         v_cb_tipopagto2            := 'CARTAO DE CREDITO';
      END IF;

--      DBMS_OUTPUT.put_line (' v_cb_tipopagto2 = ' || CHR (39) || v_cb_tipopagto2 || CHR (39));

      /* SOMENTE FARÁ O SELECT PARA BUSCAR A DESCRIÇÃO DO TIPO DE PAGAMENTO PARA OS DO TIPO "CÓDIGO DE BARRAS" */
      IF (i_cb_tipopagto2 = 'G')
      THEN
         v_cb_tipopagto1            := fun_ret_descricao_pagto (i_cb_banco, i_cb_tipopagto1);
         v_cb_data_pgto             := 'DATA CRED: ' || i_cb_dt_pagto;
      ELSE
         v_cb_tipopagto1            := NULL;
         v_cb_data_pgto             := RPAD (' ', 21, ' ');
      END IF;

--      DBMS_OUTPUT.put_line (' v_cb_tipopagto1 = ' || CHR (39) || v_cb_tipopagto1 || CHR (39));

      /* */
      IF (i_cb_tipopagto2 IN ('F', 'G'))
      THEN
         v_banco                    := LPAD (i_cb_banco, 3, ' ') || ';' || RPAD (i_cb_banco2, 20, ' ');
      ELSE
         v_banco                    := RPAD (i_cb_banco, 3, ' ') || ';' || RPAD (' ', 20, ' ');
      END IF;

--      DBMS_OUTPUT.put_line (' v_banco = ' || CHR (39) || v_banco || CHR (39));
--      DBMS_OUTPUT.put_line ('--******************************************************** ');
      v_ds_cabecalho1            :=
            RPAD ('BANCO: ', 07, ' ')
         || v_banco
         || ';'
         || RPAD (NVL (v_cb_tipopagto1, ' '), 50, ' ')
         || ';'
         || RPAD (NVL (v_cb_tipopagto2, ' '), 20, ' ')
         || ';'
         || RPAD (v_cb_data_pgto, 21, ' ')
         || ';               ;          ;                                                  ;;                    ';
      /*SELECT TRUNC(224 / 2) - TRUNC(LENGTH(V_DS_TITULO) / 2)
          INTO V_POS_INI
          FROM DUAL;*/

      /* PARA CALCULAR A POSIÇÃO INICIAL DE IMPRESSAO DO CABECALHO, DEVO DETERMINAR O TAMANHO TOTAL DO CABECALHO E ENCONTRAR A POSIÇÃO QUE
      ** CORRESPONDE A METADE DO ARQUIVO. APÓS ISSO, DEVO FAZER O MESMO COM O TITULO, ENCONTRADO O TAMANHO TOTAL E DIVIDINDO AO MEIO.
      ** DEPOIS DISSO, PARA ENCONTRAR A POSIÇÃO INICIAL, BASTA FAZER O CÁLCULO "POSIÇÃO MEIO/METADE DO CABEÇALHO MENOS (-) POSIÇÃO MEIO-METADE
      ** DO TÍTULO.
      */
      -- IMPRIME TITULO
--      UTL_FILE.put_line (harqspool_out, v_ds_titulo);
--      sub_pula_linha;
      -- IMPRIME CABEÇALHO
      UTL_FILE.put_line (harqspool_out, v_ds_cabecalho2);
      UTL_FILE.put_line (harqspool_out, v_ds_cabecalho1);
      UTL_FILE.put_line (harqspool_out, v_ds_cabecalho);
   EXCEPTION
      WHEN UTL_FILE.write_error
      THEN
         v_mensagem                 := '[SUB_grava_cabecalho] - UTL_FILE.WRITE_ERROR. Erro ao gravar: ' || SQLERRM;
         RAISE e_geral;
      WHEN UTL_FILE.invalid_operation
      THEN
         v_mensagem                 :=
                         '[SUB_grava_cabecalho] - UTL_FILE.INVALID_OPERATION. Erro de operação inválida: ' || SQLERRM;
         RAISE e_geral;
   END sub_grava_cabecalho;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_grava_gvt_ctrl_fluxo_caixa (
      i_ident_cliente IN VARCHAR2,
      i_ident_fatura IN VARCHAR2,
      i_ident_fatura_resets IN VARCHAR2,
      i_null IN VARCHAR2,
      i_dt_pagto IN DATE,
      i_dt_credito IN DATE,
      i_dias_bloqueio IN VARCHAR2,
      i_seq_nsa IN VARCHAR2,
      i_cd_banco IN VARCHAR2,
      i_cd_tipopagto2 IN VARCHAR2,
      i_vl_pagto IN VARCHAR2,
      i_sysdate DATE
   )
   IS
      v_sql_insert                  VARCHAR2 (5000)
         :=    'INSERT INTO gvt_ctrl_fluxo_caixa '
            || '     VALUES (:1_EXTERNAL_ID, '
            || '             :2_BILL_REF_NO, '
            || '             :3_BILL_REF_RESETS, '
            || '             :4_NUM_DOCUMENTO, '
            || '             :5_DATA_PAGAMENTO, '
            || '             :6_DATA_CREDITO, '
            || '             :7_QTDE_DIAS_BLOQUEIO, '
            || '             :8_COD_NSA_BANCO, '
            || '             :9_COD_BANCO, '
            || '             :10_TIPO_INTERFACE, '
            || '             :11_VALOR_TRANSACAO ) ';
--            || '             :12_DATA_MOVIMENTO )';
   BEGIN
/*
      DBMS_OUTPUT.put_line ('         sub_grava_gvt_ctrl_fluxo_caixa  ');
      DBMS_OUTPUT.put_line ('i_ident_cliente = ' || CHR (39) || i_ident_cliente || CHR (39));
      DBMS_OUTPUT.put_line ('i_ident_fatura = ' || CHR (39) || i_ident_fatura || CHR (39));
      DBMS_OUTPUT.put_line ('i_ident_fatura_resets = ' || CHR (39) || i_ident_fatura_resets || CHR (39));
      DBMS_OUTPUT.put_line ('i_null = ' || CHR (39) || i_null || CHR (39));
      DBMS_OUTPUT.put_line ('i_dt_pagto = ' || CHR (39) || i_dt_pagto || CHR (39));
      DBMS_OUTPUT.put_line ('i_dt_credito = ' || CHR (39) || i_dt_credito || CHR (39));
      DBMS_OUTPUT.put_line ('i_dias_bloqueio = ' || CHR (39) || i_dias_bloqueio || CHR (39));
      DBMS_OUTPUT.put_line ('i_seq_nsa = ' || CHR (39) || i_seq_nsa || CHR (39));
      DBMS_OUTPUT.put_line ('i_cd_banco = ' || CHR (39) || i_cd_banco || CHR (39));
      DBMS_OUTPUT.put_line ('i_cd_tipopagto2 = ' || CHR (39) || i_cd_tipopagto2 || CHR (39));
      DBMS_OUTPUT.put_line ('i_vl_pagto = ' || CHR (39) || i_vl_pagto || CHR (39));
*/
/*
      EXECUTE IMMEDIATE v_sql_insert
                  USING i_ident_cliente,
                        i_ident_fatura,
                        i_ident_fatura_resets,
                        i_NULL,
                        i_dt_pagto,
                        i_dt_credito,
                        i_dias_bloqueio,
                        i_seq_nsa,
                        i_cd_banco,
                        i_cd_tipopagto2,
                        i_vl_pagto;
*/
      INSERT INTO gvt_ctrl_fluxo_caixa
           VALUES (i_ident_cliente,
                   i_ident_fatura,
                   i_ident_fatura_resets,
                   NULL,
                   i_dt_pagto,
                   i_dt_credito,
                   i_dias_bloqueio,
                   i_seq_nsa,
                   i_cd_banco,
                   i_cd_tipopagto2,
                   i_vl_pagto,
                   SYSDATE
                  );

      COMMIT;
            DBMS_OUTPUT.put_line(i_ident_cliente);
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (   'ERRO GRAVAR gvt_ctrl_fluxo_caixa i_ident_cliente ='
                               || i_ident_cliente
                               || '  i_ident_fatura = '
                               || i_ident_fatura
                              );
         DBMS_OUTPUT.put_line ('ORACLE = ' || SQLERRM);
         
   END sub_grava_gvt_ctrl_fluxo_caixa;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_grava_detalhe (
      i_cd_banco IN VARCHAR2,
      i_ds_banco IN VARCHAR2,
      i_ds_tipopagto1 IN VARCHAR2,
      i_ds_tipopagto2 IN VARCHAR2,
      i_ident_cliente IN NUMBER,
      i_ident_fatura IN NUMBER,
      i_ident_baixa IN NUMBER,
      i_vl_debito IN VARCHAR2,
      i_vl_pagto IN VARCHAR2,
      i_dt_pagto IN VARCHAR2,
      i_dt_credito IN VARCHAR2,
      i_ds_mensagem IN VARCHAR2,
      i_seq_nsa IN NUMBER,
      i_seq_reg IN VARCHAR2
   )
   IS
   BEGIN
      UTL_FILE.put_line (harqspool_out,
                            LPAD (i_ident_cliente, 12, ' ')
                         || ';'
                         || LPAD (i_ident_fatura, 10, '0')
                         || ';'
                         || LPAD (i_ident_baixa, 10, '0')
                         || ';'
                         || LPAD (TO_CHAR (i_vl_debito, 'FM9999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || LPAD (TO_CHAR (i_vl_pagto, 'FM9999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || RPAD (NVL (i_dt_pagto, ' '), 10, ' ')
                         || ';'
                         || RPAD (NVL (i_ds_mensagem, ' '), 50, ' ')
                         || ';'
                         || LPAD (i_seq_nsa, 06, ' ')
                         || ';'
                         || LPAD (i_seq_reg, 8, ' ')
                         || RPAD (' ', 24, ' ')
                        );
      v_nr_reg                   := NVL (v_nr_reg, 0) + 1;
      v_nr_regtotal              := NVL (v_nr_regtotal, 0) + 1;
   EXCEPTION
      WHEN UTL_FILE.write_error
      THEN
         v_mensagem                 := '[sub_grava_detalhe] - UTL_FILE.WRITE_ERROR. Erro ao gravar: ' || SQLERRM;
         RAISE e_geral;
      WHEN UTL_FILE.invalid_operation
      THEN
         v_mensagem                 :=
                           '[sub_grava_detalhe] - UTL_FILE.INVALID_OPERATION. Erro de operação inválida: ' || SQLERRM;
         RAISE e_geral;
   END sub_grava_detalhe;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_valida_debitoautomatico (
      i_cd_banco IN VARCHAR2,
      i_tracking_id IN NUMBER,
      o_trans_status OUT payment_trans.trans_status%TYPE,
      o_tracking_id OUT payment_trans.tracking_id%TYPE,
      o_bill_ref_no OUT payment_trans.bill_ref_no%TYPE,
      o_amount OUT payment_trans.amount%TYPE,
      o_display_value OUT eft_response_code_values.display_value%TYPE,
      o_dt_vcto OUT VARCHAR2
   )
   IS
   BEGIN
---------------
/* DAM BL846 */
---------------
      BEGIN
         SELECT eft.trans_status,
                eft.tracking_id,
                eft.bill_ref_no,
                eft.amount,
                des.display_value,
                TO_CHAR (eft.payment_due_date, 'DD/MM/YYYY')
           INTO o_trans_status,
                o_tracking_id,
                o_bill_ref_no,
                o_amount,
                o_display_value,
                o_dt_vcto
           FROM payment_trans eft,
                eft_response_code_values des
          WHERE des.language_code = 2
            AND eft.response_code = des.response_code
            AND des.clearing_house_id = i_cd_banco
            AND eft.tracking_id = i_tracking_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            o_trans_status             := -1;
            o_tracking_id              := 0;
            o_bill_ref_no              := 0;
            o_amount                   := 0;
            o_display_value            := 'Fatura não encontrada';
            o_dt_vcto                  := TO_CHAR (SYSDATE, 'DD/MM/YYYY');
         WHEN TOO_MANY_ROWS
         THEN
            o_trans_status             := -1;
            o_tracking_id              := 0;
            o_bill_ref_no              := 0;
            o_amount                   := 0;
            o_display_value            := 'Fatura encontrada várias vezes';
            o_dt_vcto                  := TO_CHAR (SYSDATE, 'DD/MM/YYYY');
         WHEN OTHERS
         THEN
            o_trans_status             := -1;
            o_tracking_id              := 0;
            o_bill_ref_no              := 0;
            o_amount                   := 0;
            o_display_value            := 'Fatura encontrada várias vezes';
            o_dt_vcto                  := TO_CHAR (SYSDATE, 'DD/MM/YYYY');
      END;
   END sub_valida_debitoautomatico;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_valida_codigodebarra (
      i_cd_banco IN VARCHAR2,
      i_tracking_id IN NUMBER,
      o_amount OUT payment_trans.amount%TYPE,
      o_external_id OUT customer_id_acct_map.external_id%TYPE,
      o_bill_ref_no OUT payment_trans.bill_ref_no%TYPE
   )
   IS
   BEGIN
---------------
/* DAM BL847 */
---------------
      BEGIN
         SELECT   SUM (bmf.trans_amount),
                  ext.external_id,
                  bmf.orig_bill_ref_no
             INTO o_amount,
                  o_external_id,
                  o_bill_ref_no
             FROM customer_id_acct_map ext,
                  bmf,
                  bill_invoice bill,
                  trans_source_ref tra
            WHERE bmf.account_no = bill.account_no
              AND bmf.orig_bill_ref_no = bill.bill_ref_no
              AND tra.trans_source = bmf.trans_source
              AND ext.account_no = bill.account_no
              AND ext.external_id_type = 1
              AND bill.bill_ref_no = i_tracking_id
              AND RTRIM (tra.source_id) LIKE i_cd_banco || '%'
         GROUP BY bmf.orig_bill_ref_no,
                  ext.external_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            o_amount                   := 0;
            o_external_id              := '-1';
            o_bill_ref_no              := 0;
         WHEN TOO_MANY_ROWS
         THEN
            o_amount                   := 0;
            o_external_id              := '-1';
            o_bill_ref_no              := 0;
         WHEN OTHERS
         THEN
            o_amount                   := 0;
            o_external_id              := '-1';
            o_bill_ref_no              := 0;
      END;
   END;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_valida_cartaocredito (
      i_cd_banco IN VARCHAR2,
      i_tracking_id IN NUMBER,
      o_external_id OUT customer_id_acct_map.external_id%TYPE,
      o_trans_status OUT payment_trans.trans_status%TYPE,
      o_bill_ref_no OUT payment_trans.bill_ref_no%TYPE,
      o_amount OUT payment_trans.amount%TYPE,
      o_display_value OUT eft_response_code_values.display_value%TYPE,
      o_account_no OUT bmf.account_no%TYPE
   )
   IS
   BEGIN
---------------
/* DAM BL848 */
---------------
      BEGIN
         SELECT /*+ ALL_ROWS */
                external_id,
                trans_status,
                bill_ref_no,
                amount,
                display_value,
                cca.account_no
           INTO o_external_id,
                o_trans_status,
                o_bill_ref_no,
                o_amount,
                o_display_value,
                o_account_no
           FROM payment_trans cca,
                customer_id_acct_map ext,
                ccard_response_code_values des
          WHERE ext.account_no = cca.account_no
            AND des.response_code = cca.response_code
            AND des.language_code = 2
            AND ext.external_id_type = 1
            AND cca.tracking_id = i_tracking_id
            AND des.clearing_house_id = i_cd_banco;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            o_external_id              := 0;
            o_trans_status             := -1;
            o_bill_ref_no              := 0;
            o_amount                   := 0;
            o_display_value            := 'Fatura não encontrada';
            o_account_no               := 0;
         WHEN TOO_MANY_ROWS
         THEN
            o_external_id              := 0;
            o_trans_status             := -1;
            o_bill_ref_no              := 0;
            o_amount                   := 0;
            o_display_value            := 'Fatura não encontrada';
            o_account_no               := 0;
         WHEN OTHERS
         THEN
            o_external_id              := 0;
            o_trans_status             := -1;
            o_bill_ref_no              := 0;
            o_amount                   := 0;
            o_display_value            := 'Fatura não encontrada';
            o_account_no               := 0;
      END;
   END;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_quebra_pagina
   IS
   BEGIN
      UTL_FILE.put_line (harqspool_out,
                            'QTDE :'
                         || LPAD (v_nr_reg, 6, 0)
                         || ';'
                         || LPAD ('TOTAL : ', 08, ' ')
                         || ';'
                         || LPAD (TO_CHAR (v_tot_debito, 'FM9999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || LPAD (TO_CHAR (v_tot_pagto, 'FM9999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || RPAD ('DIFERENCA : ', 12, ' ')
                         || ';'
                         || LPAD (TO_CHAR (v_tot_debito - v_tot_pagto,
                                           'FM9999G999G990D00',
                                           'NLS_NUMERIC_CHARACTERS = '',.'''
                                          ),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || ';                                                  ;;                         '
                        );
      v_nr_reg                   := 0;
      v_tot_debito               := 0;
      v_tot_pagto                := 0;
   END sub_quebra_pagina;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE sub_grava_totalgeral
   IS
   BEGIN
      UTL_FILE.put_line
                     (harqspool_out,
                         '          ;                     ;           ;                     ;'
                      || '                     ;;                                                   ;;                 '
                     );
      UTL_FILE.put_line
                      (harqspool_out,
                          'TOTAL GERAL ;        ;               ;               ;            ;'
                       || '               ;                                                  ;;                         '
                      );
      UTL_FILE.put_line (harqspool_out,
                            RPAD ('QTDE  ', 6, ' ')
                         || LPAD (v_nr_regtotal, 6, 0)
                         || ';'
                         || RPAD ('TOTAL : ', 8, ' ')
                         || ';'
                         || LPAD (TO_CHAR (v_tot_debitogeral, 'FM9999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || LPAD (TO_CHAR (v_tot_pagtogeral, 'FM9999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || LPAD ('DIFERENCA : ', 12, ' ')
                         || ';'
                         || LPAD (TO_CHAR (v_tot_debitogeral - v_tot_pagtogeral,
                                           'FM9999G999G990D00',
                                           'NLS_NUMERIC_CHARACTERS = '',.'''
                                          ),
                                  15,
                                  ' '
                                 )
                         || ';'
                         || '                                                  ;;                         '
                        );
   END;
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
BEGIN

   --WDIRSPOOL    := '/home/arbor/data/log';
      
   wdirspool_out              := wdirspool_in;
   --WDIRSAIDA    := '/home/arbor/data/log';

   -- Nome do arquivo de origem dos dados (ARQUIVO_TEMPBL6000_CLASSIFICADO.TXT)
   --wqwarqspool_in               := 'ARQUIVO_TEMPBL6000_CLASSIFICADO.TXT';

   --dbms_output.put_line ('00');
   BEGIN
      -- Abre o arquivo gravado para processá-lo.
      dbms_output.put_line (wdirspool_in);
      harqspool_in               := UTL_FILE.fopen (wdirspool_in, warqspool_in, 'R');
      dbms_output.put_line (wdirspool_in);
   EXCEPTION
      --WHEN UTL_FILE.invalid_path
      WHEN others
      THEN
         DBMS_OUTPUT.put_line ('Problemas ao tentar abrir o arquivo (' || warqspool_in || ') para leitura. Verifique');
   END;

   -- Nome do arquivo de saída
   SELECT GLOBAL_NAME into v_base FROM GLOBAL_NAME;
   
   warqspool_out              := 'BILL_PAGTO_DIARIO_' || TO_CHAR (sysdate, 'YYYYMMDDHH24MISSSS') ||'_'|| v_base || '.txt';
   harqspool_out              := UTL_FILE.fopen (wdirspool_out, warqspool_out, 'W');
   -- Percorre o arquivo recém aberto para coletar as informações para gravar o novo
   v_ds_titulo                :=
         RPAD (' ', 07, ' ')
      || ';'
      || RPAD ('RELACAO DOS', 12, ' ')
      || ';'
      || RPAD ('PAGAMENTOS DIARIOS', 18, ' ')
      || ';'
      || RPAD (' ', 10, ' ')
      || TO_CHAR (SYSDATE, 'DD/MM/YY')
      || '  '
      || ';'
      || '               '
      || ';'
      || '          '
      || ';'
      || '                                                  '
      || ';'
      || ';'
      || '                    ';
   UTL_FILE.put_line (harqspool_out, v_ds_titulo);
   

   LOOP
      BEGIN
         -- Obtém a string com os dados da linha
         UTL_FILE.get_line (harqspool_in, aux_arquivo);
         /* Esses campos abaixo possuem a mesma posição para todos os tipos de pagamento */
         v_cd_banco                 := LPAD (SUBSTR (aux_arquivo, 1, 3), 3, ' ');
         v_cd_tipopagto2            := SUBSTR (aux_arquivo, 38, 1);
         v_ds_banco                 := SUBSTR (aux_arquivo, 4, 20);
         v_seq_nsa                  := SUBSTR (aux_arquivo, 34, 4);
         v_dt_pagto                 :=
                SUBSTR (aux_arquivo, 45, 2) || '/' || SUBSTR (aux_arquivo, 43, 2) || '/'
                || SUBSTR (aux_arquivo, 39, 4);   -- Dt débito
         

         /* SOMENTE FARÁ O SELECT PARA BUSCAR A DESCRIÇÃO DO TIPO DE PAGAMENTO PARA OS DO TIPO "CÓDIGO DE BARRAS" */
         IF (v_cd_tipopagto2 = 'G')
         THEN
            v_cd_tipopagto1            := SUBSTR (aux_arquivo, 112, 1);
         ELSE
            v_cd_tipopagto1            := NULL;
         END IF;

/* Os campos abaixo já variam de posição de acordo com o tipo de pagamento */
------------------------
/* DEBITO AUTOMATICO */
------------------------
         IF (v_cd_tipopagto2 = 'F')
         THEN
----------------------
/* VERIFICA QUEBRAS */
----------------------
            
/*
            v_ds_banco                 := SUBSTR (aux_arquivo, 4, 20);
            v_seq_nsa                  := SUBSTR (aux_arquivo, 34, 4);
            v_dt_pagto                 :=
                 SUBSTR (aux_arquivo, 45, 2) || '/' || SUBSTR (aux_arquivo, 43, 2) || '/'
                 || SUBSTR (aux_arquivo, 39, 4);   -- Dt débito
*/
            v_ident_cliente            := SUBSTR (aux_arquivo, 62, 12);
            v_ident_baixa              := SUBSTR (aux_arquivo, 74, 10);
            v_seq_reg                  := NULL;   -- Não vai existir nos registros do tipo Débito Automático
--            v_dt_credito               := NULL; --' ';
            --dbms_output.put_line ('05.3');
            
            --Correcao aplicada: data de credito estava recebendo data de vencimento e foi alterado para da a data de pgto receber a data de vcto.
            --09/04/2010
            sub_valida_debitoautomatico (v_cd_banco,
                                         v_ident_baixa,
                                         o_trans_status,
                                         o_tracking_id,
                                         o_bill_ref_no,
                                         o_amount,
                                         o_display_value,
                                         o_dt_vcto
                                        );
            v_dt_pagto                  := o_dt_vcto;
            
            -- Alterado para imprimir o cabeçalho somente apos os critérios abaixo nao sofrerem mais alteracao
            IF    (v_cd_banco <> v_cd_bancoaux)
               OR (v_cd_tipopagto2 <> v_cd_tipopagto2aux)
               OR (v_cd_tipopagto1 <> v_cd_tipopagto1aux)
               OR (v_dt_pagto <> v_dt_pagtoaux)
            THEN
               sub_quebra_pagina;
               sub_grava_cabecalho (v_cd_banco, v_ds_banco, v_cd_tipopagto1, v_cd_tipopagto2, v_dt_pagto);
            END IF;

            
            v_dt_credito                := 
                SUBSTR (aux_arquivo, 45, 2) || '/' || SUBSTR (aux_arquivo, 43, 2) || '/'
                || SUBSTR (aux_arquivo, 39, 4);   -- Dt débito

            
            --dbms_output.put_line ('05.4');
            IF (o_trans_status = -1)
            THEN   -- Se não encontrou nada ou ocorreu algum problema
               v_vl_debito                := 0;
               v_ident_fatura             := 0;
               v_ds_mensagem              := o_display_value;   -- (fatura não encontrada)
               v_vl_pagto                 := (SUBSTR (aux_arquivo, 47, 15) / 100);   -- valor credito (usa o valor de débito)
            ELSIF (o_trans_status = 8)
            THEN   -- Se for igual 8
               v_vl_debito                := TO_CHAR (o_amount / 100, 'FM99999999999.99');
               v_ident_fatura             := o_bill_ref_no;   -- (retornado do select)
               v_ds_mensagem              := 'Débito efetuado';
               v_vl_pagto                 := (SUBSTR (aux_arquivo, 47, 15) / 100);   -- valor credito (usa o valor de débito)
            ELSE   -- Outros
               v_vl_debito                := 0;
               v_ident_fatura             := 0;
               v_ds_mensagem              := o_mensagem;
               v_vl_pagto                 := (SUBSTR (aux_arquivo, 47, 15) / 100);   -- valor credito (usa o valor de débito)
            END IF;

            --dbms_output.put_line ('05.5');
            v_dt_pagtoaux              := v_dt_pagto;
         --dbms_output.put_line ('05.55');

         ----------------------
/* CÓDIGO DE BARRAS */
----------------------
         ELSIF (v_cd_tipopagto2 = 'G')
         THEN
            --dbms_output.put_line ('06');

            ----------------------
/* VERIFICA QUEBRAS */
----------------------
            v_ds_banco                 := SUBSTR (aux_arquivo, 4, 20);
            v_seq_nsa                  := SUBSTR (aux_arquivo, 34, 4);
            v_ident_baixa              := SUBSTR (aux_arquivo, 59, 10);
            -- atribuição de v_dt_pagto descomentado em 11-04-2011
            v_dt_pagto                 :=
                SUBSTR (aux_arquivo, 75, 2) || '/' || SUBSTR (aux_arquivo, 73, 2) || '/'
                || SUBSTR (aux_arquivo, 69, 4);  --- data de transacao (data em que o cliente realizou o pagamento)
            v_seq_reg                  := SUBSTR (aux_arquivo, 96, 8);
            v_dt_credito               :=
                SUBSTR (aux_arquivo, 45, 2) || '/' || SUBSTR (aux_arquivo, 43, 2) || '/'
                || SUBSTR (aux_arquivo, 39, 4);
            sub_valida_codigodebarra (v_cd_banco, v_ident_baixa, o_amount, o_external_id, o_bill_ref_no);

            IF    (v_cd_banco <> v_cd_bancoaux)
               OR (v_cd_tipopagto2 <> v_cd_tipopagto2aux)
               OR (v_cd_tipopagto1 <> v_cd_tipopagto1aux)
               OR (v_dt_credito <> v_dt_creditoaux)
            THEN
               sub_quebra_pagina;
               sub_grava_cabecalho (v_cd_banco, v_ds_banco, v_cd_tipopagto1, v_cd_tipopagto2, v_dt_pagto);
            END IF;

            IF (o_external_id = '-1')
            THEN   -- Se não encontrou nada ou ocorreu algum problema
               v_ident_cliente            := SUBSTR (aux_arquivo , 47, 12);
               v_ident_fatura             := 0;
               v_vl_debito                := 0;
               v_ds_mensagem              := 'Fatura não atualizada';
               v_vl_pagto                 := SUBSTR (aux_arquivo, 77, 12) / 100;   -- valor pago (usa o valor de débito)
            --DBMS_OUTPUT.put_line (SUBSTR(AUX_ARQUIVO, 77, 12));
            --DBMS_OUTPUT.put_line (SUBSTR(AUX_ARQUIVO, 77, 12) / 100);
            ELSE
               v_ident_cliente            := o_external_id;
               v_ident_fatura             := o_bill_ref_no;
               v_vl_debito                := o_amount / 100;
               v_ds_mensagem              := 'Débito efetuado';
               v_vl_pagto                 := SUBSTR (aux_arquivo, 77, 12) / 100;   -- valor pago (usa o valor de débito)
            END IF;

            v_dt_creditoaux            := v_dt_credito;
  --dbms_output.put_line ('06.1');
-----------------------
/* CARTÃO DE CRÉDITO */
-----------------------
         ELSE
            --dbms_output.put_line ('07');

            ----------------------
/* VERIFICA QUEBRAS */
----------------------
            IF    (v_cd_banco <> v_cd_bancoaux)
               OR (v_cd_tipopagto2 <> v_cd_tipopagto2aux)
               OR (v_cd_tipopagto1 <> v_cd_tipopagto1aux)
               OR (v_ds_banco <> v_ds_bancoaux)
            THEN
               sub_quebra_pagina;
               sub_grava_cabecalho (v_cd_banco, v_ds_banco, v_cd_tipopagto1, v_cd_tipopagto2, v_dt_pagto);
            END IF;

            v_ds_banco                 := SUBSTR (aux_arquivo, 4, 10);
            v_seq_nsa                  := SUBSTR (SUBSTR (aux_arquivo, 75, 20), 13, 4);   -- Número cartão (Primeiro pego os 20 caracteres, depois a partir da posição 13, pego 4 caracteres)
            v_ident_baixa              := SUBSTR (aux_arquivo, 65, 10);
            v_dt_pagto                 :=
                 SUBSTR (aux_arquivo, 45, 2) || '/' || SUBSTR (aux_arquivo, 43, 2) || '/'
                 || SUBSTR (aux_arquivo, 39, 4);
            v_dt_credito               := TO_CHAR (SYSDATE, 'DD/MM/YYYY');
            sub_valida_cartaocredito (v_cd_banco,
                                      v_ident_baixa,
                                      o_external_id,
                                      o_trans_status,
                                      o_bill_ref_no,
                                      o_amount,
                                      o_display_value,
                                      o_account_no
                                     );

            IF (o_trans_status = -1)
            THEN   -- Se não encontrou nada ou ocorreu algum problema
               v_ident_cliente            := 0;
               v_ident_fatura             := 0;
               v_vl_pagto                 := (SUBSTR (aux_arquivo, 53, 12) / 100);   -- valor pago (usa o valor de débito)
               v_vl_debito                := 0;
               v_ds_mensagem              := o_display_value;
            ELSIF (o_trans_status = 8)
            THEN   -- Se for igual 8
               v_ident_cliente            := o_external_id;
               v_ident_fatura             := o_bill_ref_no;
               v_vl_debito                := (o_amount / 100);
               v_ds_mensagem              := 'Débito efetuado';
               v_vl_pagto                 := (SUBSTR (aux_arquivo, 53, 12) / 100);   -- valor pago (usa o valor de débito)
            ELSE   -- Outros
               v_ident_cliente            := o_external_id;
               v_ident_fatura             := o_bill_ref_no;
               v_vl_pagto                 := (SUBSTR (aux_arquivo, 53, 12) / 100);   -- valor pago (usa o valor de débito)
               v_vl_debito                := 0;
               v_ds_mensagem              := o_display_value;
            END IF;

            v_ds_bancoaux              := v_ds_banco;
            /* NO TIPO DE PAGAMENTO CARTÃO DE CRÉDITO, O CÓDIGO DO BANCO NÃO É IMPRESSO */
            v_cd_banco                 := NULL;
         --dbms_output.put_line ('07.1');
         END IF;

         --dbms_output.put_line ('antes sub_grava_detalhe');

         --dbms_output.put_line ('débito: '||V_VL_DEBITO);
         --dbms_output.put_line ('vl pagto: '||V_VL_PAGTO);
         IF (v_nr_regtotal = 0)
         THEN
            sub_grava_cabecalho (v_cd_banco, v_ds_banco, v_cd_tipopagto1, v_cd_tipopagto2, v_dt_pagto);
         END IF;

         sub_grava_detalhe (v_cd_banco,
                            v_ds_banco,
                            v_ds_tipopagto1,
                            v_ds_tipopagto2,
                            v_ident_cliente,
                            v_ident_fatura,
                            v_ident_baixa,
                            v_vl_debito,
                            v_vl_pagto,
                            v_dt_pagto,
                            v_dt_credito,
                            v_ds_mensagem,
                            v_seq_nsa,
                            v_seq_reg
                           );
         --dbms_output.put_line ('depois sub_grava_detalhe');
         sub_grava_gvt_ctrl_fluxo_caixa (v_ident_cliente,
                                         v_ident_fatura,
                                         '0',
                                         NULL,
                                         TO_DATE (v_dt_pagto, 'DD/MM/YYYY'),
                                         TO_DATE (v_dt_credito, 'DD/MM/YYYY'),
                                         '0',
                                         v_seq_nsa,
                                         v_cd_banco,
                                         v_cd_tipopagto2,
                                         TO_CHAR ((v_vl_pagto * 100), 'FM000000000000000'),
                                         SYSDATE
                                        );
         --dbms_output.put_line ('tot 1');
         v_tot_debito               := NVL (v_tot_debito, 0) + v_vl_debito;
         v_tot_pagto                := NVL (v_tot_pagto, 0) + v_vl_pagto;
         --dbms_output.put_line ('tot 2');
         v_tot_debitogeral          := NVL (v_tot_debitogeral, 0) + NVL (v_vl_debito, 0);
         v_tot_pagtogeral           := NVL (v_tot_pagtogeral, 0) + NVL (v_vl_pagto, 0);
         --dbms_output.put_line ('tot 3');
         v_cd_tipopagto1aux         := v_cd_tipopagto1;
         v_cd_tipopagto2aux         := v_cd_tipopagto2;   -- (Débito em Conta/Código de Barras/Cartão de Crédito)
         v_cd_bancoaux              := v_cd_banco;
         v_ds_bancoaux              := v_ds_banco;
-----         v_ds_tipopagto1aux         := v_ds_tipopagto1;
-----         v_ds_tipopagto2aux         := v_ds_tipopagto2;
      --dbms_output.put_line ('tot 4');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            -- Fecha o arquivo aberto (ARQUIVO_TEMPBL6000_CLASSIFICADO.TXT)
            UTL_FILE.fclose (harqspool_in);
            EXIT;
      END;
   END LOOP;

   sub_quebra_pagina;
   sub_grava_totalgeral;
   -- Fecha o novo arquivo gravado atual
   UTL_FILE.fclose (harqspool_out);
   DBMS_OUTPUT.put_line ('ARQUIVO ' || warqspool_out || ' GERADO COM SUCESSO.');
EXCEPTION
   WHEN e_geral
   THEN
      DBMS_OUTPUT.put_line ('E_GERAL: ' || v_mensagem);

      IF (UTL_FILE.is_open (harqspool_in))
      THEN
         UTL_FILE.fflush (harqspool_in);
         UTL_FILE.fclose (harqspool_in);
      END IF;

      IF (UTL_FILE.is_open (harqspool_out))
      THEN
         UTL_FILE.fflush (harqspool_out);
         UTL_FILE.fclose (harqspool_out);
      END IF;

      ROLLBACK;
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('OTHERS: ' || SQLERRM);

      IF (UTL_FILE.is_open (harqspool_in))
      THEN
         UTL_FILE.fflush (harqspool_in);
         UTL_FILE.fclose (harqspool_in);
      END IF;

      IF (UTL_FILE.is_open (harqspool_out))
      THEN
         UTL_FILE.fflush (harqspool_out);
         UTL_FILE.fclose (harqspool_out);
      END IF;

      ROLLBACK;
END;
/

