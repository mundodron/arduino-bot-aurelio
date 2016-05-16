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
 where ACCOUNT_NO in (3857503,3857518,3857503,3858364,7374426,4463548)
   and trunc(DATA_PROCESSAMENTO) = trunc(sysdate)

BILL_REF_NO in (150644848)

select * from all_tables where table_name like '% %' 

select * from cmf_balance where account_no in (3857503,7374426,4463548,3858364,3857518)

select account_no from customer_id_acct_map where external_id in ('999982298387') --'777777727495'

select * from all_tables where table_name like '%FEBRABAN%'

select * from GVT_FEBRABAN_BILL_INVOICE where bill_ref_no = 153848153

select * from gvt_febraban_accounts where external_id in (999999234617,999983149056,999980501190)


select * from CONTAFACIL_CORP

select * 
  from GVT_CONTA_INTERNET
 where ACCOUNT_NO =  2856019 --,3857518,3857503,7374426,4463548)
   and trunc(DATA_PROCESSAMENTO) > (sysdate - 90)

select * from cmf_balance where bill_ref_no = 152225726



GVT_SP_ARQ_CONTA_DETALHADA

select * from all_tables where table_name like '%CDC%' 

select NOME_ARQUIVO from GVT_CONTAFACIL_ARQUIVOS

select * from customer_id_acct_map where external_id = '999983038332'

select * from gvt_conta_internet where account_no = 2856019
   and trunc(DATA_PROCESSAMENTO) > (sysdate - 90) order by 4

update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Agosto/4/2013Agosto777777775034_250.cdc', BILL_REF_NO = 152225726, external_id = 777777775034, existe_fatura = 1 where ACCOUNT_NO = 2856019 and trunc(DATA_PROCESSAMENTO) = to_date('27/07/2013','dd/mm/yyyy');




update GVT_CONTA_INTERNET set NOME_ARQUIVO = 'Junho/2/2013Junho999983038332_250.cdc', BILL_REF_NO = 145382519, external_id = 777777775034, existe_fatura = 1 where ACCOUNT_NO = 4648009 and trunc(DATA_PROCESSAMENTO) = to_date('19/05/2013','dd/mm/yyyy');

commit;

update GVT_CONTA_INTERNET set EXTERNAL_ID = '999983038332', EXISTE_FATURA = '1' where ACCOUNT_NO = 4648009 and NOME_ARQUIVO is not null;

commit;


Obrigado!
----------------------------------------------------
