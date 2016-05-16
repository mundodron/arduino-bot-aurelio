
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

select * from GVT_CONTA_INTERNET where nome_arquivo is not null order by 3 desc 

select bill_ref_no from BILL_INVOICE_DETAIL_BK

select * from bill_invoice where bill_ref_no in (select bill_ref_no from BILL_INVOICE_DETAIL_BK) and FORMAT_STATUS = 2

select 445 + 525 from dual

update BILL_INVOICE_DETAIL_BK set BILL_REF_NO = 0 

select bill_ref_no from BILL_INVOICE_DETAIL_BK

select * from customer_care where numero_fatura in (select '0' || (select bill_ref_no from BILL_INVOICE_DETAIL_BK) || '-0' from dual)

 select * from ARBOR.BILL_DISP_METH_VALUES where language_code = 2
 
 select * from bill_fmt_opt_values
 

select * from customer_id_acct_map where external_id = '999982713210'

select contact1_phone from cmf where account_no = 4610803

select * from gvt_layout_faturas_corp where account_no = 4610803


SELECT G1.account_no ACCOUNT_NO, G1.cnpj CNPJ, to_char(NULL) MENSAGEM, to_char(NULL) NUM_CONTRATO, flag
                FROM GVT_LAYOUT_FATURAS_CORP G1
               WHERE G1.account_no = 4610803
                 AND G1.data_exclusao is null
                 AND G1.flag = 1