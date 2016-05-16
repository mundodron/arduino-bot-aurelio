select C.EXTERNAL_ID,
       A.ACCOUNT_NO,
       A.BILL_REF_NO,
       A.FILE_NAME,
       B.CREATION_DATE,
       B.NO_BYTES,
       C.VERSION_FEED,
       A.FORMAT_STATUS
  from GVT_FBB_BILL_INVOICE A,
       GVT_FEBRABAN_BILL_FILES B,
       GVT_FEBRABAN_ACCOUNTS C
 where 1 = 1
   --and a.bill_ref_no in (147824320,147828229,147828225,147828228,147828227,147823982,147828231)
   and C.EXTERNAL_ID = ('999979730581')
   and A.ACCOUNT_NO = C.ACCOUNT_NO
   and A.FILE_NAME = B.FILENAME
 order by 5 desc;
 
 select * from all_tables where table_name like '%FEBRABAN%' 
 
 select * from customer_id_acct_map where external_id = '999979730581'
 
 select * from GVT_FEBRABAN_ACCOUNTS where external_id = '999979730581'
 
 select * from 