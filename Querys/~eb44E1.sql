select count(*) from LEVANTAMENTO_SELECAO

select * from LEVANTAMENTO_SELECAO where proforma is null and production is not null

select count(1) from (
    select account_no, bill_period from G0009075SQL.bip_production
     union all
    select account_no, bill_period from G0009075SQL.bip_proforma)
    
    
   select tablespace_name, username, bytes, max_bytes 
from dba_ts_quotas
where username = 'G0023421SQL'