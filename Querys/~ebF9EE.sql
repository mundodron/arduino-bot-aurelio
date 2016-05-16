-- FEBRABAN
-- Clientes que possuem Febraban ativo e a data da ultima geração

select C.EXTERNAL_ID,
       max(B.CREATION_DATE),
       count(1) 
  from (select ACCOUNT_NO, BILL_REF_NO, FILE_NAME, FORMAT_STATUS, LANGUAGE_CODE from GVT_FBB_BILL_INVOICE
        union all
        select ACCOUNT_NO, BILL_REF_NO, FILE_NAME, FORMAT_STATUS, LANGUAGE_CODE from GVT_FEBRABAN_BILL_INVOICE) A,
       GVT_FEBRABAN_BILL_FILES B,
       GVT_FEBRABAN_ACCOUNTS C
 where A.ACCOUNT_NO = C.ACCOUNT_NO
   and A.FILE_NAME = B.FILENAME
   and A.FORMAT_STATUS = 2
   and A.LANGUAGE_CODE = 2
   and C.INACTIVE_DATE is null
 group by C.EXTERNAL_ID
 order by 3 desc
 
 
------------------------------------------------
-- Fatura em CD
-- Clientes que possuem Fatura em CD ativo e a data da ultima geração

select * from GVT_LOG_DET_FATURAMENTO_CD

select * from gvt_det_faturamento_cd

select * from gvt_febraban_accounts

select * from all_tables where table_name like '%FATURAMENTO_CD%'




select * from GVT_FEBRABAN_ACCOUNTS

select * from GVT_FBB_BILL_INVOICE