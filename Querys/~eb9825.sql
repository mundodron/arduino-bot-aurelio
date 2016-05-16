SET LINESIZE 180    FEED OFF    SERVEROUT ON SIZE 1000000;
DECLARE

/*--------------------------------------------------------------------------------------------------
NAME.............: PL_GERA_ARQ_TCOE.SQL
PURPOSE..........: Gera arquivos TCOE (Arquivos de Remessa) com os CDRs de clientes "não GVT" que utilizaram o CSP 25.
DATA BASE........: PBCT1
USER.............: COBILLING
periodicity......: 
CALLED BY........: pl_gera_arq_tcoe.sh
EXTERNAL CALLS...: 
ASK PARAMETER....: não
READ FILES.......: não
WRITE FILES......: yes,  How Many? 1 (log)

-----------------------------------------------------------------------------------------------------
VERSÃO  AUTOR:               DATA:       DOC:        RDM       MOTIVO:
------  -------------------- ----------- ----------- --------- --------------------------------------
1.00    Lourena Caetano Lino 12/06/2003                        Desenvolvimento (solicitado pelo José Ricardo Moro)
1.00    Ícaro                22/12/2005                        Alteração da Sequence
1.00    Ícaro                26/12/2005                        EOT 142 para móvel
1.00    Ícaro                13/03/2007                        Adição do status 'V'
1.01    g0010388 Valter      06/04/2015  PROB924077  RDM18328  Não permitir que a PL gere arquivo vazio. Adequações gerais.
1.02    g0023421 Aurelio     16/06/2015              RDM21802  Zera a variavel i_valor_cdr toda vez que é gerado um novo arquivo.
                                                               Gera um arquivo para cada EOT de cada operadora separadamente.
---------------------------------------------------------------------------------------------------- */
iUltima_RDM                   varchar2(030) := 'RDM21802, 16/06/2015';

------------------------------
iPrograma                     varchar2(060) := 'pl_gera_arq_tcoe';
iInterface                    varchar2(002) := 'E';
------------------------------
------------------- ARQUIVO DE LOG
------------------------------
file_dir_log                  varchar2(250) := 'GVT_COBILLING_LOG';
file_name_log                 varchar2(250) := 'iPrograma' ||'_'||to_char(sysdate,'yyyymmdd_hh24miss')||'.log';
file_type_log                 UTL_FILE.FILE_TYPE;
------------------------------
------------------- ARQUIVO DE LOG
------------------------------
file_dir_tcoe                 varchar2(250) := 'GVT_COBILLING_LOG';
file_name_tcoe                varchar2(250) ;
file_type_tcoe                UTL_FILE.FILE_TYPE;
------------------------------
------------------- ARQUIVO DE LOG
------------------------------
APELIDO_OPERADORA             varchar2(030)  := 'VIVO';
Parametro_Operadora           varchar2(1000) := ' ';
------------------------------
------------------- VARIÁVEIS PADRÕES
------------------------------
Time                          date := sysdate; -- data e hora de inicio da rotina.
Timing                        date := sysdate;
iLocal                        varchar2(254);   -- registro do local que a rotina executa.
data_base                     varchar2(150) := DBMS_REPUTIL.GLOBAL_NAME();  -- nome da instância do banco de dados.
Exception_Stop                Exception;  pragma exception_init(Exception_Stop,   -20911);  -- exceção que finaliza a PL.
Exception_GoOn                Exception;  pragma exception_init(Exception_GoOn,   -20912);  -- exceção que não finaliza a PL.
Exception_Nmsg                Exception;  pragma exception_init(Exception_Nmsg,   -20913);  -- exceção que finaliza a PL, e não emite mais mensagem de erro.
iSeq_arq_log                  number  (010) := 0;
iSeq_con_erro                 number  (010) := 0;
------------------------------
------------------- QUANTIDADES
------------------------------
i_qt_Read                     number  (008) := 0;     -- Quantidade total de CDRs Lidos
i_qt_Read_total               number  (008) := 0;     -- Quantidade total de CDRs Lidos (total)
i_qt_Write_arquivo            number  (008) := 0;     -- Quantidade total de CDRs inseridos no arquivo TCOE
i_qt_Write_arquivo_total      number  (008) := 0;     -- Quantidade total de CDRs inseridos no arquivo TCOE (total)
i_qt_Write_tabela             number  (008) := 0;     -- Quantidade total de CDRs inseridos na tabela COBILLING_STATUS
i_qt_Write_tabela_total       number  (008) := 0;     -- Quantidade total de CDRs inseridos na tabela COBILLING_STATUS (total)
i_qt_Error                    number  (008) := 0;     -- Quantidade Erros
i_qt_arq                      number  (008) := 0;     -- Quantidade de Arquivos gerados
i_valor_cdr                   number  (018) := 0;     -- Valor do CDR
------------------------------
------------------------------
OUT                           varchar2(1000);
c_cursor                      SYS_REFCURSOR;
c_menor_trans_dt              date;
c_maior_trans_dt              date;
c_qtde_cdrs                   number  (010);
c_eot_pagadora                varchar2(003);
c_eot_default                 varchar2(003);
------------------------------
------------------------------
v_SQL                         varchar2(5000);
v_eot_default_old            varchar2(003) := 'X';
v_eot_origem                  varchar2(003) := '141';
v_seq_arquivo                 number  (002) := 0;
v_seq_header                  number  (010) := 0;
v_cod_registro                number  (001) ;
------------------------------
------------------------------
v_eota                        varchar2(003);
v_eotb                        varchar2(003);
v_flag_a                      varchar2(001);
v_flag_b                      varchar2(001);
v1_eota                       varchar2(003);
v1_eotb                       varchar2(003);
v1_flag_a                     varchar2(001);
v1_flag_b                     varchar2(001);
v_grupo_horario               number  (001);
v_hora                        number  (002);
v_minuto                      number  (002);
v_segundo                     number  (002);
v_degrau                      char    (002);
v_dur_real_dec                number  (002);
v_origem                      gvt_chamadas_cb.point_origin%TYPE;
v_destino                     gvt_chamadas_cb.point_target%TYPE;
v_cnl_origem                  varchar2(010);
v_cnl_destino                 varchar2(010);
v_area_visitada               varchar2(002);
v_reenv_rejeitado             varchar2(002);
v_referencia_arq              varchar2(035);
dummy                         number  (010);
------------------------------
------------------------------



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
Cursor qCDR
  is
  Select ccb.type_id_usg,
         ccb.point_origin,
         ccb.point_target,
         ccb.trans_dt,
         ccb.rate_period,
         ccb.country_code_target,
         ccb.point_class_orig,
         ccb.point_class_targ,
         ccb.primary_units,
         ccb.rated_units,
         nvl(ccb.amount,0) amount,
         ccb.annotation,
         ccb.lote,
         ccb.status,
         substr(ccb.annotation, 1, 3) cod_natureza,
         substr(ccb.annotation,12, 3) cod_pais,
         guc.swap,
         ccb.msg_id,
         ccb.msg_id2,
         ccb.msg_id_serv,
         ccb.rowid  rowid_ccb
    from gvt_chamadas_cb     ccb,
         (select swap, type_id_usg from gvt_usos_cobilling) guc
   where ccb.status = 'N'
     and ccb.eot_pagadora = c_eot_pagadora
     and substr(annotation,1,3) not in ( '---','   ')
     and trans_dt > sysdate - 45 -- conforme prazo contratual
     and guc.type_id_usg(+) = ccb.type_id_usg
     and tracking_id not in ( Select tracking_id
                                from gvt_chamadas_cb_excecao
                               where ativo = 'S'
                            )
  order by trans_dt;

  r1cdr  qCDR%rowtype;

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
PROCEDURE LOCALIZACAO_ANTERIOR (p_tipo varchar2 default null) IS
BEGIN
  -- Precisa colocar sempre no inicio da procedure "~~ 01"
  if p_tipo is not null then  iLocal := substr(iLocal,1, length(iLocal)-2)||lpad(p_tipo,2,'0') ;
  else                        iLocal := substr(iLocal,1,instr(iLocal,';', -1)-1) ;
  end if;
END LOCALIZACAO_ANTERIOR;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE grava_arq_log( p_tipo varchar2, p_texto varchar2 ) is
BEGIN
  
  if nvl(p_tipo,'TELA') = 'TELA' then
    dbms_output.put_line( substr(p_texto,   1, 250) );
    if    length(p_texto) > 250 then dbms_output.put_line( substr(p_texto, 251, 250) ); 
    elsif length(p_texto) > 500 then dbms_output.put_line( substr(p_texto, 501, 250) );
    end if;
  elsif nvl(p_tipo,'TELA') = 'put' then
    dbms_output.put( substr(p_texto,   1, 250) );
    if    length(p_texto) > 250 then dbms_output.put     ( substr(p_texto, 251, 250) ); 
    elsif length(p_texto) > 500 then dbms_output.put     ( substr(p_texto, 501, 250) );
    end if;
  end if;
  
  IF nvl(p_tipo,'FILE') = 'FILE' THEN
    --Select * from grava_arq_log where programa = 'proc_carrega_faturados' order by time, sequencia;
    --create table grava_arq_log( programa varchar2(50 byte), time date, sequencia number(10), texto varchar2(1000 byte));
    
    --iSeq_arq_log := iSeq_arq_log + 1;      Insert into grava_arq_log values (iPrograma, time, iSeq_arq_log, p_texto);    commit;
    --/*
    IF not UTL_FILE.IS_OPEN(file_type_log) THEN
      file_type_log  := UTL_FILE.fopen (file_dir_log, file_name_log, 'A');
    END IF;
    UTL_FILE.PUT_LINE(file_type_log, CONVERT( p_texto, 'WE8ISO8859P1'));
    utl_file.fflush  (file_type_log);
    --*/
  END IF;
  
Exception
  when others then
    dbms_output.put_line('Erro: Ao imprimir a msg na tela >>> ' || replace(sqlerrm, chr(10), '; ') );
    Raise Exception_Stop;
END grava_arq_log;




--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE CONTROLE ( pStatus varchar2 ) IS
  iTempo varchar2(020);
  iLote  number  (010);
BEGIN
  iTempo := to_char(trunc(sysdate)+(sysdate-Time),'hh24:mi:ss');
  
  if pStatus = 'E' then
    ROLLBACK;
  end if;
  
  Begin
    Execute immediate 'Select sequencia_interfaces_cobilling.NEXTVAL from dual' into iLote;
  Exception when others then
    Select max(nvl(lote,0)) + 1
      into iLote
      from CONTROLE_EXECUCAO_COBILLING;
  End;
  
  --/*
  Begin
    INSERT INTO CONTROLE_EXECUCAO_COBILLING
    (  data_inicio,   data_fim,  interface,   Status,   Rotina,     qtde_lidos,      qtde_reg_processados,      qtde_erros,   lote,   tempo,  msg  ) values
    (  Time,          Sysdate,  iInterface,  pStatus,  iPrograma,  i_qt_Read_total,  i_qt_write_arquivo_total,  i_qt_Error,  iLote,  iTempo,  'RDM.: ' || iUltima_RDM 
       || ';  Operadora.: '||APELIDO_OPERADORA  );
  Exception
    when others then
      grava_arq_log('', 'Erro ao inserir na tabela  [controle_execucao_cobilling] >>> '||replace(sqlerrm, chr(10), '; ') );
  End;
  --*/
  
  ------------------------------------------------------------------------------ INI Relatórios desta PL
  grava_arq_log('', rpad('=',100,'=') );
  grava_arq_log('', '..: '|| to_char(i_qt_Read_total,           '9g999g999') ||'  qtde Total de CDRs Lidos da tabela GVT_CHAMADAS_CB.' );
  grava_arq_log('', '..: '|| to_char(i_qt_Write_arquivo_total,  '9g999g999') ||'  qtde Total de CDRs Gravados no(s) arquivo(s) TCOE.' );
  grava_arq_log('', '..: '|| to_char(i_qt_Write_tabela_total,   '9g999g999') ||'  qtde Total de CDRs Gravados na tabela COBILLING_STATUS.' );
  grava_arq_log('', '..: '|| to_char(i_qt_arq,           '9g999g999') ||'  qtde de Arquivo(s) Gerado(s).' );
  grava_arq_log('', '..: '|| to_char(i_qt_Error,         '9g999g999') ||'  qtde de Problema(s).' );
  ------------------------------------------------------------------------------ FIM Relatórios desta PL

  grava_arq_log('', rpad('=',100,'=') );
  if pStatus = 'E' then
    grava_arq_log('', 'Erro: Ao executar o programa ['||iPrograma||'].');
    grava_arq_log('', 'Local.: '||iLocal );
  end if;
  grava_arq_log('', 'Final....: '||to_char(Sysdate,'dd/mm/yyyy hh24:mi:ss') || '   Duracao..: ' || iTempo );
  
  COMMIT;
  utl_file.fclose(file_type_log);

EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log('', 'Erro ao executar a PU [CONTROLE] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Status.........: '|| pStatus );
    grava_arq_log('', 'Local..........: '|| iLocal );
    Raise_application_error(-20001,'');
END CONTROLE;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
FUNCTION FUNC_VERIF_DUPLICIDADE RETURN NUMBER IS
BEGIN
  iLocal := iLocal||';FUNC_VERIF_DUPLICIDADE~~ 01';
  
  dummy := 0;
    select count(*)
      into dummy
      from cobilling_status
     where assinante_a = r1cdr.point_origin
       and assinante_b = r1cdr.point_target
       and dt_chamada_hora_inicio = r1cdr.trans_dt
       and referencia_arq = v_referencia_arq;

  LOCALIZACAO_ANTERIOR();
  
    Return dummy;
  
EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log ('FILE', 'Erro na execucao da PU [FUNC_VERIF_DUPLICIDADE] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END FUNC_VERIF_DUPLICIDADE;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE GRAVA_LINHA IS
BEGIN
  iLocal := iLocal||';GRAVA_LINHA~~ 01';
  UTL_FILE.PUT_LINE(file_type_tcoe, OUT);
  UTL_FILE.fFLUSH  (file_type_tcoe);
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log ('FILE', 'Erro na execucao da PU [GRAVA_LINHA] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END GRAVA_LINHA;




--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE GRAVA_TRAILLER IS
BEGIN
  iLocal := iLocal||';GRAVA_TRAILLER~~ 01';
  
  out := '9'||
         LPAD(TO_CHAR(i_qt_Read),7,'0')||
         LPAD(i_valor_cdr,15,'0')||'000'||
         RPAD(' ',114,' ');
  
  GRAVA_LINHA;
  
  LOCALIZACAO_ANTERIOR(5);
  
  UTL_FILE.FCLOSE(file_type_tcoe);
      
      
  grava_arq_log('', 'CDRs Lidos da GVT_CHAMADAS_CB......: ' || i_qt_Read );
  grava_arq_log('', 'CDRs Gravados no Arquivo...........: ' || i_qt_Write_arquivo );
  grava_arq_log('', 'CDRs Gravados na COBILLING_STATUS..: ' || i_qt_Write_tabela );
  grava_arq_log('', 'CDRs Valor Total no Trailler ......: ' || i_valor_cdr || '000' );
  
  IF i_qt_Write_arquivo = 0 THEN
      UTL_FILE.FREMOVE(file_dir_tcoe, file_name_tcoe);
    grava_arq_log('', 'ARQUIVO REMOVIDO DO DIRETORIO' );
  ELSE
    
    LOCALIZACAO_ANTERIOR(10);
    
      ------------------------------------------------------------------------------
      -- Atualiza tabela de controle de registros enviados no arquivo de remessa
      
      Begin
        Insert into CONTROLE_ARQUIVO_REMESSA_GCC
           (dt_processamento, dt_menor_cdr, dt_maior_cdr, eot_pagadora, qtde_reg_enviados, vlr_liquido_enviado, status, tipo_arquivo, nome_arquivo, lote)
          VALUES 
           (SYSDATE,
            c_menor_trans_dt,
            c_maior_trans_dt,
            c_eot_default,
            i_qt_Read,
            i_valor_cdr,
            'E',
            'PDR',
            file_name_tcoe,
            r1cdr.lote
           );
      Exception
        when OTHERS then
          grava_arq_log('', 'Erro ao inserir na tabela [CONTROLE_ARQUIVO_REMESSA_GCC]  >>>  '||replace(sqlerrm, chr(10), '; ') );
          raise Exception_Stop;
      End;
      
      LOCALIZACAO_ANTERIOR(15);
      
      ------------------------------------------------------------------------------
      -- Atualização da tabela GVT_SEQUENCIAS_COBILLING
      Begin
        Insert into GVT_SEQUENCIAS_COBILLING
            (sequencia,     arquivo, eot_remessa,        data_referencia)
           VALUES
            (v_seq_arquivo, 'PDR',   c_eot_default, Time);
      Exception
        when OTHERS then
          grava_arq_log('', 'Erro. Ao inserir na tabela [GVT_SEQUENCIAS_COBILLING]  >>>  '||replace(sqlerrm, chr(10), '; ') );
          raise Exception_Stop;
      End;
      
      -------
      COMMIT;
      -------
    END IF;
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log ('FILE', 'Erro na execucao da PU [GRAVA_TRAILLER] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END GRAVA_TRAILLER;




--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE GRAVA_ARQUIVO_TCOE is
BEGIN
  iLocal := iLocal||';GRAVA_ARQUIVO_TCOE~~ 01';
  
  IF    APELIDO_OPERADORA = 'BRT'        THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''TCS'' ';
  
  ELSIF APELIDO_OPERADORA = 'BRT_GSM'    THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''BTC'' ';
  
  ELSIF APELIDO_OPERADORA = 'CLARO'      THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''CLA'' and eot_pagadora not in (''024'',''028'',''430'') ';
  
  ELSIF APELIDO_OPERADORA = 'CTBC'      THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''CTB'' and eot_pagadora in (''025'',''348'',''048'',''144'',''145'',''661'',''355'',''049'',''349'',''143'',''035'',''325'',''649'',''674'',''034'') ';
  
  ELSIF APELIDO_OPERADORA = 'EMBRATEL'   THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''EBT'' and eot_pagadora not in (''183'',''185'',''283'') ';
  
  ELSIF APELIDO_OPERADORA = 'SERCOMTEL'  THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) in (''SCT'', ''STL'') ';
  
  ELSIF APELIDO_OPERADORA = 'TELEFONICA' THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''TLF'' and eot_pagadora not in (''983'',''985'') ';
  
  ELSIF APELIDO_OPERADORA = 'TELEMAR'    THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''TLM'' and eot_pagadora not in (''083'',''085'',''383'',''385'') ';
  
  ELSIF APELIDO_OPERADORA = 'TIM'        THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''TIM'' and eot_pagadora <> ''088'' ';
  
  ELSIF APELIDO_OPERADORA = 'VIVO'       THEN
    Parametro_Operadora  := 'and substr(external_id,1,3) = ''VIV'' and eot_pagadora not in (''015'',''453'',''455'') ';
    
  ELSE
    Parametro_Operadora  := 'and 1=2 ';
  END IF;
  
  LOCALIZACAO_ANTERIOR(5);
  
  IF Parametro_Operadora = 'and 1=2 ' THEN
    grava_arq_log('', 'PARAMETRO OPERADORA..: #### NAO INFORMADO ####' );
  ELSE
    grava_arq_log('', 'PARAMETRO OPERADORA..: ' || Parametro_Operadora );
  END IF;

  LOCALIZACAO_ANTERIOR(10);
  
  ------------------------------------------------------------------------------
  v_SQL := 'Select min(trans_dt)  menor_trans_dt, '||
                    'max(trans_dt)  maior_trans_dt, '||
                    'count(1)       qtde, '||
                    'eot_pagadora, '||
 -- RDM21802   'case '''||APELIDO_OPERADORA||''' when ''TELEFONICA'' then ''011''  when ''EMBRATEL'' then ''001'' else eot_pagadora end  eot_default '||
               'eot_pagadora eot_default'  ||
              'from gvt_chamadas_cb '||
              'where status = ''N'' '||
                     Parametro_Operadora ||
                'and substr(annotation,1,3) not in ( ''---'',''   '') '||
                'and trans_dt > sysdate - 45 '||-- conforme prazo contratual
                'and tracking_id not in ( Select tracking_id  from gvt_chamadas_cb_excecao where ativo = ''S'' ) '||
               'group by eot_pagadora, eot_pagadora' ;
-- RDM21802 'case '''||APELIDO_OPERADORA||''' when ''TELEFONICA'' then ''011''  when ''EMBRATEL'' then ''001'' else eot_pagadora end';
  
  LOCALIZACAO_ANTERIOR(15);
  
  dbms_output.put_line (v_SQL);
  
  ------------------------------------------------------------------------------
  -- HEADER
  
  --FOR rEOT in qEOT LOOP
  Begin
    OPEN c_cursor FOR v_SQL;
  Exception
    when others then
      grava_arq_log('', rpad('=',100,'=') );
      grava_arq_log('', '############## Erro ao abrir o cursor dinamico [v_SQL] >>> '||replace(sqlerrm, chr(10), '; ') );
      raise Exception_Stop;
  End;
  
  LOOP
    FETCH c_cursor INTO   c_menor_trans_dt,  c_maior_trans_dt,  c_qtde_cdrs,  c_eot_pagadora,  c_eot_default;
    
    EXIT WHEN c_cursor%NOTFOUND;
    
    LOCALIZACAO_ANTERIOR(20);
    
    ----------------------------------------------------------------------------
    -- TRAILLER / HEADER
    
    IF v_eot_default_old <> c_eot_default  THEN
      
      IF v_eot_default_old <> 'X' THEN
        GRAVA_TRAILLER;
      END IF;
      
      i_valor_cdr        := 0; -- RDM21802
      i_qt_Read          := 0;
      i_qt_Write_arquivo := 0;
      i_qt_Write_tabela  := 0;
      
      v_eot_default_old := c_eot_default;
      
      grava_arq_log('', rpad('-',100,'-') );
      grava_arq_log('', 'EOT PAGADORA...: ' || c_eot_pagadora || '              QUANTIDADE NO REGISTRO HEADER..: ' || c_qtde_cdrs );
      grava_arq_log('', 'EOT DEFAULT....: ' || c_eot_default );
    
      LOCALIZACAO_ANTERIOR(25);
      
      ------------------------------------------------------------------------
      -- SEQUENCIA DO NOME DO ARQUIVO
      Begin
        Select nvl(max(sequencia),0)+1
          into v_seq_arquivo
          from gvt_sequencias_cobilling
         where arquivo = 'PDR'
           and eot_remessa = c_eot_default
           and trunc(data_referencia) = trunc(Time);
      Exception
        when OTHERS then
          grava_arq_log('', 'Ao buscar o sequencial do arquivo na tabela [GVT_SEQUENCIAS_COBILLING] >>> '||replace(sqlerrm, chr(10), '; ') );
          raise Exception_Stop;
      End;
  
      LOCALIZACAO_ANTERIOR(30);
      
      ------------------------------------------------------------------------
      -- SEQUENCIA DO HEADER
      
      -- v_seq_header := 1;
      --/*
      Begin
        IF    APELIDO_OPERADORA = 'BRT'        THEN  Select COBILLING.SQ_COBILLING_REMESSA_BRT.NEXTVAL         into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'BRT_GSM'    THEN  Select COBILLING.SEQ_COBILLING_REMESSA_BRT_GSM.NEXTVAL    into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'CLARO'      THEN  Select COBILLING.SQ_COBILLING_REMESSA_CLARO.NEXTVAL       into v_seq_header   from dual;
          v_seq_arquivo := 1;
  
        ELSIF APELIDO_OPERADORA = 'CTBC'       THEN  Select COBILLING.SQ_COBILLING_REMESSA_CTBC.NEXTVAL        into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'EMBRATEL'   THEN  Select COBILLING.SQ_COBILLING_REMESSA_EMBRATEL.NEXTVAL    into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'SERCOMTEL'  THEN  Select COBILLING.SQ_COBILLING_REMESSA_SERCOMTEL.NEXTVAL   into v_seq_header   from dual;
          if v_eot_default_old = '043' then -- SE MÓVEL ATRIBUI EOT 142
            v_eot_origem := '142';
          end if;
        ELSIF APELIDO_OPERADORA = 'TELEFONICA' THEN  Select COBILLING.SQ_COBILLING_REMESSA_TLF.NEXTVAL         into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'TELEMAR'    THEN  Select COBILLING.SQ_COBILLING_REMESSA_TLM.NEXTVAL         into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'TIM'        THEN  Select COBILLING.SQ_COBILLING_REMESSA_TIM.NEXTVAL         into v_seq_header   from dual;
        ELSIF APELIDO_OPERADORA = 'VIVO'       THEN  Select COBILLING.SQ_COBILLING_REMESSA_VIVO.NEXTVAL        into v_seq_header   from dual;
          v_seq_arquivo := 1;
        ELSE
          grava_arq_log('', 'Erro ao buscar o sequencial do Header. O Sequencial nao existe ou nao foi declarado na PL.' );
          raise Exception_Stop;
            
        END IF;
      Exception
        when OTHERS then
          grava_arq_log('', 'Erro ao buscar o sequencial do Header na sequence [SQ_COBILLING_REMESSA_...] >>> '||replace(sqlerrm, chr(10), '; ') );
          raise Exception_Stop;
      End;
      
      LOCALIZACAO_ANTERIOR(35);
      
      --------------------------------------------------------------------------
      -- NOME DO ARQUIVO
      
      file_name_tcoe := 'TCOE.T'
                     || v_eot_origem
                     || c_eot_default
                     || '.S' || lpad(v_seq_arquivo,2,'0')
                     || '.D' || to_char(Time,'ddmmyy') 
                     || '.H' || to_char(Time,'hh24miss')
                     || '.NC';
      
      LOCALIZACAO_ANTERIOR(40);
      
      --------------------------------------------------------------------------
      -- ABRE O ARQUIVO
      
      file_type_tcoe := UTL_FILE.FOPEN(file_dir_tcoe, file_name_tcoe, 'W');
      grava_arq_log('', 'ARQUIVO........: ' || file_name_tcoe );
      i_qt_arq := i_qt_arq + 1;
      
      --------------------------------------------------------------------------
      -- HEADER
      OUT := '0'
          ||  v_eot_origem
          ||  c_eot_default
          ||  to_char(Time,'ddmmyyyy')
          ||  to_char(Time,'hh24miss')
          ||  to_char(c_menor_trans_dt,'ddmmyyyy')
          ||  to_char(c_maior_trans_dt,'ddmmyyyy')
          ||  lpad(v_seq_header,6,0)
          ||  RPAD(' ',97,' ');
      
      GRAVA_LINHA;
      
    END IF;
    
    
    LOCALIZACAO_ANTERIOR(50);
    
    ----------------------------------------------------------------------------
    -- DETAIL
    FOR rCDR in qCDR  Loop
      BEGIN
          i_qt_Read        := i_qt_Read        + 1;
          i_qt_Read_Total  := i_qt_Read_Total  + 1;
-- RDM21802          i_valor_cdr      := i_valor_cdr      + rcdr.amount;
          
          LOCALIZACAO_ANTERIOR(55);
          
          --------------------------------------------------------------------------
          -- CODIGO DO REGISTRO
          -- “1” para chamadas nacionais
          -- “2” para chamadas internacionais
          if rcdr.country_code_target = 0 then  v_cod_registro := 1;
          else                                  v_cod_registro := 2;
          end if;
          
          --------------------------------------------------------------------------
          -- GRUPO HORARIO
          -- 1 – Normal
          -- 2 – Reduzido
          -- 3 – Super-reduzido
          -- 4 – Misto (chamada que começa em um grupo-horário e termina em outro)
          -- 5 – Diferenciado
    
          if    rcdr.rate_period = 'N' then  v_grupo_horario := 1;
          elsif rcdr.rate_period = 'R' then  v_grupo_horario := 2;
          else                               v_grupo_horario := 4;
          end if;
          
          --------------------------------------------------------------------------
          -- CÓDIGO DE REFATURAMENTO
          -- A prestadora de origem utilizará estas posições para identificar os seguintes reenvios: 
          -- “RC” - refaturamento de contestação
          -- “RR” – reenvio de rejeição
          -- “RD” – reenvio de desistência do faturamento conjunto
    
          if rcdr.status = 'V' then  v_reenv_rejeitado := 'RR'; -- (VALTER 06/04/2015) este Status não existe.
          else                       v_reenv_rejeitado := '  ';
          end if;  
          
          LOCALIZACAO_ANTERIOR(60);
          
          --------------------------------------------------------------------------
          -- DURAÇÃO TARIFADA com uma casa decimal – MMMMD
          
          v_hora          := trunc(rcdr.primary_units/3600);
          v_minuto        := trunc((rcdr.primary_units - (v_hora*3600))/60);
          v_segundo       := trunc(rcdr.primary_units - ((v_hora*3600)+(v_minuto*60)));
          
          LOCALIZACAO_ANTERIOR(65);
          
          --------------------------------------------------------------------------
          -- EOT
          v1_eota         := substr(rcdr.annotation,4,3);
          v1_eotb         := substr(rcdr.annotation,8,3);
          
          --------------------------------------------------------------------------
          -- MÓVEL ou FIXO
          v1_flag_a       := substr(rcdr.annotation,7,1);
          v1_flag_b       := substr(rcdr.annotation,11,1);
          
          --------------------------------------------------------------------------
          -- CÓDIGO NACIONAL DA ÁREA VISITADA
          -- Código Nacional da área visitada pelo assinante em roaming.
          -- Se o código de natureza da chamada representa um chamada originada em Roaming, então o campo NÃO pode vir com zeros. 
          -- Se o código de natureza da chamada representa um chamada NÃO originada em Roaming, então o campo DEVE obrigatoriamente vir preenchido com zeros.
    
          v_area_visitada := substr(rcdr.annotation,15,2);
          
          if v_area_visitada = substr(rcdr.point_origin,1,2)   or   v_area_visitada = '  ' then
            v_area_visitada := '00';
          end if;
          
          --------------------------------------------------------------------------
          -- DURAÇÃO REAL
          if rcdr.rated_units < 10 then
            rcdr.rated_units := 10;
          end if;
          
          v_dur_real_dec := ((rcdr.rated_units/10) - TRUNC(rcdr.rated_units/10)) * 10;
          
          LOCALIZACAO_ANTERIOR(70);
          
          --------------------------------------------------------------------------
          -- Verifica se o USO é a cobrar
          if rcdr.swap = 'S' then
            v_origem      := rcdr.point_target;
            v_destino     := rcdr.point_origin;
            v_cnl_origem  := rcdr.point_class_targ;
            v_cnl_destino := rcdr.point_class_orig;
            v_eota        := v1_eotb;
            v_flag_a      := v1_flag_b;
            v_eotb        := v1_eota;
            v_flag_b      := v1_flag_a;
          else
            v_origem      := rcdr.point_origin;
            v_destino     := rcdr.point_target;
            v_cnl_origem  := rcdr.point_class_orig;
            v_cnl_destino := rcdr.point_class_targ;
            v_eota        := v1_eota;
            v_flag_a      := v1_flag_a;
            v_eotb        := v1_eotb;
            v_flag_b      := v1_flag_b;
          end if;
          
          LOCALIZACAO_ANTERIOR(75);
          
          --------------------------------------------------------------------------
          -- CNL
          -- Se o telefone origem for Móvel
          if v_flag_a = 'M'   AND   SUBSTR(v_cnl_origem, 1,3) = '999' then  v_cnl_origem := '000'||SUBSTR(v_cnl_origem,4,2);
          end if;
          
          -- Se o telefone destino for Móvel
          if v_flag_b = 'M'   AND   SUBSTR(v_cnl_destino,1,3) = '999' then  v_cnl_destino := '000'||SUBSTR(v_cnl_destino,4,2);
          end if;
          
          --------------------------------------------------------------------------
          -- DEGRAU
          -- Telefonia fixa: 01, 02, 03, 04
          -- Telefonia Móvel: 02(VC2), 03(VC3)
          -- Caso não exista diferenciação de tarifas por degrau, utilizar o padrão 99
          /*
          if    v_flag_a = 'F' AND  v_flag_b <> 'M'               then  v_degrau := '99'; -- 
          elsif v_flag_a = 'M' AND  rcdr.country_code_target <> 0 then  v_degrau := '99'; -- 
          elsif substr(v_origem,1,1) <> substr(v_destino,1,1)     then  v_degrau := '03'; -- 
          else                                                          v_degrau := '02'; -- 
          end if;
          --*/
          
          v_degrau := '99';
          IF v_cod_registro = 1 and (v_flag_b='M' or v_flag_a='M') THEN
            IF v_area_visitada = '00' THEN
              IF SUBSTR(v_origem,1,1) = SUBSTR(v_destino,1,1) THEN  v_degrau:='02';
              ELSE                                                  v_degrau:='03';
              END IF;
            ELSE
              IF SUBSTR(v_area_visitada,1,1) = SUBSTR(v_destino,1,1) THEN  v_degrau:='02';
              ELSE                                                         v_degrau:='03';
              END IF;
            END IF;
          END IF;
          
          LOCALIZACAO_ANTERIOR(80);
          
          ------------------------------------------------------------------------
          -- COBILLING_STATUS
  
                v_referencia_arq := substr(file_name_tcoe, 7,6) -- EOT Origem e Destino
                                 || substr(file_name_tcoe,19,6) -- Data
                                 || substr(file_name_tcoe,16,1);-- Sequencial
          
          IF ( FUNC_VERIF_DUPLICIDADE > 0 ) THEN
              grava_arq_log('', 'CDR duplicado na tabela [COBILLING_STATUS].  msg_id ['||rcdr.msg_id||']  msg_id2 ['||rcdr.msg_id2||']  msg_id_serv ['||rcdr.msg_id_serv||']' );
                  raise Exception_GoOn;
              END IF;
          
          LOCALIZACAO_ANTERIOR(85);
          
          Begin
              INSERT INTO COBILLING_STATUS
                  ( CDR_ID, DSNAME, REFERENCIA_ARQ, SEQUENCIAL, COD_NATUREZA, EOT_ORIGEM, EOT_DESTINO, ASSINANTE_A, CNL_ORIGEM, 
                    COD_PAIS, ASSINANTE_B, CNL_DESTINO, DT_CHAMADA_HORA_INICIO, DURACAO_REAL, DURACAO_TARIFADA, GRUPO_HORARIO, 
                    VALOR, COD_REFATURAMENTO, DT_ENVIO, ENVIADO, ULTIMO_STATUS, DT_ULTIMO_STATUS
                  )
                  VALUES
                  ( 
                            SQ_COBILLING_STATUS.NEXTVAL, ---------- CDR_ID
                            substr(file_name_tcoe, 6, 31), -------- DSNAME
                            v_referencia_arq, --------------------- REFERENCIA_ARQ
                            i_qt_Read,  --------------------------- CDR_ID
                            rcdr.cod_natureza, -------------------- COD_NATUREZA
                            nvl(trim(RPAD(v_eota,3,'0')),'000'), -- EOT_ORIGEM
                            nvl(trim(RPAD(v_eotb,3,'0')),'000'), -- EOT_DESTINO
                            RTRIM(v_origem),  --------------------- ASSINANTE_A
                            SUBSTR(v_cnl_origem,1,5),  ------------ CNL_ORIGEM
                            rcdr.cod_pais,  ----------------------- COD_PAIS
                            RTRIM(v_destino),  -------------------- ASSINANTE_B
                            SUBSTR(v_cnl_destino,1,5), ------------ CNL_DESTINO
                            rcdr.trans_dt, ------------------------ DT_CHAMADA_HORA_INICIO
                            LTRIM(TO_CHAR(v_hora,'00')) || LTRIM(TO_CHAR(v_minuto,'00')) || LTRIM(TO_CHAR(v_segundo,'00')), -- DURACAO_REAL
                            LPAD(TO_CHAR(TRUNC(rcdr.rated_units/10)),4,'0') || v_dur_real_dec, -- DURACAO_TARIFADA
                            v_grupo_horario, ---------------------- GRUPO_HORARIO
                            rcdr.amount, -------------------------- VALOR
                            v_reenv_rejeitado, -------------------- COD_REFATURAMENTO
                            Time, --------------------------------- DT_ENVIO
                            'S', ---------------------------------- ENVIADO
                            '0', ---------------------------------- ULTIMO_STATUS
                            Time ---------------------------------- DT_ULTIMO_STATUS
                          );
                  
                  i_qt_Write_tabela       := i_qt_Write_tabela       + 1;
                  i_qt_Write_tabela_total := i_qt_Write_tabela_total + 1;
          Exception
            When others then
              grava_arq_log('', 'Erro. Ao inserir na tabela [COBILLING_STATUS]  msg_id ['||rcdr.msg_id||'] msg_id2 ['||rcdr.msg_id2||']  msg_id_serv ['||rcdr.msg_id_serv||']  >>>  '||replace(sqlerrm, chr(10), '; ') );
              raise Exception_GoOn;
          End;
          
          LOCALIZACAO_ANTERIOR(90);

          ---------------------------------------------------------------------------
          -- TCOE DETAIL                                                TAMANHO  POSICAO--
          OUT :=  v_cod_registro                                  || -- 01        01 a  01  CODIGO REGISTRO
                  LPAD(rcdr.cod_natureza,3,'0')                   || -- 03        02 a  04  CODIGO NATUREZA
                  nvl(trim(RPAD(v_eota,3,'0')),'000')             || -- 03        05 a  07  EOT ORIGEM
                  nvl(trim(RPAD(v_eotb,3,'0')),'000')             || -- 03        08 a  10  EOT DESTINO
                  RPAD(RTRIM(v_origem),21,' ')                    || -- 21        11 a  31  ASSINANTE A
                  SUBSTR(v_cnl_origem,1,5)                        || -- 05        32 a  36  CNL ORIGEM
                  '25'                                            || -- 02        37 a  38  CSP
                  RPAD(NVL(rcdr.cod_pais,' '),3,' ')              || -- 03        39 a  41  COD PAIS
                  RPAD(RTRIM(v_destino),21,' ')                   || -- 21        42 a  62  ASSINANTE B
                  SUBSTR(v_cnl_destino,1,5)                       || -- 05        63 a  67  CNL DESTINO
                  TO_CHAR(rcdr.trans_dt,'DDMMYYYY')               || -- 08        68 a  75  DATA CHAMADA
                  TO_CHAR(rcdr.trans_dt,'HH24MISS')               || -- 06        76 a  81  HORA CHAMADA
                  LTRIM(TO_CHAR(v_hora,'00'))                     || -- 06        82 a  87  DURACAO REAL
                  LTRIM(TO_CHAR(v_minuto,'00'))                   || --                     DURACAO REAL
                  LTRIM(TO_CHAR(v_segundo,'00'))                  || --                     DURACAO REAL
                  LPAD(TO_CHAR(TRUNC(rcdr.rated_units/10)),4,'0') || -- 05        88 a  92  DURACAO TARIFADA
                  v_dur_real_dec                                  || --                     DURACAO TARIFADA
                  TO_CHAR(v_grupo_horario)                        || -- 01        93 a  93  GRUPO HORARIO
                  v_degrau                                        || -- 02        94 a  95  DEGRAU
                  LPAD(nvl(trim(v_area_visitada),0),2,'0')        || -- 02        96 a  97  COD NACIONAL DA AREA VISITADA
                  LPAD(rcdr.amount,7,'0')||'000'                  || -- 10        98 a 107  VALOR
                  LPAD(v_reenv_rejeitado, 2,' ')                  || -- 02       108 a 109  COD REFATURAMENTO
                  LTRIM(TO_CHAR(i_qt_Read,'0000000'))             || -- 07       110 a 116  IDENTIF. REGISTRO NO LOTE
                  RPAD(' ',24,' ')                                   -- 24       117 a 140  FILLER
                  ;
          
          IF LENGTH(OUT) <> 140 THEN
              grava_arq_log('', 'A Linha detail abaixo nao possui 140 caracteres.  msg_id ['||rcdr.msg_id||']  msg_id2 ['||rcdr.msg_id2||']  msg_id_serv ['||rcdr.msg_id_serv||']' );
              grava_arq_log('', OUT );
              raise Exception_GoOn;
          ELSIF substr(out, 116, 1) not in ('0','1','2','3','4','5','6','7','8','9') THEN
              grava_arq_log('', 'O campo "Identificador do Registro no Lote" esta desposicionado.  msg_id ['||rcdr.msg_id||']  msg_id2 ['||rcdr.msg_id2||']  msg_id_serv ['||rcdr.msg_id_serv||']' );
              grava_arq_log('', OUT );
              raise Exception_GoOn;
          END IF;
          
          GRAVA_LINHA;
          
          i_valor_cdr      := i_valor_cdr      + rcdr.amount; --RDM21802    
          LOCALIZACAO_ANTERIOR(95);
          
          --------------------------------------------------------------------------
          -- Atualiza gvt_chamadas_cb
          Begin
            Update gvt_chamadas_cb
               set status = 'E',
                   nome_arq_remessa = file_name_tcoe
             where rowid = rcdr.rowid_ccb;
             
             i_qt_Write_arquivo       := i_qt_Write_arquivo       + 1;
             i_qt_Write_arquivo_Total := i_qt_Write_arquivo_Total + 1;
          Exception
            When others then
              grava_arq_log('', 'Erro. Ao atualizar o status na tabela [GVT_CHAMADAS_CB]  msg_id ['||rcdr.msg_id||'] msg_id2 ['||rcdr.msg_id2||']  msg_id_serv ['||rcdr.msg_id_serv||']  >>>  '||replace(sqlerrm, chr(10), '; ') );
              raise Exception_Stop;
          End;
          
        EXCEPTION
            when Exception_GoOn THEN
            null;
          when others THEN
            grava_arq_log('', 'Erro. No cursor [qCDR]  msg_id ['||rcdr.msg_id||'] msg_id2 ['||rcdr.msg_id2||']  msg_id_serv ['||rcdr.msg_id_serv||']  >>>  '||replace(sqlerrm, chr(10), '; ') );
            raise;
        END;
      
      LOCALIZACAO_ANTERIOR(100);
      
    END LOOP qCDR;
    
  END LOOP;
  
  LOCALIZACAO_ANTERIOR(105);
  
  IF i_qt_Read > 0 THEN
    GRAVA_TRAILLER;
  END IF;
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log ('FILE', 'Erro na execucao da PU [GRAVA_TABELA_CB] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END GRAVA_ARQUIVO_TCOE;





--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ I N I C I O ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
BEGIN
  iLocal    := 'INICIO: 000';
  
  grava_arq_log('', rpad('=',100,'=') );
  grava_arq_log('', 'PROGRAMA.......: ' || iPrograma );
  grava_arq_log('', 'INICIO.........: ' || to_char(Time,'dd/mm/yyyy hh24:mi:ss') );
  grava_arq_log('', 'DIR. LOG.......: ' || file_dir_log );
  grava_arq_log('', 'ARQ. LOG.......: ' || file_name_log );
  grava_arq_log('', 'DIR. TCOE......: ' || file_dir_tcoe );
  grava_arq_log('', 'OPERADORA......: ' || nvl(trim(APELIDO_OPERADORA),'#### NAO INFORMADO ####') );
  grava_arq_log('', rpad('-',100,'-') );
  
  iLocal    := 'INICIO: 010';  GRAVA_ARQUIVO_TCOE;
  iLocal    := 'INICIO: 999';
  
  CONTROLE ( 'S' );

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    grava_arq_log('', 'Erro na execucao da PL ['||iPrograma||'.sql] >>> '||replace(sqlerrm, chr(10), '; ') );
    i_qt_Error := i_qt_Error + 1;
    CONTROLE ( 'E' );
END;
/
