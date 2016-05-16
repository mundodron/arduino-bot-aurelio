select * from all_tables where table_name like '%FEBRABAN%'  

select * from GVT_FEBRABAN_PONTA_B_ARBOR_bk where EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR)

select * from GVT_FEBRABAN_PONTA_B_ARBOR where row_id = '1-9DCX4A'