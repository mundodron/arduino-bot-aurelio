select count(1), processo from GVT_CONTAS_CONTAFACIL group by processo

INSERT INTO GVT_CONTAS_CONTAFACIL


select ACCOUNT_NO,
       10 ACCOUNT_CATEGORY,
       (1+ABS(MOD(dbms_random.random,100))) as PROCESSO
from backlog_cdc

select * from bill_fmt_opt

select * from all_tables where table_name like '%BILL%'

select BILL_FMT_OPT from cmf where account_no in select account_no from customer_id_acct_map where external_id = '899995279331'


select * from gvt_contas_contafacil

select processo, count(1) from GVT_CONTAS_CONTAFACIL group by processo order by 1


 SELECT DBMS_RANDOM.RANDOM FROM DUAL;
 
SELECT (1+ABS(MOD(dbms_random.random,100))) as processo
FROM DUAL;
 
 SELECT 1+1 FROM DUAL;

SELECT 
   CASE credit_limit WHEN 100 THEN 'Low'
   WHEN 5000 THEN 'High'
   ELSE 'Medium' END
   FROM dual;