select file_name from gvt_febraban_bill_invoice where bill_ref_no in (173588340,173588339,173588339,173588338)

select CREATION_DATE, filename, NO_BYTES from GVT_FEBRABAN_BILL_FILES where filename in (select file_name from gvt_febraban_bill_invoice where bill_ref_no in (173588340,173588339,173588339,173588338))

select * from all_tables where table_name like '%FEBRABAN%'

select b.account_no, B.BILL_REF_NO, f.CREATION_DATE, f.filename, f.NO_BYTES
  from gvt_febraban_bill_invoice b,
       GVT_FEBRABAN_BILL_FILES f
 where B.FILE_NAME = F.FILENAME
   and b.bill_ref_no in (173588340,173588339,173588339,173588338)
   
 select * from cmf_balance where bill_ref_no in (173588340,173588339,173588339,173588338)
   
 select * from gvt_febraban_accounts

