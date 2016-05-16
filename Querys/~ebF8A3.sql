select * from det_fatura_cd


-- INC1004858  - 999979673962
-- INC1004848  - 999979701971

-- INC992939   - 777777693878

'999979701971','999979701971','777777693878' 

select * from all_tables where table_name like '%CD%'

select * from GVT_DET_FATURAMENTO_CD where external_id in ('999979701971','999979701971','777777693878')


select 'INSERT INTO ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD (external_id) values (''' || map.external_id || ''');' from customer_id_acct_map map
where map.external_id in ('999979701971','999979701971','777777693878')
--and MAP.INACTIVE_DATE is null
and NOT EXISTS (select 1 from ARBORGVT_BILLING.GVT_DET_FATURAMENTO_CD where external_id = map.external_id);


select * from customer_id_acct_map where external_id in ('999979701971','999979701971','777777693878')