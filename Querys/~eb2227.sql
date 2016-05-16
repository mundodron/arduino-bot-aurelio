/* Formatted on 2008/11/06 17:34 (Formatter Plus v4.8.6) */
-- Nome Arquivo : PLCAD002.sql 
-- Versão : 1.0
-- Autor : Sandra Regina B. M. do Nascimento
-- Data: 15/10/2004
--
-- Função : Gerar arquivo txt para operadoras. Verifica se geracao FULL
--          pela tabela GVT_CONTROLE_CAD_CLIENTE.
--          As informacoes sao originadas da tabela GVT_CADASTRO_CLIENTE
--	        que e alimentada pela PL/SQL PLCAD001

-- Alteração: Layout Portabilidade / Cadastro Cobilling     
-- Alterado por: Juliano Antunes Waurika                                           
-- Data: 21/08/2008
--Alteração : 9 Digitos - CNLs movidos para o final do arquivo / Danilo Moura 
--Data: 14/02/2012

SET serveroutput on size 10000;

DECLARE
   v_nome_arquivo                VARCHAR2 (45);
   v_arquivo                     UTL_FILE.file_type;
   v_nome_log                    VARCHAR2 (30);
   v_dir_arq                     VARCHAR2 (100) := '&1';   -- '/home/cobilling/Interfaces/log'
   v_log                         UTL_FILE.file_type;
   v_eot_origem                  gvt_controle_cad_cliente.cod_eot_origem%TYPE;
   v_eot_destino                 gvt_controle_cad_cliente.cod_eot_destino%TYPE;
   v_sequencia                   gvt_controle_cad_cliente.sequencia%TYPE;
   v_gera_full                   VARCHAR2 (1);
   v_linha_detalhe               VARCHAR2 (1092);
   v_tot_gravados                NUMBER (9);
   v_tot_portado                 NUMBER (9);
   v_tot_ins                     NUMBER (9);   -- TOTAL DE REGISTROS INSERIDOS/NOVOS
   v_tot_alt                     NUMBER (9);   -- TOTAL DE REGISTROS ALTERADOS
   v_tot_des                     NUMBER (9);   -- TOTAL DE REGISTROS COM DESATIVACAO
   v_tot_tra                     NUMBER (9);   -- TOTAL DE REGISTROS COM TRANSFERENCIA DE TITULARIDADE
   v_tot_tro                     NUMBER (9);   -- TOTAL DE REGISTROS COM TROCA
   v_ind_bloqueio                VARCHAR2 (1);
   v_ind_sigilo                  VARCHAR2 (1);
   v_ind_susp                    VARCHAR2 (1);
   v_flag_102                    VARCHAR2 (1);
   v_num_doc                     VARCHAR2 (20);
   v_tronco_cnl                  VARCHAR2 (5);
   v_tronco_ddd                  VARCHAR2 (2);
   v_tronco_telefone             VARCHAR2 (13);  --AUMENTO DE DIGITO PARA 9 DIGITOS
   v_cat_terminal                VARCHAR2 (2);
   v_tipo_movimento              VARCHAR2 (2);

   CURSOR c_gvt_controle_cad_cliente
   IS
      SELECT cod_eot_origem,
             cod_eot_destino,
             sequencia,
             gera_full
        FROM gvt_controle_cad_cliente;

   reg_gvt_controle_cad_cliente  c_gvt_controle_cad_cliente%ROWTYPE;

   CURSOR c_gvt_cadastro_cliente
   IS
      SELECT *
        FROM gvt_cadastro_cliente
       WHERE cod_eot_origem = v_eot_origem
         AND dt_desativacao IS NULL;

   reg_gvt_cadastro_cliente      c_gvt_cadastro_cliente%ROWTYPE;

   CURSOR c_gvt_cadastro_cliente_2
   IS
      SELECT *
        FROM gvt_cadastro_cliente
       WHERE cod_eot_origem = v_eot_origem
         AND gera_txt = 'S';

   reg_gvt_cadastro_cliente_2    c_gvt_cadastro_cliente_2%ROWTYPE;

   PROCEDURE gera_header
   IS
   BEGIN
      UTL_FILE.put_line (v_arquivo,
                            '0'
                         || TO_CHAR (SYSDATE, 'YYYYMMDD')
                         || TO_CHAR (SYSDATE, 'YYYYMMDD')
                         || TO_CHAR (SYSDATE, 'HH24MISS')
                         || 'Global Village Telecom Lt'
                         || TRIM (TO_CHAR (NVL (v_eot_origem, 0), '009'))
                         || TRIM (TO_CHAR (NVL (v_eot_destino, 0), '009'))
                         || TRIM (TO_CHAR (NVL (v_sequencia, 0), '0000009'))
                         || v_tipo_movimento
                         || RPAD (' ', 936, ' ')
                        );
   END;

   PROCEDURE gera_trailler
   IS
   BEGIN
      UTL_FILE.put_line (v_arquivo,
                            '9'
                         || TO_CHAR (SYSDATE, 'YYYYMMDD')
                         || TO_CHAR (SYSDATE, 'YYYYMMDD')
                         || TO_CHAR (SYSDATE, 'HH24MISS')
                         || 'Global Village Telecom Lt'
                         || TRIM (TO_CHAR (NVL (v_tot_gravados, 0), '000000009'))
                         || TRIM (TO_CHAR (NVL (v_tot_ins, 0), '000000009'))
                         || TRIM (TO_CHAR (NVL (v_tot_alt, 0), '000000009'))
                         || TRIM (TO_CHAR (NVL (v_tot_des, 0), '000000009'))
                         || TRIM (TO_CHAR (NVL (v_tot_tra, 0), '000000009'))
                         || TRIM (TO_CHAR (NVL (v_tot_tro, 0), '000000009'))
                         || TRIM (TO_CHAR (NVL (v_tot_portado, 0), '000000009'))
                         ||
                            --RPAD('0',27,'0') ||
                            --RPAD('0',18,'0') ||
                            TRIM (TO_CHAR (NVL (v_sequencia, 0), '0000009'))
                         || RPAD (' ', 881, ' ')
                        );
   END;

   PROCEDURE gera_arquivo
   IS
   BEGIN
      v_tot_gravados             := 2;
      v_tot_ins                  := 0;
      v_tot_alt                  := 0;
      v_tot_des                  := 0;
      v_tot_tra                  := 0;
      v_tot_tro                  := 0;

			--01 - Periódico DEFAULT 
			--02 - Carga Total C 
			--03 - Cobilling O
			--04 - Sob Demanda D 
			--05 - Full de Sincronismo S

      IF v_gera_full = 'S' THEN
         v_tipo_movimento := '05';
         v_sequencia := 0;
      ELSIF v_gera_full = 'C' THEN
         v_tipo_movimento := '02';
			ELSIF v_gera_full = 'O' THEN
         v_tipo_movimento := '03';
      ELSIF v_gera_full = 'D' THEN
         v_tipo_movimento := '04';
			ELSE
         v_tipo_movimento := '01';
      END IF;

      gera_header;
      v_tot_portado              := 0;

      IF v_gera_full = 'S'
      THEN
         FOR reg_gvt_cadastro_cliente IN c_gvt_cadastro_cliente
         LOOP
            v_ind_bloqueio             := NVL (reg_gvt_cadastro_cliente.inad_cl_indicador, 'N');
            v_ind_sigilo               := NVL (reg_gvt_cadastro_cliente.ind_sigilo, ' ');

            IF (v_ind_sigilo = '1')
            THEN
               v_flag_102                 := 'S';
            ELSE
               v_flag_102                 := 'N';
            END IF;

            v_tronco_cnl               := TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.tronco_cnl, 0), '00009'));
            v_tronco_ddd               := TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.tronco_ddd, 0), '09'));
            v_tronco_telefone          := RPAD (NVL (TRIM (reg_gvt_cadastro_cliente.tronco_telefone), '0'), 13, '0');  -- 9 digitos aletração
            v_num_doc                  := RPAD (NVL (reg_gvt_cadastro_cliente.numero_documento, ' '), 16, ' ');

            IF (LENGTH (TRIM (v_num_doc)) = 11)
            THEN
               v_cat_terminal             := '01';
            ELSE
               IF (   v_tronco_cnl <> '00000'
                   OR v_tronco_ddd <> '00'
                   OR v_tronco_telefone <> '0000000000000') -- 9 DIGITOS 
               THEN
                  v_cat_terminal             := '03';
               ELSE
                  v_cat_terminal             := '02';
               END IF;
            END IF;

            v_linha_detalhe            :=
                  '1'
               || RPAD (NVL (reg_gvt_cadastro_cliente.nome_assinante, ' '), 64, ' ')
               || LPAD (NVL (reg_gvt_cadastro_cliente.tipo_doc, ' '), 2, '0')
               || v_num_doc
               || RPAD (NVL (reg_gvt_cadastro_cliente.insc_estadual, ' '), 20, ' ')
               || RPAD ('0', 7, '0')
               ||   --CNAE
                  NVL (reg_gvt_cadastro_cliente.tipo_terminal, ' ')
               ||   --TIPO TERMINAL
                  -- acesso a telefonia 
				  --#### 9 DIGITOS ALETRAÇÕES #####--RETIRADA DO CNL para o final, e aumento do terminal
                 -- TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.linha_cnl, 0), '00009')) REMOÇÃO DO CNL
                 TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.linha_ddd, 0), '09'))
               || RPAD (NVL (TRIM (reg_gvt_cadastro_cliente.linha_telefone), ' '), 13, ' ')
               ||
                  --acesso a tronco chave
                 -- v_tronco_cnl ( 9 DIGITOS )
                v_tronco_ddd
               || v_tronco_telefone
               || NVL (TRIM (reg_gvt_cadastro_cliente.tronco_ident_cobranca), ' ')
               ||
                  -- instalacao
                  RPAD (NVL (reg_gvt_cadastro_cliente.inst_tipo_logra, ' '), 8, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.inst_logradouro, ' '), 50, ' ')
               || LPAD (NVL (reg_gvt_cadastro_cliente.inst_nro, ' '), 7, '0')
               || RPAD (NVL (reg_gvt_cadastro_cliente.inst_complemento, ' '), 50, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.inst_bairro, ' '), 40, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.inst_municipio, ' '), 44, ' ')

               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.inst_cnl, 0), '00009'))
               || RPAD (NVL (reg_gvt_cadastro_cliente.inst_uf, ' '), 2, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.inst_cep, ' '), 8, ' ') 
               ||
                  --cobranca
                  RPAD (NVL (reg_gvt_cadastro_cliente.cob_tipo_logra, ' '), 8, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.cob_logradouro, ' '), 50, ' ')
               || LPAD (NVL (reg_gvt_cadastro_cliente.cob_nro, '0'), 7, '0')
               || RPAD (NVL (reg_gvt_cadastro_cliente.cob_complemento, ' '), 50, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.cob_bairro, ' '), 40, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.cob_municipio, ' '), 44, ' ')

               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.cob_cnl, 0), '00009'))
               || RPAD (NVL (reg_gvt_cadastro_cliente.cob_uf, ' '), 2, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente.cob_cep, ' '), 8, ' ')
               ||
                  --telefone de contato
				  
				--## 9 Digitos ####
			    --remoção do cnl, aumento do TN
				  
                --  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.contato_cnl, 0), '00009'))
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.contato_ddd, 0), '09'))
               || RPAD (NVL (reg_gvt_cadastro_cliente.contato_telefone, ' '), 13, ' ')
               ||
                  -- suspensao a pedido do cliente
                  NVL (reg_gvt_cadastro_cliente.susp_cl_indicador, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.susp_cl_dt_ini, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.susp_cl_dt_ini, 'HH24MMSS'), ' '), 6, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.susp_cl_dt_fim, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.susp_cl_dt_fim, 'HH24MMSS'), ' '), 6, ' ')
               ||
                  -- Inadimplencia
                  v_ind_bloqueio
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.inad_cl_dt_ini, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.inad_cl_dt_ini, 'HH24MMSS'), ' '), 6, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.inad_cl_dt_fim, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.inad_cl_dt_fim, 'HH24MMSS'), ' '), 6, ' ')
               ||
                  -- indicador de sigilo
                  v_ind_sigilo
               || 
                  -- tipo de atualizacao
                  -- NVL(REG_GVT_CADASTRO_CLIENTE.TP_ATUALIZ, 'I') || -- NVL(REG_GVT_CADASTRO_CLIENTE.TP_ATUALIZ,' ') ||
                  'A'
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.dt_atualiz, 'YYYYMMDD'), '0'), 8, '0')
               ||
                  -- telefone anterior -- nao tem informacao
				  
			    --## 9 Digitos ####
			    --remoção do cnl, aumento do TN
                --  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.telefone_ant_cnl, 0), '00009'))
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.telefone_ant_ddd, 0), '09'))
               || RPAD (NVL (reg_gvt_cadastro_cliente.telefone_ant_telefone, ' '), 13, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.telefone_ant_dt_troca, 'YYYYMMDD'), '0'), 8, '0')
               ||
                  -- da execucao do servico
				  
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.hr_execucao, 0), '000009'))
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.dt_ativacao, 'YYYYMMDD'), '0'), 8, '0')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente.dt_desativacao, 'YYYYMMDD'), '0'), 8, '0')
               ||
                  -- isencao tributaria
                  NVL (reg_gvt_cadastro_cliente.ind_isencao_trib, ' ')
               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.percentual_isencao, 0), '00009'))
               ||
                  -- retencao de tributos federais
                  NVL (reg_gvt_cadastro_cliente.retencao_tributos, ' ')
               ||
                  -- dia de vencimento da fatura
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.dia_venc_fatura, 0), '09'))
               ||
                  --motivo de envio de dados cadastrais + filler
                  RPAD (NVL (reg_gvt_cadastro_cliente.motivo_envio_cadastro, ' '), 1, ' ')
               ||   --MOTIVO
                  NVL (reg_gvt_cadastro_cliente.portado, 0)
               ||   --PORTADO
			   
			   --#### 9 DIGITOS ALETRAÇÕES #####
			   TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.linha_cnl, 0), '00009'))  -- cnl acesso
			   ||
			    v_tronco_cnl  -- cnl tronco
			   ||
			   TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.contato_cnl, 0), '00009')) -- cnl contao cliente
			   ||
			   TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente.telefone_ant_cnl, 0), '00009')) -- cnl fone anterior
			   ||
			   --CNLs inseridos
			   
			   
                  RPAD (' ', 28, ' ')  -- FILLER(49) ALTERADO PARA 9 DIGITOS (29)
               ||  
                  v_flag_102
               ||   -- FLAG 102
                  v_cat_terminal
               ||   -- CATEGORIA DO TERMINAL
                  RPAD (NVL (reg_gvt_cadastro_cliente.nome_assinante, ' '), 90, ' ')
               ||   -- FIGURAÇÃO
                  '1'
               ||   -- OPÇÃO DE PUBLICAÇÃO LTLOG
                  TRIM (TO_CHAR (0, '000009'))
               ||   -- ATIVIDADE
                  TRIM (TO_CHAR (0, '0'))
               ||   -- INDICADOR DE TUP
                  TRIM (TO_CHAR (0, '09'))
               ||   -- TIPO DE TUP
                  TRIM (TO_CHAR (0, '09'))
               ||   -- TIPO DE ESTABELECIMENTO
                  RPAD (' ', 136, ' ');   -- FILLER(137)
            v_tot_portado              := v_tot_portado + reg_gvt_cadastro_cliente.portado;
            UTL_FILE.put_line (v_arquivo, v_linha_detalhe);
            -- CONTANDO OS TIPOS DE REGISTROS
            v_tot_ins                  := v_tot_ins + 1;
            v_tot_gravados             := v_tot_gravados + 1;
         END LOOP;   --REG_GVT_CADASTRO_CLIENTE
      ELSE
         FOR reg_gvt_cadastro_cliente_2 IN c_gvt_cadastro_cliente_2
         LOOP
            v_ind_bloqueio             := NVL (reg_gvt_cadastro_cliente_2.inad_cl_indicador, 'N');
            v_ind_sigilo               := NVL (reg_gvt_cadastro_cliente_2.ind_sigilo, ' ');
            v_ind_susp                 := NVL (reg_gvt_cadastro_cliente_2.susp_cl_indicador, ' ');

            -- SE O REGISTRO FOR DE ATUALIZAÇÃO E TEM DATA DE DESCONEXÃO ENTÃO PULO PARA O PRÓXIMO REGISTRO
            IF (reg_gvt_cadastro_cliente_2.tp_atualiz IS NOT NULL)
            THEN
               IF (    (TRIM (reg_gvt_cadastro_cliente_2.tp_atualiz) = 'A')
                   AND (reg_gvt_cadastro_cliente_2.dt_desativacao IS NOT NULL)
                  )
               THEN
                  GOTO end_loop;
               END IF;

               -- Para não enviar informações sobre bloqueios ou suspensões para uma linha desconectada.
               IF (TRIM (reg_gvt_cadastro_cliente_2.tp_atualiz) = 'E')
               THEN
                  IF (   v_ind_susp <> 'N'
                      OR v_ind_bloqueio <> 'N')
                  THEN
                     GOTO end_loop;
                  END IF;
               END IF;
            END IF;

            IF (v_ind_sigilo = '1')
            THEN
               v_flag_102                 := 'S';
            ELSE
               v_flag_102                 := 'N';
            END IF;

            v_tronco_cnl               := TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.tronco_cnl, 0), '00009'));
            v_tronco_ddd               := TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.tronco_ddd, 0), '09'));
            v_tronco_telefone          := RPAD (NVL (TRIM (reg_gvt_cadastro_cliente_2.tronco_telefone), '0'), 13, '0'); -- aumento 9 Digitos
            v_num_doc                  := RPAD (NVL (reg_gvt_cadastro_cliente_2.numero_documento, ' '), 16, ' ');

            IF (LENGTH (TRIM (v_num_doc)) = 11)
            THEN
               v_cat_terminal             := '01';
            ELSE
               IF (   v_tronco_cnl <> '00000'
                   OR v_tronco_ddd <> '00'
                   OR v_tronco_telefone <> '0000000000000') -- 9 DIGITOS
               THEN
                  v_cat_terminal             := '03';
               ELSE
                  v_cat_terminal             := '02';
               END IF;
            END IF;

            v_linha_detalhe            :=
                  '1'
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.nome_assinante, ' '), 64, ' ')
               || LPAD (NVL (reg_gvt_cadastro_cliente_2.tipo_doc, ' '), 2, '0')
               || v_num_doc
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.insc_estadual, ' '), 20, ' ')
               || RPAD ('0', 7, '0')
               ||   --CNAE
                  NVL (reg_gvt_cadastro_cliente_2.tipo_terminal, ' ')
               ||   --TIPO TERMINAL
                  -- acesso a telefonia
				 -- 9 Digitos - remocao do cnl para o filer
                 -- TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.linha_cnl, 0), '00009'))
				 
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.linha_ddd, 0), '09'))
               || RPAD (NVL (TRIM (reg_gvt_cadastro_cliente_2.linha_telefone), ' '), 13, ' ')
               
			   
                  --acesso a tronco chave
                  --v_tronco_cnl -- 9 Digitos remocao do cnl para o filer
               || v_tronco_ddd
               || v_tronco_telefone
               || NVL (TRIM (reg_gvt_cadastro_cliente_2.tronco_ident_cobranca), ' ')
               ||
                  -- instalacao
                  RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_tipo_logra, ' '), 8, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_logradouro, ' '), 50, ' ')
               || LPAD (NVL (reg_gvt_cadastro_cliente_2.inst_nro, ' '), 7, '0')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_complemento, ' '), 50, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_bairro, ' '), 40, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_municipio, ' '), 44, ' ')
               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.inst_cnl, 0), '00009')) 
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_uf, ' '), 2, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.inst_cep, ' '), 8, ' ')
               ||
                  --cobranca
                  RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_tipo_logra, ' '), 8, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_logradouro, ' '), 50, ' ')
               || LPAD (NVL (reg_gvt_cadastro_cliente_2.cob_nro, '0'), 7, '0')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_complemento, ' '), 50, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_bairro, ' '), 40, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_municipio, ' '), 44, ' ')
               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.cob_cnl, 0), '00009'))
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_uf, ' '), 2, ' ')
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.cob_cep, ' '), 8, ' ')
               
                  --telefone de contato
				 -- 9 Digitos -- remocao do cnl para o filer
                 -- TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.contato_cnl, 0), '00009'))
               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.contato_ddd, 0), '09'))
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.contato_telefone, ' '), 13, ' ')
               ||
                  -- suspensao a pedido do cliente
                  v_ind_susp
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.susp_cl_dt_ini, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.susp_cl_dt_ini, 'HH24MMSS'), ' '), 6, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.susp_cl_dt_fim, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.susp_cl_dt_fim, 'HH24MMSS'), ' '), 6, ' ')
               ||
                  -- Inadimplencia
                  v_ind_bloqueio
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.inad_cl_dt_ini, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.inad_cl_dt_ini, 'HH24MMSS'), ' '), 6, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.inad_cl_dt_fim, 'YYYYMMDD'), ' '), 8, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.inad_cl_dt_fim, 'HH24MMSS'), ' '), 6, ' ')
               ||
                  -- indicador de sigilo
                  v_ind_sigilo
               ||
                  -- tipo de atualizacao
                  NVL (reg_gvt_cadastro_cliente_2.tp_atualiz, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.dt_atualiz, 'YYYYMMDD'), '0'), 8, '0')
               
                  -- telefone anterior -- nao tem informacao
				--   9 Digitos remocao do cnl para o filer
                --  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.telefone_ant_cnl, 0), '00009'))
               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.telefone_ant_ddd, 0), '09'))
               || RPAD (NVL (reg_gvt_cadastro_cliente_2.telefone_ant_telefone, ' '), 13, ' ')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.telefone_ant_dt_troca, 'YYYYMMDD'), '0'), 8, '0')
               ||
                  -- da execucao do servico
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.hr_execucao, 0), '000009'))
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.dt_ativacao, 'YYYYMMDD'), '0'), 8, '0')
               || RPAD (NVL (TO_CHAR (reg_gvt_cadastro_cliente_2.dt_desativacao, 'YYYYMMDD'), '0'), 8, '0')
               ||
                  -- isencao tributaria
                  NVL (reg_gvt_cadastro_cliente_2.ind_isencao_trib, ' ')
               || TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.percentual_isencao, 0), '00009'))
               ||
                  -- retencao de tributos federais
                  NVL (reg_gvt_cadastro_cliente_2.retencao_tributos, ' ')
               ||
                  -- dia de vencimento da fatura
                  TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.dia_venc_fatura, 0), '09'))
               ||
                  --motivo de envio de dados cadastrais + filler
                  RPAD (NVL (reg_gvt_cadastro_cliente_2.motivo_envio_cadastro, ' '), 1, ' ')
               ||   --MOTIVO
                  NVL (reg_gvt_cadastro_cliente_2.portado, 0)
               ||   --PORTADO
			   
			     --9 DIGITOS - ACRESSIMO DOS CNLS
				 
			     TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.linha_cnl, 0), '00009')) -- CNL ACESSO
			   ||
			   
			    v_tronco_cnl  --cnl tronco
			   ||
			    TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.contato_cnl, 0), '00009')) --CNL FONE CONTATO 
			   ||
			   
			   TRIM (TO_CHAR (NVL (reg_gvt_cadastro_cliente_2.telefone_ant_cnl, 0), '00009')) --cnl anterior
			   
			   ||
                  RPAD (' ', 28, ' ') -- FILLER(49) para 29, acrescimo dos CNLs no final
               ||   
                  v_flag_102
               ||   -- FLAG 102
                  v_cat_terminal
               ||   -- CATEGORIA DO TERMINAL
                  RPAD (NVL (reg_gvt_cadastro_cliente_2.nome_assinante, ' '), 90, ' ')
               ||   -- FIGURAÇÃO
                  '1'
               ||   -- OPÇÃO DE PUBLICAÇÃO LTLOG
                  TRIM (TO_CHAR (0, '000009'))
               ||   -- ATIVIDADE
                  TRIM (TO_CHAR (0, '0'))
               ||   -- INDICADOR DE TUP
                  TRIM (TO_CHAR (0, '09'))
               ||   -- TIPO DE TUP
                  TRIM (TO_CHAR (0, '09'))
               ||   -- TIPO DE ESTABELECIMENTO
                  RPAD (' ', 136, ' ');   -- FILLER(137)

            IF reg_gvt_cadastro_cliente_2.tp_atualiz = 'P'
            THEN
               v_tot_portado              := v_tot_portado + reg_gvt_cadastro_cliente.portado;
            END IF;

            UTL_FILE.put_line (v_arquivo, v_linha_detalhe);

            -- CONTANDO OS TIPOS DE REGISTROS
            IF reg_gvt_cadastro_cliente_2.tp_atualiz = 'A'
            THEN
               v_tot_alt                  := v_tot_alt + 1;
            ELSIF    reg_gvt_cadastro_cliente_2.tp_atualiz = 'E'
                  OR reg_gvt_cadastro_cliente_2.tp_atualiz = 'P'
            THEN
               v_tot_des                  := v_tot_des + 1;
            ELSIF reg_gvt_cadastro_cliente_2.tp_atualiz = 'R'
            THEN
               v_tot_tra                  := v_tot_tra + 1;
            ELSIF reg_gvt_cadastro_cliente_2.tp_atualiz = 'T'
            THEN
               v_tot_tro                  := v_tot_tro + 1;
            ELSE   --ELSIF NVL(REG_GVT_CADASTRO_CLIENTE_2.TP_ATUALIZ,'I') = 'I' THEN
               v_tot_ins                  := v_tot_ins + 1;
            END IF;

            v_tot_gravados             := v_tot_gravados + 1;

            <<end_loop>>
            NULL;
         END LOOP;   --REG_GVT_CADASTRO_CLIENTE_2
      END IF;

      gera_trailler;
   END;
--*** PRINCIPAL ***
BEGIN
   -- abrindo arquivo de log
   v_nome_log                 := 'ARQUIVOTXT' || '_D' || TO_CHAR (SYSDATE, 'YYMMDD') || '.log';
   v_log                      := UTL_FILE.fopen (v_dir_arq, v_nome_log, 'W');

   -- TESTE V_LOG      := UTL_FILE.FOPEN('/home/arbor/data/log', V_NOME_LOG, 'W');
   --

   -- COLOCANDO O CAMPO IDENT COBRANCA DEFAULT N QDO O CLIENTE NAO TIVER TRONCO
   UPDATE cobilling.gvt_cadastro_cliente
      SET tronco_ident_cobranca = 'N'
    WHERE tronco_ident_cobranca = 'S'
      AND tronco_cnl IS NULL
      AND tronco_telefone IS NULL;

   COMMIT;

   FOR reg_gvt_controle_cad_cliente IN c_gvt_controle_cad_cliente
   LOOP
      v_eot_origem               := reg_gvt_controle_cad_cliente.cod_eot_origem;
      v_eot_destino              := reg_gvt_controle_cad_cliente.cod_eot_destino;
      v_sequencia                := reg_gvt_controle_cad_cliente.sequencia;
      v_gera_full                := reg_gvt_controle_cad_cliente.gera_full;

      -- abrindo arquivo para operadora
      /*V_NOME_ARQUIVO := TRIM(TO_CHAR(V_EOT_DESTINO,'009')) || 'CAD.E' || TRIM(TO_CHAR(V_EOT_ORIGEM,'009'))  ||
                        '.D' || TO_CHAR(SYSDATE,'YYMMDD') || '.S' ||
                        TRIM(TO_CHAR(NVL(V_SEQUENCIA,0),'009')) || '.txt';
      */
      IF (v_eot_destino = 1)
      THEN
         v_nome_arquivo             :=
               'CAD.E'
            || TRIM (TO_CHAR (v_eot_origem, '009'))
            || '.D'
            || TO_CHAR (SYSDATE, 'YYMMDD')
            || '.S'
            || TRIM (TO_CHAR (NVL (v_sequencia, 0), '0009'))
            || '.txt';
       ELSIF (v_eot_destino = 11) THEN
      		IF (v_gera_full = 'S') THEN 
          	v_nome_arquivo             :=
               'D.SER61.A001F141.E'
            || TRIM (TO_CHAR (v_eot_origem, '009'))
            || '.D'
            || TO_CHAR (SYSDATE, 'YYMMDD')
            || '.H'
            || TO_CHAR (SYSDATE, 'HHMISS')
            || '.txt';
           ELSE
          	v_nome_arquivo             :=
               'D.SER61.A001M141.E'
            || TRIM (TO_CHAR (v_eot_origem, '009'))
            || '.D'
            || TO_CHAR (SYSDATE, 'YYMMDD')
            || '.H'
            || TO_CHAR (SYSDATE, 'HHMISS')
            || '.txt';
          END IF;
       ELSE
         v_nome_arquivo             :=
               TRIM (TO_CHAR (v_eot_destino, '009'))
            || 'CAD.'
            || TRIM (TO_CHAR (v_eot_origem, '009'))
            || '.'
            || TO_CHAR (SYSDATE, 'YYMMDD')
            || '.'
            || TRIM (TO_CHAR (NVL (v_sequencia, 0), '0009'))
            || '.txt';
      END IF;

      v_arquivo                  := UTL_FILE.fopen (v_dir_arq, v_nome_arquivo, 'W');
      -- TESTE V_ARQUIVO      := UTL_FILE.FOPEN('/home/arbor/data/log', V_NOME_ARQUIVO, 'W');
      gera_arquivo;
      UTL_FILE.fclose (v_arquivo);
   END LOOP;   --REG_GVT_CONTROLE_EOT_ORIGEM

   -- Altera flag e numero de sequencia.
   BEGIN
      UPDATE gvt_controle_cad_cliente
         SET sequencia = NVL (sequencia, 0) + 1,
             gera_full = 'N';
   EXCEPTION
      WHEN OTHERS
      THEN
         UTL_FILE.put_line (v_log, 'ERRO AO ALTERAR GVT_CONTROLE_CAD_CLIENTE ' || SQLERRM (SQLCODE));
   END;

   -- Altera flag e numero de sequencia.
   BEGIN
      UPDATE gvt_cadastro_cliente
         SET gera_txt = 'N';
   EXCEPTION
      WHEN OTHERS
      THEN
         UTL_FILE.put_line (v_log, 'ERRO AO ALTERAR GVT_CADASTRO_CLIENTE ' || SQLERRM (SQLCODE));
   END;

   COMMIT;
   UTL_FILE.fclose (v_log);
   UTL_FILE.fclose (v_arquivo);
   DBMS_OUTPUT.put_line ('ARQUIVO DE LOG: ' || v_nome_log);
EXCEPTION
   WHEN UTL_FILE.write_error
   THEN
      UTL_FILE.put_line (v_log, 'ERRO AO ESCREVER TXT');
      UTL_FILE.fclose (v_log);
      UTL_FILE.fclose (v_arquivo);
      DBMS_OUTPUT.put_line ('ARQUIVO DE LOG: ' || v_nome_log);
   WHEN UTL_FILE.invalid_path
   THEN
      UTL_FILE.put_line (v_log, 'CAMINHO DO ARQUIVO INVALIDO');
      UTL_FILE.fclose (v_log);
      UTL_FILE.fclose (v_arquivo);
      DBMS_OUTPUT.put_line ('ARQUIVO DE LOG: ' || v_nome_log);
   WHEN UTL_FILE.invalid_operation
   THEN
      UTL_FILE.put_line (v_log, 'OPERACAO INVALIDA');
      UTL_FILE.fclose (v_log);
      UTL_FILE.fclose (v_arquivo);
      DBMS_OUTPUT.put_line ('ARQUIVO DE LOG: ' || v_nome_log);
   WHEN OTHERS
   THEN
      UTL_FILE.put_line (v_log, 'ERRO ' || SQLERRM (SQLCODE));
      UTL_FILE.fclose (v_log);
      UTL_FILE.fclose (v_arquivo);
      DBMS_OUTPUT.put_line ('ARQUIVO DE LOG: ' || v_nome_log);
END;
/
