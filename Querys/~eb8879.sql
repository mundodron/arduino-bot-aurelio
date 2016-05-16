-- *********************************************************************************************************************************
-- Script    : carrega_arq_retorno_dacc.sql
-- Creation  : 20/07/2004 - Billing Desenvolvimento - Antonio Rafael
-- *********************************************************************************************************************************
-- Alteração : 14/09/2011 - RFC 313127 - Alteração para não gravar logs desnecessários, pois estava excedendo a variável v_log_full 
--                                                    e não processava o arquivo. E aumento da variável v_motivo para VARCHAR2(80), antes era VARCHAR2(58).
--                                                - Responsável: Evelize Amaral dos Santos.
-- *********************************************************************************************************************************
-- Alteração : 16/01/2012 - RFC 342740 - Alteraçao para não considerar conta cobrança inativa.
--                                                - Responsável: Evelize Amaral dos Santos.

DECLARE
  v_nome_arquivo_ler       VARCHAR2 (500)                                         := TRIM ('&1');
  v_caminho_ler            VARCHAR2 (500)                                         := TRIM ('&2');

  v_nome_arquivo_log       VARCHAR2 (500)                                         := TRIM ('&3');
  v_caminho_log            VARCHAR2 (500)                                         := TRIM ('&2');

  --Relatorio de cadastro de d.a. negados pelo banco
  v_nome_arquivo_rel       VARCHAR2 (500)                                         := 'DACC_CADASTROS_REJEITADOS_'||to_char(sysdate, 'DDMMYYYYHH24MISS')||'.txt';
  v_caminho_rel            VARCHAR2 (500)                                         := '&2';
  srel                     UTL_FILE.file_type;
  v_count_rel              number(10)                                             := 0;
  -----

  v_tipo_arquivo           VARCHAR2 (3);
  v_qtd_registros          NUMBER (10, 0)                                         := &4;
  v_qtd_linhas             NUMBER (10, 0)                                         := &5;
  v_tamanho_registro       NUMBER (3);
  v_registro_full          VARCHAR2 (151);
  v_log_full               VARCHAR2 (30000)                                       := '';   --MAX eh 32.767
  v_1o_caracter            CHAR (1);
  v_status                 gvt_dacc_gerencia_met_pgto.status_cadastramento%TYPE;   -- 1=ATIVO , 2=SOLICITADO , 3=PENDENTE
  v_account_no             customer_id_acct_map.account_no%TYPE;
  v_pay_method             gvt_dacc_gerencia_met_pgto.pay_method%TYPE;
  v_qtde_evento            NUMBER (1)                                             := 0;
  v_achou_arbor            NUMBER (1)                                             := 0;   --1 achou, 0 nao acho
  v_achou_bu               NUMBER (1)                                             := 0;   --1 achou, 0 nao acho
  -- Variaveis do CABECALHO
  v_cod_banco              VARCHAR2 (03);
  -- Variaveis do REGISTRO
  v_external_id            customer_id_acct_map.external_id%TYPE;
  v_ag                     VARCHAR2 (05);
  v_cc                     VARCHAR2 (15);
  v_tipo_cad               VARCHAR2 (02);
  v_cod_retorno            VARCHAR2 (02);
  etlf                     UTL_FILE.file_type;
  slog                     UTL_FILE.file_type;
  vcount                   NUMBER (10, 0)                                         := 0;
  vcont_registro_lido      NUMBER (10, 0)                                         := 0;
  vcont_registro_gravado   NUMBER (10, 0)                                         := 0;
  v_cc_cfg                 gvt_cmf_rule_acc.cc%TYPE;
  v_ag_cfg                 gvt_cmf_rule_acc.ag%TYPE;
  v_bco_cfg                gvt_cmf_rule_acc.bco%TYPE;
  v_dvag                   gvt_cmf_rule_acc.dvag%TYPE;
  v_dvcc                   gvt_cmf_rule_acc.dvcc%TYPE;
  v_right                  gvt_cmf_rule_acc.RIGHT%TYPE;
  v_left                   gvt_cmf_rule_acc.LEFT%TYPE;
  v_length                 gvt_cmf_rule_acc.LENGTH%TYPE;
  v_hiphen                 gvt_cmf_rule_acc.hiphen%TYPE;
  v_cc_limpo               VARCHAR2 (15);
  v_dv_cc                  VARCHAR2 (2);
  v_contador               NUMBER(10)                                                 := 0;

  v_motivo                 VARCHAR2(80)                                             := null; --Tratamento do registro 'H' 
                                                                                                                                                                                       --RFC 313127
  v_nome_banco             VARCHAR2(80);

  v_pay_method_atual       VARCHAR2 (1);
  
  -- Registro 'J'
  v_nsa                    varchar2(6);
  v_data_geracao           varchar2(8);
  v_data_processamento     varchar2(8);
  
  

---------------------------------------------------
---------------------------------------------------
-- SUB_PROCEDURES P/ CALCULO dos DVs
-- Somente para os casos de gvt_cmf_rule_acc.DVCC = 0
---------------------------------------------------
---------------------------------------------------
-- Real_ABN
-- Banco do Brasil
  PROCEDURE calcula_dvcc (p_bco IN VARCHAR2, p_cc IN VARCHAR2, p_ag VARCHAR2, p_dv_cc OUT VARCHAR2)
  IS
    v_soma_cc       NUMBER (38)   := 0;
    v_cc_length     NUMBER (38)   := 0;
    v_peso          NUMBER (1)    := 0;
    v_caracter_cc   NUMBER (38)   := 0;
    v_multi_cc      NUMBER (38)   := 0;
    v_dv_agcc       VARCHAR2 (100) := NULL;
    i               NUMBER        := 0;
    v_numero        VARCHAR2 (100) := NULL;
    v_unid          NUMBER        := 0;
    v_tot1          NUMBER        := 0;
    v_total         NUMBER        := 0;
    v_pesos         VARCHAR2 (12) := '81472259395';
    v_tam           NUMBER        := 0;
    v_resto         NUMBER        := 0;
  BEGIN
    IF (p_bco = '001') THEN
      v_cc_length    := LENGTH (TRIM (p_cc) );
      v_peso         := 9;

      FOR i IN REVERSE 1 .. v_cc_length
      LOOP
        IF (v_peso = 1) THEN
          v_peso    := 9;
        END IF;

        v_caracter_cc    := TO_NUMBER (SUBSTR (p_cc, i, 1) );
        v_multi_cc       := TO_NUMBER (v_caracter_cc * v_peso);
        v_soma_cc        := v_soma_cc + v_multi_cc;
        v_peso           := v_peso - 1;
      END LOOP;

      p_dv_cc        := TO_CHAR (MOD (v_soma_cc, 11) );

      IF (TRIM (p_dv_cc) = '10') THEN
        p_dv_cc    := 'X';
      END IF;
    --ELSIF (p_bco = '104') THEN
    --ELSIF (p_bco = '237') THEN
    ELSIF (p_bco = '275') THEN
      v_numero    := p_ag || p_cc;
      v_tam       := LENGTH (TRIM (v_numero) );

      FOR i IN 1 .. v_tam
      LOOP
        v_unid     := TO_NUMBER (SUBSTR (v_numero, i, 1) );
        v_peso     := TO_NUMBER (SUBSTR (v_pesos, i, 1) );
        v_tot1     := v_unid * v_peso;
        v_total    := v_total + v_tot1;
      END LOOP;

      v_resto     := MOD (v_total, 11);
      p_dv_cc     := TO_CHAR (11 - v_resto);

      IF (p_dv_cc = '10') THEN
        p_dv_cc    := '0';
      ELSIF (p_dv_cc = '11') THEN
        p_dv_cc    := '1';
      END IF;
    --ELSIF (p_bco = '341') THEN
    --ELSIF (p_bco = '399') THEN
    --ELSIF (p_bco = '409') THEN
    --ELSIF (p_bco = '745') THEN
    END IF;
  END calcula_dvcc;

BEGIN

        begin
        slog := UTL_FILE.fopen (v_caminho_log, v_nome_arquivo_log ||(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')), 'w');
        exception
        when utl_file.invalid_path then
             dbms_output.put_line('Diretório de log incorreto.');
             dbms_output.put_line('SQLCODE: '||sqlerrm);
        when utl_file.invalid_mode then
             dbms_output.put_line('Modo de abertura do arquivo de log incorreto.');
             dbms_output.put_line('SQLCODE: '||sqlerrm);
        when utl_file.invalid_operation then
             dbms_output.put_line('Arquivo de log não pode ser aberto.');
             dbms_output.put_line('SQLCODE: '||sqlerrm);
        end;

        begin
          etlf := UTL_FILE.fopen (v_caminho_ler, v_nome_arquivo_ler , 'r');
        exception
            when utl_file.invalid_path then
                 dbms_output.put_line('Diretório de log incorreto.');
                 dbms_output.put_line('SQLCODE: '||sqlerrm);
            when utl_file.invalid_mode then
                 dbms_output.put_line('Modo de abertura do arquivo de log incorreto.');
                 dbms_output.put_line('SQLCODE: '||sqlerrm);
            when utl_file.invalid_operation then
                 dbms_output.put_line('Arquivo de log não pode ser aberto.');
                 dbms_output.put_line('SQLCODE: '||sqlerrm);
        end;

  UTL_FILE.put_line (slog, 'Arquivo A SER LIDO...............:' || v_caminho_ler || '/' || v_nome_arquivo_ler);
  UTL_FILE.put_line (slog, 'Qtde de registros A SEREM LIDOS..:' || v_qtd_registros);

  LOOP
--  UTL_FILE.put_line (slog, 'Arquivo A SER LIDO...............:' || v_caminho_ler || '/' || v_nome_arquivo_ler);
--  UTL_FILE.put_line (slog, 'Qtde de registros A SEREM LIDOS..:' || v_qtd_registros);

    vcount                := vcount + 1;
    v_achou_arbor         := 0;   --1 achou, 0 nao acho
    v_achou_bu            := 0;   --1 achou, 0 nao acho
    UTL_FILE.get_line (etlf, v_registro_full);
    v_tamanho_registro    := LENGTH (v_registro_full);

    IF (v_tamanho_registro = 150) THEN   -- Tamanho correto 150 posicoes.
      v_1o_caracter    := SUBSTR (v_registro_full, 1, 1);

      IF (v_1o_caracter = 'A') THEN   --Se for Cabecalho
        --Pego o BANCO a ser Lido.
        v_cod_banco    := SUBSTR(v_registro_full, 43, 3);
        v_nome_banco   := TRIM(SUBSTR(v_registro_full, 46, 20)); --Relatorio de DA rejeitado
      END IF;

---------------------------------
---------------------------------
-- CADASTRO/EXCLUSAO VIA BANCO --
---------------------------------
---------------------------------
      IF (v_1o_caracter = 'B') THEN   -- 'B' Cadastro/Exclusao via Banco
        vcont_registro_lido    := vcont_registro_lido + 1;
        --Pegar os campos a serem utilizados
        v_external_id          := TRIM (SUBSTR (v_registro_full, 2, 25) );
        v_ag                   := SUBSTR (v_registro_full, 27, 4);
        v_cc                   := SUBSTR (v_registro_full, 31, 14);
        v_cc_limpo             := v_cc;
        v_tipo_cad             := SUBSTR (v_registro_full, 150, 1);   -- 1_Exclusão 2_Inclusão

---------------------------------------------------------------------------
------------------------------------------------------------------
-- LIMPO a Conta Corrente para cadastramento na BASE UNICA
------------------------------------------------------------------
        IF (   v_cod_banco = '001'
            OR v_cod_banco = '104'
            OR v_cod_banco = '237'
            OR v_cod_banco = '275'
            OR v_cod_banco = '341'
            OR v_cod_banco = '399'
            OR v_cod_banco = '409'
            OR v_cod_banco = '745'
            OR v_cod_banco = '070'--BRB MAYCON
            OR v_cod_banco = '422'--SAFRA
            OR v_cod_banco = '041'--BANRISUL MAYCON
            OR v_cod_banco = '748'--BANSICREDI MAYCON
            OR v_cod_banco = '756'--BANCOOB MAYCON
           ) THEN
          v_cc_limpo    := TRIM (v_cc);

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
              INTO v_cc_cfg
                  ,v_ag_cfg
                  ,v_bco_cfg
                  ,v_dvag
                  ,v_dvcc
                  ,v_right
                  ,v_left
                  ,v_length
                  ,v_hiphen
              FROM gvt_cmf_rule_acc
             WHERE clearing_house_id = v_cod_banco;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              raise_application_error (-20101, 'ERRO...CONFIGURACAO de FORMATACAO do BANCO NAO EXISTE');
          END;

          IF v_right = 1 THEN
            v_cc_limpo    := RTRIM (v_cc_limpo, '0');
          ELSE
            IF v_left = 1 THEN
              v_cc_limpo    := LTRIM (v_cc_limpo, '0');
            END IF;
          END IF;

          IF v_bco_cfg = 1 THEN
            v_cc_limpo    := SUBSTR (v_cc_limpo, 4, 14);
          END IF;

          IF v_ag_cfg = 1 THEN
            IF v_cod_banco = '422' THEN
              v_ag          := SUBSTR (v_cc_limpo, 1, 3);
              v_cc_limpo    := SUBSTR (v_cc_limpo, 4, 14);
            ELSE
              v_cc_limpo    := SUBSTR (v_cc_limpo, 5, 14);
            END IF;
          END IF;

          IF v_cc_cfg = 1 THEN
            IF v_dvcc = 0 THEN
              calcula_dvcc (v_cod_banco, v_cc_limpo, v_ag, v_dv_cc);   --Retorno "v_dv_cc"
              v_cc_limpo    := v_cc_limpo || v_dv_cc;
            END IF;
          END IF;
        END IF;

-----------------------------------------------------------------

        ------------------------------------------------------------------
-- Acho o ACCOUNT_NO
------------------------------------------------------------------
        BEGIN            
          SELECT account_no
            INTO v_account_no
            FROM customer_id_acct_map
            WHERE  external_id = v_external_id
            and inactive_date is null; --RFC 342740

          v_achou_arbor    := 1;   --Acho no ARBOR
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --RFC 313127
            /*v_log_full       :=
              v_log_full                                      ||
              ' ### ERROR ###'                                ||
              CHR (10)                                        ||
              ' Nao foi possivel carregar a Linha.: '         ||
              vcount                                          ||
              CHR (10)                                        ||
              ' Registro REJEITADO.:'                         ||
              CHR (10)                                        ||
              ' '                                             ||
              v_registro_full                                 ||
              CHR (10)                                        ||
              ' '                                             ||
              'Motivo.: Nao Encontrou o EXTERNAL_ID no ARBOR' ||
              CHR (10)                                        ||
              ' ####'                                         ||
              CHR (10);*/
            v_achou_arbor    := 0;   --Cliente não cadastrado no ARBOR
        END;

        IF (v_achou_arbor = 1) THEN   --Cliente cadastrado no ARBOR
------------------------------------------------------------------
-- Verifico se cliente esta na BASE UNICA(Pego Status)
------------------------------------------------------------------
          BEGIN
            SELECT status_cadastramento
              INTO v_status
              FROM gvt_dacc_gerencia_met_pgto
             WHERE external_id = v_external_id;
             
            v_achou_bu    := 1;   --achou na BU
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_achou_bu    := 0;   --Cliente não cadastrado na BASE UNICA
          END;
                    
          IF (v_achou_bu = 1) THEN
            IF (v_status = 1 OR v_status = 2) THEN   -- 1=Ativo , 2=Solicitado
              IF (v_tipo_cad = '2') THEN   --Inclusao
                UPDATE gvt_dacc_gerencia_met_pgto
                   SET dt_cadastro = SYSDATE
                      ,old_pay_method = pay_method
                      ,old_cod_agente_arrecadador = cod_agente_arrecadador
                      ,old_cod_agencia = cod_agencia
                      ,old_num_cc_cartao = num_cc_cartao
                      ,pay_method = 3
                      ,cod_agente_arrecadador = v_cod_banco
                      ,cod_agencia = v_ag
                      ,num_cc_cartao = v_cc_limpo
                      ,titular_cartao = NULL
                      ,dt_expiracao_cartao = NULL
                      ,status_cadastramento = 1
                      ,quem = 'BCO'
                 WHERE external_id = v_external_id;

                UPDATE payment_profile
                   SET pay_method = 3
                      ,cust_bank_sort_code = v_ag
                      ,ownr_lname = v_cc
                      ,cust_bank_acc_num = TRIM (v_external_id)
                      ,clearing_house_id = TRIM (v_cod_banco)
                 WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);

                vcont_registro_gravado    := vcont_registro_gravado + 1;
              END IF;
                            
              IF (v_tipo_cad = '1') THEN   -- Exclusao
                    -- Alteração: Luciano X. da Veiga 
                    -- Verificando se a exclusão pedida esta de acordo com a Base
                    select count(*) 
                    into v_contador
                    from gvt_dacc_gerencia_met_pgto
                    where pay_method = 3
                    and   external_id = v_external_id
                    and   cod_agencia = v_ag
                    and   trim(leading 0 from num_cc_cartao) = trim(leading 0 from v_cc_limpo);
                
                
                    IF (v_contador = 0)  THEN -- Exclusão pedida pelo banco não esta consistente com a Base                                  
                        UTL_FILE.put_line (slog, 'ERRO: Cliente do arquivo esta com forma de pagamento diferente da base de dados!' || vcont_registro_lido);
                        UTL_FILE.put_line (slog, 'ERRO: Cliente do arquivo - External_id: '||v_external_id||' agencia: '|| v_ag || ' num_cc: '|| v_cc_limpo ||' v_cc: '|| v_cc || ' registro:'|| vcont_registro_lido);                                        
                    END IF; 
                    
                    IF (v_contador > 0)  THEN 
                        UPDATE gvt_dacc_gerencia_met_pgto
                           SET dt_cadastro = SYSDATE
                              ,old_pay_method = pay_method
                              ,old_cod_agente_arrecadador = cod_agente_arrecadador
                              ,old_cod_agencia = cod_agencia
                              ,old_num_cc_cartao = num_cc_cartao
                              ,pay_method = 1
                              ,cod_agente_arrecadador = NULL
                              ,cod_agencia = NULL
                              ,num_cc_cartao = NULL
                              ,titular_cartao = NULL
                              ,dt_expiracao_cartao = NULL
                              ,status_cadastramento = 1
                              ,quem = 'BCO'
                         WHERE external_id = v_external_id
                           AND PAY_METHOD = 3
                           AND cod_agencia = v_ag
                           AND trim(leading 0 from num_cc_cartao) = trim(leading 0 from v_cc_limpo); --- alterado por Fabricio em 14/04/2011 para manter as condicoes da validacao acima
                           -- AND num_cc_cartao = v_cc_limpo; --Restricao para não excluir CCard quando receber exclusao do banco
        
                        UPDATE payment_profile
                           SET pay_method = 1
                         WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);
    
                        vcont_registro_gravado    := vcont_registro_gravado + 1;
                    END IF;
                      -- Fim alteração
                END IF;    
            END IF;

-----------------------------------------------------------------------------
            IF (v_status = 3) THEN   -- 3=Pendente
              IF (v_tipo_cad = '2') THEN   --Inclusao
                UPDATE gvt_dacc_gerencia_met_pgto
                   SET dt_cadastro = SYSDATE
                      ,old_pay_method = pay_method
                      ,old_cod_agente_arrecadador = cod_agente_arrecadador
                      ,old_cod_agencia = cod_agencia
                      ,old_num_cc_cartao = num_cc_cartao
                      ,pay_method = 3
                      ,cod_agente_arrecadador = v_cod_banco
                      ,cod_agencia = v_ag
                      ,num_cc_cartao = v_cc_limpo
                      ,titular_cartao = NULL
                      ,dt_expiracao_cartao = NULL
                      ,status_cadastramento = 1
                      ,quem = 'BCO'
                 WHERE external_id = v_external_id;

                UPDATE gvt_dacc_gerencia_fila_eventos
                   SET status_evento = 1
                      ,   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                       origem = 'BCO'
                 WHERE external_id = v_external_id AND status_evento IN (0, 9);

                UPDATE payment_profile
                   SET pay_method = 3
                      ,cust_bank_sort_code = v_ag
                      ,ownr_lname  = v_cc
                      ,cust_bank_acc_num = TRIM (v_external_id)
                      ,clearing_house_id = TRIM (v_cod_banco)
                 WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);

              vcont_registro_gravado    := vcont_registro_gravado + 1;
              END IF;
                            
              IF (v_tipo_cad = '1') THEN   --Exclusao
                  -- Alteração: Luciano X. da Veiga 
                    -- Verificando se a exclusão pedida esta de acordo com a Base
                    select count(*) 
                    into v_contador
                    from gvt_dacc_gerencia_met_pgto
                    where pay_method = 3
                    and   external_id = v_external_id
                    and   cod_agencia = v_ag
                    and   trim(leading 0 from num_cc_cartao) = trim(leading 0 from v_cc_limpo);
                
                
                    IF (v_contador = 0)  THEN -- Exclusão pedida pelo banco não esta consistente com a Base                                  
                        UTL_FILE.put_line (slog, 'ERRO: Cliente do arquivo esta com forma de pagamento diferente da base de dados!' || vcont_registro_lido);
                        UTL_FILE.put_line (slog, 'ERRO: Cliente do arquivo - External_id: '||v_external_id||' agencia: '|| v_ag || ' num_cc: '|| v_cc_limpo || ' registro:'|| vcont_registro_lido);                                        
                    END IF; 
                    
                    IF (v_contador > 0)  THEN                   
                    BEGIN
                      --Pego o pay_method pra qual ele esta mudando
                      SELECT pay_method
                        INTO v_pay_method
                        FROM gvt_dacc_gerencia_met_pgto
                       WHERE external_id = v_external_id;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        --RFC 313127
                        /*v_log_full      :=
                          v_log_full                                  ||
                          ' ### ERROR ###'                            ||
                          CHR (10)                                    ||
                          ' Nao foi possivel carregar a Linha.: '     ||
                          vcount                                      ||
                          CHR (10)                                    ||
                          ' Registro REJEITADO.:'                     ||
                          CHR (10)                                    ||
                          ' '                                         ||
                          v_registro_full                             ||
                          CHR (10)                                    ||
                          ' '                                         ||
                          'Motivo B.: Nao Encontrou o OLD_PAY_METHOD' ||
                          CHR (10)                                    ||
                          ' ####'                                     ||
                          CHR (10);*/
                        v_pay_method    := 0;   --Cliente sem OLD_PAY_METHOD
                    END;
    
                    IF (v_pay_method = 3) THEN   --DACC
                      UPDATE gvt_dacc_gerencia_met_pgto
                         SET dt_cadastro = SYSDATE
                            ,old_pay_method = pay_method
                            ,old_cod_agente_arrecadador = cod_agente_arrecadador
                            ,old_cod_agencia = cod_agencia
                            ,old_num_cc_cartao = num_cc_cartao
                            ,pay_method = 1
                            ,cod_agente_arrecadador = NULL
                            ,cod_agencia = NULL
                            ,num_cc_cartao = NULL
                            ,titular_cartao = NULL
                            ,dt_expiracao_cartao = NULL
                            ,status_cadastramento = 1
                            ,quem = 'BCO'
                       WHERE external_id = v_external_id
                           AND PAY_METHOD = 3
                           AND cod_agencia = v_ag
                           AND trim(leading 0 from num_cc_cartao) = trim(leading 0 from v_cc_limpo); --Restricao para não excluir CCard quando receber exclusao do banco
    
                      UPDATE gvt_dacc_gerencia_fila_eventos
                         SET status_evento = 1
                            ,   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                             origem = 'BCO'
                       WHERE external_id = v_external_id AND status_evento IN (0, 9);
    
                      UPDATE payment_profile
                         SET pay_method = 1
                       WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);

                      vcont_registro_gravado    := vcont_registro_gravado + 1;
                    END IF; -- Fim Alteração - Verifica exclusão
                END IF;
              END IF;
            END IF;
-----------------------------------------------------------------------------
          ELSE   --Cliente não cadastrado (v_achou_BU = 0)
            IF (v_tipo_cad = '2') THEN   -- Inclusao
              INSERT INTO gvt_dacc_gerencia_met_pgto
                          (external_id
                          ,dt_cadastro
                          ,old_pay_method
                          ,old_cod_agente_arrecadador
                          ,old_cod_agencia
                          ,old_num_cc_cartao
                          ,pay_method
                          ,cod_agente_arrecadador
                          ,cod_agencia
                          ,num_cc_cartao
                          ,titular_cartao
                          ,dt_expiracao_cartao
                          ,status_cadastramento
                          ,quem
                          )
                   VALUES (v_external_id
                          ,SYSDATE
                          ,1
                          ,   --se o cara nao esta cadastrado ele é necessriamente LB
                           NULL
                          ,NULL
                          ,NULL
                          ,3
                          ,v_cod_banco
                          ,v_ag
                          ,v_cc_limpo
                          ,NULL
                          ,NULL
                          ,1
                          ,'BCO'
                          );

              UPDATE payment_profile
                 SET pay_method = 3
                    ,cust_bank_sort_code = v_ag
                    ,ownr_lname  = v_cc
                    ,cust_bank_acc_num = TRIM (v_external_id)
                    ,clearing_house_id = TRIM (v_cod_banco)
               WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);

              vcont_registro_gravado    := vcont_registro_gravado + 1;
            END IF;
          --IF (v_tipo_cad = '1') THEN -- Exclusao(NUNCA VAI EXISTIR)

          --END IF;
          END IF;   --Cliente não cadastrado (v_achou_BU = 0 ou 1)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        END IF;   --Cliente CADASTRADO no ARBOR
      END IF;   -- Registro B

-----------------------------------------------
-----------------------------------------------
-- RETORNO DO CADASTRAMENTO/EXCLUSAO VIA GVT --
-----------------------------------------------
-----------------------------------------------
      IF (v_1o_caracter = 'F') THEN   --'F' Zerado, Retorno do envio da GVT
        IF (SUBSTR (v_registro_full, 53, 15) = '000000000000000') THEN
          vcont_registro_lido    := vcont_registro_lido + 1;
          --Pegar os campos a serem utilizados
          v_external_id          := TRIM (SUBSTR (v_registro_full, 2, 25) );
          --v_external_id := RPAD( v_external_id , 48 , ' ' );
          v_ag                   := SUBSTR (v_registro_full, 27, 4);
          v_cc                   := SUBSTR (v_registro_full, 31, 14);
          v_tipo_cad             := SUBSTR (v_registro_full, 150, 1);
          v_cod_retorno          := SUBSTR (v_registro_full, 68, 2);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------
-- Verifico se ele esta na GVT
------------------------------------------------------------------
          BEGIN
            SELECT account_no
              INTO v_account_no
              FROM customer_id_acct_map
             WHERE external_id = v_external_id
             and inactive_date is null; --RFC 342740

            v_achou_arbor    := 1;   --Achou no ARBOR
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              --RFC 313127
              /*v_log_full       :=
                v_log_full                                        ||
                ' ### ERROR ###'                                  ||
                CHR (10)                                          ||
                ' Nao foi possivel carregar a Linha.: '           ||
                vcount                                            ||
                CHR (10)                                          ||
                ' Registro REJEITADO.:'                           ||
                CHR (10)                                          ||
                ' '                                               ||
                v_registro_full                                   ||
                CHR (10)                                          ||
                ' '                                               ||
                'Motivo F.: Nao Encontrou o EXTERNAL_ID no ARBOR' ||
                CHR (10)                                          ||
                ' ####'                                           ||
                CHR (10);*/
              v_achou_arbor    := 0;   --Cliente não cadastrado no ARBOR
          END;

          IF (v_achou_arbor = 1) THEN   -- Cliente cadastrado no ARBOR
------------------------------------------------------------------
-- Verifico se cliente esta na BASE UNICA, se sim pego o status dele
------------------------------------------------------------------
            BEGIN
              SELECT status_cadastramento
                INTO v_status
                FROM gvt_dacc_gerencia_met_pgto
               WHERE external_id = v_external_id;

              v_achou_bu    := 1;   --Achou na Base Unica
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                --RFC 313127
                /*v_log_full    :=
                  v_log_full                                        ||
                  ' ### ERROR ###'                                  ||
                  CHR (10)                                          ||
                  ' Nao foi possivel carregar a Linha.: '           ||
                  vcount                                            ||
                  CHR (10)                                          ||
                  ' Registro REJEITADO.:'                           ||
                  CHR (10)                                          ||
                  ' '                                               ||
                  v_registro_full                                   ||
                  CHR (10)                                          ||
                  ' '                                               ||
                  'Motivo F.: CLiente nao cadastrado na BASE UNICA' ||
                  CHR (10)                                          ||
                  ' ####'                                           ||
                  CHR (10);*/
                v_achou_bu    := 0;   --Cliente não cadastrado na BASE UNICA
            END;

            IF (v_achou_bu = 1) THEN   --CLiente esta na BASE UNICA (Se o cliente nao estiver na base unica eh poque eh uma EXCLUSAO de DACC)
              IF (v_cod_retorno = '99' OR v_cod_retorno = '96' OR v_cod_retorno = '00') THEN   --SUCESSO da Autalizacao no BANCO
                -- Conto quantos eventos o cara tem ainda diferentes de JA PROCESS..
                BEGIN
                  SELECT COUNT (*)
                    INTO v_qtde_evento
                    FROM gvt_dacc_gerencia_fila_eventos
                   WHERE external_id = v_external_id
                     AND status_evento <> 1   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND origem IS NULL;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    --RFC 313127
                    /*v_log_full       :=
                      v_log_full                                           ||
                      ' ### ERROR ###'                                     ||
                      CHR (10)                                             ||
                      ' Nao foi possivel carregar a Linha.: '              ||
                      vcount                                               ||
                      CHR (10)                                             ||
                      ' Registro REJEITADO.:'                              ||
                      CHR (10)                                             ||
                      ' '                                                  ||
                      v_registro_full                                      ||
                      CHR (10)                                             ||
                      ' '                                                  ||
                      'Motivo F.: CLiente nao TEM EVENTO <> de JA PROCESS' ||
                      CHR (10)                                             ||
                      ' ####'                                              ||
                      CHR (10);*/
                    v_qtde_evento    := 0;   --Cliente não tem evento
                END;

                IF (v_qtde_evento = 1) THEN   -- DACC->FAT ou FAT->DACC
-------------------------------------------
-- MUDANCA DE STATUS_EVENTO de 3 para 1 ---
-------------------------------------------
                  UPDATE gvt_dacc_gerencia_met_pgto
                     SET status_cadastramento = 1
                   WHERE external_id = v_external_id;

-------------------------------------------
-- MUDANCA DE STATUS_EVENTO de 9 para 1 ---
-------------------------------------------
                  UPDATE gvt_dacc_gerencia_fila_eventos
                     SET status_evento = 1   --de "Pendente" para "Ja Processado"
                   WHERE external_id = v_external_id
                     AND sequencia =
                           (SELECT MIN (sequencia)
                              FROM gvt_dacc_gerencia_fila_eventos
                             WHERE status_evento = 9   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                               AND aguarda_retorno = 'S'
                               AND external_id = v_external_id)
                     AND status_evento = 9   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND aguarda_retorno = 'S';

---------------------------------------------
                  IF (v_tipo_cad = '0' OR v_tipo_cad = '5' ) THEN   --Inclusao
                    UPDATE payment_profile
                       SET pay_method = 3
                          ,cust_bank_sort_code = v_ag
                          ,ownr_lname  = v_cc
                          ,cust_bank_acc_num = TRIM (v_external_id)
                          ,clearing_house_id = TRIM (v_cod_banco)
                     WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);
                  END IF;

                  IF (v_tipo_cad = '1') THEN   -- Exclusao
                    UPDATE payment_profile
                       SET pay_method = 1
                     WHERE account_no = v_account_no
                       AND pay_method <> 2;
                  END IF;

                  vcont_registro_gravado    := vcont_registro_gravado + 1;
                END IF;

                IF (v_qtde_evento > 1) THEN   --DACC->DACC ou DACC->CC ou CC->DACC
-------------------------------------------
-- MUDANCA DE STATUS_EVENTO de 9 para 1 ---
-------------------------------------------
                  UPDATE gvt_dacc_gerencia_fila_eventos
                     SET status_evento = 1   --de "Pendente" para "Processado"
                   WHERE external_id = v_external_id
                     AND sequencia =
                           (SELECT MIN (sequencia)
                              FROM gvt_dacc_gerencia_fila_eventos
                             WHERE status_evento = 9   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                               AND aguarda_retorno = 'S'
                               AND external_id = v_external_id)
                     AND status_evento = 9   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                     AND aguarda_retorno = 'S';

---------------------------------------------
                  vcont_registro_gravado    := vcont_registro_gravado + 1;
                END IF;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
              ELSE   -- Erro na Atualizacao no BANCO (Vai pra FATURA !!!) - Tanto faz INCLUSAO OU EXCLUSAO !!
                UPDATE gvt_dacc_gerencia_met_pgto
                   SET dt_cadastro = SYSDATE
                      ,old_pay_method = pay_method
                      ,old_cod_agente_arrecadador = cod_agente_arrecadador
                      ,old_cod_agencia = cod_agencia
                      ,old_num_cc_cartao = num_cc_cartao
                      ,pay_method = 1
                      ,cod_agente_arrecadador = NULL
                      ,cod_agencia = NULL
                      ,num_cc_cartao = NULL
                      ,titular_cartao = NULL
                      ,dt_expiracao_cartao = NULL
                      ,ultimo_cod_retorno = v_cod_retorno
                      ,qtde_retorno_nok = qtde_retorno_nok + 1
                      ,dt_ultimo_retorno = SYSDATE
                      ,status_cadastramento = 1
                      ,quem = 'BCO'
                      ,tipo_erro = v_motivo
                 WHERE external_id = v_external_id;

                UPDATE gvt_dacc_gerencia_fila_eventos
                   SET status_evento = 1
                      ,   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                       origem = 'BCO'
                 WHERE external_id = v_external_id AND status_evento IN (0, 9);

                UPDATE payment_profile
                   SET pay_method = 1
                      ,clearing_house_id = null
                      ,cust_bank_sort_code = null
                      ,cust_bank_acc_num = null
                      ,ownr_lname  = null
                 WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);

                if v_cod_retorno = '01' then
                    v_motivo := 'Débito não efetuado - Insuficiência de fundos';
                elsif v_cod_retorno = '02' then
                    v_motivo := 'Débito não efetuado - Conta corrente não cadastrada';
                elsif v_cod_retorno = '04' then
                    v_motivo := 'Débito não efetuado - Outras restrições';
                elsif v_cod_retorno = '10' then
                    v_motivo := 'Débito não efetuado - Agência em regime de encerramento';
                elsif v_cod_retorno = '12' then
                    v_motivo := 'Débito não efetuado - Valor inválido';
                elsif v_cod_retorno = '13' then
                    v_motivo := 'Débito não efetuado - Data de lançamento inválida';
                elsif v_cod_retorno = '14' then
                    v_motivo := 'Débito não efetuado - Agência inválida';
                elsif v_cod_retorno = '15' then
                    v_motivo := 'Débito não efetuado - DAC da conta corrente inválido';
                elsif v_cod_retorno = '18' then
                    v_motivo := 'Débito não efetuado - Data deb anterior do processamento';
                elsif v_cod_retorno = '30' then
                    v_motivo := 'Débito não efetuado - Sem contrato de débito automático';
                elsif v_cod_retorno = '97' then
                    v_motivo := 'Cancelamento - Não encontrado';
                elsif v_cod_retorno = '98' then
                    v_motivo := 'Cancelamento - Não efetuado, fora de tempo hábil';
                else
                    v_motivo := 'Motivo não encontrado no layout Febraban';
                end if;

                --Relatório de DACC rejeitados
                if v_count_rel = 0 then
                       begin
                        srel := utl_file.fopen(v_caminho_rel, v_nome_arquivo_rel,'W');
                    exception
                        when utl_file.invalid_path then
                             dbms_output.put_line('Diretório de log incorreto.');
                             dbms_output.put_line('SQLCODE: '||sqlerrm);
                        when utl_file.invalid_mode then
                               dbms_output.put_line('Modo de abertura do arquivo de log incorreto.');
                             dbms_output.put_line('SQLCODE: '||sqlerrm);
                        when utl_file.invalid_operation then
                             dbms_output.put_line('Arquivo de log não pode ser aberto.');
                             dbms_output.put_line('SQLCODE: '||sqlerrm);
                    end;
                    utl_file.put_line(srel, 'Cliente;Banco;Agência;Conta Corrente;Motivo;');
                    utl_file.put_line(srel, trim(v_external_id) || ';' || NLS_INITCAP(trim(v_nome_banco)) || ';' || trim(v_ag) || ';' || trim(v_cc) || ';' || NLS_INITCAP(trim(v_motivo)) || ';');
                    v_count_rel := 1;
                else
                    utl_file.put_line(srel, trim(v_external_id) || ';' || NLS_INITCAP(trim(v_nome_banco)) || ';' || trim(v_ag) || ';' || trim(v_cc) || ';' || NLS_INITCAP(trim(v_motivo)) || ';');
                    v_count_rel := v_count_rel + 1;
                end if;
              END IF;   -- SUCESSO da Autalizacao no BANCO
            END IF;   -- Cliente cadastrado na BASE UNICA
          END IF;   -- Cliente cadastrado na GVT
        END IF;
      END IF;
      
      --*********************************************************************************************************** Registro do tipo 'H'

      IF (v_1o_caracter = 'H') THEN   --Erro de processamento

        vcont_registro_lido    := vcont_registro_lido + 1;
        --Pegar os campos a serem utilizados
        v_external_id  := SUBSTR(v_registro_full, 45, 12);

        if trim(v_external_id) is null then
            v_external_id  := SUBSTR(v_registro_full, 2, 12);
        end if;

        v_ag           := SUBSTR (v_registro_full, 27, 4);
        v_cc           := TRIM(SUBSTR (v_registro_full, 31, 14));
        v_motivo       := TRIM(SUBSTR(v_registro_full, 70, 58));

        ------------------------------------------------------------------
        ------------------------------------------------------------------
        -- Verifico se ele esta na GVT
        ------------------------------------------------------------------
        BEGIN
          SELECT account_no
            INTO v_account_no
            FROM customer_id_acct_map
           WHERE external_id = v_external_id
           and inactive_date is null; --RFC 342740

          v_achou_arbor    := 1;   --Achou no ARBOR
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --RFC 313127
            /*v_log_full       :=
              v_log_full                                        ||
              ' ### ERROR ###'                                  ||
              CHR (10)                                          ||
              ' Nao foi possivel carregar a Linha.: '           ||
              vcount                                            ||
              CHR (10)                                          ||
              ' Registro REJEITADO.:'                           ||
              CHR (10)                                          ||
              ' '                                               ||
              v_registro_full                                   ||
              CHR (10)                                          ||
              ' '                                               ||
              'Motivo F.: Nao Encontrou o EXTERNAL_ID no ARBOR' ||
              CHR (10)                                          ||
              ' ####'                                           ||
              CHR (10);*/
            v_achou_arbor    := 0;   --Cliente não cadastrado no ARBOR
        END;

        IF (v_achou_arbor = 1) THEN   -- Cliente cadastrado no ARBOR
          ------------------------------------------------------------------
          -- Verifico se cliente esta na BASE UNICA, se sim pego o status dele
          ------------------------------------------------------------------
          BEGIN
            SELECT status_cadastramento
              INTO v_status
              FROM gvt_dacc_gerencia_met_pgto
             WHERE external_id = v_external_id;

            v_achou_bu    := 1;   --Achou na Base Unica
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
            --RFC 313127
              /*v_log_full    :=
                v_log_full                                        ||
                ' ### ERROR ###'                                  ||
                CHR (10)                                          ||
                ' Nao foi possivel carregar a Linha.: '           ||
                vcount                                            ||
                CHR (10)                                          ||
                ' Registro REJEITADO.:'                           ||
                CHR (10)                                          ||
                ' '                                               ||
                v_registro_full                                   ||
                CHR (10)                                          ||
                ' '                                               ||
                'Motivo F.: CLiente nao cadastrado na BASE UNICA' ||
                CHR (10)                                          ||
                ' ####'                                           ||
                CHR (10);*/
              v_achou_bu    := 0;   --Cliente não cadastrado na BASE UNICA
          END;
          -- Erro na Atualizacao no BANCO (Vai pra FATURA !!!) - Tanto faz INCLUSAO OU EXCLUSAO !!
          UPDATE gvt_dacc_gerencia_met_pgto
             SET dt_cadastro = SYSDATE
                ,old_pay_method = pay_method
                ,old_cod_agente_arrecadador = cod_agente_arrecadador
                ,old_cod_agencia = cod_agencia
                ,old_num_cc_cartao = num_cc_cartao
                ,pay_method = 1
                ,cod_agente_arrecadador = NULL
                ,cod_agencia = NULL
                ,num_cc_cartao = NULL
                ,titular_cartao = NULL
                ,dt_expiracao_cartao = NULL
                ,ultimo_cod_retorno = v_cod_retorno
                ,qtde_retorno_nok = qtde_retorno_nok + 1
                ,dt_ultimo_retorno = SYSDATE
                ,status_cadastramento = 1
                ,quem = 'BCO'
                ,tipo_erro = v_motivo
           WHERE external_id = v_external_id;

          UPDATE gvt_dacc_gerencia_fila_eventos
             SET status_evento = 1,   --0 = Processar / 1 = Ja Processado / 9 = Pendente
                 origem = 'BCO'
           WHERE external_id = v_external_id AND status_evento IN (0, 9);

          UPDATE payment_profile
             SET pay_method = 1
                ,clearing_house_id = null
                ,cust_bank_sort_code = null
                ,cust_bank_acc_num = null
                ,ownr_lname  = null
           WHERE profile_id = (select CMF.PAYMENT_PROFILE_ID from cmf  where account_no = v_account_no);

           --Relatório de DACC rejeitados
           if v_count_rel = 0 then
                   begin
                    srel := utl_file.fopen(v_caminho_rel, v_nome_arquivo_rel,'W');
                exception
                    when utl_file.invalid_path then
                         dbms_output.put_line('Diretório de log incorreto.');
                         dbms_output.put_line('SQLCODE: '||sqlerrm);
                    when utl_file.invalid_mode then
                           dbms_output.put_line('Modo de abertura do arquivo de log incorreto.');
                         dbms_output.put_line('SQLCODE: '||sqlerrm);
                    when utl_file.invalid_operation then
                         dbms_output.put_line('Arquivo de log não pode ser aberto.');
                         dbms_output.put_line('SQLCODE: '||sqlerrm);
                end;
                utl_file.put_line(srel, 'Cliente;Banco;Agência;Conta Corrente;Motivo;');
                utl_file.put_line(srel, trim(v_external_id) || ';' || NLS_INITCAP(trim(v_nome_banco)) || ';' || trim(v_ag) || ';' || trim(v_cc) || ';' || NLS_INITCAP(trim(v_motivo)) || ';');
                v_count_rel := 1;
           else
                utl_file.put_line(srel, trim(v_external_id) || ';' || NLS_INITCAP(trim(v_nome_banco)) || ';' || trim(v_ag) || ';' || trim(v_cc) || ';' || NLS_INITCAP(trim(v_motivo)) || ';');
                v_count_rel := v_count_rel + 1;
           end if;
          END IF;   -- Cliente cadastrado na GVT
      END IF; 


-- ************************************************************************************************************************* Registro J
      if (v_1o_caracter = 'J') then   --confirmacao de processamento

           vcont_registro_lido    := vcont_registro_lido + 1;

           --Pegar os campos a serem utilizados
           v_nsa := substr(v_registro_full, 2, 6);
           v_data_geracao := substr(v_registro_full, 8, 8);
           v_data_processamento := substr(v_registro_full, 39, 8);

           begin
               update arborgvt_payments.gvt_dacc_controle_nsa
               set received_dt = to_date(v_data_processamento,'YYYYMMDD')
               where clearing_house_id = v_cod_banco
               and nsa = v_nsa;
           exception
               when others then
                   insert into arborgvt_payments.gvt_dacc_controle_nsa (clearing_house_id, nsa, sent_dt, received_dt) values (v_cod_banco, v_nsa, v_data_geracao, v_data_processamento);
                   commit;
           end;
           commit;
           
      end if;


    ELSE   -- Tamanho INVALIDO do Registro
      v_log_full    :=
        v_log_full                                     ||
        ' ### ERROR ###'                               ||
        CHR (10)                                       ||
        ' Nao foi possivel carregar a Linha.: '        ||
        vcount                                         ||
        CHR (10)                                       ||
        ' Registro REJEITADO.:'                        ||
        CHR (10)                                       ||
        ' '                                            ||
        v_registro_full                                ||
        CHR (10)                                       ||
        ' '                                            ||
        'Motivo GERAL.: Tamanho Invalido do Registro.' ||
        CHR (10)                                       ||
        ' ####'                                        ||
        CHR (10);
    END IF;

    EXIT WHEN v_qtd_linhas = vcount;
  END LOOP;

  COMMIT;   --Commit fora do LOOP..para que se possa REPROCESSAR o arquivo todo(ROLBACK Automatico)...em caso de erro ORACLE.
  UTL_FILE.fclose (etlf);
  UTL_FILE.put_line (slog, 'Qtde de registros LIDOS..........:' || vcont_registro_lido);
  UTL_FILE.put_line (slog, 'Qtde de registros GRAVADOS.......:' || vcont_registro_gravado);
  UTL_FILE.put_line (slog, v_log_full);
  UTL_FILE.put_line (slog, ' ');
  UTL_FILE.fclose(srel);
  UTL_FILE.fclose(slog);
END;
/
EXIT;
