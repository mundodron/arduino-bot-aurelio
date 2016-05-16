      SELECT DISTINCT (GCI.NOME_ARQUIVO) AS NOME_ARQUIVO,
                      TO_NUMBER (TO_CHAR (BI.PAYMENT_DUE_DATE, 'YYYYMM')) AS MES,
                      BI.PAYMENT_DUE_DATE AS DATA_PROCESSAMENTO,
                      BI.BILL_REF_NO
                 FROM ARBORGVT_BILLING.GVT_CONTA_INTERNET GCI,
                      ARBOR.BILL_INVOICE BI
                WHERE BI.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                                          FROM cmf_balance
                                         WHERE bill_ref_no in (140209709))--,142867113,145828712,137367509,145797708,145797710,145797709))
                  AND BI.ACCOUNT_NO = GCI.ACCOUNT_NO
                  AND BI.BILL_REF_NO = GCI.BILL_REF_NO
                  --and trunc(GCI.DATA_PROCESSAMENTO) > trunc(sysdate - 90)
                  --AND BI.PAYMENT_DUE_DATE > (SYSDATE - 90)
             ORDER BY DATA_PROCESSAMENTO DESC;
          
             
 select * 
   from GVT_CONTA_INTERNET
  where account_no in (SELECT ACCOUNT_NO
                                          FROM cmf_balance
                                         WHERE bill_ref_no in (140209709))--,142867113,145828712,137367509,145797708,145797710,145797709))
  and DATA_PROCESSAMENTO > trunc(sysdate - 90)
                                         
                                         
  select * 
   from GVT_CONTA_INTERNET
  where account_no = 1729370
    and DATA_PROCESSAMENTO > trunc(sysdate - 90)
    
  select 
         account_no,
         external_id,
         bill_ref_no, 
         DATA_PROCESSAMENTO,
         NOME_ARQUIVO,
          1 as EXISTE_FATURA
 from dual
  

             
             
             