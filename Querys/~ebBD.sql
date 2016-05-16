select C.EXTERNAL_ID,
       A.ACCOUNT_NO,
       A.BILL_REF_NO,
       B.CREATION_DATE,
       A.FILE_NAME,
       B.NO_BYTES,
       C.VERSION_FEED,
       A.FORMAT_STATUS
  from (select ACCOUNT_NO, BILL_REF_NO, FILE_NAME, FORMAT_STATUS from GVT_FBB_BILL_INVOICE
        union all
        select ACCOUNT_NO, BILL_REF_NO, FILE_NAME, FORMAT_STATUS from GVT_FEBRABAN_BILL_INVOICE) A,
       GVT_FEBRABAN_BILL_FILES B,
       GVT_FEBRABAN_ACCOUNTS C
 where A.ACCOUNT_NO = C.ACCOUNT_NO
   and A.FILE_NAME = B.FILENAME
   -- and a.bill_ref_no in (258840751)
   -- and C.EXTERNAL_ID in ('999979696307')
   -- and C.ACCOUNT_NO = 3847517
 order by 4 desc;

select * from bill_invoice where bill_ref_no = '258840751'

select * from gvt_febraban_accounts where account_no = 3203638

select * from GVT_FEBRABAN_BILL_INVOICE where account_no = 3203638



