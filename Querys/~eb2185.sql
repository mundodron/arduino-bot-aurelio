777777746383    150644848
999985074903    150644832
999980014348    150644831
999983162696    150574902
999985077366    150644847

select * 
  from GVT_CONTA_INTERNET A,
       CONTAFACIL_CORP B
where A.ACCOUNT_NO = B.ACCOUNT_NO
  and A.BILL_REF_NO = B.BILL_REF_NO
  and A.BILL_REF_NO in (150644848)
  
select * 
  from GVT_CONTA_INTERNET
 where ACCOUNT_NO =  3858364 --,3857518,3857503,7374426,4463548)
   and trunc(DATA_PROCESSAMENTO) > (sysdate - 90)

select * from cmf_balance where bill_ref_no = 152225726

BILL_REF_NO in (150644848)

select * from all_tables where table_name like '% %' 

select * from cmf_balance where account_no in (3857503,7374426,4463548,3858364,3857518)

select account_no from customer_id_acct_map where external_id in ('777777746383','999985074903','999980014348','999983162696','999985077366')

select * from all_tables where table_name like '%FEBRABAN%'

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no = 153848153

select * from gvt_febraban_accounts where external_id = 999999234617

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no = 153848153