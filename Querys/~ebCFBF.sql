-- 999983149056 - 147824320 
-- 999981494768 - 147828229 
-- 999980002651 - 147828225 
-- 999981494348 - 147828228 


select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_BILL_FILES order by 3 desc

select * from GVT_FBB_BILL_INVOICE where bill_ref_no in (147824320,147828229,147828225,147828228)

select * from GVT_FBB_BILL_INVOICE where bill_ref_no in (147828227,147823982,147828231)

select * from GVT_FEBRABAN_ACCOUNTS where external_id in ('999983149056','999981494768','999980002651','999981494348')