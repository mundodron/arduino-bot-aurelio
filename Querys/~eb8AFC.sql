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
   and a.bill_ref_no = 272793716 -- in (147824320,147828229,147828225,147828228,147828227,147823982,147828231)
   -- and C.EXTERNAL_ID in ('999979696307')
   and C.ACCOUNT_NO = 3203638
 order by 4 desc;


select * from bill_invoice where Account_No=4273196 order by Prep_Date desc;

select * from customer_id_acct_map where account_no = 4273196

select * from gvt_log_cmf where account_no = 9126292

