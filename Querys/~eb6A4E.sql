ALTER TABLE G0023421SQL.BACKLOG_CDC
ADD (ACCOUNT_CATEGORY NUMBER);

select processo, count(1) from backlog_cdc group by processo order by 1  


select ACCOUNT_NO,
       ACCOUNT_CATEGORY,
       Processo
from backlog_cdc


update backlog_cdc set PROCESSO = 1+ABS(MOD(dbms_random.random,100))

update backlog_cdc set ACCOUNT_CATEGORY = 10

select * from customer_id_acct_map where external_id = '999979685476'


select * from bill_invoice where account_no = 9193322 order by 2 desc

-- 327572123 -- 321774120