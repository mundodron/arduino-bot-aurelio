select 'INSERT INTO ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD (external_id) values (''' || map.external_id || ''');' from customer_id_acct_map map
where map.external_id in ('777777697922','999979673948','999979673949','999979673955','999979673956','999979673962','999979673963','999979673965','999979673966','999979673967','999979673969','999979673971','999979673974','999979673952','999979673954','999979673951','999979673970','999979673973')
and MAP.INACTIVE_DATE is null
and NOT EXISTS (select 1 from ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD where external_id = map.external_id);
 
select 'commit;' from dual;

select * from GVT_DET_FATURAMENTO_CD where external_id in ('999997013112','777777771377');