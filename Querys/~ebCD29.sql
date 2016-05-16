      SELECT DISTINCT (GCI.NOME_ARQUIVO) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (BI.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      BI.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      BI.BILL_REF_NO
                 FROM GVT_CONTA_INTERNET GCI,
                      BILL_INVOICE BI
                WHERE BI.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                          FROM CUSTOMER_ID_ACCT_MAP
                                         WHERE EXTERNAL_ID = '999980014348')
                  AND BI.ACCOUNT_NO = GCI.ACCOUNT_NO
                  AND BI.BILL_REF_NO = GCI.BILL_REF_NO
                  --AND BI.PAYMENT_DUE_DATE > (SYSDATE - 20)
             ORDER BY BI.PAYMENT_DUE_DATE DESC;
             
select * from GVT_CONTA_INTERNET where account_no in (SELECT ACCOUNT_NO
                                          FROM CUSTOMER_ID_ACCT_MAP
                                         WHERE EXTERNAL_ID = '999980014348')
                                         
                                         
select * from gvt_liberacao_boleto order by chg_date asc