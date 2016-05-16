      SELECT DISTINCT (GCI.NOME_ARQUIVO) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (BI.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      BI.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      BI.BILL_REF_NO
                 FROM ARBORGVT_BILLING.GVT_CONTA_INTERNET GCI,
                      ARBOR.BILL_INVOICE BI
                WHERE BI.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                          FROM CUSTOMER_ID_ACCT_MAP
                                         WHERE EXTERNAL_ID = V_EXTERNAL_ID)
                  AND BI.ACCOUNT_NO = GCI.ACCOUNT_NO
                  AND BI.BILL_REF_NO = GCI.BILL_REF_NO
                  AND BI.PAYMENT_DUE_DATE > (SYSDATE - V_DIAS_PAYMENT_DUE_DATE)
             ORDER BY BI.PAYMENT_DUE_DATE DESC;



select * from
  GVT_CONTA_INTERNET A,
  cmf_balance B
where A.ACCOUNT_NO = B.ACCOUNT_NO
and B.bill_ref_no = 141811210;

