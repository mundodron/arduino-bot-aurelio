select 'INSERT INTO ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD (external_id) values (''' || map.external_id || ''');' from customer_id_acct_map map
where map.external_id in ('777777693878')
and MAP.INACTIVE_DATE is null
and NOT EXISTS (select 1 from ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD where external_id = map.external_id);
 
select 'commit;' from dual;


select * from ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD where external_id = '777777693878'


select * from 