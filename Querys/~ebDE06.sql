-- 999983149056 - 147824320 
-- 999981494768 - 147828229 
-- 999980002651 - 147828225 
-- 999981494348 - 147828228 

select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_ACCOUNTS where external_id = '999983149056'

select * from GVT_FEBRABAN_BILL_FILES

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no = 147828228

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no in (147828227,147823982,147828231)