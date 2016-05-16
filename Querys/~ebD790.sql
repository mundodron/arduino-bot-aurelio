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
   -- and a.bill_ref_no in (147824320,147828229,147828225,147828228,147828227,147823982,147828231)
   and C.EXTERNAL_ID in ('999979696307')
   --and C.ACCOUNT_NO = 3847517
 order by 4 desc;
 
 
 select * from GVT_FEBRABAN_PONTA_B_ARBOR where emf_ext_id = 'SGO-301KFQ6RL-012'
 
                                                              'RJO-30S1A8KD-9592-30S1A8KF','SGO-301D8K81U-9592-301D8K81T','SGO-30S1488F-9592-30S1488H'

 
 select external_id 
   from CUSTOMER_ID_EQUIP_MAP
  where external_id_type != 6
    and inactive_date is null
    AND is_current        = 1
    
 select * from GVT_FEBRABAN_RECURSOS


