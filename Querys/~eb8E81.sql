/* Formatted on 2010/04/20 19:47 (Formatter Plus v4.8.6) */
--******************************************************************************
--* NOME............: pl6000.sql                                                                                  
--* DESCRICAO.......: 
--* AUTOR...........: Ranieri Mocelin
--* DATA CRIACAO....: 
--*
--******************************************************************************

SET verify           off;
SET serverout        on;
SET feed             off;
SET space            0;
SET pagesize         0;
SET line             500;
SET wrap             on;
SET heading          off;


DECLARE
   wdirspool_in                  VARCHAR2 (60) := '&1';
   warqspool_in                  VARCHAR2 (60) := 'LISTA_ARQS_PAYM_BL6000.txt';
   harqspool_in                  UTL_FILE.file_type;   -- handle do arq. de spool
--*
   wdirspool_in2                 VARCHAR2 (60) := NULL;
   warqspool_in2                 VARCHAR2 (60) := NULL;
   harqspool_in2                 UTL_FILE.file_type;   -- handle do arq. de spool
--**
   wdirspool_out_c1              VARCHAR2 (60) := NULL;   --'2';
   warqspool_out_c1              VARCHAR2 (60) := 'ARQ_TEMP_BL6000_C1.TXT';
   harqspool_out_c1              UTL_FILE.file_type;   -- handle do arq. de spool
--*
   wdirspool_out_c2              VARCHAR2 (60) := NULL;   -- '3';
   warqspool_out_c2              VARCHAR2 (60) := 'ARQ_TEMP_BL6000_C2.TXT';
   harqspool_out_c2              UTL_FILE.file_type;   -- handle do arq. de spool
--*
--**
   wdirspool_out_c1_err          VARCHAR2 (60) := NULL;   --'2';
   warqspool_out_c1_err          VARCHAR2 (60) := 'ARQ_TEMP_BL6000_ERRO_C1.TXT';
   harqspool_out_c1_err          UTL_FILE.file_type;   -- handle do arq. de spool
--*
   wdirspool_out_c2_err          VARCHAR2 (60) := NULL;   -- '3';
   warqspool_out_c2_err          VARCHAR2 (60) := 'ARQ_TEMP_BL6000_ERRO_C2.TXT';
   harqspool_out_c2_err          UTL_FILE.file_type;   -- handle do arq. de spool
--*
   v_executa_atu                 VARCHAR2 (30) := NULL;   -- controle erro: nome proced em execucao
   v_executa_ant                 VARCHAR2 (30) := NULL;   -- controle erro: nome proced em execucao
   erro_geral                    EXCEPTION;
   sem_movimento                 EXCEPTION;
   erro_despesa                  EXCEPTION;
   v_nome_programa               gvt_exec_arg.nome_programa%TYPE := 'PL6000';
   v_data_sistema                DATE;
   v_data_ini                    DATE;
   v_data_fim                    DATE;
   v_proxima_execucao            VARCHAR2 (020);
   v_aux_data                    gvt_exec_arg.desc_parametro%TYPE;
   v_aux_num_execucao            gvt_exec_arg.num_execucao%TYPE;
   v_aux_tem_execucao            BOOLEAN;
   v_sql                         VARCHAR2 (5000);
/*  */
   v_linha                       VARCHAR2 (5000);
   v_qtd_lidos                   NUMBER := 0;
   v_tipo_arquivo                VARCHAR2 (010);
   v_cab_registro                VARCHAR2 (37);
   v_registro                    VARCHAR2 (360);
   v_registro_ok_err             VARCHAR2 (04);
   v_server_id                   server_definition.server_id%TYPE;
   v_external_id                 external_id_acct_map.external_id%TYPE;
   v_qtd_d_lidos                 NUMBER := 0;
   v_qtd_server_id_3             NUMBER := 0;
   v_qtd_server_id_4             NUMBER := 0;
   v_qtd_server_id_3_err         NUMBER := 0;
   v_qtd_server_id_4_err         NUMBER := 0;
   v_qtd_server_id_x             NUMBER := 0;
   v_qtd_sem_server              NUMBER := 0;

/* */
   TYPE cursor_type IS REF CURSOR;

   c_cursor                      cursor_type;
/* *
-- COMENTARIO
--------------------------------------------------------------------------------
   FUNCTION converte (
      v_vlr_ent NUMBER
   )
      RETURN VARCHAR2
   IS
      v_vlr_conv                    VARCHAR2 (16);
   BEGIN
      SELECT REPLACE (REPLACE (REPLACE (TO_CHAR (v_vlr_ent / 100, '9999,999,990.00'), ',', '*'), '.', ','), '*', '.')
        INTO v_vlr_conv
        FROM DUAL;

      RETURN v_vlr_conv;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('FUNCAO INVALIDA ');
   END;

--------------------------------------------------------------------------------
--******************************************************************************
--******************************************************************************/
--------------------------------------------------------------------------------
BEGIN
   v_executa_atu              := 'MAIN';
   v_data_sistema             := SYSDATE;
   DBMS_OUTPUT.put_line ('INICIO = ' || TO_CHAR (v_data_sistema, 'YYYYMMDDHH24MISS'));
--   v_total_registros          := 0;
/**/
--*******************************************************************************
--*******************************************************************************
--*******************************************************************************
--   DBMS_OUTPUT.put_line ('INICIO  OPEN  ');
   v_executa_ant              := v_executa_atu;
   v_executa_atu              := SUBSTR ('OPEN ' || warqspool_in, 1, 30);
   v_sql                      :=
         'SELECT si.* '
      || '  FROM (SELECT   sd.server_id '
      || '            FROM server_definition sd, '
      || '                 external_id_acct_map eiam '
      || '           WHERE sd.server_id = eiam.server_id '
      || '             AND eiam.external_id = :EXTERNAL_ID '
      || '             AND eiam.external_id_type = 1 '
      || '        ORDER BY eiam.inactive_date DESC) si '
      || ' WHERE ROWNUM = 1';
/* */
   wdirspool_out_c1           := wdirspool_in;
   warqspool_out_c1           := 'ARQ_TEMP_BL6000_c1.TXT';
--   DBMS_OUTPUT.put_line ('VAI ABRIR  = ' || CHR (39) || wdirspool_out_c1 || '/' || warqspool_out_c1 || CHR (39));
   harqspool_out_c1           := UTL_FILE.fopen (wdirspool_out_c1, warqspool_out_c1, 'w');
   DBMS_OUTPUT.put_line ('ABRIU ARQUIVO = ' || warqspool_out_c1);
--
/* */
   wdirspool_out_c1_err       := wdirspool_in;
   warqspool_out_c1_err       := 'ARQ_TEMP_BL6000_ERRO_c1.TXT';
--   DBMS_OUTPUT.put_line ('VAI ABRIR  = ' || CHR (39) || wdirspool_out_c1_err || '/' || warqspool_out_c1_err || CHR (39));
   harqspool_out_c1_err       := UTL_FILE.fopen (wdirspool_out_c1_err, warqspool_out_c1_err, 'w');
   DBMS_OUTPUT.put_line ('ABRIU ARQUIVO = ' || warqspool_out_c1_err);
/* */
   wdirspool_out_c2           := wdirspool_in;
   warqspool_out_c2           := 'ARQ_TEMP_BL6000_c2.TXT';
--   DBMS_OUTPUT.put_line ('VAI ABRIR  = ' || CHR (39) || wdirspool_out_c2 || '/' || warqspool_out_c2 || CHR (39));
   harqspool_out_c2           := UTL_FILE.fopen (wdirspool_out_c2, warqspool_out_c2, 'w');
   DBMS_OUTPUT.put_line ('ABRIU ARQUIVO = ' || warqspool_out_c2);
--
/* */
   wdirspool_out_c2_err       := wdirspool_in;
   warqspool_out_c2_err       := 'ARQ_TEMP_BL6000_ERRO_c2.TXT';
--   DBMS_OUTPUT.put_line ('VAI ABRIR  = ' || CHR (39) || wdirspool_out_c2_err || '/' || warqspool_out_c2_err || CHR (39));
   harqspool_out_c2_err       := UTL_FILE.fopen (wdirspool_out_c2_err, warqspool_out_c2_err, 'w');
   DBMS_OUTPUT.put_line ('ABRIU ARQUIVO = ' || warqspool_out_c2_err);

/* */
   BEGIN
      warqspool_in               := 'LISTA_ARQS_PAYM_BL6000.txt';
      harqspool_in               := UTL_FILE.fopen (wdirspool_in, warqspool_in, 'r');
      DBMS_OUTPUT.put_line (' ABRIU lista = ' || CHR (39) || warqspool_in || CHR (39));

      LOOP
         UTL_FILE.get_line (harqspool_in, v_linha);
         v_tipo_arquivo             := SUBSTR (v_linha, 11, 2);

--         DBMS_OUTPUT.put_line ('v_tipo_arquivo = ' || CHR (39) || v_tipo_arquivo || CHR (39));
         BEGIN
            warqspool_in2              := v_linha;
            wdirspool_in2              := wdirspool_in;
            harqspool_in2              := UTL_FILE.fopen (wdirspool_in2, warqspool_in2, 'r');
            DBMS_OUTPUT.put_line (' ABRIU O ARQUIVO = ' || CHR (39) || warqspool_in2 || CHR (39));
            v_cab_registro             := NULL;
            v_registro_ok_err          := '    ';
            v_qtd_lidos                := 0;
            v_external_id              := NULL;

            LOOP
               UTL_FILE.get_line (harqspool_in2, v_linha);
--               DBMS_OUTPUT.put_line ('v_linha = ' || CHR (39) || v_linha || CHR (39));
               v_registro                 := NULL;
               v_qtd_lidos                := v_qtd_lidos + 1;

               IF v_tipo_arquivo = 'DE'
               THEN
                  IF SUBSTR (v_linha, 1, 1) = 'A'
                  THEN
                     v_cab_registro             := SUBSTR (v_linha, 43, 3);
                     v_cab_registro             := v_cab_registro || SUBSTR (v_linha, 46, 20);
                     v_cab_registro             := v_cab_registro || SUBSTR (v_linha, 66, 08);
                     v_cab_registro             := v_cab_registro || SUBSTR (v_linha, 74, 06);
                  ELSIF SUBSTR (v_linha, 1, 1) = 'F'
                  THEN
                     v_registro                 := v_registro || SUBSTR (v_linha, 01, 01);
                     v_registro                 := v_registro || SUBSTR (v_linha, 45, 08);
                     v_registro                 := v_registro || SUBSTR (v_linha, 53, 15);
                     v_registro                 := v_registro || SUBSTR (v_linha, 02, 12);
                     v_external_id              := SUBSTR (v_linha, 02, 12);
                     v_registro                 := v_registro || SUBSTR (v_linha, 72, 10);
                     v_registro                 := v_registro || RPAD (' ', 77, ' ');

                     IF     SUBSTR (v_linha, 68, 02) = '00'
                        AND SUBSTR (v_linha, 53, 15) <> '000000000000000'
                     THEN
                        v_registro_ok_err          := '0OK ';
--                        DBMS_OUTPUT.put_line ('0OK ' || v_cab_registro || v_registro);
                     ELSE
                        v_registro_ok_err          := '9ERR';
--                        DBMS_OUTPUT.put_line ('9ERR ' || v_cab_registro || v_registro);
                     END IF;
                  END IF;
               ELSIF v_tipo_arquivo = 'CO'
               THEN
--                  DBMS_OUTPUT.put_line ('SUBSTR (v_linha, 1, 1) = ' || SUBSTR (v_linha, 1, 1));
                  IF SUBSTR (v_linha, 1, 1) = 'A'
                  THEN
                     v_cab_registro             := SUBSTR (v_linha, 43, 3);
                     v_cab_registro             := v_cab_registro || SUBSTR (v_linha, 46, 20);
                     v_cab_registro             := v_cab_registro || SUBSTR (v_linha, 66, 08);
                     v_cab_registro             := v_cab_registro || SUBSTR (v_linha, 74, 06);
                  ELSIF SUBSTR (v_linha, 1, 1) = 'G'
                  THEN
                     v_registro                 := v_registro || SUBSTR (v_linha, 01, 01);
                     v_registro                 := v_registro || SUBSTR (v_linha, 30, 08);
                     v_registro                 := v_registro || SUBSTR (v_linha, 58, 12);
                     v_external_id              := SUBSTR (v_linha, 58, 12);
                     v_registro                 := v_registro || SUBSTR (v_linha, 70, 10);
                     v_registro                 := v_registro || SUBSTR (v_linha, 22, 08);
                     v_registro                 := v_registro || SUBSTR (v_linha, 82, 12);
                     v_registro                 := v_registro || SUBSTR (v_linha, 94, 07);
                     v_registro                 := v_registro || SUBSTR (v_linha, 101, 08);
                     v_registro                 := v_registro || SUBSTR (v_linha, 109, 08);
                     v_registro                 := v_registro || SUBSTR (v_linha, 117, 01);
                     v_registro                 := v_registro || RPAD (' ', 48, ' ');
                     v_registro_ok_err          := '0OK ';
--                     DBMS_OUTPUT.put_line ('0OK ' || v_cab_registro || v_registro);
                  END IF;
               ELSIF v_tipo_arquivo = 'CA'
               THEN
                  v_cab_registro             := '999';

                  IF SUBSTR (v_linha, 128, 10) = '          '
                  THEN
                     v_cab_registro             := v_registro || SUBSTR (v_linha, 197, 04);
                     v_cab_registro             := v_registro || '      ';
                  ELSE
                     v_cab_registro             := v_registro || SUBSTR (v_linha, 128, 10);
                  END IF;

                  v_cab_registro             := v_registro || '          ';
                  v_cab_registro             := v_registro || '        ';
                  v_cab_registro             := v_registro || '      ';
                  v_registro                 := v_registro || 'C';

                  IF SUBSTR (v_linha, 191, 02) > 60
                  THEN
                     v_registro                 := v_registro || '19';
                  ELSE
                     v_registro                 := v_registro || '20';
                  END IF;

                  v_registro                 := v_registro || SUBSTR (v_linha, 191, 02);
                  v_registro                 := v_registro || SUBSTR (v_linha, 193, 02);
                  v_registro                 := v_registro || SUBSTR (v_linha, 195, 02);
                  v_registro                 := v_registro || SUBSTR (v_linha, 197, 04);
                  v_registro                 := v_registro || '  ';
                  v_registro                 := v_registro || SUBSTR (v_linha, 59, 12);
                  v_external_id              := SUBSTR (v_linha, 59, 12);
                  v_registro                 := v_registro || SUBSTR (v_linha, 186, 10);
                  v_registro                 := v_registro || SUBSTR (v_linha, 15, 20);

                  IF SUBSTR (v_linha, 05, 02) = '00'
                  THEN
                     v_registro_ok_err          := '0OK ';
--                     DBMS_OUTPUT.put_line ('0OK ' || v_cab_registro || v_registro);
                  ELSE
                     v_registro_ok_err          := '9ERR';
--                     DBMS_OUTPUT.put_line ('9ERR' || v_cab_registro || v_registro);
                  END IF;
               END IF;

               IF v_registro IS NOT NULL
               THEN
                  BEGIN
--                     DBMS_OUTPUT.put_line ('v_external_id SQL = ' || CHR (39) || v_external_id || CHR (39));
                     EXECUTE IMMEDIATE v_sql
                                  INTO v_server_id
                                 USING TRIM (v_external_id);

--                     v_server_id                := 4;
--                     DBMS_OUTPUT.put_line ('v_registro_ok_err = ' || CHR (39) || v_registro_ok_err || CHR (39));
                     BEGIN
                        IF v_server_id = 3
                        THEN
                           IF SUBSTR (v_registro_ok_err, 1, 1) = '0'
                           THEN
                              UTL_FILE.put_line (harqspool_out_c1, v_cab_registro || v_registro);
                              UTL_FILE.fflush (harqspool_out_c1);
                              v_qtd_server_id_3          := v_qtd_server_id_3 + 1;
                           ELSE
                              UTL_FILE.put_line (harqspool_out_c1_err, v_cab_registro || v_registro);
                              UTL_FILE.fflush (harqspool_out_c1_err);
                              v_qtd_server_id_3_err      := v_qtd_server_id_3_err + 1;
                           END IF;
                        ELSE
                           IF SUBSTR (v_registro_ok_err, 1, 1) = '0'
                           THEN
                              UTL_FILE.put_line (harqspool_out_c2, v_cab_registro || v_registro);
                              UTL_FILE.fflush (harqspool_out_c2);
                              v_qtd_server_id_4          := v_qtd_server_id_4 + 1;
                           ELSE
                              UTL_FILE.put_line (harqspool_out_c2_err, v_cab_registro || v_registro);
                              UTL_FILE.fflush (harqspool_out_c2_err);
                              v_qtd_server_id_4_err      := v_qtd_server_id_4_err + 1;
                           END IF;
                        END IF;
                     EXCEPTION
                        WHEN UTL_FILE.invalid_mode
                        THEN
                           DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = '
                                                 || v_executa_ant
                                                );
                           DBMS_OUTPUT.put_line ('atencao --- INVALID_MODE');
                           DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
                        WHEN UTL_FILE.invalid_filehandle
                        THEN
                           DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = '
                                                 || v_executa_ant
                                                );
                           DBMS_OUTPUT.put_line ('atencao --- invalid_filehandle');
                           DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
                        WHEN UTL_FILE.invalid_path
                        THEN
                           DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = '
                                                 || v_executa_ant
                                                );
                           DBMS_OUTPUT.put_line ('Verif a exist do param. UTL_FILE_DIR no init');
                           DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
                           RAISE erro_geral;
                        WHEN UTL_FILE.invalid_operation
                        THEN
                           DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = '
                                                 || v_executa_ant
                                                );
                           DBMS_OUTPUT.put_line ('invalid_operation');
                           DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
                           RAISE erro_geral;
                        WHEN NO_DATA_FOUND
                        THEN
                           DBMS_OUTPUT.put_line ('GRAVOU = ' || v_qtd_d_lidos || '   LINHAS');
                        WHEN OTHERS
                        THEN
                           DBMS_OUTPUT.put_line ('WRITE or OPEN (ARQUIVO)');
                           DBMS_OUTPUT.put_line ('ORACLE = ' || SQLERRM);
                           RAISE erro_geral;
                     END;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        -- wellington - 23/02/2011 - envia para o arquivo de erro da cust 1 quando não acha em nenhuma cust
                        UTL_FILE.put_line (harqspool_out_c1, v_cab_registro || v_registro);
                        UTL_FILE.fflush (harqspool_out_c1);
                        v_qtd_server_id_3          := v_qtd_server_id_3 + 1;
                        
                        
                        DBMS_OUTPUT.put_line ('NÃO ACHOU CUSTOMER PARA ' || CHR (39) || v_external_id || CHR (39));
                     WHEN OTHERS
                     THEN
                        UTL_FILE.put_line (harqspool_out_c1, v_cab_registro || v_registro);
                        UTL_FILE.fflush (harqspool_out_c1);
                        v_qtd_server_id_3          := v_qtd_server_id_3 + 1;
                        
                        --DBMS_OUTPUT.put_line ('ERRO ORA : ' || SQLERRM);
                        DBMS_OUTPUT.put_line ('EXTERNAL_ID = ' || CHR (39) || v_external_id || CHR (39));
                  END;
               END IF;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
            	 UTL_FILE.fclose(harqspool_in2);
               DBMS_OUTPUT.put_line ('------------------------------ fim ---------------------------------- ');
               DBMS_OUTPUT.put_line ('--->>> FIM LEITURA ' || CHR (39) || warqspool_in2 || CHR (39));
               DBMS_OUTPUT.put_line ('********************************************************************* ');
            WHEN OTHERS
            THEN
            	 UTL_FILE.fclose(harqspool_in2);
               DBMS_OUTPUT.put_line ('------------------------------ fim ---------------------------------- ');
               DBMS_OUTPUT.put_line ('--->>>   ERRO LEITURA ' || CHR (39) || warqspool_in2 || CHR (39));
               DBMS_OUTPUT.put_line ('ora = ' || SQLERRM);
               DBMS_OUTPUT.put_line ('********************************************************************* ');
         END;
      END LOOP;
   EXCEPTION
      WHEN UTL_FILE.invalid_path
      THEN
         DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
         DBMS_OUTPUT.put_line ('Verif a exist do param. UTL_FILE_DIR no init');
         RAISE erro_geral;
      WHEN UTL_FILE.invalid_operation
      THEN
         DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
         DBMS_OUTPUT.put_line ('invalid_operation');
         DBMS_OUTPUT.put_line ('ora = ' || SQLERRM);
         RAISE erro_geral;
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line ('--------------------------- FIM LISTA ----------------------------- ');
         DBMS_OUTPUT.put_line ('LIDOS                                  = ' || v_qtd_d_lidos);
         DBMS_OUTPUT.put_line ('GRAVADOS SERVER_ID 3 (c1)  ok          = ' || v_qtd_server_id_3);
         DBMS_OUTPUT.put_line ('GRAVADOS SERVER_ID 4 (c2)  ok          = ' || v_qtd_server_id_4);
         DBMS_OUTPUT.put_line ('GRAVADOS SERVER_ID 3 (c1)  erro        = ' || v_qtd_server_id_3_err);
         DBMS_OUTPUT.put_line ('GRAVADOS SERVER_ID 4 (c2)  erro        = ' || v_qtd_server_id_4_err);
         DBMS_OUTPUT.put_line ('FIM LEITURA ARQUIVO LISTA ' || warqspool_in);
         DBMS_OUTPUT.put_line ('******************************************************************* ');
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line ('OTHERS (1) ORACLE = ' || SQLERRM);
         RAISE erro_geral;
   END;

--******************************************************************************
--******************************************************************************
   UTL_FILE.fclose_all;
EXCEPTION
   WHEN UTL_FILE.invalid_path
   THEN
      DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
      DBMS_OUTPUT.put_line ('Verif a exist do param. UTL_FILE_DIR no init');
   WHEN UTL_FILE.invalid_operation
   THEN
      DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
      DBMS_OUTPUT.put_line ('invalid_operation');
      DBMS_OUTPUT.put_line ('ora f = ' || SQLERRM);
   WHEN UTL_FILE.write_error
   THEN
      DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
      DBMS_OUTPUT.put_line ('write_error');
   WHEN sem_movimento
   THEN
      DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
      DBMS_OUTPUT.put_line ('atencao --- Erro geral - Sem movimento - verificar parametros');
      DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
   WHEN erro_geral
   THEN
      DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
      DBMS_OUTPUT.put_line ('atencao --- Erro geral');
      DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('EXECUCAO ATUAL = ' || v_executa_atu || '  ANTERIOR = ' || v_executa_ant);
      DBMS_OUTPUT.put_line ('ERRO : ' || SQLERRM (SQLCODE));
      DBMS_OUTPUT.put_line ('erro desconhecido');
END;
/

SET serverout off;
SET feed on;
EXIT;

