
INSERT INTO G0009075SQL.bip_production
(ACCOUNT_NO, BILL_PERIOD)
SELECT ACCOUNT_NO, BILL_PERIOD
FROM bipp09


INSERT INTO G0009075SQL.bip_proforma
(ACCOUNT_NO, BILL_PERIOD)
SELECT ACCOUNT_NO, BILL_PERIOD
FROM bipp09

select count(*) from G0009075SQL.bip_production where UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P09')) 

select count(*) from  G0009075SQL.bip_proforma where UPPER(BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P09')) 

select 
(select 608563 + 632897 proforoma from dual)  --1241460
- 
(select 612695 + 638330 production from dual) --1251025
from dual


select * from all_tables where table_name like '%INTERNET%'


select * from GVT_CONTA_INTERNET

select * from GVT_CONTA_INTERNET where nome_arquivo is not null and bill_ref_no is not null order by 3 desc


select count(*) from bill_invoice where bill_ref_no in (select bill_ref_no from BILL_INVOICE_DETAIL_BK) and FORMAT_STATUS = 2 

select external_id, version_feed, active_date from gvt_febraban_accounts where inactive_date is null
and external_id in (select external_id from customer_id_acct_map where INACTIVE_DATE is null and external_id_type = 1)

select * from gvt_conta_internet where data_processamento > sysdate -20 and bill_ref_no is not null order by 3 desc
