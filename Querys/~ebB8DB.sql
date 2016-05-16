SET VERIFY              OFF;
SET SERVEROUT ON SIZE   1000000;
SET FEED                OFF;
SET SPACE               0;
SET PAGESIZE            0;
SET LINE                10000;
SET WRAP                ON;
SET HEADING             OFF;

DECLARE
  /* PL criada por Rodrigo Zago (G0012386) para a geração do relatório de faturamento Carrier TIM.
  ** A mesma é executada após a execução da PLFAT_CIRC_DADOS_0005.sql que faz a carga dos dados do
  ** relatório na tabela ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.
  */
  V_DT_INICIO               DATE;
  V_DT_FIM                  DATE;
  V_PERIODO_APURACAO        VARCHAR2(200);
  V_CICLO                   VARCHAR2(3);
  V_DT_EMISSAO              DATE;
  V_MES_REF                 VARCHAR2(6);
  
  
  
  cursor cnpj is
   select cnpj, operadora from gvt_carrier_cnpj
   where status = 1;
  
  CURSOR FATURAS_CICLO (V_CNPJ IN varchar2) IS
    SELECT A.NRO_FATURA, max(DATE_GERACAO) DATA_GERACAO
      FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS A
     WHERE SUBSTR(CNPJ, 1, 8) = V_CNPJ
       AND EMISSAO_FATURA = V_DT_EMISSAO 
       AND CICLO          = V_CICLO
     GROUP BY NRO_FATURA;
  
  CURSOR DADOS_CARRIER (I_NRO_FATURA IN NUMBER,V_CNPJ IN varchar2, V_DATA_GERACAO IN DATE ) IS
SELECT 
    base.id  ID_CIRCUITO_A,
    ponta_a.NRO_FATURA NRO_FATURA_A,
    ponta_a.CONTA_SERVICO CONTA_SERVICO_A,
    ponta_a.ALIQUOTA_ICMS ALIQ_ICMS_A,
    ponta_a.FATURAMENTO_BRUTO FATURAMENTO_BRUTO_A,
    ponta_a.DESCONTOS DESCONTO_ICMS_A,
    ponta_a.AJUSTES AJUSTES_A,
    ponta_a.PIS_COFINS PIS_COFINS_A,
    ponta_a.ICMS ICMS_A,
    base.id ID_CIRCUITO_B,
    ponta_b.NRO_FATURA NRO_FATURA_B,
    ponta_b.CONTA_SERVICO CONTA_SERVICO_B,
    ponta_b.ALIQUOTA_ICMS ALIQ_ICMS_B,
    ponta_b.FATURAMENTO_BRUTO FATURAMENTO_BRUTO_B,
    ponta_b.DESCONTOS DESCONTO_ICMS_B,
    ponta_b.AJUSTES AJUSTES_B,
    ponta_b.PIS_COFINS PIS_COFINS_B,
    ponta_b.ICMS ICMS_B
FROM 
    ( SELECT base1.ID, pontaA.ct_ponta_a, DECODE( pontaB.ct_ponta_b, pontaA.ct_ponta_a, '', pontaB.ct_ponta_b ) ct_ponta_b,
             base1.faturamento_bruto, base1.descontos, base1.nome_cliente, base1.cnpj                             
    FROM                                     
        ( SELECT rcd.ID_circuito id , SUM( FATURAMENTO_BRUTO/100 ) faturamento_bruto, SUM(descontos/100) descontos,
                 MIN(NOME_CLIENTE) nome_cliente, MIN(CNPJ) cnpj
        FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS rcd 
        WHERE  rcd.DATE_GERACAO = V_DATA_GERACAO
        AND    SUBSTR(rcd.CNPJ,1,8) = V_CNPJ
        GROUP BY rcd.ID_circuito
        ORDER BY rcd.id_circuito     ) base1,
        ( SELECT  id_circuito, MIN( conta_servico) ct_ponta_a
          FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS dados
          GROUP BY id_circuito ) pontaA,
        ( SELECT  id_circuito, MAX( conta_servico) ct_ponta_b 
          FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS dados
          GROUP BY id_circuito ) pontaB
    WHERE base1.ID = pontaA.id_circuito AND
          base1.ID = pontaB.id_circuito (+) ) base, 
    ( SELECT element_id, id_circuito, TIPO_SERVICO, DESCRICAO_PRODUTO, cidade, uf, DESIGNADOR, CONTA_COBRANCA, CONTA_SERVICO, MAX( DATA_ATIVACAO ) data_ativacao, MAX(DATA_INATIVACAO ) DATA_INATIVACAO, ENDERECO_INSTALACAO, NRO_FATURA,NRO_NOTA_FISCAL, CICLO, EMISSAO_FATURA, MAX( PERIODO_APURACAO ) PERIODO_APURACAO, ALIQUOTA_ICMS, SUM(FATURAMENTO_BRUTO) as FATURAMENTO_BRUTO, sum(DESCONTOS) as DESCONTOS, sum(AJUSTES) as AJUSTES, sum(ICMS) as ICMS, sum(PIS_COFINS) as PIS_COFINS
                FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS WHERE  tipo_servico_id  IN (SELECT DISTINCT TIPO_SERVICO_ID 
                                                    FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS     
                                                    WHERE DATE_GERACAO = V_DATA_GERACAO
                                                    AND SUBSTR(CNPJ,1,8) = V_CNPJ
                                                    AND UPPER( descricao_produto ) LIKE UPPER( '%Acesso%' )  ) 
             AND element_id NOT IN (11006,11016)                                                                                                     
      GROUP BY  element_id, id_circuito, TIPO_SERVICO, DESCRICAO_PRODUTO, cidade, uf, DESIGNADOR, CONTA_COBRANCA, CONTA_SERVICO, ENDERECO_INSTALACAO, NRO_FATURA,NRO_NOTA_FISCAL, CICLO, EMISSAO_FATURA, ALIQUOTA_ICMS) ponta_a,        
    ( SELECT element_id, id_circuito, TIPO_SERVICO, DESCRICAO_PRODUTO, cidade, uf, DESIGNADOR, CONTA_COBRANCA, CONTA_SERVICO, MAX( DATA_ATIVACAO ) data_ativacao, 
             MAX(DATA_INATIVACAO ) DATA_INATIVACAO, ENDERECO_INSTALACAO, NRO_FATURA,NRO_NOTA_FISCAL, CICLO, EMISSAO_FATURA, MAX( PERIODO_APURACAO ) PERIODO_APURACAO, ALIQUOTA_ICMS, SUM(FATURAMENTO_BRUTO) as FATURAMENTO_BRUTO, sum(DESCONTOS) as DESCONTOS, sum(AJUSTES) as AJUSTES, sum(ICMS) as ICMS, sum(PIS_COFINS) as PIS_COFINS   
                FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS WHERE  tipo_servico_id  IN (SELECT DISTINCT TIPO_SERVICO_ID 
                                                    FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS     
                                                    WHERE DATE_GERACAO = V_DATA_GERACAO
                                                    AND SUBSTR(CNPJ,1,8) = V_CNPJ
                                                    AND UPPER( descricao_produto ) LIKE UPPER( '%Acesso%' )  )  
             AND element_id NOT IN (11006,11016)                                                                                                     
      GROUP BY element_id, id_circuito, TIPO_SERVICO, DESCRICAO_PRODUTO, cidade, uf, DESIGNADOR, CONTA_COBRANCA, CONTA_SERVICO, ENDERECO_INSTALACAO, NRO_FATURA,NRO_NOTA_FISCAL, CICLO, EMISSAO_FATURA, ALIQUOTA_ICMS) ponta_b        
WHERE base.id         = ponta_a.id_circuito (+) AND
      base.ct_ponta_a = ponta_a.conta_servico (+) AND 
      base.id         = ponta_b.id_circuito (+) AND          
      base.ct_ponta_b = ponta_b.conta_servico (+);           


  V_MENSAGEM                   VARCHAR2(32000);
  E_GERAL                      EXCEPTION;
  
  WDIRSAIDA                    VARCHAR2(120);
  WARQSAIDA                    VARCHAR2(120);
  HARQSAIDA                    UTL_FILE.FILE_TYPE;
  
  V_NOME_CLIENTE_A             ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NOME_CLIENTE%TYPE;
  V_CNPJ_A                     VARCHAR2(60);
  V_TIPO_SERVICO_A             ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.TIPO_SERVICO%TYPE;
  V_CIDADE_A                   ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CIDADE%TYPE;
  V_UF_A                       ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.UF%TYPE;
  V_DESIGNADOR_A               ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESIGNADOR%TYPE;
  V_CONTA_COBRANCA_A           ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_COBRANCA%TYPE;
  V_DATA_ATIVACAO_A            ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_ATIVACAO%TYPE;
  V_DATA_iNATIVACAO_A          ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_INATIVACAO%TYPE;
  V_ENDERECO_INSTALACAO_A      ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ENDERECO_INSTALACAO%TYPE;
  V_NRO_NOTA_FISCAL_A          ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_NOTA_FISCAL%TYPE;
  V_CICLO_A                    ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CICLO%TYPE;
  V_EMISSAO_FATURA_A           ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.EMISSAO_FATURA%TYPE;
  V_TAXA_INSTALACAO_A          NUMBER;
  V_VL_ENCARGOS_A              NUMBER;

  V_NOME_CLIENTE_B             ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NOME_CLIENTE%TYPE;
  V_CNPJ_B                     ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CNPJ%TYPE;
  V_TIPO_SERVICO_B             ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.TIPO_SERVICO%TYPE;
  V_CIDADE_B                   ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CIDADE%TYPE;
  V_UF_B                       ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.UF%TYPE;
  V_DESIGNADOR_B               ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESIGNADOR%TYPE;
  V_CONTA_COBRANCA_B           ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_COBRANCA%TYPE;
  V_DATA_ATIVACAO_B            ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_ATIVACAO%TYPE;
  V_DATA_iNATIVACAO_B          ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_INATIVACAO%TYPE;
  V_ENDERECO_INSTALACAO_B      ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ENDERECO_INSTALACAO%TYPE;
  V_NRO_NOTA_FISCAL_B          ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_NOTA_FISCAL%TYPE;
  V_CICLO_B                    ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CICLO%TYPE;
  V_EMISSAO_FATURA_B           ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.EMISSAO_FATURA%TYPE;
  V_TAXA_INSTALACAO_B          NUMBER;
  V_VL_ENCARGOS_B              NUMBER;
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  PROCEDURE GRAVA_PARAMETRO IS
  
  BEGIN
      
    BEGIN
      INSERT INTO ARBORGVT_BILLING.GVT_EXEC_ARG
      VALUES (SQ_GVT_EXEC_ARG.NEXTVAL,
              'CARRIERTIM',
              'FAT_CARRIER_TIM_'||V_CICLO||'_'||V_MES_REF,
              'S'
              );
    EXCEPTION
      WHEN OTHERS THEN
        V_MENSAGEM := 'Erro ao inserir dados de parâmetro de execução do processo pela primeira vez. Erro: '||SQLERRM;
        RAISE E_GERAL;
    END;
  
    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      V_MENSAGEM := '[GRAVA_PARAMENTRO] - Erro ao gravar parâmetro de execução do processo. Erro: '||SQLERRM;
      RAISE E_GERAL;      
  END;
  ----------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------------------------------------------------------
  PROCEDURE GRAVA_CABECALHO IS
    V_DS_CABECALHO          VARCHAR2(32000);
  BEGIN
    V_DS_CABECALHO   := 'NOME DO CLIENTE' ||';'||
                        'CNPJ DO CLIENTE' ||';'||
                        'SERVICO PONTA A' ||';'||
                        'CIDADE PONTA A'  ||';'||
                        'UF PONTA A' ||';'||
                        'ALÍQUOTA ICMS PONTA A' ||';'||
                        'DESIGNADOR ACESSO PONTA A' ||';'||
                        'CONTA COBRANCA A PONTA A' ||';'||
                        'CONTA SERVIÇO PONTA A' ||';'||
                        'DATA ATIVAÇÃO PONTA A' ||';'||
                        'DATA INATIVAÇÃO PONTA A' ||';'||
                        'ENDEREÇO DE INSTALAÇÃO DO SERVIÇO PONTA A' ||';'||
                        'Nº FATURA PONTA A' ||';'||
                        'Nº DA NOTA FISCAL PONTA A' ||';'||
                        'CICLO PONTA A' ||';'||
                        'PERÍODO DE APURAÇÃO PONTA A' ||';'||
                        'DATA DE EMISSÃO DA FATURA PONTA A' ||';'||
                        'SERVICO PONTA B' ||';'||
                        'CIDADE PONTA B' ||';'||
                        'UF PONTA B' ||';'||
                        'ALÍQUOTA ICMS PONTA B' ||';'||
                        'DESIGNADOR ACESSO PONTA B' ||';'||
                        'CONTA COBRANCA A PONTA B' ||';'||
                        'CONTA SERVIÇO PONTA B' ||';'||
                        'DATA ATIVAÇÃO PONTA B' ||';'||
                        'DATA INATIVAÇÃO PONTA B' ||';'||
                        'ENDEREÇO DE INSTALAÇÃO DO SERVIÇO PONTA B' ||';'||
                        'Nº DA FATURA PONTA B' ||';'||
                        'Nº DA NOTA FISCAL PONTA B' ||';'||
                        'CICLO PONTA B' ||';'||
                        'PERÍODO DE APURAÇÃO PONTA B' ||';'||
                        'DATA DE EMISSÃO DA FATURA PONTA B' ||';'||
                        'FATURAMENTO BRUTO PONTA A' ||';'||
                        'FATURAMENTO BRUTO PONTA B' ||';'||
                        'TAXA DE INSTALAÇÃO' ||';'||
                        'ENCARGOS PONTA A' ||';'||
                        'ENCARGOS PONTA B' ||';'||
                        'DECONTO ICMS PONTA A' ||';'||
                        'DECONTO ICMS PONTA B' ||';'||
                        'AJUSTES PONTA A' ||';'||
                        'AJUSTES PONTA B' ||';'||
                        'PIS COFINS PONTA A' ||';'||
                        'PIS COFINS PONTA B' ||';'||
                        'VALOR ICMS PONTA A' ||';'||
                        'VALOR ICMS PONTA B';
    
    -- Imprime Cabeçalho
    UTL_FILE.PUT_LINE(HARQSAIDA,V_DS_CABECALHO);
    
  EXCEPTION
    WHEN UTL_FILE.WRITE_ERROR THEN
      V_MENSAGEM := '[GRAVA_CABECALHO] - UTL_FILE.WRITE_ERROR. Erro ao gravar: '||SQLERRM;
      RAISE E_GERAL;
    WHEN UTL_FILE.INVALID_OPERATION THEN
      V_MENSAGEM := '[GRAVA_CABECALHO] - UTL_FILE.INVALID_OPERATION. Erro de operação inválida: '||SQLERRM;
      RAISE E_GERAL;
  END;
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------            
  PROCEDURE GRAVA_DETALHE (I_NOME_CLIENTE             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NOME_CLIENTE%TYPE,       
                           I_CNPJ_CLIENTE             IN VARCHAR2,
                           I_SERVICO_A                IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.TIPO_SERVICO%TYPE,
                           I_CIDADE_A                 IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CIDADE%TYPE,
                           I_UF_A                     IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.UF%TYPE,
                           I_ALIQ_ICMS_A              IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ALIQUOTA_ICMS%TYPE,
                           I_DESIGNADOR_A             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESIGNADOR%TYPE,
                           I_CONTA_COBRANCA_A         IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_COBRANCA%TYPE,
                           I_CONTA_SERVICO_A          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_SERVICO%TYPE,
                           I_DT_ATIVACAO_A            IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_ATIVACAO%TYPE,
                           I_DT_INATIVACAO_A          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_INATIVACAO%TYPE,
                           I_ENDERECO_A               IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ENDERECO_INSTALACAO%TYPE,
                           I_NRO_FATURA_A             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_NOTA_FISCAL%TYPE,
                           I_NRO_NOTA_FISCAL_A        IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_NOTA_FISCAL%TYPE,
                           I_CICLO_A                  IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CICLO%TYPE,
                           I_PERIODO_APURACAO_A       IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.PERIODO_APURACAO%TYPE,
                           I_DT_EMISSAO_FATURA_A      IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.EMISSAO_FATURA%TYPE,
                           I_SERVICO_B                IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.TIPO_SERVICO%TYPE,
                           I_CIDADE_B                 IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CIDADE%TYPE,
                           I_UF_B                     IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.UF%TYPE,
                           I_ALIQ_ICMS_B              IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ALIQUOTA_ICMS%TYPE,
                           I_DESIGNADOR_B             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESIGNADOR%TYPE,
                           I_CONTA_COBRANCA_B         IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_COBRANCA%TYPE,
                           I_CONTA_SERVICO_B          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_SERVICO%TYPE,
                           I_DT_ATIVACAO_B            IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_ATIVACAO%TYPE,
                           I_DT_INATIVACAO_B          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DATA_INATIVACAO%TYPE,
                           I_ENDERECO_B               IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ENDERECO_INSTALACAO%TYPE,
                           I_NRO_FATURA_B             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_FATURA%TYPE,
                           I_NRO_NOTA_FISCAL_B        IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_NOTA_FISCAL%TYPE,
                           I_CICLO_B                  IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CICLO%TYPE,
                           I_PERIODO_APURACAO_B       IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.PERIODO_APURACAO%TYPE,
                           I_DT_EMISSAO_FATURA_B      IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.EMISSAO_FATURA%TYPE,
                           I_FATURAMENTO_BRUTO_A      IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.FATURAMENTO_BRUTO%TYPE,
                           I_FATURAMENTO_BRUTO_B      IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.FATURAMENTO_BRUTO%TYPE,
                           I_TAXA_INSTALACAO          IN NUMBER,
                           I_VL_ENCARGOS_A            IN NUMBER,
                           I_VL_ENCARGOS_B            IN NUMBER,
                           I_DESCONTO_ICMS_A          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESCONTOS%TYPE,
                           I_DESCONTO_ICMS_B          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESCONTOS%TYPE,
                           I_AJUSTES_A                IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.AJUSTES%TYPE,
                           I_AJUSTES_B                IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.AJUSTES%TYPE,
                           I_PIS_COFINS_A             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.PIS_COFINS%TYPE,
                           I_PIS_COFINS_B             IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.PIS_COFINS%TYPE,
                           I_ICMS_A                   IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ICMS%TYPE,
                           I_ICMS_B                   IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ICMS%TYPE) IS
  
  BEGIN
    
    UTL_FILE.PUT_LINE(HARQSAIDA, I_NOME_CLIENTE        ||';'||
                                 TRIM(I_CNPJ_CLIENTE)  ||';'||
                                 I_SERVICO_A           ||';'||
                                 I_CIDADE_A            ||';'||
                                 TRIM(I_UF_A)          ||';'||
                                 I_ALIQ_ICMS_A         ||';'||
                                 I_DESIGNADOR_A        ||';'||
                                 I_CONTA_COBRANCA_A    ||';'||
                                 I_CONTA_SERVICO_A     ||';'||
                                 TO_CHAR(I_DT_ATIVACAO_A, 'DD/MM/YYYY') ||';'||
                                 TO_CHAR(I_DT_INATIVACAO_A, 'DD/MM/YYYY') ||';'||
                                 I_ENDERECO_A          ||';'||
                                 I_NRO_FATURA_A        ||';'||
                                 TRIM(I_NRO_NOTA_FISCAL_A) ||';'||
                                 I_CICLO_A             ||';'||
                                 I_PERIODO_APURACAO_A  ||';'||
                                 TO_CHAR(I_DT_EMISSAO_FATURA_A, 'DD/MM/YYYY') ||';'||
                                 I_SERVICO_B           ||';'||
                                 I_CIDADE_B            ||';'||
                                 TRIM(I_UF_B)          ||';'||
                                 I_ALIQ_ICMS_B         ||';'||
                                 I_DESIGNADOR_B        ||';'||
                                 I_CONTA_COBRANCA_B    ||';'||
                                 I_CONTA_SERVICO_B     ||';'||
                                 TO_CHAR(I_DT_ATIVACAO_B, 'DD/MM/YYYY') ||';'||
                                 TO_CHAR(I_DT_INATIVACAO_B, 'DD/MM/YYYY') ||';'||
                                 I_ENDERECO_B          ||';'||
                                 I_NRO_FATURA_B        ||';'||
                                 TRIM(I_NRO_NOTA_FISCAL_B) ||';'||
                                 I_CICLO_B             ||';'||
                                 I_PERIODO_APURACAO_B  ||';'||
                                 TO_CHAR(I_DT_EMISSAO_FATURA_B, 'DD/MM/YYYY') ||';'||
                                 TO_CHAR(I_FATURAMENTO_BRUTO_A, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_FATURAMENTO_BRUTO_B, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_TAXA_INSTALACAO, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||    
                                 TO_CHAR(I_VL_ENCARGOS_A, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_VL_ENCARGOS_B, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_DESCONTO_ICMS_A, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_DESCONTO_ICMS_B, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_AJUSTES_A, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_AJUSTES_B, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_PIS_COFINS_A, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_PIS_COFINS_B, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_ICMS_A, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.''') ||';'||
                                 TO_CHAR(I_ICMS_B, 'FM9G999G999G990D00', 'NLS_NUMERIC_CHARACTERS = '',.'''));
      
  EXCEPTION
    WHEN UTL_FILE.WRITE_ERROR THEN
      V_MENSAGEM := '[GRAVA_DETALHE] - UTL_FILE.WRITE_ERROR. Erro ao gravar: '||SQLERRM;
      RAISE E_GERAL;
    WHEN UTL_FILE.INVALID_OPERATION THEN
      V_MENSAGEM := '[GRAVA_DETALHE] - UTL_FILE.INVALID_OPERATION. Erro de operação inválida: '||SQLERRM;
      RAISE E_GERAL;
  END;
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  PROCEDURE RETORNA_DADOS_PONTAS (I_ID_CIRCUITO          IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.ID_CIRCUITO%TYPE,
                                  I_NRO_FATURA           IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_FATURA%TYPE,
                                  I_CONTA_SERVICO        IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_SERVICO%TYPE,
                                  O_NOME_CLIENTE         OUT VARCHAR2,
                                  O_CNPJ                 OUT VARCHAR2,
                                  O_TIPO_SERVICO         OUT VARCHAR2,
                                  O_CIDADE               OUT VARCHAR2,
                                  O_UF                   OUT VARCHAR2,
                                  O_DESIGNADOR           OUT VARCHAR2,
                                  O_CONTA_COBRANCA       OUT NUMBER,
                                  O_DATA_ATIVACAO        OUT DATE,
                                  O_DATA_INATIVACAO      OUT DATE,
                                  O_ENDERECO_INSTALACAO  OUT VARCHAR2,
                                  O_NRO_NOTA_FISCAL      OUT VARCHAR2,
                                  O_CICLO                OUT VARCHAR2,
                                  O_EMISSAO_FATURA       OUT DATE) IS
                                  
  BEGIN
     
    BEGIN
      SELECT NOME_CLIENTE,
             CNPJ,
             TIPO_SERVICO,
             CIDADE,
             UF,
             DESIGNADOR,
             CONTA_COBRANCA,
             DATA_ATIVACAO,
             DATA_INATIVACAO,
             REPLACE(ENDERECO_INSTALACAO, ';', ',') ENDERECO_INSTALACAO,
             NRO_NOTA_FISCAL,
             CICLO,
             EMISSAO_FATURA
        INTO O_NOME_CLIENTE,
             O_CNPJ,
             O_TIPO_SERVICO,
             O_CIDADE,
             O_UF,
             O_DESIGNADOR,
             O_CONTA_COBRANCA,
             O_DATA_ATIVACAO,
             O_DATA_INATIVACAO,
             O_ENDERECO_INSTALACAO,
             O_NRO_NOTA_FISCAL,
             O_CICLO,
             O_EMISSAO_FATURA
        FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS a
       WHERE ELEMENT_ID IN (11778, 11500, 11550)
         AND EMISSAO_FATURA = V_DT_EMISSAO
         AND CICLO          = V_CICLO
         AND ID_CIRCUITO    = I_ID_CIRCUITO
         AND NRO_FATURA     = I_NRO_FATURA
         AND CONTA_SERVICO  = I_CONTA_SERVICO
      GROUP BY NOME_CLIENTE,
               CNPJ,
               TIPO_SERVICO,
               CIDADE,
               UF,
               DESIGNADOR,
               CONTA_COBRANCA,
               DATA_ATIVACAO,
               DATA_INATIVACAO,
               REPLACE(ENDERECO_INSTALACAO, ';', ','),
               NRO_NOTA_FISCAL,
               CICLO,
               EMISSAO_FATURA;               
    EXCEPTION
      WHEN NO_DATA_FOUND THEN        
          /* Tenta buscar alternativamente o designador do Serviço */
        BEGIN
          SELECT NOME_CLIENTE,
                 CNPJ,
                 TIPO_SERVICO,
                 CIDADE,
                 UF,
                 DESIGNADOR,
                 CONTA_COBRANCA,
                 DATA_ATIVACAO,
                 DATA_INATIVACAO,
                 REPLACE(ENDERECO_INSTALACAO, ';', ',') ENDERECO_INSTALACAO,
                 NRO_NOTA_FISCAL,
                 CICLO,
                 EMISSAO_FATURA
            INTO O_NOME_CLIENTE,
                 O_CNPJ,
                 O_TIPO_SERVICO,
                 O_CIDADE,
                 O_UF,
                 O_DESIGNADOR,
                 O_CONTA_COBRANCA,
                 O_DATA_ATIVACAO,
                 O_DATA_iNATIVACAO,
                 O_ENDERECO_INSTALACAO,
                 O_NRO_NOTA_FISCAL,
                 O_CICLO,
                 O_EMISSAO_FATURA
            FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS a
           WHERE ELEMENT_ID IN (11769)
             AND EMISSAO_FATURA = V_DT_EMISSAO
             AND CICLO          = V_CICLO
             AND ID_CIRCUITO    = I_ID_CIRCUITO
             AND NRO_FATURA     = I_NRO_FATURA
             AND CONTA_SERVICO  = I_CONTA_SERVICO
          GROUP BY NOME_CLIENTE,
                   CNPJ,
                   TIPO_SERVICO,
                   CIDADE,
                   UF,
                   DESIGNADOR,
                   CONTA_COBRANCA,
                   DATA_ATIVACAO,
                   DATA_INATIVACAO,
                   REPLACE(ENDERECO_INSTALACAO, ';', ','),
                   NRO_NOTA_FISCAL,
                   CICLO,
                   EMISSAO_FATURA;                   
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --DBMS_OUTPUT.put_line ('DADOS NÃO ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')');
            V_MENSAGEM := '[NO_DATA_FOUND] DADOS NÃO ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')';
            RAISE E_GERAL;
          WHEN TOO_MANY_ROWS THEN
            --DBMS_OUTPUT.put_line ('VÁRIOS DADOS ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')');      
            V_MENSAGEM := '[NO_DATA_FOUND] VÁRIOS DADOS ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')';
            RAISE E_GERAL;
          WHEN OTHERS THEN
            --DBMS_OUTPUT.put_line ('ERRO AO PESQUISAR DADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||'). Erro: '||SQLERRM);
            V_MENSAGEM := '[NO_DATA_FOUND] ERRO AO PESQUISAR DADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||'). Erro: '||SQLERRM;
            RAISE E_GERAL;
        END;
        
      WHEN TOO_MANY_ROWS THEN
        /* Adicionado em 22/02/2011 por Rodrigo Zago */
        BEGIN
          SELECT NOME_CLIENTE,
                 CNPJ,
                 TIPO_SERVICO,
                 CIDADE,
                 UF,
                 DESIGNADOR,
                 CONTA_COBRANCA,
                 DATA_ATIVACAO,
                 DATA_INATIVACAO,
                 REPLACE(ENDERECO_INSTALACAO, ';', ',') ENDERECO_INSTALACAO,
                 NRO_NOTA_FISCAL,
                 CICLO,
                 EMISSAO_FATURA
            INTO O_NOME_CLIENTE,
                 O_CNPJ,
                 O_TIPO_SERVICO,
                 O_CIDADE,
                 O_UF,
                 O_DESIGNADOR,
                 O_CONTA_COBRANCA,
                 O_DATA_ATIVACAO,
                 O_DATA_INATIVACAO,
                 O_ENDERECO_INSTALACAO,
                 O_NRO_NOTA_FISCAL,
                 O_CICLO,
                 O_EMISSAO_FATURA
            FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS a
           WHERE ELEMENT_ID IN (11778, 11500, 11550)
             AND EMISSAO_FATURA = V_DT_EMISSAO
             AND CICLO          = V_CICLO
             AND ID_CIRCUITO    = I_ID_CIRCUITO
             AND NRO_FATURA     = I_NRO_FATURA
             AND CONTA_SERVICO  = I_CONTA_SERVICO
             AND UPPER(TIPO_SERVICO) LIKE '%ACESSO%'
          GROUP BY NOME_CLIENTE,
                   CNPJ,
                   TIPO_SERVICO,
                   CIDADE,
                   UF,
                   DESIGNADOR,
                   CONTA_COBRANCA,
                   DATA_ATIVACAO,
                   DATA_INATIVACAO,
                   REPLACE(ENDERECO_INSTALACAO, ';', ','),
                   NRO_NOTA_FISCAL,
                   CICLO,
                   EMISSAO_FATURA;  
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            --DBMS_OUTPUT.put_line ('DADOS NÃO ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')');
            V_MENSAGEM := '[TOO_MANY_ROWS] DADOS NÃO ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')';
            RAISE E_GERAL;
          WHEN TOO_MANY_ROWS THEN
            --DBMS_OUTPUT.put_line ('VÁRIOS DADOS ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')');      
            V_MENSAGEM := '[TOO_MANY_ROWS] VÁRIOS DADOS ENCONTRADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||')';
            RAISE E_GERAL;
          WHEN OTHERS THEN
            --DBMS_OUTPUT.put_line ('ERRO AO PESQUISAR DADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||'). Erro: '||SQLERRM);
            V_MENSAGEM := '[TOO_MANY_ROWS] ERRO AO PESQUISAR DADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||'). Erro: '||SQLERRM;
            RAISE E_GERAL;
        END;
            
      WHEN OTHERS THEN
        --DBMS_OUTPUT.put_line ('ERRO AO PESQUISAR DADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||'). Erro: '||SQLERRM);
        V_MENSAGEM := '[OTHERS] ERRO AO PESQUISAR DADOS PARA FATURA ('||I_NRO_FATURA||'), CIRCUITO ('||I_ID_CIRCUITO||') E CONTA SERVICO ('||I_CONTA_SERVICO||'). Erro: '||SQLERRM;
        RAISE E_GERAL;
    END;
  
  END;
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------  
  FUNCTION RETORNA_TAXA_INSTALACAO (I_CONTA_COBRANCA       IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.CONTA_COBRANCA%TYPE,
                                    I_NRO_FATURA           IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_FATURA%TYPE,
                                    I_DESIGNADOR           IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.DESIGNADOR%TYPE) RETURN NUMBER IS
    V_VL_TAXA      NUMBER := 0;
  
  BEGIN
  
    BEGIN
      SELECT NVL(SUM(N.RATE / 100), 0)
        INTO V_VL_TAXA
        FROM NRC N, 
             NRC_KEY NK,
             CUSTOMER_ID_ACCT_MAP E, 
             CUSTOMER_ID_EQUIP_MAP M
       WHERE E.ACCOUNT_NO = N.BILLING_ACCOUNT_NO
	       AND N.TRACKING_ID      = NK.TRACKING_ID
         AND N.TRACKING_ID_SERV = NK.TRACKING_ID_SERV
         AND E.EXTERNAL_ID      = I_CONTA_COBRANCA
         AND E.EXTERNAL_ID_TYPE = 1
         AND NK.BILL_REF_NO     = I_NRO_FATURA
         AND M.EXTERNAL_ID      = I_DESIGNADOR
         AND M.EXTERNAL_ID_TYPE = 1
         AND M.SUBSCR_NO        = N.PARENT_SUBSCR_NO
         /* Em princípio todas as nrc's que foram encontradas na tabela GVT_RELATORIO_CIRCUITO_DADOS estão sendo consideradas */
         AND N.TYPE_ID_NRC IN (12031,
                               12157,
                               12159,
                               12194,
                               12550,
                               12551,
                               12660,
                               12661,
                               12690,
                               12704,
                               12722,
                               12723,
                               12758);       
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VL_TAXA := 0;
      WHEN OTHERS THEN 
        V_VL_TAXA := 0;
    END;
  
    RETURN V_VL_TAXA;
  
  END;
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------                                   
  FUNCTION RETORNA_VL_ENCARGOS (I_NRO_FATURA         IN ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS.NRO_FATURA%TYPE) RETURN NUMBER IS
    V_VL_ENCARGOS      NUMBER := 0;
  BEGIN
    
    BEGIN
      SELECT NVL(SUM(AMOUNT) / 100, 0)
        INTO V_VL_ENCARGOS
        FROM BILL_INVOICE A,
             BILL_INVOICE_DETAIL B
       WHERE A.BILL_REF_NO = B.BILL_REF_NO
         AND A.BILL_REF_RESETS = B.BILL_REF_RESETS
         AND A.BILL_REF_NO     = I_NRO_FATURA
         AND B.TYPE_CODE = 3
         AND B.OPEN_ITEM_ID IN (2, 3);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_VL_ENCARGOS := 0;
      WHEN OTHERS THEN 
        V_VL_ENCARGOS := 0;
    END;
  
    RETURN V_VL_ENCARGOS;
  
  END;
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------------  
BEGIN
  
  WDIRSAIDA    := '&1';
  V_CICLO      := '&2';
  
  BEGIN
    SELECT ADD_MONTHS(BC.CUTOFF_DATE, -1) DT_INICIO, 
           (BC.CUTOFF_DATE -1) DT_FIM,
           CUTOFF_DATE,
           TO_CHAR(BC.PPDD_DATE, 'MMYYYY') MES_VENCIMENTO
      INTO V_DT_INICIO,
           V_DT_FIM,
           V_DT_EMISSAO,
           V_MES_REF
      FROM BILL_CYCLE BC
     WHERE BC.BILL_PERIOD = V_CICLO
       AND BC.BILL_PERIOD LIKE 'M%'
       AND BC.CUTOFF_DATE = (SELECT MAX(B.CUTOFF_DATE)
                               FROM BILL_CYCLE B
                              WHERE B.BILL_PERIOD = BC.BILL_PERIOD
                                AND B.CUTOFF_DATE <= SYSDATE
                                AND B.BILL_PERIOD LIKE 'M%');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_MENSAGEM := 'Período de Apuração não encontrado para o ciclo ('||V_CICLO||').';
      RAISE E_GERAL;
    WHEN OTHERS THEN
      V_MENSAGEM := 'Erro ao pesquisar Período de Apuração para o ciclo ('||V_CICLO||'). Erro: '||SQLERRM;
      RAISE E_GERAL;
  END;
  
  /* Select adicionado para assegurar de que será utilizado a última data de emissão gravada na tabela */
FOR OPER IN cnpj LOOP
  BEGIN
    SELECT MAX(A.EMISSAO_FATURA)
      INTO V_DT_EMISSAO
      FROM ARBORGVT_BILLING.GVT_RELATORIO_CIRCUITO_DADOS A
     WHERE SUBSTR(CNPJ, 1, 8) = OPER.CNPJ
       AND CICLO          = V_CICLO
       HAVING MAX(TRUNC(A.EMISSAO_FATURA)) <= TRUNC(SYSDATE);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_MENSAGEM := 'Última data de emissão não encontrada para o ciclo ('||V_CICLO||').';
      RAISE E_GERAL;
    WHEN OTHERS THEN
      V_MENSAGEM := 'Erro ao pesquisar última data de emissão para o ciclo ('||V_CICLO||'). Erro: '||SQLERRM;
      RAISE E_GERAL;
  END;
  
  
  V_PERIODO_APURACAO := TO_CHAR(V_DT_INICIO, 'DD/MM/YYYY') ||' A '||TO_CHAR(V_DT_FIM, 'DD/MM/YYYY');
    
  DBMS_OUTPUT.PUT_LINE ('Início de execução do processo: '||TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));

  -- Nome do arquivo de saída
  WARQSAIDA  := 'FAT_CARRIER_'||OPER.OPERADORA||'_'||V_CICLO||'_'||V_MES_REF||'.TXT';

  -- Abre o arquivo para começar a gravar as linhas
  HARQSAIDA  := UTL_FILE.FOPEN(WDIRSAIDA,WARQSAIDA,'W');
  
  -- Grava o cabeçalho
  GRAVA_CABECALHO;

  FOR H IN FATURAS_CICLO(OPER.CNPJ) LOOP
  
    FOR I IN DADOS_CARRIER (H.NRO_FATURA, OPER.CNPJ, H.DATA_GERACAO) LOOP
      
      /* Reseta variáveis a cada iteração */
      V_NOME_CLIENTE_A          := NULL;
      V_CNPJ_A                  := NULL;
      V_TIPO_SERVICO_A          := NULL;
      V_CIDADE_A                := NULL;
      V_UF_A                    := NULL;
      V_DESIGNADOR_A            := NULL;
      V_CONTA_COBRANCA_A        := NULL;
      V_DATA_ATIVACAO_A         := NULL;
      V_DATA_INATIVACAO_A       := NULL;
      V_ENDERECO_INSTALACAO_A   := NULL;
      V_NRO_NOTA_FISCAL_A       := NULL;
      V_CICLO_A                 := NULL;
      V_EMISSAO_FATURA_A        := NULL;
      V_TAXA_INSTALACAO_A       := 0;
      V_VL_ENCARGOS_A           := 0;
      
      V_NOME_CLIENTE_B          := NULL;
      V_CNPJ_B                  := NULL;
      V_TIPO_SERVICO_B          := NULL;
      V_CIDADE_B                := NULL;
      V_UF_B                    := NULL;
      V_DESIGNADOR_B            := NULL;
      V_CONTA_COBRANCA_B        := NULL;
      V_DATA_ATIVACAO_B         := NULL;
      V_DATA_INATIVACAO_B       := NULL;
      V_ENDERECO_INSTALACAO_B   := NULL;
      V_NRO_NOTA_FISCAL_B       := NULL;
      V_CICLO_B                 := NULL;
      V_EMISSAO_FATURA_B        := NULL;
      V_TAXA_INSTALACAO_B       := 0;
      V_VL_ENCARGOS_B           := 0;
    
      --dbms_output.put_line (' ');
    
      /* BUSCA INFORMAÇÕES DA PONTA A */
      IF (I.ID_CIRCUITO_A IS NOT NULL) THEN
      
        RETORNA_DADOS_PONTAS (I.ID_CIRCUITO_A,          
                              I.NRO_FATURA_A,
                              I.CONTA_SERVICO_A,
                              V_NOME_CLIENTE_A,
                              V_CNPJ_A,
                              V_TIPO_SERVICO_A,
                              V_CIDADE_A,
                              V_UF_A,
                              V_DESIGNADOR_A,
                              V_CONTA_COBRANCA_A,
                              V_DATA_ATIVACAO_A,
                              V_DATA_INATIVACAO_A,
                              V_ENDERECO_INSTALACAO_A,
                              V_NRO_NOTA_FISCAL_A,
                              V_CICLO_A,
                              V_EMISSAO_FATURA_A);    
      
        V_TAXA_INSTALACAO_A := RETORNA_TAXA_INSTALACAO (V_CONTA_COBRANCA_A,
                                                        I.NRO_FATURA_A,
                                                        V_DESIGNADOR_A);
        
        --dbms_output.put_line ('V_TAXA_INSTALACAO_A: '||V_TAXA_INSTALACAO_A);
        
        V_VL_ENCARGOS_A := RETORNA_VL_ENCARGOS (I.NRO_FATURA_A);
        
        --dbms_output.put_line ('NRO_FATURA_A: '||I.NRO_FATURA_A);
        --dbms_output.put_line ('V_VL_ENCARGOS_A: '||V_VL_ENCARGOS_A);
        
      END IF;
      
      /* BUSCA INFORMAÇÕES DA PONTA B */
      IF (I.ID_CIRCUITO_B IS NOT NULL) THEN
      
        RETORNA_DADOS_PONTAS (I.ID_CIRCUITO_B,          
                              I.NRO_FATURA_B,
                              I.CONTA_SERVICO_B,
                              V_NOME_CLIENTE_B,
                              V_CNPJ_B,
                              V_TIPO_SERVICO_B,
                              V_CIDADE_B,
                              V_UF_B,
                              V_DESIGNADOR_B,
                              V_CONTA_COBRANCA_B,
                              V_DATA_ATIVACAO_B,
                              V_DATA_INATIVACAO_B,
                              V_ENDERECO_INSTALACAO_B,
                              V_NRO_NOTA_FISCAL_B,
                              V_CICLO_B,
                              V_EMISSAO_FATURA_B);    
      
        V_TAXA_INSTALACAO_B := RETORNA_TAXA_INSTALACAO (V_CONTA_COBRANCA_B,
                                                        I.NRO_FATURA_B,
                                                        V_DESIGNADOR_B);
        
        --dbms_output.put_line ('V_TAXA_INSTALACAO_B: '||V_TAXA_INSTALACAO_B);
        
        V_VL_ENCARGOS_B := RETORNA_VL_ENCARGOS (I.NRO_FATURA_B);
        
        --dbms_output.put_line ('NRO_FATURA_B: '||I.NRO_FATURA_B);
        --dbms_output.put_line ('V_VL_ENCARGOS_B: '||V_VL_ENCARGOS_B);
        
      END IF;
      
      GRAVA_DETALHE (V_NOME_CLIENTE_A,
                     V_CNPJ_A,
                     V_TIPO_SERVICO_A,
                     V_CIDADE_A,
                     V_UF_A,
                     I.ALIQ_ICMS_A,
                     V_DESIGNADOR_A,
                     V_CONTA_COBRANCA_A,
                     I.CONTA_SERVICO_A,
                     V_DATA_ATIVACAO_A,
                     V_DATA_INATIVACAO_A,
                     V_ENDERECO_INSTALACAO_A,
                     I.NRO_FATURA_A,
                     V_NRO_NOTA_FISCAL_A,
                     V_CICLO_A,
                     V_PERIODO_APURACAO, --I.PERIODO_APURACAO_A,
                     V_EMISSAO_FATURA_A,
                     V_TIPO_SERVICO_B,
                     V_CIDADE_B,
                     V_UF_B,
                     I.ALIQ_ICMS_B,
                     V_DESIGNADOR_B,
                     V_CONTA_COBRANCA_B,
                     I.CONTA_SERVICO_B,
                     V_DATA_ATIVACAO_B,
                     V_DATA_INATIVACAO_B,
                     V_ENDERECO_INSTALACAO_B,
                     I.NRO_FATURA_B,
                     V_NRO_NOTA_FISCAL_B,
                     V_CICLO_B,
                     V_PERIODO_APURACAO, --I.PERIODO_APURACAO_B,
                     V_EMISSAO_FATURA_B,
                     I.FATURAMENTO_BRUTO_A,
                     I.FATURAMENTO_BRUTO_B,
                     V_TAXA_INSTALACAO_A + V_TAXA_INSTALACAO_B, 
                     V_VL_ENCARGOS_A,
                     V_VL_ENCARGOS_B,   
                     I.DESCONTO_ICMS_A,
                     I.DESCONTO_ICMS_B,
                     I.AJUSTES_A,
                     I.AJUSTES_B,
                     I.PIS_COFINS_A,
                     I.PIS_COFINS_B,
                     I.ICMS_A,
                     I.ICMS_B);

    END LOOP;
  
  END LOOP;
  
  GRAVA_PARAMETRO;
  
  -- Fecha o arquivo gravado
  UTL_FILE.FCLOSE(HARQSAIDA);

  DBMS_OUTPUT.PUT_LINE ('Arquivo ('||WARQSAIDA||') gravado com sucesso em ('||WDIRSAIDA||').');
END LOOP;
  DBMS_OUTPUT.PUT_LINE ('Término de execução do processo: '||TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));

EXCEPTION
  WHEN E_GERAL THEN
    --DBMS_OUTPUT.PUT_LINE ('V_MENSAGEM: '||V_MENSAGEM);
    RAISE_APPLICATION_ERROR(-20033, 'V_MENSAGEM: ' || V_MENSAGEM, TRUE);
    ROLLBACK;
  WHEN OTHERS THEN
    --DBMS_OUTPUT.PUT_LINE ('OTHERS: '||SQLERRM);
    RAISE_APPLICATION_ERROR(-20033, 'OTHERS: ' || SQLERRM, TRUE);
    ROLLBACK;
END;
/

SET SERVEROUT OFF;
SET FEED ON;

EXIT;
