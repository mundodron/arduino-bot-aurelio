CREATE OR REPLACE procedure GRCOWN.PROC_CARGA_SP
  ( p_nome_arquivo  VARCHAR2 )  IS


-- NAME.............: PROC_CARGA_SP
-- PURPOSE..........: Validar as chamadas dos arquivos REM.TCOE.T (recebidas das operadoras e tarifadas na Mediação) e gravar no GRC.
-- DATA BASE........: PBCT1
-- USER.............: GRCOWN

/*
-----------------------------------------------------------------------------------------------------
VERSÃO  AUTOR:               DATA:       DOC:        RDM       MOTIVO:
------  -------------------- ----------- ----------- --------- --------------------------------------
 1.0    Pablo                21/07/01    RFC55948              Criação.
 1.1    Patrícia             01/08/01                          Alteração do procedimento.
 1.2    Valter Rogério       22/02/12    RFC346359             Alguns arquivos tarifados na Mediação (REM.TCOE) estão com o nome de Lote errado.
                                                               A equipe não encontrou erro no fonte.
                                                               Como contenção, esta PL vai gravar o nome do arquivo lido.
 1.3    Valter Rogério       04/10/13    PROB1080              Gravar o nome do arquivo TCOE com Hora da geracao.
 1.4    Valter Rogério       01/10/14    PROB362337  RDM5979   Acrescentado a rotina de Rejeição de chamadas Sobrepostas.
 1.5    Valter Rogério       13/10/14    PROB715715  RDM12205  Implementado uma validação para duplicidade de "sequencial_chave", pois há muitos arquivos antigos que estão carrregando.
 1.6    Valter Rogério       10/11/14    PROB713192  RDM12140  Gravar o nome do arquivo TCOE na tabela controle_execução_cobilling
 1.7    Aurelio Avanzi       26/01/15    INC810202             Na procedure proc_carga_sp, corrigir o valor da duração Real, para que a Rotina de Sobreposição considerando a duração real, e não mais a tarifada.
                                                               Fazer com que o campo grc_servicos_prestados.eot receba o nome do arquivo REM.TCOE... (completo).
                                                               Criada a variavel duracao_erro que recebe a duaração sem conversão para gravar na tabela erros_bmp.
 1.8    Aurelio Avanzi       02/03/15    INC810202   RDM16483  Correção no formato de data e validação no status da grc_motivos_de_para
----------------------------------------------------------------------------------------------------


*/
iUltima_RDM        varchar2(20) := 'RDM16483,v02.03.2015';
-------------------
iPrograma          varchar2(60) := 'proc_carga_sp';
iInterface         varchar2(02) := 'AF';
-------------------
file_dir_log       varchar2(250) := 'GVT_COBILLING_LOG';
file_name_log      varchar2(250) := 'BMP_OK_'||p_nome_arquivo||'.log';  -- Nome do arquivo de log --
file_type_log      UTL_FILE.FILE_TYPE;

file_dir_bmp       varchar2(250);  -- Diretório do arquivo de log --
file_name_tcoe      varchar2(250) := p_nome_arquivo;  -- Nome do arquivo de log --
file_type_bmp      UTL_FILE.FILE_TYPE;
-------------------
Time               date := sysdate; -- data e hora de inicio da rotina.
iTempo             varchar2(100);   -- duração da execução da rotina.
iLocal             varchar2(254);   -- registro do local que a rotina executa.
data_base          varchar2(150) := DBMS_REPUTIL.GLOBAL_NAME();  -- nome da instância do banco de dados.
Exception_Stop     Exception;  pragma exception_init(Exception_Stop,   -20911);  -- exceção que finaliza a PL.
Exception_GoOn     Exception;  pragma exception_init(Exception_GoOn,   -20912);  -- exceção que não finaliza a PL.
iMsg_Oracle        varchar2(500) := null; -- mostra a mensagem na tela ou no arquivo de log.
iSeq_Erro          number  (006) := 0;    -- Sequencial da ocorrência do erro
iNro_Lote          number  (010) := 1;    -- Numero do lote.
-------------------
-- Definição das Variáveis:
v_tipo_registro     VARCHAR2(1);
v_sp                GRC_SERVICOS_PRESTADOS%ROWTYPE;
duracao_erro        NUMBER (10);
v_regs_lote         NUMBER(10);  -- Nro de registros informados no trailler do arquivo
v_valor_lote        NUMBER(10);  -- Valor dos registros informados no trailler do arquivo
v_valor_total_lote  NUMBER(20, 5) := 0; -- calculados no procedimento para efeito de verificacao c/ o valor informado
v_linha_arq         VARCHAR2(400);
v_nro_detail        NUMBER(10) := 0;
v_nro_gravados      NUMBER(10) := 0;
v_nro_erros         NUMBER(10) := 0;
v_nro_a_faturar     NUMBER(10) := 0;   -- Qtde de registros a faturar   STATUS (AF).
v_nro_desprezados   NUMBER(10) := 0;   -- Qtde de registros desprezados STATUS (DE).
v_nro_pendente      NUMBER(10) := 0;   -- Qtde de registros Pendentes   STATUS (P).
v_nro_duplicado     NUMBER(10) := 0;   -- Qtde de registros duplicados.
v_obs               GRC_INTERFACES.OBS%TYPE;
v_nro_linha         number(8) := 0;
i_qt_sobreposta     NUMBER(9) := 0;
v_reg_9             char(1) := 'N';
roda_uma_vez_1      boolean := true;
roda_uma_vez_2      boolean := true;
roda_uma_vez_3      boolean := true;
qt_unique_contraint number(10) := 0;
-------------------
Achou_Sequencial_na_GSP  number(1);
Achou_Sequencial_na_GEB  number(1);
qtde_Sequencial_na_GSP   number(10) := 0;
qtde_Sequencial_na_GEB   number(10) := 0;
-------------------

----------------------------------------------------------------------------------------------------
-- Busca o diretório para gravar arquivos de LOG.
Cursor qDIR
is
SELECT dir_unix  FROM grc_processos WHERE processo = 'LOG';

----------------------------------------------------------------------------------------------------
-- Busca o diretório para gravar arquivos de ERROS.
Cursor qDIR_BMP
is
SELECT dir_unix  FROM grc_processos WHERE processo = 'CAR';

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
FUNCTION get_motivo(motivo IN varchar2, parceiro IN varchar2, status IN varchar2) 
   RETURN varchar2
   IS 
   v_ativo varchar2(1);
   BEGIN 
     SELECT ATIVO
       INTO v_ativo 
       FROM grc_motivos_de_para gr 
      WHERE gr.motivo_grc = motivo
        AND rownum = 1
        AND parceiro = parceiro
        AND status_grc = status;
     RETURN(v_ativo);
    END;
    
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷

PROCEDURE LOCALIZACAO_ANTERIOR (p_tipo varchar2 default null) IS
BEGIN
  -- Precisa colocar sempre no inicio da procedure "~~ 01"
  if p_tipo is not null then  iLocal := substr(iLocal,1, length(iLocal)-2)||lpad(p_tipo,2,'0') ;
  else                        iLocal := substr(iLocal,1,instr(iLocal,';', -1)-1) ;
  end if;
END LOCALIZACAO_ANTERIOR;
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷-
PROCEDURE grava_arq_log( p_tipo varchar2, p_texto varchar2 ) is
BEGIN

  if nvl(p_tipo,'TELA') = 'TELA' then
    dbms_output.put_line( substr(p_texto,   1, 250) );
    if    length(p_texto) > 250 then dbms_output.put_line( substr(p_texto, 251, 250) );
    elsif length(p_texto) > 500 then dbms_output.put_line( substr(p_texto, 501, 250) );
    end if;
  elsif p_tipo = 'put' then
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
      file_type_log  := UTL_FILE.fopen (file_dir_log, file_name_log, 'W');
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

  --/*
  Begin
    Execute immediate 'Select sequencia_interfaces_cobilling.NEXTVAL from dual' into iLote;
  Exception when others then
    Select max(lote) + 1    into iLote    from CONTROLE_EXECUCAO_COBILLING ;
  End;
  --*/

  --/*
  Begin
    INSERT INTO CONTROLE_EXECUCAO_COBILLING
    (  data_inicio, data_fim,  interface,   Status,   rotina,     qtde_lidos,   qtde_reg_processados,  qtde_erros,   lote,  tempo,  msg  ) values
    (  Time,        Sysdate,  iInterface,  pStatus,  iPrograma,  v_nro_linha,   v_nro_gravados,        v_nro_erros, iLote, iTempo, 'RDM.: ' || iUltima_RDM||'  ['||file_name_tcoe||']' );
  Exception
    when others then
      grava_arq_log('FILE', 'Erro: Ao inserir na tabela  [controle_execucao_cobilling] >>> '||replace(sqlerrm, chr(10), '; ') );
  End;
  --*/

  ------------------------------------------------------------------------------ INI Relatórios desta PL
  grava_arq_log('FILE', rpad('=',150,'=') || chr(10) || 'RESUMO' );
  grava_arq_log('FILE', 'LINHAS    DETAILS  GRAVADAS  A_FATURAR  DESPREZADA  PENDENTE  REG_9  SOBREPOSTA  VALOR_TOTAL_LOTE  PROBLEMAS  PROBL_CONSTRAINT  CDR.DUPLICADO  SEQ.DUP.GSP  SEQ.DUP.GEB' );
  grava_arq_log('FILE', '--------  -------  --------  ---------  ----------  --------  -----  ----------  ----------------  ---------  ----------------  -------------  -----------  -----------' );
  grava_arq_log('FILE', '_'||lpad(v_nro_linha, 7, ' ')|| lpad(v_nro_detail,9,' ')|| lpad(v_nro_gravados,10,' ')|| lpad(v_nro_a_faturar,11,' ')||
                         lpad(v_nro_desprezados,12,' ')|| lpad(v_nro_pendente,10,' ')|| lpad(v_reg_9,7,' ')|| lpad(i_qt_sobreposta,12,' ')||
                         lpad(v_valor_total_lote,18,' ')|| lpad(v_nro_erros,11,' ')|| lpad(qt_unique_contraint,18,' ')|| lpad(v_nro_duplicado,15,' ')||
                         lpad(qtde_Sequencial_na_GSP,13,' ')|| lpad(qtde_Sequencial_na_GEB,13,' ') );
  grava_arq_log('FILE', rpad('=',150,'=') );
  ------------------------------------------------------------------------------ FIM Relatórios desta PL

  if pStatus = 'E'  OR  v_reg_9 = 'N' then
    grava_arq_log('FILE', 'Erro: Ao executar o programa ['||iPrograma||'].');
    grava_arq_log('FILE', 'Local.: '||iLocal );
    if v_reg_9 = 'N' then
      grava_arq_log('FILE', 'O REGISTRO "TRAILLER" NAO FOI LIDO' );
    end if;
  end if;
  --grava_arq_log('FILE', 'Final....: '||to_char(Sysdate,'dd/mm/yyyy hh24:mi:ss') || '   Duracao..: ' || iTempo );
  --grava_arq_log('FILE', rpad('=',100,'=') );

  ------------
  COMMIT;
  ------------
  --utl_file.fclose(file_type_log);

EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log('', 'Erro: Ao executar a PU [CONTROLE] com o status ['||pStatus||'] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Local.: '|| iLocal );
    Raise_application_error(-20000,'');
END CONTROLE;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE VALIDA_SOBREPOSICAO IS
  iSituacao     varchar2(20);
  --
  Cursor qLote
    is
    Select to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss') inicio_chamada,
           to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss') + 
              NUMTODSINTERVAL(substr(duracao_real,1,2), 'HOUR') +
              NUMTODSINTERVAL(substr(duracao_real,3,2), 'MINUTE') + 
              NUMTODSINTERVAL(substr(duracao_real,5,2), 'SECOND')  fim_chamada,
           substr(duracao_real,1,2)||':'||substr(duracao_real,3,2)||':'||substr(duracao_real,5,2) duracao_chamada,
           rowid,
           sequencial_chave,
           telefone_origem,
           telefone_destino,
           data_servico,
           hora_inicio,
           duracao,
           duracao_real,
           parceiro
      from grc_servicos_prestados
     where lote = substr(file_name_tcoe, instr(file_name_tcoe, 'TCOE'), 32)
       and status = 'AF'
      Order by telefone_origem,
               telefone_destino,
               to_date(to_char(data_servico,'yyyymmdd')||hora_inicio,'yyyymmddhh24:mi:ss');

  old  qLote%rowtype;
BEGIN
  iLocal := iLocal||';VALIDA_SOBREPOSICAO~~ 01';

  FOR new in qLote
  LOOP
      iSituacao := null;

      if old.telefone_origem  = new.telefone_origem  and
         old.telefone_destino = new.telefone_destino and
         (new.inicio_chamada + NUMTODSINTERVAL(5, 'SECOND') ) <= old.fim_chamada  then --- Chorinho de 5 segundos, alinhado com o Reginaldo Fermino e Rafael Fazio (10/10/2014)
          i_qt_sobreposta := i_qt_sobreposta + 1;
          ----------------------------------------------------------------------
          if roda_uma_vez_1 then
             roda_uma_vez_1 := false;
            grava_arq_log('FILE', rpad('=',150,'=') );
            grava_arq_log('FILE', 'CHAMADAS SOBREPOSTAS' );
            grava_arq_log('FILE', 'SITUACAO      INICIO_CHAMADA_A     DURACAO_A    FIM_CHAMADA_A        INICIO_CHAMADA_B     DURACAO_B    ORIGEM        DESTINO       PARCEIRO  SEQUENCIAL_A                    SEQUENCIAL_B');
            grava_arq_log('FILE', '------------  -------------------  -----------  -------------------  -------------------  -----------  ------------  ------------  --------  ------------------------------  ------------------------------');
          end if;
          ---
          UPDATE GRC_SERVICOS_PRESTADOS
             SET STATUS = 'EF',
                 INFORMACAO = ltrim(informacao||'; ', '; ')||'Chamada Sobreposta com o sequencial ('||old.sequencial_chave||').'
           WHERE rowid = new.rowid;
          --
          UPDATE GRC_SERVICOS_PRESTADOS
             SET STATUS = 'RJ',
                 MOTIVO = '361',
                 data_cancelamento = Time
           WHERE rowid = new.rowid;
          ---
          grava_arq_log('FILE', rpad('Sobreposta',14,' ')||
                                rpad(to_char(old.inicio_chamada,'dd/mm/yyyy hh24:mi:ss'),21,' ')||
                                rpad(old.duracao_chamada,13,' ')||
                                rpad(to_char(old.fim_chamada,'dd/mm/yyyy hh24:mi:ss'),21,' ')||
                                rpad(to_char(new.inicio_chamada,'dd/mm/yyyy hh24:mi:ss'),21,' ')||
                                rpad(new.duracao_chamada,13,' ')||
                                rpad(old.telefone_origem,14,' ')||
                                rpad(old.telefone_destino,14,' ')||
                                rpad(old.parceiro,10,' ')||
                                rpad(old.sequencial_chave,32,' ')||
                                rpad(new.sequencial_chave,30,' ')
                       );
      end if;
      old := new;

  END LOOP qLote;

  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN OTHERS THEN
    grava_arq_log('', 'Erro ao executar a PU [VALIDA_SOBREPOSICAO] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE;
END VALIDA_SOBREPOSICAO;




--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE CRITICA_CDR IS
  v_nro_dias_nac   grc_parceiros.nro_dias_nac%type;
  v_nro_dias_inter grc_parceiros.nro_dias_inter%type;
  v_nro_dias_db    grc_parceiros.nro_dias_db%type;
  v_consiste_db    grc_parceiros.consiste_db%type;
  v_data_envio     DATE := NULL;

  -- EXCESSÕES DE USÁRIOS TRATADAS NO PROCEDIMENTO
  EXC_DURACAO            EXCEPTION;
  EXC_VALOR_FATURADO     EXCEPTION;
  EXC_HORA_INICIO        EXCEPTION;
  EXC_DATA_FUTURA        EXCEPTION;
  EXC_SERVICO_CADASTRADO EXCEPTION;
  EXC_SERV_VIGENTE       EXCEPTION;
  EXC_PARCEIRO           EXCEPTION;
  EXC_DUPLICADO          EXCEPTION;
  EXC_DUPLICADO_DB       EXCEPTION;
  EXC_CONSISTE_DB        EXCEPTION;
  EXC_IDADE_CDR          EXCEPTION;
  EXC_PENDENTE           EXCEPTION;

BEGIN

   v_nro_dias_nac   := 0;
   v_nro_dias_inter := 0;
   v_nro_dias_db    := 0;
   v_consiste_db    := 0;

   iLocal := 'Validando da duracao da chamada.';

   IF v_sp.duracao = '00000' THEN
      RAISE EXC_DURACAO;
   END IF;

   iLocal := 'Validando do valor da chamada.';

   IF v_sp.valor_faturado = 0 THEN
      RAISE EXC_VALOR_FATURADO;
   END IF;

   iLocal := 'Validando a hora de inicio da chamada.';

   IF (LENGTH(v_sp.hora_inicio) < 6) OR
      (substr(v_sp.hora_inicio, 1, 2) not between 0 and 23) OR
      (substr(v_sp.hora_inicio, 3, 2) not between 0 and 59) OR
      (substr(v_sp.hora_inicio, 5, 2) not between 0 and 59) THEN
      RAISE EXC_HORA_INICIO;
   END IF;

   iLocal := 'Validando a data futura da chamada.';

   IF v_sp.data_servico > trunc(sysdate) THEN
      RAISE EXC_DATA_FUTURA;
   END IF;

   iLocal := 'Buscando o Parceiro.';

   v_sp.parceiro := FUNC_RETORNA_PARCEIRO(v_sp.csp,
                                          v_sp.sub_csp,
                                          v_sp.data_servico);
   IF v_sp.parceiro IS NULL THEN
      RAISE EXC_PARCEIRO;
   END IF;

   iLocal := 'Validando se o servico esta cadastrado.';

   PROC_VERIFICA_SERVICO(v_sp);
   IF v_sp.status <> 'AF' THEN
      RAISE EXC_SERVICO_CADASTRADO;
   END IF;

   iLocal := 'Validando a duplicidade da chamada.';

   PROC_VERIFICA_DUPLICIDADE(v_sp.parceiro,
                             v_sp.telefone_origem,
                             v_sp.telefone_destino,
                             v_sp.data_servico,
                             v_sp.hora_inicio,
                             v_sp.natureza,
                             v_sp.status,
                             v_sp.seq_chave_relacionado);

   iLocal := 'Validando a idade limite da chamada.';

   Begin
     SELECT NVL(NRO_DIAS_NAC, 45),      NVL(NRO_DIAS_INTER, 90),      NRO_DIAS_DB,         CONSISTE_DB
       INTO v_nro_dias_nac,             v_nro_dias_inter,             v_nro_dias_db,       v_consiste_db
       FROM GRC_PARCEIROS
      WHERE CODIGO = v_sp.parceiro;
   Exception
     When Others then
       null;
   End;

   IF v_sp.status = 'AF' THEN
      IF (TRUNC(Time) - v_sp.data_servico) > v_nro_dias_nac then -- Venceu o tempo limite
         v_sp.status  := 'DE';
         v_sp.motivo  := '125'; -->IDADE DA CHAMADA<<- - INC408737 = Correção do Código de Erro: trocar o "013" por "125";
         RAISE EXC_IDADE_CDR;
      END IF;
      /*
      -- Identificar se é uma chamada nacional ou internacional.
      IF v_sp.pais_destino IS NULL THEN
         -- Chamada Nacional
         IF (TRUNC(SYSDATE) - v_sp.data_servico) > v_nro_dias_nac -- Venceu o tempo limite
          THEN
            RAISE EXC_IDADE_CDR;
         ELSE
            v_sp.status := 'AF'; -- CDR OK
            v_sp.motivo := NULL;
         END IF;
      ELSE
         -- Chamada Internacional
         IF (TRUNC(SYSDATE) - v_sp.data_servico) > v_nro_dias_inter -- Venceu o tempo limite
          THEN
            RAISE EXC_IDADE_CDR;
         ELSE
            v_sp.status := 'AF'; -- CDR OK
            v_sp.motivo := NULL;
         END IF;
      END IF;
      */
   ELSE
      -- Chamada duplicada - Status "DU"
      IF v_sp.cod_contestacao = 'S' Then -- a chamada veio com 'RR', ou seja, deve-se verificar o debito mantido

         iLocal := 'Validando a duplicidade da chamada para Debito Mantido.';

         PROC_VERIFICA_DUPLICIDADE_DB(v_sp.parceiro,
                                      v_sp.telefone_origem,
                                      v_sp.telefone_destino,
                                      v_sp.data_servico,
                                      v_sp.hora_inicio,
                                      v_sp.natureza,
                                      v_sp.status);
         IF v_sp.status <> 'AF' THEN
            -- Chamada enviada como RR mais vezes que o permitido - Status "DE"
            RAISE EXC_DUPLICADO_DB;
         ELSIF v_consiste_db = 'N' Then -- Verifica se o CDR esta consiste_DB
            NULL; -- Pode faturar
         ELSE
            BEGIN
               iLocal := 'Buscando na tabela grc_historicos_serv_prestados a data da Contestacao.';

               SELECT DATA_ENVIO_CONTESTADOS
                 INTO v_data_envio
                 FROM GRC_HISTORICOS_SERV_PRESTADOS
                WHERE SERVICO_PRESTADO = v_sp.seq_chave_relacionado
                  AND STATUS_PARA IN ('RI', 'RP');
               IF (trunc(v_sp.data_chegada_ctbc) > trunc(v_data_envio)) AND
                  (trunc(v_sp.data_chegada_ctbc) - trunc(v_data_envio)) >  v_nro_dias_db Then -- Verifica se esta dentro do periodo permitido
                  RAISE EXC_CONSISTE_DB; -- Nao está dentro do prazo, entao atualiza para DE e motivo 020 -->134
               ELSE
                  PROC_VERIFICA_CONTEST(v_sp.seq_chave_relacionado,
                                        v_sp.data_chegada_ctbc,
                                        v_sp.status,
                                        v_sp.motivo);
                  IF (v_sp.status = 'P') Then-- Caso ocorra algum problema na rotina do Vantive ou PROC_VERIFICA_CONTES
                     v_sp.status := 'P';
                     v_sp.motivo := '003';
                  ELSIF (v_sp.status = 'DE') THEN
                     RAISE EXC_CONSISTE_DB;
                  END IF;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  NULL; --Alteração 06/12/2007 / Para chamadas Reenviadas
               WHEN OTHERS THEN
                  RAISE EXC_CONSISTE_DB; -- O CDR contestado ainda não foi encaminhado a operadora
            END;
         END IF;
      ELSE
         -- não é RR - Chamada realmente duplicada.
         RAISE EXC_DUPLICADO;
      END IF;
   END IF;

EXCEPTION
   WHEN EXC_DURACAO THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '001';
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_DATA_FUTURA THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '016';
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_VALOR_FATURADO THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '015';
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_HORA_INICIO THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '003';
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_SERVICO_CADASTRADO THEN
      v_sp.status            := 'P';
      v_sp.motivo            := '001';
   WHEN EXC_PARCEIRO THEN
      v_sp.status            := 'P';
      v_sp.motivo            := '002';
   WHEN EXC_DUPLICADO THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '141';  -- '017';
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_DUPLICADO_DB THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '135'; -- '006';  INC396845 = Correção do Código de Erro: trocar o "006" por "135";
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_CONSISTE_DB THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '020';
      v_sp.data_cancelamento := sysdate;
   WHEN EXC_PENDENTE THEN
      v_sp.status            := 'P';
      v_sp.motivo            := '003';
   WHEN EXC_IDADE_CDR THEN
      v_sp.status            := 'DE';
      v_sp.motivo            := '125'; -- '013';  INC408737 = Correção do Código de Erro: trocar o "013" por "125"
      v_sp.data_cancelamento := sysdate;
   WHEN OTHERS THEN
      IF SQLCODE IN (-1839, -1840, -1841, -1843, -1847) -- Problema na data do servico
       THEN
         v_sp.status          := 'DE';
         v_sp.motivo          := '002';
         v_sp.data_cancelamento := sysdate;
      ELSE
         v_sp.status          := 'P';
         v_sp.motivo          := 'XXX';
      END IF;
END CRITICA_CDR;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE MOSTRA_O_ERRO IS
  TRADUZ_ERRO  VARCHAR2(1000);
BEGIN

  if roda_uma_vez_2 then
     roda_uma_vez_2 := false;
     grava_arq_log('FILE', 'LINHA   REGISTRO  STATUS  MOTIVO  SEQUENCIAL                              PROBLEMA  //  LOCAL'||CHR(10)||
                       '------  --------  ------  ------  --------------------------------------  ----------------------');
  end if;

  grava_arq_log('FILE', rpad(v_nro_linha,8,' ')||rpad(v_tipo_registro,10,' ')||rpad(nvl(v_sp.status,' '),8,' ')||
      rpad(nvl(v_sp.motivo,' '),8,' ')||rpad(nvl(v_sp.sequencial_chave,' '),40,' ')||replace(replace(replace(sqlerrm,'ERRO','3RRO'),'ORA-','O.R.A.-'), chr(10),'; ') || '  //  '||iLocal );

END MOSTRA_O_ERRO;




--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ I N I C I O ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
BEGIN
  iLocal    := 'INICIO: 000';


  ------------------------------------------------------------------------------
  -- Busca o diretório para ler os arquivos REM.TCOE.T.
  OPEN  qDIR_BMP;
  FETCH qDIR_BMP INTO file_dir_bmp;
  CLOSE qDIR_BMP;


  iLocal    := 'INICIO: 015';
  ------------------------------------------------------------------------------
  -- Abre o arquivo de serviços prestados para leitura e o de log para escrita.
  file_type_bmp := utl_file.fopen(file_dir_bmp,  file_name_tcoe, 'R');

  iLocal    := 'INICIO: 020';
  ------------------------------------------------------------------------------
  -- Loop para leitura do arquivo REM.TCOE.T
  LOOP
    BEGIN
        utl_file.get_line(file_type_bmp,v_linha_arq);

        v_sp := null;

        iLocal    := 'INICIO: 025';

        v_tipo_registro := SUBSTR(v_linha_arq,1,1);
        v_nro_linha     := v_nro_linha + 1;

      --------------------------------------------------------------------------
      IF v_nro_linha = 1 and v_tipo_registro <> '0' then
        grava_arq_log('', 'Arquivo sem Header');
        EXIT;

      --------------------------------------------------------------------------
      ELSIF trim(v_tipo_registro) is null  OR  v_tipo_registro in ( chr(10), chr(13) ) THEN
        iLocal    := 'O Arquivo esta vazio';
        IF v_nro_linha in (1,2,3) then
          grava_arq_log('', 'Arquivo Vazio');
        END IF;
        EXIT;

      --------------------------------------------------------------------------
      -- Header
      ELSIF v_tipo_registro = '0' THEN
        iLocal    := 'Lendo o Registro 0 - Trailler';

        v_sp.data_chegada_ctbc := to_date(substr(v_linha_arq,32,8),'DDMMYYYY');

      --------------------------------------------------------------------------
      -- Trailler
      ELSIF v_tipo_registro = '9' THEN
        iLocal    := 'Lendo o Registro 9 - Header';
        v_reg_9 := 'S';
        v_linha_arq := replace(v_linha_arq,'-','');

        v_regs_lote  := rtrim(trim(substr(v_linha_arq,  2, 14)),'0'); --------- Qtde de Registros do Lote
        v_valor_lote := rtrim(trim(substr(v_linha_arq, 16, 17))/100000,'0'); -- Valor do Lote

      --------------------------------------------------------------------------
      ELSE
        iLocal    := 'Lendo o Registro Detail - '||v_tipo_registro;
        v_nro_detail  := v_nro_detail + 1;

        v_sp.data_cancelamento     := NULL;
        v_sp.seq_chave_relacionado := NULL;
        v_sp.status                := NULL;
        v_sp.motivo                := NULL;
        v_sp.codigo_servico        := NULL;
        v_sp.codigo_arbor          := NULL;

        v_sp.sequencial_chave    := rtrim(ltrim(substr(v_linha_arq, 2, 32)));

        --------------------------------------------------------------------
        -- Verifica se já existe o mesmo sequencial_chave nas tabelas -- RDM12205

        Achou_Sequencial_na_GSP := 0;
        Achou_Sequencial_na_GEB := 0;
        Select count(1) into Achou_Sequencial_na_GSP from grc_servicos_prestados  where sequencial_chave = v_sp.sequencial_chave;
        Select count(1) into Achou_Sequencial_na_GEB from grc_erros_bmp           where sequencial_chave = v_sp.sequencial_chave;

        -- Se existe duplicidade de Sequencial_chave na tabela grc_servicos_prestados...
        IF    Achou_Sequencial_na_GSP <> 0 THEN
          qtde_Sequencial_na_GSP := qtde_Sequencial_na_GSP + 1;

        -- Se existe duplicidade de Sequencial_chave na tabela grc_erros_bmp...
        ELSIF Achou_Sequencial_na_GEB <> 0 THEN
          qtde_Sequencial_na_GEB := qtde_Sequencial_na_GEB + 1;

        -- Se não existe duplicidade de Sequencial_chave...
        ELSE

          BEGIN
            v_sp.cnl_origem          := to_number(rtrim(ltrim(substr(v_linha_arq, 34, 5))));
            v_sp.cnl_destino         := to_number(rtrim(ltrim(substr(v_linha_arq, 39, 5))));
            v_sp.telefone_origem     := rtrim(ltrim(substr(v_linha_arq, 44, 21)));
            v_sp.telefone_destino    := rtrim(ltrim(substr(v_linha_arq, 65, 21)));
            v_sp.valor_faturado      := to_number(rtrim(ltrim(substr(v_linha_arq, 86, 15)))) / 100000;
            v_sp.hora_inicio         := rtrim(ltrim(substr(v_linha_arq, 109, 6)));

            iLocal    := 'INICIO: 060';

            v_sp.duracao             := to_number(nvl(rtrim(ltrim(substr(v_linha_arq, 115, 5))), 0) / 10); -- duracao tarifada
            duracao_erro        := NVL(RTRIM(LTRIM(SUBSTR(v_linha_arq, 115, 5))),0);  -- duracao tarifada erros_bmp
            v_sp.rede_origem         := rtrim(ltrim(substr(v_linha_arq, 120, 1)));
            v_sp.csp                 := to_number(rtrim(ltrim(substr(v_linha_arq, 121, 2))));
            v_sp.natureza            := to_number(rtrim(ltrim(substr(v_linha_arq, 123, 3))));
            v_sp.cod_contestacao     := rtrim(ltrim(substr(v_linha_arq, 126, 2))); -- preenchido no caso de "debito mantido"
            IF v_sp.cod_contestacao IS NULL THEN   v_sp.cod_contestacao := 'N';
            ELSE                                   v_sp.cod_contestacao := 'S';
            END IF;

            iLocal    := 'INICIO: 070';

            v_sp.data_servico        := to_date(rtrim(ltrim(substr(v_linha_arq, 101, 8))), 'ddmmyyyy');
            v_sp.eot_origem          := rtrim(ltrim(substr(v_linha_arq, 128, 3)));
            v_sp.eot_destino         := rtrim(ltrim(substr(v_linha_arq, 131, 3)));
            v_sp.pais_destino        := rtrim(ltrim(substr(v_linha_arq, 134, 3)));
            v_sp.cod_seq_tfi         := to_number(rtrim(ltrim(substr(v_linha_arq, 137, 11))));
            v_sp.lote                := rtrim(ltrim(substr(v_linha_arq, 148, 32)));
            v_sp.eot_filial          := rtrim(ltrim(substr(v_linha_arq, 154, 3)));
            v_sp.DEGRAU              := rtrim(ltrim(substr(v_linha_arq, 180, 3)));
            v_sp.cidade_desloc       := rtrim(ltrim(substr(v_linha_arq, 183, 40)));
            v_sp.servico_operadora   := rtrim(ltrim(substr(v_linha_arq, 226, 5)));
            v_SP.DURACAO_REAL        := rtrim(ltrim(substr(v_linha_arq, 233, 6)));
            v_SP.GRUPO_HORARIO       := rtrim(ltrim(substr(v_linha_arq, 239, 1))); 
            v_SP.COD_NAC_AREA_VISITADA     := rtrim(ltrim(substr(v_linha_arq, 240, 2)));
            v_SP.TCOE := p_nome_arquivo;            

            iLocal    := 'INICIO: 080';

            select sub_csp
              into v_sp.sub_csp
              from grc_eot_operadoras
             where eot = v_sp.eot_filial;

            iLocal    := 'INICIO: 085';

            CRITICA_CDR;

          EXCEPTION
            WHEN OTHERS THEN
              MOSTRA_O_ERRO;
              Raise Exception_GoOn;
          END;

          iLocal    := 'INICIO: 090';
        --v_sp.lote := substr(file_name_tcoe, instr(file_name_tcoe, 'TCOE'), 24); -- RFC 346359
          v_sp.lote := substr(file_name_tcoe, instr(file_name_tcoe, 'TCOE'), 32); -- PROB1080 -

          iLocal    := 'INICIO: 095';

          begin
            v_sp.Data_Lote := to_Date(substr(v_sp.lote, 19, 6), 'ddmmyy'); -- Kyros
          exception when others then
              v_sp.Data_Lote := null;
          end;


          BEGIN
            IF V_SP.STATUS = 'AF' THEN
              iLocal    := 'inserindo na tabela GRC_SERVICOS_PRESTADOS';

              INSERT INTO GRC_SERVICOS_PRESTADOS
                   ( sequencial_chave,        valor_faturado,          data_servico,            hora_inicio,                 duracao,                telefone_origem,
                     telefone_destino,        eot_origem,              eot_destino,             cnl_origem,                  cnl_destino,            data_insercao,
                     rede_origem,             csp,                     natureza,                pais_destino,                cod_seq_TFI,            cod_contestacao,
                     lote,                    status,                  motivo,                  seq_chave_relacionado,       codigo_servico,         codigo_arbor,
                     parceiro,                data_cancelamento,       data_chegada_ctbc,       degrau,                      cidade_desloc,          eot_filial,
                     servico_operadora,       sub_csp,                 data_lote,
                     tcoe,                    duracao_real,            grupo_horario,           cod_nac_area_visitada
                   )
                     VALUES
                   ( v_sp.sequencial_chave,   v_sp.valor_faturado,     v_sp.data_servico,       v_sp.hora_inicio,            v_sp.duracao,           v_sp.telefone_origem,
                     v_sp.telefone_destino,   v_sp.eot_origem,         v_sp.eot_destino,        v_sp.cnl_origem,             v_sp.cnl_destino,       Time,
                     v_sp.rede_origem,        v_sp.csp,                v_sp.natureza,           v_sp.pais_destino,           v_sp.cod_seq_TFI,       v_sp.cod_contestacao,
                     v_sp.lote,               v_sp.status,             v_sp.motivo,             v_sp.seq_chave_relacionado,  v_sp.codigo_servico,    v_sp.codigo_arbor,
                     v_sp.parceiro,           v_sp.data_cancelamento,  v_sp.data_chegada_ctbc,  v_sp.degrau,                 v_sp.cidade_desloc,     v_sp.eot_filial,
                     v_sp.servico_operadora,  v_sp.sub_csp,            v_sp.Data_Lote,
                     v_SP.TCOE,               v_SP.DURACAO_REAL,       v_SP.GRUPO_HORARIO,      v_SP.COD_NAC_AREA_VISITADA
                   );
            ELSE
            
              iLocal    := 'inserindo na tabela GRC_3RROS_BMP';

              if roda_uma_vez_3 then
                 roda_uma_vez_3 := false;
                Begin
                  INSERT INTO GRC_ARQS_BMP ( NOME_ARQUIVO,  DATA_CARGA ) VALUES  ( file_name_tcoe, Time );
                Exception when others then
                  null;
                End;
              end if;

              INSERT INTO GRC_ERROS_BMP
                    (sequencial_chave,        valor_faturado,          data_servico,            hora_inicio,                 duracao,                telefone_origem,
                     telefone_destino,        cnl_origem,              cnl_destino,             eot_origem,                  eot_destino,            rede_origem,
                     natureza,                pais_destino,            cod_seq_TFI,             cod_contestacao,             lote,                   cod_erro,
                     nome_arquivo,            parceiro,                sub_csp,                 eot_filial,                  data_lote,              csp,
                     duracao_real,            grupo_horario,           cod_nac_area_visitada
                    )
                     VALUES
                    (v_sp.sequencial_chave,   v_sp.valor_faturado,     v_sp.data_servico,       v_sp.hora_inicio,            duracao_erro,      v_sp.telefone_origem,
                     v_sp.telefone_destino,   v_sp.cnl_origem,         v_sp.cnl_destino,        v_sp.eot_origem,             v_sp.eot_destino,       v_sp.rede_origem,
                     v_sp.natureza,           v_sp.pais_destino,       v_sp.cod_seq_TFI,        v_sp.cod_contestacao,        v_sp.lote,              v_sp.motivo,
                     file_name_tcoe,          v_sp.parceiro,           v_sp.sub_csp,            v_sp.eot_filial,             v_sp.Data_Lote,         v_sp.csp,
                     v_SP.DURACAO_REAL,       v_SP.GRUPO_HORARIO,      v_SP.COD_NAC_AREA_VISITADA
                    );
            END IF;

            -------------
            COMMIT;
            -------------

            iLocal    := 'Computando a quantidade.';

            v_nro_gravados     := v_nro_gravados + 1;
            v_valor_total_lote := v_valor_total_lote + v_sp.valor_faturado;

            if    v_sp.status = 'DE' then  v_nro_desprezados := v_nro_desprezados + 1;
            elsif v_sp.status = 'P'  then  v_nro_pendente    := v_nro_pendente    + 1;
            elsif v_sp.status = 'AF' then  v_nro_a_faturar   := v_nro_a_faturar   + 1;
            end if;

            if v_sp.motivo = '141' then   v_nro_duplicado := v_nro_duplicado + 1;
            end if;

          EXCEPTION
            WHEN OTHERS THEN
              if sqlcode = -1 then
                qt_unique_contraint := qt_unique_contraint + 1;
              end if;
              MOSTRA_O_ERRO;
              Raise Exception_GoOn;
          END;
        END IF; -- IF iSequencial_chave_igual = 0 THEN
      END IF; -- IF v_nro_linha = 1 and v_tipo_registro <> '0' then

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        EXIT;   -- Sai do Loop ao final do arquivo.

      WHEN EXCEPTION_GOON THEN
        v_nro_erros := v_nro_erros + 1;

      WHEN OTHERS THEN
        MOSTRA_O_ERRO;
        v_nro_erros := v_nro_erros + 1;
        Raise Exception_GoOn;
     END;
  END LOOP; -- Loop para leitura do arquivo REM.TCOE.T

  iLocal    := 'INICIO: 120';

  UTL_FILE.FCLOSE(file_type_bmp);

  
  iLocal    := 'INICIO: 123' || v_sp.parceiro;
  ------------------------------------------------------------------------------
  if get_motivo('361',v_sp.parceiro,'RJ') = 'S' then
    VALIDA_SOBREPOSICAO;
  end if;
  
  iLocal    := 'INICIO: 125';
  ------------------------------------------------------------------------------
  -- Atualizar a tabela de interface com os dados da execução da carga dos serviços --

  IF v_nro_erros > 0 THEN
    v_obs := 'O arquivo apresentou ' || v_nro_erros ||' registros com problemas. Maiores detalhes veja o arquivo de LOG.';

    PROC_GERA_MENSAGENS('GRCOWN', -- destinatário
                        'ERRO! Processo de carga de SP.', -- assunto
                        file_name_tcoe, -- nome do arquivo
                        'Houve ' || v_nro_erros || ' no total, sendo '|| qt_unique_contraint || ' erros de Constraint. ' || CHR(10) ||
                        'Maiores detalhes veja o arquivo de LOG. (proc_carga_sp_d'||to_char(Time,'yyyymmdd')||'*.log');

  ELSE
    v_obs := 'Sucesso. Foram inseridos ' || v_nro_gravados || ' registros, totalizando um valor de ' || v_valor_total_lote||'.';
  END IF;

  --dbms_output.put_line( v_obs ); -- para o "egrep" do Shell Script

  iLocal    := 'INICIO: 130';

  INSERT INTO GRC_INTERFACES(CODIGO,                PROCESSO, DATA_INCLUSAO,  USUARIO, PATH_ARQUIVO,  NOME_ARQUIVO,    DATA_INIC_EXEC, DATA_FIM_EXEC,  STATUS_EXEC,                    OBS,   ATRIB1,       ATRIB2,         ATRIB3,      ATRIB4,               ATRIB5,                ATRIB6,                       ATRIB8,            PARCEIRO)
                    values  (SEQ_INTERFACE.NEXTVAL, 'CAR',    TRUNC(SYSDATE), USER,    file_dir_bmp,  file_name_tcoe,  Time,           sysdate,        DECODE(v_nro_erros,0,'S','E'),  v_obs, v_nro_detail, v_nro_gravados, v_nro_erros, to_char(v_regs_lote), to_char(v_valor_lote), to_char(v_valor_total_lote),  v_nro_desprezados, v_sp.parceiro);
  COMMIT;

  iLocal    := 'INICIO: 999';

  CONTROLE ( 'S' );

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    PROC_GERA_MENSAGENS('GRCOWN', 'ERRO! Processo de carga de SP.', file_name_tcoe, substr(replace(sqlerrm, chr(10),'; '),1, 254) );
    grava_arq_log('', 'Erro na execucao da PL ['||iPrograma||'.sql] >>> '||replace(sqlerrm, chr(10), '; ') );
    CONTROLE ( 'N' );
END PROC_CARGA_SP;
/
