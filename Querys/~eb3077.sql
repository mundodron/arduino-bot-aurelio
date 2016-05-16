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
   --and a.bill_ref_no in (238656445)
   and C.EXTERNAL_ID in ('999980674767')
   -- and C.ACCOUNT_NO = 3847517
 order by 4 desc;

select * from gvt_febraban_accounts where external_id = '999982276721'

select * from gvt_febraban_bill_invoice where account_no = 4848361

select * from all_tables where table_name like '%FEB%'

select * from GVT_FEBRABAN_CATEGORIA where upper(DESCRIPTION_FEBRABAN) like '%UNIDOS%'

select * from GVT_FEBRABAN_RECURSOS

select * from GVT_FEBRABAN_PONTA_B_ARBOR