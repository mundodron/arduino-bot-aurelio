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
   --and a.bill_ref_no in (147824320,147828229,147828225,147828228,147828227,147823982,147828231)
   --and C.EXTERNAL_ID in ('999979696307')
   and c.account_no = 8560080
   and A.BILL_REF_NO = 242658308
 order by 4 desc;



select * from COBILLING.remessa_recebidos where operadora = 'TIM'



select * from all_tables where upper(table_name) like '%REMESSA%'

select * from COBILLING.REMESSA_RECEBIDOS