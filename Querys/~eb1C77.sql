/************************************** PL_GERA_NRC_INTERRUPCAO.sql *******************************************
*                                                                                                            *
*  Desc.............: Le os dados da tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_CARGA e processa        *
*                     as interrupcoes, gerando um NRC e inserindo os dados na tabela de controle             *
*                     ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG.                                          *
*                     Para isso, para cada cliente, recupera-se seus produtos, o valor e os descontos dos    *
*                     mesmos, para entao calcular o valor do ressarcimento em cima da soma dos produtos      *
*                     encontrados.                                                                           *
*                     Apos a geracao de NRCs, trunca a tabela de carga e insere os dados antigos em uma      *
*                     tabela de backup.                                                                      *
*  Autor............: Lucas Aragao                                                                           *
*  Data Criacao.....: 18/06/2012                                                                             *
*                                                                                                            *
**************************************************************************************************************
*  Alterado por.....: Lucas Aragao                                                                           *
*  Data Alteracao...: 26/07/2012                                                                             *
*  Motivo...........: Tratamento de erros ao inserir NRC, inserindo o erro em uma coluna da tabela           *
*                     ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG e acionando a Flag para 2.                *
*                                                                                                            *
**************************************************************************************************************
*  Alterado por.....: Evelize Amaral dos Santos                                                              *
*  Data Alteracao...: 10/04/2013                                                                             *
*  Motivo...........: RFC 426127:                                                                            *
*                     -Tratamento para inserir NRC de TV com OPEN_ITEM_ID 90, pois estava                    *
*                      inserindo incorretamente com OPEN_ITEM_ID 1.                                          *
*                     -Alteracao para gravar no campo ANNOTATION e CHG_WHO da tabela NRC                     *
*                      o nome desse processo para facilitar rastreabilidade.                                 *
*                                                                                                            *
**************************************************************************************************************
*  Alterado por.....: Daniel Taques Valentin / Flavio Brunetta                                               *
*  Data Alteracao...: 04/06/2013                                                                             *
*  Motivo...........: PJ1016 - Projeto Alfaiate                                                              *
*                     -Busca do valor pela chave de tarifacao de TV por safra considerando periodos de       *
*                      de ativacoes e inativacoes dos produtos e tambem os periodos validos da interrupcao.  *
*                     -Correcao de bug que estava considerando todos os produtos inativados antes da data    *
*                      fim da interrupcao.                                                                   *
*                     -Melhorado descricao nos logs gerados indicando conta e/ou produto.                    *
*                     -Criado flag_processado=3 para identificar os erros na busca do pre√ßo dos produtos.   *
*                     -Criado flag_processado=4 para identificar sem produtos a serem ressarcidos.           *
*                     -Criado flag_processado=5 para identificar valor zero a ser ressarcido.                *
*                     -Corrigido bug no calculo do desconto percentual na query de desconto                  *
*                         De  : rd*.discount_percent                                                         *
*                         Para: rd*.discount_percent / POWER(10, rd*.implied_decimals)                       *
*                                                                                                            *
**************************************************************************************************************
*  Alterado por.....: Daniel Taques Valentin / Rafael Freitas / Flavio Brunetta                              *
*  Data Alteracao...: 20/06/2013                                                                             *
*  Motivo...........: PJ1016 - Projeto Alfaiate                                                              *
*                     - Elimina a Frase ORA do log de processamento para casos de n√£o encontrar o valor pela*
*            pela safra                                                                                      *
*             - Ajuste para o caso da billing_active_dt seja NULL                                            *
*                     - Data de corte do Alfaiate alterada para 22/05/2013                                   *
*                                                                                                            *
**************************************************************************************************************
*  Alterado por.....: Jonas Nadolny                                                                          *
*  Data Alteracao...: 14/05/2014                                                                             *
*  Motivo...........: PROB407737 -> Erro no DQ Ressarciemnto de TV                                           *
*                     Na execu√ß√£o do processo ao encontrar um cliente que n√£o possui produto no periodo da*
*            da interrup√ß√£o acaba n√£o retornado nada no cursor de produtos, assim mantendo na             *
*              variavel v_subscr_no e v_subscr_no_resets o valor do ultimo produto do cliente                *
*                      anterior, e mesmo tendo seu resgistro com a flag 4 n√£o realizando nenhuma a√ß√£o de  *
*                      ressarcimento acaba ficando registrado na base o clilente com o subscr_no errado.     *
*                                                                                                            *        
 **************************************************************************************************************
*  Alterado por.....: Jonas Nadolny                                                                          *
*  Data Alteracao...: 12/08/2014                                                                             *
*  Motivo...........: Projeto IPTV - Inclus„o da nova instancia no where da consulta                         *
*                     Devido ao tratamento que existia onde a instancia de TV era external_id_type(10)       *    
*                     precisamos alterar o mesmo para incluir o external_id_type(12) e o tratamento para     *
*                     marcar a NRC inserida com o OPEN_ITEM_ID=1 para o IPTV e 90 para o DTH e Hibrido.      *        
*                                                                                                            *        
 *************************************************************************************************************
*  Alterado por.....: Aurelio Avanzi                                                                         *
*  Data Alteracao...: 02/06/2016                                                                             *
*  Motivo...........:                                                                                        *
*                     Alterado o round(n.valor_ressarc) para n.valor_ressar                                  *        
*                                                                                                            *        
 **************************************************************************************************************/

 
--SET SERVEROUTPUT ON SIZE 1000000;

DECLARE
   v_counter_1           INT := 0;      -- contador de NRCs inseridas com sucesso
   v_counter_2           INT := 0;      -- contador de NRCs nao inseridas por erro na insercao
   v_counter_3           INT := 0;      -- contador de NRCs nao inseridas por erro na busca do preco dos produtos
   v_counter_4           INT := 0;      -- contador de NRCs nao inseridas por falta de produtos a serem ressarcidos
   v_counter_5           INT := 0;      -- contador de NRCs nao inseridas por ter valor zero a ressarcir

   v_qt_produtos         INT;           -- quantidade de produtos a serem ressarcidos

   v_valor               INT;           -- valor total do produto de um cliente por interrupcao
   v_valor_produto       INT;           -- valor de cada produto
   v_desconto            INT;           -- desconto de cada produto
   v_nrc                 INT;           -- valor do ressarcimento de uma interrupcao

   v_data_abertura       DATE;          -- data do inicio de uma interrupcao
   v_data_fechamento     DATE;          -- data do fim de uma interrupcao
   v_account_no          NUMBER(10);    -- conta do cliente por interrupcao
   --v_external_id_type    INT;         -- tipo de instancia de acordo com o tipo de interrupcao (voz,dados,tv)
   v_external_id_type    number(10);    -- tipo de instancia de acordo com o tipo de interrupcao (voz,dados,tv)

   v_subscr_no           NUMBER(10);    -- codigo da instancia do cliente
   v_subscr_no_resets    NUMBER(6);     -- codigo complementar da instancia do cliente
   v_tracking_id         NUMBER(10);    -- tracking id retornado pela funcao de criacao de nrc
   v_tracking_id_serv    NUMBER(3);     -- tracking id serv retornado pela funcao de criacao de nrc

   v_data_dados_antigos  DATE;          -- data limite para que um dado seja considerado antigo

   v_flag_processado     INTEGER;
   v_mensagem_erro       VARCHAR2(255); -- registra a mensagem de erro

   v_data_corte_alfaiate DATE := TO_DATE('22/05/2013','DD/MM/YYYY');  -- Data que foi rodado o backlog antes da subida do Lavoisier.
                                                                      -- Produtos inativados antes dessa data, nao tem a product_rate_key. (nem todos)
              
   v_periodo_interrupcao_temp   NUMBER;    -- (v_data_fechamento - v_data_abertura)
   v_periodo_interrupcao    NUMBER;    -- Usado no calculo do valor do ressarcimento
   v_30_minutos         NUMBER := 0.02083333333333;      -- Usado no calculo do periodo de interrupcao
   v_num_ss           VARCHAR(64);
   v_dt_abertura_base       DATE;
   v_dt_fechamento_base      DATE;
   v_external_id            VARCHAR2(48);
   
   ---------------------------------------------------------------------------------------------------------
   -- Cursor de carga da tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_CARGA
   CURSOR c_carga IS
      SELECT a.external_id,
             a.dt_abertura,
             a.dt_fechamento,
             a.num_ss,
             a.desc_ss,
             a.tipo_produto,
             b.account_no
      FROM   arborgvt_billing.gvt_credito_interrupcao_carga a,
             arbor.customer_id_acct_map                     b
      WHERE  a.external_id      = b.external_id
      AND    b.external_id_type = 1; -- nao deve ser uma SS ja processada na tabela de backup


   ---------------------------------------------------------------------------------------------------------
   -- Cursor de produtos de uma determinada conta
   CURSOR c_produtos IS
      SELECT  p.component_id,
              p.element_id,
              p.parent_subscr_no,
              p.parent_subscr_no_resets,
              sb.equip_class_code,
              p.tracking_id,            --PJ1016 - Alfaiate
              p.tracking_id_serv,       --PJ1016 - Alfaiate
              p.billing_active_dt,
              p.billing_inactive_dt,    --PJ1016 - Alfaiate
              pe.rate_component_id,     --PJ1016 - Alfaiate
              sb.class_of_service_code, --PJ1016 - Alfaiate
              sb.equip_type_code,       --PJ1016 - Alfaiate
        sb.rate_class,
        p.billing_account_no
      FROM    arbor.customer_id_equip_map ciem,
              arbor.product               p,
              arbor.service_billing       sb,
              product_elements            pe,   --PJ1016 - Alfaiate
        descriptions           d
      WHERE ((v_external_id_type != -1 and
              ciem.external_id_type = v_external_id_type) or
             (v_external_id_type  = -1 and
                  ciem.external_id_type in 
                         (select external_id_type
                            from external_id_type_values
                           where language_code = 2
                             and short_display like '%TV%')))
      --WHERE   ciem.external_id_type     in (10,12) -- Alterado para incluir o IPTV.
      AND     ciem.subscr_no            = p.parent_subscr_no
      AND     ciem.subscr_no_resets     = p.parent_subscr_no_resets
      -- Corrigido para considerar os produtos ativos no final do periodo de interrupcao (no caso de ter ocorrido uma change no meio do periodo).
      -- Caso o produto tenha sido desconectado dentro do periodo de interrupcao sera ignorado.
      -- Produto ativado dentro de periodo de interrupcao, sera ressarcido como se estivesse ativo desde antes da interrupcao.
      --AND     ( (TRUNC(v_data_abertura)    BETWEEN p.billing_active_dt AND NVL(p.billing_inactive_dt, SYSDATE) - 1/24/60/60)
    --      OR (TRUNC(v_data_fechamento)    BETWEEN p.billing_active_dt AND NVL(p.billing_inactive_dt, SYSDATE) - 1/24/60/60) )
    AND     v_data_abertura >= p.billing_active_dt--
    AND    (p.billing_inactive_dt is null or v_data_abertura <= p.billing_inactive_dt)--
      AND     p.parent_subscr_no        = sb.subscr_no
      AND     p.parent_subscr_no_resets = sb.subscr_no_resets
      AND     pe.element_id             = p.element_id   --PJ1016 - Alfaiate
      AND     p.parent_account_no       = v_account_no
    AND     ciem.is_current = 1
    AND d.description_code = pe.description_code 
    AND d.language_code = 2
    AND ((ciem.external_id_type = 6 AND
      UPPER(d.description_text) LIKE '%ASSINATURA%') or
      ciem.external_id_type != 6);
   
   ---------------------------------------------------------------------------------------------------------
   -- Cursor dos valores necessarios para insercao de uma NRC
   CURSOR c_anatel IS
    SELECT DT_ABERTURA, 
         DT_FECHAMENTO 
    FROM ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG
    WHERE    external_id = v_external_id
      AND FLAG_PROCESSADO IN(0, 2)
      --AND  ( (TRUNC(v_data_abertura)    BETWEEN DT_ABERTURA AND DT_FECHAMENTO)
      --    OR (TRUNC(v_data_fechamento)    BETWEEN DT_ABERTURA AND DT_FECHAMENTO) )
      --AND  v_data_abertura >= dt_abertura--
      --AND  (dt_fechamento is null or v_data_abertura <= dt_fechamento)--
    ORDER BY DT_ABERTURA;
    
   ---------------------------------------------------------------------------------------------------------
   -- Cursor dos valores necessarios para insercao de uma NRC
   CURSOR c_nrc IS
   
     SELECT a.external_id,
         b.account_no,
         a.tipo_produto,
         a.subscr_no,
         a.subscr_no_resets,
         a.flag_processado,
         DECODE(a.tipo_produto,0,12789,1,12788,2,CASE WHEN s.display_external_id_type = 10 THEN 12787 ELSE 12812 END) nrc,
         DECODE(s.display_external_id_type,
         6,valor.valor_ressarcimento, --VOZ
         7,valor2.soma, --BANDA LARGA
         10,valor2.soma, --TV
         12,valor2.soma) valor_ressarc, --TV
         --SUM(a.valor_ressarc)                                         valor_ressarc,
         --valor.valor_ressarcimento                                        valor_ressarc,
         CASE WHEN s.display_external_id_type = 10 THEN 90 ELSE 1 END open_item_id
    FROM   arborgvt_billing.gvt_credito_interrupcao_log a,
         arbor.customer_id_acct_map                   b,
         service                                      s,  --RFC 426127
         (
          
       SELECT sum(duracao_final) as tempo_interrupcao,
       trunc (sum((valor_produto / 30 / 1440) * duracao_final),0) valor_ressarcimento,
       external_id,
       tipo_produto
  FROM (SELECT external_id,
               tipo_produto,
               CASE
                  WHEN (dt_fechamento - dt_abertura) * 24 * 60 <= 30 THEN 30
                  ELSE
                   CASE
                     WHEN (dt_fechamento - dt_abertura) * 24 * 60 >= 1440 THEN
                      (CEIL((dt_fechamento - dt_abertura) * 24 * 60 / 1440) * 1440)
                     ELSE
                      1440
                   END
                END duracao_final,
               (l.valor_produto) valor_produto
          FROM arborgvt_billing.gvt_credito_interrupcao_log l
        WHERE flag_processado  IN (0,2)
        )
GROUP BY external_id, tipo_produto
         
         )  valor, 
     (select x.external_id,x.tipo_produto,trunc (sum((valor_produto / 30 / 1440) * ((dt_fechamento - dt_abertura) * 24 * 60)),0)  soma 
         from arborgvt_billing.gvt_credito_interrupcao_log x
         group by x.external_id,x.tipo_produto) valor2     
      WHERE  a.external_id      = b.external_id
      AND    valor.external_id = b.external_id
      AND    valor.tipo_produto = a.tipo_produto
      AND    valor2.external_id = b.external_id
      AND    valor2.tipo_produto = a.tipo_produto       
      AND    b.external_id_type = 1
      AND    a.flag_processado  IN (0,2) -- nao processado ainda ou com erro de insercao da NRC. Erro de preco e ignorado (3).
      AND    a.subscr_no        = s.subscr_no
      AND    a.subscr_no_resets = s.subscr_no_resets
      GROUP  BY a.external_id,
         b.account_no,
         a.tipo_produto,
         a.subscr_no,
         a.subscr_no_resets,
         a.flag_processado,
         DECODE(a.tipo_produto,0,12789,1,12788,2,CASE WHEN s.display_external_id_type = 10 THEN 12787 ELSE 12812 END),
         CASE WHEN s.display_external_id_type = 10 THEN 90 ELSE 1 END,
         DECODE(s.display_external_id_type,
         6,valor.valor_ressarcimento, --VOZ
         7,valor2.soma, --BANDA LARGA
         10,valor2.soma, --TV
         12,valor2.soma);
       
    -- Obs.:
    -- 12787   Credito Restituicao Reparo TV
    -- 12788   Credito Restituicao Reparo Dados
    -- 12789   Credito Restituicao Reparo Voz

----------------------------------------------------------------------------------------
----PROCEDURE DUPLICIDADE---------------------------------------------------------------  

PROCEDURE duplicidade (v_external_id in VARCHAR2, v_tipo_produto in INTEGER, v_data_abertura in DATE, v_data_fechamento in DATE, v_flag_processado IN OUT INTEGER, v_mensagem OUT VARCHAR2) as

external_id_temp  VARCHAR2(144);
v_num_ss_temp      VARCHAR2(64);

BEGIN

    BEGIN

        SELECT   external_id, 
            num_ss 
        INTO   external_id_temp, 
            v_num_ss_temp 
        FROM   arborgvt_billing.gvt_credito_interrupcao_log
        WHERE   v_external_id = external_id
          AND v_data_abertura = dt_abertura
          AND v_data_fechamento = dt_fechamento
          AND flag_processado in (0, 2)
          AND tipo_produto = v_tipo_produto;
          
     EXCEPTION
       WHEN OTHERS THEN
        v_flag_processado := 0;
        v_mensagem := null;
        external_id_temp := null;

    END;      
        
    if (external_id_temp is not null) 
    then
      v_flag_processado := 6;
      v_mensagem := 'Duplicado mesma origem ' || v_num_ss_temp;
      
    end if;    
        
END;

----------------------------------------------------------------------------------------
----PROCEDURE SOBREPOSI«√O--------------------------------------------------------------  

PROCEDURE sobreposicao (v_external_id in VARCHAR2, v_tipo_produto in INTEGER, v_data_abertura in DATE, v_data_fechamento in DATE, v_flag_processado IN OUT INTEGER, v_mensagem OUT VARCHAR2) as

external_id_temp   VARCHAR2(144);
v_num_ss_temp      VARCHAR2(64);

BEGIN
    

    BEGIN
      
      UPDATE arborgvt_billing.gvt_credito_interrupcao_log
      SET flag_processado = 7,
      mensagem = 'Sobreposto mesma origem ' || v_num_ss,
      VALOR_PRODUTO = 0,
      VALOR_RESSARC = 0,
      SUBSCR_NO = null,
      SUBSCR_NO_RESETS = null,
      TRACKING_ID = null,
      TRACKING_ID_SERV = null
      WHERE   v_external_id = external_id
      AND dt_abertura >= v_data_abertura --and dt_abertura < v_data_abertura 
      AND dt_fechamento <= v_data_fechamento --and  dt_fechamento > v_data_fechamento
      AND flag_processado in (0, 2)
      AND tipo_produto = v_tipo_produto
      AND rownum <= 1;
      
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Procedure sobreposicao -  Erro ao atualizar registro na tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG.');
      
    END;
    
    COMMIT;
    
    BEGIN
      
      SELECT   NVL(external_id,0), NVL(num_ss,0) into external_id_temp, v_num_ss_temp
      FROM   arborgvt_billing.gvt_credito_interrupcao_log
      WHERE   v_external_id = external_id
      AND dt_abertura <= v_data_abertura 
      AND  dt_fechamento >= v_data_fechamento
      AND flag_processado in (0, 2)
      AND tipo_produto = v_tipo_produto
      AND rownum <= 1;
            
     EXCEPTION
       WHEN OTHERS THEN
        v_flag_processado := 0;
        v_mensagem := null;
        external_id_temp := null;
    END;
        
    if (external_id_temp is not null) 
    then
        v_flag_processado := 7;
        v_mensagem := 'Sobreposto mesma origem ' || v_num_ss_temp;
    end if;
      
END;

----------------------------------------------------------------------------------------
----PROCEDURES SUMARIZA«√O--------------------------------------------------------------  
--DATA ABERTURA--
PROCEDURE sumarizacaoDataAbertura (v_external_id in VARCHAR2, v_desc_ss in VARCHAR2,
                      v_tipo_produto in INTEGER, v_data_abertura in out DATE, v_data_fechamento in DATE, 
            v_num_ss in out VARCHAR2, v_flag_processado in out INTEGER) as

v_data_aberturaAuxiliar   DATE;
v_num_ss_auxiliar_abertura  VARCHAR(64);

BEGIN

  BEGIN
      
    SELECT DT_ABERTURA, NUM_SS INTO v_data_aberturaAuxiliar, v_num_ss_auxiliar_abertura
    FROM ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG GCIL 
    WHERE GCIL.EXTERNAL_ID = v_external_id 
    AND GCIL.DT_ABERTURA   < v_data_abertura    
    AND GCIL.DT_FECHAMENTO   >= v_data_abertura    
    AND GCIL.DT_FECHAMENTO  < v_data_fechamento  
    AND FLAG_PROCESSADO IN(0, 2)  
    AND tipo_produto = v_tipo_produto    
    AND rownum <= 1;
  
  EXCEPTION
   WHEN OTHERS THEN
    v_flag_processado := 0;
    v_data_aberturaAuxiliar := NULL;
    v_num_ss_auxiliar_abertura := NULL;

  END;

  BEGIN
    
    UPDATE ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG GCIL 
    SET FLAG_PROCESSADO = 8, 
    MENSAGEM =  'Relacionado mesma origem - ' || v_num_ss,
    VALOR_PRODUTO = 0,
    VALOR_RESSARC = 0,
    SUBSCR_NO = null,
    SUBSCR_NO_RESETS = null,
    TRACKING_ID = null,
    TRACKING_ID_SERV = null
    WHERE GCIL.EXTERNAL_ID = v_external_id 
    AND GCIL.DT_ABERTURA   < v_data_abertura  
    AND GCIL.DT_FECHAMENTO   >= v_data_abertura  
    AND GCIL.DT_FECHAMENTO  < v_data_fechamento
    AND FLAG_PROCESSADO IN(0,2)
    AND tipo_produto = v_tipo_produto
    AND rownum <= 1;
                
  EXCEPTION
     WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Procedure sumarizacaoDataAbertura -  Erro ao atualizar registro na tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG.');    
    
  END;
    
  COMMIT;

  IF(v_data_aberturaAuxiliar IS NOT NULL) THEN
    
    -- Insere registro que esta sendo processado com flag_processado = 8 antes de ser sumarizado 
    -- O registro inserido dentro da pl eh referente a sumarizacao
    -- SETUP-748
    BEGIN
      INSERT INTO arborgvt_billing.gvt_credito_interrupcao_log (
          external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
          dt_inclusao, flag_processado, mensagem, valor_produto, valor_ressarc, SUBSCR_NO, SUBSCR_NO_RESETS)
      VALUES (
          v_external_id, v_data_abertura, v_data_fechamento, v_num_ss, v_desc_ss,
          v_tipo_produto, SYSDATE, 8, 'Relacionado mesma origem - '||v_num_ss_auxiliar_abertura,0,0, null, null);
      
    EXCEPTION
       WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Procedure sumarizacaoDataAbertura - Erro ao inserir num_ss '|| v_num_ss ||' na tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG.');
          
    END;
    
    COMMIT;
    
    v_data_abertura := v_data_aberturaAuxiliar;
    v_num_ss := v_num_ss_auxiliar_abertura || ',' || v_num_ss; 
    v_flag_processado := 0;
    
  END IF;
      
END;

--DATA FECHAMENTO--
PROCEDURE sumarizacaoDataFechamento (v_external_id in VARCHAR2, v_desc_ss in VARCHAR2,
                      v_tipo_produto in INTEGER, v_data_abertura in DATE, v_data_fechamento in out DATE, 
            v_num_ss in out VARCHAR2, v_flag_processado in out INTEGER) as

v_data_fechamentoAuxiliar DATE;
v_num_ss_auxiliar_fechamento  VARCHAR(64);

BEGIN

  BEGIN
      
    SELECT DT_FECHAMENTO, NUM_SS INTO v_data_fechamentoAuxiliar, v_num_ss_auxiliar_fechamento
    FROM ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG GCIL 
    WHERE GCIL.EXTERNAL_ID = v_external_id 
    AND GCIL.DT_ABERTURA   > v_data_abertura    --AND v_data_abertura < GCIL.DT_ABERTURA     
    AND GCIL.DT_ABERTURA   <= v_data_fechamento    --AND v_data_fechamento >= GCIL.DT_ABERTURA    
    AND GCIL.DT_FECHAMENTO  > v_data_fechamento  --AND v_data_fechamento <= GCIL.DT_FECHAMENTO 
    AND FLAG_PROCESSADO IN(0, 2)         --AND FLAG_PROCESSADO IN(8)
    AND tipo_produto = v_tipo_produto
    AND rownum <= 1;
  
  EXCEPTION
   WHEN OTHERS THEN
    v_flag_processado := 0;
    v_data_fechamentoAuxiliar := NULL;
    v_num_ss_auxiliar_fechamento := NULL;

  END;

  BEGIN
    
    UPDATE ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG GCIL 
    SET FLAG_PROCESSADO = 8, 
      MENSAGEM =  'Relacionado mesma origem - ' || v_num_ss,
      VALOR_PRODUTO = 0,
      VALOR_RESSARC = 0,
      SUBSCR_NO = null,
      SUBSCR_NO_RESETS = null,
      TRACKING_ID = null,
      TRACKING_ID_SERV = null
    WHERE GCIL.EXTERNAL_ID = v_external_id 
    AND GCIL.DT_ABERTURA   > v_data_abertura  
    AND GCIL.DT_ABERTURA   <= v_data_fechamento
    AND GCIL.DT_FECHAMENTO  > v_data_fechamento
    AND FLAG_PROCESSADO IN(0,2)
    AND tipo_produto = v_tipo_produto
    AND rownum <= 1;
                
  EXCEPTION
     WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Procedure sumarizacaoDataFechamento - Erro ao atualizar cliente '|| v_external_id ||' na tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG.');    
    
  END;
  
  COMMIT;
         
  IF(v_data_fechamentoAuxiliar IS NOT NULL) THEN

    -- Insere registro que esta sendo processado com flag_processado = 8 antes de ser sumarizado 
    -- O registro inserido dentro da pl eh referente a sumarizacao
    -- SETUP-748  
    BEGIN
        INSERT INTO arborgvt_billing.gvt_credito_interrupcao_log (
                      external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
                      dt_inclusao, flag_processado, mensagem, valor_produto, valor_ressarc, SUBSCR_NO, SUBSCR_NO_RESETS)
                VALUES (
                      v_external_id, v_data_abertura, v_data_fechamento, v_num_ss, v_desc_ss,
                      v_tipo_produto, SYSDATE, 8, 'Relacionado mesma origem - '||v_num_ss_auxiliar_fechamento,0,0, null, null);
    
    EXCEPTION
       WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Procedure sumarizacaoDataFechamento - Erro ao inserir num_ss '|| v_num_ss ||' na tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG.');
        
    END;
    
    COMMIT;
    
    v_data_fechamento := v_data_fechamentoAuxiliar;
    v_num_ss := v_num_ss_auxiliar_fechamento || ',' || v_num_ss; 
    v_flag_processado := 0;
  END IF;
      
END;

---------------------------------------------------------------------------------------------------------------
--PROCEDURE DATAS_BASE-----------------------------------------------------------------------------------------
PROCEDURE datas_base(v_external_id in VARCHAR2, v_dt_abertura_base out DATE, v_dt_fechamento_base out DATE) as
BEGIN
  
  BEGIN
    
    SELECT DT_ABERTURA, DT_FECHAMENTO INTO v_dt_abertura_base, v_dt_fechamento_base
    FROM ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG
    WHERE external_id = v_external_id
    AND FLAG_PROCESSADO IN(0, 2)
    AND rownum <= 1;

  EXCEPTION
    WHEN OTHERS THEN
      v_dt_abertura_base := NULL;
      v_dt_fechamento_base := NULL;
      
  END;
  
END;

BEGIN

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' Iniciando PL_GERA_NRC_INTERRUPCAO alterado em 30/10/2015...');

   ------------------------------------------------ PARTE 1 ------------------------------------------------
   --        Para cada interrupcao (linha da tabela de carga), insere os detalhes na tabela de log        --
   ---------------------------------------------------------------------------------------------------------

   ---------------------------------------------------------------------------------------------------------
   FOR i IN c_carga LOOP -- Loop por cliente
      BEGIN
         v_data_abertura := i.dt_abertura;
         v_data_fechamento := i.dt_fechamento;
         v_account_no := i.account_no;
         v_valor := 0;
     v_flag_processado := 0;

     v_subscr_no         := NULL;
     v_subscr_no_resets  := NULL;
     
         -- Seta o tipo de external id de acordo com o tipo de interrupcao
         -- procedimento comentado pois a query foi alterada para contemplar os external_id_type de TV
     -- Procedimento reativado pois a pl processar· tipos diferentes
         CASE i.tipo_produto
            WHEN 0 THEN v_external_id_type := 6;  -- voz
            WHEN 1 THEN v_external_id_type := 7;  -- dados
            --WHEN 2 THEN v_external_id_type := 10; -- tv
            ELSE v_external_id_type := -1; -- tv, iptv
         END CASE;
            
         -------------------------------------------------------------------------------------------------
         v_mensagem_erro := NULL;
         v_qt_produtos := 0;
     v_num_ss := i.num_ss;
     v_external_id := i.external_id;


     
    FOR a IN c_anatel LOOP -- Loop por interrupcao, verificacao anatel  

        duplicidade(i.external_id, i.tipo_produto , v_data_abertura, v_data_fechamento, v_flag_processado, v_mensagem_erro);
        
        IF v_flag_processado <> 6
        THEN
          sobreposicao(i.external_id, i.tipo_produto , v_data_abertura, v_data_fechamento, v_flag_processado, v_mensagem_erro);

        END IF;
        
        IF v_flag_processado <> 6 AND v_flag_processado <> 7
        THEN 
          sumarizacaoDataAbertura(i.external_id, i.desc_ss, i.tipo_produto, v_data_abertura, v_data_fechamento, v_num_ss, v_flag_processado);

        END IF;
        
        IF v_flag_processado <> 6 AND v_flag_processado <> 7 AND v_flag_processado <> 8
        THEN 
          sumarizacaoDataFechamento(i.external_id, i.desc_ss, i.tipo_produto, v_data_abertura, v_data_fechamento, v_num_ss, v_flag_processado);

        END IF;
        
    END LOOP;
     
    --IF v_mensagem_erro IS NULL THEN
    IF v_flag_processado <> 6 AND v_flag_processado <> 7 AND v_flag_processado <> 8 THEN

         FOR p IN REVERSE c_produtos LOOP -- Loop por produto
            BEGIN
               -- Seta as variavels de subscr no
               v_subscr_no := p.parent_subscr_no;
               v_subscr_no_resets := p.parent_subscr_no_resets;


        SELECT (NVL(
              (SELECT max(pro.override_rate)
                FROM product_rate_override pro
                WHERE pro.tracking_id = p.tracking_id--
                  AND pro.tracking_id_serv = p.tracking_id_serv--
                  AND v_data_abertura >= pro.active_dt--
                  AND (pro.inactive_dt is null or v_data_abertura <= pro.inactive_dt)
              ),--
                        
              NVL((SELECT max(rate)
                    FROM rate_rc rr, product_rate_key prk
                   WHERE rr.element_id = p.element_id--
                     AND (decode(e.level_code,1,
                           (SELECT rate_class_default FROM cmf WHERE account_no = p.billing_account_no),
                           p.rate_class) = rr.rate_class or rr.rate_class = 0)--
                     AND (rr.component_id = p.component_id or rr.component_id = 0)--
                     AND (rr.equip_class_code = p.equip_class_code or rr.equip_class_code = 0)--
                     AND (rr.equip_type_code = p.equip_type_code or rr.equip_type_code = 0)--
                     AND v_data_abertura >= rr.active_date--
                     AND (rr.inactive_date is null or
                       v_data_abertura <= rr.inactive_date)--
                     AND prk.jurisdiction = rr.jurisdiction
                     AND prk.units_type = rr.units_type
                     AND prk.units = rr.units_lower_limit
                     AND prk.tracking_id = p.tracking_id--
                     AND prk.tracking_id_serv = p.tracking_id_serv--
                     AND prk.inactive_dt is null
                ),
                (SELECT max(rate)
                  FROM rate_rc rr
                  WHERE rr.element_id = p.element_id--
                     AND (decode(e.level_code,1,
                           (SELECT rate_class_default FROM cmf WHERE account_no = p.billing_account_no),
                           p.rate_class) = rr.rate_class or rr.rate_class = 0)--
                    AND (rr.component_id = p.component_id or rr.component_id = 0)--
                    AND (rr.equip_type_code = p.equip_type_code or rr.equip_type_code = 0)--
                    AND (rr.equip_class_code = p.equip_class_code or rr.equip_class_code = 0)--
                    AND v_data_abertura >= rr.active_date--
                    AND (rr.inactive_date is null or v_data_abertura <= rr.inactive_date)--
                ))
              )) rate into v_valor_produto
        FROM product_elements e
        WHERE e.element_id = p.element_id;--

         
         
         
--           -- Alteracao PJ1016 - Alfaiate 
--           IF i.tipo_produto IN (0,1) THEN
--
--            -- Recupera valor do produto atual para voz e dados
--            -- ******************* Esta consulta NAO SUPORTA LAVOISIER *******************
--            SELECT NVL(r.rate,0)
--            INTO   v_valor_produto
--            FROM   arbor.rate_rc r
--            WHERE  r.element_id           = p.element_id
--            AND    r.component_id         = DECODE(p.rate_component_id, 1, p.component_id, 0)
--            AND    (r.equip_class_code    = p.equip_class_code OR r.equip_class_code = 0)
--            AND    r.units_lower_limit    = 0
--            AND    ( (TRUNC(v_data_abertura) BETWEEN r.active_date AND NVL(r.inactive_date, SYSDATE) - 1/24/60/60) 
--                OR (TRUNC(v_data_fechamento) BETWEEN r.active_date AND NVL(r.inactive_date, SYSDATE) - 1/24/60/60) );
--
--           ELSE

--            BEGIN
--             -- Recupera valor do produto atual para tv                                            
--             SELECT NVL(rr.rate,0)
--             INTO   v_valor_produto
--             FROM   product_rate_key prk,
--                rate_rc rr
--             WHERE  1 = 1
--             -- Safra
--             AND    prk.tracking_id = p.tracking_id
--             AND    prk.tracking_id_serv = p.tracking_id_serv
--             -- Valor
--             AND    rr.element_id             = p.element_id
--             AND    (rr.equip_type_code       = p.equip_type_code       OR rr.equip_type_code       = 0)
--             AND    (rr.equip_class_code      = p.equip_class_code      OR rr.equip_class_code      = 0)
--             AND    (rr.class_of_service_code = p.class_of_service_code OR rr.class_of_service_code = 0)
--             AND    rr.component_id           = DECODE(p.rate_component_id, 1, p.component_id, 0)
--             AND    rr.currency_code          = 1
--             AND    rr.jurisdiction           = 0
--             AND    rr.units_type             = 0
--             AND    (rr.units_lower_limit     = prk.units               OR rr.units_lower_limit     = 0)
--             AND    rr.pop_lower_limit        = 0
--             -- Suporte para Reajustes futuros e
--             -- considera o preco ativo no final do periodo de interrupcao.
--             -- Caso o preco tenha sido reajustado exatamente no fim do periodo, considera-se o preco anterior.
--             AND    ( (TRUNC(v_data_abertura)    BETWEEN rr.active_date AND NVL(rr.inactive_date, SYSDATE) - 1/24/60/60)
--                  OR (TRUNC(v_data_fechamento)    BETWEEN rr.active_date AND NVL(rr.inactive_date, SYSDATE) - 1/24/60/60) );

--                 EXCEPTION
--            WHEN NO_DATA_FOUND THEN
            
              
--
--            -- Ajuste para o caso da billing_active_dt seja NULL
--                        IF nvl(p.billing_inactive_dt, TRUNC(v_data_abertura)) < v_data_corte_alfaiate THEN
--
--                           -- Busca o preco sem a safra
--                           SELECT NVL(r.rate,0)
--                           INTO   v_valor_produto
--                           FROM   arbor.rate_rc r
--                           WHERE  r.element_id           = p.element_id
--                           AND    r.component_id         = DECODE(p.rate_component_id, 1, p.component_id, 0)
--                           AND    (r.equip_class_code    = p.equip_class_code OR r.equip_class_code = 0)
--                           AND    r.units_lower_limit    = 0
--                           AND    ( (TRUNC(v_data_abertura) BETWEEN r.active_date AND NVL(r.inactive_date, SYSDATE) - 1/24/60/60)
--                  OR (TRUNC(v_data_fechamento) BETWEEN r.active_date AND NVL(r.inactive_date, SYSDATE) - 1/24/60/60) );
--                  
--                        ELSE
--                           RAISE NO_DATA_FOUND;
--                        END IF;
--                  END;
--        END IF;

               -- Recupera descontos do produto atual
               SELECT NVL(SUM(DECODE(a.tipo, 'V', a.valor*100, v_valor_produto*a.valor/100)),0)
               INTO   v_desconto
               FROM   (
                        SELECT CASE
                                 WHEN rdo.override_tracking_id IS NULL THEN
                                    CASE
                                       WHEN rd.discount_amount IS NOT NULL THEN
                                          rd.discount_amount / 100
                                       ELSE
                                          rd.discount_percent / POWER(10, rd.implied_decimals)
                                    END
                                 ELSE
                                    CASE
                                       WHEN rdo.discount_amount IS NOT NULL THEN
                                          rdo.discount_amount / 100
                                       ELSE
                                          rdo.discount_percent / POWER(10, rdo.implied_decimals)
                                    END
                               END valor,
                               CASE
                                 WHEN rdo.override_tracking_id IS NULL THEN
                                    CASE
                                       WHEN rd.discount_amount IS NOT NULL THEN
                                          'V'
                                       ELSE
                                          'P'
                                    END
                                 ELSE
                                    CASE
                                       WHEN rdo.discount_amount IS NOT NULL THEN
                                          'V'
                                       ELSE
                                          'P'
                                    END
                               END tipo
                        FROM   arbor.customer_contract         cc,
                               arbor.customer_contract_key     cck,
                              arbor.contract_types            ct,
                               arbor.discount_plans            dp,
                               arbor.discount_restrictions     dr,
                               arbor.package_component_members pcm,
                               arbor.rate_discount             rd,
                              arbor.rate_discount_overrides   rdo,
                               arbor.package_components        pc
                        WHERE  pcm.component_id       = pc.component_id
                        AND    cc.tracking_id         = cck.tracking_id
                        AND    cc.tracking_id_serv    = cck.tracking_id_serv
                        AND    cc.contract_type       = ct.contract_type
                        AND    ct.plan_id_discount    IS NOT NULL
                        AND    ct.plan_id_discount    = dp.plan_id_discount
                        AND    dp.discount_id         = dr.discount_id
                        AND    dr.restricted_domain   = 1
                        AND    dr.restricted_id       = pcm.member_id
                        AND    pcm.member_type        = 1
                        AND    dr.discount_id         = rd.discount_id
                        AND    (rd.rate_class         = 1 OR rd.rate_class = 0)
                        AND    cc.tracking_id         = rdo.contract_tracking_id(+)
                        AND    cc.tracking_id_serv    = rdo.contract_tracking_id_serv(+)
                        AND    pcm.component_id       = p.component_id
                        AND    pcm.member_id          = p.element_id
                        AND    cc.parent_account_no   = v_account_no
                        --AND    ( (TRUNC(v_data_abertura) BETWEEN ct.active_date AND NVL(ct.inactive_date, SYSDATE) - 1/24/60/60)
            --    OR (TRUNC(v_data_fechamento) BETWEEN ct.active_date AND NVL(ct.inactive_date, SYSDATE) - 1/24/60/60) )
            AND     v_data_abertura >= ct.active_date--
            AND   (ct.inactive_date is null or v_data_abertura <= ct.inactive_date)--
                        ORDER  BY dp.def_order
                      ) a;

               -- Calcula valor do produto atual
               v_valor_produto := v_valor_produto - v_desconto;

               -- Zera caso negativo
               IF v_valor_produto < 0 THEN
                  v_valor_produto := 0;
               END IF;
        
               -- Atualiza no valor total dos produtos do cliente
               v_valor := v_valor + v_valor_produto;

               v_qt_produtos := v_qt_produtos + 1;

            EXCEPTION
               WHEN OTHERS THEN
                  v_mensagem_erro := SUBSTR(SQLERRM,1,255);

                  DBMS_OUTPUT.PUT_LINE (
                     TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
                     ' Conta cobranca: ' || i.external_id || ' Component_id: ' || p.component_id || ' Element_id: ' || p.element_id ||
                     ' - Ocorreu um erro inesperado na busca do preco.');
            END;

         END LOOP;

     END IF;
         -------------------------------------------------------------------------------------------------
         
     -- Verifica quanto tempo durou a interrupcao
     -- InterrupÁ„o menor ou igual a 30 minutos ñ ressarcir por 30 minutos do valor faturado;
     -- InterrupÁ„o de 31 minutos atÈ 24 horas ñ ressarcir 1/30 (um trinta avos) do valor da tarifa 
     -- ou preÁo de assinatura;
     -- InterrupÁ„o maior que 24 horas ñ ressarcir 1/30 (um trinta avos), do valor da tarifa ou preÁo de 
     -- assinatura, a cada perÌodo de 24 horas interrompido. 
     -- SETUP-748
     v_periodo_interrupcao_temp := v_data_fechamento - v_data_abertura;
     
    IF (v_periodo_interrupcao_temp <= v_30_minutos) 
    THEN
      v_periodo_interrupcao := v_30_minutos;
      
      ELSIF (v_periodo_interrupcao_temp > v_30_minutos and v_periodo_interrupcao_temp < 1) --Periodo igual a 1 equivale a 24 hrs
      THEN
        v_periodo_interrupcao := 1;
        
        ELSIF (v_periodo_interrupcao_temp = trunc(v_periodo_interrupcao_temp))
        THEN
          v_periodo_interrupcao := v_periodo_interrupcao_temp;
          
          ELSE
            v_periodo_interrupcao := (trunc(v_periodo_interrupcao_temp) + 1);
     END IF;     
     
     -- Apos termino do loop, a variavel v_valor contem o valor total de produtos de tv do cliente
         -- Agora, de fato, faz o calculo da interrupcao
         -- v_nrc := v_valor * (v_data_fechamento - v_data_abertura)/30;
     
    CASE v_external_id_type
      WHEN 6 THEN v_nrc := TRUNC((v_valor * v_periodo_interrupcao/30),5); -- voz
      WHEN 7 THEN v_nrc := v_valor * (v_data_fechamento - v_data_abertura)/30; -- dados
      WHEN -1 THEN v_nrc := v_valor * (v_data_fechamento - v_data_abertura)/30; -- tv, iptv
    END CASE;
     
         -- Obs.: data - data = diferenca em dias
         -- Multiplicando pelo valor mensal e dividindo por 30 (por definicao) tem-se o valor do
         -- ressarcimento da interrupcao     
     
     -- Quando o resultado final do valor a ressarcir for inferior a R$ 0,01, ressarcir R$ 0,01.
     -- SETUP-748
     --IF (v_nrc < 0.01) THEN
     --  v_nrc := 0.01;
     --END IF;
     
         BEGIN
            IF v_mensagem_erro IS NOT NULL THEN
               -- Insere na tabela de log com flag de erro 3 caso tenha dado erro no calculo do preco de algum produto
               -- Foi utilizado o valor 3 porque o erro 2 (nao conseguiu inserir a NRC) sao tentados reinserir a NRC em todos
               -- processamentos dessa PL.
               IF v_flag_processado <> 6 AND v_flag_processado <> 7 AND v_flag_processado <> 8 THEN 
                    v_flag_processado := 3;
               END IF;
         
               v_counter_3 := v_counter_3 + 1;   -- conta a qtde de registros que deram erro na busca do preco dos produtos

               INSERT INTO arborgvt_billing.gvt_credito_interrupcao_log (
                      external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
                      valor_produto, valor_ressarc, dt_inclusao, subscr_no, subscr_no_resets, flag_processado, mensagem)
               VALUES (
                      i.external_id, v_data_abertura, v_data_fechamento, v_num_ss, i.desc_ss,
                      i.tipo_produto, v_valor, v_nrc, SYSDATE, v_subscr_no, v_subscr_no_resets, v_flag_processado, v_mensagem_erro);

            ELSIF v_qt_produtos = 0 THEN
               -- Insere na tabela de log com flag de erro 4 caso n√£o tenha produto para calcular o ressarcimento
               -- Foi utilizado o valor 4 porque o erro 2 (nao conseguiu inserir a NRC) sao tentados reinserir a NRC em todos
               -- processamentos dessa PL.

               v_counter_4 := v_counter_4 + 1;   -- conta a qtde de registros que n√£o tem produto
         
         IF v_flag_processado <> 6 AND v_flag_processado <> 7 AND v_flag_processado <> 8 THEN 
                    v_flag_processado := 4;
               END IF;
         
               DBMS_OUTPUT.PUT_LINE (
                  TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
                  ' Conta cobranca: ' || i.external_id ||
                  ' - Nao encontrados produtos ativos no periodo da interrupcao.');

               INSERT INTO arborgvt_billing.gvt_credito_interrupcao_log (
                      external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
                      valor_produto, valor_ressarc, dt_inclusao, subscr_no, subscr_no_resets, flag_processado, mensagem)
               VALUES (
                      i.external_id, v_data_abertura, v_data_fechamento, v_num_ss, i.desc_ss,
                      i.tipo_produto, v_valor, v_nrc, SYSDATE, v_subscr_no, v_subscr_no_resets, v_flag_processado, v_mensagem_erro); --4

            ELSIF v_nrc > 0 THEN
               -- Insere na tabela de log
               INSERT INTO arborgvt_billing.gvt_credito_interrupcao_log (
                      external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
                      valor_produto, valor_ressarc, dt_inclusao, subscr_no, subscr_no_resets, flag_processado)
               VALUES (
                      i.external_id, v_data_abertura, v_data_fechamento, v_num_ss, i.desc_ss,
                      i.tipo_produto, v_valor, v_nrc, SYSDATE, v_subscr_no, v_subscr_no_resets, 0);

            ELSIF v_nrc = 0 THEN
               -- Insere na tabela de log porem nao gerara NRC por ser valor zero

               v_counter_5 := v_counter_5 + 1;

               INSERT INTO arborgvt_billing.gvt_credito_interrupcao_log (
                      external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
                      valor_produto, valor_ressarc, dt_inclusao, subscr_no, subscr_no_resets, flag_processado)
               VALUES (
                      i.external_id, v_data_abertura, v_data_fechamento, v_num_ss, i.desc_ss,
                      i.tipo_produto, v_valor, v_nrc, SYSDATE, v_subscr_no, v_subscr_no_resets, 0);

            END IF;

            COMMIT;

         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               -- Ignora insercao caso SS ja exista
               v_counter_1 := v_counter_1 - 1;

            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE (
                  TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
                  ' Conta cobranca: ' || i.external_id ||
                  ' - Ocorreu um erro inesperado ao inserir na tabela ARBORGVT_BILLING.GVT_CREDITO_INTERRUPCAO_LOG: ' || SUBSTR(SQLERRM,1,200));
         END;

      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE (
               TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
               ' Conta cobranca: ' || i.external_id ||
               ' - Ocorreu um erro inesperado na execucao da PL_GERA_NRC_INTERRUPCAO: ' || SUBSTR(SQLERRM,1,200));

      END;
   END LOOP;
   ---------------------------------------------------------------------------------------------------------

   ------------------------------------------------ PARTE 2 ------------------------------------------------
   --                 Agrupa as interrupcoes da tabela de log por cliente e insere sua NRC                --
   --                         Tambem atualiza os dados com os tracking id da NRC                          --
   ---------------------------------------------------------------------------------------------------------

   ---------------------------------------------------------------------------------------------------------
   FOR n IN c_nrc LOOP -- Loop de insercao na nrc e atualizacao na tabela de log

      BEGIN

        IF n.valor_ressarc >= 1 THEN
             -- Insere na nrc
             NRC_INSERT (
                v_account_no                => n.account_no,
                v_subscr_no                 => n.subscr_no,
                v_subscr_no_resets          => n.subscr_no_resets,
                v_element_id                => NULL,
                v_sales_channel_id          => 1, --> canal de vendas 1
                v_type_id_nrc               => n.nrc, --> tipo da NRC
                v_rate                      => v_nrc,-- n.valor_ressarc,
                v_eff_date                  => TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')||' 12:25:00','DD/MM/YYYY HH24:MI:SS'), --> EFFECTV_DT
                v_chg_who                   => 'PL_GERA_INTERRUPCAO_NRC', --RFC 426127
                v_annotation                => 'PL_GERA_INTERRUPCAO_NRC '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS'), --RFC 426127
                v_component_id              => 0,
                v_tracking_id               => v_tracking_id,
                v_tracking_id_serv          => v_tracking_id_serv,
                v_open_item_id              => n.open_item_id, --RFC 426127
                v_request_status            => 1,
                v_contract_tracking_id      => NULL,
                v_contract_tracking_id_serv => NULL,
                v_contract_association_type => 0
             );
         
            v_counter_1 := v_counter_1 + 1; --RFC 426127: conta a qtde de registros inseridos efetivamente na NRC.

             -- Atualiza dados com o tracking id da nrc gerado
             UPDATE arborgvt_billing.gvt_credito_interrupcao_log
             SET    tracking_id      = v_tracking_id,
                    tracking_id_serv = v_tracking_id_serv,
                    flag_processado  = 1,
                    mensagem         = NULL
             WHERE  external_id     = n.external_id
             AND    flag_processado = n.flag_processado;
    
          ELSE
          
          -- Atualiza dados com o tracking id da nrc gerado
             UPDATE arborgvt_billing.gvt_credito_interrupcao_log
             SET    tracking_id      = v_tracking_id,
                    tracking_id_serv = v_tracking_id_serv,
                    flag_processado  = 5,
          valor_ressarc   = 0,
                    mensagem         = NULL
             WHERE  external_id     = n.external_id
             AND    flag_processado = n.flag_processado;
               
          END IF; 
         
       
      EXCEPTION
         WHEN OTHERS THEN
            ROLLBACK;
            
            v_counter_2 := v_counter_2 + 1;  -- conta a qtde de registros que deram erro na insercao na NRC

            v_mensagem_erro := SUBSTR(SQLERRM,1,255);

            UPDATE arborgvt_billing.gvt_credito_interrupcao_log
            SET    flag_processado = 2,
                   mensagem        = v_mensagem_erro
            WHERE  external_id     = n.external_id
            AND    flag_processado = 0;
      END;
      
      COMMIT;

   END LOOP;
   ---------------------------------------------------------------------------------------------------------

   ------------------------------------------------ PARTE 3 ------------------------------------------------
   --                               Deleta todas os dados da tabela de carga                              --
   ---------------------------------------------------------------------------------------------------------

   DELETE FROM arborgvt_billing.gvt_credito_interrupcao_carga;

   COMMIT;

   ------------------------------------------------ PARTE 4 ------------------------------------------------
   --                 Transfere os dados antigos (7 meses ou mais) para a tabela de backup                --
   ---------------------------------------------------------------------------------------------------------

   -- Fixa uma data para os dados antigos
   -- Esta variavel existe apenas para nao "perder" algum dado entre a insercao e a remocao de dados
   v_data_dados_antigos := ADD_MONTHS(SYSDATE, -7);

   -- Insere os dados antigos na tabela de backup
   INSERT INTO arborgvt_billing.gvt_credito_interrupcao_bkp (
          external_id, dt_abertura, dt_fechamento, num_ss, desc_ss, tipo_produto,
          valor_produto, valor_ressarc, dt_inclusao, subscr_no, subscr_no_resets,
          tracking_id, tracking_id_serv, flag_processado)
   SELECT external_id,
          dt_abertura,
          dt_fechamento,
          num_ss,
          desc_ss,
          tipo_produto,
          valor_produto,
          valor_ressarc,
          SYSDATE,
          subscr_no,
          subscr_no_resets,
          tracking_id,
          tracking_id_serv,
          flag_processado
    FROM  arborgvt_billing.gvt_credito_interrupcao_log
   WHERE  dt_fechamento < v_data_dados_antigos;

   COMMIT;

   -- Deleta os dados antigos da tabela de log
   
    DELETE FROM arborgvt_billing.gvt_credito_interrupcao_log
    WHERE  dt_fechamento < v_data_dados_antigos;

   COMMIT;

   ---------------------------------------------------------------------------------------------------------

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' PL_GERA_NRC_INTERRUPCAO finalizada.');

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' ' || v_counter_1 ||
      ' registros foram inseridos na tabela NRC (arborgvt_billing.gvt_credito_interrupcao_log.flag_processado = 1).');

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' ' || v_counter_2 ||
      ' registros nao foram inseridos na tabela NRC por erro na insercao (arborgvt_billing.gvt_credito_interrupcao_log.flag_processado = 2).');

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' ' || v_counter_3 ||
      ' registros nao foram inseridos na tabela NRC por erro na busca do valor dos produtos (arborgvt_billing.gvt_credito_interrupcao_log.flag_processado = 3).');

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' ' || v_counter_4 ||
     ' registros nao foram inseridos na tabela NRC por nao ter produtos no periodo (arborgvt_billing.gvt_credito_interrupcao_log.flag_processado = 4).');

   DBMS_OUTPUT.PUT_LINE (
      TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
      ' ' || v_counter_5 ||
      ' registros nao foram inseridos na tabela NRC por ter valor zero a ser ressarcido (arborgvt_billing.gvt_credito_interrupcao_log.flag_processado = 5).');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE (
         TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS') ||
         ' Ocorreu um erro inesperado na execucao da PL_GERA_NRC_INTERRUPCAO: ' || SUBSTR(SQLERRM,1,200));
END;
/
EXIT;
