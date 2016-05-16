CREATE OR REPLACE PROCEDURE GRCOWN.PROC_CARGA_ERROS_BMP
                            ( p_nome_arquivo   varchar2 )  IS


-- NAME.............: PROC_CARGA_ERROS_BMP
-- PURPOSE..........: Cadastrar os CDRs com erros dos arquivos REM.TCOE.T??????.S??.D??????.H??????.NC.*.GN  onde "GN" é "No Go".
-- DATA BASE........: PBCT1
-- USER.............: GRCOWN
-- periodicity......: 
-- CALLED BY........: proc_carga_erros_bmp.sh
-- EXTERNAL CALLS...: 
-- ASK PARAMETER....: yes,  nome do arquivo REM.TCOE.
-- READ FILES.......: Yes,  arquivo REM.TCOE.
-- WRITE FILES......: yes,  How Many? 1 (log)

----------------------------------------------------------------------------------------------
-- Versão: Autor:               Data:       Doc:        Motivo:
   ------  -------------------- ----------- ----------- --------------------------------------
-- 1.01    Patrícia             13/08/01    xxxxxxxxxx  Criação do procedimento.
-- 1.02    Marcus               31/10/02    xxxxxxxxxx  Consistencias para o Sub-Csp.
-- 1.03    g0010388 Valter      16/07/2012  RFC 346359  Os arquivos TCOR que enviamos para as operadoras estão informando o nome do arquivo TCOE com posições truncadas.
-- 1.04    g0010388 Valter      16/07/2012  RFC 363933  Melhorias na homologação.
-- 1.05    g0023421 Aurelio     26/01/2015  
-- 1.06    xxxxxxxxxxxxxxxxxxxx xxxxxxxxxx  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
----------------------------------------------------------------------------------------------

-------------------
iNome_Rotina       varchar2(60) := 'proc_carga_erros_bmp';
iInterface         varchar2(02) := '';
-------------------
file_dir_log       varchar2(250);  -- Diretório do arquivo de log --
file_name_log      varchar2(250) := 'BMP_NOK_'||p_nome_arquivo||'.log';  -- Nome do arquivo de log --
file_type_log      UTL_FILE.FILE_TYPE;

file_dir_bmp       varchar2(250);  -- Diretório do arquivo de log --
file_name_bmp      varchar2(250) := p_nome_arquivo;  -- Nome do arquivo de log --
file_type_bmp      UTL_FILE.FILE_TYPE;
-------------------
Time               date;           -- data e hora de inicio da rotina --
data_base          varchar2(150);  -- nome da instância do banco de dados --
iLocal             varchar2(254);  -- registro do local que a rotina executa --
Exception_Stop     Exception;  pragma exception_init(Exception_Stop,   -20911);  -- exceção que finaliza a PL --
Exception_GoOn     Exception;  pragma exception_init(Exception_GoOn,   -20912);  -- exceção que não finaliza a PL --
iShow_Msg          varchar2(4) := null; -- mostra a mensagem na tela ou no arquivo de log --
-------------------

-- Definição das Variáveis:
V_COD_ERRO               grc_erros_bmp.cod_erro%TYPE;
V_TIPO_REGISTRO          VARCHAR2(1);
v_parceiro               grc_parceiros.codigo%TYPE;
v_linha_arq              VARCHAR2(400);
v_sequencial_chave       grc_erros_bmp.sequencial_chave%TYPE;
v_valor_faturado         grc_erros_bmp.valor_faturado%TYPE;
v_data_servico           grc_erros_bmp.data_servico%TYPE;
v_hora_inicio            grc_erros_bmp.hora_inicio%TYPE;
v_duracao                grc_erros_bmp.duracao%TYPE;
v_telefone_origem        grc_erros_bmp.telefone_origem%TYPE;
v_telefone_destino       grc_erros_bmp.telefone_destino%TYPE;
v_cnl_origem             grc_erros_bmp.cnl_origem%TYPE;
v_cnl_destino            grc_erros_bmp.cnl_destino%TYPE;
v_csp                    grc_erros_bmp.csp%TYPE;
v_eot_origem             grc_erros_bmp.eot_origem%TYPE;
v_eot_destino            grc_erros_bmp.eot_destino%TYPE;
v_rede_origem            grc_erros_bmp.rede_origem%TYPE;
v_natureza               grc_erros_bmp.natureza%TYPE;
v_pais_destino           grc_erros_bmp.pais_destino%TYPE;
v_cod_seq_TFI            grc_erros_bmp.cod_seq_TFI%TYPE;
v_cod_contestacao        grc_erros_bmp.cod_contestacao%TYPE;
v_lote                   grc_erros_bmp.lote%TYPE;
v_eot_filial             grc_erros_bmp.eot_filial%TYPE;
v_servico_operadora      grc_erros_bmp.servico_operadora%TYPE;
v_sub_csp                grc_erros_bmp.sub_csp%TYPE;
v_originalBeginChar      grc_erros_bmp.COD_REGISTRO%TYPE;
v_realDuration           grc_erros_bmp.DURACAO_REAL%TYPE;
v_billingPeriod          grc_erros_bmp.GRUPO_HORARIO%TYPE;
v_degree                 grc_erros_bmp.DEGRAU%TYPE;
v_visitedEOT             grc_erros_bmp.COD_NAC_AREA_VISITADA%TYPE;
v_nro_lidos              NUMBER := 0;
v_nro_gravados           NUMBER := 0;
v_nro_erros              NUMBER := 0;
v_regs_lote              NUMBER;  -- Nro de registros informados no trailler do arquivo
v_valor_lote             NUMBER;  -- Valor dos registros informados no trailler do arquivo
v_valor_total_lote       NUMBER(20, 5) := 0; -- calculados no procedimento para efeito de verificacao c/ o valor informado
v_obs                    grc_interfaces.obs%TYPE;
vSplote                  grc_erros_bmp.lote%TYPE;
vDataLote                grc_erros_bmp.data_lote%type;
v_nro_linha              number(8) := 0;


----------------------------------------------------------------------------------------------------
-- Busca o diretório para gravar arquivos de LOG.
Cursor qDIR
is
SELECT dir_unix
  FROM grc_processos
 WHERE processo = 'LOG';

----------------------------------------------------------------------------------------------------
-- Busca o diretório para gravar arquivos de ERROS.
Cursor qDIR_BMP
is
SELECT dir_unix
  FROM grc_processos
 WHERE processo = 'ERR';

----------------------------------------------------------------------------------------------------
-- Busca o SUB-CSP 
Cursor curSubCSP ( p_csp grc_eot_operadoras.csp%type, 
                   p_eot_filial grc_eot_operadoras.eot%type) is
SELECT sub_csp
  FROM grc_eot_operadoras
 WHERE csp = p_csp
   and eot = p_eot_filial;


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE LOCALIZACAO_ANTERIOR IS
BEGIN
  iLocal := substr(iLocal,1,instr(iLocal,';',-1)-1);
END LOCALIZACAO_ANTERIOR;

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE grava_arq_log (p_tipo varchar2, p_texto varchar2) is
BEGIN
  iLocal := iLocal||';grava_arq_log';
  
  --/*
  if p_tipo = 'TELA' or p_tipo is null then
    dbms_output.put_line( p_texto );
  end if;
  --*/
  
  --/*
  IF p_tipo = 'FILE' or p_tipo is null THEN
    IF not UTL_FILE.IS_OPEN(file_type_log) THEN
      file_name_log  := upper(iNome_Rotina) ||'_'|| file_name_bmp ||'.log';  
      file_type_log  := UTL_FILE.fopen (file_dir_log, file_name_log, 'W');
      dbms_output.put_line( 'Diretorio..: '||file_dir_log);
      dbms_output.put_line( 'Arquivo....: '||file_name_log);
      dbms_output.put_line( '----' );
    END IF;
    UTL_FILE.PUT_LINE(file_type_log, CONVERT( p_texto, 'WE8ISO8859P1'));
    utl_file.fflush  (file_type_log);
  END IF;
  --*/
   
  LOCALIZACAO_ANTERIOR;
END grava_arq_log;

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ I N I C I O ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
BEGIN
  iLocal    := 'INICIO~~ 01';
  Time      := sysdate;
  data_base := DBMS_REPUTIL.GLOBAL_NAME();
  
  -- Busca o diretório para gravar os LOGs.
  Open  qDIR;
  Fetch qDIR into file_dir_log;
     if qDIR%notfound then
       grava_arq_log('TELA', RPAD('=', 80, '=') );
       grava_arq_log('TELA', 'PL.........: ' || upper(iNome_Rotina) );
       grava_arq_log('TELA', 'Inicio.....: ' || TO_CHAR(Time, 'DD/MM/YYYY HH24:MI:SS') );
       grava_arq_log('TELA', 'Base.......: ' || data_base );
       grava_arq_log('TELA', 'Erro.......: Diretorio para o arquivo de LOG nao encontrado na grc_processos' );
       grava_arq_log('TELA', 'Oracle.....: ORA-01403: no_data_found');
       grava_arq_log('TELA', 'Arquivo....: '|| file_name_bmp );
       raise Exception_Stop;
     end if;
  Close qDIR;
  
  -- Grava informações no arquivo de LOGs.
  iLocal    := 'INICIO~~ 05';
  grava_arq_log('', RPAD('=', 80, '=') ||chr(10)||
                   'PL.........: '||upper(iNome_Rotina) ||'  --  arquivo de log de execucao' ||chr(10)||
                   'Inicio.....: ' || TO_CHAR(Time, 'DD/MM/YYYY HH24:MI:SS') ||chr(10)||
                   'Base.......: ' || data_base ||chr(10)||
                   'Usuario....: ' || user ||chr(10)||
                   'Arquivo....: '|| file_name_bmp );
  
  
  iLocal    := 'INICIO~~ 10';
  ------------------------------------------------------------------------------
  -- Busca o diretório para gravar os ERROS.
  OPEN  qDIR_BMP;
  FETCH qDIR_BMP INTO file_dir_bmp;
  CLOSE qDIR_BMP;
  
  
  iLocal    := 'INICIO~~ 15';
  ------------------------------------------------------------------------------
  -- Abre o arquivo de CDR's com erros para leitura.
  file_type_bmp := UTL_FILE.FOPEN(file_dir_bmp,     file_name_bmp,     'R');
  
  iLocal    := 'INICIO~~ 20';
  INSERT INTO GRC_ARQS_BMP
           ( NOME_ARQUIVO,
             DATA_CARGA )
   VALUES  ( file_name_bmp,
             Time );
  
  iLocal    := 'INICIO~~ 25';
  ------------------------------------------------------------------------------
  -- Loop para leitura do arquivo de CDR's com erros.
  LOOP
    BEGIN
        utl_file.get_line(file_type_bmp, v_linha_arq);
        v_tipo_registro := SUBSTR(v_linha_arq,1,1);
        
        -- HEADER
        IF v_tipo_registro = '0' THEN
              NULL;
        
        -- TRAILLER
        ELSIF v_tipo_registro = '9' THEN -- Valores enviados no Trailler do arquivo de CDR's
              iLocal    := 'INICIO~~ 30';
              v_regs_lote  := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 2, 14))));  -- Qtde de Registros do Lote
              v_valor_lote := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 16, 17))))/100000; -- Valor do Lote
        
        -- DETAIL
        ELSIF v_tipo_registro = '8' THEN
              
              v_nro_linha     := v_nro_linha + 1;
              v_nro_lidos     := v_nro_lidos + 1;
              
              iLocal    := 'INICIO~~ 35';
              v_sequencial_chave   := RTRIM(LTRIM(SUBSTR(v_linha_arq, 2, 32)));
              v_cnl_origem         := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 34, 5))));
              v_cnl_destino        := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 39,5 ))));
              v_telefone_origem    := RTRIM(LTRIM(SUBSTR(v_linha_arq, 44,21 )));
              v_telefone_destino   := RTRIM(LTRIM(SUBSTR(v_linha_arq, 65,21 )));
              v_valor_faturado     := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 86,15))))/100000;
              iLocal    := 'INICIO~~ 40';
              v_data_servico       := TO_DATE(RTRIM(LTRIM(SUBSTR(v_linha_arq, 101, 8))),'DDMMYYYY');
              v_hora_inicio        := RTRIM(LTRIM(SUBSTR(v_linha_arq, 109, 6)));
              v_duracao            := NVL(RTRIM(LTRIM(SUBSTR(v_linha_arq, 115, 5))),0);  -- Duracao tarifada
              v_rede_origem        := RTRIM(LTRIM(SUBSTR(v_linha_arq, 120, 1 )));
              v_csp                := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 121, 2))));
              v_natureza           := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 123,3))));
              v_cod_contestacao    := RTRIM(LTRIM(SUBSTR(v_linha_arq, 126, 2)));  -- Preenchido no caso de "DEBITO MANTIDO"
              
              IF v_cod_contestacao IS NULL THEN v_cod_contestacao := 'N';
              ELSE                              v_cod_contestacao := 'S';
              END IF;
              
			  iLocal    := 'INICIO~~ 45';
              iLocal    := 'INICIO~~ 50';
              
			  v_eot_origem         := RTRIM(LTRIM(SUBSTR(v_linha_arq, 128, 3)));
              v_eot_destino        := RTRIM(LTRIM(SUBSTR(v_linha_arq, 131, 3)));
              v_pais_destino       := RTRIM(LTRIM(SUBSTR(v_linha_arq, 134, 3)));
              v_cod_seq_TFI        := TO_NUMBER(RTRIM(LTRIM(SUBSTR(v_linha_arq, 137, 11))));
              v_lote               := RTRIM(LTRIM(SUBSTR(v_linha_arq, 148, 32)));
              v_eot_filial         := RTRIM(LTRIM(SUBSTR(v_linha_arq,154,3)));
              v_cod_erro           := RTRIM(LTRIM(SUBSTR(v_linha_arq,180,3)));
              v_servico_operadora  := RTRIM(LTRIM(SUBSTR(v_linha_arq,186,5)));
              v_originalBeginChar  := RTRIM(LTRIM(SUBSTR(v_linha_arq,191,1)));
              v_realDuration       := RTRIM(LTRIM(SUBSTR(v_linha_arq,193,6)));
              v_billingPeriod      := RTRIM(LTRIM(SUBSTR(v_linha_arq,199,1)));
              v_degree             := RTRIM(LTRIM(SUBSTR(v_linha_arq,200,2)));
              v_visitedEOT         := RTRIM(LTRIM(SUBSTR(v_linha_arq,202,2)));

              iLocal    := 'INICIO~~ 55';
              
              -- Busca a sub_csp
              OPEN  curSubCSP( v_csp, v_eot_filial );
              FETCH curSubCSP INTO v_sub_csp;
              CLOSE curSubCSP;
              
              iLocal    := 'INICIO~~ 60';
              -- Busca o código do parceiro
              v_parceiro  := FUNC_RETORNA_PARCEIRO(v_csp, v_sub_csp, v_data_servico);

              vSplote   := substr(file_name_bmp, instr(file_name_bmp, 'TCOE'), 24); -- RFC 346359
              begin
                vDataLote := to_Date(substr(vSplote, 19, 6), 'ddmmyy');
              exception when others then
                  vDataLote := null;
              end;
              
              iLocal    := 'INICIO~~ 65';
              
              INSERT INTO GRC_ERROS_BMP
                    (sequencial_chave,valor_faturado,
                     data_servico, hora_inicio, duracao,telefone_origem,
                     telefone_destino, cnl_origem,cnl_destino,csp,
                     eot_origem,eot_destino,
                     rede_origem,natureza,pais_destino,cod_seq_TFI,
                     cod_contestacao,lote,cod_erro,nome_arquivo,
                     parceiro, sub_csp, eot_filial, data_lote,
					 cod_registro,duracao_real,grupo_horario,degrau,cod_nac_area_visitada		 
					 )
                     VALUES
                    (v_sequencial_chave,  v_valor_faturado,
                     v_data_servico,  v_hora_inicio,  v_duracao,  v_telefone_origem,
                     v_telefone_destino,  v_cnl_origem,  v_cnl_destino,  v_csp,
                     v_eot_origem,  v_eot_destino,
                     v_rede_origem,  v_natureza,  v_pais_destino,  v_cod_seq_TFI,
                     v_cod_contestacao,  v_lote,  v_cod_erro,  file_name_bmp,
                     v_parceiro,  v_sub_csp,  v_eot_filial,  vDataLote,
					 v_originalBeginChar, v_realDuration, v_billingPeriod, v_degree, v_visitedEOT
					 );
                     
              v_nro_gravados     := v_nro_gravados + 1;
              v_valor_total_lote := v_valor_total_lote + v_valor_faturado;
        
        -- Problemas na linha do arquivo
        ELSIF v_tipo_registro IN ('1','2') THEN
          iLocal    := 'INICIO~~ 70';
          v_nro_lidos := v_nro_lidos + 1;
          v_nro_erros := v_nro_erros + 1;
          
          grava_arq_log('FILE', 'Tipo registro invalido no arquivo de erro');
          grava_arq_log('FILE', v_linha_arq);
        END IF;
        
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        EXIT;
      
      WHEN DUP_VAL_ON_INDEX THEN      -- Erro de chave primária no insert.v_nro_linha
        grava_arq_log('FILE', 'Erro de chave primaria ao tentar inserir na GRC_ERROS_BMP');
        grava_arq_log('FILE', 'Linha...........: '||v_nro_linha);
        grava_arq_log('FILE', 'Registro........: '||v_tipo_registro);
        grava_arq_log('FILE', 'Sequencial......: '||v_sequencial_chave);
        grava_arq_log('FILE', 'Local...........: '||iLocal);
        utl_file.fflush(file_type_log);
        v_nro_erros   := v_nro_erros + 1;
        
      WHEN OTHERS THEN  -- Algum outro erro no insert.
        grava_arq_log('FILE', 'Erro ao tentar inserir na GRC_ERROS_BMP');
        grava_arq_log('FILE', 'Linha...........: '||v_nro_linha);
        grava_arq_log('FILE', 'Registro........: '||v_tipo_registro);
        grava_arq_log('FILE', 'Sequencial......: '||v_sequencial_chave);
        grava_arq_log('FILE', 'Local...........: '||iLocal);
        grava_arq_log('FILE', 'Oracle..........: '||substr(replace(sqlerrm, chr(10),'; '),1, 254) );
        utl_file.fflush(file_type_log);
        v_nro_erros   := v_nro_erros + 1;
    END;
  END LOOP ;
  
  iLocal    := 'INICIO~~ 80';
  COMMIT;
  
  utl_file.FClose(file_type_bmp);
  
  ------------------------------------------------------------------------------
  grava_arq_log('', RPAD('=', 80, '='));
  grava_arq_log('', '..quantidade..: ' || v_nro_linha    ||'  de Linhas no Arquivo');
  grava_arq_log('', '..quantidade..: ' || v_nro_lidos    ||'  de Registros "detail" lidos' );
  grava_arq_log('', '..quantidade..: ' || v_nro_gravados ||'  de Registros gravados na GRC_ERROS_BMP' );
  grava_arq_log('', '..valor.......: ' || v_valor_lote   ||'  total do Arquivo no Registro 9.' );
  grava_arq_log('', '..valor.......: ' || v_valor_total_lote ||'  soma dos registros no "detail".' );
  grava_arq_log('', '--------------------------------------------------' );
  grava_arq_log('', 'Qtde..........: ' || v_nro_erros ||'  de erros durante a execucao desta PL.' );
  grava_arq_log('', '--------------------------------------------------' );
  grava_arq_log('', 'Final.....: '|| to_char(sysdate,'dd/mm/yyyy hh24:mi:ss'));
  grava_arq_log('', 'Tempo.....: '|| to_char(trunc(SYSDATE)+(SYSDATE-Time),'hh24:mi:ss'));
  
  
  iLocal    := 'INICIO~~ 85';
  ------------------------------------------------------------------------------
  -- Atualiza a tabela de interface com os dados da execução da carga dos serviços --
  IF v_nro_erros > 0 THEN
    grava_arq_log('FILE', 'Houve um erro ao executar a PL');
    v_obs := 'ERRO: O arquivo foi carregado com ' || v_nro_erros || ' registros com problemas. Maiores detalhes veja o arquivo de LOG.';
    
    PROC_GERA_MENSAGENS('GRCOWN', -- destinatário
                        'ERRO! Processo de carga de CDRs com erros.', -- assunto
                        file_name_bmp, -- nome do arquivo
                        'O arquivo foi carregado com ' || v_nro_erros || ' registro(s) com problema(s). ' || CHR(10) ||
                        'Maiores detalhes no arquivo de LOG. (' || file_dir_log ||')'|| file_name_log);
  ELSE
    v_obs := 'O arquivo foi carregado com sucesso. '  || CHR(10) ||
             'Foram inseridos ' || v_nro_gravados || ' registros, totalizando um valor de ' || v_valor_total_lote;
  END IF;
  
  iLocal    := 'INICIO~~ 90';
  ------------------------------------------------------------------------------
  INSERT INTO GRC_INTERFACES(CODIGO, PROCESSO, DATA_INCLUSAO, USUARIO, PATH_ARQUIVO, NOME_ARQUIVO,
                             DATA_INIC_EXEC, DATA_FIM_EXEC, STATUS_EXEC, OBS, ATRIB1, ATRIB2, 
                             ATRIB3, ATRIB4, ATRIB5, ATRIB6, parceiro)
                    VALUES (SEQ_INTERFACE.NEXTVAL, 'ERR', TRUNC(SYSDATE), USER, file_dir_bmp, file_name_bmp,
                            Time, sysdate, DECODE(v_nro_erros,0,'S','E'), v_obs, v_nro_lidos, v_nro_gravados,
                            v_nro_erros, to_char(v_regs_lote), to_char(v_valor_lote), to_char(v_valor_total_lote), v_parceiro);
  
  COMMIT;
  
  utl_file.FClose(file_type_log);
  
EXCEPTION
    
  WHEN others THEN
    ROLLBACK;
    if    sqlcode = '-29280' then iShow_Msg := 'TELA'; grava_arq_log(iShow_Msg, 'Exception: UTL_FILE.INVALID_PATH ... Diretorio nao Existe .. Verifique se o diretorio informado existe.');
    elsif sqlcode = '-29283' then iShow_Msg := 'TELA'; grava_arq_log(iShow_Msg, 'Exception: UTL_FILE.INVALID_OPERATION ... Acesso negado ao arquivo/Diretorio .. Verifique o status de acesso ao arquivo/diretorio');
    elsif sqlcode = '-29284' then iShow_Msg := 'TELA'; grava_arq_log(iShow_Msg, 'Exception: UTL_FILE.WRITE_ERROR ... Falha ao escrever no arquivo ..  Verifique o arquivo');
    elsif sqlcode = '-1'     then iShow_Msg := '';     grava_arq_log(iShow_Msg, 'DUP_VAL_ON_INDEX ... Verifique se o arquivo ja foi inserido anteriormente na GRC_ARQS_BMP');
    elsif sqlcode = '-20911' then                      grava_arq_log(iShow_Msg, 'Exception: EXCEPTION_STOP ...');
    elsif sqlcode = '-20912' then                      grava_arq_log(iShow_Msg, 'Exception: EXCEPTION_GOON ...');
    else                                               grava_arq_log(iShow_Msg, 'Exception: when OTHERS...');
    end if;
    
    grava_arq_log(iShow_Msg, 'Local......: '||ilocal);
    grava_arq_log(iShow_Msg, 'Erro.......: '||replace(sqlerrm,chr(10),'; ') );
    grava_arq_log(iShow_Msg, 'Tempo Decorrido..: '||to_char(trunc(sysdate) + (sysdate-Time),'hh24:mi:ss')||'.');
    utl_file.fclose_all;
    
    PROC_GERA_MENSAGENS('GRCOWN', 'ERRO! Processo de carga de erros BMP.', file_name_bmp, substr(replace(sqlerrm, chr(10),'; '),1, 254) );
    
END PROC_CARGA_ERROS_BMP; 
/