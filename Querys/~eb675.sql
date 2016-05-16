drop table limpa_CDC

create table limpa_CDC as 
select EXTERNAL_ID, account_no, bill_ref_No from backlog_cdc where bill_ref_no in (
SELECT 
       BI.BILL_REF_NO
  FROM ARBORGVT_BILLING.GVT_CONTA_INTERNET GCI,
       ARBOR.BILL_INVOICE BI
 WHERE BI.ACCOUNT_NO IN (SELECT ACCOUNT_NO
                           FROM CUSTOMER_ID_ACCT_MAP
                          WHERE 1=1) --EXTERNAL_ID in (select EXTERNAL_ID from backlog_cdc))
   AND BI.ACCOUNT_NO = GCI.ACCOUNT_NO
   AND BI.BILL_REF_NO = GCI.BILL_REF_NO
   AND BI.PAYMENT_DUE_DATE > (SYSDATE - 90))
   
   delete from backARQlog_cdc where bill_ref_no not in (select bill_ref_no from limpa_CDC)
   
   select * from backlog_cdc where bill_ref_no in (select bill_ref_no from limpa_CDC)
   
   select * from gvt_conta_internet where bill_ref_no = 307551502
   
     select * from gvt_conta_internet where NOME_ARQUIVO = 'Janeiro/6/2016Janeiro899995631706_250.cdc' and account_no = 10764227
     
     select * from backlog_cdc where ARQ = 'Janeiro/6/2016Janeiro899995631706_250.cdc'
     
     select * from gvt_conta_internet where NOME_ARQUIVO = 'Janeiro/6/2016Janeiro899995631706_250.cdc' and account_no = 10764227
     
     
     ALTER TABLE G0023421SQL.BACKLOG_CDC ADD (ARQ_old VARCHAR2(150 BYTE));
     
     