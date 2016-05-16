select count(*) from LEVANTAMENTO_SELECAO where proforma is null and production is not null

truncate table LEVANTAMENTO_SELECAO

select tablespace_name, username, bytes, max_bytes 
from dba_ts_quotas
where username = 'G0023421SQL';

select * from bill_invoice where bill_ref_no = 319674505

