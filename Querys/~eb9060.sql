----------------------------------------------------------------------------------
-- Programa      : plCOR_0001.sql
-- SCRIPT        : Gera arquivo para Conta Detalhada na Internet
-- CREATED       : MARCELO RODRIGUES DA SILVA
-- DESCRIPTION   : PL para gerar o arquivo com detalhamentos de fatura a ser
--                 enviado para a WEB e ser disponibilizado para o cliente efetuar 
--                 download.
----------------------------------------------------------------------------------------------
-- Versão: Autor:               Data:       Doc:        Motivo:
   ------  -------------------- ----------- ----------- --------------------------------------
-- 1.1     g0010388 Valter      04/DEC/2009 RFC 126356  PL abortava quando fatura não tinha Nota Fiscal;
-- 1.2     g0010388 Valter      19/FEB/2010 RFC 156351  Omitir a linhas em branco supérfluas.
-- 1.3     g0010388 Valter      31/MAR/2010 RFC 164552  Gerar arquivo de LOG.
----------------------------------------------------------------------------------
-- Aumentar buffer de saida e limpar possiveis espacos em branco na linha
SET VERIFY                     OFF;
SET SERVEROUT                  ON SIZE 1000000
SET FEED                       OFF;
SET SPACE                      0;
SET PAGESIZE                   0;
SET LINE                       500;
SET WRAP                       ON;
SET HEADING                    OFF;

-- Variaveis
DECLARE
   v_diretorio_arquivo     VARCHAR2 (100) := '&1';
   v_cliente               cmf.account_no%TYPE;
   v_bill_ref_no           bill_invoice.bill_ref_no%TYPE;
   v_existe_fatura         NUMBER (1);
   v_type_id_usg           gvt_duration_usg_variable.type_id_usg%TYPE;
   v_account_category      cmf.account_category%TYPE;
   v_element_id            NUMBER;
   retorno                 INTEGER;
   cursorclientes          INTEGER;
   vcliente                cmf.account_no%TYPE;
   v_external_id           CUSTOMER_ID_ACCT_MAP.external_id%TYPE;
   ssql                    VARCHAR2 (600);
   v_arq_ponto_conta       UTL_FILE.file_type;
   v_nome_arquivo          VARCHAR2 (150);
   nome_operadora          VARCHAR2 (80);
   v_provider_id           NUMBER (6);
   v_open_item_id          NUMBER (5);
   v_mes                   CHAR(06);
   v_mes_b                 CHAR(10);
   v_flag_usage            CHAR(01);

   t_external_orig         CHAR(48); -- Instância de serviço
   t_type_id_orig          NUMBER (6);
   t_external_id           CHAR(48); -- Instância de serviço
   t_account_no            NUMBER (10);
   t_type_id_usg           NUMBER (6);
   t_soma_min_real         NUMBER (10) := 0;
   t_soma_min_fat          NUMBER (10) := 0;
                           
   erroatuparcel           EXCEPTION;
   v_localizacao           VARCHAR2(250);        -- controle erro: nome proced. em execucao
   
   v_flag_circuito         CHAR(01):= 'S';
   v_flag_mensalidade      CHAR(01):= 'S';
   v_flag_resumo           CHAR(01):= 'N';
   v_numero_conta          NUMBER;
   v_numero_fatura         VARCHAR2(200);

   aux_num_execucao        NUMBER;
   aux_data                VARCHAR2(45);
                           
   dummy                   Number; -- RFC 126356 - Valter Rogério Ciolari (04/12/2009)
   
   v_point                 cdr_data.point_origin%TYPE;
   v_swap                  gvt_usage_defs.swap_origin_target%TYPE;
   
    ----------------------- -- ini: RFC 164552
    yFileERRO            UTL_FILE.file_type;
    yDiretorio           Varchar2(100) := v_diretorio_arquivo;
    yArquivo             Varchar2(80) := 'LOG_pl_conta_detalhada_P_C_'||to_char(sysdate,'yyyymmddhh24miss')||'_avulso.txt';
    yTempo_ini           date := sysdate;
    First_Time           boolean;
    yqtde_bip              number(8) := 0;
    yqtde_gerada           number(8) := 0;
    yqtde_erro             number(8) := 0;
    yqtde_sem_fatura       number(8) := 0;
    yqtde_sem_nota         number(8) := 0;
    yqtde_sem_usos         number(8) := 0;
    ----------------------- -- fim: RFC 164552

   -- Declarando Cursor
   -- Alterado cursor upgarb 947
   CURSOR consulta_cliente IS
      SELECT C.ACCOUNT_NO, C.BILL_REF_NO, C.PAYMENT_DUE_DATE
      FROM   G0023421SQL.CDC_PROCESSAR_BACKLOG C
      WHERE  C.account_category not in (9,10,11)
       and   C.processo = 1;

-- Cursor que separa a fatura por Notas Fiscais

   CURSOR operadora_csp IS
      SELECT DISTINCT provider_id, 
             decode(open_item_id,2,1,3,1,open_item_id) open_item_id
      FROM   bill_invoice bi, 
             bill_invoice_detail bid
      WHERE  bi.account_no = v_cliente
       AND   bi.bill_ref_no = v_bill_ref_no
       AND   bi.bill_ref_no = bid.bill_ref_no
       AND   bi.bill_ref_resets = bid.bill_ref_resets
       AND   bid.type_code IN (2, 3, 7)
       ORDER BY decode(open_item_id,2,1,3,1,open_item_id);
   eOPERADORA boolean;
------------------------------------------------------------------------------------------------
-- Cursor para detalhamento de chamadas de uma fatura

   CURSOR chamadas IS
      SELECT bed.type_id_usg ele, 
             des.description_text,
             des_jur.description_text des_jur, 
             CDR_DATA.EXTERNAL_ID, 
             bed.account_no,
             CDR_DATA.point_origin,
             CDR_DATA.point_target, 
             UP.point_city cid, 
             UP.point_state_abbr uf,
             bed.trans_dt trans_dt,
             CDR_DATA.primary_units, 
             CDR_DATA.second_units, 
             CDR_DATA.RATED_UNITS units,
             bed.type_id_usg, 
             CDR_DATA.billing_units_type, 
             (bed.BILLED_AMOUNT) am,
             (bed.amount_credited) cred, 
             CDR_DATA.rate_period,
             CDR_DATA.corridor_plan_id corridor, 
             CDR_DATA.jurisdiction juri, 
             CDR_DATA.provider_id
        FROM jurisdictions jur,
             descriptions des_jur,
             descriptions des,
             descriptions des_ele,
             usage_points UP,
             usage_types tp_uso,
             CDR_BILLED bed,
             CDR_DATA,
             bill_invoice bi
       WHERE bi.account_no = v_cliente
         AND bi.bill_ref_no = v_bill_ref_no
         AND bed.bill_ref_no = bi.bill_ref_no
         AND CDR_DATA.msg_id = bed.msg_id
         AND CDR_DATA.msg_id2 = bed.msg_id2
         AND CDR_DATA.msg_id_serv = bed.msg_id_serv
         AND CDR_DATA.SPLIT_ROW_NUM = BED.SPLIT_ROW_NUM
         AND CDR_DATA.CDR_DATA_PARTITION_KEY = BED.CDR_DATA_PARTITION_KEY
         AND tp_uso.type_id_usg = bed.type_id_usg
         AND tp_uso.type_id_usg NOT IN (100, 101, 103, 104, 150, 151, 152, 153)
         AND des.description_code = tp_uso.description_code
         AND des.language_code = 2
         AND des_ele.description_code = CDR_DATA.element_id
         AND des_ele.language_code = 2
         AND UP.point_id(+) = DECODE (point_id_target, 0, point_id_origin, point_id_target )
         AND jur.jurisdiction(+) = CDR_DATA.jurisdiction
         AND des_jur.description_code(+) = jur.description_code
         AND (des_jur.language_code = 2 OR des_jur.language_code IS NULL)
    ORDER BY CDR_DATA.provider_id, CDR_DATA.external_id, bed.type_id_usg, bed.trans_dt;

------------------------------------------------------------------------------------------------
-- Cursor para tratar a duaração de chamadas de usos Plano Madri
   CURSOR usos_madri IS
      SELECT   element_id, 
               acct_category, 
               usg_min_rate_variable,
               usg_cadence_2, 
               set_units_2
          FROM gvt_duration_usg_variable
         WHERE type_id_usg = v_type_id_usg
           AND (   element_id = v_element_id
                OR (element_id = 0 AND acct_category = v_account_category)
               )
      ORDER BY element_id DESC, acct_category;

------------------------------------------------------------------------------------------------      
-- Cursor para detalhamento de RC´s e NRC´s cobrados na fatura
   CURSOR mensalidades IS
      SELECT   conta.external_id conta,
               equip.external_id equip_external_id,
               detalhe.subtype_code produto, de.description_text nome_produto,
               equip_dt.pop_units qtde_ramais, SUM (detalhe.amount) amount,
               SUM (detalhe.discount) discount,
               SUM (detalhe.amount) + SUM (detalhe.discount) saldo,
               detalhe.provider_id,
               detalhe.type_code,
               conta.account_no
          FROM franchise_code_values uf,
               descriptions de,
               SERVICE equip_dt,
               CUSTOMER_ID_EQUIP_MAP equip,
               CUSTOMER_ID_ACCT_MAP conta,
               cmf cliente,
               bill_invoice_detail detalhe,
               bill_invoice fatura
         WHERE fatura.account_no = v_cliente
           AND fatura.bill_ref_no = v_bill_ref_no
           AND fatura.prep_status = 1
           AND fatura.backout_status = '0'
           AND fatura.format_error_code IS NULL
           AND fatura.prep_error_code IS NULL
           AND detalhe.bill_ref_no = fatura.bill_ref_no
           AND detalhe.bill_ref_resets = fatura.bill_ref_resets
           AND detalhe.type_code IN (2, 3, 7)
           AND (detalhe.amount <> 0 OR detalhe.discount <> 0)
           AND cliente.account_no = fatura.account_no
           AND conta.account_no = fatura.account_no
           AND conta.external_id_type = 1
           AND de.description_code(+) = detalhe.description_code
           AND (de.language_code = 2 OR de.language_code IS NULL)
           AND uf.franchise_code = cliente.cust_franchise_tax_code
           AND uf.language_code = 2
           AND equip.subscr_no(+) = detalhe.subscr_no
           AND equip_dt.subscr_no(+) = detalhe.subscr_no
           AND equip_dt.subscr_no_resets(+) = detalhe.subscr_no_resets
           AND ( nvl(equip.external_id_type,0) in (6, 7, 9, 0) )
           AND ((TO_CHAR(equip.INACTIVE_DATE,'YYYYMMDD') >= TO_CHAR(fatura.FROM_DATE,'YYYYMMDD') )
                OR equip.INACTIVE_DATE is NULL)
      GROUP BY conta.external_id,
               equip.external_id,
               detalhe.subtype_code,
               de.description_text,
               equip_dt.pop_units,
               detalhe.provider_id,
               detalhe.type_code,
               conta.account_no
      ORDER BY detalhe.provider_id;
      
------------------------------------------------------------------------------------------------
-- Cursor para detalhamento de circuito de dados se for o caso do cliente em questão
   CURSOR circuitos IS
      SELECT gecd.conta_cobranca,
             gecd.id_circuito,
             gecd.conta_servico,
             gecd.nome_cliente,
             gecd.isencao_icms,
             gecd.aliquota_icms/10000 aliquota_icms,
             gecd.ordem_servico,
             gecd.nro_fatura,
             gecd.descricao_produto,
             gecd.cidade,
             gecd.UF,
             gecd.endereco_instalacao,
             gecd.designador,
             gecd.preco_override,
             gecd.faturamento_bruto,
             gecd.descontos,
             gecd.ajustes,
             gecd.ICMS,
             gecd.pis_cofins,
             gecd.ISS,
             gecd.faturamento_liquido,
             TO_CHAR(gecd.data_ativacao,'DD/MM/YYYY') data_ativacao,
             TO_CHAR(gecd.data_inativacao,'DD/MM/YYYY') data_inativacao ,
             TO_CHAR(gecd.date_geracao,'DD/MM/YYYY') date_geracao,
             gecd.tipo_cobraca,
             decode(ssn.open_item_id,0,1,ssn.open_item_id) open_item_id
        FROM gvt_relatorio_circuito_dados gecd, 
             sin_seq_no ssn
       WHERE nro_fatura = v_bill_ref_no
         AND ssn.bill_ref_no = gecd.nro_fatura
        AND ssn.FULL_SIN_SEQ = gecd.NRO_NOTA_FISCAL
       ORDER BY decode(ssn.open_item_id,0,1,ssn.open_item_id), conta_cobranca, id_circuito;



   -- Declarando Função
   FUNCTION GET_SWAP(p_type_id_usg CDR_BILLED.type_id_usg%TYPE) return VARCHAR	
      AS
         vl_swap       VARCHAR(30);
      BEGIN     
        
      SELECT swap_origin_target 
         INTO vl_swap         
   FROM gvt_usage_defs   
   WHERE type_id_usg = p_type_id_usg;           
           
   RETURN vl_swap;
      EXCEPTION     
   WHEN NO_DATA_FOUND
      then return NULL;
   WHEN OTHERS
      then return NULL;
    END;
  
-----------------------------------------------------------------------------------         
-- Definição de procedures
-- Define tratamento de erro para package UTL_FILE
PROCEDURE ErroUtlFile (pRotina varchar2,pMsgErro varchar2) is
BEGIN
    dbms_output.put_line('*** E R R O *** utl_file.'||pRotina||': '||pMsgErro);
    dbms_output.put_line('  Arquivo='||v_diretorio_arquivo||'/'||v_nome_arquivo);
    dbms_output.put_line(SQLERRM);
    utl_file.fflush(v_arq_ponto_conta);
    utl_file.fclose(v_arq_ponto_conta);
END ErroUtlFile; 

-----------------------------------------------------------------------------------         
-- Arquivo de Erros  -- RFC 164552
PROCEDURE Gera_Erro (pLOG  varchar2) is
  texto_log  varchar2(400);
  Out        varchar2(2000);
begin
  if not UTL_FILE.IS_OPEN(yFileERRO) then
    
    begin
      yFileERRO := UTL_FILE.fopen(yDiretorio, yArquivo, 'W');
    exception
      WHEN utl_file.INVALID_PATH THEN
        dbms_output.put_line(chr(10)||'DIRETÓRIO FORNECIDO - INVALIDO');
        Raise erroatuparcel;
      WHEN utl_file.INVALID_OPERATION THEN
        dbms_output.put_line(chr(10)||'OPERACAO INVALIDA - UTL_FILE');
        Raise erroatuparcel;
      WHEN utl_file.WRITE_ERROR THEN
        dbms_output.put_line(chr(10)||'WRITE_ERROR');
        Raise erroatuparcel;
      WHEN OTHERS THEN
        dbms_output.put_line(chr(10)||'ERRO:  '||sqlerrm);
        Raise erroatuparcel;
    end;
    --
    dbms_output.put_line('Arquivo de LOG: '||yDiretorio||'/'||yArquivo);
    --
    utl_file.put_line(yFileERRO,
        'plCONTA_DETALHADA_P_C - CORPORATE - RELATÓRIO DE LOG - Gerado em:'||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')||CHR(10)||chr(10)||
        'ACCOUNT_NO  BILL_REF_NO  CONTA COBRAN  LOG'||chr(10)||
        '----------  -----------  ------------  ------------------------------------------------'
                      );
  end if;
  --
  if instr(pLOG, chr(13)) > 0 then
    texto_log := substr(pLOG, 1, instr(pLOG, chr(13)) );
  else 
    texto_log := pLOG;
  end if;
	if v_cliente is not null then
	  v_bill_ref_no := lpad(nvl(v_bill_ref_no,0),11,' ');
		v_external_id := rpad(nvl(v_external_id,' '),12,' ');
	end if;
  --
  Out  := lpad(v_cliente,10,' ')||'  '|| -- account_no
          v_bill_ref_no||'  '|| -- BILL_REF_NO
          v_external_id||'  '|| -- CONTA
          texto_log;                           -- LOG DE ERROS;
  utl_file.put_line(yFileERRO, Out);
Exception when others then
  dbms_output.put_line(chr(10)||'PU Gera_Erro::'||sqlerrm);
  dbms_output.put_line('-20120, ao Abrir/Gravar: "'||yDiretorio||'/'||yArquivo||chr(10)||sqlerrm);
  Raise erroatuparcel;
end Gera_Erro;
-----------------------------------------------------------------------------------------------
-- procedimento para traduzir a duração de chamadas para o formato HHHHH:MM:SS

   PROCEDURE translate_time (v_total_segundos IN NUMBER, v_time OUT VARCHAR) IS
      v_horas      NUMBER;
      v_minutos    NUMBER;
      v_segundos   NUMBER;
   BEGIN
      v_horas     := TRUNC (v_total_segundos / 3600);
      v_minutos   := TRUNC (MOD (v_total_segundos / 60, 60));
      v_segundos  := MOD (v_total_segundos, 60);
--      v_time      := LPAD (v_horas, 5, 0) ||':'|| LPAD (v_minutos, 2, 0) || ':' || LPAD (v_segundos, 2, 0);
      IF v_flag_resumo = 'S' THEN
         v_time      := LPAD (v_horas, 3, 0) ||':'|| LPAD (v_minutos, 2, 0) || ':' || LPAD (v_segundos, 2, 0);
      ELSE
         v_time      := LPAD (v_horas, 2, 0) || LPAD (v_minutos, 2, 0)  || LPAD (v_segundos, 2, 0);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_time := NULL;
         DBMS_OUTPUT.put_line ('Erro na traducao de SEGUNDOS para HORAS:MINUTOS:SEGUNDOS !');
   END translate_time;

------------------------------------------------------------------------------------------------
-- procedimento para gravar o resumo das chamadas por instância e tipo de uso
   PROCEDURE grava_tab_temp IS
   BEGIN
      v_localizacao := 'grava_tab_temp';
      --ARBORGVT_BILLING.gvt_pl_conta_detalhada
      INSERT INTO ARBORGVT_BILLING.GVT_PL_CONTA_DETALHADA 
      VALUES (t_external_orig, 
              t_account_no, 
              t_type_id_orig, 
              t_soma_min_real, 
              t_soma_min_fat);    
      COMMIT;  
      t_external_id   := null;
      t_account_no    := 0;
      t_type_id_usg   := 0;
      t_soma_min_real := 0;
      t_soma_min_fat  := 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line
                ('Erro no INSERT da tabela gvt_pl_conta_detalhada !' );
       RAISE erroatuparcel;

   END grava_tab_temp;

------------------------------------------------------------------------------------------------
-- procedimento que busca o resumo das chamadas por instância e tipo de uso

   PROCEDURE busca_minuto_faturado IS
   BEGIN
      v_localizacao := 'busca_minuto_faturado';
      --ARBORGVT_BILLING.gvt_pl_conta_detalhada
      SELECT sum (soma_min_real),  sum (soma_min_fat)
      INTO   t_soma_min_real, t_soma_min_fat 
      FROM   ARBORGVT_BILLING.GVT_PL_CONTA_DETALHADA 
      WHERE  account_no  = t_account_no
      AND    type_id_usg = t_type_id_usg
      AND    external_id = t_external_id
      GROUP BY external_id , account_no , type_id_usg;

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN 
         t_soma_min_real := 0;  
         t_soma_min_fat := 0;
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line
                ('Erro na CONSULTA da tabela gvt_pl_conta_detalhada - conta: '||t_account_no ||' - ' ||t_type_id_orig || ' - ' ||t_external_orig || SQLERRM(SQLCODE));
         RAISE erroatuparcel;

   END busca_minuto_faturado;

------------------------------------------------------------------------------------------------
-- procedimento que gera o detalhamento de chamadas no arquivo .conta
   PROCEDURE gera_relatorio_cdr IS
      v_type_id_usg_aux               gvt_duration_usg_variable.type_id_usg%TYPE;
      v_ext_id_aux                    varchar2(48);
      v_madri                         NUMBER;
      v_unidade_minima_corridor       CDR_DATA.RATED_UNITS%TYPE;
      v_units_final                   VARCHAR (12);
      v_units                         CDR_DATA.RATED_UNITS%TYPE;
      v_usage_minimum_rate            gvt_usage_defs.usage_minimum_rate%TYPE;
      v_usage_cadence                 gvt_usage_defs.usage_cadence%TYPE;
      v_set_units_2                   gvt_duration_usg_variable.set_units_2%TYPE;      
      v_set_units                     gvt_usage_defs.set_units%TYPE;
      v_usg_min_rate_variable         gvt_duration_usg_variable.usg_min_rate_variable%TYPE;
      v_is_variable                   gvt_usage_defs.is_variable%TYPE;
      v_convert_factor                usage_units_convert.convert_factor%TYPE;
      v_qtde_usada                    CDR_DATA.RATED_UNITS%TYPE;
      v_unidade_minima_sem_corridor   CDR_DATA.RATED_UNITS%TYPE;
      v_usg_cadence_2                 gvt_duration_usg_variable.usg_cadence_2%TYPE;
      v_segundos_param                NUMBER(10);
      v_second_units                  varchar(12);
      v_account_no                    NUMBER(10);

   BEGIN
      v_localizacao := 'gera_relatorio_cdr';

      UTL_FILE.put_line
         (v_arq_ponto_conta,
             'Cód. Conta Cobrança:CodContaCobr:string:48,0:text'
          || CHR(09)
          || 'Cód. Produto:CodProduto:string:6,0:text'
          || CHR(09)
          || 'Descrição da chamada:DescChamada:string:80,0:text'
          || CHR(09)
          || 'Descrição da jurisdição:DescJurisdicao:string:80,0:text'
          || CHR(09)
          || 'Instância:Instancia:string:48,0:text'
          || CHR(09)
          || 'Destino da chamada:DestChamada:string:48,0:text'
          || CHR(09)
          || 'Cidade Destino:CidadeDest:string:35,0:text'
          || CHR(09)
          || 'Estado Destino:EstadoDest:string:2,0:text'
          || CHR(09)
          || 'Data da Chamada:DataChamada:date:10,0:date'
          || CHR(09)
          || 'Duração Real Chamada:DurRealChamada:string:20,0:text'
          || CHR(09)
          || 'Duração Tarifada Chamada:DurTarifChamada:string:20,0:text'
          || CHR(09)
          || 'Valor Chamada:ValorChamada:decimal:18,2:float2'
          || CHR(09)
          || 'Valor Creditado Chamada:ValorCredChamada:decimal:18,2:float2'
          || CHR(09)
          || 'Período Chamada:PerChamada:string:1,0:text'
          || CHR(09)
          || 'Horário Chamada:HorChamada:string:10,0:text'
         );
      v_type_id_usg_aux := 0;
      v_ext_id_aux := 0;
      
      FOR y IN chamadas LOOP
       BEGIN
       IF y.provider_id = v_provider_id THEN
         -- Zera Variavel de Controle se chamada varia por Madri
         IF (y.type_id_usg <> v_type_id_usg_aux) OR ( y.external_id <> v_ext_id_aux AND v_ext_id_aux <> 0 ) THEN
          -- Quando foi sumarizado todos os valores de uma mesma instância e tipo de uso grava na tabela temporária
                 IF v_type_id_usg_aux <> 0 THEN                      
                   t_external_id := v_ext_id_aux;
                   t_type_id_usg := v_type_id_usg_aux;
                   t_account_no  := v_account_no;
                   grava_tab_temp;
                 END IF; 
--            END IF;
            
            v_madri := 0;
            v_unidade_minima_corridor := 0;
            v_units := 0;

            -- Obtendo definicoes de uso normais para a chamada
            BEGIN
               v_flag_usage:= 'S';
               SELECT NVL (usage_minimum_rate, 0), 
                      NVL (usage_cadence, 0),
                      set_units, 
                      is_variable
                 INTO v_usage_minimum_rate, 
                      v_usage_cadence,
                      v_set_units, 
                      v_is_variable
                 FROM gvt_usage_defs
                WHERE type_id_usg = y.type_id_usg;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_flag_usage:= 'N';
--                  RAISE erroatuparcel;
            END;
            IF v_flag_usage = 'S' THEN
            BEGIN
               IF (y.corridor <> 0 OR v_set_units = 'P') THEN
                  -- Obtendo o valor de CONVERT_FACTOR
                  BEGIN
                     SELECT convert_factor
                       INTO v_convert_factor
                       FROM usage_units_convert
                      WHERE in_units_type = y.billing_units_type
                        AND out_units_type = 100;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        DBMS_OUTPUT.put_line
                           (   'Campos da tabela USAGE_UNITS_CONVERT nao encontrado para: '
                            || y.billing_units_type || ' - account: '||v_account_no
                           );
   --                     RAISE erroatuparcel;
                  END;
               END IF;
   
               -- Tratamento do campo de duracao da chamada tarifada - (UNITS)
               IF y.corridor <> 0 THEN
                  -- Duracao minima para corridor
                  BEGIN
                     SELECT /*+ RULE */
                            NVL (MAX (rub.num_units), 0)
                       INTO v_unidade_minima_corridor
                       FROM rate_usage_bands_overrides rub,
                            rate_usage_overrides ru
                      WHERE ru.inactive_dt IS NULL
                        AND ru.type_id_usg = y.type_id_usg
                        AND ru.jurisdiction = y.juri
                        AND ru.rate_period = y.rate_period
                        AND ru.element_id = y.ele
                        AND ru.corridor_plan_id = y.corridor
                        AND ru.seqnum = rub.seqnum;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.put_line
                           (   'Nao encontrada duracao minima de corridor para o uso : '
                            || y.type_id_usg || ' - account: '||v_account_no
                           );
   --                     RAISE erroatuparcel;
                  END;
               END IF;
            END;
            END IF;
         END IF;

         IF v_flag_usage = 'S' THEN
         BEGIN
            IF v_unidade_minima_corridor <> 0 THEN
               IF y.units < v_unidade_minima_corridor THEN
                  v_units := v_unidade_minima_corridor * v_convert_factor;
               ELSE
                  v_units := y.units * v_convert_factor;
               END IF;
            END IF;
   
            IF (    (v_is_variable = 'Y')
                AND (v_type_id_usg_aux <> y.type_id_usg)
                AND (v_unidade_minima_corridor = 0)
               ) THEN
               -- Obtendo categoria da conta da chamada
               BEGIN
                  SELECT account_category
                    INTO v_account_category
                    FROM cmf
                   WHERE account_no = v_cliente;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     DBMS_OUTPUT.put_line
                        (   'Nao encontrada CMF.ACCOUNT_CATEGORY para a conta : '
                         || v_cliente
                        );
                        RAISE erroatuparcel;
               END;
   
               -- Ajusta variaveis para abrir cursor do madri...
               v_type_id_usg := y.type_id_usg;
               v_element_id  := y.ele;
   
               FOR w IN usos_madri LOOP
                  IF (   (    (w.element_id <> 0)
                          AND (   (w.acct_category = 0)
                               OR (w.acct_category = v_account_category)
                              )
                         )
                      OR (    (w.element_id = 0)
                          AND (w.acct_category = v_account_category)
                         )
                     ) THEN
                     -- Madri...
                     v_madri := 1;
                     -- Buscando qtde usada
                     v_set_units_2 := w.set_units_2;
                     v_usg_min_rate_variable := w.usg_min_rate_variable;
                     v_usg_cadence_2 := w.usg_cadence_2;
                  END IF;
   
                  EXIT WHEN v_madri = 1;
               END LOOP;
            END IF;
   
            IF v_madri = 1 THEN
               IF v_set_units_2 = 'U' THEN
                  v_qtde_usada := y.units;
               ELSIF v_set_units_2 = 'P' THEN
                  v_qtde_usada := y.primary_units;
               ELSIF v_set_units_2 = 'S' THEN
                  v_qtde_usada := y.second_units;
               END IF;
   
               -- Guardando utilizacao conforme madri
               IF v_usg_min_rate_variable > v_qtde_usada THEN
                  v_units := v_usg_min_rate_variable;
               ELSE
                  v_units := y.units * v_usg_cadence_2;
               END IF;
            END IF;
   
            IF (v_madri = 0 AND v_unidade_minima_corridor = 0) THEN
               -- Nao varia nem por Madri nem por Corridor
               IF v_set_units = 'S' THEN
                  IF y.second_units < v_usage_minimum_rate THEN
                     v_units := v_usage_minimum_rate;
                  ELSE
                     v_units := y.units * v_usage_cadence;
                  END IF;
               ELSIF v_set_units = 'P' THEN
                  -- Busca duracao minima sem corridor para cada uso diferente
                  IF v_type_id_usg_aux <> y.type_id_usg THEN
                     v_unidade_minima_sem_corridor := 0;
   
                     BEGIN
                        SELECT /*+ ORDERED USE_NL(RU,RUB) */
                               NVL (MAX (rub.num_units), 0)
                          INTO v_unidade_minima_sem_corridor
                          FROM rate_usage ru, 
                               rate_usage_bands rub
                         WHERE ru.inactive_dt IS NULL
                           AND ru.type_id_usg = y.type_id_usg
                           AND ru.jurisdiction = y.juri
                           AND ru.rate_period = y.rate_period
                           AND ru.element_id = y.ele
                           AND ru.seqnum = rub.seqnum;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           DBMS_OUTPUT.put_line
                              (   'Nao encontrada duracao minima sem corridor para o uso : '
                               || y.type_id_usg || ' - account: '||v_account_no
                              );
   --                     RAISE erroatuparcel;
                     END;
                  END IF;
   
                  IF v_unidade_minima_sem_corridor > y.units THEN
                     v_units := v_unidade_minima_sem_corridor * v_convert_factor;
                  ELSE
                     v_units := y.units * v_convert_factor;
                  END IF;
               ELSE
                  v_units := y.second_units;
               END IF;
            END IF;
         END;
         ELSE 
            v_units :=  y.second_units;
         END IF;

         -- Transforma a duracao real (z.SECOND_UNITS) em campo data(hora,minutos,segundos)
         v_segundos_param  := y.second_units;
         t_soma_min_real   := t_soma_min_real + v_segundos_param;
         
         v_flag_resumo := 'S';
         translate_time (v_segundos_param, v_second_units);
         v_flag_resumo := 'N';
         -- Transforma a duracao tarifada (v_UNITS) em campo data(hora,minutos,segundos)
         v_segundos_param  := v_units;
         t_soma_min_fat    := t_soma_min_fat + v_segundos_param;
         translate_time (v_segundos_param, v_units_final);
         v_type_id_usg_aux := y.type_id_usg;
         v_ext_id_aux      := y.external_id;
         t_external_orig   := y.external_id;
         t_type_id_orig    := y.type_id_usg;
         t_type_id_usg     := v_type_id_usg_aux;
         t_external_id     := y.external_id;
         t_account_no      := y.account_no;
         v_account_no      := y.account_no;            
                    
         -- Retorna o flag swap para decidir se inverter point_origin e point_target para chamadas 
         -- 0800, chamadas cobrar, etc.
         
         v_swap := GET_SWAP(t_type_id_orig);
                          
         --dbms_output.put_line(t_type_id_orig || '#' || v_swap || '#' || y.point_origin || '#' ||y.point_target );
         IF (v_swap IS NOT NULL) THEN
          IF (UPPER(v_swap) = 'Y') THEN
            v_point := y.point_origin;
          ELSE
            v_point := y.point_target;
          END IF;
         ELSE
          v_point := y.point_target;
         END IF;
         
         
         UTL_FILE.put_line (v_arq_ponto_conta, 
                               v_external_id
                            || CHR(09)
                            || y.ele
                            || CHR(09)
                            || y.description_text
                            || CHR(09)
                            || y.des_jur
                            || CHR(09)
                            || y.external_id
                            || CHR(09)
                            || v_point
                            || CHR(09)
                            || y.cid
                            || CHR(09)
                            || y.uf
                            || CHR(09)
                            || to_char(y.trans_dt,'yyyymmdd')
                            || CHR(09)
                            || v_second_units
                            || CHR(09)
                            || v_units_final
                            || CHR(09)
                            || y.am
                            || CHR(09)
                            || y.cred
                            || CHR(09)
                            || y.rate_period
                            || CHR(09)
                            || to_char(y.trans_dt,'hh24:mi:ss')
                           );

       END IF; -- END IF y.provider_id = v_provider_id
       EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Erro em Loop gera_relatorio_cdr : ' || ' ' || SQLERRM(SQLCODE));
         RAISE erroatuparcel;
       END;
      END LOOP;
            
      -- Faz insert para a última volta do Loop
      IF v_type_id_usg_aux <> 0 THEN
         grava_tab_temp;
      END IF;

   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_cdr : ' || ' ' || SQLERRM(SQLCODE));
            
      RAISE erroatuparcel;
   END gera_relatorio_cdr;

------------------------------------------------------------------------------------------------
-- procedimento para gravar o detalhamento de mensalidades
   PROCEDURE gera_relatorio_mensalidade IS
   BEGIN
      v_localizacao := 'gera_relatorio_mensalidade';

      FOR y IN mensalidades LOOP
       IF ( y.provider_id = v_provider_id AND ( y.type_code = 2 OR y.type_code = 3 ) ) THEN
         IF v_flag_mensalidade = 'S' THEN
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line (v_arq_ponto_conta, nome_operadora);
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line (v_arq_ponto_conta, 'Serviços Mensais'|| CHR (09) ||'ServMens'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line
               (v_arq_ponto_conta,
                   'Cód. Conta Cobrança:CodContaCobr:string:48,0:text'
                || CHR(09)
                || 'Instância:Instancia:string:48,0:text'
                || CHR(09)
                || 'Cód. Produto:CodProduto:string:6,0:text'
                || CHR(09)
                || 'Desc. Produto:DescProduto:string:80,0:text'
                || CHR(09)
                || 'Quantidade de ramais:QtdRamais:integer:10,0:integer'
                || CHR(09)
                || 'Somatória dos valores:SomaValores:decimal:18,2:float2'
                || CHR(09)
                || 'Somatória dos descontos:SomaDescontos:decimal:18,2:float2'
                || CHR(09)
                || 'Saldo:Saldo:decimal:18,2:float2'
               );
            v_flag_mensalidade := 'N';
         END IF;
         UTL_FILE.put_line (v_arq_ponto_conta,
                               v_external_id
                            || CHR (09)
                            || y.equip_external_id
                            || CHR (09)
                            || y.produto
                            || CHR (09)
                            || y.nome_produto
                            || CHR (09)
                            || y.qtde_ramais
                            || CHR (09)
                            || y.amount
                            || CHR (09)
                            || y.discount
                            || CHR (09)
                            || y.saldo
                           );
       END IF;
      END LOOP;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_mensalidade : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_mensalidade;

------------------------------------------------------------------------------------------------
-- procedimento para gravar o relatório de circuito de dados no arquivo
   PROCEDURE gera_relatorio_circ_dados IS
   BEGIN
      v_localizacao := 'gera_relatorio_circ_dados';
     FOR c IN circuitos
      LOOP
       BEGIN
       IF c.open_item_id = v_open_item_id THEN
         IF v_flag_circuito = 'S' THEN
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line (v_arq_ponto_conta, nome_operadora);
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            UTL_FILE.put_line (v_arq_ponto_conta,'Circuito de Dados'|| CHR (09) ||'CircDados'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
            
            UTL_FILE.put_line
               (v_arq_ponto_conta,
                  'Cód. Conta cobrança:CodContaCobr:string:48,0:text'
               || CHR (09)
               || 'Circuito:Circuito:integer:10,0:integer'
               || CHR (09)
               || 'Identificador Conta Serviço:IdentContaServ:string:22,0:text'
               || CHR (09)
               || 'Nome do Cliente:NomeCtaServico:string:56,0:text'
               || CHR (09)
               || 'ICMS Isento:IcmsIsento:string:1,0:text'
               || CHR (09)
               || 'Alíquota ICMS:AliqICMS:decimal:10,2:float2'
               || CHR (09)
               || 'Ordem Serviço:OrdServico:string:15,0:text'
               || CHR (09)
               || 'Número da Fatura:NumFatura:string:10,0:text'
               || CHR (09)
               || 'Descrição do Produto:DescProduto:string:80,0:text'
               || CHR (09)
               || 'Cidade:Cidade:string:35,0:text'
               || CHR (09)
               || 'UF:UF:string:28,0:text'
               || CHR (09)
               || 'Endereço de Instalação:EndInstalacao:string:200,0:text'
               || CHR (09)
               || 'Designador:Designador:string:100,0:text'
               || CHR (09)
               || 'Preço contratado:PrecOverride:decimal:18,2:float2'
               || CHR (09)
               || 'Faturamento Bruto:FatBruto:decimal:18,2:float2'
               || CHR (09)
               || 'Descontos:Descontos:decimal:18,2:float2'
               || CHR (09)
               || 'Ajustes:Ajustes:decimal:18,2:float2'
               || CHR (09)
               || 'ICMS:ICMS:decimal:18,2:float2'
               || CHR (09)
               || 'PIS/Cofins:PisCofins:decimal:18,2:float2'
               || CHR (09)
               || 'ISS:ISS:decimal:18,2:float2'
               || CHR (09)
               || 'Faturam. Líquido:FatLiquido:decimal:18,2:float2'
               || CHR (09)
               || 'Data Ativação:DtAtivacao:string:20,0:text'
               || CHR (09)
               || 'Data Inativação:DtInativacao:string:20,0:text'
               || CHR (09)
               || 'Data Geração:DtGeracao:string:20,0:text'
               || CHR (09)
               || 'Tipo de Cobrança:TipoCob:string:20,0:text');
            
            v_flag_circuito := 'N';
         END IF;
         UTL_FILE.put_line (v_arq_ponto_conta,
                               c.conta_cobranca
                            || CHR (09)
                            || c.id_circuito
                            || CHR (09)
                            || c.conta_servico
                            || CHR (09)
                            || c.nome_cliente
                            || CHR (09)
                            || c.isencao_icms
                            || CHR (09)
                            || c.aliquota_icms
                            || CHR (09)
                            || c.ordem_servico
                            || CHR (09)
                            || c.nro_fatura
                            || CHR (09)
                            || c.descricao_produto
                            || CHR (09)
                            || c.cidade
                            || CHR (09)
                            || c.UF
                            || CHR (09)
                            || c.endereco_instalacao
                            || CHR (09)
                            || c.designador
                            || CHR (09)
                            || c.preco_override
                            || CHR (09)
                            || c.faturamento_bruto
                            || CHR (09)
                            || c.descontos
                            || CHR (09)
                            || c.ajustes
                            || CHR (09)
                            || c.ICMS
                            || CHR (09)
                            || c.pis_cofins
                            || CHR (09)
                            || c.ISS
                            || CHR (09)
                            || c.faturamento_liquido
                            || CHR (09)
                            || c.data_ativacao                          
                            || CHR (09)
                            || c.data_inativacao
                            || CHR (09)
                            || c.date_geracao
                            || CHR (09)
                            || c.tipo_cobraca
                           );
       END IF;
       EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Erro em Loop gera_relatorio_circ_dados : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
       END;
      END LOOP;

   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_circ_dados : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_circ_dados;

------------------------------------------------------------------------------------------------
-- procedimento para gravar o resumo de todas as cobranças, exceto circuito de dados

   PROCEDURE gera_relatorio_resumo IS
        v_units_final       VARCHAR (20);
        v_units_final_fat   VARCHAR (20);
   BEGIN
      v_localizacao := 'gera_relatorio_resumo';
     UTL_FILE.put_line
         (v_arq_ponto_conta,
            'Cód. Conta cobrança:CodContaCobr:string:48,0:text'
         || CHR (09)
         || 'Instância:Instancia:string:48,0:text'
         || CHR (09)
         || 'Cód. Produto:CodProduto:string:6,0:text'
         || CHR (09)
         || 'Desc. Produto:DescProduto:string:80,0:text'
         || CHR (09)
         || 'Somatória de minutos:SomaMinutos:string:12,0:text'
         || CHR (09)
         || 'Somatória dos valores:SomaValores:decimal:18,2:float2'
         || CHR (09)
         || 'Somatória dos descontos:SomaDescontos:decimal:18,2:float2'
         || CHR (09)
         || 'Saldo:Saldo:decimal:18,2:float2'
         || CHR (09)
         || 'Somatória de minutos faturados:SomaMinutosFaturados:string:12,0:text'
         );

     FOR y IN mensalidades LOOP
      BEGIN
       IF ( y.provider_id = v_provider_id ) THEN
         IF y.type_code = 7 THEN
            t_account_no  := y.account_no;
            t_type_id_usg := y.produto;
            t_external_id := y.equip_external_id; 
  
            busca_minuto_faturado;                                              
            
            v_flag_resumo := 'S';
            translate_time (t_soma_min_real, v_units_final);
 
            translate_time (t_soma_min_fat, v_units_final_fat);
            v_flag_resumo := 'N';            

         ELSE
            t_soma_min_fat  := 0;
            t_soma_min_real := 0;
            v_units_final   := ' ';
            v_units_final_fat := ' ';
         END IF;

         UTL_FILE.put_line (v_arq_ponto_conta,                      
                               y.conta
                            || CHR (09)
                            || y.equip_external_id
                            || CHR (09)
                            || y.produto
                            || CHR (09)
                            || y.nome_produto
                            || CHR (09)
                            || v_units_final
                            || CHR (09)
                            || y.amount
                            || CHR (09)
                            || y.discount
                            || CHR (09)
                            || y.saldo
                            || CHR (09)
                            || v_units_final_fat
                           );

       END IF;
       EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('Erro em Loop gera_relatorio_resumo : ' || ' ' || SQLERRM(SQLCODE));
         RAISE erroatuparcel;
      END;
     END LOOP;

   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_resumo : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_resumo;
 
------------------------------------------------------------------------------------------------
-- procedimento para gravar o cabeçalho do arquivo .conta

   PROCEDURE imprime_inicio IS
      nota_fiscal    VARCHAR (40);
      data_inicio    DATE;
      data_fim       DATE;
      nome_cliente   VARCHAR (60);
      vencim_fat     DATE;
      emissao_fat    DATE;
      uf             VARCHAR (4);
      nro_fatura     NUMBER (10);
   BEGIN
      v_localizacao := 'imprime_inicio';

      SELECT TRIM (s.full_sin_seq), 
             b.from_date, 
             b.TO_DATE,
             TRIM (c.bill_lname), 
             b.payment_due_date, 
             b.statement_date,
             TRIM (c.bill_state), 
             b.bill_ref_no
        INTO nota_fiscal, 
             data_inicio, 
             data_fim,
             nome_cliente, 
             vencim_fat, 
             emissao_fat,
             uf,
       nro_fatura
        FROM bill_invoice b, 
             sin_seq_no s, 
             cmf c
       WHERE b.account_no = v_cliente
         AND b.bill_ref_no = v_bill_ref_no
         AND b.bill_ref_no = s.bill_ref_no
         and s.open_item_id <= 3
         AND c.account_no = b.account_no;

      -- tratar exeption
      UTL_FILE.put_line (v_arq_ponto_conta, nota_fiscal);
      UTL_FILE.put_line (v_arq_ponto_conta, to_char(data_inicio,'yyyymmdd'));
      UTL_FILE.put_line (v_arq_ponto_conta, to_char(data_fim,'yyyymmdd'));
      UTL_FILE.put_line (v_arq_ponto_conta, nome_cliente);
      UTL_FILE.put_line (v_arq_ponto_conta, to_char(vencim_fat,'yyyymmdd'));
      UTL_FILE.put_line (v_arq_ponto_conta, to_char(emissao_fat,'yyyymmdd'));
      UTL_FILE.put_line (v_arq_ponto_conta, uf);
      UTL_FILE.put_line (v_arq_ponto_conta, nro_fatura);

   
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em imprime_inicio : ' || ' ' || SQLERRM(SQLCODE));
      --DBMS_OUTPUT.PUT_LINE('CLIENTE: ' || v_cliente || ' FATURA:' || nro_fatura);
      DBMS_OUTPUT.PUT_LINE('CLIENTE: ' || v_cliente || ' FATURA:' || v_bill_ref_no); -- RFC 126356 - Valter Rogério Ciolari (04/12/2009)
      RAISE erroatuparcel;
   END imprime_inicio;


------------------------------------------------------------------------------------------------
-- procedimento para buscar a descrição da operadora
   PROCEDURE csp_descricao (v_provider_id in varchar2, v_descr OUT varchar2) IS
   BEGIN
      SELECT trim(display_value)
        INTO v_descr
        FROM service_providers_values
       WHERE provider_id = v_provider_id AND language_code = 2;
       
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em csp_descricao : ' || ' ' || SQLERRM(SQLCODE));        
      RAISE erroatuparcel;
   END csp_descricao;

------------------------------------------------------------------------------------------------
-- procedimento para buscar a descrição da operadora
   PROCEDURE consulta_fatura IS
     v_prep_status  varchar2(30);
     v_prep_error_code number(6);
   BEGIN
      v_localizacao := 'consulta_fatura';
      v_existe_fatura := 0;
      
      -- confirma existencia da fatura            
      IF v_bill_ref_no IS NOT NULL THEN
         v_existe_fatura := 1;
      else
         Gera_Erro('Nao existe Fatura.');
         yqtde_sem_fatura := nvl(yqtde_sem_fatura,0) + 1;
      END IF;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         v_existe_fatura := 0;
         Gera_Erro('Nao existe Fatura.');
         yqtde_sem_fatura := nvl(yqtde_sem_fatura,0) + 1;
         RAISE erroatuparcel;
      WHEN OTHERS THEN
         v_existe_fatura := 0;
         Gera_Erro('Erro consulta_fatura; ORA:'||sqlerrm);
         --DBMS_OUTPUT.put_line('ORA - Erro consulta_fatura (ACCOUNT_NO) = '|| v_cliente );
     RAISE erroatuparcel;
   END consulta_fatura;

------------------------------------------------------------------------------------------------

PROCEDURE grava_tabela_conta_internet (p_account_no in number,p_external_id in varchar2, p_bill_ref_no in number, p_data_processamento in date, p_nome_arq in varchar2,p_existe_fatura char) is
BEGIN
   v_localizacao := 'grava_tabela_conta_internet';

   INSERT INTO gvt_conta_internet (ACCOUNT_NO,EXTERNAL_ID,BILL_REF_NO,DATA_PROCESSAMENTO,NOME_ARQUIVO,EXISTE_FATURA)
     VALUES (p_account_no,p_external_id,p_bill_ref_no,p_data_processamento,p_nome_arq,p_existe_fatura);
   COMMIT;
   
   EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO : GRAVAÇÃO DE PARÂMETROS NA TABELA GVT_CONTA_INTERNET');
        dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
        RAISE erroatuparcel;      
       
END grava_tabela_conta_internet;    
------------------------------------------------------------------------------------------------
--- Início do programa
------------------------------------------------------------------------------------------------

BEGIN
  dbms_output.put_line('pl_conta_detalhada - Corporate'||chr(10)||rpad('-',50,'-') ); -- RFC 156351
  dbms_output.put_line('Inicio ..........: '|| TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
  
  FOR regc0 IN consulta_cliente  LOOP
  BEGIN
    v_cliente := regc0.ACCOUNT_NO; 
	v_bill_ref_no := regc0.BILL_REF_NO; 
	v_mes := TO_CHAR(regc0.PAYMENT_DUE_DATE,'YYYYMM'); 	
    yqtde_bip       := nvl(yqtde_bip,0) + 1;

    consulta_fatura;    

    IF v_existe_fatura = 1 THEN
		-- RFC 126356 - Valter Rogério Ciolari (04/12/2009)
		begin
		  Select 1 into dummy from sin_seq_no where bill_ref_no = v_bill_ref_no;
		exception
		  when no_data_found then
			Gera_Erro('Fatura não possui Nota Fiscal.');
			yqtde_sem_nota := nvl(yqtde_sem_nota,0) + 1;
			v_existe_fatura := 0;
		  when others then
			null;
		end;
		  
      SELECT external_id
	     INTO   v_external_id
	     FROM   CUSTOMER_ID_ACCT_MAP
		WHERE  account_no = v_cliente 
		AND    external_id_type = 1;
	END IF;
      
    IF v_existe_fatura = 1 THEN
         
         
      -- para formatar o nome exe: 2006Maio999999999999_250.cdc
      IF SUBSTR(v_mes, 5, 2) = '12'  THEN v_mes_b := 'Dezembro';  END IF;
      IF SUBSTR(v_mes, 5, 2) = '11'  THEN v_mes_b := 'Novembro';  END IF;
      IF SUBSTR(v_mes, 5, 2) = '10'  THEN v_mes_b := 'Outubro';   END IF;
      IF SUBSTR(v_mes, 5, 2) = '09'  THEN v_mes_b := 'Setembro';  END IF;
      IF SUBSTR(v_mes, 5, 2) = '08'  THEN v_mes_b := 'Agosto';    END IF;
      IF SUBSTR(v_mes, 5, 2) = '07'  THEN v_mes_b := 'Julho';     END IF;
      IF SUBSTR(v_mes, 5, 2) = '06'  THEN v_mes_b := 'Junho';     END IF;
      IF SUBSTR(v_mes, 5, 2) = '05'  THEN v_mes_b := 'Maio';      END IF;
      IF SUBSTR(v_mes, 5, 2) = '04'  THEN v_mes_b := 'Abril';     END IF;
      IF SUBSTR(v_mes, 5, 2) = '03'  THEN v_mes_b := 'Marco';     END IF;
      IF SUBSTR(v_mes, 5, 2) = '02'  THEN v_mes_b := 'Fevereiro'; END IF;
      IF SUBSTR(v_mes, 5, 2) = '01'  THEN v_mes_b := 'Janeiro';   END IF;

      FIRST_TIME := true;
      eOPERADORA := false;

      -- Aqui colocar Loop por operadora
      FOR x IN operadora_csp LOOP
      BEGIN
        eOPERADORA := true;
        -- Deverá criar o arquivo somente se houver Detalhes da Fatura.
        IF FIRST_TIME THEN
          FIRST_TIME := FALSE;
          -- Alterado para incluir arquivo na pasta Mes + ultimo digito do numero da conta + nome do arquivo
          -- Ex : Outubro/5/2006Maio999999999999_250.cdc
          v_nome_arquivo := trim(v_mes_b) || '/' || substr(trim(v_external_id),12,1) || '/' || SUBSTR(v_mes, 1, 4)|| TRIM(v_mes_b)||trim(v_external_id) ||'_250.cdc';
          --v_nome_arquivo := SUBSTR(v_mes, 1, 4)|| TRIM(v_mes_b)||trim(v_external_id) ||'_250.cdc';

          v_arq_ponto_conta := UTL_FILE.fopen (v_diretorio_arquivo, v_nome_arquivo , 'w',5000);
          
          yqtde_gerada := nvl(yqtde_gerada,0) + 1;

          imprime_inicio;
          UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        END IF;

        v_flag_mensalidade := 'S';
        v_flag_circuito    := 'S'; -- RFC 156351

        v_provider_id := x.provider_id;
        v_open_item_id := x.open_item_id;
        csp_descricao (x.provider_id, nome_operadora);

        IF v_provider_id <> 25 then
           UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        END IF;
        UTL_FILE.put_line (v_arq_ponto_conta, nome_operadora);
        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        UTL_FILE.put_line (v_arq_ponto_conta, 'Chamadas'|| CHR (09) ||'Chamadas'|| CHR (09) ||'sim');
        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));

        gera_relatorio_cdr;

        gera_relatorio_mensalidade;

        gera_relatorio_circ_dados;

        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        UTL_FILE.put_line (v_arq_ponto_conta, nome_operadora);
        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        UTL_FILE.put_line (v_arq_ponto_conta, 'Resumo'|| CHR (09) ||'Resumo'|| CHR (09) ||'nao');
        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));
        gera_relatorio_resumo;
        UTL_FILE.put_line (v_arq_ponto_conta, CHR (09));

      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro no FOR x IN operadora_csp : ' || ' ' || SQLERRM(SQLCODE));
        RAISE erroatuparcel;
      END;
      END LOOP; -- END ... FOR x IN operadora_csp

      UTL_FILE.fclose (v_arq_ponto_conta);
	  
	  BEGIN
		update G0023421SQL.CDC_PROCESSAR_BACKLOG
		set processo = nvl(processo,0) + 500
		where account_no = v_cliente
		and bill_ref_no = v_bill_ref_no;
		COMMIT;
	  EXCEPTION WHEN OTHERS THEN
	    COMMIT;
        DBMS_OUTPUT.PUT_LINE('Erro no update da tabela CDC_PROCESSAR_BACKLOG: ' || ' ' || SQLERRM(SQLCODE));
        RAISE erroatuparcel;
      END;

      v_numero_conta  := trim(v_external_id);
      v_numero_fatura := v_bill_ref_no;

      BEGIN
        SP_MARCA_GERACAO_CONTA_FACIL ( v_numero_conta, v_numero_fatura );
      END;

      grava_tabela_conta_internet(v_cliente, v_numero_conta, v_numero_fatura, sysdate, v_nome_arquivo, 1);
      
      if not eOPERADORA then
        Gera_Erro('Não existem Usos.');
        yqtde_sem_usos := nvl(yqtde_sem_usos,0) + 1;
      end if;

    ELSE
      grava_tabela_conta_internet(v_cliente, trim(v_external_id), NULL, SYSDATE, NULL, 0);
      yqtde_erro := nvl(yqtde_erro,0) + 1;
    END IF; -- END ... IF v_existe_fatura = 1
    
  EXCEPTION 
    WHEN UTL_FILE.INVALID_PATH THEN
        ErroUtlFile (v_localizacao,'ERRO :invalid_path');
        dbms_output.put_line('ERRO :Verif a exist do param. UTL_FILE_DIR no init');
        RAISE erroatuparcel;
    WHEN UTL_FILE.INVALID_OPERATION THEN
        ErroUtlFile (v_localizacao,'ERRO :invalid_operation');
        RAISE erroatuparcel;
    WHEN UTL_FILE.WRITE_ERROR THEN
        ErroUtlFile (v_localizacao,'ERRO :write_error'); 
        RAISE erroatuparcel;
    WHEN erroatuparcel THEN
         dbms_output.put_line(v_localizacao);
         dbms_output.put_line('atencao --- Erro geral ');
         dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
         ROLLBACK;
     WHEN OTHERS THEN
        UTL_FILE.fclose (v_arq_ponto_conta);
        DBMS_OUTPUT.PUT_LINE('Erro no Loop principal : ' || ' ' || SQLERRM(SQLCODE));
        RAISE erroatuparcel;
  END; -- BEGIN
  END LOOP; -- END ... LOOP principal
  
  
  dbms_output.put_line('Final ...........: '|| to_char(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
  dbms_output.put_line('Tempo ...........: '|| to_char(trunc(sysdate) + (sysdate-ytempo_ini),'hh24:mi:ss') );
  dbms_output.put_line('-------------------------------------');
  dbms_output.put_line('.'||lpad(yqtde_bip   ,8,' ')||' contas estavam no BIP.');
  dbms_output.put_line('.'||lpad(yqtde_gerada,8,' ')||' contas tiveram arquivos gerados.');
  if yqtde_erro + yqtde_sem_fatura + yqtde_sem_nota + yqtde_sem_usos > 0 then
  dbms_output.put_line('.'||lpad(yqtde_erro  ,8,' ')||' contas tiveram erros.');
  dbms_output.put_line('.'||lpad(yqtde_sem_fatura ,8,' ')||' contas não tinham fatura.');
  dbms_output.put_line('.'||lpad(yqtde_sem_nota   ,8,' ')||' contas não tinham nota fiscal.');
  dbms_output.put_line('.'||lpad(yqtde_sem_usos   ,8,' ')||' contas não tinham CDRs.');
  end if;
  v_cliente := null;
  v_bill_ref_no := null;
  v_external_id := null;
  Gera_Erro('Final ...........: '|| to_char(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
  Gera_Erro('Tempo ...........: '|| to_char(trunc(sysdate) + (sysdate-ytempo_ini),'hh24:mi:ss') );
  Gera_Erro('-------------------------------------');
  Gera_Erro('.'||lpad(yqtde_bip   ,8,' ')||' contas estavam no BIP.');
  Gera_Erro('.'||lpad(yqtde_gerada,8,' ')||' contas tiveram arquivos gerados.');
  if yqtde_erro + yqtde_sem_fatura + yqtde_sem_nota + yqtde_sem_usos > 0 then
  Gera_Erro('.'||lpad(yqtde_erro  ,8,' ')||' contas tiveram erros.');
  Gera_Erro('.'||lpad(yqtde_sem_fatura ,8,' ')||' contas não tinham fatura.');
  Gera_Erro('.'||lpad(yqtde_sem_nota   ,8,' ')||' contas não tinham nota fiscal.');
  Gera_Erro('.'||lpad(yqtde_sem_usos   ,8,' ')||' contas não tinham CDRs.');
  end if;
  utl_file.fclose(yFileERRO);
  
EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
      ErroUtlFile (v_localizacao,'ERRO :invalid_path');
      dbms_output.put_line('ERRO :Verif a exist do param. UTL_FILE_DIR no init');
            RAISE erroatuparcel;
  WHEN UTL_FILE.INVALID_OPERATION THEN
      ErroUtlFile (v_localizacao,'ERRO :invalid_operation');
            RAISE erroatuparcel;
  WHEN UTL_FILE.WRITE_ERROR THEN
      ErroUtlFile (v_localizacao,'ERRO :write_error'); 
            RAISE erroatuparcel;
  WHEN erroatuparcel THEN
       dbms_output.put_line(v_localizacao);
       dbms_output.put_line('atencao --- Erro geral ');
       dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
       ROLLBACK;
  WHEN OTHERS THEN
       dbms_output.put_line(v_localizacao);
       dbms_output.put_line('ERRO DESCONHECIDO ');
       dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
       ROLLBACK; 

END;
/
EXIT;

