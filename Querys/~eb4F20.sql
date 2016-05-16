select C.EXTERNAL_ID,
       A.ACCOUNT_NO,
       A.BILL_REF_NO,
       B.CREATION_DATE,
       A.FILE_NAME,
       trunc(B.NO_BYTES /1024 /1024) ||' MB' MB,
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
   and a.bill_ref_no in (238656445)
   and C.EXTERNAL_ID in ('999982276721')
   --and C.ACCOUNT_NO = 4848361
   and B.NO_BYTES = '9901052'
 order by 4 desc;
 
 
 select count(1), B.DISPLAY_VALUE, C.BILL_DISP_METH
   from cmf C,
        bill_disp_meth_values b
 where c.BILL_DISP_METH = B.BILL_DISP_METH
   and B.LANGUAGE_CODE = 2
    group by B.DISPLAY_VALUE, C.BILL_DISP_METH
   
  
  update cmf set BILL_DISP_METH = 2 where account_no in (  
  select D.ACCOUNT_NO
   from cmf C,
        bill_disp_meth_values b,
        GVT_DET_FATURAMENTO_CD a,
        customer_id_acct_map d
 where c.BILL_DISP_METH = B.BILL_DISP_METH
   and A.EXTERNAL_ID = D.EXTERNAL_ID
   and C.ACCOUNT_NO = D.ACCOUNT_NO
   and B.LANGUAGE_CODE = 2
   and D.INACTIVE_DATE is null)
 

   
       
   
   select * from bill_disp_meth_values
   
   select * from GVT_DET_FATURAMENTO_CD
   
   
   
select * from 'VTA-30JS0702','VTA-30S0UIWH','GJA-30S16ESL','GJA-30VCGS8I','PNG-30XLGOTH','SGO-301D8K81U','SGO-30S1488F','SGO-301KE6YBN','PNG-30JS06ZI-9698','VTA-30JS070L-9698','GJA-30VCGS8I-9699-30VCGS8K','SGO-301KE6YBN-9699-301KE79LL','SGO-301KFJ27G-012','SGO-301KFJ272','RJO-30S1A8KD','RJO-301KFP9VV','RJO-301KFP9W9-012','RJO-30LB35DG','RJO-30LB35DG','RJO-30LB35DG','RJO-30LB35DG-012-30LB35DU','RJO-301KE6YA3-9699-301KE6YAT','RJO-301KE6YA3','RJO-30RS33CG','SGO-301KFQ6R7','SGO-301KFQ6R7','SGO-301KFQ6RL-012','SGO-301KFQ6RL-012'