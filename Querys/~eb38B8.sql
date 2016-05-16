SET VERIFY                     OFF;
SET SERVEROUT                  ON SIZE 1000000
SET FEED                       OFF;
SET SPACE                      0;
SET PAGESIZE                   0;
SET LINE                       500;
SET WRAP                       ON;
SET HEADING                    OFF;
DECLARE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Nome Arquivo: 
-- Vers�o:   1.0
-- Autor:    Caroline Martins
-- Data:     Abril/2009
-- Gera informa��es para disponibilizar na Web a conta detalhada para clientes Retail.
----------------------------------------------------------------------------------------------
-- Vers�o: Autor:               Data:       Doc:        Motivo:
   ------  -------------------- ----------- ----------- --------------------------------------
-- 1.1     Valter (g0010388)    18/Feb/2010 RFC 156351  Omitir a linhas em branco sup�rfluas.
-- 1.2     g0010388 Valter      31/MAR/2010 RFC 164552  Gerar arquivo de LOG.
-- 1.3     P9906496 Daniel		  28/JUN/2011             Inclus�o de servi�os de TV
-- 1.4     g0010388 Valter      31/AUG/2011 RFC 329629  Corre��o de Erro character to number conversion error
-- 1.5     g0007405 Evelize     03/OUT/2012 RFC 390828  Corre��o de c�lculo dos descontos.
----------------------------------------------------------------------------------------------


   v_diretorio_arquivo     VARCHAR2 (100) := '&1';
   v_prep_date             DATE           := TO_DATE (&2, 'yyyymmddhh24miss');
   v_tipo_processamento    VARCHAR(20)    := '&3';
   v_prep_date_fim         DATE           := TO_DATE (&4, 'yyyymmddhh24miss');
   i_Account_category      varchar2(30)   := '&5';
   i_Processo              varchar2(03)   := '&6';
   v_cliente               cmf.account_no%TYPE;
   v_bill_ref_no           bill_invoice.bill_ref_no%TYPE;
   v_existe_fatura         NUMBER (1);
   Time                    date;
   data_base               varchar2(100);

   v_type_id_usg           gvt_duration_usg_variable.type_id_usg%TYPE;
   v_account_category      cmf.account_category%TYPE;
   v_element_id            NUMBER;
   retorno                 INTEGER;
   cursorclientes          INTEGER;
   vcliente                cmf.account_no%TYPE;
   v_external_id           customer_id_acct_map.external_id%TYPE;
   ssql                    VARCHAR2 (600);
   v_arq_ponto_conta       UTL_FILE.file_type;
   v_nome_arquivo          VARCHAR2 (150);
   nome_operadora          VARCHAR2 (80);
   v_provider_id           NUMBER (6);
   v_open_item_id          NUMBER (3);
   v_mes                   CHAR(06);
   v_mes_b                 CHAR(10);
   v_flag_usage            CHAR(01);

   t_external_orig         CHAR(48); -- Inst�ncia de servi�o
   t_type_id_orig          NUMBER (6);
   t_external_id           CHAR(48); -- Inst�ncia de servi�o
   t_account_no            NUMBER (10);
   t_type_id_usg           NUMBER (6);
   t_soma_min_real         NUMBER (10) := 0;
   t_soma_min_fat          NUMBER (10) := 0;
                           
   erroatuparcel           EXCEPTION;
   iLocal                  VARCHAR2(250);        -- controle erro: nome proced. em execucao
   
   v_flag_mensalidade      CHAR(01):= 'S';
   v_flag_nrc              CHAR(01):= 'S';
   v_flag_desconto         CHAR(01):= 'S';
   v_flag_encargo          CHAR(01):= 'S';
   v_flag_cdr              CHAR(01):= 'S';
   v_flag_resumo           CHAR(01):= 'N';
   v_numero_conta          NUMBER;
   v_numero_fatura         VARCHAR2(200);

   v_point                 CDR_DATA.POINT_ORIGIN%TYPE;
   v_swap                gvt_usage_defs.swap_origin_target%TYPE;
   
    dummy                  number;-- ini: RFC 156351
    ----------------------- -- ini: RFC 164552
    yFileERRO            UTL_FILE.file_type;
    yDiretorio           Varchar2(100) := v_diretorio_arquivo;
    yArquivo             Varchar2(80) := 'LOG_pl_conta_detalhada_P_R_'||to_char(sysdate,'yyyymmddhh24miss')||'.txt';
    First_Time           boolean;
    yqtde_bip              number(8) := 0;
    yqtde_gerada           number(8) := 0;
    yqtde_erro             number(8) := 0;
    yqtde_sem_fatura       number(8) := 0;
    yqtde_sem_nota         number(8) := 0;
    yqtde_sem_usos         number(8) := 0;
    ----------------------- -- fim: RFC 164552

/*********************************************************************************************/
   -- Declarando Cursor
   CURSOR consulta_cliente IS
      SELECT C.ACCOUNT_NO
      FROM   CMF C , 
             GVT_CONTAS_CONTAFACIL G 
      WHERE  C.ACCOUNT_NO = G.ACCOUNT_NO 
       AND   C.ACCOUNT_TYPE = 1
       AND   G.account_category in (&5)
       and   G.processo = &6;

/*********************************************************************************************/
/***
**** Cursor que separa a fatura por Notas Fiscais
***/
   CURSOR operadora_csp IS
      SELECT DISTINCT DECODE(provider_id,251,25,provider_id) provider_id,  -- Alterado para agrupar os providers de TV
             decode(open_item_id,2,1,3,1,90,1,91,1,92,1,open_item_id) open_item_id -- Incluido itens 90, 91 e 92 para TV
      FROM   bill_invoice bi, 
             bill_invoice_detail bid
      WHERE  bi.account_no = v_cliente
       AND   bi.bill_ref_no = v_bill_ref_no
       AND   bi.bill_ref_no = bid.bill_ref_no
       AND   bi.bill_ref_resets = bid.bill_ref_resets
       AND   bid.type_code IN (2, 3, 7)
       ORDER BY decode(open_item_id,2,1,3,1,90,1,91,1,92,1,open_item_id); -- Incluido itens 90, 91 e 92 para TV
   eOPERADORA boolean;

------------------------------------------------------------------------------------------------
/***
**** Cursor para detalhamento de chamadas de uma fatura
***/
   CURSOR chamadas IS
      SELECT bed.type_id_usg ele, 
             bi.PAYMENT_DUE_DATE venc_fat,
       BFTV.DISPLAY_VALUE tipo_lig,
             des.description_text,
             des_jur.description_text des_jur, 
             cdr_data.external_id, 
             bed.account_no,
             bed.point_origin,
             bed.point_target, 
             UP.point_city cid, 
             UP.point_state_abbr uf,
             bed.trans_dt trans_dt,
             cdr_data.primary_units, 
             cdr_data.second_units, 
             cdr_data.rated_units units,
             bed.type_id_usg, 
             cdr_data.billing_units_type, 
             (cdr_data.amount) am,
             (bed.amount_credited) cred,
             (bed.billed_amount-bed.amount_credited) vlr_cham,  
             cdr_data.rate_period,
             cdr_data.corridor_plan_id corridor, 
             cdr_data.jurisdiction juri, 
             cdr_data.provider_id
        FROM jurisdictions jur,
             descriptions des_jur,
             descriptions des,
             descriptions des_ele,
             usage_points UP,
             usage_types tp_uso,
             cdr_billed bed,
			       cdr_data,
             bill_invoice bi,
             BILL_FORMAT_TEMPLATE BFT,
             BILL_FMT_TEMPLATE_CODE_VALUES BFTV
       WHERE bi.account_no = v_cliente
         AND bi.bill_ref_no = v_bill_ref_no
         AND bed.bill_ref_no = bi.bill_ref_no
         AND tp_uso.type_id_usg = bed.type_id_usg
         AND tp_uso.type_id_usg NOT IN (100, 101, 103, 104, 150, 151, 152, 153)
         AND des.description_code = tp_uso.description_code
         AND des.language_code = 2
         AND des_ele.description_code = cdr_data.element_id
         AND des_ele.language_code = 2
		 		 AND cdr_data.msg_id = bed.msg_id
		     AND cdr_data.msg_id2 = bed.msg_id2
		     AND cdr_data.msg_id_serv = bed.msg_id_serv
		     AND cdr_data.cdr_data_partition_key = bed.cdr_data_partition_key 
         AND BFT.CODE_VALUE = BED.TYPE_ID_USG
         AND BFTV.TEMPLATE_CODE = BFT.TEMPLATE_CODE
         AND BFTV.LANGUAGE_CODE = 2
         AND UP.point_id(+) = DECODE (point_id_target, 0, point_id_origin, point_id_target )
         AND jur.jurisdiction(+) = cdr_data.jurisdiction
         AND des_jur.description_code(+) = jur.description_code
         AND (des_jur.language_code = 2 OR des_jur.language_code IS NULL)
         AND tp_uso.product_line_id <> 11982 -- Incluido para eliminar usos de TV
         ORDER BY cdr_data.provider_id, cdr_data.external_id, bed.type_id_usg, bed.trans_dt;

------------------------------------------------------------------------------------------------
/***
**** Cursor para tratar a duara��o de chamadas de usos Plano Madri
***/   
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
/***
**** Cursor para tratar usos de TV
***/ 
CURSOR usos_tv IS
select DECODE(cd.provider_id,251,25,cd.provider_id) provider_id, des.description_text as tipo_inst, cd.external_id as inst,
       cd.customer_tag as nome_produto,
       cd.amount, cd.trans_dt as trans_dt
  from cdr_data cd, cdr_billed cb, usage_types ut, descriptions des
 where 1 = 1
   and des.description_code = ut.description_code
   and des.language_code = 2
   and cb.type_id_usg = ut.type_id_usg
   and cd.msg_id = cb.msg_id
   and cd.msg_id2 = cb.msg_id2
   and cd.msg_id_serv = cb.msg_id_serv
   and cd.split_row_num = cb.split_row_num
   and cd.cdr_data_partition_key = cb.cdr_data_partition_key
   and ut.product_line_id = 11982 -- Linha de produtos do PAY TV
   and cb.bill_ref_resets = 0
   and cb.bill_ref_no = v_bill_ref_no
   and cb.account_no = v_cliente;

------------------------------------------------------------------------------------------------      
/***
**** Cursor para detalhamento de RC�s e NRC�s cobrados na fatura
***/
   CURSOR mensalidades IS
    select bi.account_no, 
     bi.BILL_REF_NO,
       ecv.DISPLAY_VALUE tipo_inst,
       trim(eiem.EXTERNAL_ID) inst,
       DES.DESCRIPTION_TEXT nome_produto,
       BID.FROM_DATE dt_ini,
       BID.TO_DATE dt_fim,
     bid.OPEN_ITEM_ID,
     bid.type_code,
     bid.SUBTYPE_CODE produto,
     bid.discount_id,
     des2.DESCRIPTION_TEXT nome_desconto, 
     SUM (bid.amount) + SUM (bid.discount) saldo,
     SUM(BID.AMOUNT) AMOUNT,
     SUM(BID.DISCOUNT) AMOUNT_DISCOUNT,
     DECODE(bid.provider_id,251,25,bid.provider_id) provider_id -- Alterado para agrupar os providers de TV
    from   emf_config_id_values ecv,
     DESCRIPTIONS DES,
     DESCRIPTIONS DES2,
       service,
       customer_id_equip_map eiem,
       bill_invoice bi,
       bill_invoice_detail bid
    where  bi.account_no = v_cliente -- CONTA
          AND    bi.bill_ref_no = v_bill_ref_no -- FATURA
          AND    bi.prep_status = 1
    AND    bi.backout_status = '0'
    AND    bi.format_error_code IS NULL
    AND    bi.prep_error_code IS NULL
    and  bi.BILL_REF_NO = bid.BILL_REF_NO
    and  bi.BILL_REF_RESETS = bid.BILL_REF_RESETS
    AND    bid.type_code IN (2,3,7)
    AND   (BID.amount <> 0 OR BID.discount <> 0)
    AND  DES.DESCRIPTION_CODE(+) = BID.SUBTYPE_CODE
    AND (DES.language_code = 2 OR DES.language_code IS NULL)
    AND  DES2.DESCRIPTION_CODE(+) = BID.discount_id
    AND (DES2.language_code = 2 OR DES2.language_code IS NULL)
    AND    eiem.subscr_no(+) = bid.subscr_no
    AND    service.subscr_no(+) = bid.subscr_no
          AND    service.subscr_no_resets(+) = bid.subscr_no_resets
      AND (ecv.language_code = 2 OR ecv.language_code IS NULL)
      and  service.EMF_CONFIG_ID = ecv.EMF_CONFIG_ID(+)
          AND   (nvl(eiem.external_id_type,0) in (6, 7, 9, 0, 10) ) -- Alterado para Registros de TV
          AND  ((TO_CHAR(eiem.INACTIVE_DATE,'YYYYMMDD') >= TO_CHAR(bi.FROM_DATE,'YYYYMMDD') )
                OR eiem.INACTIVE_DATE is NULL)
    GROUP BY bi.account_no, bi.bill_Ref_no, ecv.DISPLAY_VALUE, eiem.external_id, DES.DESCRIPTION_TEXT, BID.FROM_DATE, 
         BID.TO_DATE, bid.OPEN_ITEM_ID, bid.SUBTYPE_CODE,bid.discount_id,des2.DESCRIPTION_TEXT,bid.type_code,DECODE(bid.provider_id,251,25,bid.provider_id);  -- Alterado para agrupar os providers de TV

------------------------------------------------------------------------------------------------      
/***
**** Cursor para detalhamento de descontos (caso exista mais de um desconto que incide para o mesmo produto)
***/
CURSOR descontos IS
    select  bi.account_no, 
      bi.BILL_REF_NO,
      DES.DESCRIPTION_TEXT nome_desconto,
      bid.DISCOUNT_ID,
      sum(bid.DISCOUNT_AMOUNT) AMOUNT_DISCOUNT
    from    DESCRIPTIONS DES,
      bill_invoice bi,
      bill_invoice_discount bid
    where   bi.account_no = v_cliente
          AND     bi.bill_ref_no = v_bill_ref_no
    AND     bi.prep_status = 1
    AND     bi.backout_status = '0'
    AND     bi.format_error_code IS NULL
    AND     bi.prep_error_code IS NULL
    and   bi.BILL_REF_NO = bid.BILL_REF_NO
    and   bi.BILL_REF_RESETS = bid.BILL_REF_RESETS
    AND   DES.DESCRIPTION_CODE = BID.DISCOUNT_ID
    AND  (DES.language_code = 2 OR DES.language_code IS NULL)
    group by bi.account_no, 
         bi.BILL_REF_NO,
           DES.DESCRIPTION_TEXT,
         bid.DISCOUNT_ID;
           
/*********************************************************************************************/
   -- Declarando Fun��o
   FUNCTION GET_SWAP(p_type_id_usg CDR_BILLED.TYPE_ID_USG%TYPE) return VARCHAR 
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
  
         
/*********************************************************************************************/
-- Defini��o de procedures
/*********************************************************************************************/

PROCEDURE LOCALIZACAO_ANTERIOR IS
BEGIN
  iLocal := substr(iLocal,1,instr(iLocal,';',-1)-1);
END LOCALIZACAO_ANTERIOR;


/* Define tratamento de erro para package UTL_FILE */
--
PROCEDURE ErroUtlFile (pRotina varchar2,pMsgErro varchar2) is
BEGIN
    dbms_output.put_line('*** E R R O *** utl_file.'||pRotina||': '||pMsgErro);
    dbms_output.put_line('  Arquivo='||v_diretorio_arquivo||'/'||v_nome_arquivo);
    dbms_output.put_line(SQLERRM);
    utl_file.fflush(v_arq_ponto_conta);
    utl_file.fclose(v_arq_ponto_conta);
END ErroUtlFile; 

--����������������������������������������������������������������������������������
-- Arquivo de Erros  -- RFC 164552
PROCEDURE GRAVA_ARQ_LOG (p_tipo varchar2,  p_texto  varchar2) is
  texto_log  varchar2(400);
  Out        varchar2(2000);
begin
  
  --/*
  IF p_tipo = 'FILE'  OR  p_tipo is null THEN
	  if not UTL_FILE.IS_OPEN(yFileERRO) then
	    
	    begin
	      yFileERRO := UTL_FILE.fopen(yDiretorio, yArquivo, 'W');
	    exception
	      WHEN utl_file.INVALID_PATH THEN
	        dbms_output.put_line(chr(10)||'DIRET�RIO FORNECIDO - INVALIDO');
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
	        'plCONTA_DETALHADA_P_C - RETAIL - RELAT�RIO DE LOG - Gerado em:'||to_char(Time,'dd/mm/yyyy hh24:mi:ss')||CHR(10)||chr(10)||
	        'ACCOUNT_NO  BILL_REF_NO  CONTA COBRAN  LOG'||chr(10)||
	        '----------  -----------  ------------  ------------------------------------------------'
	                      );
	  end if;
	  --
	  if instr(p_texto, chr(13)) > 0 then
	    texto_log := substr(p_texto, 1, instr(p_texto, chr(13)) );
	  else 
	    texto_log := p_texto;
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
	END IF;
  --*/
	
	IF p_tipo = 'TELA'  OR  p_tipo is null THEN
		DBMS_OUTPUT.PUT_LINE(p_texto);
	END IF;
	
	
Exception when others then
  dbms_output.put_line(chr(10)||'PU Gera_Erro::'||sqlerrm);
  dbms_output.put_line('-20120, ao Abrir/Gravar: "'||yDiretorio||'/'||yArquivo||chr(10)||sqlerrm);
  Raise erroatuparcel;
end GRAVA_ARQ_LOG;
--����������������������������������������������������������������������������������

/*********************************************************************************************/
/***
**** procedimento para traduzir a dura��o de chamadas para o formato HHHHH:MM:SS
***/
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
/***
**** procedimento para gravar o resumo das chamadas por inst�ncia e tipo de uso
***/
   PROCEDURE grava_tab_temp IS
   BEGIN
      iLocal := iLocal||';grava_tab_temp';
      
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
     
     LOCALIZACAO_ANTERIOR;
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line
                ('Erro no INSERT da tabela gvt_pl_conta_detalhada !' );
       RAISE erroatuparcel;

   END grava_tab_temp;

------------------------------------------------------------------------------------------------
/***
**** procedimento que busca o resumo das chamadas por inst�ncia e tipo de uso
***/
   PROCEDURE busca_minuto_faturado IS
   BEGIN
      iLocal := iLocal||';busca_minuto_faturado';
      
      --ARBORGVT_BILLING.gvt_pl_conta_detalhada
      SELECT sum (soma_min_real),  sum (soma_min_fat)
      INTO   t_soma_min_real, t_soma_min_fat 
      FROM   ARBORGVT_BILLING.GVT_PL_CONTA_DETALHADA 
      WHERE  account_no  = t_account_no
      AND    type_id_usg = t_type_id_usg
      AND    external_id = t_external_id
      GROUP BY external_id , account_no , type_id_usg;
     
     LOCALIZACAO_ANTERIOR;
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
/***
**** procedimento que gera o detalhamento de chamadas no arquivo .conta
***/
   PROCEDURE gera_relatorio_cdr IS
      v_type_id_usg_aux               gvt_duration_usg_variable.type_id_usg%TYPE;
      v_ext_id_aux                    char(48);
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
      iLocal := ilocal||';gera_relatorio_cdr~~ 01';
      
      v_type_id_usg_aux := 0;
      v_ext_id_aux := 0;
      
      FOR y IN chamadas LOOP
       BEGIN
       iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 02';
       IF y.provider_id = v_provider_id THEN
         -- Zera Variavel de Controle se chamada varia por Madri
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 03';
       --IF (y.type_id_usg <> v_type_id_usg_aux) OR ( y.external_id <> TRIM(v_ext_id_aux) AND TRIM(v_ext_id_aux) <> 0 ) THEN
         IF (y.type_id_usg <> v_type_id_usg_aux) OR ( y.external_id <> TRIM(v_ext_id_aux) AND TRIM(v_ext_id_aux) <> '0' ) THEN -- RFC 329629
          /* Quando foi sumarizado todos os valores de uma mesma inst�ncia e tipo de uso
             grava na tabela tempor�ria */
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
            
            iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 04';
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
            
            iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 05';
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
               
               iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 06';
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
         
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 07';
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
               
               iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 08';
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
            
            iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 09';
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
            
            iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 10';
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
                  
                  iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 11';
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
         
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 12';
         -- Transforma a duracao real (z.SECOND_UNITS) em campo data(hora,minutos,segundos)
         v_segundos_param  := y.second_units;
         t_soma_min_real   := t_soma_min_real + v_segundos_param;
         
         v_flag_resumo := 'S';
         translate_time (v_segundos_param, v_second_units);
         v_flag_resumo := 'N';
         -- Transforma a duracao tarifada (v_UNITS) em campo data(hora,minutos,segundos)
         v_segundos_param  := v_units;
         
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 13';
         t_soma_min_fat    := t_soma_min_fat + v_segundos_param;
         translate_time (v_segundos_param, v_units_final);
         v_type_id_usg_aux := y.type_id_usg;
         v_ext_id_aux      := TRIM(y.external_id);
         t_external_orig   := TRIM(y.external_id);
         
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 14';
         t_type_id_orig    := y.type_id_usg;
         t_type_id_usg     := v_type_id_usg_aux;
         t_external_id     := TRIM(y.external_id);
         t_account_no      := y.account_no;
         v_account_no      := y.account_no;            
                    
         -- Retorna o flag swap para decidir se inverter point_origin e point_target para chamadas 
         -- 0800, chamadas cobrar, etc.
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 15';
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
         
          iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 16';
         
					IF v_flag_cdr = 'S' THEN
						UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
						UTL_FILE.put_line (v_arq_ponto_conta, 'Chamadas'|| CHR (09) ||'Chamadas'|| CHR (09) ||'sim');
						
						UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
						
						UTL_FILE.put_line
                (v_arq_ponto_conta,
									   'Origem:OrigCham:string:24,0:text'
									|| CHR(09)
									|| 'Data e Hora:DataHoraCham:datetime:0,0:datetime'
									|| CHR(09)
									|| 'Dura��o:DuracCham:time:0,0:time'
									|| CHR(09)
									|| 'Destino:DestCham:string:24,0:text'
									|| CHR(09)
									|| 'Cidade Destino:CidadeDest:string:35,0:text'
									|| CHR(09)
									|| 'Estado Destino:EstadoDest:string:2,0:text'
									|| CHR(09)
									|| 'Tipo Liga��o:TipoLigCham:string:100,0:text'
									|| CHR(09)
									|| 'Tipo:TipoCham:string:80,0:text'
									|| CHR(09)
									|| 'Hor�rio:HorarioCham:string:40,0:text'
									|| CHR(09)
									|| 'Valor a Pagar em Reais:ValLiqCham:decimal:18,2:float2'
									|| CHR(09)
									|| 'Vencimento:VencimentoCham:date:0,0:date'
           );
           v_flag_cdr := 'N';
         END IF;
         
         iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 17';
         UTL_FILE.put_line (v_arq_ponto_conta, 
                               y.point_origin
                            || CHR(09)
                            || to_char(y.trans_dt,'yyyymmddhh24miss')
                            || CHR(09)
                            || v_units_final
                            || CHR(09)
                            || y.point_target
                            || CHR(09)
                            || y.cid
                            || CHR(09)
                            || y.uf
                            || CHR(09)
                            || y.tipo_lig
                            || CHR(09)
                            || y.description_text
                            || CHR(09)
                            || y.rate_period
                            || CHR(09)
                            || y.vlr_cham
                            || CHR(09)
                            || to_char(y.venc_fat,'yyyymmdd')
                           );

       END IF; -- END IF y.provider_id = v_provider_id
       EXCEPTION WHEN OTHERS THEN
		      DBMS_OUTPUT.PUT_LINE('Erro no loop gera_relatorio_cdr.');
		      DBMS_OUTPUT.PUT_LINE('..Local......: '||iLocal);
		      DBMS_OUTPUT.PUT_LINE('..Oracle.....: '||SQLERRM(SQLCODE));
         RAISE erroatuparcel;
       END;
      END LOOP;
      
      iLocal := substr(iLocal,1,instr(iLocal,'~~')-1)||'~~ 18';
      -- Faz insert para a �ltima volta do Loop
      IF v_type_id_usg_aux <> 0 THEN
         grava_tab_temp;
      END IF;
      
     LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_cdr.');
      DBMS_OUTPUT.PUT_LINE('..Local......: '||iLocal);
      DBMS_OUTPUT.PUT_LINE('..Oracle.....: '||SQLERRM(SQLCODE));
            
      RAISE erroatuparcel;
   END gera_relatorio_cdr;

------------------------------------------------------------------------------------------------
/***
**** procedimento para gravar o detalhamento de mensalidades
***/
   PROCEDURE gera_relatorio_mensalidade IS
   BEGIN
      iLocal := iLocal||';gera_relatorio_mensalidade';

      FOR y IN mensalidades LOOP
       IF ( y.provider_id = v_provider_id AND ( y.type_code = 2)) THEN
         IF v_flag_mensalidade = 'S' THEN

            UTL_FILE.put_line (v_arq_ponto_conta, chr(09)); -- RFC 156351
            UTL_FILE.put_line (v_arq_ponto_conta, 'Servi�os Mensais'|| CHR (09) ||'ServMens'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta, chr(09));

            UTL_FILE.put_line
               (v_arq_ponto_conta,
                   'Tipo:TipoServMens:string:80,0:text'
                || CHR(09)
                || 'Identificador:IDServMens:string:48,0:text'
                || CHR(09)
                || 'Descri��o:DescServMens:string:80,0:text'
                || CHR(09)
                || 'Data de in�cio:DataIniSerMens:date:0,0:date'
                || CHR(09)
                || 'Data de fim:DataFimSerMens:date:0,0:date'
                || CHR(09)
                || 'Valor:ValorServMens:decimal:18,2:float2'
               );
            v_flag_mensalidade := 'N';
         END IF;
         UTL_FILE.put_line (v_arq_ponto_conta,
                               y.tipo_inst
                            || CHR (09)
                            || y.inst
                            || CHR (09)
                            || y.nome_produto
                            || CHR (09)
                            || to_char(y.dt_ini,'yyyymmdd')
                            || CHR (09)
                            || to_char(y.dt_fim,'yyyymmdd')
                            || CHR (09)
                            || y.amount
                           );
       END IF;
      END LOOP;
      
      LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_mensalidade : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_mensalidade;

------------------------------------------------------------------------------------------------
/***
**** procedimento para gravar o detalhamento de servi�os eventuais
***/
   PROCEDURE gera_relatorio_nrc IS
   BEGIN
      iLocal := iLocal||';gera_relatorio_nrc';
      
      FOR y IN mensalidades LOOP
       IF ( y.provider_id = v_provider_id AND ( y.type_code = 3) and (y.open_item_id <> 2 and y.open_item_id <> 3 )) THEN
         IF v_flag_nrc = 'S' THEN

            
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
            UTL_FILE.put_line (v_arq_ponto_conta, 'Servi�os Eventuais'|| CHR (09) ||'ServEvent'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));

            UTL_FILE.put_line
               (v_arq_ponto_conta,
                   'Tipo:TipoServEve:string:80,0:text'
                || CHR(09)
                || 'Identificador:IDServEve:string:48,0:text'
                || CHR(09)
                || 'Descri��o:DescServEve:string:80,0:text'
                || CHR(09)
                || 'Valor:ValorServEve:decimal:18,2:float2'
                || CHR(09)
                || 'Data e Hora:DataHoraCompra:datetime:0,0:datetime'
               );
            v_flag_nrc := 'N';
         END IF;
         UTL_FILE.put_line (v_arq_ponto_conta,
                               y.tipo_inst
                            || CHR (09)
                            || y.inst
                            || CHR (09)
                            || y.nome_produto
                            || CHR (09)
                            || y.amount
                            || CHR (09)
                            || CHR (32)
                           );
       END IF;
      END LOOP;
      
      -- Incluido para Gerar dados de Usos de TV na parte de Servi�os Eventuais
      FOR y IN usos_tv LOOP
       IF ( y.provider_id = v_provider_id) THEN
         IF v_flag_nrc = 'S' THEN
            
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
            UTL_FILE.put_line (v_arq_ponto_conta, 'Servi�os Eventuais'|| CHR (09) ||'ServEvent'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));

            UTL_FILE.put_line
               (v_arq_ponto_conta,
                   'Tipo:TipoServEve:string:80,0:text'
                || CHR(09)
                || 'Identificador:IDServEve:string:48,0:text'
                || CHR(09)
                || 'Descri��o:DescServEve:string:80,0:text'
                || CHR(09)
                || 'Valor:ValorServEve:decimal:18,2:float2'
				|| CHR(09)
				|| 'Data e Hora:DataHoraCompra:datetime:0,0:datetime'
			);
            v_flag_nrc := 'N';
         END IF;
         UTL_FILE.put_line (v_arq_ponto_conta,
                               y.tipo_inst
                            || CHR (09)
                            || y.inst
                            || CHR (09)
                            || y.nome_produto
                            || CHR (09)
                            || y.amount
                            || CHR(09)
                            || to_char(y.trans_dt,'yyyymmddhh24miss')
                           );
      END IF;
      END LOOP;
      
      LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_nrc : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_nrc;

------------------------------------------------------------------------------------------------
/***
**** procedimento para gravar o detalhamento de Encargos
***/
   PROCEDURE gera_relatorio_encargo IS
   BEGIN
      iLocal := iLocal||';gera_relatorio_encargo';

      FOR y IN mensalidades LOOP
       IF ( y.provider_id = v_provider_id AND ( y.type_code = 3) and (y.open_item_id = 2 or y.open_item_id = 3 )) THEN
         IF v_flag_encargo = 'S' THEN

            
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
      UTL_FILE.put_line (v_arq_ponto_conta, 'Encargos'|| CHR (09) ||'Encargos'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));

            UTL_FILE.put_line
               (v_arq_ponto_conta,
                   'Descri��o:DescrEncargo:string:80,0:text'
                || CHR(09)
                || 'Data:DataEncargo:date:0,0:date'
                || CHR(09)
    || 'Valor:ValorEncargo:decimal:18,2:float2'
               );
            v_flag_encargo := 'N';
         END IF;
         UTL_FILE.put_line (v_arq_ponto_conta,
                               y.nome_produto
                            || CHR (09)
                            || to_char(y.dt_fim,'yyyymmdd')
                            || CHR (09)
                            || y.amount
                           );
       END IF;
      END LOOP;
      
      LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_encargo : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_encargo;

------------------------------------------------------------------------------------------------
/***
**** procedimento para gravar o detalhamento de descontos
***/
--RFC 390828 - Evelize
PROCEDURE gera_relatorio_desconto IS
   BEGIN
      iLocal := iLocal||';gera_relatorio_desconto';

      for d in descontos loop
      	IF ( d.discount_id is not null) THEN
        	IF v_flag_desconto = 'S' THEN

            
      		UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
      		UTL_FILE.put_line (v_arq_ponto_conta, 'Descontos'|| CHR (09) ||'Descontos'|| CHR (09) ||'nao');
      		UTL_FILE.put_line (v_arq_ponto_conta,chr(09));

      		UTL_FILE.put_line
          		     (v_arq_ponto_conta,
           		      'Descri��o:DescrDesconto:string:80,0:text'
          		      || CHR(09)
            		    || 'Valor:ValorDesconto:decimal:18,2:float2'
               		);
          v_flag_desconto := 'N';
       		END IF;
         
          
      		UTL_FILE.put_line (v_arq_ponto_conta,
          		           d.nome_desconto
              		    || CHR (09)
                  		|| d.amount_discount
                   		);
          
      	END IF;
      END LOOP;
      
   LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_desconto : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_desconto;   
   
/*
----OLD---------------------------------------------------------------------------------------------   
   PROCEDURE gera_relatorio_desconto IS
   BEGIN
      iLocal := iLocal||';gera_relatorio_desconto';

      FOR y IN mensalidades LOOP
       IF ( y.provider_id = v_provider_id AND ( y.discount_id is not null)) THEN
         IF v_flag_desconto = 'S' THEN

            
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));
      UTL_FILE.put_line (v_arq_ponto_conta, 'Descontos'|| CHR (09) ||'Descontos'|| CHR (09) ||'nao');
            UTL_FILE.put_line (v_arq_ponto_conta,chr(09));

            UTL_FILE.put_line
               (v_arq_ponto_conta,
                 'Descri��o:DescrDesconto:string:80,0:text'
                || CHR(09)
                || 'Valor:ValorDesconto:decimal:18,2:float2'
               );
            v_flag_desconto := 'N';
         END IF;
         
         UTL_FILE.put_line (v_arq_ponto_conta,
                 y.nome_desconto
                            || CHR (09)
                            || y.amount_discount
                           );
         if y.discount_id = -2 then
          for d in descontos loop
            UTL_FILE.put_line (v_arq_ponto_conta,
                     d.nome_desconto
                  || CHR (09)
                  || d.amount_discount
                   );
          end loop;
         end if;
                           
       END IF;
      END LOOP;
      
      LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em gera_relatorio_desconto : ' || ' ' || SQLERRM(SQLCODE));
      RAISE erroatuparcel;
   END gera_relatorio_desconto;
----OLD---------------------------------------------------------------------------------------------*/      

-----------------------------------------------------------------------------------------------
/***
**** procedimento para gravar o cabe�alho do arquivo .conta
***/

   PROCEDURE imprime_inicio IS
      nota_fiscal    VARCHAR2(40);
      data_inicio    DATE;
      data_fim       DATE;
      nome_cliente   VARCHAR2(168);
      vencim_fat     DATE;
      emissao_fat    DATE;
      uf             VARCHAR2(84);
      nro_fatura     NUMBER(10);
   BEGIN
      iLocal := iLocal||';imprime_inicio';

      SELECT TRIM(s.full_sin_seq), 
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
             uf, nro_fatura
        FROM bill_invoice b, 
             sin_seq_no s, 
             cmf c
       WHERE b.account_no = v_cliente
         AND b.bill_ref_no = v_bill_ref_no
         AND b.bill_ref_no = s.bill_ref_no
         and s.open_item_id <= 3
         AND c.account_no = b.account_no
         and b.prep_status = 1;

      -- tratar exeption
	    begin
	      UTL_FILE.put_line (v_arq_ponto_conta, nota_fiscal);
	      UTL_FILE.put_line (v_arq_ponto_conta, to_char(data_inicio,'yyyymmdd'));
	      UTL_FILE.put_line (v_arq_ponto_conta, to_char(data_fim,'yyyymmdd'));
	      UTL_FILE.put_line (v_arq_ponto_conta, nome_cliente);
	      UTL_FILE.put_line (v_arq_ponto_conta, to_char(vencim_fat,'yyyymmdd'));
	      UTL_FILE.put_line (v_arq_ponto_conta, to_char(emissao_fat,'yyyymmdd'));
	      UTL_FILE.put_line (v_arq_ponto_conta, uf);
	      UTL_FILE.put_line (v_arq_ponto_conta, nro_fatura);
	    exception when others then
	      DBMS_OUTPUT.PUT_LINE('Erro em "imprime_inicio" ao gravar arquivo : ' || SQLERRM(SQLCODE));
	      DBMS_OUTPUT.PUT_LINE('CLIENTE: ' || v_cliente || ' FATURA:' || v_bill_ref_no);
	      RAISE erroatuparcel;
	    end;
    
     LOCALIZACAO_ANTERIOR;
   EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro em imprime_inicio : ' || SQLERRM(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('CLIENTE: ' || v_cliente || ' FATURA:' || v_bill_ref_no);
      RAISE erroatuparcel;
   END imprime_inicio;


------------------------------------------------------------------------------------------------
/***
**** procedimento para buscar a descri��o da operadora
***/
   --PROCEDURE csp_descricao (v_provider_id in varchar2, v_descr OUT varchar2) IS
   PROCEDURE csp_descricao (v_provider_id in number, v_descr OUT varchar2) IS
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
/***
**** procedimento para buscar a descri��o da operadora
***/
   PROCEDURE consulta_fatura IS
   BEGIN
      iLocal := iLocal||';consulta_fatura';
      
      v_existe_fatura := 0;
      v_bill_ref_no   := null;

      SELECT MAX (bill_ref_no),
             TO_CHAR(Max(payment_due_date),'YYYYMM')
      INTO   v_bill_ref_no,
             v_mes
      FROM   bill_invoice a
      WHERE  account_no = v_cliente 
        AND  prep_status = 1
        AND  prep_error_code is null
        AND  backout_status = '0'
        AND  format_error_code IS NULL
        AND  prep_date >= v_prep_date;

      -- confirma existencia da fatura            
      IF v_bill_ref_no IS NOT NULL THEN
         v_existe_fatura := 1;
         -- v_bill_ref_no := 86719368;
         -- dbms_output.put_line('Numero da fatura......................' || v_bill_ref_no);
      else
         GRAVA_ARQ_LOG('FILE', 'Nao existe Fatura.');
         yqtde_sem_fatura := nvl(yqtde_sem_fatura,0) + 1;
      END IF;
      
     LOCALIZACAO_ANTERIOR;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         v_existe_fatura := 0;
         GRAVA_ARQ_LOG('FILE', 'Nao existe Fatura.');
         yqtde_sem_fatura := nvl(yqtde_sem_fatura,0) + 1;
         RAISE erroatuparcel;
      WHEN OTHERS THEN
         v_existe_fatura := 0;
         GRAVA_ARQ_LOG('FILE', 'Erro consulta_fatura; ORA:'||sqlerrm);
         --DBMS_OUTPUT.put_line('ORA - Erro consulta_fatura (ACCOUNT_NO) = '|| v_cliente );
         RAISE erroatuparcel;
   END consulta_fatura;

------------------------------------------------------------------------------------------------
PROCEDURE grava_tabela_conta_internet (p_account_no in number,p_external_id in varchar2, p_bill_ref_no in number, p_data_processamento in date, p_nome_arq in varchar2,p_existe_fatura char) is
BEGIN
   iLocal := iLocal||';grava_tabela_conta_internet';
   
   if ( p_nome_arq is null  or  p_nome_arq = '' ) then   --- se o nome do arquivo esta vazio, teve erro na gera��o do arquivo
      INSERT INTO gvt_conta_internet (ACCOUNT_NO, EXTERNAL_ID, BILL_REF_NO, DATA_PROCESSAMENTO, NOME_ARQUIVO, EXISTE_FATURA)
        VALUES (p_account_no, p_external_id, null, p_data_processamento, null, null);
      COMMIT;
   else
      INSERT INTO gvt_conta_internet (ACCOUNT_NO, EXTERNAL_ID, BILL_REF_NO, DATA_PROCESSAMENTO, NOME_ARQUIVO, EXISTE_FATURA)
        VALUES (p_account_no, p_external_id, p_bill_ref_no, p_data_processamento, p_nome_arq, p_existe_fatura);
      COMMIT;
   end if;
   
   LOCALIZACAO_ANTERIOR;
 EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERRO : GRAVA��O DE PAR�METROS NA TABELA GVT_CONTA_INTERNET');
      dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
      RAISE erroatuparcel;      
       
END grava_tabela_conta_internet;    

------------------------------------------------------------------------------------------------
/***
**** In�cio do programa
***/
BEGIN
  iLocal := 'Inicio da PL';
  
  Time := sysdate;
  data_base := DBMS_REPUTIL.GLOBAL_NAME();
  GRAVA_ARQ_LOG('', rpad('=',50,'=') );
  GRAVA_ARQ_LOG('', 'PROGRAMA - PL_CONTA_DETALHADA_P_R.sql  --  Retail' );
  GRAVA_ARQ_LOG('', 'Base....: '|| data_base );
  GRAVA_ARQ_LOG('', 'Inicio..: '|| to_char(Time,'dd/mm/yyyy hh24:mi:ss') );
  GRAVA_ARQ_LOG('', rpad('-',50,'-') );
  GRAVA_ARQ_LOG('', '..diretorio_arquivo.....: '||v_diretorio_arquivo);
  GRAVA_ARQ_LOG('', '..prep_date ini.........: '||v_prep_date);
  GRAVA_ARQ_LOG('', '..prep_date fim.........: '||v_prep_date_fim);
  GRAVA_ARQ_LOG('', '..tipo_processamento....: '||v_tipo_processamento);
  GRAVA_ARQ_LOG('', '..Account_category .....: '||i_Account_category);
  GRAVA_ARQ_LOG('', '..Processo .............: '||i_Processo);
  GRAVA_ARQ_LOG('', rpad('-',50,'-') );

  FOR regc0 IN consulta_cliente  LOOP
  BEGIN
    v_cliente := regc0.account_no; 
    v_existe_fatura := 0;
    v_bill_ref_no   := NULL;
    yqtde_bip       := nvl(yqtde_bip,0) + 1;
    v_nome_arquivo  := NULL;

    consulta_fatura;
    
	IF v_existe_fatura = 1 THEN
		-- RFC 126356 - Valter Rog�rio Ciolari (04/12/2009)
		begin
		  Select 1 into dummy from sin_seq_no where bill_ref_no = v_bill_ref_no;
		exception
		  when no_data_found then
			GRAVA_ARQ_LOG('FILE', 'Fatura n�o possui Nota Fiscal.');
			yqtde_sem_nota := nvl(yqtde_sem_nota,0) + 1;
			v_existe_fatura := 0;
		  when others then
			null;
		end;
		
		SELECT external_id
		INTO   v_external_id
		FROM   customer_id_acct_map
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
        -- Dever� criar o arquivo somente se houver Detalhes da Fatura.
        IF FIRST_TIME THEN
          FIRST_TIME := FALSE;
          -- Alterado para incluir arquivo na pasta Mes + ultimo digito do numero da conta + nome do arquivo
          -- Ex : Outubro/5/2006Maio999999999999_250.cdc
          v_nome_arquivo := trim(v_mes_b) || '/' || substr(trim(v_external_id),12,1) || '/' || SUBSTR(v_mes, 1, 4)|| TRIM(v_mes_b)||trim(v_external_id) ||'_250.cdc';
          -- antigo
          --v_nome_arquivo := SUBSTR(v_mes, 1, 4)|| TRIM(v_mes_b)||trim(v_external_id) ||'_250.cdc';

          if UTL_FILE.is_open(v_arq_ponto_conta) then
          UTL_FILE.fclose(v_arq_ponto_conta);
          end if;

          v_arq_ponto_conta := UTL_FILE.fopen (v_diretorio_arquivo, v_nome_arquivo , 'w',5000);
          
          yqtde_gerada := nvl(yqtde_gerada,0) + 1;

          imprime_inicio;


          UTL_FILE.put_line (v_arq_ponto_conta,'');
          
        END IF;
        
        
        v_flag_mensalidade := 'S';
        v_flag_nrc := 'S';
        v_flag_desconto := 'S';
        v_flag_encargo := 'S';
        v_flag_cdr := 'S';

        v_provider_id := x.provider_id;
        v_open_item_id := x.open_item_id;
        csp_descricao (x.provider_id, nome_operadora);

        -- RFC 156351
        --IF v_provider_id <> 25 then
        --   UTL_FILE.put_line (v_arq_ponto_conta,'');
        --END IF;

        UTL_FILE.put_line (v_arq_ponto_conta, nome_operadora);

        gera_relatorio_mensalidade;
        gera_relatorio_nrc;
        gera_relatorio_desconto;
        gera_relatorio_cdr;
        gera_relatorio_encargo;

        -- RFC 156351
        --UTL_FILE.put_line (v_arq_ponto_conta, '');
        --UTL_FILE.put_line (v_arq_ponto_conta, '');
        UTL_FILE.put_line (v_arq_ponto_conta, chr(09));
        UTL_FILE.put_line (v_arq_ponto_conta, chr(09));

      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro no FOR x IN operadora_csp : ' || ' ' || SQLERRM(SQLCODE));
        RAISE erroatuparcel;
      END;
      END LOOP; -- END ... FOR x IN operadora_csp

      UTL_FILE.fclose (v_arq_ponto_conta);

      v_numero_conta  := trim(v_external_id);
      v_numero_fatura := v_bill_ref_no;

      BEGIN
        SP_MARCA_GERACAO_CONTA_FACIL ( v_numero_conta, v_numero_fatura );
		
      END;

      grava_tabela_conta_internet(v_cliente, v_numero_conta, v_numero_fatura, sysdate, v_nome_arquivo, 1);

      if not eOPERADORA then
        GRAVA_ARQ_LOG('FILE', 'N�o existem Usos.');
        yqtde_sem_usos := nvl(yqtde_sem_usos,0) + 1;
      end if;
      
    ELSE      
      grava_tabela_conta_internet(v_cliente, trim(v_external_id), NULL, SYSDATE, NULL, 0);
      yqtde_erro := nvl(yqtde_erro,0) + 1;
    END IF; -- END ... IF v_existe_fatura = 1
      EXCEPTION 
        WHEN UTL_FILE.INVALID_PATH THEN
            ErroUtlFile (iLocal,'ERRO :invalid_path');
            dbms_output.put_line('ERRO :Verif a exist do param. UTL_FILE_DIR no init');
            RAISE erroatuparcel;
        WHEN UTL_FILE.INVALID_OPERATION THEN
            ErroUtlFile (iLocal,'ERRO :invalid_operation');
            RAISE erroatuparcel;
        WHEN UTL_FILE.WRITE_ERROR THEN
            ErroUtlFile (iLocal,'ERRO :write_error'); 
            RAISE erroatuparcel;
        WHEN erroatuparcel THEN
             dbms_output.put_line(iLocal);
             dbms_output.put_line('atencao --- Erro geral ');
             dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
             ROLLBACK;
         WHEN OTHERS THEN
            UTL_FILE.fclose (v_arq_ponto_conta);
            DBMS_OUTPUT.PUT_LINE('Erro no Loop principal : ' || ' ' || SQLERRM(SQLCODE));
            RAISE erroatuparcel;
      END; -- BEGIN
    <<PROXIMA_CONTA>>
    null;
   END LOOP; -- END ... LOOP principal
  
  
  v_cliente := null;
  v_bill_ref_no := null;
  v_external_id := null;
  GRAVA_ARQ_LOG('', 'Final ...........: '|| to_char(SYSDATE,'dd/mm/yyyy hh24:mi:ss'));
  GRAVA_ARQ_LOG('', 'Tempo ...........: '|| to_char(trunc(sysdate) + (sysdate-Time),'hh24:mi:ss') );
  GRAVA_ARQ_LOG('', '-------------------------------------');
  GRAVA_ARQ_LOG('', '.'||lpad(yqtde_bip   ,8,' ')||' contas estavam no BIP.');
  GRAVA_ARQ_LOG('', '.'||lpad(yqtde_gerada,8,' ')||' contas tiveram arquivos gerados.');
	if yqtde_erro + yqtde_sem_fatura + yqtde_sem_nota + yqtde_sem_usos > 0 then
  GRAVA_ARQ_LOG('', '.'||lpad(yqtde_erro  ,8,' ')||' contas tiveram erros.');
  GRAVA_ARQ_LOG('', '.'||lpad(yqtde_sem_fatura ,8,' ')||' contas n�o tinham fatura.');
  GRAVA_ARQ_LOG('', '.'||lpad(yqtde_sem_nota   ,8,' ')||' contas n�o tinham nota fiscal.');
  GRAVA_ARQ_LOG('', '.'||lpad(yqtde_sem_usos   ,8,' ')||' contas n�o tinham CDRs.');
  end if;
  utl_file.fclose(yFileERRO);
   
EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
      ErroUtlFile (iLocal,'ERRO :invalid_path');
      dbms_output.put_line('ERRO :Verif a exist do param. UTL_FILE_DIR no init');
            RAISE erroatuparcel;
  WHEN UTL_FILE.INVALID_OPERATION THEN
      ErroUtlFile (iLocal,'ERRO :invalid_operation');
            RAISE erroatuparcel;
  WHEN UTL_FILE.WRITE_ERROR THEN
      ErroUtlFile (iLocal,'ERRO :write_error'); 
            RAISE erroatuparcel;
  WHEN erroatuparcel THEN
       dbms_output.put_line('WHEN erroatuparcel...(fim)');
       dbms_output.put_line('Local......: '||iLocal);
       if v_cliente     is not null then dbms_output.put_line('Cliente.....: '||v_cliente);     end if;
       if v_bill_ref_no is not null then dbms_output.put_line('Fatura......: '||v_bill_ref_no); end if;
       dbms_output.put_line('ERRO : '||SQLERRM(SQLCODE));
       ROLLBACK;
  WHEN OTHERS THEN
       dbms_output.put_line('WHEN OTHERS...(fim)');
       dbms_output.put_line('Local......: '||iLocal);
       if v_cliente     is not null then dbms_output.put_line('Cliente....: '||v_cliente);     end if;
       if v_bill_ref_no is not null then dbms_output.put_line('Fatura.....: '||v_bill_ref_no); end if;
       dbms_output.put_line('..Oracle.....: '||SQLERRM(SQLCODE));
       ROLLBACK; 

END;
/
EXIT;

