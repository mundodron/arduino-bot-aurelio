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
   and C.EXTERNAL_ID in ('999979737229')
   and A.ACCOUNT_NO = C.ACCOUNT_NO
   and A.FILE_NAME = B.FILENAME
 order by 5 desc;
 
 
 
  GVT_FEBRABAN_ACCOUNTS - onde fica registrado o version_feed (2:velho 3:novo)
  version_feed = 2 é gravado na tabela GVT_FBB_BILL_INVOICE
  version_feed = 3 é gravado na tabela GVT_FEBRABAN_BILL_INVOICE
