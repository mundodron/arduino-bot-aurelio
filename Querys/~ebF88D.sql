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
                                         
                                         
update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Maio/8/2013Maio999980014348_250.cdc' where ACCOUNT_NO = 7374426 and trunc(DATA_PROCESSAMENTO) = to_date('05/05/2013','dd/mm/yyyy');

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Abril/8/2013Abril999980014348_250.cdc' where ACCOUNT_NO = 7374426 and trunc(DATA_PROCESSAMENTO) = to_date('06/04/2013','dd/mm/yyyy');

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Marco/8/2013Marco999980014348_250.cdc' where ACCOUNT_NO = 7374426 and trunc(DATA_PROCESSAMENTO) = to_date('08/03/2013','dd/mm/yyyy');

commit;

update GVT_CONTA_INTERNET set EXTERNAL_ID = '999980014348', BILL_REF_NO = 136203174, EXISTE_FATURA = '1' where ACCOUNT_NO = 7374426 and NOME_ARQUIVO is not null;

commit;
