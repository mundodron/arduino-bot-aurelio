select * from gvt_febraban_bill_invoice where bill_ref_no = 150819712

select * from cmf_balance where bill_ref_no in (150241907,147634114)

select * from gvt_febraban_bill_invoice


777777746383    150644848
999985074903    150644832
999980014348    150644831
999983162696    150574902
999985077366    150644847


select * from ARBORGVT_BILLING.GVT_CONTAFACIL_ARQUIVOS

select * from GVT_CONTA_INTERNET where account_no in (select account_no from customer_id_acct_map where external_id in ('999985077366','999983162696','999980014348'))
and trunc(data_processamento) > to_date('01/06/2013','dd/mm/yyyy')


select * from all_tables where table_name like '%CDC%' 