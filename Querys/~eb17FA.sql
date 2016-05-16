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
   and C.EXTERNAL_ID in ('999980674767')
   and A.BILL_REF_NO = 226326306
 order by 4 desc;

select * from gvt_febraban_ponta_b_arbor where emf_ext_id = 'SGO-301D8K81U-9592-301D8K81T'


select * from ARBORGVT_BILLING.GVT_AVULSO_FATURACD



INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
select account_no, bill_ref_no from bill_invoice where account_no = 8561141 and bill_ref_no in (225339503,231924505,238526355);

INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
select account_no, bill_ref_no from bill_invoice where account_no = 8680090 and bill_ref_no in (225338358,231923546,238525306);

INSERT INTO ARBORGVT_BILLING.GVT_AVULSO_FATURACD (account_no, bill_ref_no) 
select account_no, bill_ref_no from bill_invoice where account_no = 2348130 and bill_ref_no in (225329709,225335946,231915308,231916349,238518508,238522145);

commit;