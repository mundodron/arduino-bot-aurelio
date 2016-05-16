select * from all_tables where table_name like '%FEBRABAN%'  

select * from GVT_FEBRABAN_PONTA_B_ARBOR where EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR_bk)