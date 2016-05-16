update usage_points set MOBILE_ZONE = 5 where point in ('5001234505','5001234510','5001234520','5001234515','415001234505','415001234510','5001234516')

select point from usage_points where POINT_CITY like '%TELETON%'

select * from usage_points where MOBILE_ZONE is not null

 select * from GVT_BILL_INVOICE_NFST where bill_ref_no = 284704319
 
 select * from customer_id_equip_map where SUBSCR_NO in (243364770, 236671238) and inactive_date is not null
 
 update customer_id_equip_map set IS_CURRENT = 1 where SUBSCR_NO in (4148609) and inactive_date is null
 
 select * from all_tables where table_name like '%VELO%'
 
 delete from GVT_PRODUCT_VELOCITY where END_DT is not null