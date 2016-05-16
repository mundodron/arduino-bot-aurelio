SET serverout on;

DECLARE
----------------------------------------------------------------------------------------------
-- Versão: Autor:               Data:       Doc:        Motivo:
   ------  -------------------- ----------- ----------- --------------------------------------
-- 1.1     g0010388 Valter      27/SEP/2010 RFC 272848  A PL "pl_corrige_data_boleto_ajuste" abortou, pois usava os parametros da tabela act_exec_arg. 
--                                                                                  Os scripts foram tranferidos para esta PL.
-- 1.2     g0010388 Valter      14/07/2011  RFC 313228  O Update não atualizava o status de 'R' para 'B', ou '5', ou 'D'.
-- 1.3     g0013798 Felipe      06/07/2012  RFC 366331  Adicionado UNION no cursor c_adj para verificar pagamentos na tabela BMF. Ajustes da tabela ajuste_massivo serão inseridos 
--                                                        na tabela BMF como pagamentos. As alterações no ajuste_massivo estão na RFC_366331 e GVTPM-37710.
-- 1.4       g0013798 Felipe        17/08/2012  RFC 377831  Adicionada uma validação na QUERY para que não pegue os casos que tenham ajuste do tipo boleto, para que os mesmos
--                                                        possam ser inseridos na gvt_bankslip. Quando encontrava clientes com somente um pagamento para a mesma fatura ele não 
--                                                        gerava boleto e quando encontrava mais de um pagamento, gerava pois caia na exception que deixava a variável nula.
-- 1.5       g0013798 Felipe      17/08/2012  RFC 377831  Adicionada validação na query para que a mesma some valores caso encontre pagamentos do tipo boleto
-- 1.6     G0013798 Felipe      27/08/2012  RFC 383229  Adicionada função CONVERT em todos os pontos em que a PL grava dados no arquivo para evitar com que caracteres especiais
--                                                        sejam gravados.
----------------------------------------------------------------------------------------------
   wdirspool                     VARCHAR2 (60) := '1';
   warqspoolb                    VARCHAR2 (60) := 'BOLETO.txt';
   harqspoolb                    UTL_FILE.file_type;   -- handle do arq. de spool
   warqspoolc                    VARCHAR2 (60) := 'CLIENTE.txt';
   harqspoolc                    UTL_FILE.file_type;   -- handle do arq. de spool
   warqspoold                    VARCHAR2 (60) := 'PL_BANKSLIP_PROBLEMAS.txt';
   harqspoold                    UTL_FILE.file_type;   -- handle do arq. de spool
   --INI RFC 272848
   warqspoole                    VARCHAR2 (60) := 'PL_BANKSLIP_DATA_VENCTO';
   harqspoole                    UTL_FILE.file_type;
   v_data_vencto                 date;
   v_qt_status_V                 number(8);
   v_qt_status_P                 number(8);
   v_qt_status_T                 number(8);
   v_qt_pagos                    number(8);
   v_qt_total                    number(8);
   --FIM RFC 272848
   v_executa_atu                 VARCHAR2 (30) := NULL;   -- controle erro: nome proced em execucao
   v_executa_ant                 VARCHAR2 (30) := NULL;   -- controle erro: nome proced em execucao
   erro_geral                    EXCEPTION;
   sem_movimento                 EXCEPTION;
   erro_despesa                  EXCEPTION;
   v_nome_programa               gvt_exec_arg.nome_programa%TYPE := 'PL0201';
   v_data_sistema                DATE;
   v_data_ini                    DATE;
   v_data_fim                    DATE;
   v_proxima_execucao            VARCHAR2 (020);
   v_aux_data                    gvt_exec_arg.desc_parametro%TYPE;
   v_aux_num_execucao            gvt_exec_arg.num_execucao%TYPE;
   v_aux_tem_execucao            BOOLEAN;
   v_conta_credito               jnl_custom.fml_acct_cr%TYPE;
   v_conta_debito                jnl_custom.fml_acct_db%TYPE;
   v_total_debitos               NUMBER (13, 2);
   v_total_creditos              NUMBER (13, 2);
/**/
   v_sequencial                  NUMBER (06);
   v_bmf_chg_date                bmf.chg_date%TYPE;
   v_cmfb_ppdd_date              cmf_balance.ppdd_date%TYPE;
   v_bmf_trans_amount            bmf.trans_amount%TYPE;
   v_cmfb_orig_ppdd_date         cmf_balance.ppdd_date%TYPE;
   v_cmfb_total_paid             cmf_balance.total_paid%TYPE;
   v_cmfb_balance_due            cmf_balance.balance_due%TYPE;
   v_cmfb_new_charges            cmf_balance.new_charges%TYPE;
   v_bit_bill_amount             gvt_bill_invoice_total.bill_amount%TYPE;
   v_bit_bill_bank_draft_date    gvt_bill_invoice_total.bill_bank_draft_date%TYPE;
   v_bit_bill_bank_draft_amount  gvt_bill_invoice_total.bill_bank_draft_amount%TYPE;
   v_adj_reason_code_ini         adj.adj_reason_code%TYPE := 900;
   v_adj_reason_code_fim         adj.adj_reason_code%TYPE := 999;
   v_adj_subscr_no               adj.subscr_no%TYPE := 99999999;
   v_adj_subscr_no_resets        adj.subscr_no_resets%TYPE := 999;
   v_external_id_b               customer_id_equip_map.external_id%TYPE;
   v_external_id_a               customer_id_acct_map.external_id%TYPE;
   v_cmf_bill_address1           cmf.bill_address1%TYPE;
   v_cmf_bill_address2           cmf.bill_address2%TYPE;
   v_cmf_bill_address3           cmf.bill_address3%TYPE;
   v_cmf_bill_city               cmf.bill_city%TYPE;
   v_cmf_bill_lname              cmf.bill_lname%TYPE;
   v_cmf_bill_state              cmf.bill_state%TYPE;
   v_cmf_bill_zip                cmf.bill_zip%TYPE;
   v_cmf_bill_name_pre           cmf.bill_name_pre%TYPE;
   v_cmf_account_category        cmf.account_category%TYPE;
   v_tipo_cliente                VARCHAR (1);
   v_draft_amount                bmf.trans_amount%TYPE;
   v_full_sin_seq                sin_seq_no.full_sin_seq%TYPE;
   v_sin_seq_st_date             sin_seq_no.statement_date%TYPE;
   v_short_display               equip_class_code_values.short_display%TYPE;
   v_status                      VARCHAR (01);
   v_status_aux                  NUMBER := 0;    
   v_total_registros             NUMBER := 0;
   v_total_ajustes               NUMBER := 0;
   v_total_faturas               NUMBER := 0;
   v_total_reg                   NUMBER := 0;
   v_total_fat                   NUMBER := 0;
   v_total_adj                   NUMBER := 0;
   v_total_bol                   NUMBER := 0;
   v_total_reg_5                 NUMBER := 0;
   v_total_fat_5                 NUMBER := 0;
   v_total_adj_5                 NUMBER := 0;
   v_total_bol_5                 NUMBER := 0;
   v_codigo_de_barras            VARCHAR2 (48);
   v_adj_bill_ref_no             adj.bill_ref_no%TYPE := 99999999;
   v_adj_bill_ref_resets         adj.bill_ref_resets%TYPE := 999;
   v_qtd_problema                NUMBER := 0;
 

   -- ATENCAO retirar o trunc após a validacao.
   CURSOR c_adj (
      c_data_ini DATE,
      c_data_fim DATE,
      c_reason_code_ini NUMBER,
      c_reason_code_fim NUMBER
   )
   IS
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
                WHERE t1.bill_ref_no in (select fatura from chamados)
                and t1.account_no = t3.parent_account_no
                  AND t1.adj_trans_code = t2.adj_trans_code
                  --AND t1.transact_date >= trunc(c_data_ini) -- RFC 272848
                  --AND t1.transact_date < trunc(c_data_fim) -- RFC 272848
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
        and     t4.orig_bill_ref_no in (select fatura from chamados)
        order by account_no,
                 orig_bill_ref_no,
                 orig_bill_ref_resets;    
                 

/* */
   CURSOR c_cust_equi_map (
      c_account_no NUMBER,
      c_subscr_no_resets NUMBER,
      c_id_type NUMBER
   )
   IS
      /*
      SELECT   external_id
          FROM external_id_equip_map
         WHERE subscr_no = c_subscr_no
           AND subscr_no_resets = c_subscr_no_resets
           AND external_id_type = c_id_type
      ORDER BY inactive_date DESC,
               active_date DESC;
*/
     SELECT external_id
       FROM customer_id_equip_map
      WHERE subscr_no IN (SELECT e.subscr_no
                          FROM service e
                          WHERE e.parent_account_no = c_account_no)
        AND subscr_no_resets = c_subscr_no_resets
        AND external_id_type = c_id_type
     ORDER BY inactive_date DESC,
                active_date DESC,
                       subscr_no;

/* */
   CURSOR c_bankslip_problema (
      c_sequencial NUMBER
   )
   IS
      SELECT bks.*,
             bks.ROWID row_id
        FROM GVT_BANKSLIP_BK bks
       WHERE bks.status = 'P'
         AND bks.sequencial < c_sequencial;

/* */
   CURSOR c_bankslip_rel
   IS
        SELECT  
               bks.SEQUENCIAL,
               bks.ACCOUNT_NO,
               bks.EXTERNAL_ID_A,
               bks.SUBSCR_NO,
               bks.SUBSCR_NO_RESETS,
               bks.EXTERNAL_ID_B,
               bks.BILL_LNAME,
               bks.BILL_TIPO_CLIENTE,
               NVL(bks.BILL_ADDRESS1,' ') BILL_ADDRESS1,
               NVL(bks.BILL_ADDRESS2,' ') BILL_ADDRESS2,
               NVL(bks.BILL_ADDRESS3,' ') BILL_ADDRESS3,
               NVL(bks.BILL_CITY,' ') BILL_CITY,
               NVL(bks.BILL_STATE,' ') BILL_STATE,
               bks.BILL_ZIP,
               bks.BILL_REF_NO,
               bks.BILL_REF_RESETS,
               bks.FULL_SIN_SEQ,
               bks.PPDD_DATE,
               bks.TOTAL_ADJ,
               bks.BILL_DRAFT_AMOUNT,
               bks.BILL_AMOUNT,
               bks.ORIG_PPDD_DATE,
               bks.SHORT_DISPLAY,
               bks.DATA_MOVIMENTO,
               bks.STATUS,
               bks.DATA_ATUALIZACAO,
               bks.ROWID row_id
          FROM GVT_BANKSLIP_BK bks
         WHERE bks.status IN ('T', 'R')
      ORDER BY bks.account_no,
               bks.bill_ref_no,
               bks.bill_ref_resets;

--------------------------------------------------------------------------------
--  FUNCAO - Converte valor padrão Oracle para Real
--------------------------------------------------------------------------------
   FUNCTION converte (
      v_vlr_ent NUMBER
   )
      RETURN VARCHAR2
   IS
      v_vlr_conv                    VARCHAR2 (16);
   BEGIN
--      SELECT REPLACE (REPLACE (REPLACE (TO_CHAR (v_vlr_ent, '9999,999,990.99'), ',', '*'), '.', ','), '*', '.')
      SELECT SUBSTR (TO_CHAR (v_vlr_ent, '9g999g999g990d00'), 2)
        INTO v_vlr_conv
        FROM DUAL;

      RETURN v_vlr_conv;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('FUNCAO INVALIDA ');
   END;

--------------------------------------------------------------------------------
--  FUNCAO - gera_vlr_codigo_barras
--  Cópia da função disponivel no billtest
--  Alterei valor do ultimo campo do vlr_entra de "99" para "01"
--------------------------------------------------------------------------------
   FUNCTION gera_vlr_codigo_barras (
      v_vlr_fat NUMBER,
      v_cod_deb_automatico NUMBER,
      v_nr_fatura NUMBER
   )
      RETURN VARCHAR2
   IS
--DECLARE
      v_tamanho                     NUMBER (05) := 0;
      v_multi                       NUMBER (05) := 99;
      v_digito                      NUMBER := 0;
      v_sum                         NUMBER (05) := 0;
      v_vlr                         NUMBER (05) := 0;
      v_calc                        NUMBER (05) := 0;
      v_vlr_entra                   VARCHAR2 (100);
      v_vlr_cod_barras              VARCHAR2 (100);
      v_vlr_gerado                  VARCHAR2 (100);

/*
   v_vlr_fat                     NUMBER := 4500;
   v_cod_deb_automatico          NUMBER := 999999976451;
   v_nr_fatura                   NUMBER := 56130214;
*/
/* */
      PROCEDURE sub_calcula_digito
      IS
      BEGIN
--      DBMS_OUTPUT.put_line('ent=' || v_vlr_entra);
         v_tamanho                  := LENGTH (v_vlr_entra);
--      DBMS_OUTPUT.put_line('v_tamanho = ' || v_tamanho);
         v_calc                     := 0;
         v_vlr                      := 0;
         v_sum                      := 0;

         FOR i IN 1 .. v_tamanho
         LOOP
            IF MOD (i, 2) > 0
            THEN
               v_multi                    := 2;
            ELSE
               v_multi                    := 1;
            END IF;

            v_calc                     := SUBSTR (v_vlr_entra, i, 1) * v_multi;

            IF v_calc < 10
            THEN
               v_vlr                      := v_calc;
            ELSE
               v_vlr                      := SUBSTR (v_calc, 1, 1) + SUBSTR (v_calc, 2, 1);
            END IF;

            v_sum                      := v_sum + v_vlr;

         END LOOP;

         v_digito                   := 10 - (MOD (v_sum, 10));

         IF v_digito = 10
         THEN
            v_digito                   := 0;
         END IF;
/*
      DBMS_OUTPUT.put_line('v_digito=' || v_digito);
      DBMS_OUTPUT.put_line('**************************************************************************************** ');
*/
      END sub_calcula_digito;
/* */
   BEGIN
      v_vlr_entra                :=
            '846'
         || LPAD (v_vlr_fat, 11, 0)
         || '0082'
         || LPAD (v_cod_deb_automatico, 13, 0)
         || LPAD (v_nr_fatura, 10, 0)
         || '01';
      sub_calcula_digito;
      v_vlr_gerado               := SUBSTR (v_vlr_entra, 1, 3) || v_digito || SUBSTR (v_vlr_entra, 4);
/* */
      v_vlr_entra                := SUBSTR (v_vlr_gerado, 1, 11);
      sub_calcula_digito;
--   v_vlr_cod_barras           := v_vlr_entra || '-' || v_digito || ' ';
      v_vlr_cod_barras           := v_vlr_entra || v_digito;
/* */
      v_vlr_entra                := SUBSTR (v_vlr_gerado, 12, 11);
      sub_calcula_digito;
--   v_vlr_cod_barras           := v_vlr_cod_barras || v_vlr_entra || '-' || v_digito || ' ';
      v_vlr_cod_barras           := v_vlr_cod_barras || v_vlr_entra || v_digito;
/* */
      v_vlr_entra                := SUBSTR (v_vlr_gerado, 23, 11);
      sub_calcula_digito;
--   v_vlr_cod_barras           := v_vlr_cod_barras || v_vlr_entra || '-' || v_digito || ' ';
      v_vlr_cod_barras           := v_vlr_cod_barras || v_vlr_entra || v_digito;
/* */
      v_vlr_entra                := SUBSTR (v_vlr_gerado, 34, 11);
      sub_calcula_digito;
--   v_vlr_cod_barras           := v_vlr_cod_barras || v_vlr_entra || '-' || v_digito || ' ';
      v_vlr_cod_barras           := v_vlr_cod_barras || v_vlr_entra || v_digito;
--   DBMS_OUTPUT.put_line ('v_vlr_cod_barras= ' || v_vlr_cod_barras);
      RETURN v_vlr_cod_barras;

   END;

--******************************************************************************
   PROCEDURE sub_numeracao_execucao
   IS
   BEGIN
      v_executa_ant              := v_executa_atu;
      v_executa_atu              := 'sub_numeracao_execucao';

      SELECT num_exec
        INTO v_aux_num_execucao
        FROM (SELECT MIN (num_execucao) num_exec
                FROM gvt_exec_arg
               WHERE flg_utilizado = 'N'
                 AND UPPER (nome_programa) = v_nome_programa)
       WHERE num_exec IS NOT NULL;

      v_aux_tem_execucao         := TRUE;
      v_executa_atu              := v_executa_ant;
      v_executa_ant              := 'sub_numeracao_execucao';
   END sub_numeracao_execucao;

--******************************************************************************
   PROCEDURE sub_carrega_parametro_execucao
   IS
   BEGIN
      v_executa_ant              := v_executa_atu;
      v_executa_atu              := 'sub_carrega_parametro_execucao';

      SELECT desc_parametro
        INTO v_aux_data
        FROM gvt_exec_arg
       WHERE num_execucao = v_aux_num_execucao
         AND UPPER (nome_programa) = v_nome_programa;

      v_executa_atu              := v_executa_ant;
      v_executa_ant              := 'sub_carrega_parametro_execucao';

   END sub_carrega_parametro_execucao;

--******************************************************************************
   PROCEDURE sub_grava_execucao_ok
   IS
   BEGIN
      v_executa_ant              := v_executa_atu;
      v_executa_atu              := 'sub_grava_execucao_ok';

  --    UPDATE gvt_exec_arg
  --       SET flg_utilizado = 'S'
  --     WHERE num_execucao = v_aux_num_execucao
  --       AND UPPER (nome_programa) = v_nome_programa;
  --
  --    COMMIT;
      v_executa_atu              := v_executa_ant;
      v_executa_ant              := 'sub_grava_execucao_ok';
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('ERRO : ATUALIZAÇÃO DE PARÂMETROS');
         DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
         RAISE erro_geral;
   END sub_grava_execucao_ok;


--******************************************************************************
--******************************************************************************
BEGIN
   v_executa_atu              := 'MAIN';
   v_data_sistema             := SYSDATE;
   DBMS_OUTPUT.put_line ('INICIO = ' || TO_CHAR (v_data_sistema, 'YYYYMMDDHH24MISS'));

   v_aux_data                 := '20121101000000N000995';
      
   --DBMS_OUTPUT.put_line ('V_aux_DATA =' || CHR (39) || v_aux_data || CHR (39));

      --sub_proxima_execucao;
      v_data_ini                 := TO_DATE (SUBSTR (v_aux_data, 1, 14), 'YYYYMMDDHH24MISS');
      v_data_fim                 := TO_DATE ('20130120235959', 'YYYYMMDDHH24MISS');
      v_sequencial               := SUBSTR (v_aux_data, 16, 6);

   DBMS_OUTPUT.put_line (   'PERIODO: INICIO = '
                         || TO_CHAR (v_data_ini, 'YYYYMMDDHH24MISS')
                         || '   FIM = '
                         || TO_CHAR (v_data_fim, 'YYYYMMDDHH24MISS')
                        );
   v_total_registros          := 0;
   v_total_debitos            := 0;
   v_total_creditos           := 0;
   v_qt_status_v              := 0;
   v_qt_status_P              := 0;
   v_qt_total                 := 0;
   v_qt_pagos                 := 0;

--*******************************************************************************
--*******************************************************************************
--*******************************************************************************
   FOR r_adj IN c_adj (v_data_ini, v_data_fim, v_adj_reason_code_ini, v_adj_reason_code_fim)
   LOOP

      IF    r_adj.orig_bill_ref_no <> v_adj_bill_ref_no
         OR r_adj.orig_bill_ref_resets <> v_adj_bill_ref_resets
      THEN
         v_adj_bill_ref_no          := r_adj.orig_bill_ref_no;
         v_adj_bill_ref_resets      := r_adj.orig_bill_ref_resets;
         v_qt_total := v_qt_total + 1;


         BEGIN
            v_external_id_b            := NULL;


            FOR r_cust_equi_map IN c_cust_equi_map (r_adj.account_no, r_adj.subscr_no_resets, 6)
            LOOP
               v_external_id_b            := r_cust_equi_map.external_id;
               EXIT;
            END LOOP;

            IF v_external_id_b IS NULL
            THEN
               v_external_id_b            := '0000000000';
            END IF;

         END;

--      COLOCADO DEPOIS
--      Seleção na tabela BMF através dos campos
--        ACCOUNT_NO, ORIG_BILL_REF_NO, ORIG_BILL_REF_RESETS, POST_DATE
--        para obter a data de registro do pagamento
         BEGIN
            SELECT /*+ RULE */
                   chg_date
              INTO v_bmf_chg_date
              FROM bmf
             WHERE account_no = r_adj.account_no
               AND orig_bill_ref_no = r_adj.orig_bill_ref_no
               AND orig_bill_ref_resets = r_adj.orig_bill_ref_resets
               AND TRUNC (chg_date) <= v_data_fim
               AND bmf_trans_type not in (SELECT DISTINCT BMF_TRANS_TYPE_PGTO FROM GVT_DEPARA_AJUSTE_MASSIVO WHERE UPPER(DESCRIPTION_PGTO) LIKE 'BOLETO%') --RFC 377831
               AND bmf_trans_type <> -98
               AND bmf_trans_type <> -4;
               
               
               
         EXCEPTION
            WHEN OTHERS
            THEN
               v_bmf_chg_date             := NULL;
         END;

         IF v_bmf_chg_date IS not NULL THEN
            v_qt_pagos := nvl(v_qt_pagos,0) + 1;
         ELSE

            BEGIN
               EXECUTE IMMEDIATE    'SELECT bal.ppdd_date, '
                                 || '       baj.bal_adj, '
                                 || '       bal.orig_ppdd_date, '
                                 || '       bal.total_paid, '
                                 || '       bal.balance_due, '
                                 || '       bal.new_charges '
                                 || '  FROM cmf_balance bal, '
                                 || '       (SELECT SUM (NVL (bal_adj, 0)) bal_adj '
                                 || '          FROM (SELECT NVL (trans_amount * btd.trans_sign, 0) bal_adj '
                                 || '                  FROM bmf_trans_descr btd, '
                                 || '                       bmf '
                                 || '                 WHERE bmf.file_id = :file_id '
                                 || '                   AND bmf.account_no = :account_no '
                                 || '                   AND bmf.no_bill = 0 '
                                 || '                   AND bmf.bill_ref_no = 0 '
                                 --|| '                   AND bmf.bmf_trans_type = -4 ' RFC 377831
                                 || '                    AND ( bmf.bmf_trans_type in (SELECT   distinct bmf_trans_type_pgto '    --RFC 377831
                                 || '                                                 FROM     arborgvt_billing.gvt_depara_ajuste_massivo '
                                 --|| '                                                 FROM     gvt_depara_ajuste_massivo '                                 
                                 || '                                                 WHERE    upper(description_pgto) like ''BOLETO%'') or bmf.bmf_trans_type = -4) '
                                 || '                   AND btd.bmf_trans_type = bmf.bmf_trans_type '
                                 || '                UNION ALL '
                                 || '                SELECT NVL (total_adj, 0) bal_adj '
                                 || '                  FROM cmf_balance '
                                 || '                 WHERE bill_ref_no = :bill_ref_no '
                                 || '                   AND bill_ref_resets = :bill_ref_resets '
                                 || '                   AND account_no = :account_no)) baj '
                                 || ' WHERE bal.bill_ref_no = :bill_ref_no '
                                 || '   AND bal.bill_ref_resets = :bill_ref_resets '
                                 || '   AND bal.account_no = :account_no'
                            INTO v_cmfb_ppdd_date,
                                 v_bmf_trans_amount,
                                 v_cmfb_orig_ppdd_date,
                                 v_cmfb_total_paid,
                                 v_cmfb_balance_due,
                                 v_cmfb_new_charges
                           USING r_adj.orig_bill_ref_no,
                                 r_adj.account_no,
                                 r_adj.orig_bill_ref_no,
                                 r_adj.orig_bill_ref_resets,
                                 r_adj.account_no,
                                 r_adj.orig_bill_ref_no,
                                 r_adj.orig_bill_ref_resets,
                                 r_adj.account_no;

               v_draft_amount             := v_cmfb_new_charges + v_bmf_trans_amount + v_cmfb_total_paid;

            END;

            BEGIN
               EXECUTE IMMEDIATE    'SELECT external_id '
                                 || '  FROM customer_id_acct_map '
                                 || ' WHERE account_no = :account_no '
                                 || '   AND external_id_type = :id_type '
                            INTO v_external_id_a
                           USING r_adj.account_no, 1;

            END;

            BEGIN
               EXECUTE IMMEDIATE    'SELECT bill_address1, '
                                 || '       bill_address2, '
                                 || '       bill_address3, '
                                 || '       bill_city, '
                                 || '       bill_lname, '
                                 || '       bill_state, '
                                 || '       bill_zip, '
                                 || '       bill_name_pre, '
                                 || '       account_category '
                                 || '  FROM cmf '
                                 || ' WHERE account_no = :account_no '
                            INTO v_cmf_bill_address1,
                                 v_cmf_bill_address2,
                                 v_cmf_bill_address3,
                                 v_cmf_bill_city,
                                 v_cmf_bill_lname,
                                 v_cmf_bill_state,
                                 v_cmf_bill_zip,
                                 v_cmf_bill_name_pre,
                                 v_cmf_account_category
                           USING r_adj.account_no;

               IF v_cmf_account_category IN (12, 13, 14, 15, 21, 22)
               THEN
                  v_tipo_cliente             := 'C';
               ELSE
                  v_tipo_cliente             := 'R';
               END IF;


            END;

            BEGIN
               /*
               alterado em : 23/06/2011
               alterado por: fransergio paiva de andrade - kyros
               
               original: AND open_item_id = 0
               alterado: AND open_item_id in (0 ,90)
               
               by Festa:29/06/2011
               Adicionado para passar o parâmetro :open_item_id
               */
               EXECUTE IMMEDIATE    'SELECT full_sin_seq, '
                                 || '       statement_date '
                                 || '  FROM sin_seq_no '
                                 || ' WHERE bill_ref_no = :orig_bill_ref_no '
                                 || '   AND bill_ref_resets = :orig_bill_ref_resets '
                                 || '   AND open_item_id = :open_item_id '
                            INTO v_full_sin_seq,
                                 v_sin_seq_st_date
                           USING r_adj.orig_bill_ref_no, r_adj.orig_bill_ref_resets, r_adj.open_item_id;
            END;


            BEGIN
               SELECT t2.short_display INTO v_short_display
                 FROM service_billing t1,
                      equip_class_code_values t2
                WHERE t1.equip_class_code = t2.equip_class_code
                  AND t1.subscr_no = r_adj.subscr_no
                  AND t1.subscr_no_resets = r_adj.subscr_no_resets
                  AND t2.language_code = 2;

            END;

         DBMS_OUTPUT.put_line (' EXEC IMM 6 ');
            BEGIN
               EXECUTE IMMEDIATE    'SELECT bit.bill_amount, '
                                 || '       bit.bill_bank_draft_date, '
                                 || '       bit.bill_bank_draft_amount '
                                 || '  FROM gvt_bill_invoice_total bit '
                                 || ' WHERE bit.bill_ref_no = :bill_ref_no '
                                 || '   AND bit.bill_ref_resets = :bill_ref_resets'
                            INTO v_bit_bill_amount,
                                 v_bit_bill_bank_draft_date,
                                 v_bit_bill_bank_draft_amount
                           USING r_adj.orig_bill_ref_no, r_adj.orig_bill_ref_resets;

                BEGIN

                   COMMIT;
                   NULL;
                   
                END;

--
               v_status                   := 'T';
            END;
            
         DBMS_OUTPUT.put_line (' IF    v_status =' || v_status|| '  v_draft_amount = '||v_draft_amount);
            IF    v_status = 'P' OR
               (  v_status = 'T' AND v_draft_amount >= 0  )
            THEN
            

               BEGIN
                  EXECUTE IMMEDIATE    'INSERT INTO GVT_BANKSLIP_BK '
                                    || 'VALUES (:sequencia, '
                                    || '       :account_no, '
                                    || '       :external_id_a, '
                                    || '       :subscr_no, '
                                    || '       :subscr_no_resets, '
                                    || '       :external_id_b, '
                                    || '       :bill_lname, '
                                    || '       :tipo_cliente, '
                                    || '       :address1, '
                                    || '       :address2, '
                                    || '       :address3, '
                                    || '       :city, '
                                    || '       :state, '
                                    || '       :zip, '
                                    || '       :bill_ref_no, '
                                    || '       :bill_ref_no_resets, '
                                    || '       :full_sin_seq, '
                                    || '       :ppdd_date, '
                                    || '       :total_adj, '
                                    || '       :draft_amount, '
                                    || '       :bill_amount, '
                                    || '       :orig_ppdd_date, '
                                    || '       :short_display, '
                                    || '       :data_movto, '
                                    || '       :status, '
                                    || '       :atu_data ) '
                              USING v_sequencial,
                                    r_adj.account_no,
                                    RTRIM (v_external_id_a),
                                    r_adj.subscr_no,
                                    r_adj.subscr_no_resets,
                                    RTRIM (v_external_id_b),
                                    RTRIM (v_cmf_bill_lname),
                                    RTRIM (v_tipo_cliente),
                                    RTRIM (v_cmf_bill_address1),
                                    RTRIM (v_cmf_bill_address2),
                                    RTRIM (v_cmf_bill_address3),
                                    RTRIM (v_cmf_bill_city),
                                    RTRIM (v_cmf_bill_state),
                                    RPAD  (v_cmf_bill_zip,8, ' '),
                                    r_adj.orig_bill_ref_no,
                                    r_adj.orig_bill_ref_resets,
                                    RTRIM (v_full_sin_seq),
                                    v_cmfb_ppdd_date,
                                    v_bmf_trans_amount,
                                    v_draft_amount,
                                    v_cmfb_new_charges,
                                    v_cmfb_orig_ppdd_date,
                                    RTRIM (v_short_display),
                                    SYSDATE,
                                    v_status,
                                    SYSDATE;

                  COMMIT;

                     DBMS_OUTPUT.put_line ('oracle = ' || SQLERRM);
                     DBMS_OUTPUT.put_line ('INSERT = ' || r_adj.orig_bill_ref_no || ' ,' || r_adj.orig_bill_ref_resets);
               END;
            ELSE
               v_qt_status_T := nvl(v_qt_status_T,0) + 1;
            END IF;   
            
         END IF;
      END IF;   -- ESTE E DO v_bmf_chg_date
   END LOOP;

--*******************************************************************************
--***************** vai tratar problema *****************************************
--*******************************************************************************
--   dbms_output.put_line('************** vai tratar problema **************** ');
   -- INI: vai tratar problema
   FOR r_bks_prob IN c_bankslip_problema (v_sequencial)
   LOOP
      BEGIN
         EXECUTE IMMEDIATE    'SELECT bit.bill_amount, '
                           || '       bit.bill_bank_draft_date, '
                           || '       bit.bill_bank_draft_amount '
                           || '  FROM gvt_bill_invoice_total bit '
                           || ' WHERE bit.bill_ref_no = :bill_ref_no '
                           || '   AND bit.bill_ref_resets = :bill_ref_resets'
                      INTO v_bit_bill_amount,
                           v_bit_bill_bank_draft_date,
                           v_bit_bill_bank_draft_amount
                     USING r_bks_prob.bill_ref_no, r_bks_prob.bill_ref_resets;

         BEGIN
            EXECUTE IMMEDIATE    'SELECT bal.ppdd_date, '
                              || '       baj.bal_adj, '
                              || '       bal.orig_ppdd_date, '
                              || '       bal.total_paid, '
                              || '       bal.balance_due, '
                              || '       bal.new_charges '
                              || '  FROM cmf_balance bal, '
                              || '       (SELECT SUM (NVL (bal_adj, 0)) bal_adj '
                              || '          FROM (SELECT NVL (trans_amount * btd.trans_sign, 0) bal_adj '
                              || '                  FROM bmf_trans_descr btd, '
                              || '                       bmf '
                              || '                 WHERE bmf.file_id = :file_id '
                              || '                   AND bmf.account_no = :account_no '
                              || '                   AND bmf.no_bill = 0 '
                              || '                   AND bmf.bill_ref_no = 0 '
                              --|| '                   AND bmf.bmf_trans_type = -4 ' RFC 377831
                              || '                    AND ( bmf.bmf_trans_type in (SELECT   distinct bmf_trans_type_pgto '    --RFC 377831
                              || '                                                 FROM     arborgvt_billing.gvt_depara_ajuste_massivo '
                              || '                                                 WHERE    upper(description_pgto) like ''BOLETO%'') or bmf.bmf_trans_type = -4) '
                              || '                   AND btd.bmf_trans_type = bmf.bmf_trans_type '
                              || '                UNION ALL '
                              || '                SELECT NVL (total_adj, 0) bal_adj '
                              || '                  FROM cmf_balance '
                              || '                 WHERE bill_ref_no = :bill_ref_no '
                              || '                   AND bill_ref_resets = :bill_ref_resets '
                              || '                   AND account_no = :account_no)) baj '
                              || ' WHERE bal.bill_ref_no = :bill_ref_no '
                              || '   AND bal.bill_ref_resets = :bill_ref_resets '
                              || '   AND bal.account_no = :account_no'
                         INTO v_cmfb_ppdd_date,
                              v_bmf_trans_amount,
                              v_cmfb_orig_ppdd_date,
                              v_cmfb_total_paid,
                              v_cmfb_balance_due,
                              v_cmfb_new_charges
                        USING r_bks_prob.bill_ref_no,
                              r_bks_prob.account_no,
                              r_bks_prob.bill_ref_no,
                              r_bks_prob.bill_ref_resets,
                              r_bks_prob.account_no,
                              r_bks_prob.bill_ref_no,
                              r_bks_prob.bill_ref_resets,
                              r_bks_prob.account_no;

            v_draft_amount             := v_cmfb_new_charges + v_bmf_trans_amount + v_cmfb_total_paid;
 
            BEGIN
                   
                   UPDATE GVT_BANKSLIP_BK SET 
                          status = 'R', 
                          data_atualizacao = sysdate, 
                          total_adj = v_bmf_trans_amount, 
                          bill_draft_amount = v_draft_amount, 
                          bill_amount = v_cmfb_new_charges 
                    WHERE ROWID = r_bks_prob.row_id;
                 
               -- Descomentar apos a validacao

               BEGIN

              --      EXECUTE IMMEDIATE    'UPDATE gvt_bill_invoice_total '
              --          || '   SET bill_bank_draft_date = :draft_date,  '
              --          || '       bill_bank_draft_amount = :draft_amount '
              --          || ' WHERE bill_ref_no = :bill_ref_no '
              --          || '   AND bill_ref_resets = :bill_ref_resets '
              --    USING SYSDATE, v_draft_amount, r_bks_prob.bill_ref_no, r_bks_prob.bill_ref_resets;

                  COMMIT;
                  NULL;


                END;

            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (   'BKSP = '
                                        || r_bks_prob.account_no
                                        || ' ,'
                                        || r_bks_prob.bill_ref_no
                                        || ' , '
                                        || r_bks_prob.bill_ref_resets
                                        || ' , '
                                        || r_bks_prob.row_id
                                       );
                  DBMS_OUTPUT.put_line ('ORACLE = ' || SQLERRM);
                  RAISE erro_geral;
            END;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('ORACLE = ' || SQLERRM);
               DBMS_OUTPUT.put_line ('BIT = ' || r_bks_prob.bill_ref_no || ' , ' || r_bks_prob.bill_ref_resets);
               RAISE erro_geral;
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('ORACLE = ' || SQLERRM);
            DBMS_OUTPUT.put_line ('BIT = ' || r_bks_prob.bill_ref_no || ' , ' || r_bks_prob.bill_ref_resets);
            RAISE erro_geral;
      END;
   END LOOP;
   -- FIM: vai tratar problema
--*******************************************************************************
  -- sub_grava_header_boleto;
  -- sub_grava_header_cliente;

   --dbms_output.put_line('TRATOU HB e HC');
--*******************************************************************************

      dbms_output.put_line(' FOR r_bks_rel IN c_bankslip_rel ');
   FOR r_bks_rel IN c_bankslip_rel
   LOOP
      v_total_reg                := v_total_reg + 1;
      v_total_fat                := v_total_fat + r_bks_rel.bill_amount;
      v_total_adj                := v_total_adj + r_bks_rel.total_adj;

      -- Verifica se existe o mesmo FULL_SIN_SEQ e mesmo bill_draft_amount 
      
      v_status_aux := 1;
       
      IF v_status_aux > 0 THEN 
         v_status                   := 'T';
      ELSIF r_bks_rel.bill_draft_amount <= 500
      THEN
         v_total_reg_5              := v_total_reg_5 + 1;
         v_total_fat_5              := v_total_fat_5 + r_bks_rel.bill_amount;
         v_total_adj_5              := v_total_adj_5 + r_bks_rel.total_adj;
         v_total_bol_5              := v_total_bol_5 + r_bks_rel.bill_draft_amount;
         v_status                   := '5'; 
      ELSE
         v_total_bol                := v_total_bol + r_bks_rel.bill_draft_amount;
         v_total_registros          := v_total_registros + 1;
         v_total_ajustes            := v_total_ajustes + r_bks_rel.total_adj;
         v_total_faturas            := v_total_faturas + r_bks_rel.bill_amount;
         v_status                   := 'B';
         
        -- POSTERGA A DATA DE VENCIMENTO PARA 15 DIAS --
          BEGIN
             v_data_vencto := sysdate + 15;
             --csr_update_inv_due_date (r_bks_rel.account_no, r_bks_rel.bill_ref_no, r_bks_rel.bill_ref_resets, v_data_vencto);
          EXCEPTION
             WHEN OTHERS THEN
               v_data_vencto := null;
               v_status := 'V'; -- Problema com a Data de vencimento
               v_qt_status_V := nvl(v_qt_status_V,0) + 1;
          END;

      END IF;
      
   BEGIN
         
      UPDATE GVT_BANKSLIP_BK SET
             status = v_status,
                 data_atualizacao = SYSDATE,
                 ppdd_date = nvl(v_data_vencto, ppdd_date) -- RFC 272848
       WHERE ROWID = r_bks_rel.row_id;
     -- fim: RFC 313228
     COMMIT;
      
   END;        --DBMS_OUTPUT.put_line ('Status = ' || v_status);
            --v_status:=' '
   COMMIT;
   END LOOP;

--***************** vai listar problema *****************************************
   v_qtd_problema             := 0;

  -- FOR r_bks_prob IN c_bankslip_problema (v_sequencial)
  -- LOOP
  --    v_qtd_problema             := v_qtd_problema + 1;

    --  BEGIN
  --       IF v_qtd_problema = 1 THEN
 --           warqspoold                 := 'BANKSLIP_PROBLEMAS_' || TO_CHAR (v_data_sistema, 'YYYYMMDDHH24MISS') || '.txt';
 --           DBMS_OUTPUT.put_line ('wArqSpoold : ' || warqspoold);
 --           harqspoold                 := UTL_FILE.fopen (wdirspool, warqspoold, 'w');
 --        END IF;
 --       
 --        -- RFC_383229
 --        UTL_FILE.put_line (harqspoold,
 --                      CONVERT (SUBSTR (TO_CHAR (r_bks_prob.sequencial, '000000'), 2, 06)
 --                   || SUBSTR (TO_CHAR (r_bks_prob.account_no, '0000000000'), 2, 10)
 --                   || RPAD (NVL (r_bks_prob.external_id_a, ' '), 12, ' ')
 --                   || SUBSTR (TO_CHAR (r_bks_prob.subscr_no, '0000000000'), 2, 10)
 --                   || SUBSTR (TO_CHAR (r_bks_prob.subscr_no_resets, '000'), 2, 03)
 --                   || RPAD (NVL (r_bks_prob.external_id_b, ' '), 10, ' ')
 --                   || RPAD (NVL (r_bks_prob.bill_lname, ' '), 55, ' ')
 --                   || r_bks_prob.bill_tipo_cliente
 --                   || RPAD (NVL (r_bks_prob.bill_address1, ' '), 75, ' ')
 --                   || RPAD (NVL (r_bks_prob.bill_address2, ' '), 30, ' ')
 --                   || RPAD (NVL (r_bks_prob.bill_address3, ' '), 30, ' ')
 --                   || RPAD (NVL (r_bks_prob.bill_city, ' '), 35, ' ')
 --                   || RPAD (NVL (r_bks_prob.bill_state, ' '), 02, ' ')
 --                   || RPAD (NVL (r_bks_prob.bill_zip, ' '), 08, ' ')
 --                   || SUBSTR (TO_CHAR (r_bks_prob.bill_ref_no, '0000000000'), 2, 10)
 --                   || SUBSTR (TO_CHAR (r_bks_prob.bill_ref_resets, '000'), 2, 03)
 --                   || RPAD (NVL (r_bks_prob.full_sin_seq, ' '), 12, ' ')
 --                   || TO_CHAR (r_bks_prob.ppdd_date, 'DDMMYYYY')
 --                   || SUBSTR (TO_CHAR (r_bks_prob.total_adj, '0000000000000'), 2, 13)
 --                   || SUBSTR (TO_CHAR (r_bks_prob.bill_draft_amount, '0000000000000'), 2, 13)
 --                   || SUBSTR (TO_CHAR (r_bks_prob.bill_amount, '0000000000000'), 2, 13)
 --                   || TO_CHAR (r_bks_prob.orig_ppdd_date, 'DDMMYYYY')
 --                   || RPAD (NVL (r_bks_prob.short_display, ' '), 02, ' ')
 --                   || TO_CHAR (r_bks_prob.data_movimento, 'YYYYMMDD')
 --                  , 'WE8ISO8859P1' )); 
 --        
 --                          
 --        UTL_FILE.fflush (harqspoold);
 --     END;

  -- END LOOP;

 --  IF UTL_FILE.is_open (harqspoold)
 --     THEN
 --     UTL_FILE.fclose (harqspoold);
 --  END IF;
   --
   dbms_output.put_line('QUANTIDADES....');
   dbms_output.put_line('   Total de Faturas com Ajustes............: '||v_qt_total);
   if nvl(v_qt_status_T,0) > 0 then
     dbms_output.put_line('   Fatura com valor negativo...............: '||v_qt_status_T);
   end if;
   if nvl(v_qt_pagos,0) > 0 then
     dbms_output.put_line('   Faturas ja pagas........................: '||v_qt_pagos);
   end if;
   for r1 in (Select count(*) qt,  decode(status,  'B','Boletos Gerados',
                                                'P','Problemas não Corrigidos',
                                                'R','Problemas     Corrigidos',
                                                'T','Tratados',
                                                '5','Boletos iguais ou menores que R$5,00',
                                                'D','Boletos Duplicados',
                                                'V','Data de Vencimento não foi Postergada',
                                                'Erro desconhecido') descricao
                from gvt_bankslip_BK where sequencial = v_sequencial - 1 group by status)
   loop
     dbms_output.put_line('   '||rpad(r1.descricao,40,'.')||': '||r1.qt);
   end loop;
--*******************************************************************************
END;
/

SET serverout off;
SET feed on;
EXIT;

-- select * from GVT_bankslip_bk

-- truncate table GVT_bankslip_bk