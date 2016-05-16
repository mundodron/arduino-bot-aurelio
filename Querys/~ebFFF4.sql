-- Senhores, 
-- Somente 2 account_no, ambos na CT1, estão sem No_Bill.

-- Conforme a query:

select c.account_no, c.no_bill, c.remark 
from GVT_DETALHAMENTO_CICLO gdc,
     cmf c
where gdc.DATA_PROCESSO >= to_Date ('29/06/2015','dd/mm/rrrr')
and gdc.gvt_mode='CICLO'
AND gdc.ANOTATION='CONTA IGNORADA PELO BIP'
AND gdc.ACCOUNT_CATEGORY=9
and gdc.account_no = c.account_no
and not exists (select 1 from cmf c2 where c2.parent_id = c.parent_id and c2.no_bill=1)
;
