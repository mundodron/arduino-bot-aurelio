 insert into G0009075SQL.bip_production select account_no, bill_period from bipp27
 
 select account_no, 
            BILL_LNAME,
            bill_period,
            ACCOUNT_CATEGORY,
            NO_BILL,
            CHG_DATE
   from cmf
  where cmf.account_no in (select account_no from G0009075SQL.bip_production
                       minus
                       select account_no from G0009075SQL.bip_proforma)
    AND UPPER(cmf.BILL_PERIOD) in (SELECT BILL_PERIOD FROM GVT_PROCESSAMENTO_CICLO WHERE PROCESSAMENTO = UPPER('P27'))
    
    
    select * from gvt_no_bill_audit where account_no = 2285090 order by created desc
    
    select * from gvt_log_cmf where account_no = 2285090 order by quando desc
        


select * from G0009075SQL.bip_production where bill_period = 'M10' 

select * from  G0009075SQL.bip_proforma where bill_period = 'M10' 

select 
(select count(*) from G0009075SQL.bip_production where bill_period = 'M10') 
-
(select  count(*) from  G0009075SQL.bip_proforma where bill_period = 'M10')
from dual
                       
select * from bipp23 where bill_period = 'M10' 


INSERT INTO G0009075SQL.bip_prodiction
(ACCOUNT_NO, BILL_PERIOD)
SELECT ACCOUNT_NO, BILL_PERIOD
FROM bipp27


select * from ARBORGVT_BILLING.GVT_CONTA_INTERNET where account_no in (Select account_no from g0010388sql.vrc_cdr_cob_zerado_2)

select * from bill_invoice where account_no = 2285090 order by prep_date desc


INSERT INTO G0009075SQL.bip_proforma
(ACCOUNT_NO, BILL_PERIOD)
SELECT ACCOUNT_NO, BILL_PERIOD
FROM bipp09


select * from gvt_conta_internet where data_processamento > sysdate -15 and bill_ref_no is not null order by 3 desc