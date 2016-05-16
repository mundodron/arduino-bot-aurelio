select * from all_tables where table_name like '%PRODUCT_VELOCITY%' 


MI_PRODUCT_VELOCITY


create index MI_PRODUCT_VELOCITY_idx1 on MI_PRODUCT_VELOCITY(END_DT,TRACKING_ID, TRACKING_ID_SERV);