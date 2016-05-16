DECLARE

/*
----------------------------------------------------------------------------------------------------
 NAME.............: PROC_CARREGA_CONTESTADOS
 PURPOSE..........: Atualizar o status do GRC (grc_servicos_prestados) com as chamadas Contestadas da tabela ADJ.
 DATA BASE........: PBCT1 e PBCT2
 USER.............: COBILLING
 
----------------------------------------------------------------------------------------------------
Versao: Autor:               DATA      DOC         PM/RDM       Motivo:
------  -------------------- --------- ----------- -----------  ------------------------------------
1.00    THIAGO               28/07/03  RFC 292085               -- INOVAR CONSULTORIA
1.01    Valter e Paulo Marne 06/07/11  RFC xxxxxx               O Status de Contestados estava errado
1.02    Valter Rogério       26/11/11  RFC 335366               Quando houver um aborte vai informar no arquivo de LOG.
1.03    Daniel Tundisi(kyros)13/01/12  Proj_1380                Melhorias GRC Cobilling
1.04    g0010388 Valter      16/07/12  RFC 363933               Melhorias na homologaçao.
1.05    g0010388 Valter      02/12/13  PROB268853  PM50498      A NESTED TABLE "GRC_MOTIVOS_ARBOR" paresentou erros de tamanho de variável.
1.06    g0010388 Valter      26/08/14  PROB609174  RDM9279      Mesmo nao havendo registros ativos na tabela grc_motivos_arbor, a PL atualizava a tabela gvt_contestados_cobilling.
1.07    g0010388 Valter      18/09/14  PROB623211  RDM9657      Esta PL nao estava buscando os Ajustes Massivos agrupados na tabela
1.08    g0010388 Valter      18/09/14  PROB623211  RDM10655     A PL da RDM anterior estava com o Owner "grcown" antes da GRC_HISTORICOS_SERV_PRESTADOS, que na base PBCT2, pertence ao Owner "dbarem".
1.09    g0010388 Valter      30/10/14  PROB713234  RDM12142     Adaptaçao ao Motivos cadastrados nas tabelas "grc_motivos_arbor" e "grc_motivos_de_para".
1.10    g0010388 Valter      12/12/14  PROB779894  RDM15476     A proc gerava erro quando o campo "grc_servicos_prestados.informacao" estoura o limite.
1.11    g0023421 Aurelio     12/03/15  INC853005   RDM17134     Soma sete dias a variavel iULTIMA_EXECUCAO para pegar os ajustes dos últimos sete dias.
1.12    g0023421 Aurelio     23/03/15              RDM23921     Insere registros de NAO FATURA CONJUNTO na tabela GRCOWN.GRC_NAOFATURACONJUNTO.
---------------------------------------------------------------------------------------------------- */
iUltima_RDM        varchar2(30) := 'RDM23921 (23/07/2015)';

-------------------
iPrograma          varchar2(60) := 'proc_carrega_contestados';
iInterface         varchar2(02) := 'RI';
-------------------
------------------- ARQUIVO DE LOG
-------------------

file_dir_log       varchar2(250) := 'GVT_COBILLING_LOG';
file_name_log      varchar2(250) := iPrograma ||'_'||to_char(sysdate,'yyyymmddhh24miss')||'.log';
file_type_log      UTL_FILE.FILE_TYPE;
-------------------
------------------- VARIÁVEL PADRAO
-------------------
Time               date := sysdate; -- data e hora de inicio da rotina.
--Timing             date := sysdate; -- data e hora de inicio da rotina.
iLocal             varchar2(254);   -- registro do local que a rotina executa.
data_base          varchar2(150) := DBMS_REPUTIL.GLOBAL_NAME();  -- nome da instância do banco de dados.
Exception_Stop     Exception;  pragma exception_init(Exception_Stop,   -20911);  -- exceçao que finaliza a PL.
Exception_GoOn     Exception;  pragma exception_init(Exception_GoOn,   -20912);  -- exceçao que nao finaliza a PL.
Exception_Nmsg     Exception;  pragma exception_init(Exception_Nmsg,   -20913);  -- exceçao que finaliza a PL, e nao emite mais mensagem de erro.
iSequencia         number(10) := 0;
v_existe           varchar2(20):= null; 

-------------------
i_qt_Read            number(10) := 0;     -- qtde de cdrs lidos --
i_qt_Write           number(07) := 0;     -- Qtde de cdrs atualizados --
i_qt_Error           number(08) := 0;     -- Quantidade de erros diversos.
i_qt_cdrs_sf         number(07) := 0;     -- Qtde -- de cdrs com status F  --
i_qt_cdrs_sa         number(07) := 0;     -- Qtde -- de cdrs com status A  --
i_qt_cdrs_sr         number(07) := 0;     -- Qtde -- de cdrs com status R  --
i_qt_sem_motivo      number(07) := 0;     -- Qtde -- de cdrs sem motivo cadastrado --
i_qt_cdrs_ri         number(07) := 0;     -- Qtde -- de cdrs com status F  --
i_qt_cdrs_ra         number(07) := 0;     -- Qtde -- de cdrs com status A  --
i_qt_cdrs_rp         number(07) := 0;     -- Qtde -- de cdrs com status R  --
i_qt_cdrs_F2         number(07) := 0;     -- Qtde -- de cdrs com status F2  --
i_qt_cdrs_F9         number(07) := 0;     -- Qtde -- de cdrs com status F9  --
i_qt_total           number(10) := 0;
-------------------
iULTIMA_EXECUCAO     date := null;
dummy                number  (01);



--¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
  -- NESTED TABLE --> GRC_MOTIVOS_ARBOR --> BUSCA_MOTIVOS_ARBOR
  TYPE   type_MOA  is record ( status_grc varchar2(3),  motivo_grc varchar2(3),   motivo_arbor varchar2(40) );
  TYPE  table_MOA  is table of   type_MOA   index by   binary_integer;
  tMOA  table_MOA;
  iMOA  binary_integer := 0;
  iMotivo_grc varchar2(40);



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
/* PORQUE FIZ A QUERY ASSIM? (valter 25/11/12), atualizado em (27/08/2014)
   
   1) GRC_SERVICOS_PRESTADOS
      Nao dá para buscar pela GRC primeiro, pois nem todos os MSG_ID estao preenchidos na GRC, e resultaria num full table na CDR_DATA.
      E buscar na GRC por todas as chamadas... a assertividade seria menor.
   
   2) RANGE DE DATAS
      Nao vou usar um Range de datas, pois ao buscar hoje (26/11/12) por chamadas que foram contestadas, haviam 37.000, e se todas mudarem o status
      para "RI" entao na próxima execuçao, a quantidade será menor.
      E desta forma, estou garantindo que todas as chamadas que foram Contestadas serao pegas.
   
   3) REQUEST_STATUS
      Somente vou utiliza o request_status 1 e 4. Os outros sao desnecessários.
   
    ADJ.REVIEW_DATE,    -- Date and time of supervisor review
    ADJ.TRANSACT_DATE   -- Date and time adjustment was entered.
    ADJ.REQUEST_STATUS  -- 0 = requested; 1 = approved; 2 = denied; 3 = modified; 4 = canceled; 5 = reserved; 6 = system generated reversal; 7 = disputed; 8 = dispute rejected; 
    
    manual de ajuste - Kenan_BP_12_0-Guide_to_Products_Rates_and_Discounts.pdf
      REQUEST_STATUS = 6 (system generated reversal)
        When a billed adjustment is cancelled or modified, Kenan BP automatically generates an adjustment reversal to cancel out the original adjustment.
        Configure two adjustment reversal rows - one credit, one debit - because the reversal always has the opposite sign of the original adjustment. These rows are system-generated (target type 9), post-bill, and viewable, but should not be journalized or displayed on customer invoices.
        Isto significa que um nao existe um "request_status = 4" sem um "request_status = 6". Entao nao precisa validar o "request_status = 6".
*/
Cursor qADJ
  is
  Select /*+ full(adj) parallel(adj 8) */
         adj.orig_bill_ref_no,
         adj.orig_bill_ref_resets,
         adj.tracking_id,
         adj.tracking_id_serv,
         adj.transact_date,
         adj.request_status,
         adj.adj_reason_code,
         cdr.msg_id,
         cdr.msg_id2,
         cdr.msg_id_serv,
         grc.status,
         grc.data_recebimento,
         grc.sequencial_chave,
         grc.data_cobranca_inad,
         grc.valor_faturado,
         grc.telefone_origem, 
         grc.csp
    From GRC_SERVICOS_PRESTADOS grc,
         ARBOR.CDR_DATA     cdr,
         ARBOR.ADJ      adj
   Where adj.open_item_id between 4 and 89
     and adj.request_status   in ( 1, 4 )
     and cdr.msg_id            = adj.orig_msg_id
     and cdr.msg_id2           = adj.orig_msg_id2
     and cdr.msg_id_serv       = adj.orig_msg_id_serv
     and cdr.split_row_num     = adj.orig_split_row_num
     and grc.sequencial_chave  = cdr.ext_tracking_id
     and ( ( grc.status  in ('F' ,'A', 'R', 'F2', 'F9')   and  adj.request_status = 1 ) or
           ( grc.status  in ('RI','RA','RP')  and  adj.request_status = 4 ) )
     and Not Exists ( -- Nao pode haver um lançamento de contestaçao no mesmo dia
                     Select 1
                       From GVT_CONTESTADOS_COBILLING gcc
                      Where gcc.adj_tracking_id      = adj.tracking_id
                        and gcc.adj_tracking_id_serv = adj.tracking_id_serv
                        and gcc.request_status       = adj.request_status
                        and data_entrada             = adj.transact_date
                     )
    Order by adj.orig_bill_ref_no, 
             adj.orig_msg_id,
             adj.request_status;

r1x  qADJ%rowtype;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
Cursor qHCA is
Select --+ index (grc sp_pk)
         hca.bill_ref_no  orig_bill_ref_no,
         0  orig_bill_ref_resets,
         0  tracking_id,
         0  tracking_id_serv,
         hca.dt_ajuste transact_date,
         hca.request_status,
         hca.adj_reason_code,
         cdr.msg_id,
         cdr.msg_id2,
         cdr.msg_id_serv,
         grc.status,
         grc.data_recebimento,
         grc.sequencial_chave,
         grc.data_cobranca_inad,
         grc.valor_faturado,
         grc.telefone_origem,
         grc.csp
from gvt_historico_cdrs_ajustados hca,
     cdr_data cdr,
         grc_servicos_prestados grc
where hca.dt_ajuste > iULTIMA_EXECUCAO
  and cdr.msg_id = hca.msg_id
  and cdr.msg_id2 = hca.msg_id2
    and cdr.msg_id_serv = hca.msg_id_serv
    and grc.sequencial_chave = cdr.ext_tracking_id
    and grc.status  in ('F','A','R', 'F2', 'F9');

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- Busca o lançamento de Contestaçao ocorrida antes do "Estorno de Contestaçao"
Cursor qEstorno is
  Select transact_date
   from arbor.adj  adj
  where orig_bill_ref_no     = r1x.orig_bill_ref_no
    and orig_bill_ref_resets = r1x.orig_bill_ref_resets
    and orig_msg_id          = r1x.msg_id
    and request_status       = 1
    and Exists ( -- Deve haver um lançamento de contestaçao no mesmo dia
                 Select 1
                   From GVT_CONTESTADOS_COBILLING gcc
                  Where gcc.adj_tracking_id      = adj.tracking_id
                    and gcc.adj_tracking_id_serv = adj.tracking_id_serv
                    and gcc.request_status       = adj.request_status
                    and data_entrada             = adj.transact_date
               ) ;


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- Busca na tabela "gvt_contestados_cobilling" por um lançamento de contestaçao.
Cursor qCtr ( p_date date ) is
  Select 1
    from gvt_contestados_cobilling
   where adj_tracking_id      = r1x.tracking_id
     and adj_tracking_id_serv = r1x.tracking_id_serv
     and data_entrada         = p_date
     and request_status       = 1
     and rownum < 2;


--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- Busca o status anterior, para atualizar na grc_servicos_prestados
Cursor qHis is
  Select status_de, data_alteracao
    from GRC_HISTORICOS_SERV_PRESTADOS
   where servico_prestado = r1x.sequencial_chave
     and status_para      = r1x.status
   Order by data_alteracao desc;

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE LOCALIZACAO_ANTERIOR (p_tipo varchar2 default null) IS
BEGIN
  -- Precisa colocar sempre no inicio da procedure "~~ 01"
  if p_tipo is not null then  iLocal := substr(iLocal,1, length(iLocal)-2)||lpad(p_tipo,2,'0') ;
  else                        iLocal := substr(iLocal,1,instr(iLocal,';', -1)-1) ;
  end if;
END LOCALIZACAO_ANTERIOR;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE GRAVA_CONTROLE_ERROS ( pTipo_local varchar2, pLocal varchar2, pErro varchar2 ) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  iParametros     varchar2(500) := 'Sequencial Chave ('||r1x.sequencial_chave||')';
  iDetalhe        varchar2(500) := 'Local do Erro ('||iLocal||')';
BEGIN
  iLocal := iLocal||';GRAVA_CONTROLE_ERROS~~ 01';
  
  iSequencia := iSequencia + 1;
  
  --/*
  Begin
    Insert into COB_CONTROLE_ERROS
       ( base,       Programa,  Tipo_local,  Local, Conteudo,  Sequencia,  Parametros,  Erro,   Detalhe, Time ) values
       ( data_base, iPrograma, pTipo_local, pLocal, null,     iSequencia, iParametros, pErro,  iDetalhe, Time );
    COMMIT;
  Exception
    when others then
      dbms_output.put_line( 'Erro ao inserir na tabela  [COB_CONTROLE_ARQUIVOS] >>> '||replace(sqlerrm, chr(10), '; ') );
      Raise Exception_Stop;
  End;
  --*/
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line( 'Erro ao executar a PU [GRAVA_CONTROLE_ERROS] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE;
END GRAVA_CONTROLE_ERROS;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
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
    (  data_inicio,       data_fim,  Interface,   Status,   Rotina,     qtde_lidos,   qtde_reg_processados,  qtde_erros,   lote,   tempo,  msg  ) values
    (  iULTIMA_EXECUCAO,  Sysdate,  iInterface,  pStatus,  iPrograma,  i_qt_Read,     i_qt_Write,            i_qt_Error,  iLote,  iTempo, 'RDM.: ' || iUltima_RDM ||
      ';  CDRs Lidos.: '||i_qt_Read ||
      ';  CDRs Contestados.: '||i_qt_Write ||
      ';  Sem cadastro na grc_motivos_arbor.: '||i_qt_sem_motivo );
  Exception
    when others then
      grava_arq_log('', 'Erro ao inserir na tabela  [controle_execucao_cobilling] >>> '||replace(sqlerrm, chr(10), '; ') );
  End;
  --*/
  
  ------------------------------------------------------------------------------ INI Relatórios desta PL
  grava_arq_log('', '..: '|| to_char(i_qt_Read,          '9g999g999') ||'  qtde de CDRs lidos.' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_sf,       '9g999g999') ||'  qtde de CDRs com status "F"  Contestados com status "RI".' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_F2 ,      '9g999g999') ||'  qtde de CDRs com status "F2" Contestados com status "RI".' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_F9 ,      '9g999g999') ||'  qtde de CDRs com status "F9" Contestados com status "RI".' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_sa ,      '9g999g999') ||'  qtde de CDRs com status "A"  Contestados com status "RA".' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_sr ,      '9g999g999') ||'  qtde de CDRs com status "R"  Contestados com status "RP".' );
  grava_arq_log('', '..: '|| to_char(i_qt_Write,         '9g999g999') ||'  qtde de CDRs Contestados (TOTAL).' ||chr(10) );
  
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_ri ,      '9g999g999') ||'  qtde de CDRs com status "RI"  que foram Estornados.' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_ra ,      '9g999g999') ||'  qtde de CDRs com status "RA"  que foram Estornados.' );
  grava_arq_log('', '..: '|| to_char(i_qt_cdrs_rp ,      '9g999g999') ||'  qtde de CDRs com status "RP"  que foram Estornados.' || chr(10) );
  
  grava_arq_log('', '..: '|| to_char(i_qt_sem_motivo,    '9g999g999') ||'  qtde de CDRs que nao possuem cadastro na tabela GRC_MOTIVOS_ARBOR, e portanto nao foram Contestados.' );
  grava_arq_log('', '..: '|| to_char(i_qt_Error,         '9g999g990') ||'  qtde de Problemas' );
  ------------------------------------------------------------------------------INI Relatórios desta PL

  if pStatus = 'E' then
        grava_arq_log('', 'Erro: Ao executar o programa ['||iPrograma||'].');
    grava_arq_log('', 'Local.: '||iLocal );
  end if;
  grava_arq_log('', 'Final....: '||to_char(Sysdate,'dd/mm/yyyy hh24:mi:ss') || '   Duracao..: ' || iTempo );
  grava_arq_log('', rpad('=',100,'=') );
  
  COMMIT;
  utl_file.fclose(file_type_log);

EXCEPTION
  WHEN OTHERS THEN
    GRAVA_CONTROLE_ERROS('PROCEDURE', 'CONTROLE', 'Erro ao executar a PU [CONTROLE] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Erro ao executar a PU [CONTROLE] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Status.........: '|| pStatus );
    grava_arq_log('', 'Local..........: '|| iLocal );
    Raise_application_error(-20000,'');
END CONTROLE;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
PROCEDURE BUSCA_ULTIMA_EXECUCAO IS
BEGIN
  iLocal := iLocal||';BUSCA_ULTIMA_EXECUCAO~~ 01';
  
  Select max(data_fim)
    into iULTIMA_EXECUCAO
    from CONTROLE_EXECUCAO_COBILLING
   where rotina = iPrograma
     and status in ('Y','S'); -- status com sucesso RDM9657
  
  if iULTIMA_EXECUCAO is null then
     iULTIMA_EXECUCAO := sysdate-14;
  else
     iULTIMA_EXECUCAO := iULTIMA_EXECUCAO-7;
  end if;  
  grava_arq_log('', 'Ultima execucao deste programa ('||to_char(iULTIMA_EXECUCAO, 'DD/MM/YYYY')||').' );
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN OTHERS THEN
    GRAVA_CONTROLE_ERROS('PROCEDURE', 'BUSCA_ULTIMA_EXECUCAO', 'Erro ao executar a PU [BUSCA_ULTIMA_EXECUCAO] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Erro ao executar a PU [BUSCA_ULTIMA_EXECUCAO] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END BUSCA_ULTIMA_EXECUCAO;



--RDM23921 ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- NAOFATURACONJUNTO
PROCEDURE INSERE_NAOFATURACONJUNTO IS
BEGIN
  iLocal := iLocal||';EFETUA_CONTESTACAO_HCA~~ 01';
  
  ------------------------------------------------------------------------------
    LOCALIZACAO_ANTERIOR(22);  
    select 1 into v_existe from GRCOWN.GRC_NAOFATURACONJUNTO where telefone = r1x.telefone_origem and operadora = r1x.csp and INACTIVE_DT is null;
      if v_existe is not null then  
        update GRCOWN.GRC_NAOFATURACONJUNTO set inactive_dt = sysdate where telefone = r1x.telefone_origem and INACTIVE_DT is null;
        commit;
      end if;
      insert into GRCOWN.GRC_NAOFATURACONJUNTO(TELEFONE,OPERADORA,ACTIVE_DT,INACTIVE_DT,DESCRICAO )
           VALUES (r1x.telefone_origem, r1x.CSP, sysdate, null, null);
           COMMIT;
    LOCALIZACAO_ANTERIOR();
 END INSERE_NAOFATURACONJUNTO;
 
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- Esta FUNCTION verifica se existe o "de-para" e retorna o status do GRC.
FUNCTION BUSCA_MOTIVOS_ARBOR return boolean is
  Cursor qMOA is
    Select status_grc, motivo_grc, motivo_arbor
      from GRC_MOTIVOS_ARBOR
     where status_grc in ('RI') -- Esta proc somente Contesta. (valter - 02/12/13)
       and substr(motivo_arbor,1,1) NOT in ('%', '*')
       and ativo = 'S';
BEGIN
  iLocal := iLocal||';BUSCA_MOTIVOS_ARBOR~~ 01';
  -- Se o Índice for igual a zero, entao popula a Nested Table
  IF nvl(iMOA,0) = 0 then
    iMOA := 0;
    FOR rMOA IN qMOA    LOOP
        iMOA := iMOA + 1;
      --tMOA(iMOA).status_grc   := rMOA.status_grc;
        tMOA(iMOA).motivo_grc   := rMOA.motivo_grc;
        tMOA(iMOA).motivo_arbor := rMOA.motivo_arbor;
    END LOOP;
    if nvl(iMOA,0) = 0 then
      GRAVA_CONTROLE_ERROS('TABELA', 'GRC_MOTIVOS_ARBOR', 'NAO HA REGISTROS ATIVOS NA TABELA [GRC_MOTIVOS_ARBOR] PARA CARREGAR EM MEMORIA.' );
      grava_arq_log('',  'NAO HA REGISTROS ATIVOS NA TABELA [GRC_MOTIVOS_ARBOR] PARA CARREGAR EM MEMORIA.' );
      Raise Exception_Nmsg;
    else
      grava_arq_log('FILE',  'Quantidade de registros carregados em memoria da tabela [GRC_MOTIVOS_ARBOR]..: '|| trim(to_char(nvl(iMOA,0), '999g999g990')) );
    end if;
  END IF;
  LOCALIZACAO_ANTERIOR(2);
  
  iMotivo_grc := null;
  -- Busca pelo registro
  FOR indice IN 1..iMOA   LOOP
    if tMOA(indice).motivo_arbor = ltrim(to_char(r1x.adj_reason_code,'000'))  THEN -- RDM12142
  --if tMOA(indice).motivo_arbor = trim(r1x.adj_reason_code)  THEN 
        
        LOCALIZACAO_ANTERIOR();
        iMotivo_grc := tMOA(indice).motivo_grc;
        return (true);
    end if;
  END LOOP;
  
  LOCALIZACAO_ANTERIOR();
  return (false);
  
Exception
  WHEN Exception_Nmsg THEN
    LOCALIZACAO_ANTERIOR();
    Raise Exception_Nmsg;
    
  When others then
    grava_arq_log('',  'Erro na execucao da PU [BUSCA_MOTIVOS_ARBOR] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END BUSCA_MOTIVOS_ARBOR;

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- AJUSTE SIMPLES - TABELA ADJ
PROCEDURE EFETUA_CONTESTACAO_ADJ IS
BEGIN
  iLocal := iLocal||';EFETUA_CONTESTACAO_ADJ~~ 01';
  
  
  ------------------------------------------------------------------------------
  FOR rADJ IN qADJ
  LOOP
    r1x := rADJ;
    i_qt_Read := i_qt_Read +1;
    
    LOCALIZACAO_ANTERIOR(5);
    ----------------------------------------------------------------------------
    -- AJUSTE CANCELADO (cancelled)

    IF radj.request_status = 4  THEN
      
      LOCALIZACAO_ANTERIOR(10);
      
      -- Para que possa haver um "cancelamento" de contestaçao, deve haver primeiro uma contestaçao no GRC.
      -- Esta rotina verifica se já foi enviado uma solicitacao de contestaçao (request_status = 1)
      
      -- Busca o "adj.transact_date"  na ADJ, onde o "request_status" = 1
      For rEstorno in qEstorno
      Loop
        -- Se existir registro na ADJ, Busca na tabela "gvt_contestados_cobilling" por um lançamento de contestaçao.
        Open  qCtr ( rEstorno.transact_date );
        Fetch qCtr into dummy;
           -- Se nao existir um lançamento de contestaçao, entao permite que seja realizado um lançamento de Cancelamento da Contestaçao.
           if qCtr%notfound then
            
              LOCALIZACAO_ANTERIOR(20);
          
              ------------------------------------------------------------------
              -- Busca o status anterior, para atualizar na grc_servicos_prestados
              For rHis in qHis
              Loop
                LOCALIZACAO_ANTERIOR(25);
                --/*
                UPDATE grc_servicos_prestados
                   SET status = rHis.status_de,
                       data_cobranca_ri = null
                 WHERE sequencial_chave = radj.sequencial_chave;
                --*/
                
                if    radj.status = 'RI' then i_qt_cdrs_ri := i_qt_cdrs_ri + 1;
                elsif radj.status = 'RA' then i_qt_cdrs_ra := i_qt_cdrs_ra + 1;
                elsif radj.status = 'RP' then i_qt_cdrs_rp := i_qt_cdrs_rp + 1;            
                end if;
                
                BEGIN
                  LOCALIZACAO_ANTERIOR(30);
                  INSERT INTO GVT_CONTESTADOS_COBILLING  VALUES ( radj.tracking_id,   radj.tracking_id_serv,   radj.request_status,   radj.transact_date );
                Exception
                  when dup_val_on_index then
                    GRAVA_CONTROLE_ERROS('TABELA', 'GVT_CONTESTADOS_COBILLING', 'ao inserir na [GVT_CONTESTADOS_COBILLING] >>> dup_val_on_index >>> tracking_id ('||radj.tracking_id||';'||radj.tracking_id_serv||') Request_status ('||radj.request_status||').' );
                    grava_arq_log('FILE',  'ao inserir na [GVT_CONTESTADOS_COBILLING] >>> dup_val_on_index >>> tracking_id ('||radj.tracking_id||';'||radj.tracking_id_serv||') Request_status ('||radj.request_status||').' );
                    i_qt_Error := i_qt_Error + 1;
                    
                  when others then
                    GRAVA_CONTROLE_ERROS('TABELA', 'GVT_CONTESTADOS_COBILLING', 'Erro ao inserir na [GVT_CONTESTADOS_COBILLING] >>> '||replace(sqlerrm, chr(10), '; ') );
                    grava_arq_log('',  'Erro ao inserir na [GVT_CONTESTADOS_COBILLING] >>> '||replace(sqlerrm, chr(10), '; ') );
                    i_qt_Error := i_qt_Error + 1;
                    RAISE Exception_Stop;
                END;
                
                Exit;
              End Loop qHis;
            
           end if;
        Close qCtr;
      End Loop qADJ;
    
    ------------------------------------------------------------------------------
    -- CONTESTAÇAO "DE FATO"
    ELSIF radj.request_status = 1 THEN
        
        LOCALIZACAO_ANTERIOR(50);
        
        IF NOT BUSCA_MOTIVOS_ARBOR THEN
          
          LOCALIZACAO_ANTERIOR(55);
          
          GRAVA_CONTROLE_ERROS('TABELA', 'GRC_MOTIVOS_ARBOR', '"adj_reason_code" ('||lpad(radj.adj_reason_code,3,' ')||') nao cadastrado na "GRC_MOTIVOS_ARBOR".  Sequencial.: '||rpad(radj.sequencial_chave,25,' ')||' track: '||radj.tracking_id );
          grava_arq_log('FILE', '"adj_reason_code" ('||lpad(radj.adj_reason_code,3,' ')||') nao cadastrado na "GRC_MOTIVOS_ARBOR".  Sequencial.: '||rpad(radj.sequencial_chave,25,' ')||' track: '||radj.tracking_id );
          i_qt_Error        := i_qt_Error      + 1;
          i_qt_sem_motivo   := i_qt_sem_motivo + 1;
    
        ELSE
          LOCALIZACAO_ANTERIOR(60);
          
          --/*
          -- Se o status atual for igual a "R", entao muda para "RP" (RECLAMADO APOS O REPASSE)
          -- Se o status atual for igual a "A", entao muda para "RA" (RECLAMADO APOS A ARRECADACAO, ANTES DO REPASSE)
          -- Senao muda para "RI" (CONTESTADO)
          UPDATE grc_servicos_prestados
             SET status           = decode(radj.status, 'R', 'RP', 'A', 'RA', 'RI'),
                 data_cobranca_RI = radj.transact_date,
                 motivo           = iMotivo_grc,
                 protocolo        = radj.tracking_id || radj.tracking_id_serv
           WHERE sequencial_chave = radj.sequencial_chave;
           
           if iMotivo_grc = '218' then
            INSERE_NAOFATURACONJUNTO;
           end if;
           
          --*/
          
          if    radj.status = 'F'  then i_qt_cdrs_sf  := i_qt_cdrs_sf  + 1;
          elsif radj.status = 'A'  then i_qt_cdrs_sa  := i_qt_cdrs_sa  + 1;
          elsif radj.status = 'R'  then i_qt_cdrs_sr  := i_qt_cdrs_sr  + 1;
          elsif radj.status = 'F2' then i_qt_cdrs_f2  := i_qt_cdrs_f2  + 1;
          elsif radj.status = 'F9' then i_qt_cdrs_f9  := i_qt_cdrs_f9  + 1;        
          end if;
          i_qt_Write := i_qt_Write + 1;
          
          LOCALIZACAO_ANTERIOR(65);
          
          INSERT INTO GRC_ESTORNADAS VALUES (1, radj.sequencial_chave, radj.valor_faturado);
          
          BEGIN
            LOCALIZACAO_ANTERIOR(70);
            INSERT INTO GVT_CONTESTADOS_COBILLING  VALUES ( radj.tracking_id,   radj.tracking_id_serv,   radj.request_status,   radj.transact_date );
          Exception
            when dup_val_on_index then
              GRAVA_CONTROLE_ERROS('TABELA', 'GVT_CONTESTADOS_COBILLING', 'ao inserir na [GVT_CONTESTADOS_COBILLING] >>> dup_val_on_index >>> tracking_id ('||radj.tracking_id||';'||radj.tracking_id_serv||') Request_status ('||radj.request_status||').' );
              grava_arq_log('FILE',  'ao inserir na [GVT_CONTESTADOS_COBILLING] >>> dup_val_on_index >>> tracking_id ('||radj.tracking_id||';'||radj.tracking_id_serv||') Request_status ('||radj.request_status||').' );
              i_qt_Error := i_qt_Error + 1;
              
            when others then
              GRAVA_CONTROLE_ERROS('TABELA', 'GVT_CONTESTADOS_COBILLING', 'Erro ao inserir na [GVT_CONTESTADOS_COBILLING] >>> '||replace(sqlerrm, chr(10), '; ') );
              grava_arq_log('',  'Erro ao inserir na [GVT_CONTESTADOS_COBILLING] >>> '||replace(sqlerrm, chr(10), '; ') );
              i_qt_Error := i_qt_Error + 1;
              RAISE Exception_Stop;
          END;
        
        END IF;
    END IF;
    
  END LOOP qGRC;
  
  ----------------------------------------------------------------------------
  -- IMPOSTOS DE ESTORNO --> será executado na PROC_RET_ARBOR somente na PBCT1.
  
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN Exception_Nmsg THEN
    LOCALIZACAO_ANTERIOR();
    Raise Exception_Nmsg;
    
  WHEN OTHERS THEN
    GRAVA_CONTROLE_ERROS('PROCEDURE', 'EFETUA_CONTESTACAO_ADJ', 'Erro na execucao da PU [EFETUA_CONTESTACAO_ADJ] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Erro na execucao da PU [EFETUA_CONTESTACAO_ADJ] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END EFETUA_CONTESTACAO_ADJ;



--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
-- AJUSTE MASSIVO - TABELA GVT_HISTORICO_CDRS_AJUSTADOS
PROCEDURE EFETUA_CONTESTACAO_HCA IS
BEGIN
  iLocal := iLocal||';EFETUA_CONTESTACAO_HCA~~ 01';
  
  ------------------------------------------------------------------------------
  FOR rHCA IN qHCA
  LOOP
    r1x := rhca;
    i_qt_Read := i_qt_Read +1;
    
    -- No ajuste massivo nao existe "Estorno de Ajuste"
        
    IF NOT BUSCA_MOTIVOS_ARBOR THEN
      
      LOCALIZACAO_ANTERIOR(5);
      
      GRAVA_CONTROLE_ERROS('TABELA', 'GRC_MOTIVOS_ARBOR', '"adj_reason_code" ('||lpad(rhca.adj_reason_code,3,' ')||') nao cadastrado na "GRC_MOTIVOS_ARBOR".  Sequencial.: '||rpad(rhca.sequencial_chave,25,' ') );
      grava_arq_log('FILE', '"adj_reason_code" ('||lpad(rhca.adj_reason_code,3,' ')||') nao cadastrado na "GRC_MOTIVOS_ARBOR".  Sequencial.: '||rpad(rhca.sequencial_chave,25,' ') );
      i_qt_Error        := i_qt_Error      + 1;
      i_qt_sem_motivo   := i_qt_sem_motivo + 1;

    ELSE
      LOCALIZACAO_ANTERIOR(10);
      
      --/*
      -- Se o status atual for igual a "R", entao muda para "RP" (RECLAMADO APOS O REPASSE)
      -- Se o status atual for igual a "A", entao muda para "RA" (RECLAMADO APOS A ARRECADACAO, ANTES DO REPASSE)
      -- Senao muda para "RI" (CONTESTADO)
      UPDATE grc_servicos_prestados
      SET status           = decode(rhca.status, 'R', 'RP', 'A', 'RA', 'RI'),
          data_cobranca_RI = rhca.transact_date,
          motivo           = iMotivo_grc,
          protocolo        = rhca.orig_bill_ref_no
      WHERE sequencial_chave = rhca.sequencial_chave;
      
      if iMotivo_grc = '218' then 
       INSERE_NAOFATURACONJUNTO; 
      end if;
      
      --*/
      
      LOCALIZACAO_ANTERIOR(15);
      
      if    rhca.status = 'F'  then i_qt_cdrs_sf  := i_qt_cdrs_sf  + 1;
      elsif rhca.status = 'A'  then i_qt_cdrs_sa  := i_qt_cdrs_sa  + 1;
      elsif rhca.status = 'R'  then i_qt_cdrs_sr  := i_qt_cdrs_sr  + 1;
      elsif rhca.status = 'F2' then i_qt_cdrs_f2  := i_qt_cdrs_f2  + 1;
      elsif rhca.status = 'F9' then i_qt_cdrs_f9  := i_qt_cdrs_f9  + 1;    
      end if;
      i_qt_Write := i_qt_Write + 1;
      
      LOCALIZACAO_ANTERIOR(20);
      
      INSERT INTO GRC_ESTORNADAS VALUES (1, rhca.sequencial_chave, rhca.valor_faturado);
    
    END IF;
    
  END LOOP qHCA;
  
  LOCALIZACAO_ANTERIOR();
EXCEPTION
  WHEN Exception_Nmsg THEN
    LOCALIZACAO_ANTERIOR();
    Raise Exception_Nmsg;
    
  WHEN OTHERS THEN
    GRAVA_CONTROLE_ERROS('PROCEDURE', 'EFETUA_CONTESTACAO_HCA', 'Erro na execucao da PU [EFETUA_CONTESTACAO_HCA] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Erro na execucao da PU [EFETUA_CONTESTACAO_HCA] >>> '||replace(sqlerrm, chr(10), '; ') );
    RAISE Exception_Stop;
END EFETUA_CONTESTACAO_HCA;

--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷ I N I C I O ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
--÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
BEGIN
  iLocal    := 'INICIO: 000';
  
  grava_arq_log('', rpad('=',100,'=') );
  grava_arq_log('', 'PROGRAMA.: '||iPrograma || '  -  Contesta as chamadas da tabela ADJ.' );
  grava_arq_log('', 'Inicio...: '||to_char(Time,'dd/mm/yyyy hh24:mi:ss') );
  grava_arq_log('', rpad('-',100,'-') );
  
  iLocal    := 'INICIO: 05';  BUSCA_ULTIMA_EXECUCAO;
  iLocal    := 'INICIO: 10';  EFETUA_CONTESTACAO_ADJ;
  iLocal    := 'INICIO: 15';  EFETUA_CONTESTACAO_HCA;
  iLocal    := 'INICIO: 99';
  
  CONTROLE ( 'S' );

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    GRAVA_CONTROLE_ERROS('PL', 'FINAL DA PL', 'Erro na execucao da PL ['||iPrograma||'.sql] >>> '||replace(sqlerrm, chr(10), '; ') );
    grava_arq_log('', 'Erro na execucao da PL ['||iPrograma||'.sql] >>> '||replace(sqlerrm, chr(10), '; ') );
    i_qt_Error := i_qt_Error + 1;
    CONTROLE ( 'E' );
END;
/