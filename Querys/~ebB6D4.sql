select * from cmf_balance where bill_ref_no in (156980925,156982507)

select * from gvt_fbb_bill_invoice where bill_ref_no in (156980925,156982507)

select * from GVT_FEBRABAN_ACCOUNTS where account_no in (4007437,7362750)

select * from all_tables where table_name like '%FEBRABAN%' 

select * from GVT_FEBRABAN_BILL_FILES where filename in (select file_name from gvt_fbb_bill_invoice where bill_ref_no in (156980925,156982507));