select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_PONTA_B_ARBOR_bk where EMF_EXT_ID = 'PAA-3019MSLYN-9699-3019MSLYP'


select * from GVT_FEBRABAN_PONTA_B_ARBOR_BK where EMF_EXT_ID not in (select EMF_EXT_ID from GVT_FEBRABAN_PONTA_B_ARBOR )