CREATE OR REPLACE PROCEDURE ARBORGVT_BILLING.gvt_sp_arq_conta_detalhada (
   v_external_id IN VARCHAR2,
   v_dias_payment_due_date IN NUMBER,
   cursor_conta_detalhada OUT gvt_tipo_cursor.cursortype,
   codigo_erro OUT NUMBER,
   mensagem OUT VARCHAR2
)
IS
   v_qtd                         NUMBER := 0;
BEGIN
   OPEN cursor_conta_detalhada FOR
      SELECT DISTINCT (gci.nome_arquivo) AS nome_arquivo,
                      TO_NUMBER (TO_CHAR (bi.payment_due_date, 'yyyymm')) AS mes,
                      bi.payment_due_date AS data_processamento,
                      bi.bill_ref_no
                 FROM arborgvt_billing.gvt_conta_internet gci,
                      arbor.bill_invoice bi
                WHERE bi.account_no IN (SELECT account_no
                                          FROM customer_id_acct_map
                                         WHERE external_id = v_external_id)
                  AND bi.account_no = gci.account_no
                  AND bi.bill_ref_no = gci.bill_ref_no
                  AND bi.payment_due_date > (SYSDATE - v_dias_payment_due_date)
             ORDER BY bi.payment_due_date DESC;

   SELECT   COUNT (1)
       INTO v_qtd
       FROM arborgvt_billing.gvt_conta_internet gci,
            arbor.bill_invoice bi
      WHERE bi.account_no IN (SELECT account_no
                                FROM customer_id_acct_map
                               WHERE external_id = v_external_id)
        AND bi.account_no = gci.account_no
        AND bi.bill_ref_no = gci.bill_ref_no
        AND bi.payment_due_date > (SYSDATE - v_dias_payment_due_date)
   ORDER BY bi.payment_due_date DESC;

   IF v_qtd = 0
   THEN
      codigo_erro                := -1;
      mensagem                   := 'EXTERNAL_ID NÃO ENCONTRADO OU SEM DADOS';
   ELSE
      codigo_erro                := 0;
      mensagem                   := NULL;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
/*    Retorna MENSAGEM de EXTERNAL_ID NÃO ENCONTRADO*/
      codigo_erro                := -1;
      mensagem                   := 'EXTERNAL_ID NÃO ENCONTRADO OU SEM DADOS';
   WHEN OTHERS
   THEN
/*    Retorna MENSAGEM de ERRO*/
      codigo_erro                := -99;
      mensagem                   := 'ERRO NA BUSCA DO EXTERNAL_ID ->' || TO_CHAR (SQLCODE) || '-' || SQLERRM;
END;
/
