DECLARE
------------------------------------------
-- VARIAVEIS
------------------------------------------
  v_nome_arquivo_log     VARCHAR2 (100)                 := TRIM ('&1') || '.log';
  v_caminho_log          VARCHAR2 (100)                 := TRIM ('&2');
  v_caminho              VARCHAR2 (100)                 := TRIM ('&3');
  v_acao                 CHAR (1);
  slog                   UTL_FILE.file_type;
  v_seq_numb             bank_seqs.seq_numb%TYPE;
  
  stxt001                UTL_FILE.file_type;
  stxt027                UTL_FILE.file_type;
  stxt031                UTL_FILE.file_type;
  stxt038                UTL_FILE.file_type;
  stxt039                UTL_FILE.file_type;
  stxt048                UTL_FILE.file_type;
  stxt041                UTL_FILE.file_type;
  stxt065                UTL_FILE.file_type;
  stxt104                UTL_FILE.file_type;
  stxt070                UTL_FILE.file_type;
  stxt184                UTL_FILE.file_type;
  stxt230                UTL_FILE.file_type;
  stxt237                UTL_FILE.file_type;
  stxt275                UTL_FILE.file_type;
  stxt291                UTL_FILE.file_type;
  stxt341                UTL_FILE.file_type;
  stxt347                UTL_FILE.file_type;
  stxt353                UTL_FILE.file_type;
  stxt389                UTL_FILE.file_type;
  stxt399                UTL_FILE.file_type;
  stxt409                UTL_FILE.file_type;
  stxt453                UTL_FILE.file_type;
  stxt479                UTL_FILE.file_type;
  stxt641                UTL_FILE.file_type;
  stxt745                UTL_FILE.file_type;
  stxt748                UTL_FILE.file_type;
  stxt756                UTL_FILE.file_type;
  stxt777                UTL_FILE.file_type;
  stxt904                UTL_FILE.file_type;
  stxt422                UTL_FILE.file_type;
  
  v_nome_arquivo001      VARCHAR2 (100);
  v_nome_arquivo027      VARCHAR2 (100);
  v_nome_arquivo031      VARCHAR2 (100);
  v_nome_arquivo038      VARCHAR2 (100);
  v_nome_arquivo039      VARCHAR2 (100);
  v_nome_arquivo048      VARCHAR2 (100);
  v_nome_arquivo041      VARCHAR2 (100);
  v_nome_arquivo065      VARCHAR2 (100);
  v_nome_arquivo104      VARCHAR2 (100);
  v_nome_arquivo070      VARCHAR2 (100);
  v_nome_arquivo184      VARCHAR2 (100);
  v_nome_arquivo230      VARCHAR2 (100);
  v_nome_arquivo237      VARCHAR2 (100);
  v_nome_arquivo275      VARCHAR2 (100);
  v_nome_arquivo291      VARCHAR2 (100);
  v_nome_arquivo341      VARCHAR2 (100);
  v_nome_arquivo347      VARCHAR2 (100);
  v_nome_arquivo353      VARCHAR2 (100);
  v_nome_arquivo389      VARCHAR2 (100);
  v_nome_arquivo399      VARCHAR2 (100);
  v_nome_arquivo409      VARCHAR2 (100);
  v_nome_arquivo453      VARCHAR2 (100);
  v_nome_arquivo479      VARCHAR2 (100);
  v_nome_arquivo641      VARCHAR2 (100);
  v_nome_arquivo745      VARCHAR2 (100);
  v_nome_arquivo748      VARCHAR2 (100);
  v_nome_arquivo756      VARCHAR2 (100);
  v_nome_arquivo777      VARCHAR2 (100);
  v_nome_arquivo904      VARCHAR2 (100);
  v_nome_arquivo422      VARCHAR2 (100);
  
  v_cabecalho_arq001     CHAR (1)                       := 'N';
  v_cabecalho_arq027     CHAR (1)                       := 'N';
  v_cabecalho_arq031     CHAR (1)                       := 'N';
  v_cabecalho_arq038     CHAR (1)                       := 'N';
  v_cabecalho_arq039     CHAR (1)                       := 'N';
  v_cabecalho_arq048     CHAR (1)                       := 'N';
  v_cabecalho_arq041     CHAR (1)                       := 'N';
  v_cabecalho_arq065     CHAR (1)                       := 'N';
  v_cabecalho_arq104     CHAR (1)                       := 'N';
  v_cabecalho_arq070     CHAR (1)                       := 'N';
  v_cabecalho_arq184     CHAR (1)                       := 'N';
  v_cabecalho_arq230     CHAR (1)                       := 'N';
  v_cabecalho_arq237     CHAR (1)                       := 'N';
  v_cabecalho_arq275     CHAR (1)                       := 'N';
  v_cabecalho_arq291     CHAR (1)                       := 'N';
  v_cabecalho_arq341     CHAR (1)                       := 'N';
  v_cabecalho_arq347     CHAR (1)                       := 'N';
  v_cabecalho_arq353     CHAR (1)                       := 'N';
  v_cabecalho_arq389     CHAR (1)                       := 'N';
  v_cabecalho_arq399     CHAR (1)                       := 'N';
  v_cabecalho_arq409     CHAR (1)                       := 'N';
  v_cabecalho_arq453     CHAR (1)                       := 'N';
  v_cabecalho_arq479     CHAR (1)                       := 'N';
  v_cabecalho_arq641     CHAR (1)                       := 'N';
  v_cabecalho_arq745     CHAR (1)                       := 'N';
  v_cabecalho_arq748     CHAR (1)                       := 'N';
  v_cabecalho_arq756     CHAR (1)                       := 'N';
  v_cabecalho_arq777     CHAR (1)                       := 'N';
  v_cabecalho_arq904     CHAR (1)                       := 'N';
  v_cabecalho_arq422     CHAR (1)                       := 'N';
  
  v_conta_linha_arq001   NUMBER (5)                     := 0;
  v_conta_linha_arq027   NUMBER (5)                     := 0;
  v_conta_linha_arq031   NUMBER (5)                     := 0;
  v_conta_linha_arq038   NUMBER (5)                     := 0;
  v_conta_linha_arq039   NUMBER (5)                     := 0;
  v_conta_linha_arq048   NUMBER (5)                     := 0;
  v_conta_linha_arq041   NUMBER (5)                     := 0;
  v_conta_linha_arq065   NUMBER (5)                     := 0;
  v_conta_linha_arq104   NUMBER (5)                     := 0;
  v_conta_linha_arq070   NUMBER (5)                     := 0;
  v_conta_linha_arq184   NUMBER (5)                     := 0;
  v_conta_linha_arq230   NUMBER (5)                     := 0;
  v_conta_linha_arq237   NUMBER (5)                     := 0;
  v_conta_linha_arq275   NUMBER (5)                     := 0;
  v_conta_linha_arq291   NUMBER (5)                     := 0;
  v_conta_linha_arq341   NUMBER (5)                     := 0;
  v_conta_linha_arq347   NUMBER (5)                     := 0;
  v_conta_linha_arq353   NUMBER (5)                     := 0;
  v_conta_linha_arq389   NUMBER (5)                     := 0;
  v_conta_linha_arq399   NUMBER (5)                     := 0;
  v_conta_linha_arq409   NUMBER (5)                     := 0;
  v_conta_linha_arq453   NUMBER (5)                     := 0;
  v_conta_linha_arq479   NUMBER (5)                     := 0;
  v_conta_linha_arq641   NUMBER (5)                     := 0;
  v_conta_linha_arq745   NUMBER (5)                     := 0;
  v_conta_linha_arq748   NUMBER (5)                     := 0;
  v_conta_linha_arq756   NUMBER (5)                     := 0;
  v_conta_linha_arq777   NUMBER (5)                     := 0;
  v_conta_linha_arq904   NUMBER (5)                     := 0;
  v_conta_linha_arq422   NUMBER (5)                     := 0;
  
  v_cc                   gvt_cmf_rule_acc.cc%TYPE;
  v_ag                   gvt_cmf_rule_acc.ag%TYPE;
  v_bco                  gvt_cmf_rule_acc.bco%TYPE;
  v_dvag                 gvt_cmf_rule_acc.dvag%TYPE;
  v_dvcc                 gvt_cmf_rule_acc.dvcc%TYPE;
  v_right                gvt_cmf_rule_acc.RIGHT%TYPE;
  v_left                 gvt_cmf_rule_acc.LEFT%TYPE;
  v_length               gvt_cmf_rule_acc.LENGTH%TYPE;
  v_hiphen               gvt_cmf_rule_acc.hiphen%TYPE;
  
  v_campo_cc_arq_bank    VARCHAR2 (15);
  v_qtde_dv_ag           NUMBER (1);
  v_qtde_dv_cc           NUMBER (1);
  v_count_external_id    NUMBER (3) := 0;
  v_aux_external_id      VARCHAR2 (48) := null;
  
  -- Alteração Filipe
  -- v_banco: contém o código do banco para o cliente atual
  v_banco                gvt_dacc_gerencia_met_pgto.cod_agente_arrecadador%TYPE;
  -- v_account_no: contém o código da conta do cliente
  v_account_no           customer_id_acct_map.account_no%TYPE;
  -- o tipo de pagamento anterior do cliente
  v_old_pmethod          gvt_dacc_gerencia_met_pgto.old_pay_method%TYPE;
  -- o tipo de pagamento atual do cliente
  v_method               gvt_dacc_gerencia_met_pgto.pay_method%TYPE;
  -- Indica se deve atualizar para pendente
  ---v_pendente             NUMBER(1);

------------------------------------------------------------------------------------
-- CURSOR(ES) ----------------------------------------------------------------------
------------------------------------------------------------------------------------
--Pego Todos os "MENORES" Eventos que sejam "A PROCESSAR" e "AGUARDA RETORNO"
  CURSOR cur_clientes_selecionados
  IS
    SELECT   external_id
            ,cod_agente_arrecadador
            ,cod_agencia
            ,rpad(num_cc_cartao,15) num_cc_cartao
            ,tp_evento
            ,sequencia
        FROM gvt_dacc_gerencia_fila_eventos gdgfe
       WHERE gdgfe.status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
         AND gdgfe.aguarda_retorno = 'S'
    ORDER BY cod_agente_arrecadador;
------------------------------------------------------------------------------------
BEGIN
  -- Crio e abro o arquivo de LOG
  slog    := UTL_FILE.fopen (v_caminho_log, v_nome_arquivo_log, 'w');

  BEGIN
    FOR r_linha IN cur_clientes_selecionados
    LOOP
      -- Verifico se o cliente existe no ARBOR
      v_aux_external_id := r_linha.external_id;
      
      SELECT COUNT (external_id)
        INTO v_count_external_id
        FROM customer_id_acct_map
       WHERE external_id = r_linha.external_id;

      IF (v_count_external_id >= 1) THEN

        --BANCO DO BRASIL S/A
        IF (TRIM (r_linha.cod_agente_arrecadador) = '001') THEN
          IF v_cabecalho_arq001 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo001       :=
                               'BILL_DebAutom_BANCO_' || '001' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt001                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo001, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt001
                              , 'A1' ||
                                RPAD ('11015', 20, ' ') ||
                                'GVT/CURITIBA-PR     001' ||
                                RPAD ('BANCO DO BRASIL S/A', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq001      := 'S';
            v_conta_linha_arq001    := v_conta_linha_arq001 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 1;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            --Inclusao
            UTL_FILE.put_line
                   (stxt001
                   , 'E' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     SUBSTR (LPAD (r_linha.cod_agencia, 5, '0'), 1, 4) ||
                     v_campo_cc_arq_bank ||
                     TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                     '00000000000000003                                                                                ' ||
                     v_acao
                 );
          ELSIF v_acao = '1' THEN
            --Exclusao
            UTL_FILE.put_line
                   (stxt001
                   , 'D' ||
                   RPAD (r_linha.external_id, 25, ' ') ||
                   LPAD (r_linha.cod_agencia, 4, 0) ||
                   v_campo_cc_arq_bank ||
                   RPAD (r_linha.external_id, 25, ' ') ||
                   RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                   RPAD (' ', 20, ' ') ||
                   v_acao
                 );
          END IF;
                 
          v_conta_linha_arq001    := v_conta_linha_arq001 + 1;
        END IF;

        --BESC
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '027' ) THEN

        --END IF;

        --BEG S/A
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '031' ) THEN

        --END IF;

        --BANESTADO
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '038' ) THEN

        --END IF;

        --BANRISUL
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '039' ) THEN

        --END IF;

        --BANRISUL 
        --Retirada da alteração provisória até adaptação da Interchange. Será gerado registro D para este banco
        IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '041') THEN
          IF v_cabecalho_arq041 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo041       :=
                               'BILL_DebAutom_BANCO_' || '041' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt041                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo041, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt041
                              , 'A1' ||
                                RPAD ('01234', 20, ' ') ||
                                'GVT/CURITIBA-PR     041' ||
                                RPAD ('BANRISUL', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            --Decido se é INCLUSAO ou CANCELAMENTO
            v_cabecalho_arq041      := 'S';
            v_conta_linha_arq041    := v_conta_linha_arq041 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;
--COMENTARIO MAYCON
--          IF v_ag = 1 THEN
--            IF v_dvag = 1 THEN
--              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
--            ELSE
--              v_campo_cc_arq_bank    :=
--                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
--                v_campo_cc_arq_bank;
--            END IF;
--          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            --Inclusao
            UTL_FILE.put_line
                   (stxt041
                   , 'D' ||
                     RPAD (' ', 25, ' ') || --RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') || --RPAD (' ', 25, ' ') ||
                     RPAD (' ',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          
          ELSIF v_acao = '1' THEN
            --Exclusão
            UTL_FILE.put_line
                   (stxt041
                   , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (' ', 25, ' ') || --RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          END IF;
          
          
          
          v_conta_linha_arq041    := v_conta_linha_arq041 + 1;
        END IF;

        --CTBCI
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '048' ) THEN

        --END IF;

        --LEMON BANK
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '065' ) THEN

        --END IF;

        --CAIXA ECONOMICA FED
        IF (TRIM (r_linha.cod_agente_arrecadador) = '104') THEN
          IF v_cabecalho_arq104 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo104       :=
                               'BILL_DebAutom_BANCO_' || '104' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt104                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo104, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt104
                              , 'A1' ||
                                RPAD ('300108', 20, ' ') ||
                                'GVT/CURITIBA-PR     104' ||
                                RPAD ('CAIXA ECONOMICA FED', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            --Decido se é INCLUSAO ou CANCELAMENTO
            v_cabecalho_arq104      := 'S';
            v_conta_linha_arq104    := v_conta_linha_arq104 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            --Inclusao
            UTL_FILE.put_line
                   (stxt104
                   , 'E' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                     '00000000000000003                                                                                ' ||
                     '5'
                   ); -- O formato utilizado pela Caixa é diferente do da Febraban, o código de ação é diferente.
          ELSIF v_acao = '1' THEN
            --Exclusão
            UTL_FILE.put_line
                   (stxt104
                   , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          END IF;
          v_conta_linha_arq104    := v_conta_linha_arq104 + 1;
        END IF;

        --BRB
        IF (TRIM (r_linha.cod_agente_arrecadador) = '070') THEN
          IF v_cabecalho_arq070 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo070       :=
                               'BILL_DebAutom_BANCO_' || '070' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt070                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo070, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt070
                              , 'A1' ||
                                RPAD ('00771150000000009', 20, ' ') ||
                                'GVT/CURITIBA-PR     070' ||
                                RPAD ('BRB-BANCO DE BRASILI', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq070      := 'S';
            v_conta_linha_arq070    := v_conta_linha_arq070 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          UTL_FILE.put_line
                 (stxt070
                 , 'E' ||
                   RPAD (r_linha.external_id, 25, ' ') ||
                   LPAD (r_linha.cod_agencia, 4, 0) ||
                   v_campo_cc_arq_bank ||
                   TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                   '00000000000000003                                                                                ' ||
                   v_acao
                 );
          v_conta_linha_arq070    := v_conta_linha_arq070 + 1;
        END IF;

        --BANCO SAFRA
        IF (TRIM (r_linha.cod_agente_arrecadador) = '422') THEN
          IF v_cabecalho_arq422 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo422       :=
                               'BILL_DebAutom_BANCO_' || '422' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt422                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo422, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt422
                              , 'A1' ||
                                RPAD ('000007111', 20, ' ') ||
                                'GVT/CURITIBA-PR     422' ||
                                RPAD ('SAFRA', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq422      := 'S';
            v_conta_linha_arq422    := v_conta_linha_arq422 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          --dbms_output.put_line('CC1 = ' || v_campo_cc_arq_bank );
          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          --dbms_output.put_line('CC1 = ' || v_campo_cc_arq_bank );
          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --dbms_output.put_line('CC1 = ' || v_campo_cc_arq_bank );
          --Imprime TODOS os REGISTROs
          UTL_FILE.put_line
                 (stxt422
                 , 'E' ||
                   RPAD (r_linha.external_id, 25, ' ') ||
                   LPAD (SUBSTR (r_linha.cod_agencia, 1, 3), 4, 0) ||
                   v_campo_cc_arq_bank ||
                   TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                   '00000000000000003                                                                                ' ||
                   v_acao
                 );
          v_conta_linha_arq422    := v_conta_linha_arq422 + 1;
        END IF;

        --BAND
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '230' ) THEN
        --END IF;

        --BRADESCO S/A
        --Retirada a alteração provisória até adaptação da Interchange. Será gerado registro D para este banco
        IF (TRIM (r_linha.cod_agente_arrecadador) = '237') THEN
          IF v_cabecalho_arq237 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo237       :=
                               'BILL_DebAutom_BANCO_' || '237' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt237                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo237, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt237
                              , 'A1' ||
                                RPAD ('00798', 20, ' ') ||
                                'GVT/CURITIBA-PR     237' ||
                                RPAD ('BRADESCO S/A', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq237      := 'S';
            v_conta_linha_arq237    := v_conta_linha_arq237 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            UTL_FILE.put_line
                   (stxt237
                   , 'E' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                     '00000000000000003                                                                                ' ||
                     v_acao
                   );
          ELSIF v_acao = '1' THEN
            UTL_FILE.put_line
                 (stxt237
                 , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );    
          END IF;
          v_conta_linha_arq237    := v_conta_linha_arq237 + 1;
        END IF;

        --BANCO REAL S/A ABN
        IF (TRIM (r_linha.cod_agente_arrecadador) = '275') THEN
          IF v_cabecalho_arq275 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo275       :=
                               'BILL_DebAutom_BANCO_' || '275' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt275                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo275, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt275
                              , 'A1' ||
                                RPAD ('0893', 20, ' ') ||
                                'GVT/CURITIBA-PR     275' ||
                                RPAD ('BANCO REAL S/A', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq275      := 'S';
            v_conta_linha_arq275    := v_conta_linha_arq275 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
              UTL_FILE.put_line
                     (stxt275
                     , 'E' ||
                       RPAD (r_linha.external_id, 25, ' ') ||
                       LPAD (r_linha.cod_agencia, 4, 0) ||
                       v_campo_cc_arq_bank ||
                       TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                       '00000000000000003                                                                                ' ||
                       v_acao
                     );
          ELSIF v_acao = '1' THEN
            UTL_FILE.put_line
                 (stxt275
                 , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );    
          END IF; 
          
           v_conta_linha_arq275    := v_conta_linha_arq275 + 1;
        END IF;

        --BCN
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '291' ) THEN
        --END IF;

        --ITAU S/A
        --Retirada da alteração provisória até adaptação da Interchange. Será gerado registro D para este banco
        IF (TRIM (r_linha.cod_agente_arrecadador) = '341') THEN
          IF v_cabecalho_arq341 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo341       :=
                               'BILL_DebAutom_BANCO_' || '341' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt341                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo341, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt341
                              , 'A1' ||
                                RPAD ('0882100300855', 20, ' ') ||
                                'GVT/CURITIBA-PR     341' ||
                                RPAD ('ITAU S/A', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq341      := 'S';
            v_conta_linha_arq341    := v_conta_linha_arq341 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            UTL_FILE.put_line
                   (stxt341
                   , 'E' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                     '00000000000000003                                                                                ' ||
                     v_acao
                   );
          ELSIF v_acao = '1' THEN
            UTL_FILE.put_line
                   (stxt341
                   , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          END IF;
          v_conta_linha_arq341    := v_conta_linha_arq341 + 1;
        END IF;

        --CTBC
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '347' ) THEN
        --END IF;

        --SANTANDER
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '353' ) THEN
        --END IF;

        --BM
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '389' ) THEN
        --END IF;

        --HSBC BANK BRASIL S/A
        IF (TRIM (r_linha.cod_agente_arrecadador) = '399') THEN
          IF v_cabecalho_arq399 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo399       :=
                               'BILL_DebAutom_BANCO_' || '399' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt399                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo399, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt399
                              , 'A1' ||
                                RPAD ('00002755823', 20, ' ') ||
                                'GVT/CURITIBA-PR     399' ||
                                RPAD ('HSBC BANK BRASIL S/A', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq399      := 'S';
            v_conta_linha_arq399    := v_conta_linha_arq399 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 2;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          UTL_FILE.put_line
                 (stxt399
                 , 'E' ||
                   RPAD (r_linha.external_id, 25, ' ') ||
                   LPAD (r_linha.cod_agencia, 4, 0) ||
                   v_campo_cc_arq_bank ||
                   TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                   '00000000000000003                                                                                ' ||
                   v_acao
                 );
          v_conta_linha_arq399    := v_conta_linha_arq399 + 1;
        END IF;

        --UNIBANCO S/A
        --Retirada da alteração provisória até adaptação da Interchange. Será gerado registro D para este banco
        IF (TRIM (r_linha.cod_agente_arrecadador) = '409') THEN
          IF v_cabecalho_arq409 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo409       :=
                               'BILL_DebAutom_BANCO_' || '409' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt409                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo409, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt409
                              , 'A1' ||
                                RPAD ('21096799219067692', 20, ' ') ||
                                'GVT/CURITIBA-PR     409' ||
                                RPAD ('UNIBANCO S/A', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq409      := 'S';
            v_conta_linha_arq409    := v_conta_linha_arq409 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            UTL_FILE.put_line
                   (stxt409
                   , 'E' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                     '00000000000000003                                                                                ' ||
                     v_acao
                   );
          ELSIF v_acao = '1' THEN
            UTL_FILE.put_line
                   (stxt409
                   , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          END IF;
          v_conta_linha_arq409    := v_conta_linha_arq409 + 1;
        END IF;

        --CTBC
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '453' ) THEN
        --END IF;

        --BOSTON
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '479' ) THEN
        --END IF;

        --BILBAO
        --IF ( TRIM(r_linha.COD_AGENTE_ARRECADADOR) = '641' ) THEN
        --END IF;

        --CITIBANK
        --Retirada da alteração provisória até adaptação da Interchange. Será gerado registro D para este banco
        IF (TRIM (r_linha.cod_agente_arrecadador) = '745') THEN        
          IF v_cabecalho_arq745 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo745       :=
                               'BILL_DebAutom_BANCO_' || '745' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt745                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo745, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt745
                              , 'A1' ||
                                RPAD ('148', 20, ' ') ||
                                'GVT/CURITIBA-PR     745' ||
                                RPAD ('CITIBANK', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq745      := 'S';
            v_conta_linha_arq745    := v_conta_linha_arq745 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;

          IF v_ag = 1 THEN
            IF v_dvag = 1 THEN
              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
                v_campo_cc_arq_bank;
            END IF;
          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;

          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN
            --Inclusão
            UTL_FILE.put_line
                   (stxt745
                   , 'E' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                     '00000000000000003                                                                                ' ||
                     v_acao
                   );
          ELSIF v_acao = '1' then
            --Exclusão
            UTL_FILE.put_line
                   (stxt745
                   , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          END IF;
          v_conta_linha_arq745    := v_conta_linha_arq745 + 1;
        END IF;

        --BANSICREDI
        IF (TRIM (r_linha.cod_agente_arrecadador) = '748') THEN
          IF v_cabecalho_arq748 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo748       :=
                               'BILL_DebAutom_BANCO_' || '748' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt748                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo748, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt748
                              , 'A1' ||
                                RPAD ('6D', 20, ' ') ||
                                'GVT/CURITIBA-PR     748' ||
                                RPAD ('BANSICREDI', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq748      := 'S';
            v_conta_linha_arq748    := v_conta_linha_arq748 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;
--COMENTARIO MAYCON
--          IF v_ag = 1 THEN
--            IF v_dvag = 1 THEN
--              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
--            ELSE
--              v_campo_cc_arq_bank    :=
--                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
--                v_campo_cc_arq_bank;
--            END IF;
--          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;
          --Imprime TODOS os REGISTROs
          IF v_acao = '0' THEN --Inclusao
          UTL_FILE.put_line
                 (stxt748
                 , 'E' ||
                   RPAD (r_linha.external_id, 25, ' ') ||
                   LPAD (r_linha.cod_agencia, 4, 0) ||
                   v_campo_cc_arq_bank ||
                   TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                   '00000000000000003                                                                                ' ||
                   v_acao
                 );
            ELSIF v_acao = '1' THEN --Exclusão
            UTL_FILE.put_line
                   (stxt748
                   , 'D' ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     LPAD (r_linha.cod_agencia, 4, 0) ||
                     v_campo_cc_arq_bank ||
                     RPAD (r_linha.external_id, 25, ' ') ||
                     RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                     RPAD (' ', 20, ' ') ||
                     v_acao
                   );
          END IF;
          v_conta_linha_arq748    := v_conta_linha_arq748 + 1;
        END IF;

        --BANCOOB
        IF (TRIM (r_linha.cod_agente_arrecadador) = '756') THEN
          IF v_cabecalho_arq756 = 'N' THEN
            --Gero nome do arquivo
            v_nome_arquivo756       :=
                               'BILL_DebAutom_BANCO_' || '756' || '_' || TO_CHAR (SYSDATE, 'YYYYMMDDhh24miss')
                               || '.txt';
            --Crio arquivo
            stxt756                 := UTL_FILE.fopen (v_caminho, v_nome_arquivo756, 'w');

            --Pego o sequencial na BANK_SEQS
            SELECT seq_numb
              INTO v_seq_numb
              FROM bank_seqs
             WHERE bank_id = TO_NUMBER (r_linha.cod_agente_arrecadador);
             --v_seq_numb :=0; -- Solicitacao Carol

            --Imprime CABECALHO
            UTL_FILE.put_line (stxt756
                              , 'A1' ||
                                RPAD ('08460082', 20, ' ') ||
                                'GVT/CURITIBA-PR     756' ||
                                RPAD ('BANCOOB', 20, ' ') ||
                                TO_CHAR (SYSDATE, 'YYYYMMDD') ||
                                LPAD (v_seq_numb, 6, 0) ||
                                '04DEBITO AUTOMATICO                                                    '
                              );
            v_cabecalho_arq756      := 'S';
            v_conta_linha_arq756    := v_conta_linha_arq756 + 1;
          END IF;

          --Decido se é INCLUSAO ou CANCELAMENTO
          IF (r_linha.tp_evento = 'I') THEN
            v_acao    := '0';   --INCLUSAO
          ELSE
            v_acao    := '1';   --EXCLUSAO
          END IF;

          v_campo_cc_arq_bank     := TRIM (r_linha.num_cc_cartao);
          v_qtde_dv_ag            := 0;
          v_qtde_dv_cc            := 1;

          --Pego as caracteristicas para a formacao do CAMPO CC no arquivo bancario a ser enviado.
          BEGIN
            SELECT cc
                  ,ag
                  ,bco
                  ,dvag
                  ,dvcc
                  ,RIGHT
                  ,LEFT
                  ,LENGTH
                  ,hiphen
              INTO v_cc
                  ,v_ag
                  ,v_bco
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = TRIM (r_linha.cod_agente_arrecadador);
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_cc = 1 THEN
            IF v_dvcc = 1 THEN
              v_campo_cc_arq_bank    := v_campo_cc_arq_bank;
            ELSE
              v_campo_cc_arq_bank    :=
                                    SUBSTR (v_campo_cc_arq_bank, 1, LENGTH (TRIM (v_campo_cc_arq_bank) ) - v_qtde_dv_cc);
            END IF;
          ELSE
            v_campo_cc_arq_bank    := '';
          END IF;
--COMENTARIO MAYCON
--          IF v_ag = 1 THEN
--            IF v_dvag = 1 THEN
--              v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
--            ELSE
--              v_campo_cc_arq_bank    :=
--                SUBSTR (r_linha.cod_agencia, 1, LENGTH (TRIM (r_linha.cod_agencia) ) - v_qtde_dv_ag) ||
--                v_campo_cc_arq_bank;
--            END IF;
--          END IF;

          IF v_bco = 1 THEN
            v_campo_cc_arq_bank    := TRIM (r_linha.cod_agente_arrecadador) || v_campo_cc_arq_bank;
          END IF;

          IF v_right = 1 THEN
            v_campo_cc_arq_bank    := RPAD (RPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
          ELSE
            IF v_left = 1 THEN
              v_campo_cc_arq_bank    := RPAD (LPAD (v_campo_cc_arq_bank, v_length, 0), 14, ' ');
            ELSE
              v_campo_cc_arq_bank    := RPAD (v_campo_cc_arq_bank, 14, ' ');
            END IF;
          END IF;
          --Imprime TODOS os REGISTROs
              IF v_acao = '0' THEN --Inclusao
                  UTL_FILE.put_line
                  (stxt756
                , 'E' ||
                RPAD (r_linha.external_id, 25, ' ') ||
                LPAD (r_linha.cod_agencia, 4, 0) ||
                v_campo_cc_arq_bank ||
                TO_CHAR (SYSDATE + 1, 'YYYYMMDD') ||
                '00000000000000003                                                                                ' ||
                v_acao
                );
            ELSIF v_acao = '1' THEN --Exclusão
                UTL_FILE.put_line
                  (stxt756
                , 'D' ||
                RPAD (r_linha.external_id, 25, ' ') ||
                LPAD (r_linha.cod_agencia, 4, 0) ||
                v_campo_cc_arq_bank ||
                RPAD (r_linha.external_id, 25, ' ') ||
                RPAD ('EXCLUSAO SOLICITADA POR INTERESSE DO CLIENTE',60,' ') ||
                RPAD (' ', 20, ' ') ||
                v_acao
                );
            END IF;
          v_conta_linha_arq756    := v_conta_linha_arq756 + 1;
        END IF;

/*
        --- 1 de 2 ----------------------------------------
-- MUDANCA DE "STATUS_CADASTRAMENT"O de 2 para 3 --
-- NA TAB "GVT_DACC_GERENCIA_MET_PGTO" ------------
---------------------------------------------------
        UPDATE gvt_dacc_gerencia_met_pgto
           SET status_cadastramento = 3   --De "Solicitado" para "Pendente"
         WHERE external_id = r_linha.external_id;

        COMMIT;

-------------------------------------------------

        --- 2 de 2 --------------------------------
-- MUDANCA DE STATUS_EVENTO de 0 para 9 ---
-- Na TAB GVT_DACC_GERENCIA_FILA_EVENTOS --
-------------------------------------------
        UPDATE gvt_dacc_gerencia_fila_eventos
           SET status_evento = 9   --de "Processar" para "Pendente"
         WHERE external_id = r_linha.external_id
           AND sequencia =
                 (SELECT MIN (sequencia)
                    FROM gvt_dacc_gerencia_fila_eventos
                   WHERE status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND aguarda_retorno = 'S'
                     AND external_id = r_linha.external_id)
           AND status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
           AND aguarda_retorno = 'S';

        COMMIT;*/
        
        
        --ALTERAÇÃO POR FILIPE
        --Aqui estou pegando o código do banco para poder ver se devo esperar por resposta do banco ou não
        v_banco := TRIM(r_linha.cod_agente_arrecadador);
        
        -- Estou admitindo que terei que fazer pelo método antigo a atualização pra pendente
        --v_pendente:=0;
        
        UTL_FILE.put_line (slog, 'BANCO: ' || v_banco);
        
        /*IF (  v_banco = '745'
           OR v_banco = '001'
           OR v_banco = '341'
           OR v_banco = '237'
           OR v_banco = '409'
           OR v_banco = '041'
           OR v_banco = '104') THEN
          --É um dos bancos que não darão retorno*/
          
          --Selecionando os métodos de pagamento
          --Somente forçar status qdo é de 3->1 e 3->3
          SELECT     old_pay_method,
                  pay_method
            INTO  v_old_pmethod, v_method
            FROM  GVT_DACC_GERENCIA_MET_PGTO
           WHERE  EXTERNAL_ID = r_linha.external_id;
          
          UTL_FILE.put_line (slog, 'OLD: ' || v_old_pmethod || ' NEW: ' || v_method);
          
          UTL_FILE.put_line (slog, 'TP_EVENTO: ' || r_linha.tp_evento);
          
          --Verifico os métodos de pagamento. 3->DACC, 2->CC, 1->Fatura
          IF (v_old_pmethod = '3' AND (v_method = '1' or v_method = '2' or v_method = '3')) THEN
            --Decido se é INCLUSAO ou CANCELAMENTO
            IF ( r_linha.tp_evento = 'E' ) THEN
              -- Indica que não deverá fazer o procedimento como antes
              --v_pendente := 1;
              --Seleciono o código da conta do cliente
              SELECT ACCOUNT_NO
              INTO   v_account_no
              FROM   CUSTOMER_ID_ACCT_MAP
              WHERE  external_id = r_linha.external_id;
              
              IF v_method <> '2' then
                IF v_method <> '1' then
                  --Indico ao ARBOR que a cobrança será por fatura
                  UPDATE PAYMENT_PROFILE
                  SET    PAY_METHOD = 1
                  WHERE  ACCOUNT_NO = v_account_no;
                  
                  UPDATE gvt_dacc_gerencia_met_pgto
                     SET status_cadastramento = 1   --De "Solicitado" para "OK"
                   WHERE external_id = r_linha.external_id;
                ELSE
                  --Indico ao ARBOR que a cobrança será por fatura
                  UPDATE PAYMENT_PROFILE
                  SET    PAY_METHOD = 1
                  WHERE  ACCOUNT_NO = v_account_no;
                  
                  UPDATE gvt_dacc_gerencia_met_pgto
                     SET status_cadastramento = 1   --De "Solicitado" para "OK"
                   WHERE external_id = r_linha.external_id;
                END IF;
               
              ELSE
                UPDATE PAYMENT_PROFILE
                SET    PAY_METHOD = 1
                WHERE  ACCOUNT_NO = v_account_no;
                
                UPDATE gvt_dacc_gerencia_met_pgto
                   SET status_cadastramento = 3   --De "Solicitado" para "OK"
                 WHERE external_id = r_linha.external_id;
              END IF;
              
              UPDATE gvt_dacc_gerencia_fila_eventos
                 SET status_evento = 1   --de "Pendente" para "Processado"
               WHERE external_id = r_linha.external_id
                 AND sequencia = r_linha.sequencia                       
                 AND status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                 AND aguarda_retorno = 'S';
            END IF;--IF exclusão
          END IF;--IF Pay_Method
        --END IF;--IF BANCOS
        
        
        --IF v_pendente = 0 THEN
        IF ( r_linha.tp_evento = 'I' ) THEN
          UTL_FILE.put_line (slog, 'INCLUSÃO BANCO: ' || v_banco);
          --- 1 de 2 ----------------------------------------
          -- MUDANCA DE "STATUS_CADASTRAMENT"O de 2 para 3 --
          -- NA TAB "GVT_DACC_GERENCIA_MET_PGTO" ------------
          ---------------------------------------------------
          UPDATE gvt_dacc_gerencia_met_pgto
             SET status_cadastramento = 3   --De "Solicitado" para "Pendente"
           WHERE external_id = r_linha.external_id;
  
          COMMIT;
  
          -------------------------------------------------
  
          --- 2 de 2 --------------------------------
          -- MUDANCA DE STATUS_EVENTO de 0 para 9 ---
          -- Na TAB GVT_DACC_GERENCIA_FILA_EVENTOS --
          -------------------------------------------
          UPDATE gvt_dacc_gerencia_fila_eventos
             SET status_evento = 9   --de "Processar" para "Pendente"
           WHERE external_id = r_linha.external_id
             AND sequencia = r_linha.sequencia                   
             AND status_evento = 0   --0 = Processar / 1 = Ja Processado / 9 = Pendente
             AND aguarda_retorno = 'S';

          COMMIT;
        END IF;
        
---------------------------------------------
      END IF;   --Verificacao no ARBOR
      
    END LOOP;

-------------------------------------------------
-- IMPRESSAO DO RODAPE --------------------------
-------------------------------------------------

    --BANCO DO BRASIL S/A
    if (v_cabecalho_arq001 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 001;
        --v_seq_numb :=0; -- Solicitacao Carol


        v_conta_linha_arq001 := v_conta_linha_arq001 + 2;

        utl_file.put_line(stxt001, 'J' || lpad(v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad(v_conta_linha_arq001, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt001, 'Z' || lpad(v_conta_linha_arq001, 6, 0) || '00000000000000000                                                                                                                              ');

        --utl_file.put_line(stxt001, '');
        utl_file.fclose(stxt001);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('001', v_seq_numb, sysdate, null);
        commit;

    end if;

    --BANRISUL
    if (v_cabecalho_arq041 = 'S') then

        v_conta_linha_arq041 := v_conta_linha_arq041 + 1;
        utl_file.put_line(stxt041, 'Z' || lpad (v_conta_linha_arq041, 6, 0) || '00000000000000000                                                                                                                              ');

        --utl_file.put_line (stxt041, '');
        utl_file.fclose (stxt041);

    end if;

    --caixa economica fed
    if (v_cabecalho_arq104 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 104;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq104 := v_conta_linha_arq104 + 2;

        utl_file.put_line(stxt104, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq104, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt104, 'Z' || lpad (v_conta_linha_arq104, 6, 0) || '00000000000000000                                                                                                                              ');
        
        --utl_file.put_line(stxt104, '');
        utl_file.fclose(stxt104);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('104', v_seq_numb, sysdate, null);
        commit;

    end if;

    --brb
    if (v_cabecalho_arq070 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 070;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq070 := v_conta_linha_arq070 + 2;

        utl_file.put_line(stxt070, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq070, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt070, 'Z' || lpad (v_conta_linha_arq070, 6, 0) || '00000000000000000                                                                                                                              ');
        
        --utl_file.put_line (stxt070, '');
        utl_file.fclose (stxt070);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('070', v_seq_numb, sysdate, null);
        commit;

    end if;

    --safra
    if (v_cabecalho_arq422 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 422;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq422 := v_conta_linha_arq422 + 2;

        utl_file.put_line(stxt422, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq422, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt422, 'Z' || lpad (v_conta_linha_arq422, 6, 0) || '00000000000000000                                                                                                                              ');

        --utl_file.put_line (stxt422, '');
        utl_file.fclose (stxt422);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('422', v_seq_numb, sysdate, null);
        commit;

    end if;

    --bradesco s/a
    if (v_cabecalho_arq237 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 237;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq237 := v_conta_linha_arq237 + 2;

        utl_file.put_line(stxt237, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq237, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt237, 'Z' || lpad (v_conta_linha_arq237, 6, 0) || '00000000000000000                                                                                                                              ');

        --utl_file.put_line (stxt237, '');
        utl_file.fclose (stxt237);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('237', v_seq_numb, sysdate, null);
        commit;

    end if;

    --banco real s/a abn
    if (v_cabecalho_arq275 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 275;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq275 := v_conta_linha_arq275 + 2;

        utl_file.put_line(stxt275, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq275, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt275, 'Z' || lpad (v_conta_linha_arq275, 6, 0) || '00000000000000000                                                                                                                              ');
        
        --utl_file.put_line (stxt275, '');
        utl_file.fclose (stxt275);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('275', v_seq_numb, sysdate, null);
        commit;

    end if;

    --itau s/a
    if (v_cabecalho_arq341 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 341;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq341 := v_conta_linha_arq341 + 2;

        utl_file.put_line(stxt341, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq341, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt341, 'Z' || lpad (v_conta_linha_arq341, 6, 0) || '00000000000000000                                                                                                                              ');
        
        --utl_file.put_line (stxt341, '');
        utl_file.fclose (stxt341);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('341', v_seq_numb, sysdate, null);
        commit;

    end if;

    --hsbc bank brasil s/a
    if (v_cabecalho_arq399 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 399;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq399 := v_conta_linha_arq399 + 2;

        utl_file.put_line(stxt399, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq399, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt399, 'Z' || lpad (v_conta_linha_arq399, 6, 0) ||'00000000000000000                                                                                                                              ');

        --utl_file.put_line (stxt399, '');
        utl_file.fclose (stxt399);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('399', v_seq_numb, sysdate, null);
        commit;

    end if;

    --unibanco s/a
    if (v_cabecalho_arq409 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 409;
        --v_seq_numb :=0; -- Solicitacao Carol
        
        v_conta_linha_arq409 := v_conta_linha_arq409 + 2;

        utl_file.put_line(stxt409, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq409, 6, 0) || '00000000000000000' ||  '                                                                                                                ');
        utl_file.put_line(stxt409, 'Z' || lpad (v_conta_linha_arq409, 6, 0) || '00000000000000000                                                                                                                              ' );
        
        --utl_file.put_line (stxt409, '');
        utl_file.fclose (stxt409);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('409', v_seq_numb, sysdate, null);
        commit;

    end if;

    --citibank
    if (v_cabecalho_arq745 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 745;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq745 := v_conta_linha_arq745 + 2;

        utl_file.put_line(stxt745, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq745, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt745, 'Z' || lpad (v_conta_linha_arq745, 6, 0) || '00000000000000000                                                                                                                              ');

        --utl_file.put_line(stxt745, '');
        utl_file.fclose(stxt745);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('745', v_seq_numb, sysdate, null);
        commit;

    end if;

  --bansicredi s/a
    if (v_cabecalho_arq748 = 'S') then

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 748;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq748 := v_conta_linha_arq748 + 2;

        utl_file.put_line(stxt748, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq748, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt748, 'Z' || lpad (v_conta_linha_arq748, 6, 0) ||'00000000000000000                                                                                                                              ');
        
        --utl_file.put_line(stxt748, '');
        utl_file.fclose(stxt748);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('748', v_seq_numb, sysdate, null);
        commit;

    end if;

  --bancoob s/a
      if (v_cabecalho_arq756 = 'S') THEN

        select seq_numb into v_seq_numb from bank_seqs where bank_id = 756;
        --v_seq_numb :=0; -- Solicitacao Carol

        v_conta_linha_arq756 := v_conta_linha_arq756 + 2;

        utl_file.put_line(stxt756, 'J' || lpad (v_seq_numb, 6, 0) || to_char(sysdate,'YYYYMMDD') || lpad (v_conta_linha_arq756, 6, 0) || '00000000000000000' || '                                                                                                                ');
        utl_file.put_line(stxt756, 'Z' || lpad (v_conta_linha_arq756, 6, 0) ||'00000000000000000                                                                                                                              ');
        
        --utl_file.put_line(stxt756, '');
        utl_file.fclose(stxt756);

        insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values ('756', v_seq_numb, sysdate, null);
        commit;

    end if;
    
    COMMIT;

    --BESC IF (v_cabecalho_arq027 = 'S') THEN END IF;
    --BEG S/A IF (v_cabecalho_arq031 = 'S') THEN END IF;
    --BANESTADO IF (v_cabecalho_arq038 = 'S') THEN END IF;
    --BANRISUL IF (v_cabecalho_arq039 = 'S') THEN END IF;
    --CTBCI IF (v_cabecalho_arq048 = 'S') THEN END IF;
    --LEMON BANK IF (v_cabecalho_arq065 = 'S') THEN END IF;
    --BANCO BBA S/A IF (v_cabecalho_arq184 = 'S') THEN END IF;
    --BAND IF (v_cabecalho_arq230 = 'S') THEN END IF;
    --BCN IF (v_cabecalho_arq291 = 'S') THEN END IF;
    --CTBC IF (v_cabecalho_arq347 = 'S') THEN END IF;
    --SANTANDER IF (v_cabecalho_arq353 = 'S') THEN END IF;
    --BM IF (v_cabecalho_arq389 = 'S') THEN END IF;
    --CTBC IF (v_cabecalho_arq453 = 'S') THEN END IF;
    --BOSTON IF (v_cabecalho_arq479 = 'S') THEN END IF;
    --BILBAO IF (v_cabecalho_arq641 = 'S') THEN END IF;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      UTL_FILE.put_line (slog, 'ERRO : Estava processando o External_id: ' || v_aux_external_id);
      UTL_FILE.put_line (slog, 'ERRO : ' || SQLERRM (SQLCODE) );
      raise_application_error (-20100, 'ERRO Geral !!!!' || SQLERRM (SQLCODE) );      
      ROLLBACK;
  END;

  UTL_FILE.fclose(slog);
END;
/

EXIT;

