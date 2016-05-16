CREATE OR REPLACE PROCEDURE ARBORGVT_BILLING.GVT_SP_ARQUIVO_FEBRABAN (
   V_EXTERNAL_ID IN VARCHAR2,
   V_DIAS_PAYMENT_DUE_DATE IN NUMBER,
   CURSOR_CONTA_DETALHADA OUT GVT_TIPO_CURSOR.CURSORTYPE,
   CODIGO_ERRO OUT NUMBER,
   MENSAGEM OUT VARCHAR2
)
IS
 V_QTD               NUMBER := 0;

 BEGIN
      CODIGO_ERRO                := 0;
      MENSAGEM                   := NULL;
 OPEN CURSOR_CONTA_DETALHADA FOR
      SELECT DISTINCT (F.FILE_NAME) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (B.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      B.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      B.BILL_REF_NO
                 FROM ARBORGVT_BILLING.GVT_FBB_BILL_INVOICE F,
                      ARBOR.BILL_INVOICE B
                WHERE B.BILL_REF_NO = F.BILL_REF_NO
                  AND B.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                         FROM CUSTOMER_ID_ACCT_MAP
                                        WHERE EXTERNAL_ID = V_EXTERNAL_ID)
                  AND EXISTS (SELECT 1 --- cliente ainda tem que ter a opcao de febraban ativada nesta tabela, senao a SP retorna vazia, e o portal exibe CDC
                                FROM GVT_FEBRABAN_ACCOUNTS G
                               WHERE G.ACCOUNT_NO = B.ACCOUNT_NO)
                  AND B.PAYMENT_DUE_DATE > (SYSDATE - V_DIAS_PAYMENT_DUE_DATE)
      UNION
            SELECT DISTINCT (F.FILE_NAME) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (B.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      B.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      B.BILL_REF_NO
                 FROM GVT_FEBRABAN_BILL_INVOICE F,
                      ARBOR.BILL_INVOICE B
                WHERE B.BILL_REF_NO = F.BILL_REF_NO
                  AND B.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                         FROM CUSTOMER_ID_ACCT_MAP
                                        WHERE EXTERNAL_ID = V_EXTERNAL_ID)
                  AND EXISTS (SELECT 1 --- cliente ainda tem que ter a opcao de febraban ativada nesta tabela, senao a SP retorna vazia, e o portal exibe CDC
                                FROM GVT_FEBRABAN_ACCOUNTS G
                               WHERE G.ACCOUNT_NO = B.ACCOUNT_NO)
                  AND B.PAYMENT_DUE_DATE > (SYSDATE - V_DIAS_PAYMENT_DUE_DATE)             
      ORDER BY DATA_PROCESSAMENTO DESC;

      SELECT COUNT (1) 
       INTO V_QTD
       from (
      SELECT DISTINCT (F.FILE_NAME) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (B.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      B.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      B.BILL_REF_NO
                 FROM ARBORGVT_BILLING.GVT_FBB_BILL_INVOICE F,
                      ARBOR.BILL_INVOICE B
                WHERE B.BILL_REF_NO = F.BILL_REF_NO
                  AND B.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                         FROM CUSTOMER_ID_ACCT_MAP
                                        WHERE EXTERNAL_ID = V_EXTERNAL_ID)
                  AND EXISTS (SELECT 1 --- cliente ainda tem que ter a opcao de febraban ativada nesta tabela, senao a SP retorna vazia, e o portal exibe CDC
                                FROM GVT_FEBRABAN_ACCOUNTS G
                               WHERE G.ACCOUNT_NO = B.ACCOUNT_NO)
                  AND B.PAYMENT_DUE_DATE > (SYSDATE - V_DIAS_PAYMENT_DUE_DATE)
      UNION
            SELECT DISTINCT (F.FILE_NAME) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (B.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      B.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      B.BILL_REF_NO
                 FROM GVT_FEBRABAN_BILL_INVOICE F,
                      ARBOR.BILL_INVOICE B
                WHERE B.BILL_REF_NO = F.BILL_REF_NO
                  AND B.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                         FROM CUSTOMER_ID_ACCT_MAP
                                        WHERE EXTERNAL_ID = V_EXTERNAL_ID)
                  AND EXISTS (SELECT 1 --- cliente ainda tem que ter a opcao de febraban ativada nesta tabela, senao a SP retorna vazia, e o portal exibe CDC
                                FROM GVT_FEBRABAN_ACCOUNTS G
                               WHERE G.ACCOUNT_NO = B.ACCOUNT_NO)
                  AND B.PAYMENT_DUE_DATE > (SYSDATE - V_DIAS_PAYMENT_DUE_DATE));

   IF V_QTD = 0
   THEN
      CODIGO_ERRO                := -1;
      MENSAGEM                   := 'EXTERNAL_ID NÃO ENCONTRADO OU SEM DADOS';
   ELSE
      CODIGO_ERRO                := 0;
      MENSAGEM                   := NULL;
   END IF;

   EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
   /*    RETORNA MENSAGEM DE EXTERNAL_ID NÃO ENCONTRADO*/
      CODIGO_ERRO                := -1;
      MENSAGEM                   := 'EXTERNAL_ID NÃO ENCONTRADO OU SEM DADOS';
   WHEN OTHERS
   THEN
   /*    RETORNA MENSAGEM DE ERRO*/
      CODIGO_ERRO                := -99;
      MENSAGEM                   := 'ERRO NA BUSCA DO EXTERNAL_ID ->' || TO_CHAR (SQLCODE) || '-' || SQLERRM;
  END;
/